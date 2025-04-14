import 'dashboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'user_model.dart';
class TransferReceiptPage extends StatelessWidget {
  final String recipientName;
  final String bank;
  final String accountNumber;
  final String amount;
final User user;
  const TransferReceiptPage({
    super.key,
    required this.recipientName,
    required this.bank,
    required this.accountNumber,
    required this.amount,
    required this.user
  });

  @override
  Widget build(BuildContext context) {
    final double parsedAmount = double.tryParse(amount) ?? 0.0;
    final double fee = 15.0;
    final double total = parsedAmount + fee;

    final String formattedDate = DateFormat('MMMM d, y – h:mm a').format(DateTime.now());

    return CupertinoPageScaffold(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE1F5FE), Color(0xFFFFF3E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      CupertinoIcons.checkmark_seal_fill,
                      color: Color(0xFF4CAF50),
                      size: 90,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Transfer Complete',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF607D8B),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildInfoRow('Recipient', recipientName),
                    _buildInfoRow('Bank', bank),
                    _buildInfoRow('Account No.', accountNumber),
                    _buildInfoRow('Amount', '₱${parsedAmount.toStringAsFixed(2)}'),
                    _buildInfoRow('Transfer Fee', '₱${fee.toStringAsFixed(2)}'),
                    const Divider(height: 30, color: Color(0xFFB0BEC5)),
                    _buildInfoRow(
                      'Total Deducted',
                      '₱${total.toStringAsFixed(2)}',
                      isBold: true,
                      color: Color(0xFF0D47A1),
                    ),
                    const SizedBox(height: 40),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      color: const Color(0xFF4FC3F7),
                      borderRadius: BorderRadius.circular(30),
                      child: const Text(
                        'Done',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                     onPressed: () {
                      Navigator.pop(context); 
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => DashboardScreen(user: user), // Pass user or any other parameters required
                        ),
                      );
                    },

                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF607D8B),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: color ?? const Color(0xFF263238),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
