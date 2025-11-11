import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/account.dart';
import '../models/transaction.dart';
import 'transactions_screen.dart';

/// Accounts List Screen - Displays all bank accounts
/// Loads account data from local JSON file and shows account cards
/// Only the first account has an active "View Transactions" button
class AccountsScreen extends StatefulWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  List<Account> accounts = [];
  Map<String, List<dynamic>> allTransactions = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }

  /// Load accounts and transactions from separate JSON files
  Future<void> loadAccounts() async {
    try {
      // Load accounts JSON
      final String accountsJson = await rootBundle.loadString('assets/accounts.json');
      final Map<String, dynamic> accountsData = json.decode(accountsJson);
      
      // Load transactions JSON
      final String transactionsJson = await rootBundle.loadString('assets/transactions.json');
      final Map<String, dynamic> transactionsData = json.decode(transactionsJson);
      
      // Store transactions by account type
      allTransactions = {
        'Chequing': List<dynamic>.from(transactionsData['transactions']['Chequing'] ?? []),
        'Savings': List<dynamic>.from(transactionsData['transactions']['Savings'] ?? []),
      };
      
      // Parse accounts and merge with transactions
      final List<dynamic> accountsList = accountsData['accounts'] as List<dynamic>;
      setState(() {
        accounts = accountsList.map((accountJson) {
          final Map<String, dynamic> accountData = accountJson as Map<String, dynamic>;
          
          // Determine which transactions to use
          List<Transaction> transactionsList = [];
          if (accountData['name'].toString().contains('Chequing')) {
            transactionsList = (allTransactions['Chequing'] ?? [])
                .map((t) => Transaction.fromJson(t as Map<String, dynamic>))
                .toList();
          } else if (accountData['name'].toString().contains('Savings')) {
            transactionsList = (allTransactions['Savings'] ?? [])
                .map((t) => Transaction.fromJson(t as Map<String, dynamic>))
                .toList();
          }
          
          // Create new Account with transactions from transactions.json
          return Account(
            id: accountData['id'] as String,
            name: accountData['name'] as String,
            accountNumber: accountData['accountNumber'] as String,
            balance: (accountData['balance'] as num).toDouble(),
            currency: accountData['currency'] as String,
            transactions: transactionsList,
          );
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading accounts: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom app bar with RBC-inspired colors
      appBar: AppBar(
        title: const Text(
          'My Accounts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF005DAA), // Royal blue
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        // Light background gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF005DAA),
              Color(0xFFF5F5F5),
            ],
            stops: [0.0, 0.3],
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                ),
              )
            : accounts.isEmpty
                ? const Center(
                    child: Text(
                      'No accounts found',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      final account = accounts[index];
                      // All accounts should have active transaction buttons
                      return _buildAccountCard(account, true);
                    },
                  ),
      ),
    );
  }

  /// Build a card widget for an individual account
  Widget _buildAccountCard(Account account, bool hasActiveButton) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFFAFAFA),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account name
              Text(
                account.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003D71),
                ),
              ),
              const SizedBox(height: 8),
              
              // Masked account number
              Row(
                children: [
                  const Icon(
                    Icons.credit_card,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    account.accountNumber,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Balance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Balance',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    account.getFormattedBalance(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: account.balance >= 0 
                          ? const Color(0xFF2E7D32) // Green for positive
                          : const Color(0xFFC62828), // Red for negative
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // View Transactions button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: hasActiveButton
                      ? () {
                          // Navigate to Transactions Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionsScreen(account: account),
                            ),
                          );
                        }
                      : null, // Disabled for non-first accounts
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasActiveButton 
                        ? const Color(0xFF005DAA) 
                        : Colors.grey[300],
                    foregroundColor: hasActiveButton 
                        ? Colors.white 
                        : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: hasActiveButton ? 2 : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 18,
                        color: hasActiveButton ? Colors.white : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        hasActiveButton 
                            ? 'View Transactions' 
                            : 'Transactions Unavailable',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
