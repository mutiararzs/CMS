import 'package:flutter/material.dart';

import '../utils/login_colors.dart';

/// Logo aplikasi "Peta Masa Depanku".
///
/// File sumber 1024x1024 (PNG transparan). Gambar didekode sesuai ukuran
/// tampil x devicePixelRatio supaya tetap tajam di layar HD tanpa
/// menghabiskan memori.
class AppLogo extends StatelessWidget {
  static const assetPath = 'assets/images/logo-peta-masa-depanku.png';

  final double size;

  const AppLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final px = (size * MediaQuery.devicePixelRatioOf(context)).round();

    return Image.asset(
      assetPath,
      width: size,
      height: size,
      cacheWidth: px,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      semanticLabel: 'Logo Peta Masa Depanku',
      errorBuilder: (_, __, ___) => Icon(
        Icons.explore,
        size: size,
        color: LoginColors.link,
      ),
    );
  }
}