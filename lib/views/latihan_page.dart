import 'package:flutter/material.dart';

class LatihanPage extends StatefulWidget {
  const LatihanPage({super.key});

  @override
  State<LatihanPage> createState() => _LatihanPageState();
}

class _LatihanPageState extends State<LatihanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              "Pemula",
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          SizedBox(width: kToolbarHeight),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.fromLTRB(20,30,20,90),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              spacing: 20,
              children: [
                Column(
                  spacing: 10,
                  children: [
                    Text(
                      "1 dari 5",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Standard Plank",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: (){}, 
                          icon: Icon(Icons.lightbulb, color: Colors.amber, size: 20,))
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Text(
              "00:17",
              style: TextStyle(
                color: Colors.white,
                fontSize: 96,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              spacing: 15,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/latihan');
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        backgroundColor: const Color(0xFF620000),
                      ),
                      child: const Text(
                        "Pause",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/latihan');
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          color: Color(0xFF620000),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}