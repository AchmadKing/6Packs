class ExerciseModel {
  final String name;
  final List<String> steps;
  final List<String> videos;

  ExerciseModel({
    required this.name,
    required this.steps,
    required this.videos,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    // 1. Ambil Steps
    List<String> parsedSteps = [];
    if (json['steps'] != null) {
      parsedSteps = List<String>.from(json['steps']);
    }

    // 2. Ambil Videos dengan PRIORITAS ANGLE SIDE
    List<String> parsedVideos = [];

    if (json['videos'] != null && json['videos'] is List) {
      List<dynamic> videoList = json['videos'];

      // A. Cari video dengan angle 'side' secara spesifik
      var sideVideo = videoList.firstWhere(
        (v) => v is Map && v['angle'] == 'side',
        orElse: () => null,
      );

      // B. Jika ketemu angle side, masukkan dia ke urutan PERTAMA
      if (sideVideo != null && sideVideo['url'] != null) {
        parsedVideos.add(sideVideo['url'].toString());
      }

      // C. Masukkan video sisanya (misal: front)
      for (var v in videoList) {
        if (v is Map && v['url'] != null) {
          String url = v['url'].toString();
          
          // Cek supaya tidak memasukkan video side dua kali (duplikat)
          if (sideVideo != null && url == sideVideo['url']) {
            continue; 
          }
          
          parsedVideos.add(url);
        }
      }
    }

    return ExerciseModel(
      name: json['name'] ?? '',
      steps: parsedSteps,
      videos: parsedVideos,
    );
  }
}