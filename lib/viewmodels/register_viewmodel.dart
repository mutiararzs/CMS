import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final birthDateController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirm = true;
  bool acceptedTerms = false;
  bool showTermsError = false;
  bool isLoading = false;
  String? errorMessage;

  void togglePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleConfirm() {
    obscureConfirm = !obscureConfirm;
    notifyListeners();
  }

  void toggleTerms(bool value) {
    acceptedTerms = value;
    showTermsError = !value;
    notifyListeners();
  }

  void setBirthDate(DateTime date) {
    birthDateController.text =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    notifyListeners();
  }

  Future<bool> register() async {
    errorMessage = null;
    showTermsError = !acceptedTerms;
    
    if (!(formKey.currentState?.validate() ?? false) || !acceptedTerms) {
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      // Simulasi proses registrasi (API call)
      await Future.delayed(const Duration(seconds: 2));
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void signInWithSocial(String providerName) {
    // Implementasi social login
  }

  @override
  void dispose() {
    nameController.dispose();
    birthDateController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}