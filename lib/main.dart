import 'package:aplikasi_6packs/splash_screen.dart';
import 'package:aplikasi_6packs/views/akun_page.dart';
import 'package:aplikasi_6packs/views/berita_page.dart';
import 'package:aplikasi_6packs/views/detail_latihan_page.dart';
import 'package:aplikasi_6packs/views/edit_akun_page.dart';
import 'package:aplikasi_6packs/views/home_page.dart';
import 'package:aplikasi_6packs/views/latihan_page.dart';
import 'package:aplikasi_6packs/views/login_page.dart';
import 'package:aplikasi_6packs/views/main_page.dart';
import 'package:aplikasi_6packs/views/paket_latihan_page.dart';
import 'package:aplikasi_6packs/views/password_page.dart';
import 'package:aplikasi_6packs/views/question_page.dart';
import 'package:aplikasi_6packs/views/register_page.dart';
import 'package:aplikasi_6packs/views/welcome_page.dart';
import 'package:aplikasi_6packs/views/rencana_page.dart';
import 'package:aplikasi_6packs/views/riwayat_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      title: 'Aplikasi 6Packs',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.white,
          selectionHandleColor: Colors.white,
        ),
      ),
      routes: {
        '/': (context) => SplashScreen(),
        '/welcome': (context) => WelcomePage(),
        '/main': (context) => MainPage(),
        
        // --- TAMBAHAN PENTING ---
        // Route ini yang dipanggil oleh tombol "Kembali ke Beranda"
        '/homepage': (context) => MainPage(), 
        // ------------------------

        '/berita': (context) => BeritaPage(),
        '/daftar': (context) => RegisterPage(),
        '/pertanyaan': (context) => QuestionPage(),
        '/masuk': (context) => LoginPage(),
        '/akun': (context) => AkunPage(),
        '/edit-akun': (context) => EditAkunPage(),
        '/password': (context) => PasswordPage(),
        '/paket-latihan': (context) => PaketLatihanPage(),
        '/detail-latihan': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return DetailLatihanPage(paket: args["paket"]);
        },
        '/latihan': (context) => LatihanPage(),
        '/rencana': (context) => const RencanaPage(),
        '/riwayat': (context) => RiwayatPage(),
      },
      initialRoute: '/',
    );
  }
}