import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: AppColors.lightText,
        borderRadius: BorderRadius.circular(15),

        border: Border.all(color: AppColors.mutedText.withValues(alpha: 0.2)),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(icon, color: AppColors.primary, size: 21),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                textPoppins(title, fontSize: 11, color: AppColors.mutedText),

                const SizedBox(height: 4),

                textPoppins(value, fontSize: 14, fontWeight: FontWeight.w600),
              ],
            ),
          ),
        ],
      ),
    );
  }
}