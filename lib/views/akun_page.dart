import 'dart:io';
import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/notification_service.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({super.key});

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  String username = "User";
  String email = "email@email.com";
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Init service agar siap digunakan
    NotificationService.init();
  }

  void _loadUserData() async {
    final data = await UserService.getUserData();
    setState(() {
      username = data['username'] ?? "User";
      email = data['email'] ?? "email";
      imagePath = data['image'];
    });
  }

  // --- LOGIKA BARU: HANDLE KLIK MENU NOTIFIKASI ---
  void _handleNotificationMenuClick() async {
    // 1. Minta Izin Notifikasi Dulu (Popup OS akan muncul jika pertama kali)
    await NotificationService.requestPermissions();

    // 2. Setelah izin diproses (diizinkan/ditolak), buka Dialog Pengaturan
    if (mounted) {
      _showNotificationDialog();
    }
  }

  // --- DIALOG PENGATURAN ---
  void _showNotificationDialog() async {
    final settings = await UserService.getNotificationSettings();
    
    bool isEnabled = settings['enabled'];
    TimeOfDay selectedTime = TimeOfDay(hour: settings['hour'], minute: settings['minute']);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text(
                "Pengingat Latihan",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Atur waktu untuk kami mengingatkan Anda berolahraga setiap hari.",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  
                  // PILIH JAM
                  InkWell(
                    onTap: isEnabled ? () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Color(0xFF0089CE),
                                onPrimary: Colors.white,
                                surface: Color(0xFF2C2C2C),
                                onSurface: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setDialogState(() {
                          selectedTime = picked;
                        });
                      }
                    } : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        color: isEnabled ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isEnabled ? const Color(0xFF0089CE) : Colors.transparent
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            selectedTime.format(context),
                            style: TextStyle(
                              fontSize: 32, 
                              fontWeight: FontWeight.bold,
                              color: isEnabled ? Colors.white : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.edit, color: isEnabled ? Colors.white70 : Colors.grey, size: 18)
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // TOGGLE SWITCH
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Aktifkan Notifikasi", style: TextStyle(color: Colors.white)),
                      Switch(
                        value: isEnabled,
                        activeColor: const Color(0xFF0089CE),
                        onChanged: (val) {
                          setDialogState(() {
                            isEnabled = val;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Batal", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // SIMPAN DATA
                    await UserService.saveNotificationSettings(
                      isEnabled: isEnabled, 
                      hour: selectedTime.hour, 
                      minute: selectedTime.minute
                    );

                    // JADWALKAN NOTIFIKASI
                    if (isEnabled) {
                      await NotificationService.scheduleDailyNotification(
                        hour: selectedTime.hour, 
                        minute: selectedTime.minute
                      );
                    } else {
                      await NotificationService.cancelNotification();
                    }

                    if (mounted) {
                      Navigator.pop(ctx); // Tutup Dialog
                      
                      // TAMPILKAN SNACKBAR CUSTOM
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                isEnabled ? Icons.check_circle : Icons.notifications_off, 
                                color: Colors.white
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(isEnabled 
                                  ? "Pengingat diset jam ${selectedTime.format(context)}" 
                                  : "Pengingat dimatikan"
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: isEnabled ? Colors.green : Colors.grey,
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0089CE)),
                  child: const Text("Simpan", style: TextStyle(color: Colors.white)),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text("Profil Saya", style: TextStyle(fontSize: 15)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              // CARD PROFIL
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.only(right: 15),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () async {
                        final result = await Navigator.pushNamed(context, '/edit-akun');
                        if (result == true) {
                          _loadUserData();
                        }
                      },
                      icon: const Icon(Icons.edit_outlined, color: Colors.white),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // GENERAL MENU
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "General",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/riwayat');
                          },
                          child: _buildMenuItem(Icons.person_outline, "Capaian Saya"),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // --- UPDATE: BUTTON NOTIFIKASI DENGAN LOGIKA IZIN ---
                        InkWell(
                          onTap: _handleNotificationMenuClick, // Panggil fungsi logic baru
                          child: _buildMenuItem(Icons.notifications_outlined, "Notifikasi"),
                        ),
                        // ---------------------------------------------------

                        const SizedBox(height: 20),
                        
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/password');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.lock_outline_rounded, color: Colors.white),
                                  const SizedBox(width: 20),
                                  const Text("Ganti Password", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w700)),
                                ],
                              ),
                              const Icon(Icons.chevron_right, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),

              // SUPPORT MENU
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Support",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(Icons.question_answer, "FAQ"),
                        const SizedBox(height: 20),
                        _buildMenuItem(Icons.share_outlined, "Bagikan"),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),

              // LOGOUT
              Ink(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/masuk', (route) => false);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: const [
                        Icon(Icons.logout, color: Color(0xFFFF4040)),
                        SizedBox(width: 20),
                        Text(
                          "Log Out",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFFFF4040),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Icon(Icons.chevron_right, color: Colors.white),
      ],
    );
  }
}