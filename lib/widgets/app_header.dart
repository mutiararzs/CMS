import 'package:flutter/material.dart';

import '../utils/theme.dart';

/// Header putih semi-transparan setinggi 64 dengan judul di tengah.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key, required this.title, this.showBack = false});

  final String title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xCCFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showBack)
            Positioned(
              left: 4,
              child: IconButton(
                tooltip: 'Kembali',
                icon: const Icon(Icons.arrow_back, color: AppColors.ink),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          Text(
            title,
            style: AppText.mono(
              size: 16,
              letterSpacing: 0.8,
              height: 22 / 16,
            ),
          ),
        ],
      ),
    );
  }
}