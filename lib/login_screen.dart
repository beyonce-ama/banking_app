import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;
  String? _successMessage;
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
    final padding = isSmallScreen ? 24.0 : 40.0;

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
          
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    
                    // App header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "BDO",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                           color: const Color.fromARGB(255, 22, 77, 241),
                            letterSpacing: 1.2,
                          ),
                        ), 
                        const SizedBox(width: 12),   const Icon(
                          CupertinoIcons.creditcard_fill,
                          size: 28,
                          color: Color(0xFF3366FF),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Login card
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Sign in to continue to your account",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              color: const Color(0xFF546E7A),
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Username field
                          CupertinoTextField(
                            controller: _usernameController,
                            placeholder: "Email or Bank Number",
                            placeholderStyle: TextStyle(
                              color: const Color(0xFF90A4AE),
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            style: TextStyle(
                              color: const Color(0xFF37474F),
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                                width: 1,
                              ),
                            ),
                            prefix: const Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Icon(
                                CupertinoIcons.person_fill,
                                color: Color(0xFF3366FF),
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Password field
                          Stack(
                            children: [
                              CupertinoTextField(
                                controller: _passwordController,
                                placeholder: "PIN",
                                placeholderStyle: TextStyle(
                                  color: const Color(0xFF90A4AE),
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                                obscureText: _obscurePassword,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                style: TextStyle(
                                  color: const Color(0xFF37474F),
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE0E0E0),
                                    width: 1,
                                  ),
                                ),
                                prefix: const Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: Icon(
                                    CupertinoIcons.lock_fill,
                                    color: Color(0xFF3366FF),
                                    size: 20,
                                  ),
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
                                    color: const Color(0xFF3366FF),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Login button
                          SizedBox(
                            width: double.infinity,
                            child: CupertinoButton(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFF3366FF),
                              child: const Text(
                                "LOG IN",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                String username = _usernameController.text.trim();
                                String pin = _passwordController.text.trim();

                                if (username.isEmpty || pin.isEmpty) {
                                  setState(() {
                                    _errorMessage = "Please fill in all fields.";
                                  });
                                  return;
                                }

                                try {
                                  var url = Uri.parse("https://phpconfig.fun/atmapp/login.php");
                                  var response = await http.post(
                                    url,
                                    headers: {"Content-Type": "application/json"},
                                    body: jsonEncode({"username": username, "pin": pin}),
                                  );

                                  print("Status Code: ${response.statusCode}");
                                  print("Response Body: ${response.body}");

                                  if (response.statusCode == 200) {
                                    var jsonResponse = jsonDecode(response.body);

                                    if (jsonResponse["status"] == "success") {
                                      setState(() {
                                        _successMessage = "Login Successful!";
                                        _errorMessage = null;
                                      });
                                      User user = User.fromJson(jsonResponse["data"]);

                                      Future.delayed(const Duration(seconds: 1), () {
                                        Navigator.pushReplacement(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (_) => DashboardScreen(user: user),
                                          ),
                                        );
                                      });
                                    } else {
                                      setState(() {
                                        _errorMessage = jsonResponse["message"];
                                        _successMessage = null;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      _errorMessage = "Unexpected error occurred. Please try again.";
                                      _successMessage = null;
                                    });
                                  }
                                } catch (e) {
                                  print("Login Error: $e");
                                  setState(() {
                                    _errorMessage = "Could not connect to server. Please try again.";
                                    _successMessage = null;
                                  });
                                }
                              },
                            ),
                          ),
                          
                          // Messages
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.red[100]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.exclamationmark_triangle_fill,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          
                          if (_successMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.green[100]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.checkmark_alt_circle_fill,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _successMessage!,
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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