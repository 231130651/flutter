import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controller/database_handler.dart';
import '../../../model/transaction_model.dart';
import '../../../provider/transaction_provider.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _category = 'Cash';
  String _type = 'income';
  final db = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total',
                  labelStyle: TextStyle(fontSize: 14),
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  labelStyle: TextStyle(fontSize: 14),
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: _category,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                isExpanded: true,
                items: ['Cash', 'Debit', 'Kredit']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value!),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: const Text('Pemasukan', style: TextStyle(fontSize: 13)),
                      value: 'income',
                      groupValue: _type,
                      onChanged: (value) => setState(() => _type = value!),
                      activeColor: const Color(0xFFD84040),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: const Text('Pengeluaran', style: TextStyle(fontSize: 13)),
                      value: 'expense',
                      groupValue: _type,
                      onChanged: (value) => setState(() => _type = value!),
                      activeColor: const Color(0xFFD84040),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final amount = double.tryParse(_amountController.text);
                  if (amount == null || amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Masukkan jumlah yang valid')),
                    );
                    return;
                  }

                  final tx = Transaction(
                    type: _type,
                    description: _descriptionController.text.trim(),
                    amount: _type == 'income' ? amount : -amount,
                    category: _category,
                    date: DateTime.now().toIso8601String(),
                  );

                  await db.insertTransaction(tx.toMap());
                  await Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
                  if (mounted) Navigator.pop(context, {'refresh': true});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD84040),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 14),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Simpan'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
