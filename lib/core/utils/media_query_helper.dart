import 'package:flutter/material.dart';

class MediaQueryHelper {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double getBottomPadding(BuildContext context) {
    return MediaQuery.paddingOf(context).bottom;
  }
}
