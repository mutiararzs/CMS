import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixAsset,
    required this.prefixSize,
    required this.controller,
    this.prefixLeft = 14,
    this.textStart,
    this.borderRadius = 10,
    this.labelColor = AppColors.textDark,
    this.labelIndent = 0,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.autofillHints,
    this.textInputAction,
  });

  final String label;
  final String hint;
  final String prefixAsset;
  final Size prefixSize;
  final TextEditingController controller;

  /// Jarak ikon dari tepi kiri input.
  final double prefixLeft;

  /// Posisi awal teks dari tepi kiri input. Kalau null: ikon + 8px.
  final double? textStart;

  final double borderRadius;
  final Color labelColor;
  final double labelIndent;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final start = textStart ?? prefixLeft + prefixSize.width + 8;
    final gapRight = math.max(0.0, start - prefixLeft - prefixSize.width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: labelIndent),
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(color: labelColor),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          autofillHints: autofillHints,
          textInputAction: textInputAction,
          style: AppTextStyles.input,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: AppTextStyles.hint,
            errorStyle: AppTextStyles.error,
            contentPadding: const EdgeInsets.fromLTRB(0, 14, 16, 14),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: prefixLeft, right: gapRight),
              child: SvgPicture.asset(
                prefixAsset,
                width: prefixSize.width,
                height: prefixSize.height,
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: suffix,
            suffixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            border: _border(Colors.transparent),
            enabledBorder: _border(Colors.transparent),
            focusedBorder: _border(Colors.transparent),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: color, width: 1),
      );
}