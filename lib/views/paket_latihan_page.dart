import 'package:flutter/material.dart';
import '../models/paket_model.dart';

class PaketLatihanPage extends StatefulWidget {
  const PaketLatihanPage({super.key});

  @override
  State<PaketLatihanPage> createState() => _PaketLatihanPageState();
}

class _PaketLatihanPageState extends State<PaketLatihanPage> {
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
        title: Text(
          "Pilih Paket Pelatihan",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 70, 30, 120),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xFF005078),
                      Color(0xFF0089CE),
                      Color(0xFF3ABDFF)
                    ]
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: 0,
                      bottom: 60,
                      child: ShaderMask(
                        shaderCallback: (Rect bounds){
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black,
                              Color.fromARGB(0, 0, 0, 0),
                            ],
                            stops: [0.0,1]
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Image.asset(
                          "assets/images/pemula.png",
                          fit: BoxFit.cover
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Noob",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, color: const Color.fromARGB(255, 255, 255, 255), size: 20),
                                ],
                              )
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detail-latihan',
                                  arguments: {"paket": workoutPackages[0]},
                                );
                              }, 
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                backgroundColor: Color.fromARGB(255, 255, 255, 255)
                              ),
                              child: Text(
                                "Mulai",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xFF862400),
                      Color(0xFFFF5900),
                      Color(0xFFFF8800)
                    ]
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 20,
                      top: 0,
                      bottom: 60,
                      child: ShaderMask(
                        shaderCallback: (Rect bounds){
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black,
                              Color.fromARGB(0, 0, 0, 0),
                            ],
                            stops: [0.0,1]
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Image.asset(
                          "assets/images/menengah.png",
                          fit: BoxFit.cover
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pro",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.white, size: 20),
                                  Icon(Icons.star, color: Colors.white, size: 20),
                                ],
                              )
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detail-latihan',
                                  arguments: {"paket": workoutPackages[1]},
                                );
                              }, 
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                backgroundColor: Color.fromARGB(255, 255, 255, 255)
                              ),
                              child: Text(
                                "Mulai",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xFF470000),
                      Color(0xFFDE0000),
                      Color(0xFFFF3A3A)
                    ]
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 20,
                      top: 0,
                      bottom: 60,
                      child: ShaderMask(
                        shaderCallback: (Rect bounds){
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black,
                              Color.fromARGB(0, 0, 0, 0),
                            ],
                            stops: [0.0,1]
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 10,
                              bottom: 0,
                              left: 0,
                              right: 50,
                              child: Opacity(
                                opacity: 0.5,
                                child: Image.asset(
                                  "assets/images/lanjutan.png",
                                  fit: BoxFit.cover
                                ),
                              ),
                            ),
                            Image.asset(
                              "assets/images/lanjutan.png",
                              fit: BoxFit.cover
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hacker",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.white, size: 20),
                                  Icon(Icons.star, color: Colors.white, size: 20),
                                  Icon(Icons.star, color: Colors.white, size: 20),
                                ],
                              )
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detail-latihan',
                                  arguments: {"paket": workoutPackages[2]},
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                backgroundColor: Color.fromARGB(255, 255, 255, 255)
                              ),
                              child: Text(
                                "Mulai",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}