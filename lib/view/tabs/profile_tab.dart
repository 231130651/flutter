import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/database_handler.dart';
import '../../main.dart';
import '../../controller/login_controller.dart';
import '../../provider/transaction_provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final db = DatabaseHandler();
  String email = '';
  String selectedTheme = 'light';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final users = await db.getAllUsers();
    final lastUser = users.isNotEmpty ? users.last : null;
    final theme = await db.getThemeMode();
    setState(() {
      email = lastUser != null ? lastUser['username'] : 'Pengguna';
      selectedTheme = theme;
    });
  }

  Future<void> _changeTheme(String mode) async {
    await db.setThemeMode(mode);
    themeNotifier.value = mode == 'dark' ? ThemeMode.dark : ThemeMode.light;
    setState(() => selectedTheme = mode);
  }

  Future<void> _confirmAndResetData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Reset"),
        content: const Text("Yakin ingin menghapus semua data?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Ya"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await db.deleteAllTransactions();
      if (!mounted) return;
      Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil direset")),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          const CircleAvatar(
            radius: 60,
            backgroundColor: Color(0xFFFFF3D3),
            backgroundImage: AssetImage('assets/money.png'),
          ),
          const SizedBox(height: 24),
          Text(email, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tema', style: TextStyle(fontSize: 16)),
              DropdownButton<String>(
                value: selectedTheme,
                items: ['light', 'dark']
                    .map((mode) => DropdownMenuItem(
                          value: mode,
                          child: Text(mode == 'light' ? 'Terang' : 'Gelap'),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) _changeTheme(value);
                },
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _confirmAndResetData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Reset Data'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<LoginController>(context, listen: false).logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD84040),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
