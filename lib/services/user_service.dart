import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _keyCurrentSession = 'current_session_user';

  static Future<String?> _getCurrentUserKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCurrentSession);
  }

  // --- AUTH & USER DATA (SAMA SEPERTI SEBELUMNYA) ---
  static Future<bool> checkUserExists(String username, String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(username);
  }

  static Future<void> register(String username, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userData = {
      'email': email,
      'password': password,
      'image_path': null,
      'is_question_done': false,
      'weekly_target': 3,
      'workout_logs': [], 
      'workout_history': [], // LIST BARU: Untuk menyimpan detail histori
    };
    await prefs.setString(username, jsonEncode(userData));
    await prefs.setString(_keyCurrentSession, username);
  }

  static Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(username);
    if (jsonString == null) return false;
    try {
      Map<String, dynamic> userData = jsonDecode(jsonString);
      if (userData['password'] == password) {
        await prefs.setString(_keyCurrentSession, username);
        return true;
      }
    } catch (e) { return false; }
    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentSession);
  }

  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? currentUsername = prefs.getString(_keyCurrentSession);
    if (currentUsername == null) return {'username': 'User', 'email': '', 'image': null};
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

  static Future<void> updateProfile({String? newUsername, String? newImagePath}) async {
    final prefs = await SharedPreferences.getInstance();
    String? oldUsername = prefs.getString(_keyCurrentSession);
    if (oldUsername == null) return;
    String? jsonString = prefs.getString(oldUsername);
    if (jsonString == null) return;
    Map<String, dynamic> userData = jsonDecode(jsonString);

    if (newImagePath != null) userData['image_path'] = newImagePath;
    if (newUsername != null && newUsername != oldUsername) {
      await prefs.remove(oldUsername);
      await prefs.setString(newUsername, jsonEncode(userData));
      await prefs.setString(_keyCurrentSession, newUsername);
    } else {
      await prefs.setString(oldUsername, jsonEncode(userData));
    }
  }

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

  static Future<bool> isFirstLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? currentUsername = prefs.getString(_keyCurrentSession);
    if (currentUsername == null) return false;
    String? jsonString = prefs.getString(currentUsername);
    if (jsonString != null) {
      Map<String, dynamic> userData = jsonDecode(jsonString);
      return userData['is_question_done'] != true; 
    }
    return false;
  }

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

  static Future<void> logWorkoutToday() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = await _getCurrentUserKey();
    if (username == null) return;
    String? jsonString = prefs.getString(username);
    if (jsonString != null) {
      Map<String, dynamic> userData = jsonDecode(jsonString);
      List<String> logs = [];
      if (userData['workout_logs'] != null) {
        logs = List<String>.from(userData['workout_logs']);
      }
      String today = DateTime.now().toLocal().toIso8601String().split('T')[0];
      if (!logs.contains(today)) {
        logs.add(today);
        userData['workout_logs'] = logs;
        await prefs.setString(username, jsonEncode(userData));
      }
    }
  }

  static Future<Map<String, dynamic>> getWeeklyProgress() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = await _getCurrentUserKey();
    int target = 3;
    List<int> completedDays = [];
    int completedCount = 0;

    if (username != null) {
      String? jsonString = prefs.getString(username);
      if (jsonString != null) {
        Map<String, dynamic> userData = jsonDecode(jsonString);
        target = userData['weekly_target'] ?? 3;
        List<String> logs = [];
        if (userData['workout_logs'] != null) logs = List<String>.from(userData['workout_logs']);
        
        DateTime now = DateTime.now();
        DateTime startOfWeek = DateTime(now.year, now.month, now.day - (now.weekday - 1));
        DateTime endOfWeek = startOfWeek.add(const Duration(days: 7));

        for (String logDate in logs) {
          DateTime date = DateTime.parse(logDate);
          if ((date.isAfter(startOfWeek) || date.isAtSameMomentAs(startOfWeek)) && date.isBefore(endOfWeek)) {
            if (!completedDays.contains(date.weekday)) completedDays.add(date.weekday);
          }
        }
        completedCount = completedDays.length;
      }
    }
    return {'target': target, 'completed_count': completedCount, 'completed_days': completedDays};
  }


  // ==========================================
  // 5. NOTIFIKASI SETTINGS
  // ==========================================

  // Simpan Pengaturan Notifikasi
  static Future<void> saveNotificationSettings({
    required bool isEnabled,
    required int hour,
    required int minute,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? username = await _getCurrentUserKey();
    if (username == null) return;

    String? jsonString = prefs.getString(username);
    if (jsonString != null) {
      Map<String, dynamic> userData = jsonDecode(jsonString);
      
      // Simpan data notif ke JSON user
      userData['notif_enabled'] = isEnabled;
      userData['notif_hour'] = hour;
      userData['notif_minute'] = minute;

      await prefs.setString(username, jsonEncode(userData));
    }
  }

  // Ambil Pengaturan Notifikasi
  // Return: { 'enabled': bool, 'hour': int, 'minute': int }
  static Future<Map<String, dynamic>> getNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = await _getCurrentUserKey();
    
    // Default values
    bool enabled = false;
    int hour = 19; // Default jam 7 malam
    int minute = 0;

    if (username != null) {
      String? jsonString = prefs.getString(username);
      if (jsonString != null) {
        Map<String, dynamic> userData = jsonDecode(jsonString);
        enabled = userData['notif_enabled'] ?? false;
        hour = userData['notif_hour'] ?? 19;
        minute = userData['notif_minute'] ?? 0;
      }
    }

    return {'enabled': enabled, 'hour': hour, 'minute': minute};
  }

  // ==========================================
  // FITUR BARU: HISTORI LATIHAN
  // ==========================================

  // Simpan Detail Latihan ke Histori
  static Future<void> saveWorkoutHistory({
    required String packageLevel,
    required int exerciseCount,
    required int calories,
    required int durationSeconds,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? username = await _getCurrentUserKey();
    if (username == null) return;

    String? jsonString = prefs.getString(username);
    if (jsonString != null) {
      Map<String, dynamic> userData = jsonDecode(jsonString);
      
      // Ambil list history lama
      List<dynamic> history = userData['workout_history'] ?? [];
      
      // Buat entry baru
      Map<String, dynamic> newEntry = {
        'date': DateTime.now().toIso8601String(), // Simpan tanggal lengkap dengan jam
        'package': packageLevel,
        'count': exerciseCount,
        'calories': calories,
        'duration': durationSeconds,
      };
      
      // Tambahkan di awal list (biar paling baru di atas)
      history.insert(0, newEntry);
      
      // Simpan balik
      userData['workout_history'] = history;
      await prefs.setString(username, jsonEncode(userData));
    }
  }

  // Ambil List Histori
  static Future<List<Map<String, dynamic>>> getWorkoutHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = await _getCurrentUserKey();
    if (username == null) return [];

    String? jsonString = prefs.getString(username);
    if (jsonString != null) {
      Map<String, dynamic> userData = jsonDecode(jsonString);
      List<dynamic> history = userData['workout_history'] ?? [];
      return List<Map<String, dynamic>>.from(history);
    }
    return [];
  }
}