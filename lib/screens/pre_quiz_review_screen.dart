import 'package:flutter/material.dart';
import '../shared.dart';
import 'quiz_screen.dart';

class PreQuizReviewScreen extends StatelessWidget {
  final Map<String, dynamic> levelData;
  final int levelIndex;

  const PreQuizReviewScreen({
    super.key, 
    required this.levelData, 
    required this.levelIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBG,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("REVIEW LEVEL ${levelIndex + 1}"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            // Badge Icon Level Dinamis sesuai data dari LevelScreen
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: (levelData['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: levelData['color'] as Color, width: 2),
                ),
                child: Icon(
                  levelData['icon'] as IconData,
                  size: 60,
                  color: levelData['color'] as Color,
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Judul Kuis / Era Dangdut
            Center(
              child: Text(
                levelData['title'] ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15),
            
            // Deskripsi Singkat Review Bab
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Text(
                "Kuis ini akan menguji pemahaman sosiokultural lu mengenai bab '${levelData['title']}'. Siapkan ingatan lu tentang tokoh, perkembangan era, dan konflik budaya yang terjadi di fase ini.",
                style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            
            const Spacer(),
            
            // TOMBOL PILIHAN NAVIGASI (INTERAKTIF)
            Row(
              children: [
                // Tombol Kembali ke Pemilihan Materi
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white38),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("BACA MATERI", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 15),
                
                // Tombol Gas Langsung Kuis (Sudah Sinkron ke Constructor QuizScreen Lu)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(
                            // Mengirim parameter selectedLevel yang pas ke QuizScreen asli lu
                            selectedLevel: levelIndex + 1, 
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAmber,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text(
                      "LANGSUNG KUIS", 
                      style: TextStyle(color: kDarkBG, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}