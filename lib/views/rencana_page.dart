import 'package:flutter/material.dart';
// Pastikan path import widget custom ini sesuai dengan project Anda
import '../widgets/custom_thumb_shape.dart';
import '../widgets/customTickMarkShape.dart';
// Import Service untuk menyimpan data
import '../services/user_service.dart'; 

class RencanaPage extends StatefulWidget {
  const RencanaPage({super.key});

  @override
  State<RencanaPage> createState() => _RencanaPageState();
}

class _RencanaPageState extends State<RencanaPage> {
  double _sliderValue = 2.0; // Default awal (3 hari) jika belum ada data

  @override
  void initState() {
    super.initState();
    _loadCurrentPlan();
  }

  // Load data saat halaman dibuka
  void _loadCurrentPlan() async {
    int savedTarget = await UserService.getWeeklyTarget();
    if (mounted) {
      setState(() {
        // Konversi target (1-7) ke slider value (0-6)
        _sliderValue = (savedTarget - 1).toDouble();
      });
    }
  }

  // Helper untuk label teks
  String getActivityLabel(double value) {
    // Value slider 0-6 menjadi Label 1-7
    return (value.toInt() + 1).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(left: 40, right: 40, bottom: 30, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Berapa Hari Rencana Anda Berolahraga Dalam Waktu Satu Minggu?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            
            // Gambar Ilustrasi
            Expanded(
              child: Image.asset("assets/images/rencana.png"),
            ),
            
            Column(
              children: [
                // Label angka besar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      getActivityLabel(_sliderValue),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      "x",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Slider Custom
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF8B1E1E),
                    inactiveTrackColor: Colors.grey.shade800,
                    thumbColor: const Color(0xFF8B1E1E),
                    overlayColor: const Color(0xFF8B1E1E).withOpacity(0.2),
                    thumbShape: const CustomThumbShape(
                      thumbRadius: 10.0,
                      borderWidth: 3.0,
                    ),
                    trackHeight: 8.0,
                    activeTickMarkColor: Colors.white,
                    inactiveTickMarkColor: Colors.white.withOpacity(0.5),
                    tickMarkShape: const CustomTickMarkShape(
                      tickMarkRadius: 5.0,
                    ),
                  ),
                  child: Slider(
                    value: _sliderValue,
                    min: 0.0,
                    max: 6.0,
                    divisions: 6,
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                ),

                // Label Keterangan (Jarang - Aktif)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Sangat Jarang",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        "Sangat Aktif",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),

                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      // 1. Hitung Target (Value 0-6 + 1 = Target 1-7)
                      int target = _sliderValue.toInt() + 1;
                      
                      // 2. Simpan ke Shared Preferences
                      await UserService.setWeeklyTarget(target);

                      // 3. Kembali ke Home dan beritahu ada perubahan (true)
                      if (context.mounted) {
                        Navigator.pop(context, true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF620000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      )
                    ),
                    child: const Text(
                      "Simpan Rencana",
                      style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}