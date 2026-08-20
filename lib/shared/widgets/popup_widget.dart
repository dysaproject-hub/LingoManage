import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/core/utils/currency_formatters.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_program_provider.dart';
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

  static void showDialogAddCourseProgram({
    required BuildContext context,
    required CourseModel courseData,
    required WidgetRef ref,
  }) {
    final TextEditingController programNameController = TextEditingController();

    final TextEditingController descriptionController = TextEditingController();

    final TextEditingController registrationFeeController =
        TextEditingController();

    final TextEditingController monthlyFeeController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.lightText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: textBaloo2("Add Course Programs", fontSize: 24),

          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.6,
            ),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),

                    textFieldWidget(
                      labelText: "Program Name",
                      controller: programNameController,
                      textFieldType: TextFieldType.outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Program name is required!";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    textFieldWidget(
                      labelText: "Description",
                      controller: descriptionController,
                      textFieldType: TextFieldType.outline,
                    ),

                    const SizedBox(height: 16),

                    textFieldWidget(
                      labelText: "Registration Fee",
                      controller: registrationFeeController,
                      textFieldType: TextFieldType.outline,
                      keyboardType: TextInputType.number,
                      inputFormatters: [CurrencyInputFormatter()],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "The registration fee is required!";
                        }

                        final monthlyFeeText = value
                            .replaceAll('.', '')
                            .replaceAll(',', '');

                        final fee = int.tryParse(monthlyFeeText);

                        if (fee == null) {
                          return "The registration fee invalid!";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    textFieldWidget(
                      labelText: "Monthly Fee",
                      controller: monthlyFeeController,
                      textFieldType: TextFieldType.outline,
                      keyboardType: TextInputType.number,
                      inputFormatters: [CurrencyInputFormatter()],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "The monthly fee is required!";
                        }

                        final monthlyFeeText = value
                            .replaceAll('.', '')
                            .replaceAll(',', '');

                        final fee = int.tryParse(monthlyFeeText);

                        if (fee == null) {
                          return "The monthly fee invalid!";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
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
              text: "Add Program",
              textColor: AppColors.lightText,
              bgColor: AppColors.accent,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              borderRadius: BorderRadius.circular(10),
              onPressed: () async {
                final registrationFeeText = registrationFeeController.text
                    .replaceAll('.', '')
                    .replaceAll(',', '');

                final monthlyFeeText = monthlyFeeController.text
                    .replaceAll('.', '')
                    .replaceAll(',', '');

                if (!formKey.currentState!.validate()) {
                  return;
                }

                await ref
                    .read(courseProgramControllerProvider.notifier)
                    .addCourseProgram(
                      courseId: courseData.id,
                      name: programNameController.text,
                      description: descriptionController.text,
                      registrationFee: int.tryParse(registrationFeeText) ?? 0,
                      monthlyFee: int.tryParse(monthlyFeeText) ?? 0,
                      isActive: true,
                    );

                ref.invalidate(getAllCourseProgramProvider);

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
