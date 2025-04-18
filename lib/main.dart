import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('savedAccounts');
  runApp(const BankingApp());
}

class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF3366FF),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
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
    final isLandscape = size.width > size.height;

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
          
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: isLandscape ? size.height : null,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 24 : 40,
                    vertical: isLandscape ? 20 : 40,
                  ),
                  child: Column(
                    mainAxisAlignment: isLandscape 
                        ? MainAxisAlignment.center 
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    
                      
                      SizedBox(height: isLandscape ? 20 : 120),
                      // App header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 12),
                          Text(
                            "BDO",
                            style: TextStyle(
                              fontSize:  90,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 22, 77, 241),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => _showTeamDialog(context),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 39, 92, 251).withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                CupertinoIcons.info,
                                size: 16,
                                color: Color(0xFF3366FF),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Hero illustration
                      // Container(
                      //   padding: const EdgeInsets.all(30),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white.withOpacity(0.9),
                      //     shape: BoxShape.circle,
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: const Color(0xFF3366FF).withOpacity(0.1),
                      //         blurRadius: 30,
                      //         spreadRadius: 5,
                      //       ),
                      //     ],
                      //   ),
                      //   child: SvgPicture.asset(
                      //     'assets/banking.svg', // Replace with your banking illustration
                      //     width: isSmallScreen ? 150 : 180,
                      //   ),
                      // ),
                      
                      SizedBox(height:  5),
                      
                      // Welcome text
                      Column(
                        children: [
                          Text(
                            "Smart Banking App",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 26 : 32,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1A237E),
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Experience the future of finance with our secure, fast, and intuitive banking platform.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              color: const Color(0xFF546E7A),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: isLandscape ? 30 : 120),
                      
                      // Login button
                      SizedBox(
                        width: isSmallScreen ? double.infinity : size.width * 0.6,
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF3366FF),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "GET STARTED",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                  color: Colors.white
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(CupertinoIcons.arrow_right, size: 20),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => const LoginScreen(),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Additional options
                      SizedBox(height: isLandscape ? 20 : 40),
                     
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 void _showTeamDialog(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 5,
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey4,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const Text(
            'Development Team',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildTeamMember(
                  "Ama Beyonce",
                  "Lead Developer",
                  "images/beyonce.jpg",
                ),
                _buildTeamMember(
                  "Bulanadi, Jhon Vianney",
                  "Backend Developer",
                  "images/bulanadi.jpeg",
                ),
                _buildTeamMember(
                  "Culala, Andrea",
                  "UI/UX Designer",
                  "images/culala.jpg",
                ),
                _buildTeamMember(
                  "Dizon, John Carlo V",
                  "Mobile Developer",
                  "images/jc.jpg",
                ),
                _buildTeamMember(
                  "Timbol, Christian",
                  "Security Engineer",
                  "images/timbol.jpg",
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CupertinoButton(
              color: const Color(0xFF3366FF),
              borderRadius: BorderRadius.circular(12),
              child: const Text("Close", style: TextStyle(color: Colors.white),),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildTeamMember(String name, String role, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            CupertinoIcons.person_crop_circle_fill,
            color: Color(0xFF3366FF),
            size: 24,
          ),
        ],
      ),
    );
  }
}