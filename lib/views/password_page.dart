import 'package:flutter/material.dart';
import '../services/user_service.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text("Ganti Password", style: TextStyle(fontSize: 15)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Column(
                children: [
                  const Text(
                    "Perbarui Password Anda",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Masukkan password yang sudah ada dan password yang baru",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // diperbaiki spacing
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Password Saat Ini",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: _oldPassController, // LOGIC
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.08),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.04),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.04),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.04),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.04),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Password Baru",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: _newPassController, // LOGIC
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.08),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.04),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.04),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.04),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.04),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    // --- LOGIKA GANTI PASS ---
                    if (_oldPassController.text.isEmpty || _newPassController.text.isEmpty) return;

                    bool success = await UserService.changePassword(
                      _oldPassController.text, 
                      _newPassController.text
                    );

                    if (context.mounted) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Password berhasil diganti!"))
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Password lama salah!"))
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    backgroundColor: const Color(0xFF620000),
                  ),
                  child: const Text(
                    "Ganti Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
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
}