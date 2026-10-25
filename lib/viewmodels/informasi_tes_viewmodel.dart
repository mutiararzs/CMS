import 'package:flutter/material.dart';

class TestStat {
  final IconData icon;
  final String value;
  final String label;

  const TestStat({required this.icon, required this.value, required this.label});
}

class InformasiTesViewModel extends ChangeNotifier {
  // TODO: ganti data statis ini dengan data dari REST API saat backend siap.
  final String badge = 'Asesmen Minat Bakat';
  final String title = 'Tes Minat & Bakat (RIASEC)';
  final String description =
      'Asesmen ini dirancang untuk memetakan kepribadian, minat aktivitas, '
      'dan potensi karier ideal berdasarkan teori Holland Code.';

  final int totalQuestions = 60;
  final int estimatedMinutes = 15;

  late final List<TestStat> stats = [
    TestStat(
      icon: Icons.help_outline_rounded,
      value: '$totalQuestions Soal',
      label: 'Jumlah Pertanyaan',
    ),
    TestStat(
      icon: Icons.schedule_rounded,
      value: '$estimatedMinutes Menit',
      label: 'Estimasi Waktu',
    ),
    const TestStat(
      icon: Icons.linear_scale_rounded,
      value: 'Skala 1 - 5',
      label: 'Tipe Jawaban',
    ),
    const TestStat(
      icon: Icons.rule_rounded,
      value: 'Tanpa Skoring',
      label: 'Tidak Ada Benar/Salah',
    ),
  ];

  final List<String> instructions = const [
    'Jawablah secara jujur sesuai kondisi diri Anda saat ini.',
    'Tidak ada jawaban benar atau salah dalam tes ini.',
    'Usahakan menjawab seluruh pertanyaan tanpa ada yang terlewat.',
    'Kemajuan tes akan tersimpan otomatis jika terjadi kendala jaringan.',
  ];

  final String tip = 'Kerjakan di tempat tenang untuk hasil psikogram optimal.';

  final String dimensionTitle = 'Analisis 6 Dimensi Holland';
  final String dimensionSubtitle =
      'Realistik, Investigatif, Artistik, Sosial, Enterprising, & Konvensional';

  bool _isStarting = false;
  bool _disposed = false;
  bool get isStarting => _isStarting;

  /// Mengembalikan true jika tes siap dimulai.
  Future<bool> startTest() async {
    if (_isStarting) return false;
    _isStarting = true;
    notifyListeners();
    try {
      // TODO: POST /assessments/riasec/start via Dio, lalu ambil daftar soal.
      await Future.delayed(const Duration(milliseconds: 300));
      return true;
    } finally {
      _isStarting = false;
      notifyListeners();
    }
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}