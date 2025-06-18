class Transaction {
  final int? id;
  final String type;
  final String description;
  final String date;
  final double amount;
  final String category;

  Transaction({
    this.id,
    required this.type,
    required this.description,
    required this.date,
    required this.amount,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'date': date,
      'amount': amount,
      'category': category,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      type: map['type'],
      description: map['description'],
      date: map['date'],
      amount: map['amount'],
      category: map['category'],
    );
  }
}
