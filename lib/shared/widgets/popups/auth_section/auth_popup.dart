import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/shared/widgets/buttons/button_widget.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class AuthPopup {
  static void signOutAlert(BuildContext context, VoidCallback onPressed) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.lightText,
          title: textPoppins(
            "Are you sure to logout from this account?",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
          actions: [
            Button(
              text: "Cancel",
              textColor: AppColors.black,
              bgColor: AppColors.lightText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              borderRadius: BorderRadius.circular(10),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            Button(
              text: "Logout",
              textColor: AppColors.lightText,
              bgColor: AppColors.red,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              borderRadius: BorderRadius.circular(10),
              onPressed: onPressed,
            ),
          ],
        );
      },
    );
  }
}