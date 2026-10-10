import 'package:flutter/material.dart';

import '../utils/theme.dart';

/// Kolom input putih dengan garis tebal. Dipakai di dalam [Form]
/// sehingga mendukung `validator` dan pesan error di bawah kolom.
class NeoTextField extends FormField<String> {
  NeoTextField({
    super.key,
    required TextEditingController controller,
    String? hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    Iterable<String>? autofillHints,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
    ValueChanged<String>? onSubmitted,
    bool enabled = true,
    Widget? suffix,
    super.validator,
  }) : super(
          initialValue: controller.text,
          enabled: enabled,
          builder: (FormFieldState<String> field) {
            final hasError = field.hasError;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(
                        10,
                        10,
                        suffix != null ? 76 : 10,
                        10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: hasError ? AppColors.red : AppColors.ink,
                          width: 2,
                        ),
                      ),
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        enabled: enabled,
                        obscureText: obscureText,
                        keyboardType: keyboardType,
                        autofillHints: autofillHints,
                        textInputAction: textInputAction,
                        onChanged: field.didChange,
                        onSubmitted: onSubmitted,
                        cursorColor: AppColors.ink,
                        style: AppText.body(
                          size: 15,
                          height: 1.47,
                          letterSpacing: obscureText ? 0.75 : 0,
                        ),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: hint,
                          hintStyle: AppText.body(
                            size: 15,
                            height: 1.47,
                            color: AppColors.ink.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                    if (suffix != null)
                      Positioned(right: 8, child: suffix),
                  ],
                ),
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      field.errorText!,
                      style: AppText.body(
                        size: 12,
                        color: AppColors.red,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}