import 'package:flutter/material.dart';
import '../controller/database_handler.dart'; // sesuaikan jika berbeda

class RegisterController extends ChangeNotifier {
  final DatabaseHandler _db = DatabaseHandler();

  Future<bool> register(String username, String password) async {
    final existingUsers = await _db.getAllUsers();
    final isExist = existingUsers.any((user) => user['username'] == username);

    if (isExist) return false;

    await _db.registerUser({
      'username': username.trim(),
      'password': password.trim(),
    });

    return true;
  }
}
