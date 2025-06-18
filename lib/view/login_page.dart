import 'package:flutter/material.dart';
import '../controller/database_handler.dart';
import 'dashboard_screen.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final DatabaseHandler dbHandler = DatabaseHandler();
  bool isPasswordVisible = false;

  void _showSnackBar(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success
            ? Colors.green
            : Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _handleLogin() async {
    final username = userCtrl.text.trim();
    final password = passCtrl.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnackBar("Username dan password wajib diisi!");
      return;
    }

    final user = await dbHandler.loginUser(username, password);
    if (user != null && mounted) {
      _showSnackBar("Login berhasil!", success: true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      _showSnackBar("Username atau password salah.");
    }

    userCtrl.clear();
    passCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final hintColor = Theme.of(context).hintColor;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Color(0xFFF8F2DE),
                          backgroundImage:
                              const AssetImage('assets/money.png'),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'BaBa Wallet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text("LOGIN",
                    style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 2,
                        color: textColor)),
                const SizedBox(height: 25),
                _inputField("USERNAME", Icons.account_circle_outlined,
                    userCtrl, textColor, hintColor),
                _passwordField(textColor, hintColor),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primary,
                      foregroundColor:
                          Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: _handleLogin,
                    child: const Text("LOGIN",
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Tidak punya akun?", style: TextStyle(color: textColor)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterPage()),
                          );
                        },
                        child: const Text("Register"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, IconData icon,
      TextEditingController controller, Color? textColor, Color? hintColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 12, color: hintColor)),
        TextField(
          controller: controller,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: hintColor),
            hintStyle: TextStyle(color: hintColor),
            border: const UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _passwordField(Color? textColor, Color? hintColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("PASSWORD", style: TextStyle(fontSize: 12, color: hintColor)),
        TextField(
          controller: passCtrl,
          obscureText: !isPasswordVisible,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline, color: hintColor),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: hintColor,
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
            hintStyle: TextStyle(color: hintColor),
            border: const UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
