import 'package:flutter/material.dart';

enum RiwayatStatus { selesai, dalamProses }

class RiwayatItem {
  final String dateText;
  final RiwayatStatus status;
  final IconData icon;
  final String title;
  final String description;

  /// Kotak hasil: label kecil, nilai utama, dan persentase.
  final String detailLabel;
  final String detailValue;
  final int percent;

  /// Pil putih di kanan kotak hasil. [pillPrefix] opsional (mis. "Holland:").
  final String? pillPrefix;
  final IconData? pillIcon;
  final String pillText;

  /// true jika halaman detail hasil untuk tes ini sudah tersedia.
  final bool hasResultPage;

  const RiwayatItem({
    required this.dateText,
    required this.status,
    required this.icon,
    required this.title,
    required this.description,
    required this.detailLabel,
    required this.detailValue,
    required this.percent,
    this.pillPrefix,
    this.pillIcon,
    required this.pillText,
    this.hasResultPage = false,
  });

  bool get isDone => status == RiwayatStatus.selesai;
}

class RiwayatViewModel extends ChangeNotifier {
  // TODO: ganti data dummy ini dengan data dari REST API saat backend siap.
  final List<RiwayatItem> _items = const [
    RiwayatItem(
      dateText: '18 Mei 2024',
      status: RiwayatStatus.selesai,
      icon: Icons.explore_outlined,
      title: 'Tes Minat RIASEC & Bakat',
      description: 'Pemetaan karir dan preferensi lingkungan\nkerja',
      detailLabel: 'Hasil Dominan',
      detailValue: 'Investigative',
      percent: 92,
      pillPrefix: 'Holland:',
      pillText: 'IRE',
      hasResultPage: true,
    ),
    RiwayatItem(
      dateText: '10 Januari 2024',
      status: RiwayatStatus.selesai,
      icon: Icons.lightbulb_outline_rounded,
      title: 'Tes Kecerdasan Majemuk',
      description: 'Analisis 8 Spektrum Inteligensi Gardner',
      detailLabel: 'Inteligensi Tertinggi',
      detailValue: 'Logis-Matematik',
      percent: 88,
      pillIcon: Icons.psychology_outlined,
      pillText: 'Analitis',
    ),
    // Contoh item "Dalam Proses" (tidak ada di desain, hanya untuk filter).
    RiwayatItem(
      dateText: '2 Juni 2024',
      status: RiwayatStatus.dalamProses,
      icon: Icons.work_outline_rounded,
      title: 'Tes Nilai Kerja',
      description: 'Preferensi nilai dan motivasi dalam berkarier',
      detailLabel: 'Progres Pengerjaan',
      detailValue: 'Soal 18 dari 40',
      percent: 45,
      pillIcon: Icons.timelapse_rounded,
      pillText: 'Belum selesai',
    ),
  ];

  RiwayatStatus? _filter; // null = Semua

  RiwayatStatus? get filter => _filter;
  int get totalCount => _items.length;
  int get doneCount => _items.where((e) => e.isDone).length;
  int get inProgressCount => totalCount - doneCount;

  List<RiwayatItem> get visibleItems =>
      _filter == null ? _items : _items.where((e) => e.status == _filter).toList();

  void setFilter(RiwayatStatus? value) {
    if (value == _filter) return;
    _filter = value;
    notifyListeners();
  }
}