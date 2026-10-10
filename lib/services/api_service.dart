import 'package:dio/dio.dart';

import '../models/user.dart';
import '../utils/constants.dart';

/// Hasil login yang berhasil.
class LoginResult {
  final String token;
  final User user;

  const LoginResult({required this.token, required this.user});
}

/// Error yang pesannya aman ditampilkan langsung ke pengguna.
class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: apiTimeout,
      receiveTimeout: apiTimeout,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// Kontrak yang perlu disepakati dengan tim backend:
  ///
  /// POST /auth/login
  /// Request : { "email": "...", "password": "..." }
  /// Response: { "token": "...",
  ///             "user": { "user_id": 1, "nama": "...", "email": "...",
  ///                       "role": "siswa", "sekolah": "..." } }
  /// Gagal   : 401 + { "message": "..." }
  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    if (useMock) return _mockLogin(email, password);

    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      return LoginResult(
        token: data['token'] as String,
        user: User.fromJson(data['user'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException(_messageFromDio(e));
    } on TypeError {
      // Format response dari backend tidak sesuai kontrak.
      throw const ApiException(
        'Data dari server tidak sesuai. Hubungi tim backend.',
      );
    }
  }

  Future<LoginResult> _mockLogin(String email, String password) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    if (email.toLowerCase() != mockEmail || password != mockPassword) {
      throw const ApiException('Email atau kata sandi salah.');
    }

    return const LoginResult(
      token: 'mock-token-123',
      user: User(
        id: '1',
        nama: 'Siswa Contoh',
        email: mockEmail,
        role: 'siswa',
        sekolah: 'SMA Contoh Jakarta',
      ),
    );
  }

  String _messageFromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi ke server terlalu lama. Coba lagi.';
      case DioExceptionType.connectionError:
        return 'Tidak dapat terhubung ke server. Periksa koneksi internetmu.';
      default:
        break;
    }

    final status = e.response?.statusCode;
    if (status == 401) return 'Email atau kata sandi salah.';

    final body = e.response?.data;
    if (body is Map && body['message'] is String) {
      return body['message'] as String;
    }
    return 'Terjadi kesalahan di server. Coba lagi nanti.';
  }
}