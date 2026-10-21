class RegisterRequest {
  final String fullName;
  final String birthDate;
  final String email;
  final String password;

  const RegisterRequest({
    required this.fullName,
    required this.birthDate,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'birth_date': birthDate,
        'email': email,
        'password': password,
      };
}