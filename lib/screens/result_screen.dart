import 'package:flutter/material.dart';
import '../shared.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  const ResultScreen({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBG,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("SKOR KAMU", style: TextStyle(color: kTextGray, letterSpacing: 2)),
            const SizedBox(height: 10),
            Text("$score", style: kTitleStyle.copyWith(fontSize: 80, color: kAmber)),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kAmber, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text("KEMBALI KE HOME", style: TextStyle(color: kDarkBG, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}