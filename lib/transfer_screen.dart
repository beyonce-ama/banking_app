import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'user_model.dart';
import 'package:hive/hive.dart';
import 'dashboard_screen.dart';

class TransferPage extends StatefulWidget {
  final User user;
  const TransferPage({super.key, required this.user});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Box savedAccountsBox = Hive.box('savedAccounts');
    final List<Map<String, String>> savedAccounts = savedAccountsBox.values
        .cast<Map>()
        .map((e) => Map<String, String>.from(e))
        .toList();

    final List<String> partnerBanks = [
      "China Bank", "Landbank", "PNB", "Union Bank", 
      "BPI", "RCBC"
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    center: FractionalOffset.center,
                    startAngle: 0.0,
                    endAngle: _animation.value * 6.28319, // 2*pi
                    colors: const [
                      Color(0xFFF0F7FF),
                      Color(0xFFE1F0FF),
                      Color(0xFFD6E9FF),
                      Color(0xFFE1F0FF),
                      Color(0xFFF0F7FF),
                    ],
                    stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                  ),
                ),
              );
            },
          ),
          
          // Floating bubbles
          Positioned(
            top: -50,
            right: -30,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3366FF).withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3366FF).withOpacity(0.03),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                   Row(
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          CupertinoIcons.back,
                          color: Color(0xFF3366FF),
                          size: 28,
                        ),
                        onPressed: () => Navigator.push(context,
                         MaterialPageRoute(
                            builder: (_) => DashboardScreen(user: widget.user ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'Transfer Funds',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Saved Accounts Section
                  const Text(
                    'Saved Accounts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A2C50),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (savedAccounts.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Center(
                        child: Text(
                          'No saved accounts yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: savedAccounts.map((acc) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransferFormPage(
                                    bankOrAccount: acc['bank']!,
                                    accountId: widget.user.id.toString(),
                                    initialName: acc['name']!,
                                    initialAccount: acc['account']!,
                                    user: widget.user,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 180,
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    acc['name']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF1A2C50),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "${acc['bank']} • ${acc['account']}",
                                    style: const TextStyle(
                                      color: Color(0xFF6B7B8F),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  const SizedBox(height: 30),

                  // Partner Banks Section
                  const Text(
                    'Partner Banks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A2C50),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Column(
                    children: partnerBanks.map((bank) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        color: Colors.white.withOpacity(0.7),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransferFormPage(
                                  bankOrAccount: bank,
                                  accountId: widget.user.id.toString(),
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3366FF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.account_balance,
                              color: Color(0xFF3366FF),
                            ),
                          ),
                          title: Text(
                            bank,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A2C50),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFF6B7B8F),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransferFormPage extends StatefulWidget {
  final String bankOrAccount;
  final String accountId;
  final String? initialName;
  final String? initialAccount;
  final User user;

  const TransferFormPage({
    super.key,
    required this.bankOrAccount,
    required this.accountId,
    required this.user,
    this.initialName,
    this.initialAccount,
  });

  @override
  TransferFormPageState createState() => TransferFormPageState();
}

class TransferFormPageState extends State<TransferFormPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _recipientNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _message;
  bool _isSuccess = false;
  final String _transferApiUrl = "https://phpconfig.fun/atmapp/transfer.php";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _recipientNameController.text = widget.initialName ?? '';
    _accountNumberController.text = widget.initialAccount ?? '';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _submitTransfer() async {
    final name = _recipientNameController.text.trim();
    final account = _accountNumberController.text.trim();
    final amount = _amountController.text.trim();
    final bank = widget.bankOrAccount;
    final accountId = widget.accountId;

    if (name.isEmpty || account.isEmpty || amount.isEmpty) {
      _showMessage("Please fill out all fields.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(_transferApiUrl),
        body: {
          "accountId": accountId,
          "recipientBankName": bank,
          "recipientAccountNumber": account,
          "amount": amount,
        },
      );

      final json = jsonDecode(response.body);
      if (json.containsKey('success')) {
        _showMessage(json['success'], success: true);
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TransferReceiptPage(
                recipientName: name,
                bank: bank,
                accountNumber: account,
                amount: amount,
                user: widget.user,
              ),
            ),
          );
        });
      } else if (json.containsKey('error')) {
        _showMessage(json['error']); 
      } else {
        _showMessage('Transfer failed.');  
      }
    } catch (e) {
      _showMessage("Failed to connect to server.");
    }
  }

  Future<void> _saveAccountToHive() async {
    final name = _recipientNameController.text.trim();
    final bank = widget.bankOrAccount;
    final account = _accountNumberController.text.trim();

    if (name.isEmpty || account.isEmpty) {
      _showMessage("Please fill out recipient name and account number.");
      return;
    }

    final box = await Hive.openBox('savedAccounts');
    bool accountExists = false;
    for (var savedAccount in box.values) {
      if (savedAccount['account'] == account && savedAccount['bank'] == bank) {
        accountExists = true;
        break;
      }
    }

    if (accountExists) {
      _showMessage("This account is already saved.");
      return;
    }

    await box.add({
      'name': name,
      'bank': bank,
      'account': account,
    });

    _showMessage("Account saved successfully!", success: true);
  }

  void _showMessage(String message, {bool success = false}) {
    setState(() {
      _message = message;
      _isSuccess = success;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() => _message = null);
    });
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Animated background
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: SweepGradient(
                  center: FractionalOffset.center,
                  startAngle: 0.0,
                  endAngle: _animation.value * 6.28319,
                  colors: const [
                    Color(0xFFF0F7FF),
                    Color(0xFFE1F0FF),
                    Color(0xFFD6E9FF),
                    Color(0xFFE1F0FF),
                    Color(0xFFF0F7FF),
                  ],
                  stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                ),
              ),
            );
          },
        ),
        
        // Floating bubbles
        Positioned(
          top: -50,
          right: -30,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF3366FF).withOpacity(0.05),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          left: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF3366FF).withOpacity(0.03),
            ),
          ),
        ),

        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF3366FF)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Transfer to ${widget.bankOrAccount}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A2C50),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Message
                if (_message != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isSuccess 
                          ? Colors.green.withOpacity(0.9)
                          : Colors.red.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isSuccess ? Icons.check_circle : Icons.error,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _message!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Form
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildCupertinoTextField(
                        controller: _recipientNameController,
                        label: 'Recipient Name',
                        placeholder: 'Enter full name',
                      ),
                      const SizedBox(height: 20),
                      _buildCupertinoTextField(
                        controller: _accountNumberController,
                        label: 'Account Number',
                        placeholder: 'Enter account number',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildCupertinoTextField(
                        controller: _amountController,
                        label: 'Amount',
                        placeholder: 'Enter amount in PHP',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 30),

                      // Modified layout with buttons side by side
                      Row(
                        children: [
                          Expanded(
                            child: CupertinoButton.filled(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              borderRadius: BorderRadius.circular(12),
                              onPressed: _saveAccountToHive,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(CupertinoIcons.bookmark, size: 20),
                                  SizedBox(width: 8),
                                  Text('Save Account'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CupertinoButton(
                              color: const Color(0xFF3366FF),
                              borderRadius: BorderRadius.circular(12),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              onPressed: _submitTransfer,
                              child: const Text(
                                'Transfer Now',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
  }
Widget _buildCupertinoTextField({
  required TextEditingController controller,
  required String label,
  required String placeholder,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A2C50),
        ),
      ),
      const SizedBox(height: 6),
      CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        keyboardType: keyboardType,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ],
  );
}

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
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final double parsedAmount = double.tryParse(amount) ?? 0.0;
    final double fee = 15.0;
    final double total = parsedAmount + fee;
    final String formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(DateTime.now());

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF0F7FF), Color(0xFFE1F0FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Neumorphic Card
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F7FF),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          // Darker shadow
                          BoxShadow(
                            color: Colors.blueGrey.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(10, 10),
                          ),
                          // Lighter shadow
                          BoxShadow(
                            color: Colors.white.withOpacity(0.7),
                            blurRadius: 30,
                            offset: const Offset(-10, -10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Animated Checkmark
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color.fromARGB(255, 65, 255, 51), Color.fromARGB(255, 102, 255, 107)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          
                          const SizedBox(height: 25),
                          const Text(
                            'TRANSFER COMPLETED',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 55, 247, 37),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Color(0xFF6B7B8F),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 30),
                          
                          // Receipt Details
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _buildReceiptItem('Recipient', recipientName),
                                _buildReceiptItem('Bank', bank),
                                _buildReceiptItem('Account', accountNumber),
                                _buildReceiptItem('Amount', '₱${parsedAmount.toStringAsFixed(2)}'),
                                _buildReceiptItem('Fee', '₱${fee.toStringAsFixed(2)}'),
                                const SizedBox(height: 15),
                                Container(
                                  height: 1,
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                                const SizedBox(height: 15),
                                _buildReceiptItem('TOTAL', '₱${total.toStringAsFixed(2)}', isTotal: true),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF3366FF),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: const BorderSide(color: Color(0xFF3366FF)),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DashboardScreen(user: user),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                'BACK TO DASHBOARD',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptItem(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? const Color(0xFF3366FF) : const Color(0xFF6B7B8F),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isTotal ? const Color(0xFF3366FF) : const Color(0xFF1A2C50),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}