import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  // TODO: ganti data dummy ini dengan data dari REST API saat backend siap.
  final String name = 'Rizky Pratama';
  final String studentInfo = 'Siswa Kelas 12 SMA • IPA 1';
  final String school = 'SMA Negeri 70 Jakarta';
  final int completedCount = 3;

  final String lastTestTitle = 'Tes RIASEC Minat\nKarir';
  final String lastTestDate = '18 Mei 2024';
  final String lastTestLevel = 'Tinggi';
  final String lastTestType = 'Investigatif';

  final String appVersion = 'Bakat Mercu Mobile v1.0.0';
}