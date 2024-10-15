import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_lab1_authen/models/Product_model.dart';
import 'package:flutter_lab1_authen/controllers/auth_service.dart';
import 'package:flutter_lab1_authen/provider/user_provider.dart';
import 'package:flutter_lab1_authen/varible.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductService {
  Future<List<productModel>> getProducts(
      BuildContext context, String accessToken, String refreshToken) async {
    final response = await http.get(
      Uri.parse('$apiURL/api/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((product) => productModel.fromJson(product))
          .toList();
    } else if (response.statusCode == 403) {
      final newAccessToken =
          await AuthService().refreshToken(context, refreshToken);
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        return await getProducts(context, newAccessToken, refreshToken);
      } else {
        print('Failed to refresh token, logging out.');
        Logout(context);
        throw Exception('Failed to refresh token');
      }
    } else if (response.statusCode == 401) {
      print('Access denied, logging out.');
      Logout(context);
      throw Exception('Access denied');
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  Future<productModel> getproduct(BuildContext context, String id,
      String accessToken, String refreshToken) async {
    final response = await http.get(
      Uri.parse("$apiURL/api/product/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Product fetched successfully');
      return productModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 403) {
      final newAccessToken =
          await AuthService().refreshToken(context, refreshToken);
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        return await getproduct(context, id, newAccessToken, refreshToken);
      } else {
        print('Failed to refresh token, logging out.');
        Logout(context);
        throw Exception('Failed to refresh token');
      }
    } else if (response.statusCode == 401) {
      print('Access denied, logging out.');
      Logout(context);
      throw Exception('Access denied');
    } else {
      throw Exception('Failed to fetch product: ${response.statusCode}');
    }
  }

  Future<void> addProduct(
      BuildContext context,
      String productName,
      String productType,
      int price,
      String unit,
      String accessToken,
      String refreshToken) async {
    final response = await http.post(
      Uri.parse("$apiURL/api/product"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "product_name": productName,
        "product_type": productType,
        "price": price,
        "unit": unit
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('Product Post successfully');
    } else if (response.statusCode == 403) {
      final newAccessToken =
          await AuthService().refreshToken(context, refreshToken);
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        addProduct(context, productName, productType, price, unit,
            newAccessToken, refreshToken);
      } else {
        print('Failed to refresh token, logging out.');
        Logout(context);
        throw Exception('Failed to refresh token');
      }
    } else if (response.statusCode == 401) {
      Logout(context);
      print('logging out');
    }
  }

  Future<void> deleteProduct(BuildContext context, String id,
      String accessToken, String refreshToken) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? accessToken = userProvider.accessToken;
    String? refreshToken = userProvider.refreshToken;

    final response = await http.delete(
      Uri.parse('$apiURL/api/product/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    } else if (response.statusCode == 403) {
      final newAccessToken =
          await AuthService().refreshToken(context, refreshToken!);
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        deleteProduct(context, id, newAccessToken, refreshToken);
      } else {
        print('Failed to refresh token, logging out.');
        Logout(context);
        throw Exception('Failed to refresh token');
      }
    } else if (response.statusCode == 401) {
      Logout(context);
      print('logging out');
    }
  }

  Future<void> updateProduct(
      BuildContext context,
      String id,
      String productName,
      String productType,
      int price,
      String unit,
      String accessToken,
      String refreshToken) async {
    final response = await http.put(
      Uri.parse('$apiURL/api/product/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "product_name": productName,
        "product_type": productType,
        "price": price,
        "unit": unit
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('Product updated successfully');
    } else if (response.statusCode == 403) {
      final newAccessToken =
          await AuthService().refreshToken(context, refreshToken);
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        updateProduct(context, id, productName, productType, price, unit,
            newAccessToken, refreshToken);
      } else {
        print('Failed to refresh token, logging out.');
        Logout(context);
        throw Exception('Failed to refresh token');
      }
    } else if (response.statusCode == 401) {
      print('logging out');
      Logout(context);
    }
  }

  Future<void> Logout(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.onLogout();
    Navigator.pushNamed(context, '/login'); // Redirect to login or home page
  }
}
