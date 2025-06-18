import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controller/database_handler.dart';

class ReportTab extends StatefulWidget {
  const ReportTab({super.key});

  @override
  State<ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends State<ReportTab> {
  final db = DatabaseHandler();
  double income = 0;
  double expense = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final transactions = await db.getTransactions();
    double inc = 0;
    double exp = 0;

    for (var tx in transactions) {
      final amount = (tx['amount'] as num).toDouble();
      if (tx['type'] == 'income') {
        inc += amount;
      } else {
        exp += amount.abs();
      }
    }

    setState(() {
      income = inc;
      expense = exp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = income + expense;
    final incomePercent = total == 0 ? 0 : (income / total) * 100;
    final expensePercent = total == 0 ? 0 : (expense / total) * 100;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                            titleStyle: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                            radius: 90,
                            titlePositionPercentageOffset: 1.2,
                          ),
                          PieChartSectionData(
                            value: expense,
                            color: Colors.red,
                            title: '${expensePercent.toStringAsFixed(1)}%',
                            titleStyle: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
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
                      Text('Rp. ${income.toStringAsFixed(0)}'),
                    ]),
                    Column(children: [
                      const Text('Pengeluaran', style: TextStyle(color: Colors.red)),
                      Text('Rp. ${expense.toStringAsFixed(0)}'),
                    ]),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }
}
