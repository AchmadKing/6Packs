import 'dart:io';
import 'package:flutter/material.dart';
import '../services/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data User
  String username = "User";
  String? imagePath;

  // Data Rencana Mingguan
  int weeklyTarget = 3; // Default
  int completedCount = 0;
  List<int> completedDays = []; // List hari yang sudah selesai (1=Senin, 7=Minggu)

  // Data Dummy Berita
  final List<Map<String, String>> newsList = [
    {
      "title": "Tips Menjaga Kesehatan di Rumah",
      "desc": "Menjaga kesehatan dimulai dari kebiasaan kecil sehari-hari. Simak tips berikut untuk tetap sehat meski sibuk.",
    },
    {
      "title": "Manfaat Olahraga Setiap Pagi",
      "desc": "Olahraga pagi memberi energi untuk beraktivitas, meningkatkan metabolisme, dan memperbaiki mood.",
    },
    {
      "title": "Makanan Tinggi Protein yang Murah",
      "desc": "Tidak harus mahal untuk makan sehat. Berikut daftar makanan tinggi protein yang ramah dompet.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Fungsi untuk memuat semua data (Profil & Progress)
  void _loadData() async {
    // 1. Ambil Profil User
    final user = await UserService.getUserData();
    
    // 2. Ambil Progress Mingguan
    final progress = await UserService.getWeeklyProgress();

    if (mounted) {
      setState(() {
        // Set Profil
        username = user['username'] ?? "User";
        imagePath = user['image'];

        // Set Progress
        weeklyTarget = progress['target'];
        completedCount = progress['completed_count'];
        completedDays = List<int>.from(progress['completed_days']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan hari ini (1 = Senin, ..., 7 = Minggu)
    int currentWeekday = DateTime.now().weekday;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 50),
              
              // ==========================================
              // 1. HEADER HALO (PROFIL)
              // ==========================================
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: imagePath != null 
                          ? DecorationImage(
                              image: FileImage(File(imagePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),
                  Text(
                    "Halo, $username!",
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),

              // ==========================================
              // 2. CAPAIAN MINGGUAN (LOGIKA UTAMA)
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Header Card
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Capaian Mingguan",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 10),
                            
                            // --- TOMBOL PENSIL (EDIT RENCANA) ---
                            GestureDetector(
                              onTap: () async {
                                // Navigasi ke RencanaPage
                                // 'await' menunggu user selesai mengedit & kembali
                                await Navigator.pushNamed(context, '/rencana');
                                
                                // Setelah kembali, refresh data agar angka target terupdate
                                _loadData();
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            // ------------------------------------
                          ],
                        ),
                        // Text Progress (Contoh: 2/5)
                        Text(
                          "$completedCount/$weeklyTarget",
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Lingkaran Hari 1-7
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (index) {
                        int dayNumber = index + 1; // 1 = Senin, dst.
                        
                        // Logika Penentuan Status
                        bool isCompleted = completedDays.contains(dayNumber);
                        bool isToday = dayNumber == currentWeekday;

                        // Variabel UI
                        Widget content;
                        BoxDecoration decoration;

                        if (isCompleted) {
                          // KASUS A: SUDAH LATIHAN (API)
                          decoration = const BoxDecoration(
                            color: Colors.white, 
                            shape: BoxShape.circle,
                          );
                          content = const Icon(
                            Icons.local_fire_department, 
                            color: Colors.orange, 
                            size: 20
                          );
                        } else if (isToday) {
                          // KASUS B: HARI INI TAPI BELUM LATIHAN (PUTIH)
                          decoration = const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          );
                          content = Text(
                            "$dayNumber",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          // KASUS C: HARI LAIN BELUM LATIHAN (GELAP)
                          decoration = BoxDecoration(
                            color: Colors.white10, 
                            shape: BoxShape.circle,
                          );
                          content = Text(
                            "$dayNumber",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }

                        return Expanded(
                          flex: 1,
                          child: Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: decoration,
                            child: Center(child: content),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==========================================
              // 3. BANNER PROMO
              // ==========================================
              Container(
                width: double.infinity,
                height: 250,
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xFF470000),
                        Color(0xFFDE0000),
                        Color(0xFFFF3A3A),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      // Gambar Background
                      Positioned(
                        right: 20,
                        top: 0,
                        bottom: 60,
                        child: Image.asset(
                          "assets/images/onedayordayone.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Teks & Tombol
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "One Day",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                  ),
                                ),
                                Text(
                                  "or Day One",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/paket-latihan',
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                ),
                                child: const Text(
                                  "Mulai Sekarang",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ==========================================
              // 4. BERITA TERBARU
              // ==========================================
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Berita Terbaru",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {}, 
                          child: Row(
                            children: [
                              Text(
                                "Lihat Semua",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // List Berita
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: newsList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        final item = newsList[index];

                        return InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withOpacity(0.08),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Thumbnail Placeholder
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                // Isi Berita
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["title"]!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item["desc"]!,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}