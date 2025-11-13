import 'package:aplikasi_6packs/splash_screen.dart';
import 'package:aplikasi_6packs/views/detail_latihan_page.dart';
import 'package:aplikasi_6packs/views/home_page.dart';
import 'package:aplikasi_6packs/views/latihan_page.dart';
import 'package:aplikasi_6packs/views/login_page.dart';
import 'package:aplikasi_6packs/views/paket_latihan_page.dart';
import 'package:aplikasi_6packs/views/register_page.dart';
import 'package:aplikasi_6packs/views/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        '/daftar': (context) => RegisterPage(),
        '/masuk': (context) => LoginPage(),
        '/homepage': (context) => HomePage(),
        '/paket-latihan': (context) => PaketLatihanPage(),
        '/detail-latihan': (context) => DetailLatihanPage(),
        '/latihan': (context) => LatihanPage(),
      },
      initialRoute: '/',
    );
  }
}


