import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_lab1_authen/controllers/Product_service.dart';
import 'package:flutter_lab1_authen/models/Product_model.dart';
import 'package:flutter_lab1_authen/provider/user_provider.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<productModel> _products = [];
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _timer;

  void _fetchAllProducts() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;
    try {
      final allProduct = await ProductService()
          .getProducts(context, accessToken!, refreshToken!);
      setState(() {
        _products = allProduct;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Set loading to false
        _errorMessage = e.toString(); // Set error message
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllProducts();
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      _fetchAllProducts(); // Refetch every 2 seconds
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('Home'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/post_page');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: Logout,
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text('This is ProductPage'),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator()) // Loading indicator
                  : _errorMessage != null
                      ? Center(
                          child: Text('Error: $_errorMessage')) // Error message
                      : ListView.builder(
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return ListTile(
                              title: Text(product.productName),
                              subtitle: Text(
                                "Type: ${product.productType} | Price: ${product.price} | Unit: ${product.unit}",
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/edit_page',
                                        arguments: product,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      // Implement delete logic here
                                      _deleteProduct(
                                          product.id, product.productName);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // Example delete method
  void _deleteProduct(String productId, String productName) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;
    // Show confirmation dialog
    bool confirmDelete = await _showConfirmationDialog(productName);

    if (confirmDelete) {
      try {
        await ProductService()
            .deleteProduct(context, productId, accessToken!, refreshToken!);
        _fetchAllProducts(); // Refetch products after deletion
      } catch (e) {
        print('Error deleting product: $e');
      }
    }
  }

  Future<bool> _showConfirmationDialog(String productName) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this $productName?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false if cancelled
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true if confirmed
              },
            ),
          ],
        );
      },
    ).then((value) => value ?? false); // Ensure a boolean is returned
  }

  void Logout() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.onLogout();
    Navigator.pushNamed(context, '/login');
  }
}
