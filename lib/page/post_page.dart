import 'package:flutter/material.dart';
import 'package:flutter_lab1_authen/controllers/Product_service.dart';
import 'package:flutter_lab1_authen/controllers/auth_service.dart';
import 'package:flutter_lab1_authen/provider/user_provider.dart';
import 'package:provider/provider.dart';

class post_product extends StatefulWidget {
  @override
  _post_productState createState() => _post_productState();
}

class _post_productState extends State<post_product> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productTypeController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitController = TextEditingController();

  void addProduct() async {
    if (_formKey.currentState!.validate()) {
      final productName = _productNameController.text;
      final productType = _productTypeController.text;
      final priceString = _priceController.text;
      final unit = _unitController.text;
      // Convert price to int
      final int? price = int.tryParse(priceString);

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String? accessToken = userProvider.accessToken;
      String? refreshToken = userProvider.refreshToken;

      String? newToken =
          await AuthService().refreshToken(context, refreshToken!);
      if (newToken != null) {
        userProvider.updateAccessToken(newToken);
        accessToken = newToken;
      } else {
        print('Failed to refresh token.');
      }

      try {
        await ProductService().addProduct(context, productName, productType,
            price!, unit, accessToken!, refreshToken);
        _showDialog('Add Product Successful');

        // Clear text fields after successful submission
        _productNameController.clear();
        _productTypeController.clear();
        _priceController.clear();
        _unitController.clear();
        Navigator.pushReplacementNamed(context, '/admin_page');
      } catch (e) {
        print('Error adding product: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product')),
        );
      }
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('System')),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Center(child: Text('OK')),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _productTypeController,
                decoration: InputDecoration(
                  labelText: 'Product Type',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _unitController,
                decoration: InputDecoration(
                  labelText: 'Unit',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    addProduct();
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
