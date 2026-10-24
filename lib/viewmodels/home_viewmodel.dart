import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  // TODO: ganti data dummy ini dengan data dari REST API saat backend siap.
  final String name = 'Rizky';
  final String studentInfo = 'Siswa Kelas 12 SMA • IPA';

  final int totalQuestions = 60;
  final int estimatedMinutes = 25;
  final DateTime assessmentDate = DateTime(2024, 5, 18);

  final String lastTestTitle = 'Tes RIASEC Minat & Bakat';
  final DateTime lastTestDate = DateTime(2024, 5, 18);
  final int matchPercent = 98;
  final String dominantType = 'Visual • Spasial';

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  String get greeting {
    final h = DateTime.now().hour;
    final salam = h < 11
        ? 'Selamat Pagi'
        : h < 15
            ? 'Selamat Siang'
            : h < 18
                ? 'Selamat Sore'
                : 'Selamat Malam';
    return '$salam, $name!';
  }

  String get assessmentDateText => formatDate(assessmentDate);
  String get lastTestDateText => formatDate(lastTestDate);

  void selectTab(int index) {
    if (index == _tabIndex) return;
    _tabIndex = index;
    notifyListeners();
  }

  String formatDate(DateTime d) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}