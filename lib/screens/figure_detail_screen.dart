import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 
import '../shared.dart';
import '../data.dart'; // Pastikan kDarkBG dan kAmber ada di sini

class FigureDetailScreen extends StatelessWidget {
  final Figure figure;
  const FigureDetailScreen({super.key, required this.figure});

  // Fungsi buat buka YouTube (Tetep dipertahankan sesuai request)
  Future<void> _launchYoutube(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        debugPrint('Tidak bisa membuka $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBG,
      body: CustomScrollView(
        slivers: [
          // 1. HEADER GAMBAR (GANTI KE ASSET)
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: kDarkBG,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    figure.imageAsset, // Field asset dari shared.dart
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.white10,
                      child: const Icon(Icons.person, color: Colors.white24, size: 100),
                    ),
                  ),
                  // Gradasi biar transisi ke konten halus
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, kDarkBG],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. KONTEN DETAIL
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(figure.name, 
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  Text(figure.nickname.toUpperCase(), 
                    style: const TextStyle(color: kAmber, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                  
                  const SizedBox(height: 25),
                  
                  Text(figure.description, 
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 15, height: 1.7)),
                  
                  const SizedBox(height: 35),
                  _buildSectionTitle("FUN FACTS"),
                  const SizedBox(height: 15),

                  // LOOPING FUN FACTS
                  ...figure.funFacts.map((fact) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Icon(Icons.star, color: kAmber, size: 14),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(fact, 
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, height: 1.5)),
                        ),
                      ],
                    ),
                  )),

                  const SizedBox(height: 35),
                  _buildSectionTitle("FAMOUS SONGS"),
                  const SizedBox(height: 15),

                  // LOOPING LAGU & TOMBOL YOUTUBE
                  ...figure.famousSongs.map((song) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      leading: const CircleAvatar(
                        backgroundColor: kAmber,
                        radius: 18,
                        child: Icon(Icons.play_arrow_rounded, color: kDarkBG, size: 24),
                      ),
                      title: Text(song['title'] ?? "", 
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                      trailing: Icon(Icons.open_in_new_rounded, color: kAmber.withOpacity(0.5), size: 18),
                      onTap: () => _launchYoutube(song['url'] ?? ""),
                    ),
                  )),
                  
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper buat Judul Seksi
  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, 
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 4),
        Container(width: 30, height: 3, color: kAmber),
      ],
    );
  }
}