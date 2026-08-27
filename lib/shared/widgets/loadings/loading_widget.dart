import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  final Color? color;
  final double? size;

  const LoadingWidget({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeRotatingDots(
        color: color ?? AppColors.black,
        size: size ?? 50,
      ),
    );
  }
}