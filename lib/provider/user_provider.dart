import 'package:flutter/material.dart';
import 'package:flutter_lab1_authen/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  String? _user;
  String? _accessToken;
  String? _refreshToken;

  String? get user => _user;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  void saveUser(User UserModel) {
    _user = UserModel.user.userName;
    _accessToken = UserModel.accessToken;
    _refreshToken = UserModel.refreshToken;
    notifyListeners();
  }

  void onLogout() {
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  void updateAccessToken(String token) {
    _accessToken = token;
    notifyListeners();
  }
}
