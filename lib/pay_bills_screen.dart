import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'user_model.dart';
import 'dashboard_screen.dart';

class BillsPaymentPage extends StatefulWidget {
  const BillsPaymentPage({super.key, required this.user});
  final User user;

  @override
  State<BillsPaymentPage> createState() => _BillsPaymentPageState();
}

class _BillsPaymentPageState extends State<BillsPaymentPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 400;

    return CupertinoPageScaffold(
      child: Stack(
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
          
          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 20 : 30,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with back button
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
                        'Bills Payment',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 26 : 30,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Subtitle
                  Text(
                    'Select a biller to pay',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: const Color(0xFF7F8C8D),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Billers List
                  Expanded(
                    child: _buildBillerList(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillerList(BuildContext context) {
    final List<Map<String, dynamic>> billers = [
      {
        "name": "Pelco",
        "icon": CupertinoIcons.bolt_fill,
        "color": Color(0xFFFFA000),
      },
      {
        "name": "Balibago Water Works",
        "icon": CupertinoIcons.drop_fill,
        "color": Color(0xFF00ACC1),
      },
      {
        "name": "Converge",
        "icon": CupertinoIcons.wifi,
        "color": Color(0xFF7B1FA2),
      },
      {
        "name": "PLDT",
        "icon": CupertinoIcons.phone_fill,
        "color": Color(0xFFE53935),
      },
      {
        "name": "Maynilad",
        "icon": CupertinoIcons.drop_fill,
        "color": Color(0xFF039BE5),
      },
      {
        "name": "Smart",
        "icon": CupertinoIcons.antenna_radiowaves_left_right,
        "color": Color(0xFF43A047),
      },
      {
        "name": "Globe",
        "icon": CupertinoIcons.globe,
        "color": Color(0xFFFB8C00),
      },
    ];

    return ListView.separated(
      itemCount: billers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final biller = billers[index];
        return CupertinoButton(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(14),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => BillPaymentFormPage(
                  biller: biller['name'],
                  user: widget.user,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: biller['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    biller['icon'],
                    color: biller['color'],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    biller['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ),
                const Icon(
                  CupertinoIcons.chevron_forward,
                  size: 18,
                  color: Color(0xFF95A5A6),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BillPaymentFormPage extends StatefulWidget {
  final String biller;
  final User user;

  const BillPaymentFormPage({
    super.key,
    required this.biller,
    required this.user,
  });

  @override
  _BillPaymentFormPageState createState() => _BillPaymentFormPageState();
}

class _BillPaymentFormPageState extends State<BillPaymentFormPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  bool _isLoading = false;
  String? _message;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _amountController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  Future<void> _submitPayment() async {
    final amount = _amountController.text.trim();
    final accNum = _accountNumberController.text.trim();

    if (amount.isEmpty || accNum.isEmpty) {
      _setMessage("Please fill in all fields.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://phpconfig.fun/atmapp/pay_bills.php'),
        body: {
          'user_id': widget.user.id.toString(),
          'biller': widget.biller,
          'amount': amount,
          'account_number': accNum,
        },
      );
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          _setMessage("You have successfully paid ₱$amount for ${widget.biller}", success: true);
        } else {
          _setMessage("Payment failed: ${jsonResponse['message']}");
        }
      } else {
        _setMessage("Server error: ${response.statusCode}");
      }
    } catch (e) {
      _setMessage("Error: ${e.toString()}");
    }

    setState(() => _isLoading = false);
  }

  void _setMessage(String message, {bool success = false}) {
    setState(() {
      _message = message;
      _isSuccess = success;
    });

    if (success) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => ReceiptPage(
              biller: widget.biller,
              amount: _amountController.text,
              accountNumber: _accountNumberController.text,
              user: widget.user,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    return CupertinoPageScaffold(
      child: Stack(
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
          
          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 20 : 30,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with back button
                  Row(
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          CupertinoIcons.back,
                          color: Color(0xFF3366FF),
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'Pay ${widget.biller}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 24 : 28,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Form content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
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
                          
                          // Account Number Field
                          _buildTextField(
                            controller: _accountNumberController,
                            label: 'Account Number',
                            placeholder: 'Enter account number',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),
                          
                          // Amount Field
                          _buildTextField(
                            controller: _amountController,
                            label: 'Amount (₱)',
                            placeholder: 'Enter amount',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 40),
                          
                          // Pay Button
                          _isLoading
                              ? const CupertinoActivityIndicator()
                              : CupertinoButton.filled(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  borderRadius: BorderRadius.circular(12),
                                  onPressed: _submitPayment,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(CupertinoIcons.creditcard_fill, size: 20),
                                      SizedBox(width: 10),
                                      Text(
                                        'Pay Now',
                                        style: TextStyle(fontSize: 16),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
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
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          padding: const EdgeInsets.all(16),
          keyboardType: keyboardType,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          style: const TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 16,
          ),
          placeholderStyle: const TextStyle(
            color: Color(0xFF95A5A6),
          ),
        ),
      ],
    );
  }
}
class ReceiptPage extends StatelessWidget {
  final String biller;
  final String amount;
  final String accountNumber;
  final User user;

  const ReceiptPage({
    super.key,
    required this.biller,
    required this.amount,
    required this.accountNumber,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final double amountValue = double.tryParse(amount) ?? 0;
    final double totalAmount = amountValue + 15;
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
                                colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
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
                            'PAYMENT CONFIRMED',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
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
                                _buildReceiptItem('Biller', biller),
                                _buildReceiptItem('Account', accountNumber),
                                _buildReceiptItem('Amount', '₱$amount'),
                                _buildReceiptItem('Fee', '₱15.00'),
                                const SizedBox(height: 15),
                                Container(
                                  height: 1,
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                                const SizedBox(height: 15),
                                _buildReceiptItem('TOTAL', '₱${totalAmount.toStringAsFixed(2)}', isTotal: true),
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
                                  side: const BorderSide(color: Color(0xFF3366FF),
                                ),
                              ),),
                              onPressed: () {
                                Navigator.popUntil(context, (route) => route.isFirst);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DashboardScreen(user: user),
                                  ),
                                );
                              },
                              child: const Text(
                                'DONE',
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