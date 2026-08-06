import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';

Widget textPagratiNarrow(
  String text, {
  TextAlign textAlign = TextAlign.left,
  Color color = AppColors.black,
  double fontSize = 12,
  FontWeight fontWeight = FontWeight.w400,
}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      fontFamily: 'PragatiNarrow',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
  );
}

Widget textPoppins(
  String text, {
  TextAlign textAlign = TextAlign.left,
  Color color = AppColors.black,
  double fontSize = 12,
  FontWeight fontWeight = FontWeight.w400,
  TextDecoration textDecoration = TextDecoration.none
}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      decoration: textDecoration,
      fontFamily: 'Poppins',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
  );
}
