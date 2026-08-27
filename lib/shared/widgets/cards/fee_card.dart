import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class FeeCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;

  const FeeCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: AppColors.lightText,
        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: AppColors.mutedText.withValues(alpha: 0.18)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon == null
              ? SizedBox.shrink()
              : Icon(icon, size: 20, color: AppColors.primary),

          const SizedBox(height: 8),

          textPoppins(title, fontSize: 10, color: AppColors.mutedText),

          const SizedBox(height: 3),

          textPoppins(
            value,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ],
      ),
    );
  }
}
