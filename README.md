# Evolution of Dangdut 🎸🔥
> **Aplikasi Media Pembelajaran Sejarah & Evolusi Dangdut Interaktif Berbasis Flutter dengan Integrasi Google Gemini AI**

Aplikasi ini dibangun menggunakan **Flutter & Dart** sebagai medium pembelajaran sosiokultural yang interaktif mengenai sejarah dan linimasa perkembangan musik dangdut di Indonesia. Proyek ini mengintegrasikan fitur-fitur tingkat lanjut seperti *dynamic text parsing*, *multi-channel audio engineering*, dan respons *Generative AI* secara real-time.

---

## 🚀 Fitur Utama

* **Dashboard Editorial Minimalis:** Antarmuka (UI) yang bersih, modern, dan sangat responsif, dirancang khusus untuk kenyamanan eksplorasi pengguna tanpa visual *clutter*.
* **14 Level Narasi Sosiokultural:** Modul pembelajaran terstruktur mulai dari era Proto-Dangdut hingga era Masa Depan AI, lengkap dengan pelacakan progres membaca berbasis lokal via `SharedPreferences`.
* **Smart Term Highlight & Contextual AI Pop-up:** Sistem otomatis yang mem-parsing istilah-istilah penting sosiologi dan musikologi (seperti *Pierre Bourdieu*, *Distingsi*, *Koplo Speed*) di dalam teks menjadi komponen emas interaktif. Mengetuk istilah ini akan langsung memunculkan *bottom sheet* penjelasan instan.
* **Dual-Engine AI Integration (Live API + Local Fallback):**
    * *Mesin Utama:* Mengirimkan *direct request* secara real-time ke **Google Generative AI (Gemini 2.5 Flash)** dengan *prompt engineering* khusus yang bertindak sebagai mentor pakar.
    * *Mesin Cadangan:* Otomatis beralih ke kamus lokal terstruktur jika pengguna sedang *offline* atau kuota limit API habis, memastikan aplikasi 100% bebas dari *crash*.
* **Multi-channel Audio Engine:** Memanfaatkan teknik *layering audio* via package `audioplayers`, memungkinkan pemutaran musik latar (*backsound*) konstan secara *looping* selama kuis bersamaan dengan efek suara (*SFX*) respons jawaban, serta *audio reward* adaptif di akhir sesi kuis.
* **Kuis Dinamis & Visual Feedback:** Modul evaluasi pilihan ganda interaktif di setiap level yang memberikan respons perubahan warna tombol secara instan (`AnimatedContainer`) saat opsi diklik oleh pengguna.
* **Galeri Tokoh (Figure Recognition):** Ensiklopedia visual terintegrasi yang mengenalkan para pionir, aktor kunci, dan legenda yang membentuk sejarah musik dangdut di tanah air.

---

## 🛠️ Stack Teknologi & Arsitektur

* **Framework:** Flutter (Multiplatform Mobile Development)
* **Bahasa Pemrograman:** Dart
* **Integrasi AI:** `google_generative_ai` (Official SDK Google AI Studio)
* **Penyimpanan Lokal:** `shared_preferences` (Caching data lokal untuk skor tertinggi dan status baca)
* **Mesin Audio:** `audioplayers` (Manipulasi audio multi-channel)

---

## 📈 Optimasi Performa Perangkat Mobile

Untuk memastikan performa aplikasi tetap ringan dan lancar saat dijalankan di smartphone spesifikasi rendah (*low-end devices*), proyek ini menerapkan teknik *engineering* Flutter tingkat lanjut:
* **Lazy Loading via `SliverList`:** Merendering paragraf teks narasi yang panjang secara efisien tanpa memakan konsumsi memori (RAM) berlebih.
* **Caching Dimensi Gambar (`cacheWidth`):** Membatasi resolusi gambar saat didekode agar ukuran file aset visual tidak membebani memori perangkat.
* **Isolated Repaint Boundaries:** Mengisolasi widget animasi dan tumpukan gambar menggunakan `RepaintBoundary` untuk mencegah proses *re-paint* UI yang berat memengaruhi pohon widget lainnya.

---

## 🎯 Metodologi Pengembangan

Proyek ini dikembangkan secara mandiri menggunakan prinsip **Solo Agile XP (Extreme Programming)**:
* **Iterative Small Releases:** Setiap komponen fungsional dikodekan, diuji langsung di perangkat (*on-device testing*), dan diterapkan secara bertahap modul demi modul.
* **Continuous Refactoring:** Melakukan optimalisasi arsitektur kode secara berkala untuk membasmi bug *layout constraints* (layar meluber/overflow) serta menyempurnakan akurasi regex pada fitur kata emas secara instan.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
