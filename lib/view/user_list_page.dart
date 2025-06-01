import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/user_model.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<UserModel>('users');
    final users = box.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("User List")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(user.email),
            subtitle: Text("Password: ${user.password}"),
          );
        },
      ),
    );
  }
}
