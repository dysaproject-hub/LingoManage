
import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class SummaryItem extends StatelessWidget {
  final String title;
  final String value;

  const SummaryItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: textPoppins(title, fontSize: 12, color: AppColors.mutedText),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: textPoppins(
              value,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
