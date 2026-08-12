import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_provider.dart';
import 'package:lingo_manage/shared/widgets/button_widget.dart';
import 'package:lingo_manage/shared/widgets/text_field_widget.dart';
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

  static void showDialogUpdateCourseData({
    required BuildContext context,
    required CourseModel courseData,
    required WidgetRef ref,
  }) {
    final TextEditingController nameController = TextEditingController(
      text: courseData.name,
    );

    final TextEditingController descriptionController = TextEditingController(
      text: courseData.description,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.lightText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: textBaloo2("Edit Course Data", fontSize: 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              textFieldWidget(
                labelText: "Course Name",
                controller: nameController,
                textFieldType: TextFieldType.outline,
              ),
              const SizedBox(height: 16),
              textFieldWidget(
                labelText: "Description",
                controller: descriptionController,
                textFieldType: TextFieldType.outline,
              ),
              const SizedBox(height: 24),
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
              text: "Update",
              textColor: AppColors.lightText,
              bgColor: AppColors.accent,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              borderRadius: BorderRadius.circular(10),
              onPressed: () async {
                await ref
                    .read(courseControllerProvider.notifier)
                    .updateCourse(
                      courseId: courseData.id,
                      name: nameController.text,
                      description: descriptionController.text,
                    );

                ref.invalidate(myCoursesProvider);

                if (!context.mounted) return;
                Navigator.pop(context);
              },
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
