import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'user_model.dart';
import 'package:hive/hive.dart';


class TransferPage extends StatelessWidget {
  final User user;
  const TransferPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final List<String> partnerBanks = ["BDO", "Landbank", "PNB", "China Bank", "Union Bank", "BPI", "RCBC",];

    return CupertinoPageScaffold(
      child: SingleChildScrollView(
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
                  // Title
                  const Text(
                    'Transfer Funds',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263238),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  const Text(
                    'Select a saved account or a partner bank to start a transfer.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF607D8B),
                    ),
                  ),
                  const SizedBox(height: 30),

                  const Text(
                    'Saved Accounts',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

                  const SizedBox(height: 30),
                  const Text(
                    'Partner Banks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

               // Partner Banks List (replacing horizontal scroll view)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: partnerBanks.map((bank) {
                      return GestureDetector(
                        onTap: () {},
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
                              const Icon(CupertinoIcons.building_2_fill,
                                  size: 26, color: Color(0xFF1565C0)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  bank,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF263238),
                                  ),
                                ),
                              ),
                              const Icon(CupertinoIcons.chevron_forward,
                                  size: 20, color: Color(0xFF90A4AE)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 45),
                ],
              ),
            ),
          ),
        ),
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

class TransferFormPageState extends State<TransferFormPage> {
  final TextEditingController _recipientNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String? _message;
  final bool _isSuccess = false;

@override
void initState() {
  super.initState();
  _recipientNameController.text = widget.initialName ?? '';
  _accountNumberController.text = widget.initialAccount ?? '';
}
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
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

                // Flash message
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

                // Title
                const Text(
                  'Transfer Money',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF37474F),
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  'Enter the recipient\'s account details for ${widget.bankOrAccount}.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF7C8C8D),
                  ),
                ),
                const SizedBox(height: 30),

                // Form Fields
                _buildTextField(
                  controller: _recipientNameController,
                  label: 'Recipient Name',
                  placeholder: 'Enter recipient name',
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: _accountNumberController,
                  label: 'Bank Account Number',
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
               const SizedBox(height: 20),

              // Save Button - Small and aligned right
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 137, 230, 140),
                            Color.fromARGB(255, 89, 193, 93),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 127, 129, 134).withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.add_circled_solid, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Submit Button
               GestureDetector(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                       colors: [
                    Color(0xFF42A5F5),
                    Color(0xFF1565C0), ],
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
                      Icon(CupertinoIcons.arrow_right_circle_fill, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Transfer Now',
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
     const SizedBox(height: 230),

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