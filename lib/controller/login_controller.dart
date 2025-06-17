import 'package:flutter/material.dart';
import '../controller/database_handler.dart'; // ganti sesuai path kalau perlu

class LoginController extends ChangeNotifier {
  final DatabaseHandler _db = DatabaseHandler();

  String _errorText = '';
  String get errorText => _errorText;

  Future<bool> handleLogin(String username, String password) async {
    final user = await _db.loginUser(username.trim(), password.trim());

    if (user != null) {
      _errorText = 'Login berhasil';
      notifyListeners();
      return true;
    } else {
      _errorText = 'Username atau password salah.';
      notifyListeners();
      return false;
    }
  }
}
