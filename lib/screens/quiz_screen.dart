import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart'; // 1. Tambah import ini
import '../shared.dart';
import '../data.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final int selectedLevel;
  const QuizScreen({super.key, required this.selectedLevel});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> filteredQuestions;
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedAnswerIndex;
  bool isAnswered = false;
  bool _isBgmPlaying = true;

  // 2. DEKLARASI MULTI-CHANNEL AUDIO PLAYER
  late AudioPlayer _backsoundPlayer;
  late AudioPlayer _sfxPlayer;

  @override
  void initState() {
    super.initState();
    filteredQuestions = listQuestions.where((q) => q.level == widget.selectedLevel).toList();
    
    // 3. INISIALISASI & JALANKAN BACKSOUND
    _backsoundPlayer = AudioPlayer();
    _sfxPlayer = AudioPlayer();
    _playBacksound();
  }

  void _playBacksound() {
    // Gunakan .catchError pada rantai Future agar error asinkron tidak menyebabkan Web nge-freeze.
    _backsoundPlayer.setReleaseMode(ReleaseMode.loop).then((_) {
      // ATUR VOLUME BACKSOUND DI SINI (Contoh: 0.3 = 30%, 0.1 = 10%)
      _backsoundPlayer.play(AssetSource('audio/quiz/quiz_bg.mp3'), volume: 0.7).catchError((e) {
        debugPrint("Gagal memutar backsound: $e");
      });
    }).catchError((_) {});
  }

  // HELPER UNTUK PLAY SFX BIAR AMAN DARI CRASH
  void _playSfx(String path, {double volume = 1.0}) {
    if (!mounted) return;
    _sfxPlayer.stop().then((_) {
      // Volume sekarang dinamis sesuai parameter yang dikirim
      _sfxPlayer.play(AssetSource(path), volume: volume).catchError((e) {
        debugPrint("Gagal play SFX: $e");
      });
    }).catchError((_) {});
  }

  // JURUS SIMPAN SKOR TERTINGGI + SFX SELESAI
  void _updateHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = 'high_score_${widget.selectedLevel}';
    int currentHighScore = prefs.getInt(key) ?? 0;

    if (score > currentHighScore) {
      await prefs.setInt(key, score);
    }

    // 4. MATIKAN BACKSOUND & MAINKAN SFX AKHIR (BERDASARKAN SKOR)
    _backsoundPlayer.stop().catchError((_) {}); 
    if (score >= 70) {
      _playSfx('audio/quiz/victory.mp3', volume: 0.7); // Atur volume menang di sini (1.0 = 100%)
    } else {
      _playSfx('audio/quiz/defeat.mp3', volume: 0.7); // Atur volume kalah di sini
    }

    // Kasih delay dikit biar sound hasil kuisnya kedengeran sebelum pindah screen
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(score: score)),
    );
  }

  void checkAnswer(int index) async {
    if (isAnswered) return;

    setState(() {
      selectedAnswerIndex = index;
      isAnswered = true;
    });

    // 5. MAINKAN SFX INSTAN BENAR / SALAH
    if (index == filteredQuestions[currentQuestionIndex].correctAnswerIndex) {
      score += (100 ~/ filteredQuestions.length); 
      // ATUR VOLUME SUARA BENAR DI SINI (Contoh: 1.0 = 100%)
      _playSfx('audio/quiz/correct.mp3', volume: 0.3);
    } else {
      // ATUR VOLUME SUARA SALAH DI SINI (Contoh: 0.2 = 20%)
      _playSfx('audio/quiz/wrong.mp3', volume: 0.3);
    }

    // Naikkan delay dari 600ms ke 1200ms biar user sempet ngeliat jawaban bener/salah
    await Future.delayed(const Duration(milliseconds: 1200));

    if (currentQuestionIndex < filteredQuestions.length - 1) {
      if (!mounted) return;
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        isAnswered = false;
      });
    } else {
      if (!mounted) return;
      _updateHighScore();
    }
  }

  // 6. WAJIB DISPOSE BIAR AUDIO GAK BOCOR PAS PINDAH LAYAR
  @override
  void dispose() {
    _backsoundPlayer.stop().catchError((_) {});
    _sfxPlayer.stop().catchError((_) {});
    _backsoundPlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (filteredQuestions.isEmpty) {
      return Scaffold(
        backgroundColor: kDarkBG,
        body: Center(
          child: Text("Belum ada soal untuk Level ${widget.selectedLevel}", 
          style: const TextStyle(color: Colors.white)),
        ),
      );
    }

    final question = filteredQuestions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: kDarkBG,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        title: Text("Level ${widget.selectedLevel}", style: const TextStyle(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isBgmPlaying ? Icons.volume_up : Icons.volume_off, color: kAmber),
            onPressed: () {
              // Ubah state UI seketika tanpa perlu nunggu player merespon (Bebas Lag)
              setState(() {
                _isBgmPlaying = !_isBgmPlaying;
              });

              if (!_isBgmPlaying) {
                _backsoundPlayer.pause().catchError((_) {});
              } else {
                if (_backsoundPlayer.source == null) {
                  _backsoundPlayer.setReleaseMode(ReleaseMode.loop).then((_) {
                    // ATUR VOLUME BACKSOUND DI SINI JUGA BIAR SAMA KALAU DI-UNMUTE
                    _backsoundPlayer.play(AssetSource('audio/quiz/quiz_bg.mp3'), volume: 0.3).catchError((_) {});
                  }).catchError((_) {});
                } else {
                  _backsoundPlayer.resume().catchError((_) {});
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / filteredQuestions.length,
              backgroundColor: Colors.white10,
              color: kAmber,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 30),
            
            Text(
              "PERTANYAAN ${currentQuestionIndex + 1} / ${filteredQuestions.length}", 
              style: const TextStyle(color: kAmber, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 12)
            ),
            const SizedBox(height: 12),
            Text(
              question.questionText, 
              style: const TextStyle(color: kTextLight, fontSize: 22, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 40),

            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  bool isCorrect = index == question.correctAnswerIndex;
                  bool isSelected = selectedAnswerIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => checkAnswer(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isAnswered
                              ? (isCorrect 
                                  ? Colors.green.withOpacity(0.2) 
                                  : (isSelected ? Colors.red.withOpacity(0.2) : Colors.white.withOpacity(0.05)))
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isAnswered
                                ? (isCorrect ? Colors.green : (isSelected ? Colors.red : Colors.white10))
                                : Colors.white10,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              question.options[index], 
                              style: TextStyle(
                                color: isAnswered && isSelected ? Colors.white : kTextLight, 
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                              )
                            ),
                            if (isAnswered && isCorrect) const Icon(Icons.check_circle, color: Colors.green),
                            if (isAnswered && isSelected && !isCorrect) const Icon(Icons.cancel, color: Colors.red),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}