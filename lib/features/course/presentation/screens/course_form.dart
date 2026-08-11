import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/utils/media_query_helper.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_provider.dart';
import 'package:lingo_manage/shared/widgets/button_widget.dart';
import 'package:lingo_manage/shared/widgets/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/text_field_widget.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class CourseForm extends ConsumerStatefulWidget {
  const CourseForm({super.key});

  @override
  ConsumerState<CourseForm> createState() => _RegisterAdminState();
}

class _RegisterAdminState extends ConsumerState<CourseForm> {
  final _courseNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _courseNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseState = ref.watch(courseControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.lightText,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: CustomIconButton(
                    boxColor: AppColors.primary,
                    iconColor: AppColors.lightText,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    iconData: Icons.arrow_back,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                Image.asset(
                  "assets/app_icon/app_icon.png",
                  width: 150,
                  height: 150,
                ),
                textBaloo2(
                  "LingoManage",
                  fontSize: 32,
                  color: AppColors.black,
                  fontWeight: FontWeight.w800,
                ),
                textPoppins("Add your course name!"),
                const SizedBox(height: 80),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      textFieldWidget(
                        labelText: "Course Name",
                        controller: _courseNameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "The course name field cannot be empty!";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      textFieldWidget(
                        labelText: "Description",
                        controller: _descriptionController,
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                courseState.isLoading
                    ? const LoadingWidget()
                    : FlexibleButton(
                        text: "Add Course",
                        textColor: AppColors.lightText,
                        bgColor: AppColors.accent,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        borderRadius: BorderRadius.circular(10),
                        width: MediaQueryHelper.getScreenWidth(context),
                        onPressed: () async {
                          final notifier = ref.read(
                            courseControllerProvider.notifier,
                          );

                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          await notifier.addCourse(
                            name: _courseNameController.text,
                            description: _descriptionController.text,
                          );

                          if (!context.mounted) return;

                          Navigator.pop(context);

                          ref.invalidate(courseControllerProvider);
                        },
                      ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
