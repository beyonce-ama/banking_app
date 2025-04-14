import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class BillsPaymentPage extends StatelessWidget {
  const BillsPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bills Payment',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF37474F),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select a biller to pay',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF7C8C8D),
                  ),
                ),
                const SizedBox(height: 30),

                // Billers List
                _buildBillerList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fixed method - now it's an instance method and can access `user`
  Widget _buildBillerList(BuildContext context) {
    final List<Map<String, dynamic>> billers = [
      {
        "name": "Pelco",
        "icon": CupertinoIcons.bolt_fill,
      },
      {
        "name": "Balibago Water Works",
        "icon": CupertinoIcons.drop_fill,
        "tags": ["GCredit", "GGives"]
      },
      {
        "name": "Converge",
        "icon": CupertinoIcons.wifi,
      },
       {
        "name": "PLDT",
        "icon": CupertinoIcons.wifi,
      },
      {
        "name": "Maynilad",
        "icon": CupertinoIcons.drop,
      },
      {
        "name": "Smart",
        "icon": CupertinoIcons.phone_fill,
      },
      {
        "name": "Globe",
        "icon": CupertinoIcons.phone,
     
      },
    ];

    return Column(
      children: billers.map((biller) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    BillPaymentFormPage(biller: biller['name']),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(biller['icon'], size: 28, color: const Color(0xFF1565C0)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        biller['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF263238),
                        ),
                      ),
                      const SizedBox(height: 4),
             
                    ],
                  ),
                ),
                const Icon(CupertinoIcons.chevron_forward, size: 20, color: Color(0xFF90A4AE)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}


class BillPaymentFormPage extends StatefulWidget {
  final String biller;

  const BillPaymentFormPage({
    super.key,
    required this.biller,
  });

  @override
  _BillPaymentFormPageState createState() => _BillPaymentFormPageState();
}

class _BillPaymentFormPageState extends State<BillPaymentFormPage> {
  final _amountController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final bool _isLoading = false;
  String? _message;
  final bool _isSuccess = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFFFEBEE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.back, color: Color(0xFF37474F)),
                      SizedBox(width: 6),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF37474F),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Pay Bill: ${widget.biller}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF37474F),
                  ),
                ),
                
                const SizedBox(height: 20),
                const Text(
                  'Enter the bill details',
                  style: TextStyle(fontSize: 16, color: Color(0xFF7C8C8D)),
                ),
                const SizedBox(height: 30),
                  if (_message != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isSuccess ? Colors.green[100] : Colors.red[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isSuccess ? Icons.check_circle : Icons.error,
                            color: _isSuccess ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _message!,
                              style: TextStyle(
                                color: _isSuccess ? Colors.green[800] : Colors.red[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                _buildTextField(
                  controller: _accountNumberController,
                  label: 'Account Number',
                  placeholder: 'Enter account number',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: _amountController,
                  label: 'Amount (₱)',
                  placeholder: 'Enter amount',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 40),

                _isLoading
                    ? const Center(child: CupertinoActivityIndicator())
                    : GestureDetector(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF42A5F5),
                                Color(0xFF1565C0),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.creditcard_fill, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Pay Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
          color: Color(0xFF37474F),
        ),
      ),
      const SizedBox(height: 6),
      CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        padding: const EdgeInsets.all(15),
        keyboardType: keyboardType,
        cursorColor: Color(0xFF37474F),
        style: const TextStyle(
          color: Color(0xFF263238), // dark gray-blue text
          fontSize: 16,
        ),
        placeholderStyle: const TextStyle(
          color: Color(0xFF90A4AE), // soft blue-gray
          fontSize: 15,
        ),
        decoration: BoxDecoration(
          color: Color(0xFFF0F4F8), // very light blue-gray background
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
      ),
    ],
  );
}
}


// Only the updated ReceiptPage class for brevity
class ReceiptPage extends StatelessWidget {
  final String biller;
  final String amount;
  final String accountNumber;

  const ReceiptPage({
    super.key,
    required this.biller,
    required this.amount,
    required this.accountNumber,
  });

  @override
  Widget build(BuildContext context) {
    final double amountValue = double.tryParse(amount) ?? 0;
    final double totalAmount = amountValue + 15;
    final String formattedDate = DateTime.now().toString().substring(0, 16); // yyyy-MM-dd HH:mm

    return CupertinoPageScaffold(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFFFEBEE)],
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 6)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.check_mark_circled_solid, size: 70, color: Colors.green),
                    const SizedBox(height: 16),
                    const Text(
                      'Payment Successful!',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF37474F)),
                    ),
                    const SizedBox(height: 20),
                    _buildRow('Date', formattedDate),
                    _buildRow('Biller', biller),
                    _buildRow('Account No.', accountNumber),
                    _buildRow('Amount', '₱$amount'),
                    _buildRow('Fee', '₱15.00'),
                    const Divider(height: 30),
                    _buildRow('Total Paid', '₱${totalAmount.toStringAsFixed(2)}'),
                    const SizedBox(height: 30),
                    CupertinoButton.filled(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      borderRadius: BorderRadius.circular(30),
                      child: const Text('Done'),
                        onPressed: () {
                      Navigator.pop(context); 
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => DashboardScreen(), 
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

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
        ],
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
