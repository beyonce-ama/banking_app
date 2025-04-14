import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BankingApp());
}

class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
              padding: EdgeInsets.symmetric(horizontal: padding), // Responsive padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      GestureDetector(
                        onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Development Team',
                                      style: TextStyle(
                                        color: Color(0xFF0d0d0d),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              content: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.systemFill,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "images/beyonce.jpg",
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.fill,
                                          ),
                                          SizedBox(width: 15),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Ama Beyonce",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              Text(
                                                "Software Developer",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.systemFill,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "images/bulanadi.jpeg",
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.fill,
                                          ),
                                          SizedBox(width: 15),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Bulanadi, Jhon Vianney",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              Text(
                                                "Software Developer",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.systemFill,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "images/culala.jpg",
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.fill,
                                          ),
                                          SizedBox(width: 15),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Culala, Andrea",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              Text(
                                                "Software Developer",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.systemFill,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "images/jc.jpg",
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.fill,
                                          ),
                                          SizedBox(width: 15),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Dizon, John Carlo V",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              Text(
                                                "Software Developer",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.systemFill,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "images/timbol.jpg",
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.fill,
                                          ),
                                          SizedBox(width: 15),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Timbol, Christian",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              Text(
                                                "Software Developer",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                CupertinoButton(
                                  child: Text(
                                    'Close',
                                    style: TextStyle(color: CupertinoColors.destructiveRed),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(CupertinoIcons.info, color: Color(0xFF1E88E5),)),
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
                  const SizedBox(height: 60),

                  // Icon logo
                  Icon(
                    CupertinoIcons.creditcard_fill, 
                    size: 180, 
                    color: Color(0xFF1E88E5), 
                  ),

                  const SizedBox(height: 40),

                  // Welcome text
                  const Text(
                    "Welcome to Your Smart Bank",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF37474F), 
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Take control of your finances in a few taps. Secure, fast, and simple.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFB0BEC5), 
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 50),

                
                  const SizedBox(height: 50),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF42A5F5), // Light blue
                          Color(0xFF1565C0), 
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF5C6BC0).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      borderRadius: BorderRadius.circular(30),
                      child: const Text(
                        "LOG IN",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () { },
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