import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; 

// Tambahin async di sini buat proses nunggu
void main() async {
  // 1. Inisialisasi binding Flutter (Wajib ada kalau pake async di main)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Trik "Paksa" nahan splash screen sistem selama 2 detik
  // Ini biar transisi ke SplashScreen.dart lu gak berasa loncat
  await Future.delayed(const Duration(seconds: 2));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evolution of Dangdut',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat', 
        // Tambahin ini biar transisi antar halaman di seluruh aplikasi lebih smooth
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const SplashScreen(), 
    );
  }
}