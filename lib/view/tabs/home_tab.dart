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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              Text(income.toStringAsFixed(2), style: TextStyle(color: textColor)),
            ]),
            Column(children: [
              const Text('Pengeluaran', style: TextStyle(color: Colors.red)),
              Text(expense.toStringAsFixed(2), style: TextStyle(color: textColor)),
            ]),
            Column(children: [
              const Text('Total'),
              Text(total.toStringAsFixed(2), style: TextStyle(color: textColor)),
            ]),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: transactions.isEmpty
              ? const Center(child: Text('Tidak ada data'))
              : ListView.separated(
                  itemCount: transactions.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final rawDate = DateTime.tryParse(tx.date);
                    final formattedDate = rawDate != null
                        ? DateFormat('dd-MM-yyyy').format(rawDate)
                        : '-';

                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Kategori: ${tx.category} (${tx.type})",
                              style: TextStyle(color: textColor, overflow: TextOverflow.ellipsis),
                            ),
                          ),
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
                              Text(
                                tx.amount.toString(),
                                style: TextStyle(
                                  color: tx.type == 'income' ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          "Tanggal: $formattedDate",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
