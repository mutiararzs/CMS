class User {
  final String id;
  final String nama;
  final String email;
  final String role; // 'siswa' atau 'admin'
  final String? sekolah;

  const User({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
    this.sekolah,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'].toString(),
      nama: json['nama'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      sekolah: json['sekolah'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'nama': nama,
      'email': email,
      'role': role,
      'sekolah': sekolah,
    };
  }
}