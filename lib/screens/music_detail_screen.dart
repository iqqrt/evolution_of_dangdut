import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../shared.dart';
import '../data.dart'; // Pastikan kDarkBG dan kAmber ada di sini

class MusicDetailScreen extends StatefulWidget {
  final Song song;
  const MusicDetailScreen({super.key, required this.song});

  @override
  State<MusicDetailScreen> createState() => _MusicDetailScreenState();
}

class _MusicDetailScreenState extends State<MusicDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      debugPrint("Audio player state: $state");
      if (!mounted) return;
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    
    // Listen to errors
    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() => isPlaying = false);
    });
  }

  void togglePlay() async {
    try {
      if (isPlaying) {
        await _audioPlayer.stop();
        setState(() => isPlaying = false);
      } else {
        // Pake AssetSource - strip "assets/" prefix
        String audioPath = widget.song.audioPath.replaceFirst('assets/', '');
        debugPrint("Playing audio: $audioPath");
        await _audioPlayer.play(AssetSource(audioPath));
        setState(() {
          isPlaying = true;
          errorMessage = null;
        });
      }
    } catch (e) {
      debugPrint("Error playing audio: $e");
      setState(() {
        errorMessage = "Audio gagal dimuat: ${widget.song.audioPath}";
        isPlaying = false;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBG,
      body: CustomScrollView(
        slivers: [
          // Header dengan Image Asset & Gradasi
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: kDarkBG,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // GANTI KE ASSET
                  Image.asset(
                    widget.song.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.white10,
                      child: const Center(
                        child: Icon(Icons.music_note, color: Colors.white24, size: 80),
                      ),
                    ),
                  ),
                  // Overlay biar teks transisi ke bawah enak dilihat
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
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul & Artist
                  Text(widget.song.title, 
                    style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("${widget.song.artist} — ${widget.song.year}", 
                    style: const TextStyle(color: kAmber, fontSize: 16, fontWeight: FontWeight.w500)),
                  
                  const SizedBox(height: 40),

                  // PLAYER CONTROL (Circle Progress Style)
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: togglePlay,
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: kAmber,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: kAmber.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                )
                              ],
                            ),
                            child: Icon(
                              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, 
                              size: 45, 
                              color: kDarkBG
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          isPlaying ? "SEKARANG DIPUTAR" : "TAP UNTUK DENGERIN",
                          style: TextStyle(
                            color: isPlaying ? kAmber : Colors.white24, 
                            fontSize: 10, 
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // INFO SEKTOR
                  _buildHeaderLabel("INFO SEPUTAR LAGU"),
                  const SizedBox(height: 15),
                  _buildInfoRow("Dominan", widget.song.dominantInstrument),
                  _buildInfoRow("Era", widget.song.era),
                  const SizedBox(height: 15),
                  Text(
                    widget.song.description, 
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 15, height: 1.6)
                  ),

                  const SizedBox(height: 40),

                  // LIRIK SEKTOR
                  _buildHeaderLabel("LIRIK LAGU"),
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03), 
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white.withOpacity(0.05))
                    ),
                    child: Text(
                      widget.song.lyrics,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 15, 
                        height: 2.2, 
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.5
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget Helper biar kode bersih
  Widget _buildHeaderLabel(String label) {
    return Text(
      label, 
      style: const TextStyle(
        color: Colors.white38, 
        fontWeight: FontWeight.bold, 
        fontSize: 11, 
        letterSpacing: 2
      )
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(color: Colors.white24, fontSize: 14)),
          Text(value, style: const TextStyle(color: kAmber, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}