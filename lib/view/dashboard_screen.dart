import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controller/database_handler.dart';
import '../main.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openTransactionForm() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const TransactionForm(),
    );

    if (result != null && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _ReportTab(),
      _HomeTab(),
      _ProfileTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('BaBa Wallet'),
        centerTitle: true,
        backgroundColor: const Color(0xFFD84040),
        foregroundColor: Colors.white,
      ),
      body: pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _openTransactionForm,
              backgroundColor: const Color(0xFFD84040),
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFD84040),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Laporan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  final db = DatabaseHandler();
  double income = 0;
  double expense = 0;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = income + expense;
    final incomePercent = total == 0 ? 0 : (income / total) * 100;
    final expensePercent = total == 0 ? 0 : (expense / total) * 100;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Text('Ringkasan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
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

class _ReportTab extends StatefulWidget {
  @override
  State<_ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends State<_ReportTab> {
  final db = DatabaseHandler();
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final txs = await db.getTransactions();
    setState(() => transactions = txs);
  }

  @override
  Widget build(BuildContext context) {
    double income = 0;
    double expense = 0;

    for (var tx in transactions) {
      final amount = (tx['amount'] as num).toDouble();
      if (tx['type'] == 'income') {
        income += amount;
      } else {
        expense += amount.abs();
      }
    }

    double total = income - expense;

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
              : ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return ListTile(
                      title: Text(tx['description'] ?? ''),
                      subtitle: Text("Kategori: ${tx['category']} (${tx['type']})"),
                      trailing: Text(
                        tx['amount'].toString(),
                        style: TextStyle(
                          color: tx['type'] == 'income' ? Colors.blue : Colors.red,
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
class _ProfileTab extends StatefulWidget {
  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
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
              const Text('Mode Tampilan', style: TextStyle(fontSize: 16)),
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD84040),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

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
    return Padding(
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
                final amount = double.tryParse(_amountController.text) ?? 0.0;
                final data = {
                  'amount': _type == 'income' ? amount : -amount,
                  'description': _descriptionController.text,
                  'category': _category,
                  'type': _type,
                  'date': DateTime.now().toIso8601String(),
                };
                await db.insertTransaction(data);
                if (mounted) Navigator.pop(context, data);
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
    );
  }
}
