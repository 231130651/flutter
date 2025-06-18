import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../provider/transaction_provider.dart';

class ReportTab extends StatelessWidget {
  const ReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final income = provider.income.toDouble();
    final expense = provider.expense.toDouble();
    final total = income + expense;
    final incomePercent = total == 0 ? 0 : (income / total) * 100;
    final expensePercent = total == 0 ? 0 : (expense / total) * 100;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Text(
            'Ringkasan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (total == 0)
            const Expanded(
              child: Center(child: Text('Belum ada data transaksi')),
            )
          else
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 0,
                  sections: [
                    PieChartSectionData(
                      value: income,
                      color: Colors.green,
                      title: '${incomePercent.toStringAsFixed(1)}%',
                      titleStyle: const TextStyle(fontSize: 12, color: Colors.black),
                      radius: 90,
                      titlePositionPercentageOffset: 1.2,
                    ),
                    PieChartSectionData(
                      value: expense,
                      color: Colors.red,
                      title: '${expensePercent.toStringAsFixed(1)}%',
                      titleStyle: const TextStyle(fontSize: 12, color: Colors.black),
                      radius: 90,
                      titlePositionPercentageOffset: 1.2,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [
                const Text('Pendapatan', style: TextStyle(color: Colors.green)),
                Text('Rp ${income.toStringAsFixed(0)}'),
              ]),
              Column(children: [
                const Text('Pengeluaran', style: TextStyle(color: Colors.red)),
                Text('Rp ${expense.toStringAsFixed(0)}'),
              ]),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
