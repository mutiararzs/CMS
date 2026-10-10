import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import 'api_service.dart';

/// Menyimpan sesi login di perangkat.
/// Catatan: shared_preferences tidak terenkripsi. Untuk versi akhir,
/// pertimbangkan flutter_secure_storage untuk menyimpan token.
class LocalStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  Future<void> saveSession(LoginResult session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, session.token);
    await prefs.setString(_userKey, jsonEncode(session.user.toJson()));
  }

  /// Mengembalikan null jika tidak ada sesi tersimpan atau datanya rusak.
  Future<LoginResult?> readSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userJson = prefs.getString(_userKey);
    if (token == null || userJson == null) return null;

    try {
      final user = User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      return LoginResult(token: token, user: user);
    } catch (_) {
      await clearSession();
      return null;
    }
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}