import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_styles.dart';

class RememberForgotRow extends StatelessWidget {
  const RememberForgotRow({
    super.key,
    required this.rememberMe,
    required this.onRememberChanged,
    this.onForgotPressed,
  });

  final bool rememberMe;
  final ValueChanged<bool?> onRememberChanged;
  final VoidCallback? onForgotPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onRememberChanged(!rememberMe),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: 16,
                height: 16,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: rememberMe ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(2.5),
                  border: Border.all(color: AppColors.checkboxBorder, width: 1),
                ),
                child: rememberMe
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 8),
              Text(AppStrings.rememberMe, style: AppTextStyles.caption),
            ],
          ),
        ),
        GestureDetector(
          onTap: onForgotPressed,
          child: Text(AppStrings.forgotPassword, style: AppTextStyles.link),
        ),
      ],
    );
  }
}