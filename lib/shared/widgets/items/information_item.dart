
import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class InformationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const InformationItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,

          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),

          child: Icon(icon, size: 20, color: AppColors.primary),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textPoppins(
                title,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),

              const SizedBox(height: 3),

              textPoppins(
                description,
                fontSize: 11,
                color: AppColors.mutedText,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
