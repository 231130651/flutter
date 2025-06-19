import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../provider/transaction_provider.dart';
import '../../controller/database_handler.dart';
import '../../model/transaction_model.dart';
import '../widgets/transaction_form.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  void _openTransactionForm(BuildContext context, [Transaction? tx]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => TransactionForm(existingTransaction: tx),
    );
  }

  void _confirmDelete(BuildContext context, int id) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Transaksi'),
        content: const Text('Yakin ingin menghapus transaksi ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (shouldDelete == true) {
      await DatabaseHandler().deleteTransaction(id);
      if (context.mounted) {
        Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final transactions = provider.transactions;
    final income = provider.income.toDouble();
    final expense = provider.expense.toDouble();
    final total = income - expense;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: [
              const Text('Pendapatan', style: TextStyle(color: Colors.green)),
              Text("Rp. ${income.toStringAsFixed(2)}", style: TextStyle(color: textColor)),
            ]),
            Column(children: [
              const Text('Pengeluaran', style: TextStyle(color: Colors.red)),
              Text("Rp. ${expense.toStringAsFixed(2)}", style: TextStyle(color: textColor)),
            ]),
            Column(children: [
              const Text('Total'),
              Text("Rp. ${total.toStringAsFixed(2)}", style: TextStyle(color: textColor)),
            ]),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: transactions.isEmpty ? const Center(child: Text('Tidak ada data')) : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                final rawDate = DateTime.tryParse(tx.date);
                final formattedDate = rawDate != null
                    ? DateFormat('dd-MM-yyyy').format(rawDate)
                    : '-';
    return Column(
      children: [
        if (index == 0) const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Kategori: ${tx.category} (${tx.type})", style: TextStyle(color: textColor)),
                    Text("Tanggal: $formattedDate", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(tx.description, style: TextStyle(color: textColor)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Rp. ${tx.amount.toString()}",
                    style: TextStyle(
                      color: tx.type == 'income' ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () => _openTransactionForm(context, tx),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                        onPressed: tx.id != null
                            ? () => _confirmDelete(context, tx.id!)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
    }),
    )],
  );
  }
}
