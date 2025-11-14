import 'package:aplikasi_6packs/views/akun_page.dart';
import 'package:aplikasi_6packs/views/berita_page.dart';
import 'package:aplikasi_6packs/views/home_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  List<Widget> pages = [
    HomePage(),
    BeritaPage(),
    AkunPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
                icon: Icon(Icons.newspaper, color: currentIndex == 1 ? Colors.red : Colors.white),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
                icon: Icon(Icons.home, color: currentIndex == 0 ? Colors.red : Colors.white),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },
                icon: Icon(Icons.person, color: currentIndex == 2 ? Colors.red : Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}