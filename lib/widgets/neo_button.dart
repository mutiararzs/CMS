import 'package:flutter/material.dart';

import '../utils/theme.dart';

/// Tombol lebar penuh dengan garis tebal dan bayangan keras.
class NeoButton extends StatelessWidget {
  const NeoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.orange,
    this.textColor = Colors.white,
    this.fontSize = 20,
    this.letterSpacing = 1.0,
    this.verticalPadding = 14,
    this.shadow = 3,
    this.icon,
    this.iconAtEnd = true,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final double fontSize;
  final double letterSpacing;
  final double verticalPadding;
  final double shadow;
  final IconData? icon;
  final bool iconAtEnd;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || isLoading;

    final iconWidget = icon == null
        ? null
        : Icon(icon, size: fontSize * 0.8, color: textColor);

    final children = <Widget>[
      if (iconWidget != null && !iconAtEnd) ...[iconWidget, const SizedBox(width: 8)],
      Flexible(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppText.mono(
            size: fontSize,
            color: textColor,
            letterSpacing: letterSpacing,
          ),
        ),
      ),
      if (iconWidget != null && iconAtEnd) ...[const SizedBox(width: 8), iconWidget],
    ];

    return Semantics(
      button: true,
      enabled: !disabled,
      label: label,
      child: Container(
        width: double.infinity,
        decoration: neoBox(color: color, shadow: shadow),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: disabled ? null : onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding,
                horizontal: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: isLoading
                    ? [
                        SizedBox(
                          width: fontSize,
                          height: fontSize,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'MEMPROSES...',
                          style: AppText.mono(
                            size: fontSize,
                            color: textColor,
                            letterSpacing: letterSpacing,
                          ),
                        ),
                      ]
                    : children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}