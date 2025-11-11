import 'transaction.dart';

/// Model class representing a bank account
class Account {
  final String id;
  final String name;
  final String accountNumber;
  final double balance;
  final String currency;
  final List<Transaction> transactions;

  Account({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.balance,
    required this.currency,
    required this.transactions,
  });

  /// Factory constructor to create an Account from JSON
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      name: json['name'] as String,
      accountNumber: json['accountNumber'] as String,
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String,
      transactions: (json['transactions'] as List<dynamic>)
          .map((transactionJson) => Transaction.fromJson(transactionJson as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convert Account to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'accountNumber': accountNumber,
      'balance': balance,
      'currency': currency,
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }

  /// Get formatted balance with currency symbol
  String getFormattedBalance() {
    String symbol = currency == 'CAD' ? '\$' : currency;
    return '$symbol${balance.toStringAsFixed(2)}';
  }
}
