import 'package:flutter/material.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
        backgroundColor: const Color(0xFFD84040),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Form Tambah Transaksi',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
