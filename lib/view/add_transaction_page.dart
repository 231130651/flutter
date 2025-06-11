import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:math_expressions/math_expressions.dart';
import '../model/transaction_model.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  String selectedType = 'Pemasukan';
  String amount = '';
  String selectedCategory = 'Gaji';
  final noteController = TextEditingController();

  final List<String> categories = ['Gaji', 'Makanan', 'Transportasi', 'Lainnya'];

  void appendAmount(String value) {
    setState(() {
      amount += value;
    });
  }

  void backspace() {
    setState(() {
      if (amount.isNotEmpty) {
        amount = amount.substring(0, amount.length - 1);
      }
    });
  }

  Future<void> saveTransaction() async {
    if (amount.isEmpty) return;
    try {
      final parser = ShuntingYardParser();
      final exp = parser.parse(amount.replaceAll(',', '.'));
      final contextModel = ContextModel();
      final result = exp.evaluate(EvaluationType.REAL, contextModel);
      final finalAmount = result.toDouble();

      final transaction = TransactionModel(
        title: noteController.text.isEmpty ? selectedCategory : noteController.text,
        amount: selectedType == 'Pemasukan' ? finalAmount.toInt() : -finalAmount.toInt(),
        date: DateTime.now(),
      );

      final box = await Hive.openBox<TransactionModel>('transactions');
      await box.add(transaction);

      final saldoBox = await Hive.openBox<num>('saldo');
      final currentSaldo = saldoBox.get('main', defaultValue: 0) ?? 0;
      await saldoBox.put('main', currentSaldo + finalAmount);

      if (!mounted) return;
      setState(() {
        amount = '';
        noteController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi berhasil disimpan')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format tidak valid')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
        backgroundColor: const Color(0xFFD84040),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            const SizedBox(height: 10),
            ToggleButtons(
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: const Color(0xFFD84040),
              color: Colors.black87,
              isSelected: ['Pemasukan', 'Pengeluaran']
                  .map((e) => e == selectedType)
                  .toList(),
              onPressed: (index) {
                setState(() {
                  selectedType = ['Pemasukan', 'Pengeluaran'][index];
                  selectedCategory = selectedType == 'Pemasukan' ? 'Gaji' : 'Makanan';
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Pemasukan'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Pengeluaran'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              amount.isEmpty ? 'Rp' : 'Rp $amount',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: (selectedType == 'Pemasukan'
                        ? ['Gaji']
                        : categories.where((cat) => cat != 'Gaji').toList())
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(child: buildNumpad()),
          ],
        ),
      ),
    );
  }

  Widget buildNumpad() {
    final buttons = [
      '1', '2', '3', '⌫',
      '4', '5', '6', '-',
      '7', '8', '9', '+',
      '', '0', ',', 'Selesai',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        itemCount: buttons.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (context, index) {
          final label = buttons[index];
          if (label.isEmpty) return const SizedBox.shrink();

          // final isAction = ['⌫', '+', '-', 'Selesai'].contains(label);
          final isRed = ['⌫', '+', '-', 'Selesai'].contains(label);

          return ElevatedButton(
            onPressed: () async {
              if (label == '⌫') {
                backspace();
              } else if (label == 'Selesai') {
                await saveTransaction();
              } else {
                appendAmount(label);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isRed
                  ? const Color(0xFFA31D1D)
                  : const Color(0xFFECDCBF),
              foregroundColor: isRed ? Colors.white : Colors.black,
              textStyle: const TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: label == '⌫'
                ? const Icon(Icons.backspace_outlined)
                : Text(label),
          );
        },
      ),
    );
  }
}
