import 'dart:io';
import 'package:flutter/material.dart';
import '../services/user_service.dart';

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
  }

  void _loadUserData() async {
    final data = await UserService.getUserData();
    setState(() {
      username = data['username'] ?? "User";
      email = data['email'] ?? "email";
      imagePath = data['image'];
    });
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
                        // --- FOTO PROFIL ---
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
                        // --- NAMA & EMAIL ---
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
                    // --- TOMBOL EDIT ---
                    IconButton(
                      onPressed: () async {
                        // Tunggu hasil dari halaman edit
                        final result = await Navigator.pushNamed(context, '/edit-akun');
                        // Jika ada perubahan (true), refresh halaman ini
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
              
              // --- MENU GENERAL ---
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        _buildMenuItem(Icons.person_outline, "Capaian Saya"),
                        const SizedBox(height: 20),
                        _buildMenuItem(Icons.notifications_outlined, "Notifikasi"),
                        const SizedBox(height: 20),
                        // Menu Ganti Password
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

              // --- MENU SUPPORT ---
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

              // --- TOMBOL LOGOUT ---
              Ink(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    // Logika Logout: Kembali ke Login, hapus stack
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