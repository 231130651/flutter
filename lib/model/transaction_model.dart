import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1) // GANTI dari 0 ke 1 untuk hindari konflik
class TransactionModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  int amount;

  @HiveField(2)
  DateTime date;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.date,
  });
}
