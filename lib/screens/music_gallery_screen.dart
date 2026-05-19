import 'package:flutter/material.dart';
import '../shared.dart';
import '../data.dart';
import 'music_detail_screen.dart';

class MusicGalleryScreen extends StatefulWidget {
  const MusicGalleryScreen({super.key});

  @override
  State<MusicGalleryScreen> createState() => _MusicGalleryScreenState();
}

class _MusicGalleryScreenState extends State<MusicGalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBG,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Sound of Evolution", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        itemCount: listSongs.length,
        itemBuilder: (context, index) {
          final song = listSongs[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicDetailScreen(song: song),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  // 1. Icon Indikator Musik
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: kAmber.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.library_music_rounded, color: kAmber, size: 20),
                  ),
                  
                  const SizedBox(width: 16),

                  // 2. Deskripsi Lagu (Tengah)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title, 
                          style: const TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold, 
                            fontSize: 15
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${song.artist} • ${song.year}", 
                          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)
                        ),
                        const SizedBox(height: 8),
                        // Label Era
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: kAmber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            song.era.toUpperCase(), 
                            style: const TextStyle(
                              color: kAmber, 
                              fontSize: 9, 
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5
                            )
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // 3. Thumbnail Gambar (Kanan) - SEKARANG PAKE ASSET
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      song.imageAsset, // Field baru dari shared.dart
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      // Handler jika file tidak ditemukan
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 70,
                          height: 70,
                          color: Colors.white10,
                          child: const Icon(Icons.broken_image_rounded, color: Colors.white24),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}