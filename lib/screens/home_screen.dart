import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared.dart';
import '../data.dart';
import 'materi_list_screen.dart';
import 'level_screen.dart';
import 'music_gallery_screen.dart';
import 'profile_screen.dart';
import 'figure_list_screen.dart';
import 'ai_chat_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "User";
  double progressPercent = 0.0;
  int completedCount = 0;
  int completedQuizCount = 0;
  int totalScore = 0;
  List<String> userActivities = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String savedName = prefs.getString('user_name') ?? "Guest";

    int materiCount = 0;
    for (var materi in listMateri) {
      if (prefs.getBool('read_${materi.title}') ?? false) {
        materiCount++;
      }
    }

    int quizCount = 0;
    int points = 0;
    // Mengambil data dari 14 level kuis yang tersedia
    for (int i = 1; i <= 14; i++) {
      int score = prefs.getInt('high_score_$i') ?? 0;
      points += score;
      if (score == 100) {
        quizCount++; // Hanya dihitung kalau nilainya sempurna (100)
      }
    }

    List<String> savedActivities = prefs.getStringList('recent_activities') ?? ["Belum ada aktivitas"];

    int totalTasks = listMateri.length + 14;
    int totalCompleted = materiCount + quizCount;

    setState(() {
      userName = savedName;
      completedCount = materiCount;
      completedQuizCount = quizCount;
      totalScore = points;
      progressPercent = totalTasks == 0 ? 0.0 : totalCompleted / totalTasks;
      userActivities = savedActivities;
    });
  }

  void _recordActivity(String newActivity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> activities = prefs.getStringList('recent_activities') ?? [];
    
    activities.insert(0, newActivity);
    
    if (activities.length > 3) {
      activities = activities.sublist(0, 3);
    }
    
    await prefs.setStringList('recent_activities', activities);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBG,
      // --- TOMBOL AI FLOATING ---
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAmber,
        elevation: 10,
        child: const Icon(Icons.psychology, color: kDarkBG, size: 30),
        onPressed: () {
          _recordActivity("Ngobrol bareng AI");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AIChatScreen()),
          );
        },
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 160.0, // FIX: Dinaikkan ke 160 biar gak luber ke bawah
            backgroundColor: kDarkBG,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16), // FIX: Diatur ulang agar posisi vertikalnya presisi
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // FIX: Dibungkus Flexible agar teks panjang otomatis mengalah dan tidak meluber
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "HALO, ${userName.toUpperCase()}!", 
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: kAmber),
                          overflow: TextOverflow.ellipsis, // Pengaman kalau nama kepanjangan
                        ),
                        const Text(
                          "Interactive Music Evolution Learning", 
                          style: TextStyle(fontSize: 8, color: Colors.white54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10), // Jarak aman antara teks dan avatar
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                      _loadData(); 
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.white10, 
                      radius: 18, 
                      child: Icon(Icons.person_rounded, color: kAmber, size: 18)
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Main Menu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 20),

                  _buildProgressCard(),
                  const SizedBox(height: 25),

                  _buildMainCard(
                    "Mulai Belajar", "Telusuri sejarah & evolusi dangdut", Icons.auto_stories, kAmber, 
                    () async {
                      _recordActivity("Membaca Materi Dangdut");
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => const MateriListScreen()));
                      _loadData();
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildMainCard(
                    "Dangdut Figures", "Kenali para legenda musik dangdut", Icons.people_alt_rounded, Colors.orangeAccent, 
                    () async {
                      _recordActivity("Melihat Profil Tokoh");
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => const FigureListScreen()));
                      _loadData();
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildSmallCard(
                          "Audio", "Dengar Sample", Icons.headset_mic, Colors.pinkAccent, 
                          () async {
                            _recordActivity("Mendengarkan Audio");
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => const MusicGalleryScreen()));
                            _loadData();
                          }
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSmallCard(
                          "Quiz", "Uji Wawasan", Icons.extension, Colors.greenAccent, 
                          () async {
                            _recordActivity("Mencoba Kuis");
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => LevelScreen()));
                            _loadData();
                          }
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                  
                  const Text("Aktivitas Terakhir", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 15),
                  
                  ...userActivities.map((activity) => _buildHistoryItem(activity, "Baru saja")).toList(),

                  const SizedBox(height: 100), // Spasi tambahan agar tidak tertutup FAB
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET HELPERS
  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Progres Belajar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text("${(progressPercent * 100).toInt()}%", style: const TextStyle(color: kAmber, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: progressPercent, minHeight: 8, backgroundColor: Colors.white10, color: kAmber),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$completedCount/${listMateri.length} Materi", style: const TextStyle(color: Colors.white54, fontSize: 11)),
              Text("$completedQuizCount/14 Kuis Sempurna", style: const TextStyle(color: Colors.white54, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          Text("Total Poin Kuis: $totalScore pts", style: const TextStyle(color: kAmber, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMainCard(String title, String sub, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withOpacity(0.8), color.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkBG)),
              Text(sub, style: const TextStyle(fontSize: 11, color: kDarkBG)),
            ])),
            Icon(icon, size: 40, color: kDarkBG),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallCard(String title, String sub, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(sub, style: const TextStyle(fontSize: 10, color: Colors.white54)),
        ]),
      ),
    );
  }

  Widget _buildHistoryItem(String activity, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          const Icon(Icons.history, color: Colors.white24, size: 18),
          const SizedBox(width: 15),
          Expanded( // Mencegah teks history kepanjangan meluber ke samping
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(activity, style: const TextStyle(color: Colors.white70, fontSize: 12), overflow: TextOverflow.ellipsis),
              Text(time, style: const TextStyle(color: Colors.white24, fontSize: 10)),
            ]),
          ),
        ],
      ),
    );
  }
}