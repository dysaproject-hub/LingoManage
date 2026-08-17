import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';

Widget textBaloo2(
  String text, {
  TextAlign textAlign = TextAlign.left,
  Color color = AppColors.black,
  double fontSize = 12,
  FontWeight fontWeight = FontWeight.w400,
  int? maxlines,
  TextOverflow? textOverFlow,
}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxlines,
    overflow: textOverFlow,
    style: GoogleFonts.baloo2(
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
  TextDecoration textDecoration = TextDecoration.none,
  int? maxLines,
  TextOverflow? textOverflow,
}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: textOverflow,
    style: GoogleFonts.poppins(
      decoration: textDecoration,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
  );
}
