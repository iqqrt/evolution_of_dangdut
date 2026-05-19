import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared.dart';
import 'home_screen.dart';
import 'login_screen.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _revealAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Durasi total dipercepat jadi 3 detik
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _revealAnimation = Tween<double>(begin: 1.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.8, curve: Curves.easeInOutQuart),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn)
      ),
    );

    _controller.forward();

    // 2. LOGIKA PINDAH HALAMAN (Set ke 3000ms / 3 Detik)
    Future.delayed(const Duration(milliseconds: 3000), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? name = prefs.getString('user_name');

      if (mounted) {
        Widget destination = (name == null) ? const LoginScreen() : const HomeScreen();

        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800), // Transisi dipercepat dikit biar sinkron
            pageBuilder: (context, animation, secondaryAnimation) => destination,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBG,
      body: AnimatedBuilder(
        animation: _revealAnimation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: MediaQuery.of(context).size,
                painter: RevealPainter(
                  fraction: _revealAnimation.value,
                  color: const Color(0xFFD4A017),
                ),
              ),
              
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/LogoD.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.music_note, size: 80, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class RevealPainter extends CustomPainter {
  final double fraction;
  final Color color;

  RevealPainter({required this.fraction, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = sqrt(size.width * size.width + size.height * size.height);
    canvas.drawCircle(center, maxRadius * fraction, paint);
  }

  @override
  bool shouldRepaint(RevealPainter oldDelegate) => oldDelegate.fraction != fraction;
}