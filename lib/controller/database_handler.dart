import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  static final DatabaseHandler _instance = DatabaseHandler._internal();
  factory DatabaseHandler() => _instance;
  DatabaseHandler._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'keuangan.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        description TEXT,
        date TEXT NOT NULL,
        category TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    await db.insert('settings', {'key': 'theme_mode', 'value': 'light'});
  }

  Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction);
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;
    return await db.query('transactions', orderBy: 'date DESC');
  }

  Future<int> updateTransaction(Map<String, dynamic> transaction) async {
    final db = await database;
    return await db.update(
      'transactions',
      transaction,
      where: 'id = ?',
      whereArgs: [transaction['id']],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> registerUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<String> getThemeMode() async {
    final db = await database;
    final result = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: ['theme_mode'],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first['value'] as String;
    } else {
      await db.insert('settings', {'key': 'theme_mode', 'value': 'light'});
      return 'light';
    }
  }

  Future<void> setThemeMode(String mode) async {
    final db = await database;
    await db.update(
      'settings',
      {'value': mode},
      where: 'key = ?',
      whereArgs: ['theme_mode'],
    );
  }

  Future<void> deleteAllTransactions() async {
    final db = await database;
    await db.delete('transactions');
  }
}
