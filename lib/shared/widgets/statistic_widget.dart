import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class StatisticCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const StatisticCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: AppColors.lightText,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: AppColors.mutedText.withValues(alpha: 0.15)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),

          const SizedBox(height: 10),

          textBaloo2(value, fontSize: 22, fontWeight: FontWeight.w800),

          const SizedBox(height: 2),

          textPoppins(title, fontSize: 10, color: AppColors.mutedText),
        ],
      ),
    );
  }
}