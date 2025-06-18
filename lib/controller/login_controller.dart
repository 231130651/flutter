import 'package:flutter/material.dart';
import '../controller/database_handler.dart';

class LoginController extends ChangeNotifier {
  final DatabaseHandler _db = DatabaseHandler();

  String _errorText = '';
  String get errorText => _errorText;

  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _user;

  bool get isLoggedIn => _user != null;

  Future<bool> handleLogin(String username, String password) async {
    final result = await _db.loginUser(username.trim(), password.trim());

    if (result != null) {
      _user = result;
      _errorText = 'Login berhasil';
      notifyListeners();
      return true;
    } else {
      _user = null;
      _errorText = 'Username atau password salah.';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
