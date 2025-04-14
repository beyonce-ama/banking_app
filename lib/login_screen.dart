import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;  // Variable to hold the error message
 String? _successMessage; // Variable to hold the success message

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.07;

    return CupertinoPageScaffold(
      child: Container(
        width: double.infinity,
        height: double.infinity,
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
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(CupertinoIcons.device_phone_portrait, color: Color(0xFF1E88E5)),
                      SizedBox(width: 8),
                      Text(
                        "Banking App",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF37474F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Icon(
                    CupertinoIcons.creditcard_fill,
                    size: 120,
                    color: Color(0xFF1E88E5),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Log In to Your Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF37474F),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Enter your credentials to continue.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFB0BEC5),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Username Input (with placeholder only)
                  CupertinoTextField(
                    controller: _usernameController,
                    placeholder: "Email or Bank Number",
                    placeholderStyle: TextStyle(
                      color: Color(0xFF90A4AE), // Soft gray
                      fontSize: 16,
                    ),
                    onChanged: (value) => print("Username: $value"), 
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    style: const TextStyle(
                      color: Color(0xFF37474F),
                      fontSize: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password Input (with placeholder only and toggle icon)
                  Stack(
                    children: [
                      CupertinoTextField(
                        controller: _passwordController,
                        placeholder: "PIN",
                        placeholderStyle: TextStyle(
                          color: Color(0xFF90A4AE), // Soft gray
                          fontSize: 16,
                        ),
                        onChanged: (value) => print("PIN: $value"), 
                        obscureText: _obscurePassword,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        style: const TextStyle(
                          color: Color(0xFF37474F),
                          fontSize: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 16,
                        top: 12,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          child: Icon(
                            _obscurePassword
                                ? CupertinoIcons.eye_fill
                                : CupertinoIcons.eye_slash_fill,
                            color: const Color(0xFF1E88E5),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Login Button
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF42A5F5),
                          Color(0xFF1565C0),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1565C0).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(30),
                      child: const Text(
                        "LOG IN",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: ()  { },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Display error message if there's one
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.only(top: 20),
                      color: Colors.red[100],
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),

                  // Display success message if login is successful
                  if (_successMessage != null)
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.only(top: 20),
                      color: Colors.green[100],
                      child: Text(
                        _successMessage!,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}