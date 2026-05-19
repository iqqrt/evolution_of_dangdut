import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../shared.dart';
import '../data.dart';
import 'materi_detail_screen.dart'; // Gak perlu ../ karena satu folder screens

class MateriListScreen extends StatelessWidget {
  const MateriListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBG,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Pilih Materi", style: TextStyle(color: kTextLight)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: listMateri.length,
        itemBuilder: (context, index) {
          final materi = listMateri[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MateriDetailScreen(materi: materi),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Text("0${index + 1}", 
                      style: const TextStyle(color: kAmber, fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(materi.title, style: const TextStyle(color: kTextLight, fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(materi.subtitle, style: const TextStyle(color: kTextGray, fontSize: 13)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: kTextGray, size: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}