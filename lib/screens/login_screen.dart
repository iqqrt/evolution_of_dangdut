import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _saveNameAndGoHome() async {
    if (_nameController.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _nameController.text);
      
      if (!mounted) return;
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const HomeScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBG,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Siapa namamu?", style: TextStyle(color: kAmber, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 10),
            const Text("Biar kita lebih akrab.", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Masukkan nama...",
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: kAmber)),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kAmber, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: _saveNameAndGoHome,
                child: const Text("MULAI JELAJAH", style: TextStyle(color: kDarkBG, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}