import 'package:flutter/material.dart';
import '../models/login_request.dart';
import '../services/auth_services.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({AuthService? authService})
      : _authService = authService ?? AuthService();

  final AuthService _authService;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _disposed = false;
  String? _errorMessage;

  bool get rememberMe => _rememberMe;
  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<bool> login() async {
    // Cegah submit ganda saat proses login masih berjalan.
    if (_isLoading) return false;
    if (!(formKey.currentState?.validate() ?? false)) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authService.login(
        LoginRequest(
          email: emailController.text.trim(),
          password: passwordController.text,
          rememberMe: _rememberMe,
        ),
      );
      if (!success) {
        _errorMessage = 'Email atau kata sandi salah.';
      }
      return success;
    } catch (_) {
      _errorMessage = 'Gagal masuk. Periksa koneksi internet lalu coba lagi.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithSocial(String providerName) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.loginWithSocial(providerName);
    } catch (_) {
      _errorMessage = 'Gagal masuk dengan $providerName. Silakan coba lagi.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Hindari error "notifyListeners after dispose" jika halaman sudah ditutup
  // saat proses async masih berjalan.
  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}