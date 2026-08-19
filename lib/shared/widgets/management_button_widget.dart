import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class ManagementButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onPressed;

  const ManagementButton({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lightText,

      borderRadius: BorderRadius.circular(15),

      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onPressed,

        child: Container(
          padding: const EdgeInsets.all(14),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),

            border: Border.all(
              color: AppColors.mutedText.withValues(alpha: 0.15),
            ),
          ),

          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,

                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(icon, color: AppColors.primary),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textPoppins(
                      title,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),

                    const SizedBox(height: 3),

                    textPoppins(
                      description,
                      fontSize: 10,
                      color: AppColors.mutedText,
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.mutedText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}