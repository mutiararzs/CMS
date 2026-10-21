import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/social_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_styles.dart';
import 'divider_with_label.dart';

/// Kartu "ATAU MASUK DENGAN" + tombol Google & Apple.
class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key, required this.onPressed});

  /// Kalau null, tombol nonaktif.
  final ValueChanged<SocialProvider>? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          const DividerWithLabel(label: AppStrings.orLoginWith),
          Row(
            children: [
              for (var i = 0; i < SocialProvider.all.length; i++) ...[
                if (i > 0) const SizedBox(width: 9),
                Expanded(
                  child: SocialLoginButton(
                    provider: SocialProvider.all[i],
                    onPressed: onPressed == null
                        ? null
                        : () => onPressed!(SocialProvider.all[i]),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.provider,
    required this.onPressed,
  });

  final SocialProvider provider;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialIcon(type: provider.type),
                const SizedBox(width: 8),
                Text(provider.name, style: AppTextStyles.socialButton),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Ikon 20x20. Posisi tiap potongan SVG mengikuti persentase di kode React.
class _SocialIcon extends StatelessWidget {
  const _SocialIcon({required this.type});

  final SocialType type;

  static const double _size = 20;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        children: type == SocialType.google
            ? [
                _piece(AppAssets.google1, 0.5, 0.425, 0.5, 0.575),
                _piece(AppAssets.google2, 0.0517, 0.5946, 0.9483, 0.4054),
                _piece(AppAssets.google3, 0, 0.2742, 1, 0.7258),
                _piece(AppAssets.google4, 0.0517, 0, 0.9483, 1),
              ]
            : [
                _piece(AppAssets.apple, 0.161, 0.1375, 0.839, 0.8625),
              ],
      ),
    );
  }

  Widget _piece(String asset, double l, double t, double w, double h) {
    return Positioned(
      left: _size * l,
      top: _size * t,
      width: _size * w,
      height: _size * h,
      child: SvgPicture.asset(asset, fit: BoxFit.fill),
    );
  }
}