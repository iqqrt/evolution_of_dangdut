import 'package:flutter/material.dart';
import '../shared.dart';
import 'pre_quiz_review_screen.dart'; // 1. IMPORT LAYAR REVIEW YANG BARU

class LevelScreen extends StatelessWidget {
  LevelScreen({super.key}); 

  final List<Map<String, dynamic>> levels = [
    {"title": "Proto-Dangdut", "icon": Icons.history, "color": Colors.brown},
    {"title": "Raja Dangdut", "icon": Icons.workspace_premium, "color": kAmber},
    {"title": "Politik Massa", "icon": Icons.groups, "color": Colors.redAccent},
    {"title": "Koplo Speed", "icon": Icons.speed, "color": Colors.orange},
    {"title": "Perang Budaya", "icon": Icons.gavel, "color": Colors.pinkAccent},
    {"title": "VCD & Digital", "icon": Icons.album, "color": Colors.blueGrey},
    {"title": "Nostalgia Digital", "icon": Icons.cloud_done, "color": Colors.indigoAccent},
    {"title": "Anti Normal", "icon": Icons.diversity_3, "color": Colors.lightGreen}, 
    {"title": "Matinya Genre", "icon": Icons.do_not_disturb_on, "color": Colors.purpleAccent},
    {"title": "Neuroscience", "icon": Icons.psychology, "color": Colors.cyanAccent},
    {"title": "Antropologi", "icon": Icons.accessibility_new, "color": Colors.tealAccent},
    {"title": "Eksploitasi & Bebas", "icon": Icons.female, "color": Colors.pink}, 
    {"title": "Ekonomi Rakyat", "icon": Icons.payments, "color": Colors.green},
    {"title": "Masa Depan AI", "icon": Icons.auto_awesome, "color": Colors.blueAccent},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBG,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Pilih Level Kuis", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(25),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.85, 
        ),
        itemCount: levels.length,
        itemBuilder: (context, index) {
          final levelData = levels[index];
          return _buildLevelCard(
            context, 
            index, // 2. Kirim index (dimulai dari 0) biar gampang diolah di layar review
            levelData
          );
        },
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, int index, Map<String, dynamic> levelData) {
    int level = index + 1;
    Color color = levelData["color"];
    String title = levelData["title"];
    IconData icon = levelData["icon"];

    return GestureDetector(
      onTap: () {
        // 3. SEKARANG JALUR NAVIGASINYA SUDAH MAMPIR KE PRE-QUIZ REVIEW DULU
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreQuizReviewScreen(
              levelData: levelData,
              levelIndex: index,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 35, color: color),
            ),
            const SizedBox(height: 15),
            Text(
              "LEVEL $level", 
              style: TextStyle(
                color: color, 
                fontWeight: FontWeight.w900, 
                fontSize: 10,
                letterSpacing: 1.5
              )
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                title, 
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 13,
                  height: 1.2
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}