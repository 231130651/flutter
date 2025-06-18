import 'package:flutter/material.dart';
import '../model/transaction_model.dart';
import '../controller/database_handler.dart';

class TransactionProvider with ChangeNotifier {
  final db = DatabaseHandler();

  List<Transaction> _transactions = [];
  double _income = 0;
  double _expense = 0;

  List<Transaction> get transactions => _transactions;
  double get income => _income;
  double get expense => _expense;

  Future<void> fetchTransactions() async {
    final data = await db.getTransactions();
    _transactions = data.map((map) => Transaction.fromMap(map)).toList();

    _income = 0;
    _expense = 0;

    for (var tx in _transactions) {
      if (tx.type == 'income') {
        _income += tx.amount;
      } else {
        _expense += tx.amount.abs();
      }
    }

    notifyListeners();
  }

  Future<void> addTransaction(Transaction tx) async {
    await db.insertTransaction(tx.toMap());
    await fetchTransactions();
  }

  Future<void> deleteAllTransactions() async {
    final db = await this.db.database;
    await db.delete('transactions');
    _transactions = [];
    _income = 0;
    _expense = 0;
    notifyListeners();
  }
}
