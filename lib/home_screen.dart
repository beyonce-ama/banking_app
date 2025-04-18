import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onFeatureTap;
  final User user;

  const HomeScreen({super.key, required this.user, required this.onFeatureTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class BankTransaction {
  final String type;
  final double amount;
  final String date;

  BankTransaction({
    required this.type,
    required this.amount,
    required this.date,
  });

  factory BankTransaction.fromJson(Map<String, dynamic> json) {
    return BankTransaction(
      type: json['Type'],
      amount: double.tryParse(json['Amount'].toString()) ?? 0.0,
      date: json['Date'],
    );
  }
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late double _currentBalance;
  bool _showBalance = true;
  bool _showCardNumber = true;
  List<BankTransaction> _transactions = [];
  bool _isLoadingTransactions = true;
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
    fetchTransactions();
    _currentBalance = widget.user.balance;
    fetchBalance();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchBalance() async {
    try {
      final response = await http.post(
        Uri.parse('https://phpconfig.fun/atmapp/get_balance.php'),
        body: {'accountId': widget.user.id.toString()},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final newBalance = double.tryParse(data['balance'].toString()) ?? 0.0;
          setState(() {
            _currentBalance = newBalance;
          });
        }
      }
    } catch (e) {
      print("Exception in fetchBalance: $e");
    }
  }

  Future<void> fetchTransactions() async {
    try {
      final response = await http.post(
        Uri.parse('https://phpconfig.fun/atmapp/transaction.php'),
        body: {'accountId': widget.user.id.toString()},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await fetchBalance();
        if (responseData['status'].toString() == 'success') {
          List<dynamic> data = responseData['data'];
          setState(() {
            _transactions = data.map((t) => BankTransaction.fromJson(t)).toList();
            _isLoadingTransactions = false;
          });
        } else {
          setState(() {
            _isLoadingTransactions = false;
          });
        }
      } else {
        setState(() {
          _isLoadingTransactions = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoadingTransactions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 400;
    final padding = isSmallScreen ? 24.0 : 40.0;

    String formatAccountNo(String accountNo) {
      return accountNo.replaceAllMapped(RegExp(r".{1,4}"), (match) => "${match.group(0)} ").trim();
    }

    return CupertinoPageScaffold(
      child: Stack(
        children: [
          // Animated background matching welcome screen
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
            ),),
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
            ), ),
          
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    
                    // App header with welcome message
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(
                            CupertinoIcons.person_fill,
                            color: const Color(0xFF3366FF),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Welcome, ${widget.user.name}",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 20 : 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A237E),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Balance card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Account Balance",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF546E7A),
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showBalance = !_showBalance;
                                  });
                                },
                                child: Icon(
                                  _showBalance
                                      ? CupertinoIcons.eye_fill
                                      : CupertinoIcons.eye_slash_fill,
                                  color: const Color(0xFF3366FF),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _showBalance
                                ? "₱${_currentBalance.toStringAsFixed(2)}"
                                : "••••••",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 28 : 32,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1A237E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Quick actions grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      childAspectRatio: 0.8,
                      children: [
                        FeatureCard(
                          icon: CupertinoIcons.arrow_up_arrow_down,
                          label: "Transfers",
                          onTap: () => widget.onFeatureTap.call(1),
                        ),
                        FeatureCard(
                          icon: CupertinoIcons.money_dollar,
                          label: "Pay Bills",
                          onTap: () => widget.onFeatureTap.call(2),
                        ),
                        FeatureCard(
                          icon: CupertinoIcons.creditcard,
                          label: "Cards",
                          onTap: () => widget.onFeatureTap.call(3),
                        ),
                        FeatureCard(
                          icon: CupertinoIcons.device_phone_portrait,
                          label: "Buy Load",
                          onTap: () {},
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Bank card design
                    Container(
                      width: double.infinity,
                      height: 180,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3366FF), Color(0xFF1A237E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3366FF).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.bankName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                _showCardNumber
                                    ? formatAccountNo(widget.user.accountNo)
                                    : "•••• •••• ••••",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showCardNumber = !_showCardNumber;
                                  });
                                },
                                child: const Icon(
                                  CupertinoIcons.eye_fill,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Exp: 12/24",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Transactions section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recent Transactions",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A237E),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_isLoadingTransactions)
                            const Center(
                              child: CupertinoActivityIndicator(
                                radius: 14,
                                color: Color(0xFF3366FF),
                              ),
                            )
                          else if (_transactions.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  "No transactions found",
                                  style: TextStyle(
                                    color: const Color(0xFF546E7A),
                                  ),
                                ),
                              ),
                            )
                          else
                            ..._transactions.map((tx) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: TransactionTile(
                                type: tx.type,
                                amount: tx.amount,
                                date: tx.date,
                              ),
                            )),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF3366FF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: const Color(0xFF3366FF),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF37474F),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final String type;
  final double amount;
  final String date;

  const TransactionTile({
    super.key,
    required this.type,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = type.toLowerCase().contains("deposit") || 
                     type.toLowerCase().contains("from");

    String formattedAmount = "${isIncome ? "+" : "-"} ₱${amount.toStringAsFixed(2)}";

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF3366FF).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isIncome ? CupertinoIcons.arrow_down : CupertinoIcons.arrow_up,
            size: 18,
            color: const Color(0xFF3366FF),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF90A4AE),
                ),
              ),
            ],
          ),
        ),
        Text(
          formattedAmount,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isIncome ? Colors.green[800] : Colors.red[700],
          ),
        ),
      ],
    );
  }
}