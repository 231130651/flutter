// lib/services/hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../model/user_model.dart';

class HiveService {
  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    await Hive.openBox<UserModel>('users');
  }

  static Box<UserModel> getUserBox() => Hive.box<UserModel>('users');

  static void addUser(UserModel user) {
    getUserBox().add(user);
  }

  static List<UserModel> getAllUsers() {
    return getUserBox().values.toList();
  }

  static bool userExists(String email, String password) {
    return getUserBox().values.any(
      (user) => user.email == email && user.password == password,
    );
  }
}
