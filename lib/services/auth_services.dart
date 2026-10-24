import 'package:dio/dio.dart';

import '../models/login_request.dart';
import '../models/register_request.dart';

class AuthService {
  /// Ubah ke false dan isi baseUrl saat REST API dari tim backend sudah siap.
  static const bool useDummy = true;
  static const String baseUrl = 'https://api.example.com/api';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// Mengembalikan true jika login berhasil.
  /// Error jaringan/server dilempar ke pemanggil (ditangkap di LoginViewModel).
  Future<bool> login(LoginRequest request) async {
    if (useDummy) {
      await Future.delayed(const Duration(milliseconds: 800));
      return true;
    }

    final res = await _dio.post('/auth/login', data: request.toJson());
    return res.statusCode == 200;
  }

  /// Mengembalikan true jika pendaftaran berhasil.
  Future<bool> register(RegisterRequest request) async {
    if (useDummy) {
      await Future.delayed(const Duration(milliseconds: 800));
      return true;
    }

    final res = await _dio.post('/auth/register', data: request.toJson());
    return res.statusCode == 200 || res.statusCode == 201;
  }

  Future<void> loginWithSocial(String providerName) async {
    // TODO: sambungkan ke Google/Apple sign-in saat backend siap.
    await Future.delayed(const Duration(milliseconds: 500));
  }
}