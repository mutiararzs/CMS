import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._api, this._storage);

  final ApiService _api;
  final LocalStorageService _storage;

  User? _user;
  String? _token;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  bool get isLoggedIn => _user != null;
  String? get errorMessage => _errorMessage;

  /// Dipanggil sekali saat aplikasi dibuka: pulihkan sesi yang tersimpan.
  Future<void> init() async {
    final session = await _storage.readSession();
    if (session != null) {
      _token = session.token;
      _user = session.user;
    }
    _isInitialized = true;
    notifyListeners();
  }

  /// Mengembalikan true jika login berhasil.
  Future<bool> login({
    required String email,
    required String password,
    required bool remember,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final session = await _api.login(email: email.trim(), password: password);

      if (session.user.role != 'siswa') {
        throw const ApiException(
          'Akun ini bukan akun siswa. Admin masuk lewat panel web.',
        );
      }

      if (remember) {
        await _storage.saveSession(session);
      } else {
        await _storage.clearSession();
      }

      _token = session.token;
      _user = session.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan tak terduga. Coba lagi.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void clearError() {
    if (_errorMessage == null) return;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.clearSession();
    _user = null;
    _token = null;
    _errorMessage = null;
    notifyListeners();
  }
}