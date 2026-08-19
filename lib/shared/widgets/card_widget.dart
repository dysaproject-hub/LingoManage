import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/utils/media_query_helper.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class CardWithStrokeWidget extends StatelessWidget {
  final String title;
  final String description;
  final Image? image;
  final double borderRadius;

  const CardWithStrokeWidget({
    super.key,
    required this.title,
    required this.description,
    this.image,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.black.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textBaloo2(
                  title,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: MediaQueryHelper.getScreenWidth(context) / 2,
                  child: textPoppins(
                    description,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: AppColors.black,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: image ?? SizedBox.shrink()),
        ],
      ),
    );
  }
}
