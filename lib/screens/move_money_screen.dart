import 'package:flutter/material.dart';

/// Move Money Screen - Transfer money between accounts
class MoveMoneyScreen extends StatefulWidget {
  const MoveMoneyScreen({Key? key}) : super(key: key);

  @override
  State<MoveMoneyScreen> createState() => _MoveMoneyScreenState();
}

class _MoveMoneyScreenState extends State<MoveMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  
  String? _fromAccount;
  String? _toAccount;
  
  final List<Map<String, String>> _accounts = [
    {'id': 'chequing', 'name': 'Chequing (4019)', 'balance': '\$3,649.86'},
    {'id': 'savings', 'name': 'Savings (9012)', 'balance': '\$15,750.00'},
    {'id': 'credit', 'name': 'Credit Card (3456)', 'balance': '-\$842.75'},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 28),
            SizedBox(width: 12),
            Text('Transfer Successful'),
          ],
        ),
        content: Text(
          'Successfully transferred \$${_amountController.text}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Clear form
              setState(() {
                _fromAccount = null;
                _toAccount = null;
                _amountController.clear();
              });
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _handleTransfer() {
    if (_formKey.currentState!.validate()) {
      _showSuccessDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Move Money',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF005DAA),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF005DAA),
                Color(0xFFF5F5F5),
              ],
              stops: [0.0, 0.2],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transfer card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Transfer Between Accounts',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003D71),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Move money instantly between your RBC accounts',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // From Account
                          const Text(
                            'From Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF003D71),
                            ),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: _fromAccount,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.account_balance, color: Color(0xFF005DAA)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                            ),
                            hint: const Text('Select account'),
                            isExpanded: true,
                            items: _accounts.map((account) {
                              return DropdownMenuItem(
                                value: account['id'],
                                child: Text(
                                  '${account['name']!} - ${account['balance']!}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => _fromAccount = value);
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an account';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          // Swap icon
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFC600).withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.swap_vert,
                                color: Color(0xFF005DAA),
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // To Account
                          const Text(
                            'To Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF003D71),
                            ),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: _toAccount,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.account_balance_wallet, color: Color(0xFF005DAA)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                            ),
                            hint: const Text('Select account'),
                            isExpanded: true,
                            items: _accounts.map((account) {
                              return DropdownMenuItem(
                                value: account['id'],
                                child: Text(
                                  '${account['name']!} - ${account['balance']!}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => _toAccount = value);
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an account';
                              }
                              if (value == _fromAccount) {
                                return 'Please select a different account';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          
                          // Amount
                          const Text(
                            'Amount',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF003D71),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 16, top: 14),
                                child: Text(
                                  '\$',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF005DAA),
                                  ),
                                ),
                              ),
                              hintText: '0.00',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an amount';
                              }
                              final amount = double.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return 'Please enter a valid amount';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          
                          // Transfer button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _handleTransfer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFC600),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                'Transfer Money',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF005DAA).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF005DAA).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFF005DAA),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Transfers between RBC accounts are instant and free',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 120), // Extra spacing for bottom navigation
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
