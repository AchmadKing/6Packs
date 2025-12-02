import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _keyCurrentSession = 'current_session_user';

  // --- HELPERS ---
  // Mendapatkan username yang sedang login saat ini
  static Future<String?> _getCurrentUserKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCurrentSession);
  }

  // ==========================================
  // 1. AUTHENTICATION (Login, Register, Cek User)
  // ==========================================

  // Cek apakah username sudah dipakai orang lain
  static Future<bool> checkUserExists(String username, String email) async {
    final prefs = await SharedPreferences.getInstance();
    // Cek apakah key (username) sudah ada di database lokal
    return prefs.containsKey(username);
  }

  // Register User Baru
  static Future<void> register(String username, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // Struktur Data User (JSON)
    Map<String, dynamic> userData = {
      'email': email,
      'password': password,
      'image_path': null,
      'is_question_done': false, // Belum isi kuesioner
      'weekly_target': 3,        // Default target 3x seminggu
      'workout_logs': [],        // Belum ada riwayat latihan
    };

    // Simpan data dengan KUNCI = USERNAME
    await prefs.setString(username, jsonEncode(userData));

    // Otomatis Login
    await prefs.setString(_keyCurrentSession, username);
  }

  // Login User
  static Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Cek apakah username ada?
    String? jsonString = prefs.getString(username);
    if (jsonString == null) return false;

    // 2. Cek password
    Map<String, dynamic> userData = jsonDecode(jsonString);
    if (userData['password'] == password) {
      await prefs.setString(_keyCurrentSession, username);
      return true;
    }
    return false;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentSession);
  }

  // ==========================================
  // 2. USER DATA & PROFILE
  // ==========================================

  // Ambil Data User Aktif
  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? currentUsername = prefs.getString(_keyCurrentSession);
    
    if (currentUsername == null) {
      return {'username': 'User', 'email': '', 'image': null};
    }

    String? jsonString = prefs.getString(currentUsername);
    if (jsonString != null) {
      Map<String, dynamic> userData = jsonDecode(jsonString);
      return {
        'username': currentUsername,
        'email': userData['email'],
        'image': userData['image_path'],
      };
    }
    return {};
  }

  // Update Profile (Username & Foto)
  static Future<void> updateProfile({String? newUsername, String? newImagePath}) async {
    final prefs = await SharedPreferences.getInstance();
    String? oldUsername = prefs.getString(_keyCurrentSession);
    if (oldUsername == null) return;

    // Ambil data lama
    String? jsonString = prefs.getString(oldUsername);
    if (jsonString == null) return;
    Map<String, dynamic> userData = jsonDecode(jsonString);

    // Update Image
    if (newImagePath != null) {
      userData['image_path'] = newImagePath;
    }

    // Update Username (Migrasi Key)
    if (newUsername != null && newUsername != oldUsername) {
      // Hapus key lama
      await prefs.remove(oldUsername);
      // Simpan di key baru
      await prefs.setString(newUsername, jsonEncode(userData));
      // Update session
      await prefs.setString(_keyCurrentSession, newUsername);
    } else {
      // Username tidak berubah, update data di key lama
      await prefs.setString(oldUsername, jsonEncode(userData));
    }
  }

  // Ganti Password
  static Future<bool> changePassword(String oldPass, String newPass) async {
    final prefs = await SharedPreferences.getInstance();
    String? currentUsername = prefs.getString(_keyCurrentSession);
    if (currentUsername == null) return false;

    String? jsonString = prefs.getString(currentUsername);
    if (jsonString == null) return false;
    Map<String, dynamic> userData = jsonDecode(jsonString);

    if (userData['password'] == oldPass) {
      userData['password'] = newPass;
      await prefs.setString(currentUsername, jsonEncode(userData));
      return true;
    }
    return false;
  }

  // ==========================================
  // 3. KUESIONER LOGIC
  // ==========================================

  // Cek apakah user baru pertama kali (belum isi kuesioner)
  static Future<bool> isFirstLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? currentUsername = prefs.getString(_keyCurrentSession);
    if (currentUsername == null) return false;

    String? jsonString = prefs.getString(currentUsername);
    if (jsonString != null) {
      Map<String, dynamic> userData = jsonDecode(jsonString);
      // Jika key 'is_question_done' true, berarti BUKAN first login
      return userData['is_question_done'] != true; 
    }
    return false;
  }

  // Tandai kuesioner selesai
  static Future<void> completeQuestionnaire() async {
    final prefs = await SharedPreferences.getInstance();
    String? currentUsername = prefs.getString(_keyCurrentSession);
    if (currentUsername == null) return;

    String? jsonString = prefs.getString(currentUsername);
    if (jsonString != null) {
      Map<String, dynamic> userData = jsonDecode(jsonString);
      userData['is_question_done'] = true;
      await prefs.setString(currentUsername, jsonEncode(userData));
    }
  }

  // ==========================================
  // 4. WORKOUT PLAN & LOGS
  // ==========================================

  // Simpan Target Mingguan
  static Future<void> setWeeklyTarget(int days) async {
    final prefs = await SharedPreferences.getInstance();
    String? username = await _getCurrentUserKey();
    if (username == null) return;

    String? jsonString = prefs.getString(username);
    if (jsonString != null) {
      Map<String, dynamic> userData = jsonDecode(jsonString);
      userData['weekly_target'] = days;
      await prefs.setString(username, jsonEncode(userData));
    }
  }

  // Ambil Target Mingguan
  static Future<int> getWeeklyTarget() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = await _getCurrentUserKey();
    if (username == null) return 3;

    String? jsonString = prefs.getString(username);
    if (jsonString != null) {
      Map<String, dynamic> userData = jsonDecode(jsonString);
      return userData['weekly_target'] ?? 3;
    }
    return 3;
  }

  // Catat Latihan Hari Ini (Dipanggil saat finish workout)
  static Future<void> logWorkoutToday() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = await _getCurrentUserKey();
    if (username == null) return;

    String? jsonString = prefs.getString(username);
    if (jsonString != null) {
      Map<String, dynamic> userData = jsonDecode(jsonString);
      
      // Ambil list log lama
      List<String> logs = (userData['workout_logs'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      
      // Tanggal hari ini (YYYY-MM-DD)
      String today = DateTime.now().toIso8601String().split('T')[0];

      // Jika hari ini belum tercatat, tambahkan
      if (!logs.contains(today)) {
        logs.add(today);
        userData['workout_logs'] = logs;
        await prefs.setString(username, jsonEncode(userData));
      }
    }
  }

  // Hitung Progres Mingguan (Untuk Lingkaran di Home Page)
  static Future<Map<String, dynamic>> getWeeklyProgress() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = await _getCurrentUserKey();
    
    int target = 3;
    List<int> completedDays = []; // List hari (1=Senin, 7=Minggu)
    int completedCount = 0;

    if (username != null) {
      String? jsonString = prefs.getString(username);
      if (jsonString != null) {
        Map<String, dynamic> userData = jsonDecode(jsonString);
        target = userData['weekly_target'] ?? 3;
        
        List<String> logs = (userData['workout_logs'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
        
        // Filter log hanya untuk MINGGU INI
        DateTime now = DateTime.now();
        // Cari hari Senin minggu ini
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        startOfWeek = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day); // Reset jam

        for (String logDate in logs) {
          DateTime date = DateTime.parse(logDate);
          // Jika log >= Senin minggu ini
          if (date.isAfter(startOfWeek.subtract(const Duration(seconds: 1)))) {
            if (!completedDays.contains(date.weekday)) {
              completedDays.add(date.weekday);
            }
          }
        }
        completedCount = completedDays.length;
      }
    }

    return {
      'target': target,
      'completed_count': completedCount,
      'completed_days': completedDays,
    };
  }
}