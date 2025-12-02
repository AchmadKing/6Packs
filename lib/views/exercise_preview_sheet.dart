import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/workout_api.dart';
import '../models/workout_model.dart';

class ExercisePreviewSheet extends StatefulWidget {
  final String movementName;

  const ExercisePreviewSheet({
    super.key,
    required this.movementName,
  });

  @override
  State<ExercisePreviewSheet> createState() => _ExercisePreviewSheetState();
}

class _ExercisePreviewSheetState extends State<ExercisePreviewSheet> {
  final MuscleWikiApiService api = MuscleWikiApiService();
  late Future<List<ExerciseModel>> exerciseFuture;

  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    exerciseFuture = api.getExerciseByName(widget.movementName);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo(String url) async {
    if (_videoController != null) return;

    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(url),
        httpHeaders: {
          'X-RapidAPI-Key': MuscleWikiApiService.apiKey,
          'X-RapidAPI-Host': MuscleWikiApiService.host,
        },
      );

      await _videoController!.initialize();
      _videoController!.setLooping(true); // Video berulang otomatis
      _videoController!.play(); // Auto-play saat siap

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Error initializing video: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.of(context).size.height * 0.7;

    return Container(
      height: sheetHeight,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0B0B0B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: FutureBuilder<List<ExerciseModel>>(
        future: exerciseFuture,
        builder: (context, snapshot) {
          // 1. LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          // 2. ERROR
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    "Gagal memuat data",
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  ),
                ],
              ),
            );
          }

          // 3. EMPTY
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "Gerakan '${widget.movementName}' tidak ditemukan.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }

          // 4. DATA FOUND
          final ExerciseModel data = snapshot.data!.first;
          
          final String? videoUrl = data.videos.isNotEmpty ? data.videos.first : null;

          if (videoUrl != null && _videoController == null) {
            _initializeVideo(videoUrl);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Drag Handle ---
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              // --- Judul Gerakan ---
              Text(
                data.name.isNotEmpty ? data.name : widget.movementName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // --- Video Player ---
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: videoUrl != null
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            // Video Display
                            if (_isVideoInitialized)
                              VideoPlayer(_videoController!)
                            else
                              const CircularProgressIndicator(color: Colors.white),

                            // Tombol Play/Pause Overlay
                            if (_isVideoInitialized)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_videoController!.value.isPlaying) {
                                      _videoController!.pause();
                                    } else {
                                      _videoController!.play();
                                    }
                                  });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: AnimatedOpacity(
                                      opacity: _videoController!.value.isPlaying ? 0.0 : 1.0,
                                      duration: const Duration(milliseconds: 200),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.videocam_off, color: Colors.white30, size: 40),
                              SizedBox(height: 8),
                              Text(
                                "Video tidak tersedia",
                                style: TextStyle(color: Colors.white30),
                              ),
                            ],
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Instruksi:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // --- Steps List ---
              Expanded(
                child: data.steps.isNotEmpty
                    ? ListView.separated(
                        itemCount: data.steps.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 15),
                        itemBuilder: (context, index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Bubble Nomor
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Teks Instruksi
                              Expanded(
                                child: Text(
                                  data.steps[index],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    height: 1.4,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          "Tidak ada instruksi tertulis.",
                          style: TextStyle(color: Colors.white30),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}