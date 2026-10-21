import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class DividerWithLabel extends StatelessWidget {
  const DividerWithLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    // Tinggi total 21px (pt-1 + garis 1px + pb-4) seperti di kode React.
    return SizedBox(
      height: 21,
      child: Align(
        alignment: Alignment.topCenter,
        child: Transform.translate(
          offset: const Offset(0, -2),
          child: Row(
            children: [
              Expanded(child: Container(height: 1, color: AppColors.divider)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(label, style: AppTextStyles.dividerLabel),
              ),
              Expanded(child: Container(height: 1, color: AppColors.divider)),
            ],
          ),
        ),
      ),
    );
  }
}