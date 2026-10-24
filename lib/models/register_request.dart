class RegisterRequest {
  final String fullName;
  final DateTime birthDate;
  final String email;
  final String password;

  const RegisterRequest({
    required this.fullName,
    required this.birthDate,
    required this.email,
    required this.password,
  });

  /// Format tanggal Lahir
  String get birthDateIso {
    final m = birthDate.month.toString().padLeft(2, '0');
    final d = birthDate.day.toString().padLeft(2, '0');
    return '${birthDate.year}-$m-$d';
  }

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'birth_date': birthDateIso,
        'email': email,
        'password': password,
      };
}