import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/shared/widgets/buttons/button_widget.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class AdminPopup {
  static void removeAdminCourse(
    BuildContext context,
    AppUser appUser,
    VoidCallback onRemove,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.lightText,
          title: textPoppins(
            "Remove Admins",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
          content: textPoppins(
            'Are you sure to remove ${appUser.fullname} from this course?',
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
              text: "Remove",
              textColor: AppColors.lightText,
              bgColor: AppColors.red,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              borderRadius: BorderRadius.circular(10),
              onPressed: onRemove,
            ),
          ],
        );
      },
    );
  }
}