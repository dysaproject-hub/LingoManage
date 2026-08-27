import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_provider.dart';
import 'package:lingo_manage/shared/widgets/buttons/button_widget.dart';
import 'package:lingo_manage/shared/widgets/text/text_field_widget.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class CoursePopup {
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
                fontSize: 14,
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

    final TextEditingController addressController = TextEditingController(
      text: courseData.address,
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

          // HANYA DITAMBAHKAN AGAR TIDAK OVERFLOW
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.6,
            ),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
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

                  const SizedBox(height: 16),

                  textFieldWidget(
                    labelText: "address",
                    controller: addressController,
                    textFieldType: TextFieldType.outline,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
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
                      address: addressController.text,
                    );

                ref.invalidate(myCoursesProvider);
                ref.invalidate(courseDetailProvider);

                if (!context.mounted) return;
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}