import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Wajib Import
import '../services/user_service.dart';

class EditAkunPage extends StatefulWidget {
  const EditAkunPage({super.key});

  @override
  State<EditAkunPage> createState() => _EditAkunPageState();
}

class _EditAkunPageState extends State<EditAkunPage> {
  final TextEditingController _usernameController = TextEditingController();
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  void _loadCurrentData() async {
    final data = await UserService.getUserData();
    setState(() {
      _usernameController.text = data['username'] ?? "";
      _imagePath = data['image'];
    });
  }

  Future<void> _pickImage() async {
    // Ambil gambar dari galeri
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          "Edit Profil",
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xFFFF0000)),
            onPressed: () async {
              // --- LOGIKA SIMPAN PERUBAHAN ---
              await UserService.updateProfile(
                newUsername: _usernameController.text,
                newImagePath: _imagePath,
              );
              if (context.mounted) {
                // Kembali ke halaman sebelumnya dengan sinyal 'true' (berhasil update)
                Navigator.pop(context, true);
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 70),
                margin: const EdgeInsets.only(top: 80),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- FOTO PROFIL EDITABLE ---
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: _imagePath != null 
                                ? DecorationImage(
                                    image: FileImage(File(_imagePath!)),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                        // Tombol Pensil
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: const Icon(Icons.edit, color: Colors.black, size: 20),
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
                          "Username",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _usernameController, // LOGIC
                          decoration: InputDecoration(
                            filled: false,
                            fillColor: Colors.white.withOpacity(0.02),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.04)),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.04)),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.04)),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFF0000)),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}