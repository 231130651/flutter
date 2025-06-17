import 'package:flutter/material.dart';
import '../controller/database_handler.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();
  final DatabaseHandler dbHandler = DatabaseHandler();

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
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;
    final confirm = confirmCtrl.text;

    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      _showSnackBar("Semua field wajib diisi!");
      return;
    }

    if (pass != confirm) {
      _showSnackBar("Password Salah!");
      return;
    }

    final existingUsers = await dbHandler.getAllUsers();
    final exists = existingUsers.any((user) => user['username'] == email);

    if (exists) {
      _showSnackBar("Email sudah terdaftar!");
      return;
    }

    await dbHandler.registerUser({
      'username': email,
      'password': pass,
    });

    if (!mounted) return;
    _showSnackBar("Registrasi berhasil!", success: true);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                _inputField("E-MAIL", Icons.email_outlined, emailCtrl),
                _passwordField(),
                _confirmPasswordField(),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD84040),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: _handleRegister,
                    child: const Text("REGISTER", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
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

  Widget _inputField(String label, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            border: const UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("PASSWORD", style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        TextField(
          controller: passCtrl,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
            ),
            border: const UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _confirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("KONFIRMASI PASSWORD", style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        TextField(
          controller: confirmCtrl,
          obscureText: !isConfirmVisible,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(isConfirmVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => isConfirmVisible = !isConfirmVisible),
            ),
            border: const UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
