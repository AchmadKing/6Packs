import 'package:flutter/material.dart';

class EditAkunPage extends StatefulWidget {
  const EditAkunPage({super.key});

  @override
  State<EditAkunPage> createState() => _EditAkunPageState();
}

class _EditAkunPageState extends State<EditAkunPage> {
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
        title: Text(
          "Edit Profil",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xFFFF0000)),
            onPressed: () {
              // TODO: aksi centang
            },
          ),

          // agar kiri & kanan seimbang, karena leading punya width default 56
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height, // minimal setinggi layar
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 70),
                margin: EdgeInsets.only(top: 80),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Text(
                          "Username",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          )
                        ),
                        TextFormField(
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
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFF0000)),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          )
                        ),
                        TextFormField(
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
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFF0000)),
                            ),
                          ),
                          style: TextStyle(
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