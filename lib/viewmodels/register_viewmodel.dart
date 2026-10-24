import 'package:flutter/material.dart';
import '../models/register_request.dart';
import '../services/auth_services.dart';

class RegisterViewModel extends ChangeNotifier {
  RegisterViewModel({AuthService? authService})
      : _authService = authService ?? AuthService();

  final AuthService _authService;

  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final birthDateController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  DateTime? _birthDate;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;
  bool _termsError = false;
  bool _isLoading = false;
  bool _disposed = false;
  String? _errorMessage;

  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get agreeTerms => _agreeTerms;
  bool get termsError => _termsError;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setBirthDate(DateTime date) {
    _birthDate = date;
    birthDateController.text = _formatDate(date);
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void toggleAgreeTerms(bool? value) {
    _agreeTerms = value ?? false;
    if (_agreeTerms) _termsError = false;
    notifyListeners();
  }

  Future<bool> register() async {
    if (_isLoading) return false;

    final formValid = formKey.currentState?.validate() ?? false;
    _termsError = !_agreeTerms;
    if (!formValid || _termsError) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authService.register(
        RegisterRequest(
          fullName: fullNameController.text.trim(),
          birthDate: _birthDate!,
          email: emailController.text.trim(),
          password: passwordController.text,
        ),
      );
      if (!success) {
        _errorMessage = 'Pendaftaran gagal. Periksa data kamu lalu coba lagi.';
      }
      return success;
    } catch (_) {
      _errorMessage = 'Gagal mendaftar. Periksa koneksi internet lalu coba lagi.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    fullNameController.dispose();
    birthDateController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}