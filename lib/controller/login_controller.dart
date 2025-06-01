import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/user_model.dart';

class LoginController extends ChangeNotifier {
  String _errorText = '';
  String get errorText => _errorText;

  void handleLogin(String email, String password) {
    final box = Hive.box<UserModel>('users');

    final trimmedEmail = email.trim().toLowerCase();
    final trimmedPassword = password.trim();

    final isValid = box.values.any(
      (user) =>
          user.email.trim().toLowerCase() == trimmedEmail &&
          user.password.trim() == trimmedPassword,
    );

    if (isValid) {
      _errorText = 'Login berhasil';
    } else {
      _errorText = 'Email atau password salah.';
    }

    notifyListeners();
  }
}
