import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:lingo_manage/shared/widgets/button_widget.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class PopupWidget {
  static void removeCourseAlert(
    BuildContext context,
    CourseModel course,
    VoidCallback onRemove,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.lightText,
          title: textPoppins(
            "Are you sure to remove this course?",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              textPoppins(
                "CourseName : ${course.name}",
                fontSize: 16,
                color: AppColors.black,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              textPoppins(
                "Description : ${course.description}",
                fontSize: 14,
                color: AppColors.black,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              textPoppins(
                "CreatedAt : ${course.createdAt}",
                fontSize: 14,
                color: AppColors.black,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
            ],
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
                Navigator.pop(context);
              },
            ),
            Button(
              text: "Delete",
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

  static void signOutAlert(BuildContext context, VoidCallback onPressed) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.lightText,
          title: textPoppins(
            "Are you sure to sign out from this account?",
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
              text: "Sign Out",
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
