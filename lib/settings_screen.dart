import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';
import 'login_screen.dart';

class SettingsPage extends StatelessWidget {
  final User user;
  const SettingsPage({super.key, required this.user});


void logout(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => LoginScreen()),
    (Route<dynamic> route) => false,
  );
}

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE3F2FD),
              Color(0xFFFFEBEE), 
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
                  'Settings',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF37474F),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Manage your preferences',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF7C8C8D),
                  ),
                ),
                const SizedBox(height: 30),

                Expanded(
                  child: ListView(
                    children: [
                      _buildSectionTitle('Account Settings'),
                      _buildListTile(
                        title: 'Change PIN',
                        icon: CupertinoIcons.lock,
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (context) =>  ChangePinPage(user: user)),
                          );
                        },
                      ),

                      // _buildListTile(
                      //   title: 'Change Password',
                      //   icon: CupertinoIcons.lock_circle,
                      //   onTap: () {
                      //     // Change Password functionality
                      //   },
                      // ),
                      const Divider(),

                      // // Section: Preferences
                      // _buildSectionTitle('Preferences'),
                      // _buildListTile(
                      //   title: 'Notification Settings',
                      //   icon: CupertinoIcons.bell,
                      //   onTap: () {
                      //     // Notification settings functionality
                      //   },
                      // ),
                      // _buildListTile(
                      //   title: 'Language',
                      //   icon: CupertinoIcons.globe,
                      //   onTap: () {
                      //     // Language settings functionality
                      //   },
                      // ),
                      // const Divider(),

                      // Section: Logout
                      _buildSectionTitle('Logout'),
                      _buildListTile(
                        title: 'Log Out',
                        icon: CupertinoIcons.power,
                        iconColor: Colors.red.shade700,
                       onTap: () {
                        logout(context);
                      },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF37474F),
        ),
      ),
    );
  }

  // Helper method to build individual ListTiles
  Widget _buildListTile({
    required String title,
    required IconData icon,
    Color? iconColor,
    required Function onTap,
  }) {
    return CupertinoListTile(
      leading: Icon(
        icon,
        color: iconColor ?? CupertinoColors.activeBlue,
      ),
      title: Text(title, style: TextStyle(
          fontSize: 18,
          color: Color(0xFF37474F),
        ),),
      trailing: const Icon(CupertinoIcons.chevron_forward),
      onTap: () => onTap(),
    );
  }
}

class ChangePinPage extends StatefulWidget {
  final User user;
  const ChangePinPage({super.key, required this.user});

  @override
  _ChangePinPageState createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  bool _isLoading = false;
  String? _message;
  bool _isSuccess = false;

void _showMessage(String message, {bool success = false}) {
  setState(() {
    _message = message;
    _isSuccess = success;
  });

  Future.delayed(const Duration(seconds: 3), () {
    setState(() => _message = null);
  });
}

 Future<void> initiatePinChange() async {
  final accountId = widget.user.id;

  print('Initiating PIN change for accountId: $accountId');

  setState(() {
    _isLoading = true;
  });

  try {
    final response = await http.post(
      Uri.parse('https://phpconfig.fun/atmapp/send_otp.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'accountId': accountId}),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Parsed response data: $data');

      if (data['success'] != null) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => VerifyOtpPage(accountId: accountId.toString()),
          ),
        );
      } else {
        _showMessage(data['error'] ?? 'Failed to send OTP.');
      }
    } else {
      _showMessage('Server error. Please try again later.');
    }
  } catch (e) {
    print('Error occurred: $e');
    setState(() {
      _isLoading = false;
    });
    _showMessage('Something went wrong. Please check your connection.');
  }
}

 @override
Widget build(BuildContext context) {
  return CupertinoPageScaffold(
    child: Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE3F2FD),
            Color(0xFFFFEBEE),
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
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (_message != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
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

                    const Text(
                      "To change your PIN, we'll send an OTP to your registered email.",
                      style: TextStyle(
                        color: Color(0xFF37474F),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    CupertinoButton(
                      onPressed: _isLoading ? null : initiatePinChange,
                    child: _isLoading
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey5,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CupertinoActivityIndicator(color: Color(0xFF37474F)),
                              SizedBox(width: 10),
                              Text(
                                'Sending...',
                                style: TextStyle(
                                  color: Color(0xFF37474F),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const Text('Send OTP'),

                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}


class VerifyOtpPage extends StatefulWidget {
  final String accountId;

  const VerifyOtpPage({super.key, required this.accountId});

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  bool _isLoading = false;
  String? _message;
  bool _isSuccess = false;
bool _obscurePin = true;


void _showMessage(String message, {bool success = false}) {
  setState(() {
    _message = message;
    _isSuccess = success;
  });

  Future.delayed(const Duration(seconds: 3), () {
    setState(() => _message = null);
  });
}

 Future<void> verifyOtpAndChangePin() async {
  final otp = _otpController.text.trim();
  final newPin = _newPinController.text.trim();

  if (otp.isEmpty || newPin.isEmpty) {
    _showMessage('Please enter both OTP and new PIN.');
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final response = await http.post(
      Uri.parse('https://phpconfig.fun/atmapp/change_pin.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'accountId': widget.accountId,
        'otp': otp,
        'newPin': newPin,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] != null) {
        _showMessage('PIN changed successfully!', success: true);
        Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
        );
      });
      } else {
        _showMessage(data['error'] ?? 'Failed to change PIN.');
      }
    } else {
      _showMessage('Server error. Please try again later.');
    }
  } catch (error) {
    setState(() {
      _isLoading = false;
    });
    print('Error occurred: $error');
    _showMessage('An error occurred. Please try again.');
  }
}

  
@override
Widget build(BuildContext context) {
  return CupertinoPageScaffold(
    child: Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE3F2FD),
            Color(0xFFFFEBEE),
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
              const SizedBox(height: 30),
              if (_message != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
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

              const Text(
                "Verify OTP",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF37474F),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please enter the OTP sent to your email and set your new PIN.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF607D8B),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OTP',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                     const SizedBox(height: 10),
                    CupertinoTextField(
                      controller: _otpController,
                      placeholder: 'Enter OTP',
                      keyboardType: TextInputType.number,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      style: const TextStyle(
                        color: Color(0xFF37474F),
                        fontSize: 16,
                      ),
                      placeholderStyle: const TextStyle(
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'New Pin',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                     const SizedBox(height: 10),

                   Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      CupertinoTextField(
                        controller: _newPinController,
                        placeholder: 'Enter New PIN',
                        keyboardType: TextInputType.number,
                        obscureText: _obscurePin,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F4F8),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        style: const TextStyle(
                          color: Color(0xFF37474F),
                          fontSize: 16,
                        ),
                        placeholderStyle: const TextStyle(
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscurePin = !_obscurePin;
                            });
                          },
                          child: Icon(
                            _obscurePin ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                            color: const Color(0xFF607D8B),
                          ),
                        ),
                      ),
                    ],
                  ),

                    const SizedBox(height: 30),
                    CupertinoButton.filled(
                      onPressed: _isLoading ? null : verifyOtpAndChangePin,
                      child: _isLoading
                          ? const CupertinoActivityIndicator()
                          : const Text('Change PIN'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
