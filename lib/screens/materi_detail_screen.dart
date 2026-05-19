import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; // Library Resmi Gemini
import '../shared.dart';
import '../data.dart';

class MateriDetailScreen extends StatelessWidget {
  final Materi materi;
  const MateriDetailScreen({super.key, required this.materi});

  // DAFTAR ISTILAH KUNCI YANG OTOMATIS BISA DI-KLIK USER UNTUK PENJELASAN LIVE AI
  static const List<String> smartTerms = [
    "Pierre Bourdieu",
    "Distingsi",
    "Orkes Melayu",
    "Koplo Speed",
    "Popdut",
    "Anti Normal",
    "Sosiokultural",
    "Stigma",
    "Cringe",
    "Low-brow",
    "Cheesy",
    "Tumbal",
    "Kasta",
    "Anomali psikologis",
    "Jamet music",
    "Flow melodic",
    "Rabbit Hole",
    "Bedroom producers",
    "Hipdut",
    "Pakem industri",
    "Urban",
    "Posisi tawar",
    "Skeptis",
    "Ego",
    "Daftar putar",
    "Onomatope",
    "Hardware upgrade",
    "Liukan suara",
    "Standar kompetensi",
    "Akses",
    "Layar tancap",
    "Maling budaya",
    "Ex-rocker",
    "Tatanan musik",
    "Distorsi",
    "Hard Reset",
    "Invasi",
    "Insting",
    "Perfeksionis",
    "Obsesif",
    "Aransemen",
    "Groovy",
    "Adrenalin",
    "Medium dakwah",
    "Branding",
    "Konservatisme",
    "Power game",
    "Intro",
    "Catchy",
    "Responsif",
    "Teatrikal",
    "Glamor",
    "Catatan kaki",
    "Pencekalan",
    "Akar rumput",
    "Kudeta estetika",
    "Hajatan",
    "Katarsis",
    "Laid back",
    "Double-kick",
    "Urgensi",
    "Urban-industrial",
    "Representasi",
    "Pusat gravitasi",
    "Sound Horeg",
    "Lihai",
    "Pedagang asongan",
    "Penjaga gerbang",
    "Marwah",
    "Erotis",
    "Bahan bakar",
    "Clash of civilizations",
    "Dipersidangkan",
    "Medan tempur",
    "Aktivis",
    "Dalil agama",
    "Rating",
    "Efek Domino",
    "Komoditas",
    "Goyang Pargoy",
    "Mekanisme demokratisasi",
    "Mika bening",
    "Fanbase",
    "Militan",
    "Algoritma manusia",
    "Viralitas",
    "Manajemen profesional",
    "Ambyar",
    "Pop-Dangdut",
    "Easy listening",
    "Ameba Pico",
    "Barrier to entry",
    "Indie",
    "Engagement",
    "Ceruk algoritma",
    "Meme",
    "Low-fi",
    "Gen Z",
    "Tatanan industri",
    "Mapan",
    "Bastardisasi musikal",
    "Pemusik puritan",
    "Linier",
    "Remeh",
    "Refleksi",
    "Hypebeast",
    "Otoritas tunggal",
    "Open source",
    "Sains",
    "Pacemaker",
    "Puzzle matematika",
    "Trance ringan",
    "Atribut gengsi",
    "Sistem saraf purba",
    "Resistensi budaya",
    "Bias",
    "Munafik",
    "Objektifikasi",
    "Patriarki",
    "Rentan",
    "Validitas performa",
    "Sektor informal Finansial",
    "Rebranding Sosial",
    "Diva Nasional",
    "Elegan",
    "Steril",
    "Katalisator",
    "Hiperlocal",
    "Monomentisasi",
    "Challenge",
    "Terfragmentasi",
    "Terotomatisasi",
    "Biduan Virtual",
    "Metaverse",
    "Hyperglobal",
    "Fusion",
    "World music",
    "Oversaturasi",
    "Krusial",
    "Server",
    "Web3",
    "Transmisi data saraf",
    "Subversi digital",
    "Hibriditas budaya",
    "Kreativitas",
    "Vibe",
    "Chaos",
    "Hook",
    "BPM",
    "Synthesizer",
    "Green screen",
    "AdSense",
    "Flashdisk",
    "VCD"
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> lines = materi.content.split('\n');

    return Scaffold(
      backgroundColor: kDarkBG,
      body: RepaintBoundary(
        child: Stack(
          children: [
            CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  stretch: false,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  backgroundColor: kDarkBG,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      materi.imageAsset,
                      fit: BoxFit.cover,
                      cacheWidth: 500,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.white10,
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.white24, size: 80),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(materi.title, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(materi.subtitle, style: const TextStyle(color: kAmber, fontSize: 16)),
                        const SizedBox(height: 20),
                        Container(height: 1, color: Colors.white10),
                        const SizedBox(height: 20),
                        
                        // INFO BANNER KECIL UNTUK PANDUAN USER
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: kAmber.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kAmber.withOpacity(0.2)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.auto_awesome, color: kAmber, size: 16),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Tips: Klik istilah berwarna emas untuk penjelasan instan dari Bang Jago.",
                                  style: TextStyle(color: Colors.white70, fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final String line = lines[index].trim();
                        if (line.startsWith('#')) {
                          return _buildSubHeading(line.replaceFirst('#', '').trim());
                        } else if (line.isNotEmpty) {
                          return _buildInteractiveParagraph(context, line);
                        } else {
                          return const SizedBox(height: 10);
                        }
                      },
                      childCount: lines.length,
                      addRepaintBoundaries: true,
                      addAutomaticKeepAlives: true,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: kDarkBG.withOpacity(0.95),
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                child: _MarkAsReadButton(materi: materi),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: kAmber, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.5),
      ),
    );
  }

  // PARSER PARAGRAF INTERAKTIF: FIX BUG PARTIAL MATCHING PAKE WORD BOUNDARY (\b)
  Widget _buildInteractiveParagraph(BuildContext context, String text) {
    List<InlineSpan> spans = [];
    
    // Proteksi Regex: Memastikan kata kunci harus berdiri sendiri, gak memotong kata lain
    String pattern = smartTerms.map((term) => "\\b${RegExp.escape(term)}\\b").join('|');
    RegExp regExp = RegExp("($pattern)", caseSensitive: false);
    
    text.splitMapJoin(
      regExp,
      onMatch: (Match match) {
        String matchText = match.group(0)!;
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () => _showAiExplanationSheet(context, matchText),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: kAmber.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    matchText,
                    style: const TextStyle(
                      color: kAmber,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        return '';
      },
      onNonMatch: (String nonMatch) {
        spans.add(TextSpan(text: nonMatch));
        return '';
      },
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: const TextStyle(color: Color(0xFFD1D1D1), fontSize: 15, height: 1.6, fontFamily: 'Roboto'),
          children: spans,
        ),
      ),
    );
  }

  // BOTTOM SHEET INTERAKTIF UNTUK MENAMPILKAN JAWABAN GEMINI API
  void _showAiExplanationSheet(BuildContext context, String term) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16161C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.55,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kAmber.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.psychology_rounded, color: kAmber, size: 24),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(term.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text("Dari Bang Jago", style: TextStyle(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white38),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Container(height: 1, color: Colors.white10),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: FutureBuilder<String>(
                    future: _fetchGeminiData(term), 
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildShimmerLoading();
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return const Text(
                          "Gagal terhubung ke bang Jago. Coba cek kuota atau koneksi internet lu, Ki.",
                          style: TextStyle(color: Colors.redAccent, fontSize: 14, height: 1.5),
                        );
                      }
                      
                      return Text(
                        snapshot.data!,
                        style: const TextStyle(color: Color(0xFFE2E2E2), fontSize: 14, height: 1.6),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // MESIN UTAMA: SEAKAR MANDIRI LANGSUNG NEMBAK API GOOGLE GEMINI LIVE
  Future<String> _fetchGeminiData(String term) async {
    const String apiKey = "AIzaSyBShVx7AHQSrT9LRPbUWkW59o1xcLE0s8g"; 

    try {
      // 1. Inisialisasi Model Resmi Gemini 2.5 Flash
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      // 2. Setting Prompt Spesifik untuk Konteks Materi Sejarah Dangdut
      final prompt ="Lu adalah Bang Jago, pakar sejarah musik dangdut Indonesia. "
          "Jelasin konsep sosiokultural, tokoh yang perngaruh, bahasa yang sulit di pahami atau istilah musik dangdut '$term' ini ke audies yang kurang paham tentang dangdut dan bahasa gaul, masih pemula "
          "dengan gaya mentor yang santai, gaul, informatif, asyik, tapi tetep akademis dan kurangin pengunaan kata sulit agar penjelasanya mudah di cerna pemula ini. "
          "Batasi penjelasan lu maksimal 3 atau 4 kalimat pendek saja agar pas di layar HP.";

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      } else {
        throw Exception("Response kosong");
      }
      
    } catch (e) {
      // ENGINE CADANGAN LOKAL (FALLBACK): Aktif otomatis jika kuota API habis / offline pas demo
      Map<String, String> localExplanations = {
        "Pierre Bourdieu": "Sosiolog ternama asal Prancis yang mencetuskan teori penting seputar 'Selera Musik'. Bourdieu berargumen bahwa selera budaya bukanlah bakat alami bawaan lahir, melainkan instrumen dinamis yang dibentuk kelas sosial untuk menegaskan posisi hierarki mereka di masyarakat (Distingsi). Konsep ini pas banget buat membedah kenapa dangdut dulunya dituduh 'kampungan' oleh kelas elit tertentu.",
    "Distingsi": "Ini istilah buat strategi orang kelas atas yang pengen pamer kalau selera mereka lebih keren dan modern dibanding orang biasa. Intinya sih, ini cara buat gengsi-gengsian lewat musik atau hobi yang dipilih. Konsep ini bikin kita paham kenapa ada orang yang aslinya suka dangdut tapi jaim buat ngaku.",
    "Orkes Melayu": "Kalau lo mau tahu, ini dia format musik legendaris zaman dulu yang jadi kakek buyutnya dangdut hari ini. Musiknya cenderung sopan, puitis, kalem, dan pakai alat kayak biola sama akordeon. OM inilah yang jadi wadah eksperimen awal sebelum bunyi kendang modern lahir.",
    "Koplo Speed": "Nah, kalau ini istilah buat percepatan tempo musik dangdut yang bikin ketukannya jadi super kencang. Kecepatan ini didapat dari teknik tabuhan kendang yang rapat dan serba ngebut. Ritme ini sengaja didesain buat memprovokasi badan lo biar otomatis pengen langsung joget.",
    "Popdut": "Genre hasil kawin silang yang masukin kelenturan cengkok dangdut ke dalam aransemen musik pop modern. Tujuannya jelas, biar musik dangdut terdengar lebih santai dan ramah di kuping masyarakat luas. Formula ini bikin lo gak perlu jadi fans dangdut garis keras buat bisa nikmatin lagunya.",
    "Anti Normal": "Kolektif musik internet asal Jogja-Solo yang berani ngacak-ngacak aturan main industri musik arus utama. Mereka tumbuh mandiri dari komunitas digital kayak Discord dan SoundCloud tanpa butuh modal label raksasa. Gerakan mereka ngebuktiin kalau karya keren itu gak harus selalu ngikutin standar Jakarta.",
    "Sosiokultural": "Istilah akademis buat ngegambarin hubungan erat antara kondisi nyata masyarakat sama produk budaya yang lahir. Contohnya, bagaimana lelahnya kehidupan buruh pabrik ikut membentuk lahirnya musik koplo yang serba cepat. Jadi, musik itu bukan cuma soal nada, tapi cerminan realitas hidup kita.",
    "Stigma": "Ini adalah stempel atau label negatif yang telanjur melekat pada sesuatu di mata masyarakat. Dangdut lama banget kena stigma ini karena visualnya dituduh vulgar dan liriknya dianggap murahan. Efeknya, genre ini sempat lama ditaruh di posisi paling bawah dalam kasta musik.",
    "Cringe": "Bahasa gaul buat reaksi fisik berupa rasa geli atau gak nyaman pas kita ngelihat hal yang dianggap norak. Di dunia sosiologi, rasa geli ini muncul karena selera lo lagi nolak hal yang dianggap beda kelas. Contohnya, pas orang kota merasa aneh dengerin dentum kendang yang tiba-tiba berputar.",
    "Low-brow": "Sebutan buat produk kebudayaan populer yang dianggap 'rendah' atau remeh sama kaum elit. Kebalikan dari seni kelas atas, budaya jenis ini dinilai gak butuh mikir keras buat dinikmati. Dangdut sempat lama terjebak di kotak ini sebelum akhirnya internet meruntuhkan sekatnya.",
    "Cheesy": "Istilah buat lirik lagu atau gaya panggung yang dinilai terlalu murahan, lebay, atau norak. Meskipun sering diejek, gaya yang apa adanya ini sebenarnya punya daya pikat kuat karena jujur banget. Banyak orang diam-diam suka justru karena lagunya terasa sangat menghibur.",
    "Tumbal": "Kondisi di mana dangdut dijadikan korban penghakiman dalam permainan gengsi masyarakat. Banyak orang sengaja ngasih stempel buruk ke dangdut cuma demi bikin posisi selera mereka kelihatan lebih tinggi. Padahal, mereka cuma takut dicap gak keren kalau ketahuan ikut bergoyang.",
    "Kasta": "Sistem tingkatan kaku yang tanpa sadar dipakai orang buat membedakan kualitas manusia dari musiknya. Kaum elit sering bikin aturan seolah musik pop atau barat itu kasta atas, sedangkan dangdut kasta bawah. Padahal pas kendang mulai bunyi, sistem saraf lo gak kenal sama sistem kasta ini.",
    "Anomali psikologis": "Kondisi aneh di mana isi kepala lo menolak suatu musik karena gengsi, tapi tubuh lo malah otomatis menikmatinya. Ini sering terjadi pas lo dengerin lagu yang dicap norak tapi ternyata ketukannya enak banget. Otak lo bingung karena sistem dopamin ternyata gak peduli sama gengsi sosial lo.",
    "Jamet music": "Label internet buat melabeli musik yang dianggap identik sama gaya sub-kultur akar rumput. Musik jenis ini biasanya pakai percampuran bahasa yang acak-acakan serta autotune yang sangat ekstrem. Walau awalnya dihujat, genre ini malah sering viral karena bikin candu para netizen.",
    "Flow melodic": "Kelancaran dan keindahan ayunan nada saat seorang musisi membawakan lirik atau rima rap. Dalam hipdut, aliran melodi yang pas bikin ketukan lagu terasa sangat dinamis dan hidup. Komponen ini penting banget biar lagu yang penuh eksperimen tetep enak didengar telinga pemula.",
    "Rabbit Hole": "Istilah buat momen di mana lo keasyikan menjelajah internet sampai masuk terlalu dalam ke sub-kultur baru. Berawal dari iseng klik satu video, lo malah berakhir tahu banyak hal unik yang belum pernah lo denger. Petualangan digital inilah yang bikin lo nemu musik-musik keren di luar jalur utama.",
    "Bedroom producers": "Sebutan buat anak muda kreatif yang memproduksi musik keren modal laptop dari dalam kamar tidur mereka. Mereka gak butuh studio mahal atau modal besar dari perusahaan rekaman raksasa. Cukup pakai software digital, mereka sudah bisa bikin lagu hits yang siap bersaing di Spotify.",
    "Hipdut": "Sub-genre baru hasil perkawinan silang antara musik Hip-hop dan Dangdut. Ciri khasnya adalah pembawaan rima rap yang cepat, autotune tebal, tapi di tengahnya ada ketukan kendang pargoy. Ini adalah musik eksperimental yang lincah banget merajai lantai dansa internet.",
    "Pakem industri": "Aturan main lama yang kaku dan biasanya ditetapkan oleh perusahaan rekaman besar di kota besar. Pakem ini biasanya mendikte lagu seperti apa yang boleh viral atau dianggap keren. Untungnya, era internet bikin musisi daerah bisa bebas bikin karya tanpa perlu ikut aturan ini.",
    "Urban": "Kultur atau gaya hidup masyarakat yang tinggal di wilayah perkotaan besar. Anak muda urban biasanya punya akses informasi global yang luas, tapi seleranya sering dibatasi aturan gengsi kelompoknya. Musik dangdut modern hadir buat mencairkan kesepian dan ketegangan hidup kaum kota ini.",
    "Posisi tawar": "Kekuatan kultural yang bikin suatu kelompok punya harga diri dan gak gampang diremehkan kelompok lain. Dengan bikin karya yang keren, musisi daerah punya posisi tawar yang tinggi di industri musik. Mereka membuktikan kalau gaya lokal juga bisa bikin orang kota ikut takjub.",
    "Skeptis": "Sikap ragu, sinis, atau meremehkan sesuatu sebelum benar-benar mencoba mengetahuinya. Orang yang skeptis biasanya langsung mencap dangdut sebagai musik sampah tanpa mau memahami sejarahnya. Padahal kalau ego mereka diturunkan sejenak, mereka bakal kagum sama keunikan musik ini.",
    "Ego": "Rasa gengsi dalam diri yang bikin seseorang menolak buat ngakuin kekuatan ritme musik tertentu. Banyak orang menahan badannya biar gak joget hanya demi menjaga citra diri yang kaku. Menurunkan ego sejenak bakal bikin lo sadar kalau musik itu gunanya buat merayakan kebahagiaan.",
    "Daftar putar": "Kumpulan lagu atau *playlist* musik digital yang kita dengerin lewat aplikasi streaming. Sayangnya, daftar putar ini sering dipakai orang buat ngehakimi atau menilai kasta sosial orang lain. Padahal, isi *playlist* itu hak pribadi dan bentuk kejujuran berekspresi tiap orang.",
    "Onomatope": "Sebutan ilmiah buat kata yang tercipta dari tiruan bunyi asli benda tersebut. Istilah kata 'Dangdut' sendiri sebenarnya adalah onomatope yang meniru bunyi ketukan kendang India. Siapa sangka, kata yang lahir dari tiruan bunyi ini sekarang jadi identitas musik raksasa.",
    "Hardware upgrade": "Pembaruan atau peningkatan kualitas alat musik fisik yang dipakai oleh para musisi. Contohnya, saat Orkes Melayu mengganti perkusi lama dengan alat musik modern seperti gitar elektrik. Upgrade ini bikin musik rakyat punya energi baru yang lebih bertenaga buat menggetarkan panggung.",
    "Liukan suara": "Teknik vokal naik-turun dalam satu helaan napas yang menjadi ciri khas penyanyi dangdut. Liukan suara yang rumit ini lahir dari pengaruh seni vokal musik padang pasir. Teknik ini bikin penyanyi dangdut punya standar kualitas yang jauh lebih berat dibanding pop barat.",
    "Standar kompetensi": "Tolok ukur kemampuan berat yang wajib dimiliki oleh seorang penyanyi dangdut profesional. Di genre ini, lo nggak bisa cuma modal suara merdu atau bisa nyanyi standar saja. Lo harus mutlak menguasai kontrol napas dan kelihaian cengkok yang super rumit.",
    "Akses": "Kemudahan jangkauan media penyebaran yang bikin sebuah karya bisa cepat didengar masyarakat luas. Di zaman dulu, akses utama rakyat hanyalah lewat frekuensi tunggal RRI dan layar tancap. Keterbatasan saluran zaman dulu justru bikin seluruh pelosok negeri bisa kompak menyukai lagu yang sama.",
    "Layar tancap": "Bioskop terbuka gratis di lapangan yang memutarkan film India secara massal di masa lalu. Media ini menjadi senjata ampuh yang bikin masyarakat bawah jatuh cinta pada musik Bollywood. Dari keseruan layar tancap inilah rakyat mulai mencari-cari lagu sejenis di radio.",
    "Maling budaya": "Metafora gaul buat ngegambarin kreativitas musisi kita yang mahir mengadopsi berbagai budaya asing. Dangdut itu lahir karena musisi kita pintar mengambil elemen musik Barat, India, dan Arab secara kreatif. Semua elemen itu lalu diaduk jadi satu wadah lokal yang rasanya Indonesia banget.",
    "Ex-rocker": "Sebutan sejarah buat Rhoma Irama yang sebelum menjadi Raja Dangdut adalah anak band rock. Latar belakang rocker inilah yang bikin dia punya insting tajam buat ngubah musik melayu. Berkat dia, dangdut modern lahir dengan energi yang jauh lebih bertenaga.",
    "Tatanan musik": "Struktur atau tatanan industri musik nasional yang mengatur tren lagu di suatu masa. Tatanan yang kaku ini sering kali berhasil diacak-acak oleh inovasi baru para musisi akar rumput. Mulai dari revolusi Soneta hingga gerakan indie, tatanan musik selalu berubah mengikuti zaman.",
    "Distorsi": "Efek suara gitar elektrik yang kotor, gahar, dan biasanya identik dengan musik rock. Rhoma Irama secara nekat memasukkan efek distorsi ini ke dalam struktur musik melayu tradisional. Inovasi berani ini bikin musik dangdut modern punya power buat menggetarkan lapangan luas.",
    "Hard Reset": "Langkah radikal buat merombak total sistem aransemen musik lama yang dinilai ketinggalan zaman. Ketika orkes melayu mulai dianggap terlalu lembek, Rhoma Irama melakukan langkah berani ini. Dia memasukkan instrumen modern agar musik rakyat punya daya saing tinggi.",
    "Invasi": "Masuknya tren kebudayaan luar secara masif yang sempat mengancam kelestarian musik lokal. Contohnya, saat band-band rock Barat menyerbu telinga anak muda Indonesia di awal era 70-an. Invasi ini memaksa musisi dangdut buat mutar otak agar lagunya nggak dilupakan zaman.",
    "Insting": "Kepekaan alami seorang musisi dalam membaca arah selera pasar dan perkembangan teknologi audio. Insting yang tajam bikin seorang seniman tahu kapan harus memperbarui gaya musiknya. Berkat insting inilah, dangdut selalu sukses bermutasi mengikuti selera tiap generasi.",
    "Perfeksionis": "Sifat seseorang yang sangat obsesif dalam mengejar kesempurnaan di setiap detail pekerjaan. Karakter perfeksionis Rhoma Irama bikin Soneta Group punya disiplin latihan yang sangat gila. Hasilnya, tiap instrumen dari suling sampai bass bisa kawin dengan sangat presisi.",
    "Obsesif": "Sikap fokus yang berlebihan terhadap keteraturan, detail aransemen, hingga keserasian visual panggung. Sifat obsesif para pelopor dangdut ini berguna buat menaikkan kelas musik rakyat. Mereka ingin membuktikan kalau musisi jalanan juga bisa tampil rapi, mewah, dan bermartabat.",
    "Aransemen": "Struktur atau susunan penataan alat musik dalam sebuah lagu agar terdengar harmonis. Contoh aransemen jenius dangdut adalah mengawinkan lengkingan suling bambu dengan raungan gitar rock. Penataan yang pas bikin lagu terdengar seimbang dan asyik dinikmati.",
    "Groovy": "Kualitas irama musik yang terasa sangat asyik, ritmis, dan punya alunan yang bikin candu. Cabikan bass yang *groovy* adalah modal utama lagu dangdut buat mengunci perhatian penonton. Ketukan jenis ini otomatis memicu kaki dan tubuh kita buat langsung ikut bergoyang.",
    "Adrenalin": "Hormon dalam tubuh yang memicu pacuan energi, semangat meluap, dan rasa gembira penonton. Aransemen dangdut modern yang bertenaga emang dirancang buat menaikkan adrenalin ini. Efeknya, penonton di lapangan luas bisa kompak bergoyang dengan energi yang meledak-ledak.",
    "Medium dakwah": "Strategi memfungsikan musik sebagai sarana buat menyebarkan ajaran agama dan nasihat moral. Rhoma Irama mengubah dangdut jadi medium dakwah dengan memasukkan lirik kritik sosial dan miras. Cara cerdik ini sukses menaikkan derajat dangdut di mata kaum elit.",
    "Branding": "Upaya membangun citra atau identitas baru agar suatu produk dinilai positif oleh publik. Dangdut melakukan *rebranding* dengan menyelipkan unsur pesan moral dan pakaian panggung yang rapi. Taktik ini berhasil mengubah cap dangdut dari musik jalanan menjadi musik bermartabat.",
    "Konservatisme": "Paham kaku yang berusaha keras menjaga nilai-nilai moral lama dan menolak perubahan radikal. Di dunia dangdut, paham ini sempat bikin para tetua bertindak sebagai polisi moral bagi genrenya. Akibatnya, sempat terjadi benturan keras saat gaya baru yang lebih berani muncul dari daerah.",
    "Power game": "Pertempuran tawar-menawar pengaruh budaya buat ngebuktiin siapa yang punya basis massa paling besar. Dangdut memenangkan *power game* ini lewat film layar lebar dan jutaan penonton fanatik di lapangan. Mereka sukses ngebuktiin kalau musik rakyat adalah pemilik suara mayoritas di negeri ini.",
    "Intro": "Bagian awal atau melodi pembuka sebuah lagu sebelum penyanyi mulai masuk membawakan lirik. Pembuatan intro dalam dangdut modern wajib hukumnya dibuat sangat menarik dan nendang. Gunanya jelas, buat langsung memikat perhatian pendengar dalam beberapa detik pertama.",
    "Catchy": "Karakteristik musik yang ramah di telinga, gampang diingat, dan langsung nempel di kepala. Lagu yang *catchy* biasanya punya melodi atau lirik sederhana yang bikin orang kepikiran terus. Ini rahasia utama kenapa lagu dangdut bisa cepat viral di kalangan masyarakat luas.",
    "Responsif": "Sifat instrumen musik yang mampu bersahut-sahutan secara pas menanggapi melodi vokal. Isian suling dangdut dibuat responsif agar lagu terasa lebih hidup dan komunikatif. Komponen ini bikin penyanyi dan musik di belakangnya terlihat kompak saling mendukung.",
    "Teatrikal": "Gaya pertunjukan panggung yang penuh drama, ekspresif, dan disajikan dengan kostum glamor. Aksi teatrikal musisi dangdut bikin konser musik bukan cuma enak didengar, tapi juga seru ditonton. Visual yang totalitas inilah yang bikin penonton betah berdiri lama di depan panggung.",
    "Glamor": "Gaya panggung yang gemerlap, mewah, dan menggunakan kostum desainer yang sangat memikat. Elemen glamor ini dipakai biduan daerah buat menaikkan kelas pertunjukan mereka. Tampilan berkelas ini dipakai sebagai strategi bertahan hidup agar dangdut diterima kaum menengah.",
    "Catatan kaki": "Metafora buat posisi remeh yang tidak dianggap penting dalam catatan sejarah. Dangdut diprediksi hanya bakal jadi catatan kaki sejarah musik melayu jika tidak dirombak total. Berkat keberanian para pelopornya, genre ini justru melompat jadi raksasa industri musik nasional.",
    "Pencekalan": "Tindakan pelarangan tampil yang dilakukan oleh pihak berwenang atau stasiun televisi. Lirik dangdut yang terlalu berani mengkritik pemerintah di era Orde Baru biasanya langsung kena pencekalan. Namun di era internet, pencekalan justru sering jadi iklan gratis yang bikin artis makin terkenal.",
    "Akar rumput": "Sebutan buat lapisan masyarakat kelas bawah, seperti buruh pabrik, supir truk, dan petani. Mereka adalah penggerak organik sekaligus nyawa utama yang menghidupi industri dangdut daerah. Tanpa dukungan kaum akar rumput, dangdut tidak akan punya kekuatan sebesar sekarang.",
    "Kudeta estetika": "Momen di mana standar keindahan musik daerah berhasil merebut dominasi dari kota besar. Ketika Jakarta sibuk mendikte musik yang sopan, daerah pinggiran malah meledak dengan gaya koplo yang liar. Gerakan ini membuktikan kalau selera rakyat bawah juga bisa memimpin pasar nasional.",
    "Hajatan": "Acara pesta rakyat di pedesaan yang menjadi panggung utama perputaran ekonomi musik koplo. Dari panggung hajatan di tengah sawah inilah ekosistem dangdut daerah bisa hidup mandiri. Hajatan terbukti menyediakan banyak lapangan kerja buat pemuda dan pedagang lokal.",
    "Katarsis": "Ruang pelampiasan emosi bagi masyarakat buat melepaskan segala beban dan penatnya hidup. Rakyat bawah butuh katarsis lewat joget dangdut koplo agar bisa sejenak melupakan himpitan ekonomi. Di sini, ketukan kendang berfungsi sebagai obat penyembuh stres yang paling manjur.",
    "Laid back": "Karakteristik ketukan musik yang temponya stabil, santai, kalem, dan tidak terburu-buru. Gaya *laid back* ini merupakan ciri khas utama dari aransemen musik dangdut klasik zaman dulu. Ketukan santai ini sangat kontras dengan era koplo modern yang temponya serba ngebut.",
    "Double-kick": "Teknik tabuhan ganda pada kendang koplo yang bikin temponya naik secara drastis. Teknik sinkopasi yang rumit ini menciptakan sensasi musik yang serba cepat dan buru-buru. Ketukan *double-kick* inilah yang jadi rahasia utama kenapa koplo punya energi meluap-luap.",
    "Urgensi": "Sensasi keterburuan hidup yang dirasakan oleh masyarakat akibat tuntutan ekonomi. Ketukan kendang koplo yang serba cepat sengaja dibuat buat mencerminkan sensasi urgensi ini. Musik ini mewakili detak jantung orang-orang yang harus bertahan hidup di kerasnya persaingan.",
    "Urban-industrial": "Kondisi lingkungan masyarakat yang tinggal di daerah penyangga kota besar dan bekerja di sektor pabrik. Ritme hidup kaum urban-industrial ini sangat keras, monoton, dan diburu oleh jam kerja. Musik koplo hadir sebagai hiburan hyperlocal yang paling paham dengan kerasnya hidup mereka.",
    "Representasi": "Simbol atau cerminan nyata dari kondisi kehidupan kelompok masyarakat penikmatnya. Visual video klip dangdut lama adalah bentuk representasi dari kemewahan impian masyarakat bawah. Musik ini dicintai karena berani menjadi perwakilan suara orang-orang yang dipinggirkan.",
    "Pusat gravitasi": "Titik kumpul utama tempat berputarnya roda ekonomi dan interaksi sosial masyarakat daerah. Panggung orkes koplo kampung bertindak sebagai pusat gravitasi ekonomi mandiri yang sangat kuat. Di sana, semua orang dari kru audio sampai pedagang asongan bisa kompak mencari nafkah.",
    "Sound Horeg": "Tren modifikasi sound system raksasa di Jawa yang suaranya sengaja disetel super kencang. Saking dahsyatnya suara bass yang dihasilkan, getarannya bisa dirasakan langsung di dada dan kaca rumah. Bagi pemilik orkes, investasi sound horeg senilai miliaran ini adalah soal harga diri.",
    "Lihai": "Kemampuan cerdik, cekatan, dan sangat ahli dalam mengendalikan situasi di lapangan. Contohnya adalah pembawaan seorang MC panggung yang lihai membakar semangat ribuan penonton. Kelihaian ini penting banget biar suasana konser tetap tertib tapi energinya tetap membara.",
    "Pedagang asongan": "Sektor ekonomi informal kecil yang menjual rokok atau minuman di pinggir lapangan konser. Mereka memanfaatkan kerumunan massa panggung dangdut buat menyambung napas ekonomi keluarga. Fenomena ini ngebuktiin kalau dangdut adalah jaring pengaman sosial yang nyata bagi rakyat.",
    "Penjaga gerbang": "Istilah sosiologi (*gatekeeper*) buat kaum elit industri yang hobi membatasi perkembangan suatu genre musik. Mereka sering menghujat gaya dangdut baru dari daerah karena dianggap merusak pakem lama. Hebatnya, musisi daerah tidak peduli dan terus melompati batasan para penjaga gerbang ini.",
    "Marwah": "Harga diri, kehormatan, atau martabat luhur yang dijaga ketat oleh kaum puritan. Pelopor dangdut klasik marah karena menganggap goyangan erotis koplo telah merusak marwah genre ini. Konflik marwah ini sempat memicu perang dingin kebudayaan yang sangat ramai di masanya.",
    "Erotis": "Gaya goyangan panggung yang dinilai terlalu menonjolkan sensualitas tubuh perempuan. Gaya ini sempat dilarang keras oleh lembaga sensor karena ketakutan kaum elit akan dekadensi moral. Padahal bagi biduan daerah, goyangan itu adalah teknik motorik murni buat bertahan hidup di panggung.",
    "Bahan bakar": "Metafora buat stigma buruk kaum elit yang justru diubah jadi energi kreativitas oleh musisi daerah. Alih-alih minder dituduh kampungan atau norak, musisi koplo malah makin tertantang buat tampil liar. Cacatan netizen justru diolah jadi bahan bakar utama buat bikin lagu mereka makin viral.",
    "Clash of civilizations": "Benturan budaya yang terjadi ketika dua peradaban dengan standar nilai berbeda mendadak bertemu. Ini terjadi saat performa mentah koplo daerah tiba-tiba dibawa masuk ke industri TV Jakarta yang steril. Benturan ini bikin publik kota kaget melihat ekspresi joget rakyat yang sangat agresif.",
    "Dipersidangkan": "Proses pendisiplinan nilai budaya sepihak yang dilakukan oleh kelompok penguasa terhadap daerah. Pertemuan legendaris Inul Daratista di kantor Soneta dianggap sebagai simbol persidangan ini. Di sana, pihak pusat mencoba mendikte aturan moral yang wajib dipatuhi artis daerah.",
    "Medan tempur": "Ruang kontestasi ideologi di mana tubuh perempuan kelas bawah diperebutkan oleh berbagai kepentingan. Di panggung dangdut, tubuh biduan jadi rebutan antara argumen hak agensi pekerja dengan sensor konservatif. Fenomena ini nunjukin betapa rapuhnya definisi kesopanan di masyarakat kita.",
    "Aktivis": "Kelompok masyarakat yang vokal membela hak asasi manusia, kebebasan berekspresi, dan agensi tubuh. Para aktivis perempuan pasca-Reformasi kompak membela hak biduan daerah dari tekanan sensor sepihak. Mereka menilai perempuan berhak mandiri secara ekonomi lewat bakat seninya.",
    "Dalil agama": "Argumen religius atau teks suci yang digunakan kelompok konservatif buat menekan industri hiburan. Dalil ini dipakai buat mendesak stasiun TV agar membatasi pakaian dan goyangan para biduan. Penggunaan dalil ini sering kali memicu perdebatan panjang seputar batas kesopanan publik.",
    "Rating": "Sistem penilaian angka digital yang menunjukkan jumlah penonton sebuah acara televisi. Industri TV sangat haus akan rating tinggi karena modal utama buat nyari keuntungan besar. Demi mengejar rating, pengusaha media rela menjual komoditas kontroversi panggung meskipun penuh kritik.",
    "Efek Domino": "Reaksi berantai di mana satu kejadian kecil otomatis memicu lahirnya rentetan peristiwa besar lainnya. Contohnya, upaya pencekalan satu biduan justru memicu lahirnya gelombang goyangan baru di TV. Taktik menekan musik rakyat terbukti selalu gagal karena dangdut sangat pintar bermutasi.",
    "Komoditas": "Sesuatu barang atau kontroversi bernilai ekonomi tinggi yang siap diperjualbelikan demi untung. Di dunia hiburan, isu moral dan goyangan seksi biduan sengaja dikemas jadi komoditas laku. Hal ini bikin dangdut komersial kadang dinilai menang di rating tapi kehilangan nyawa aslinya.",
    "Goyang Pargoy": "Gerakan dansa minimalis dan berulang-ulang yang sangat populer di platform digital TikTok. Goyangan pargoy lahir sebagai bentuk adaptasi tubuh penari terhadap format layar HP yang sempit. Fenomena ini nunjukin kalau ruang publik bergoyang sudah pindah dari lapangan ke digital.",
    "Mekanisme demokratisasi": "Proses pemerataan hak di mana teknologi murah bikin semua orang bisa bebas mengakses karya seni. Lewat pembajakan VCD lima ribu perak, monopoli perusahaan rekaman besar berhasil dihancurkan. Efeknya, penyanyi pelosok bisa ikutan terkenal tanpa modal promo miliaran.",
    "Mika bening": "Kemasan plastik murah seadanya yang dipakai buat membungkus kepingan VCD bajakan jalanan. Walau tampilannya sangat sederhana, mika bening ini bertindak sebagai 'media sosial' pertama bagi dangdut daerah. Lewat kepingan murah inilah rekaman konser pelosok bisa tersebar ke luar pulau.",
    "Fanbase": "Komunitas pangkalan penggemar setia yang bergerak secara militan demi mendukung idola mereka. Berbeda dengan artis kota, penyebaran lagu dangdut daerah digerakkan organik oleh kekuatan *fanbase* ini. Mereka adalah motor utama yang bikin video panggung jadul bisa mendadak viral di YouTube.",
    "Militan": "Sifat basis penggemar akar rumput yang sangat loyal, kompak, dan punya semangat juang tinggi. Mereka rela meluangkan waktu buat mengunggah, membagikan, dan membela karya musisi idolanya di internet. Kekuatan militan komunitas inilah yang bikin dangdut nggak butuh lagi restu TV kota.",
    "Algoritma manusia": "Kolektif netizen dan operator warnet zaman dulu yang kompak menentukan lagu apa yang bakal viral. Sebelum ada mesin pintar Spotify, kumpulan manusia inilah yang bertindak menyebarkan video dangdut secara organik. Selera nyata mereka jauh lebih akurat dibanding setingan mesin digital.",
    "Viralitas": "Kondisi penyebaran konten secara super cepat, masif, dan meluas di seluruh jejaring internet. Berkat adanya platform YouTube, benih-benih viralitas musik dangdut daerah mulai terbentuk. Hal ini bikin musisi kamar tidur bisa ikutan hits global modal video sederhana saja.",
    "Manajemen profesional": "Sistem pengelolaan artis secara korporat yang biasanya kaku dan serba diatur modal besar. Industri dangdut akar rumput sukses memotong jalur manajemen formal ini lewat distribusi digital mandiri. Kebebasan ini bikin musisi daerah bisa berkarya lebih jujur tanpa takut disensor produser.",
    "Ambyar": "Estetika budaya baru di mana rasa patah hati tidak lagi ditangisi sendirian di kamar. Istilah yang dipopulerkan Didi Kempot ini mengajak orang merayakan kesedihan bersama lewat joget kendang. Ini kontradiksi emosional yang bikin luka hati terasa lebih ringan karena dirayakan kolektif.",
    "Pop-Dangdut": "Genre musik cair di era modern yang menghapus sekat kaku antara musik pop dan dangdut klasik. Aransemennya dikemas lebih modern dengan sentuhan piano megah tapi nyawa kendangnya tetep ada. Formula ramah ini bikin orang kota nggak malu lagi dengerin lagu daerah.",
    "Easy listening": "Karakteristik lagu yang melodinya sangat ringan, santai, dan langsung asyik didengar sejak awal. Musik *easy listening* sengaja dibuat tanpa aransemen yang ribet agar ramah buat kuping pemula. Faktor inilah yang bikin lagu pop-dangdut zaman sekarang gampang merajai tangga lagu digital.",
    "Ameba Pico": "Game jejaring sosial virtual era awal 2010-an tempat anak muda berkumpul secara digital. Ruang internet yang acak inilah yang jadi tempat nongkrong awal para produser musik Gen Z. Dari labirin internet jadul seperti inilah benih kolektif musik independen mulai lahir.",
    "Barrier to entry": "Istilah bisnis buat hambatan modal, alat, atau jalur distribusi buat masuk ke suatu industri. Dulu, buat bikin lagu dangdut lo wajib punya studio mahal dan musisi profesional yang digaji besar. Sekarang, hambatan ini runtuh total cukup modal laptop dan software digital dari kamar.",
    "Indie": "Semangat kemandirian total seorang musisi dalam memproduksi hingga mendistribusikan karyanya. Musisi dangdut internet sekarang adalah definisi indie sejati karena bergerak tanpa modal label besar. Mereka bebas rekaman di kamar dan langsung rilis karyanya ke aplikasi streaming global.",
    "Engagement": "Tingkat keterikatan, komentar, dan interaksi yang didapat dari sebuah konten di media sosial. Uniknya internet, hujatan netizen (*overhate*) dihitung sebagai *engagement* digital yang menguntungkan. Semakin ramai dihujat, algoritma mesin justru bakal bikin lagu itu makin tersebar luas.",
    "Ceruk algoritma": "Sudut-sudut ruang digital tersembunyi tempat berkumpulnya kelompok netizen dengan minat spesifik. Lagu eksperimental dangdut menyebar lewat ceruk-ceruk internet ini berkat bantuan kekuatan komunitas digital. Hal ini bikin lagu yang awalnya asing bisa mendadak masuk ke FYP media sosial lo.",
    "Meme": "Unit konten humor berbalut ironi yang gampang diduplikasi dan disebarkan netizen di internet. Komunitas dangdut internet memakai lelucon meme buat bikin ikatan kelompok mereka makin kompak. Kreativitas meme ini bikin musik yang awalnya dicap aneh terasa asyik buat diikutin.",
    "Low-fi": "Estetika kualitas audio atau video beresolusi rendah yang dibuat dengan budget seadanya. Meskipun kualitasnya dianggap 'rusak', visual *low-fi* sengaja dipakai buat ngasih kesan otentik. Gaya ini justru digemari Gen Z karena dirasa paling jujur mewakili keganjilan hidup.",
    "Gen Z": "Generasi muda digital asli yang tumbuh besar bersama berkembangnya logika internet yang acak. Karakteristik utama Gen Z adalah mereka menolak batasan kaku antara musik berkelas dan norak. Mereka bebas dengerin K-Pop di pagi hari dan nutup malam pakai koplo paling kencang.",
    "Tatanan industri": "Sistem pasar musik arus utama yang seleranya didominasi oleh standar kota metropolitan. Tatanan yang sudah mapan puluhan tahun ini mendadak goyah akibat digempur musisi internet daerah. Modal nekat dan keunikan gaya terbukti sukses mengacak-acak pasar musik nasional.",
    "Mapan": "Kondisi industri musik jalur utama yang sistem bisnisnya sudah stabil dan berjalan rapi puluhan tahun. Sayangnya, kemapanan ini bikin lagu-lagu di TV jadi terdengar seragam dan membosankan. Kehadiran musisi kamar tidur yang aneh justru mendobrak kemapanan itu agar musik kembali dinamis.",
    "Bastardisasi musikal": "Metafora akademis buat pencampuran ekstrem antar genre musik yang dilakukan secara sengaja. Kaum puritan menganggap gaya ini sebagai pelecehan terhadap struktur kemurnian musik lama. Tapi buat anak muda, ini adalah bentuk kejujuran berekspresi tanpa batasan kaku.",
    "Pemusik puritan": "Kelompok musisi senior yang kaku dan sangat menjaga kemurnian aturan struktur musik lama. Mereka menganggap mencampur dangdut dengan rap atau EDM sebagai sebuah penghinaan besar. Kaum puritan lupa kalau kekuatan utama dangdut justru ada pada sifatnya yang adaptif.",
    "Linier": "Karakteristik alur penulisan lirik lagu yang ceritanya lurus, runtut, berurutan, dan serius. Berbeda dengan dangdut lama yang alurnya linier, musik generasi sekarang liriknya serba acak. Mereka lebih suka menulis tentang hal-hal remeh yang terjadi di keseharian.",
    "Remeh": "Hal-hal kecil di keseharian yang dianggap tidak penting atau kurang bernilai intelektual. Uniknya, lirik dangdut modern justru fokus mengangkat isu remeh dan kata absurd ini. Pendekatan santai ini dipilih karena paling pas buat menertawakan kerasnya dunia luar.",
    "Refleksi": "Cerminan nyata dari kondisi psikologis atau tren budaya yang sedang terjadi di masyarakat. Penggunaan lirik dangdut yang penuh ironi merupakan bentuk refleksi dari cara Gen Z bertahan hidup. Mereka memilih menghadapi dunia yang makin kacau dengan cara menertawakannya lewat lagu.",
    "Hypebeast": "Bahasa gaul buat anak muda kota yang gayanya sangat berkiblat pada tren fashion mahal. Dangdut modern sukses menghapus batasan gengsi kelompok ini lewat aransemen pasca-genre. Hasilnya, lo bisa tetep tampil sekeren anak *hypebeast* tapi nggak malu buat joget kendang.",
    "Otoritas tunggal": "Kekuasaan penuh yang dipegang satu kelompok buat mendikte aturan benar-salah dalam sebuah genre. Dulu, 'polisi moral' industri memegang kendali penuh atas wajah musik dangdut nasional. Era internet sukses meruntuhkan otoritas tunggal itu agar semua orang bebas berkarya.",
    "Open source": "Istilah komputer buat sistem sumber terbuka yang kodenya bebas dimodifikasi oleh siapa saja. Dangdut kini dianggap sebagai kebudayaan *open source* karena bebas dirombak musisi mana pun. Sifat terbuka inilah yang bikin nyawa dangdut tetep eksis melampaui zaman.",
    "Sains": "Pendekatan ilmu pengetahuan logis buat membedah fenomena yang terjadi di sekitar kita. Dalam buku lo, dangdut dibedah lewat kacamata sains buat nyari tahu kerja otak pendengarnya. Sains ngebuktiin kalau tubuh kita emang diprogram alami buat merespons kendang.",
    "Pacemaker": "Alat pemicu atau pengatur detak konstan yang mengendalikan ritme kerja suatu sistem. Ketukan berulang instrumen kendang dangdut bertindak layaknya sebuah pacemaker bagi otak kita. Ritme konstan ini langsung mengambil alih kendali sistem gerak tanpa kita sadari.",
    "Puzzle matematika": "Metafora buat kerumitan struktur ketukan musik yang polanya melompat-lompat penuh kejutan. Ritme kendang dangdut adalah puzzle matematika yang diselesaikan oleh tubuh lewat gerakan. Saat otak lo berhasil menebak pola ketukannya, lo bakal ngerasa puas banget.",
    "Trance ringan": "Kondisi psikologis di mana fokus kesadaran lo menurun akibat terhipnotis ritme repetitif. Dentum kencang sound system dangdut bisa memicu kondisi trance ringan ini di lapangan luas. Efeknya, lo bakal melupakan sejenak beban pikiran dan fokus total buat menggerakkan badan.",
    "Atribut gengsi": "Simbol status sosial, seperti jabatan atau kekayaan, yang bikin manusia merasa kaku. Di depan panggung dangdut, semua atribut gengsi ini otomatis runtuh lebur jadi satu. Orang dari berbagai kelas sosial bisa kompak melepas gengsinya demi bergoyang bersama.",
    "Sistem saraf purba": "Bagian terdalam dari otak manusia yang mengatur emosi dasar dan gerakan refleks tubuh. Kendang dangdut bekerja sangat efektif karena menyerang langsung ke sistem saraf purba ini. Makanya, selera lo bisa bohong lewat gengsi, tapi saraf lo nggak akan bisa bohong.",
    "Resistensi budaya": "Bentuk perlawanan diam-diam masyarakat bawah terhadap aturan kaku kelompok berkuasa. Bagi kaum buruh kasar, bergoyang di panggung dangdut adalah cara mereka merebut kembali kendali tubuhnya. Goyangan adalah ritual buat bilang kalau mereka berdaulat atas dirinya sendiri.",
    "Bias": "Sikap ketidakadilan yang condong memihak satu kelompok tertentu karena adanya kepentingan. Standar kesopanan yang dibuat kaum elit sering kali bias karena cuma menyudutkan budaya rakyat. Mereka mencap goyang kampung sebagai hal norak tapi memuji dansa ballroom sebagai seni luhur.",
    "Munafik": "Sikap berpura-pura mulia di depan publik padahal perilakunya sendiri tidak mencerminkan hal itu. Penjaga moral TV sering dicap munafik karena sibuk melarang goyangan biduan di depan kamera. Padahal di balik layar, mereka tetep memanfaatkan sensualitas visual demi meraup untung iklan.",
    "Objektifikasi": "Tindakan merendahkan manusia dengan cara memandangnya sebagai objek visual pemuas hasrat saja. Di panggung dangdut, biduan sering mengalami objektifikasi akibat tatapan mata penonton pria. Tantangan berat inilah yang harus dilawan para penyanyi perempuan lewat kualitas karyanya.",
    "Patriarki": "Sistem sosial kaku yang menempatkan posisi laki-laki sebagai pemegang kendali kekuasaan tertinggi. Dalam struktur patriarki, biduan perempuan sering terjebak distigma negatif di kehidupan nyata. Panggung dangdut hadir buat mendobrak dominasi itu lewat kemandirian finansial biduan.",
    "Rentan": "Kondisi posisi seseorang yang tidak aman dan gampang terkena dampak buruk lingkungan. Penyanyi dangdut perempuan posisinya sangat rentan karena risiko pelecehan di atas panggung. Ketangguhan mereka dalam menghadapi risiko inilah yang bikin roda dangdut tetep bisa berputar.",
    "Validitas performa": "Bukti nyata kesuksesan seorang seniman dalam menguasai dan menghibur penontonnya. Bagi biduan akar rumput, banyaknya uang saweran yang didapat adalah simbol validitas performa ini. Saweran nunjukin kalau mereka lihai membaca psikologi massa di bawah panggung.",
    "Sektor informal": "Lapangan pekerjaan mandiri di masyarakat yang dijalankan tanpa adanya ikatan kontrak kantor formal. Menjadi penyanyi, pemain keyboard, atau kru audio orkes adalah contoh sektor informal dangdut. Sektor ini terbukti sukses menyelamatkan jutaan pemuda desa dari kemiskinan.",
    "Finansial": "Segala hal yang berkaitan dengan kondisi keuangan, modal usaha, atau pendapatan ekonomi. Panggung dangdut sering jadi batu loncatan berharga bagi perempuan daerah buat mandiri secara finansial. Dari hasil menyanyi, mereka sukses membiayai sekolah adik hingga membangun rumah.",
    "Rebranding Sosial": "Strategi merombak total gaya panggung agar status sosial artis naik kelas di mata publik. Biduan modern melakukan *rebranding* dengan mengubah pakaian seksi menjadi gaun elegan ala idola K-Pop. Taktik cerdik ini dipakai buat menghancurkan stigma buruk penyanyi murahan.",
    "Diva Nasional": "Sebutan kehormatan buat penyanyi perempuan papan atas yang prestasinya diakui secara nasional. Transformasi biduan dari penyanyi jalur pantura menjadi diva nasional membuktikan kelas dangdut. Mereka membuktikan kalau musik rakyat bisa tampil terhormat di gedung mewah.",
    "Elegan": "Gaya tampilan yang anggun, rapi, berkelas, dan sama sekali tidak terlihat murahan. Penggunaan kostum elegan oleh penyanyi modern bikin citra dangdut jadi makin bersih. Gaya visual ini mempermudah musik dangdut buat masuk ke ruang-ruang kelas menengah.",
    "Steril": "Kondisi ruang sosial kelas menengah yang bersih dari debu jalanan dan serba diatur aturan baku. Dangdut modern sengaja dikemas lebih rapi agar bisa menembus masuk ke ruang steril ini. Sifat adaptif ini bikin lagu daerah bisa ikutan diputar di kafe-kafe elit kota.",
    "Katalisator": "Zat atau elemen pemicu yang mempercepat terjadinya proses perubahan di suatu lingkungan. Panggung dangdut bertindak sebagai katalisator ekonomi yang membuat uang berputar cepat di desa. Begitu tenda biru berdiri, pasar kaget otomatis lahir buat mendatangkan untung.",
    "Kultus": "Sikap penghormatan atau kekaguman berlebihan terhadap suatu benda atau fenomena budaya. Di Jawa Timur, lahir kultus terhadap sound horeg di mana kualitas bass jadi ukuran harga diri orkes. Kultus ini memicu berkembangnya industri bengkel box speaker lokal di pelosok desa.",
    "Hiperlocal": "Konsep pengembangan teknologi atau bisnis yang fokus melayani kebutuhan komunitas super kecil. Industri audio dangdut bergerak secara *hyperlocal* karena riset box speaker dilakukan mandiri di desa. Mereka fokus bikin suara bass paling 'jahat' yang pas dengan telinga warga lokal.",
    "Monomentisasi": "Proses mengubah karya seni atau popularitas menjadi sumber penghasilan uang yang konsisten. Musisi daerah sekarang sangat cerdik memonetisasi karya lewat AdSense YouTube dan video TikTok. Uang digital inilah yang dipakai modal buat memproduksi lagu baru mereka.",
    "Challenge": "Tren gerakan dansa atau tantangan berulang yang diikuti massal oleh para pengguna media sosial. Masa depan lagu dangdut sekarang dipaksa tunduk buat memenuhi kebutuhan konten *challenge* ini. Lagu sengaja didesain punya potongan pendek berdurasi 15 detik agar gampang viral.",
    "Terfragmentasi": "Kondisi sesuatu yang pecah terbelah menjadi potongan-potongan kecil dan tidak utuh lagi. Akibat era TikTok, nasib lagu dangdut masa depan bakal makin terfragmentasi. Orang tidak lagi menikmati lagu secara utuh, melainkan cuma berburu bagian hook ter-enak saja.",
    "Terotomatisasi": "Proses pengerjaan sesuatu secara otomatis menggunakan bantuan mesin pintar tanpa tenaga manusia. Produksi aransemen dangdut masa depan diprediksi bakal terotomatisasi oleh kehadiran AI. Mesin bisa gampang meniru pola kendang, tapi tetap bakal kesulitan meniru keringat panggung.",
    "Biduan Virtual": "Sosok penyanyi kecerdasan buatan yang eksis dalam bentuk animasi digital di layar. Teknologi masa depan memungkinkan lahirnya biduan virtual yang bisa konser non-stop di metaverse. Walau suaranya bisa dibuat merdu, nyawa asli dangdut tetep butuh interaksi manusia nyata.",
    "Metaverse": "Dunia simulasi virtual tiga dimensi di internet tempat manusia bisa berinteraksi lewat avatar digital. Konser dangdut masa depan diprediksi bakal ikutan merambah masuk ke dalam ruang metaverse ini. Panggung digital ini bikin musisi bisa menyapa fans global tanpa batasan jarak fisik.",
    "Hyperglobal": "Kondisi di mana produk kebudayaan lokal tingkat desa bisa melompat merajai pasar internasional. Dangdut bergerak menuju era hyperglobal karena ketukan kendangnya mulai disukai orang asing. Bahasa daerah tidak lagi jadi penghalang orang luar buat ikut vibing bersama.",
    "Fusion": "Proses peleburan atau penggabungan dua unsur budaya berbeda menjadi satu kombinasi baru. Dangdut masa depan bakal makin berani melakukan *fusion* ekstrem dengan produser internasional. Kita bakal dengerin perpaduan gila seperti dangdut-techno atau dangdut-lofi di masa depan.",
    "World music": "Kategori musik global yang menempatkan musik tradisional daerah sejajar dengan tren dunia. Dangdut diprediksi bakal sah diakui sebagai bagian dari *world music* yang dihormati. Kelasnya bakal dinilai setara dengan musik Reggae Jamaika atau Reggaeton Amerika Latin.",
    "Oversaturasi": "Kondisi pasar digital yang kebanjiran stok barang akibat produksi yang terlalu berlebihan. Karena bikin lagu dangdut sekarang makin gampang, internet terancam mengalami oversaturasi karya. Di era banjir konten ini, musisi wajib pintar bikin komunitas loyal agar tidak tenggelam.",
    "Krusial": "Kondisi genting atau poin sangat penting yang menentukan hidup-matinya suatu keputusan. Di masa depan digital, peran seorang kurator musik bertindak sangat krusial. Mereka yang bakal jadi penyaring utama buat milih lagu mana yang layak didengar di lautan konten.",
    "Server": "Perangkat komputer raksasa penyimpan data digital yang menjadi jantung utama internet. Panggung konser dangdut masa depan diprediksi tidak cuma ada di lapangan, tapi pindah ke server Discord. Di ruang digital inilah musisi masa depan bakal menjaga hubungan erat dengan fansnya.",
    "Web3": "Generasi terbaru internet berbasis desentralisasi yang memberikan hak kepemilikan penuh pada pengguna. Ekosistem Web3 bakal dimanfaatkan musisi dangdut masa depan buat menjual karya secara mandiri. Sistem ini bikin seniman bisa hidup makmur langsung dari sokongan komunitas loyalnya.",
    "Transmisi data saraf": "Teknologi masa depan yang mengirimkan sinyal suara langsung ke dalam pusat otak manusia. Apapun media pemutarnya nanti, buku lo menjamin kalau esensi ketukan dangdut tidak akan berubah. Selama jantung manusia masih berdetak, suara kendang itu bakal tetep dicari rakyat.",
    "Subversi digital": "Gerakan perlawanan diam-diam di internet buat merombak tatanan industri lama yang kaku. Musisi kamar tidur melakukan subversi digital dengan merilis lagu aneh yang bebas dari sensor. Karya bebas mereka membuktikan kalau kreativitas internet tidak bisa disensor siapa pun.",
    "Hibriditas budaya": "Proses percampuran berbagai unsur budaya asing yang melahirkan satu identitas lokal baru. Dangdut adalah bukti nyata dari hibriditas budaya yang sangat cerdas di Indonesia. Genre ini sukses mencampur akordeon Eropa, tabla India, dan gitar rock Barat jadi musik kita.",
    "Kreativitas": "Kemampuan berpikir out-of-the-box buat menciptakan karya baru yang segar dan adaptif. Menganggap dangdut kampungan adalah bukti kalau kita buta terhadap kreativitas musisi lokal. Dangdut bertahan satu abad justru karena kreativitas musisinya yang selalu pintar cari celah.",
    "Vibe": "Bahasa gaul internet sebutan buat atmosfer, suasana hati, atau aura yang dipancarkan musik. Di era pasca-genre, anak muda sekarang tidak lagi peduli pada kotak nama genre lagu. Mereka dengerin lagu cuma berdasarkan kecocokan *vibe* dengan kondisi perasaan mereka saat itu.",
    "Chaos": "Kondisi kacau, acak, liar, penuh kejutan, tapi justru memancarkan energi kegembiraan murni. Energi *chaos* di panggung hajatan rakyat inilah yang tidak akan pernah bisa ditiru oleh robot AI. Dangdut dicintai karena berani menjadi cermin jujur buat merayakan kekacauan hidup kita.",
    "Hook": "Bagian melodi atau lirik dalam lagu yang paling enak, mencolok, dan paling gampang ingat. Di era digital, bagian hook ini sengaja ditaruh di detik-detik awal baris lagu. Taktik ini dipakai agar jempol netizen langsung berhenti melakukan scrolling saat dengerin lagunya.",
    "BPM": "Singkatan dari *Beats Per Minute*, yaitu satuan ukuran buat menghitung kecepatan tempo musik. Musik koplo sengaja menaikkan angka BPM ini secara drastis dibanding dangdut klasik. BPM yang tinggi inilah yang bikin adrenalin pendengarnya otomatis terpacu buat joget ngebut.",
    "Synthesizer": "Alat musik elektronik berbentuk keyboard yang bisa meniru berbagai jenis suara instrumen digital. Di era dangdut remix, suling bambu tradisional mulai digantikan oleh suara synthesizer murah ini. Penggunaan alat ini bikin lagu dangdut lama terdengar lebih kencang di speaker angkot.",
    "Green screen": "Kain latar belakang hijau yang dipakai buat mempermudah proses edit efek visual video. Video klip dangdut era VCD bajakan hobi banget pakai green screen berbudget seadanya ini. Latar pemandangan air terjun stok yang dihasilkan justru menciptakan estetika norak yang ikonik.",
    "AdSense": "Sistem pembagian keuntungan uang digital dari iklan yang disediakan oleh platform YouTube. Label dangdut daerah sangat mandiri karena modal produksinya didapat dari hasil AdSense ini. Semakin banyak video mereka ditonton rakyat, semakin besar modal mereka buat bikin lagu baru.",
    "Flashdisk": "Alat penyimpanan data digital fisik berukuran kecil yang dicolok ke speaker atau audio mobil. Ketika toko kaset tutup, pasar distribusi fisik dangdut daerah pindah ke pengisian flashdisk ini. Hal ini ngebuktiin kalau dangdut selalu punya celah organik buat terus bertahan hidup.",
    "VCD": "Singkatan dari *Video Compact Disc*, kepingan perak murah yang jadi media sosial pertama dangdut. Lewat lapak VCD bajakan lima ribu perak di pinggir jalan, musik daerah bisa menembus pasar nasional. VCD terbukti menyelamatkan dangdut saat industri musik global sedang krisis."
      };

      await Future.delayed(const Duration(milliseconds: 400));
      
      // Cari jawaban lokal secara Case Insensitive (mengabaikan huruf besar/kecil)
      String? exactLocalAnswer;
      for (var key in localExplanations.keys) {
        if (key.toLowerCase() == term.toLowerCase()) {
          exactLocalAnswer = localExplanations[key];
          break;
        }
      }

      // Jika kata kunci gak pas di map lokal, return respons santai ala Bang Jago
      return exactLocalAnswer ?? "Waduh bro, istilah '$term' ini intinya punya pengaruh kuat banget sama perkembangan pergerakan skena dangdut di masyarakat kita. Nanti coba lu tanyain langsung di room chat utama biar Bang Jago bedah lebih dalem lagi ya!";
    }
  }

  // WIDGET ANIMASI LOADING SHIMMER MINIMALIS
  Widget _buildShimmerLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(3, (index) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          width: index == 2 ? 150 : double.infinity,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      )),
    );
  }
}

class _MarkAsReadButton extends StatefulWidget {
  final Materi materi;
  const _MarkAsReadButton({required this.materi});

  @override
  State<_MarkAsReadButton> createState() => _MarkAsReadButtonState();
}

class _MarkAsReadButtonState extends State<_MarkAsReadButton> {
  bool isRead = false;

  @override
  void initState() {
    super.initState();
    _checkReadStatus();
  }

  void _checkReadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isRead = prefs.getBool('read_${widget.materi.title}') ?? false;
    });
  }

  void _markAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('read_${widget.materi.title}', true);
    setState(() {
      isRead = true;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Materi ditandai sudah dibaca!')),
      );
    }
  }

  void _unmarkAsRead() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A24),
        title: const Text('Batalkan Tandai Sudah Dibaca?', style: TextStyle(color: Colors.white)),
        content: const Text('Yakin ingin menghapus tanda sudah dibaca pada materi ini?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal', style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ya, Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('read_${widget.materi.title}', false);
      setState(() {
        isRead = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tanda sudah dibaca dihapus.')), 
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(isRead ? Icons.check_circle : Icons.done, color: Colors.white),
        label: Text(isRead ? 'Batalkan Sudah Dibaca' : 'Tandai Sudah Dibaca'),
        style: ElevatedButton.styleFrom(
          backgroundColor: isRead ? Colors.red : kAmber,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: isRead ? _unmarkAsRead : _markAsRead,
      ),
    );
  }
}