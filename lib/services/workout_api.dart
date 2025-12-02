import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/workout_model.dart';

class MuscleWikiApiService {
  // ==========================================
  // KONFIGURASI API
  // ==========================================
  
  // Base URL & Host untuk endpoint Search
  static const String baseUrl = "https://musclewiki-api.p.rapidapi.com";
  static const String host = "musclewiki-api.p.rapidapi.com";

  // API Key
  static const String apiKey = "5840f494d9mshfb767291798eaeep16ab87jsn34803f766563"; 

  // ==========================================
  // FUNGSI GET DATA
  // ==========================================
  Future<List<ExerciseModel>> getExerciseByName(String name) async {
    final url = Uri.parse("$baseUrl/search").replace(queryParameters: {
      'q': name,
    });

    try {
      final response = await http.get(
        url,
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': host,
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        
        // Mapping JSON ke Model
        return data.map((json) => ExerciseModel.fromJson(json)).toList();
      } else {
        print("API Error Code: ${response.statusCode}");
        print("API Error Body: ${response.body}");
        throw Exception("Gagal mengambil data latihan: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
      rethrow;
    }
  }
}