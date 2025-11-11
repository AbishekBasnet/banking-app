/// Model class representing a bank transaction
class Transaction {
  final String id;
  final String date;
  final String description;
  final double amount;

  Transaction({
    required this.id,
    required this.date,
    required this.description,
    required this.amount,
  });

  /// Factory constructor to create a Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      date: json['date'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  /// Convert Transaction to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'description': description,
      'amount': amount,
    };
  }

  /// Check if transaction is a credit (positive amount)
  bool isCredit() => amount > 0;

  /// Check if transaction is a debit (negative amount)
  bool isDebit() => amount < 0;
}
