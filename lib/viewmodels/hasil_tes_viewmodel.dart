import 'package:flutter/material.dart';

class CareerRecommendation {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> tags;

  const CareerRecommendation({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tags,
  });
}

class MajorRecommendation {
  final String title;
  final String faculty;

  const MajorRecommendation({required this.title, required this.faculty});
}

class HasilTesViewModel extends ChangeNotifier {
  // TODO: ganti data dummy ini dengan hasil dari REST API (GET /assessments/{id}/result).
  final DateTime completedAt = DateTime(2024, 5, 18);

  final String dominantCode = 'I • R • E';
  final String dominantLabel = 'Investigatif - Realistik - Enterprising';

  final String profileTitle = 'Profil Utama: Investigatif & Realistik';
  final String profileDescription =
      'Anda memiliki rasa ingin tahu intelektual yang tajam dipadukan dengan '
      'kemampuan eksekusi teknis yang praktis dan terstruktur. Anda sangat '
      'terstimulasi ketika membedah masalah yang kompleks serta merancang '
      'solusi konkret di dunia nyata.';
  final List<String> traits = const [
    'Berpikir Analitis',
    'Eksplorasi Teknologi',
    'Problem Solver Praktis',
  ];

  final List<CareerRecommendation> careers = const [
    CareerRecommendation(
      title: 'Insinyur Perangkat Lunak',
      subtitle: 'Software Engineer • Sistem & Cloud',
      icon: Icons.code_rounded,
      tags: ['High Growth', 'Stem Tech'],
    ),
    CareerRecommendation(
      title: 'Peneliti & Analis Data',
      subtitle: 'Data Scientist • AI Specialist',
      icon: Icons.analytics_outlined,
      tags: ['Komp. Analitik', 'Machine Learning'],
    ),
    CareerRecommendation(
      title: 'Ahli Robotika & IoT',
      subtitle: 'Robotics • Otomasi Terapan',
      icon: Icons.precision_manufacturing_outlined,
      tags: ['Hardware & AI', 'Otomasi Cerdas'],
    ),
  ];

  final List<MajorRecommendation> majors = const [
    MajorRecommendation(
      title: 'Teknik Informatika / Ilmu Komputer',
      faculty: 'Fakultas Ilmu Komputer (FASILKOM)',
    ),
    MajorRecommendation(
      title: 'Sains Data & Kecerdasan Buatan',
      faculty: 'Fakultas Sains & Teknologi Matematika',
    ),
    MajorRecommendation(
      title: 'Teknik Elektro & Mekatronika',
      faculty: 'Fakultas Teknik Industri & Rekayasa',
    ),
  ];

  String get completedDateText {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    final d = completedAt;
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}