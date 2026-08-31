import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class LittleBadge extends StatelessWidget {
  final String text;
  final Color color;

  const LittleBadge({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),

      child: textPoppins(
        text,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.lightText,
      ),
    );
  }
}
