import 'package:flutter/material.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class Button extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color bgColor;
  final double fontSize;
  final FontWeight fontWeight;
  final BorderRadius borderRadius;
  final VoidCallback onPressed;
  final double paddingVertical;
  final double paddingHorizontal;

  const Button({
    super.key,
    required this.text,
    required this.textColor,
    required this.bgColor,
    required this.fontSize,
    required this.fontWeight,
    required this.borderRadius,
    required this.onPressed,
    this.paddingVertical = 8,
    this.paddingHorizontal = 16,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(color: bgColor, borderRadius: borderRadius),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
            vertical: paddingVertical,
          ),
          child: textPoppins(
            text,
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final Color boxColor;
  final Color iconColor;
  final GestureTapCallback onTap;
  final IconData iconData;
  final double? padding;
  final double? size;
  final BorderRadius? borderRadius;
  final Color? boxShadowColor;

  const CustomIconButton({
    super.key,
    required this.boxColor,
    required this.iconColor,
    required this.onTap,
    required this.iconData,
    this.padding,
    this.size,
    this.borderRadius,
    this.boxShadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadius ?? BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding ?? 10),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: borderRadius ?? BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: boxShadowColor ?? Colors.black.withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(iconData, color: iconColor, size: size),
      ),
    );
  }
}

class FlexibleButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color bgColor;
  final double fontSize;
  final FontWeight fontWeight;
  final BorderRadius borderRadius;
  final VoidCallback onPressed;
  final double width;
  final double paddingVertical;
  final double paddingHorizontal;

  const FlexibleButton({
    super.key,
    required this.text,
    required this.textColor,
    required this.bgColor,
    required this.fontSize,
    required this.fontWeight,
    required this.borderRadius,
    required this.onPressed,
    required this.width,
    this.paddingVertical = 8,
    this.paddingHorizontal = 16,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        decoration: BoxDecoration(color: bgColor, borderRadius: borderRadius),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
              vertical: paddingVertical,
            ),
            child: textPoppins(
              text,
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
