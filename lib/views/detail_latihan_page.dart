import 'package:flutter/material.dart';
import '../models/paket_model.dart';
import 'exercise_preview_sheet.dart';

class DetailLatihanPage extends StatefulWidget {
  final WorkoutPackage paket;

  const DetailLatihanPage({super.key, required this.paket});

  @override
  State<DetailLatihanPage> createState() => _DetailLatihanPageState();
}

class _DetailLatihanPageState extends State<DetailLatihanPage> {
  // -------------------------
  // 1. LOGIKA UI DINAMIS (Warna & Gambar)
  // -------------------------
  
  List<Color> getGradientColors(String level) {
    switch (level) {
      case "Noob":
        return [
          const Color(0xFF005078),
          const Color(0xFF0089CE),
          const Color(0xFF3ABDFF),
        ];
      case "Pro":
        return [
          const Color(0xFF862400),
          const Color(0xFFFF5900),
          const Color(0xFFFF8800),
        ];
      case "Hacker":
        return [
          const Color(0xFF470000),
          const Color(0xFFDE0000),
          const Color(0xFFFF3A3A),
        ];
      default:
        return [Colors.grey, Colors.grey];
    }
  }

  Color getButtonColor(String level) {
    switch (level) {
      case "Noob": return const Color(0xFF0089CE);
      case "Pro": return const Color(0xFFFF5900);
      case "Hacker": return const Color(0xFFDE0000);
      default: return Colors.blue;
    }
  }

  String getImagePath(String level) {
    switch (level) {
      case "Noob": return "assets/images/pemula.png";
      case "Pro": return "assets/images/menengah.png";
      case "Hacker": return "assets/images/lanjutan.png";
      default: return "assets/images/pemula.png";
    }
  }

  // -------------------------
  // 2. LOGIKA HITUNGAN
  // -------------------------
  int getTotalDuration(WorkoutPackage paket) {
    int total = 0;
    for (var m in paket.movements) {
      if (m.type == "detik") total += m.amount;
      if (m.type == "repetisi") total += (m.amount * 2);
    }
    return (total / 60).ceil();
  }

  int getCalories(WorkoutPackage paket) {
    if (paket.level == "Noob") return 60;
    if (paket.level == "Pro") return 90;
    return 120;
  }

  @override
  Widget build(BuildContext context) {
    final paket = widget.paket;
    final screenHeight = MediaQuery.of(context).size.height;

    // Ambil aset dinamis
    final currentGradient = getGradientColors(paket.level);
    final currentButtonColor = getButtonColor(paket.level);
    final currentImage = getImagePath(paket.level);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        // Title Custom dengan Icon Bintang
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              paket.level,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.star, color: Colors.white, size: 14),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        children: [
          // ==============================
          // 1. HEADER (Gradient + Gambar)
          // ==============================
          Container(
            width: double.infinity,
            height: screenHeight * 0.28, // Sedikit lebih tinggi agar gambar muat
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: currentGradient,
              ),
            ),
            // Stack untuk menumpuk Gambar di atas Gradient
            child: Stack(
              children: [
                // Gambar Karakter (Masking)
                Positioned(
                  right: -30,
                  top: 40, // Turunkan sedikit agar tidak kena AppBar
                  bottom: 0,
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black, 
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        stops: [0.0, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset(
                      currentImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // Teks Besar (Level)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      paket.level.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: Colors.white24, // Efek watermark transparan
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==============================
          // 2. KONTEN UTAMA (Scrollable)
          // ==============================
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Stack(
                children: [
                  // List Gerakan
                  Positioned.fill(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Info Card
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInfoItem("Latihan", "${paket.movements.length}"),
                                _buildInfoItem("Durasi", "${getTotalDuration(paket)} mnt"),
                                _buildInfoItem("Kalori", "${getCalories(paket)} kkal"),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          const Text(
                            "Daftar Gerakan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          // List Item
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: paket.movements.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 15),
                            itemBuilder: (context, index) {
                              final m = paket.movements[index];
                              return _buildMovementItem(context, m);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ==============================
                  // 3. TOMBOL MULAI (Fixed Bottom)
                  // ==============================
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 120, // Area gradasi hitam di bawah tombol
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black, Colors.transparent],
                        ),
                      ),
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/latihan',
                              arguments: {"paket": paket},
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            shadowColor: currentButtonColor.withValues(alpha: 0.5),
                            backgroundColor: currentButtonColor, // Warna Tombol Dinamis
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Mulai Latihan Sekarang",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Helper ---

  Widget _buildMovementItem(BuildContext context, WorkoutMovement m) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ExercisePreviewSheet(
            movementName: m.name,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white70),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    m.type == "detik"
                        ? "${m.amount} Detik"
                        : "${m.amount} Repetisi",
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}