// lib/services/hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../model/user_model.dart';
import '../model/transaction_model.dart';

class HiveService {
  static Future<void> initHive() async {
    await Hive.initFlutter();

    // Daftarkan adapter
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(TransactionModelAdapter());

    // Buka box
    await Hive.openBox<UserModel>('users');
    await Hive.openBox<TransactionModel>('transactions');
    await Hive.openBox<int>('saldo');

    // Inisialisasi saldo jika belum ada
    final saldoBox = Hive.box<int>('saldo');
    if (!saldoBox.containsKey('main')) {
      await saldoBox.put('main', 0);
    }
  }

  // ---------- USER ----------
  static Box<UserModel> getUserBox() => Hive.box<UserModel>('users');

  static void addUser(UserModel user) {
    getUserBox().add(user);
  }

  static List<UserModel> getAllUsers() {
    return getUserBox().values.toList();
  }

  static bool userExists(String email, String password) {
    return getUserBox().values.any(
      (user) => user.email == email && user.password == password,
    );
  }

  // ---------- TRANSACTION ----------
  static Box<TransactionModel> getTransactionBox() =>
      Hive.box<TransactionModel>('transactions');

  static void addTransaction(TransactionModel tx) {
    getTransactionBox().add(tx);
  }

  static List<TransactionModel> getAllTransactions() {
    return getTransactionBox().values.toList();
  }

  // ---------- SALDO ----------
  static Box<int> getSaldoBox() => Hive.box<int>('saldo');

  static int getSaldo() => getSaldoBox().get('main', defaultValue: 0)!;

  static void updateSaldo(int value) {
    getSaldoBox().put('main', value);
  }
}
