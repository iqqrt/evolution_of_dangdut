import 'package:flutter/material.dart';
import '../shared.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBG,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Aplikasi lu
            ClipOval(child: Image.asset('assets/images/LogoD.png', width: 100)),
            const SizedBox(height: 20),
            const Text("EVOLUTION OF DANGDUT", style: TextStyle(color: kAmber, fontWeight: FontWeight.bold, fontSize: 20)),
            const Text("v1.0.0", style: TextStyle(color: Colors.white24)),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Aplikasi ini dirancang untuk memperkenalkan sejarah dan evolusi musik dangdut kepada generasi muda secara interaktif.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, height: 1.5),
              ),
            ),
            const SizedBox(height: 40),
            const Text("DEVELOPED BY", style: TextStyle(color: kAmber, fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 5),
            const Text("Riski Raditiya", style: TextStyle(color: Colors.white, fontSize: 16)),
            const Text("Politeknik Negeri Media Kreatif", style: TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}