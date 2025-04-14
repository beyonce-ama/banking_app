import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
    final Function(int) onFeatureTap;

  const HomeScreen({super.key, required this.onFeatureTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class BankTransaction {
  final String type; 
  final double amount;
  final String date;

  BankTransaction({
    required this.type, // 'title' is now 'type'
    required this.amount,
    required this.date,
  });

  factory BankTransaction.fromJson(Map<String, dynamic> json) {
    return BankTransaction(
      type: json['Type'], // 'title' is now 'Type'
      amount: double.tryParse(json['Amount'].toString()) ?? 0.0, // Amount field
      date: json['Date'], // Date field
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late double _currentBalance;

  bool _showBalance = true;
  bool _showCardNumber = true;
 final List<BankTransaction> _transactions = [];
final bool _isLoadingTransactions = true;

@override
void initState() {
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.07;

    String formatAccountNo(String accountNo) {
      return accountNo.replaceAllMapped(RegExp(r".{1,4}"), (match) => "${match.group(0)} ").trim();
    }

    return SingleChildScrollView(
      child: CupertinoPageScaffold(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE3F2FD), // Light Blue
                Color(0xFFFFEBEE), // Light Pink
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Icon(CupertinoIcons.person, color: Color(0xFF1565C0)),
                        SizedBox(width: 8),
                        Text(
                          "Welcome,",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
      
                    // Account Balance
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Account Balance",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1565C0),
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
                                  color: Color(0xFF1565C0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _showBalance
                              ? _currentBalance.toStringAsFixed(2)
                              : "••••••",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E88E5),
                            ),
                          ),
                        ],
                      ),
                    ),
      
                    const SizedBox(height: 30),
      
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FeatureCard(
                        icon: CupertinoIcons.arrow_up_arrow_down,
                        label: "Transfers",
                        onTap: () => widget.onFeatureTap.call(1),
                      ),
                      FeatureCard(
                        icon: CupertinoIcons.money_dollar,
                        label: "Pay Bills",
                        onTap: () =>widget.onFeatureTap.call(2),
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
      
                    // Card Design Section
                    Container(
                      width: double.infinity,
                      height: 180,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF42A5F5), Color(0xFF1565C0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text('',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                 _showCardNumber
                                  ? "453534443"
                                  : "**** **** ****",
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
                                  CupertinoIcons.eye,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Exp: 12/24",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
      
                    const SizedBox(height: 30),
      
                    // Transaction Tile (for loop use later)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Recent Transactions",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_isLoadingTransactions)
                            const Center(child: CupertinoActivityIndicator())
                          else if (_transactions.isEmpty)
                            const Text("No transactions found.")
                          else
                           ..._transactions.map((tx) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TransactionTile(
                              type: tx.type, 
                              amount: tx.amount, 
                              date: tx.date,
                            ),
                          )),

                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
      
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 80,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 26, color: Color(0xFF1E88E5)),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF37474F)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
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

  String formattedAmount = 
      "${isIncome ? "+" : "-"} ₱${amount.toStringAsFixed(2)}";

  return Row(
    children: [
      const Icon(CupertinoIcons.time, size: 22, color: Color(0xFF1E88E5)),
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
                color: Colors.grey,
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
