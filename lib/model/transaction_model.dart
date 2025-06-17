class Transaction {
  final int? id;
  final String type;
  final String description;
  final int amount;
  final String category;

  Transaction({
    this.id,
    required this.type,
    required this.description,
    required this.amount,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'amount': amount,
      'category': category,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      type: map['type'],
      description: map['description'],
      amount: map['amount'],
      category: map['category'],
    );
  }
}
