import 'package:flutter/material.dart';
import '../services/user_service.dart';

// Pastikan import ini sesuai dengan struktur folder Anda
import 'berat_tinggi_badan_page.dart';
import 'rencana_page.dart';
import 'seberapaaktif_page.dart';
import 'tipe_badan_page.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int currentPagesIndex = 0;

  // Daftar Halaman Kuesioner
  final List<Widget> pages = [
    const TipeBadanPage(),
    const BeratTinggiBadanPage(),
    const SeberapaAktifPage(),
    const RencanaPage(),
  ];

  // Judul Header per Halaman
  final List<String> pagesTitle = [
    "Pilih Tipe Perut Anda",
    "Berat dan Tinggi Badan",
    "Seberapa Aktif Anda?",
    "Rencana Latihan",
  ];

  @override
  Widget build(BuildContext context) {
    // Menghitung progress bar (0.25, 0.50, 0.75, 1.0)
    double progress = (currentPagesIndex + 1) / pages.length;
    bool isLastPage = currentPagesIndex == pages.length - 1;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      
      // --- APP BAR DENGAN PROGRESS BAR ---
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false, // Hilangkan tombol back default
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Judul Halaman
            Text(
              pagesTitle[currentPagesIndex], 
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 20),
            
            // Progress Bar Custom
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20), // Padding disesuaikan
              child: SizedBox(
                height: 6,
                child: Stack(
                  children: [
                    // Track Putih (Background bar)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    // Progress Merah (Animated bar)
                    AnimatedFractionallySizedBox(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF910303),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Tambahkan height agar AppBar muat menampung progress bar
        toolbarHeight: 80, 
      ),

      // --- BODY (HALAMAN BERGANTI) ---
      body: pages[currentPagesIndex],

      // --- BOTTOM BAR (TOMBOL NEXT) ---
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        elevation: 0,
        child: Container(
          width: double.infinity,
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ElevatedButton(
            onPressed: () async {
              if (isLastPage) {
                // LOGIKA SELESAI
                // 1. Tandai user sudah mengisi kuesioner
                await UserService.completeQuestionnaire();

                if (context.mounted) {
                  // 2. Pindah ke Halaman Utama dan hapus history
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/main', // Pastikan route ini sesuai dengan main.dart (MainPage)
                    (Route<dynamic> route) => false,
                  );
                }
              } else {
                // LOGIKA NEXT PAGE
                setState(() {
                  currentPagesIndex++;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              elevation: 0,
              backgroundColor: const Color(0xFF620000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              isLastPage ? "Selesai" : "Selanjutnya",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}