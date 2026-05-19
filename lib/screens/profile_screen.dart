import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared.dart';
import 'about_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "";
  Map<String, int> highScores = {};
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "Guest";
      _nameController.text = userName;
      
      // Ambil skor dari level 1 sampai 14
      for (int i = 1; i <= 14; i++) {
        highScores[i.toString()] = prefs.getInt('high_score_$i') ?? 0;
      }
    });
  }

  void _updateName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Nama berhasil diperbarui!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBG,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        centerTitle: true,
        title: const Text("PROFIL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 2)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION NAMA ---
            const Text("PENGATURAN IDENTITAS", 
              style: TextStyle(color: kAmber, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.5)),
            const SizedBox(height: 15),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                hintText: "Nama User",
                hintStyle: const TextStyle(color: Colors.white24),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.edit_note, color: kAmber),
                suffixIcon: IconButton(onPressed: _updateName, icon: const Icon(Icons.check_circle, color: kAmber)),
              ),
            ),

            const SizedBox(height: 40),

            // --- SECTION HIGH SCORES ---
            const Text("SKOR TERTINGGI PER LEVEL", 
              style: TextStyle(color: kAmber, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.5)),
            const SizedBox(height: 15),

            // LOGIKA SORTING & MAPPING
            ...(() {
              // 1. Ambil semua key (level)
              List<String> keys = highScores.keys.toList();
              
              // 2. Sortir secara numerik (1, 2, 3... 14)
              keys.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

              // 3. Map jadi widget
              return keys.map((key) {
                int score = highScores[key] ?? 0;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        key.padLeft(2, '0'),
                        style: const TextStyle(color: kAmber, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(width: 20),
                      const Text("Evolution Level", style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const Spacer(),
                      Text("$score", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(width: 8),
                      const Text("PTS", style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }).toList();
            }()),

            const SizedBox(height: 40),

            // --- SECTION MENU ---
            const Text("SISTEM", 
              style: TextStyle(color: kAmber, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.5)),
            const SizedBox(height: 15),
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen())),
              tileColor: Colors.white.withOpacity(0.05),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              leading: const Icon(Icons.info_outline, color: Colors.white),
              title: const Text("Tentang Aplikasi", style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}