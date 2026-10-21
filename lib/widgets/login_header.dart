import 'package:flutter/material.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    this.title = AppStrings.welcomeTitle,
    this.subtitle = AppStrings.welcomeSubtitle,
    this.titleStyle,
    this.logoGap = 16,
    this.subtitleGap = 8,
  });

  final String title;
  final String subtitle;
  final TextStyle? titleStyle;
  final double logoGap;
  final double subtitleGap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 104,
          height: 104,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color(0x0D000000), blurRadius: 1, offset: Offset(0, 1)),
            ],
          ),
          child: Image.asset(
            AppAssets.logo,
            width: 104,
            height: 104,
            fit: BoxFit.cover,
            errorBuilder: (_, error, __) {
              debugPrint('LOGO GAGAL DIMUAT: $error');
              return const SizedBox(width: 104, height: 104);
            },
          ),
        ),
        SizedBox(height: logoGap),
        Text(title, style: titleStyle ?? AppTextStyles.title),
        SizedBox(height: subtitleGap),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.subtitle,
        ),
      ],
    );
  }
}