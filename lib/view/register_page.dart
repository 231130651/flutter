import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/register_controller.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmVisible = false;

  void _showSnackBar(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _handleRegister() async {
    final username = userCtrl.text.trim();
    final pass = passCtrl.text;
    final confirm = confirmCtrl.text;
    if (username.isEmpty || pass.isEmpty || confirm.isEmpty) {
      _showSnackBar("Semua kolom wajib diisi!");
      return;
    }
    if (pass != confirm) {
      _showSnackBar("Password tidak cocok!");
      return;
    }
    final success = await Provider.of<RegisterController>(context, listen: false)
        .register(username, pass);
    if (!mounted) return;
    if (success) {
      _showSnackBar("Registrasi berhasil!", success: true);
      Navigator.pop(context);
    } else {
      _showSnackBar("username sudah terdaftar.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final hintColor = Theme.of(context).hintColor;

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
                        const CircleAvatar(
                          radius: 60,
                          backgroundColor: Color(0xFFF8F2DE),
                          backgroundImage: AssetImage('assets/money.png'),
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
                const Text("REGISTER", style: TextStyle(fontSize: 18, letterSpacing: 2)),
                const SizedBox(height: 25),
                CustomInput(
                  label: "USERNAME",
                  icon: Icons.account_circle_outlined,
                  controller: userCtrl,
                ),
                CustomInput(
                  label: "PASSWORD",
                  icon: Icons.lock_outline,
                  controller: passCtrl,
                  obscureText: !isPasswordVisible,
                  suffix: IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: hintColor,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
                CustomInput(
                  label: "KONFIRMASI PASSWORD",
                  icon: Icons.lock,
                  controller: confirmCtrl,
                  obscureText: !isConfirmVisible,
                  suffix: IconButton(
                    icon: Icon(
                      isConfirmVisible ? Icons.visibility : Icons.visibility_off,
                      color: hintColor,
                    ),
                    onPressed: () {
                      setState(() {
                        isConfirmVisible = !isConfirmVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  label: "REGISTER",
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Punya Akun? "),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Login"),
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
}
