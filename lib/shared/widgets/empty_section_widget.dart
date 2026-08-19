import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class EmptySection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  const EmptySection({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: AppColors.mutedText.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: AppColors.mutedText.withValues(alpha: 0.12)),
      ),

      child: Column(
        children: [
          Icon(icon, size: 34, color: AppColors.mutedText),

          const SizedBox(height: 10),

          textPoppins(title, fontSize: 14, fontWeight: FontWeight.w600),

          const SizedBox(height: 5),

          textPoppins(
            description,
            textAlign: TextAlign.center,
            fontSize: 11,
            color: AppColors.mutedText,
          ),

          const SizedBox(height: 12),

          OutlinedButton(
            onPressed: onPressed,

            child: textPoppins(
              buttonText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}