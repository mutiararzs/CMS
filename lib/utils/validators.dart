class Validators {
  Validators._();

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email wajib diisi';
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(v)) return 'Format email tidak valid';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Kata sandi wajib diisi';
    if (v.length < 8) return 'Kata sandi minimal 8 karakter';
    return null;
  }

  static String? fullName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Nama lengkap wajib diisi';
    if (v.length < 3) return 'Nama terlalu pendek';
    return null;
  }

  /// Tanggal lahir tidak wajib (sesuai desain), tapi kalau diisi harus dd/mm/yyyy.
  static String? birthDate(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(v)) {
      return 'Gunakan format dd/mm/yyyy';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final v = value ?? '';
    if (v.isEmpty) return 'Konfirmasi kata sandi wajib diisi';
    if (v != password) return 'Kata sandi tidak sama';
    return null;
  }
}