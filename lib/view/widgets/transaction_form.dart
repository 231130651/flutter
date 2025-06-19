import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controller/database_handler.dart';
import '../../../model/transaction_model.dart';
import '../../../provider/transaction_provider.dart';

class TransactionForm extends StatefulWidget {
  final Transaction? existingTransaction;

  const TransactionForm({super.key, this.existingTransaction});

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
  void initState() {
    super.initState();
    if (widget.existingTransaction != null) {
      final tx = widget.existingTransaction!;
      _amountController.text = tx.amount.abs().toString();
      _descriptionController.text = tx.description;
      _category = tx.category;
      _type = tx.type;
    }
  }

  @override
Widget build(BuildContext context) {
  final textColor = Theme.of(context).colorScheme.onSurface;
  final hintColor = Theme.of(context).hintColor;

  return SafeArea(
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
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
              style: TextStyle(fontSize: 14, color: textColor),
              decoration: InputDecoration(
                labelText: 'Total',
                labelStyle: TextStyle(fontSize: 14, color: hintColor),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              style: TextStyle(fontSize: 14, color: textColor),
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                labelStyle: TextStyle(fontSize: 14, color: hintColor),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _category,
              isExpanded: true,
              dropdownColor: Theme.of(context).colorScheme.surface,
              style: TextStyle(fontSize: 14, color: textColor),
              items: ['Cash', 'Debit', 'Kredit']
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat, style: TextStyle(color: textColor)),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _category = value!),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Radio<String>(
                      value: 'income',
                      groupValue: _type,
                      onChanged: (value) => setState(() => _type = value!),
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'Pemasukan',
                      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Radio<String>(
                      value: 'expense',
                      groupValue: _type,
                      onChanged: (value) => setState(() => _type = value!),
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'Pengeluaran',
                      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(_amountController.text);
                if (amount == null || amount <= 0) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Masukkan jumlah yang valid')),
                  );
                  return;
                }

                final tx = Transaction(
                  id: widget.existingTransaction?.id,
                  type: _type,
                  description: _descriptionController.text.trim(),
                  amount: _type == 'income' ? amount : -amount,
                  category: _category,
                  date: widget.existingTransaction?.date ?? DateTime.now().toIso8601String(),
                );

                if (tx.id != null) {
                  await db.updateTransaction(tx.toMap());
                } else {
                  await db.insertTransaction(tx.toMap());
                }

                await Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
                if (mounted) Navigator.pop(context, {'refresh': true});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                textStyle: const TextStyle(fontSize: 14),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(widget.existingTransaction != null ? 'Update' : 'Simpan'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}
}