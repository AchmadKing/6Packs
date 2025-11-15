import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailLatihanPage extends StatefulWidget {
  const DetailLatihanPage({super.key});

  @override
  State<DetailLatihanPage> createState() => _DetailLatihanPageState();
}

class _DetailLatihanPageState extends State<DetailLatihanPage> {
  late YoutubePlayerController ytController;

  @override
  void initState() {
    super.initState();
    ytController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=F-nQ_KJgfCY",
      )!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    ytController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
            Icon(Icons.star, color: Colors.white, size: 20),
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
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // background gradient
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color(0xFF005078),
                    Color(0xFF0089CE),
                    Color(0xFF3ABDFF),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -30,
                    top: 0,
                    bottom: 60,
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black,
                            Color.fromARGB(0, 0, 0, 0),
                          ],
                          stops: [0.0, 1],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset(
                        "assets/images/pemula.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // main content
            Positioned(
              left: 0,
              right: 0,
              top: 150,
              bottom: 0,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: IntrinsicHeight(
                    child: Column(
                      spacing: 20,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Jumlah Latihan",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Text(
                                    "5",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Estimasi Durasi",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Text(
                                    "15-20 menit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Kalori",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Text(
                                    "103.0 kcal",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // daftar latihan
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            spacing: 30,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Latihan",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Column(
                                spacing: 15,
                                children: List.generate(5, (index) {
                                  return Ink(
                                    width: double.infinity,
                                    height: 100,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.01),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) {
                                            double currentExtent = 0.4;

                                            return DraggableScrollableSheet(
                                              initialChildSize: 0.4,
                                              minChildSize: 0.2,
                                              maxChildSize: 1.0,
                                              builder: (context, scrollController) {
                                                return NotificationListener<DraggableScrollableNotification>(
                                                  onNotification: (notif) {
                                                    currentExtent = notif.extent;
                                                    return true;
                                                  },
                                                  child: StatefulBuilder(
                                                    builder: (context, setState) {
                                                      return Container(
                                                        padding: const EdgeInsets.all(20),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              const BorderRadius.vertical(top: Radius.circular(30)),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            // Drag Handle
                                                            AnimatedOpacity(
                                                              opacity: currentExtent < 0.95 ? 1 : 0,
                                                              duration: const Duration(milliseconds: 200),
                                                              child: Container(
                                                                width: 40,
                                                                height: 5,
                                                                margin: const EdgeInsets.only(bottom: 15),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white24,
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                              ),
                                                            ),

                                                            Expanded(
                                                              child: ListView(
                                                                controller: scrollController,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        "Standard Planks",
                                                                        style: const TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: 20,
                                                                            fontWeight: FontWeight.w700),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Icon(Icons.flash_on, color: Colors.white, size: 16,),
                                                                          Icon(Icons.flash_on, color: Colors.white, size: 16,),
                                                                          Icon(Icons.flash_on, color: Colors.white, size: 16,)
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 20),
                                                                  ClipRRect(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    child: YoutubePlayer(
                                                                      controller: ytController,
                                                                      showVideoProgressIndicator: true,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 50),
                                                                  Text(
                                                                    "Standard plank adalah latihan dasar untuk memperkuat otot inti (core) dengan cara mempertahankan posisi tubuh lurus seperti papan. Latihan ini tidak membutuhkan alat dan berfokus pada kestabilan tubuh. Plank membantu memperkuat otot perut, punggung bawah, bahu, dan panggul.",
                                                                    textAlign: TextAlign.justify,
                                                                    style: const TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Standard Plank",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            "45 detik",
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 160),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // tombol mulai
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 200,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black,
                      Colors.transparent,
                    ],
                  ),
                ),
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
                      "Mulai",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
