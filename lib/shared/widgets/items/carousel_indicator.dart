import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';

class CarouselIndicator extends StatelessWidget {
  final int currentIndex;
  final List data;
  const CarouselIndicator({
    super.key,
    required this.currentIndex,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(data.length, (index) {
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 20 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.mutedText,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}
