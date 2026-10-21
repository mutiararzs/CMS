import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Lingkaran biru blur di belakang header (setara `blur-[32px]` di Tailwind).
class GlowBackground extends StatelessWidget {
  const GlowBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
      child: Container(
        width: 192,
        height: 192,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.glow,
        ),
      ),
    );
  }
}