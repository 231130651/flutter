import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/user_model.dart';

class RegisterController extends ChangeNotifier {
  bool register(String email, String password) {
    final box = Hive.box<UserModel>('users');
    final isExist = box.values.any((user) => user.email == email);

    if (isExist) return false;

    box.add(UserModel(email: email, password: password));
    return true;
  }
}
