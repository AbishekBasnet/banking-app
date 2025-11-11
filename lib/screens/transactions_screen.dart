import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/account.dart';
import '../models/transaction.dart';

/// Transactions Screen - Displays transactions for a selected account
/// Shows transaction details with color-coded amounts (green for credits, red for debits)
class TransactionsScreen extends StatelessWidget {
  final Account account;

  const TransactionsScreen({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with account information
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transactions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Text(
              account.name,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF005DAA), // Royal blue
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        // Light background
        color: const Color(0xFFF5F5F5),
        child: Column(
          children: [
            // Account summary header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Color(0xFF005DAA),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    account.accountNumber,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    account.getFormattedBalance(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Current Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Transactions list
            Expanded(
              child: account.transactions.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No transactions found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: account.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = account.transactions[index];
                        return _buildTransactionCard(transaction);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build a card widget for an individual transaction
  Widget _buildTransactionCard(Transaction transaction) {
    // Format the date (e.g., "Feb 1, 2025")
    DateTime date = DateTime.parse(transaction.date);
    String formattedDate = DateFormat('MMM d, yyyy').format(date);
    
    // Determine if amount is positive (credit) or negative (debit)
    bool isCredit = transaction.isCredit();
    Color amountColor = isCredit 
        ? const Color(0xFF2E7D32) // Green for credits
        : const Color(0xFFC62828); // Red for debits
    
    // Format amount with currency symbol
    String formattedAmount = '\$${transaction.amount.abs().toStringAsFixed(2)}';
    String displayAmount = isCredit ? '+$formattedAmount' : '-$formattedAmount';

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        // Transaction icon
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isCredit 
                ? const Color(0xFFE8F5E9) // Light green background
                : const Color(0xFFFFEBEE), // Light red background
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            color: amountColor,
          ),
        ),
        // Transaction description and date
        title: Text(
          transaction.description,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF003D71),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        // Transaction amount
        trailing: Text(
          displayAmount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: amountColor,
          ),
        ),
      ),
    );
  }
}
