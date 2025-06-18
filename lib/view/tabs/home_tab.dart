import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../provider/transaction_provider.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final transactions = provider.transactions;
    final income = provider.income.toDouble();
    final expense = provider.expense.toDouble();
    final total = income - expense;

    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: [
              const Text('Pendapatan', style: TextStyle(color: Colors.blue)),
              Text(income.toStringAsFixed(2), style: const TextStyle(color: Colors.blue)),
            ]),
            Column(children: [
              const Text('Pengeluaran', style: TextStyle(color: Colors.red)),
              Text(expense.toStringAsFixed(2), style: const TextStyle(color: Colors.red)),
            ]),
            Column(children: [
              const Text('Total'),
              Text(total.toStringAsFixed(2)),
            ]),
          ],
        ),
        const SizedBox(height: 20),
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
                      title: Text(tx.description),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Kategori: ${tx.category} (${tx.type})"),
                          Text("Tanggal: $formattedDate", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      trailing: Text(
                        tx.amount.toString(),
                        style: TextStyle(
                          color: tx.type == 'income' ? Colors.blue : Colors.red,
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
