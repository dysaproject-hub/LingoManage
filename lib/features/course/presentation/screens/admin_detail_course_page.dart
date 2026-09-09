import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/routes/routes.dart';
import 'package:lingo_manage/core/utils/exceptions/app_error_mapper.dart';
import 'package:lingo_manage/features/admin/presentation/providers/admin_course_provider.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_program_provider.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_provider.dart';
import 'package:lingo_manage/features/student/presentation/provider/student_provider.dart';
import 'package:lingo_manage/shared/widgets/buttons/button_widget.dart';
import 'package:lingo_manage/shared/widgets/cards/card_program.dart';
import 'package:lingo_manage/shared/widgets/cards/empty_card.dart';
import 'package:lingo_manage/shared/widgets/errors/error_widget.dart';
import 'package:lingo_manage/shared/widgets/loadings/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/buttons/management_button_widget.dart';
import 'package:lingo_manage/shared/widgets/cards/statistic_card.dart';
import 'package:lingo_manage/shared/widgets/popups/course_program_section/course_program_popup.dart';
import 'package:lingo_manage/shared/widgets/popups/course_section/course_popup.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class AdminDetailCoursePage extends ConsumerWidget {
  final CourseModel courseModel;

  const AdminDetailCoursePage({super.key, required this.courseModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminProvider = ref.watch(courseAdminsProvider(courseModel.id));
    final courseAsync = ref.watch(courseDetailProvider(courseModel.id));
    final courseProgramDataList = ref.watch(
      getAllCourseProgramProvider(courseModel.id),
    );

    final approvedStudentByCourseId = ref.watch(
      approvedStudentByCourseProvider(courseModel.id),
    );

    Future<void> refreshPage() async {
      ref.invalidate(getAllCourseProgramProvider);
    }

    return Scaffold(
      backgroundColor: AppColors.lightText,
      appBar: AppBar(
        backgroundColor: AppColors.lightText,
        elevation: 0,
        title: textPoppins(
          'Course Detail',
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshPage,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: courseAsync.when(
                    data: (data) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 58,
                            height: 58,

                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(16),
                            ),

                            child: const Icon(
                              Icons.school_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),

                          const SizedBox(height: 20),

                          textBaloo2(
                            data.name,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),

                          const SizedBox(height: 8),

                          textPoppins(
                            data.description ?? 'No description available.',
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),

                          const SizedBox(height: 18),

                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                                size: 17,
                              ),

                              const SizedBox(width: 5),

                              Expanded(
                                child: textPoppins(
                                  data.address.isEmpty ? "-" : data.address,
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    error: (e, s) {
                      final err = ErrorMapper.map(e);

                      return CustomErrorWidget(
                        message: err.message,
                        title: "Can't load course data",
                      );
                    },
                    loading: () => LoadingWidget(),
                  ),
                ),

                const SizedBox(height: 28),

                textBaloo2(
                  'Overview',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: StatisticCard(
                        icon: Icons.people_alt_outlined,
                        title: 'Students',
                        value: approvedStudentByCourseId.when(
                          data: (data) {
                            return "${data.length}";
                          },
                          error: (error, s) => '-',
                          loading: () => '...',
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: StatisticCard(
                        icon: Icons.class_outlined,
                        title: 'Classes',
                        value: '--',
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: StatisticCard(
                        icon: Icons.admin_panel_settings_outlined,
                        title: 'Admins',
                        value: adminProvider.when(
                          data: (data) {
                            return "${data.length}";
                          },
                          error: (error, s) => '-',
                          loading: () => '...',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textBaloo2(
                      'Programs',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),

                    TextButton.icon(
                      onPressed: () {
                        CourseProgramPopup.showDialogAddCourseProgram(
                          context: context,
                          courseData: courseModel,
                          ref: ref,
                        );
                      },

                      icon: const Icon(Icons.add, size: 18),

                      label: textPoppins(
                        'Add',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                courseProgramDataList.when(
                  data: (data) {
                    return data.isEmpty
                        ? EmptySection(
                            icon: Icons.menu_book_outlined,
                            title: 'No programs yet',
                            description:
                                'Add programs such as Regular, Private, or Intensive.',
                            buttonText: 'Add Program',
                            onPressed: () {
                              CourseProgramPopup.showDialogAddCourseProgram(
                                context: context,
                                courseData: courseModel,
                                ref: ref,
                              );
                            },
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final courseProgram = data[index];
                              return ProgramCard(
                                program: courseProgram,
                                onDelete: () {
                                  CourseProgramPopup.showDialogDeleteCourseProgram(
                                    context,
                                    courseProgram,
                                    () async {
                                      await ref
                                          .watch(
                                            courseProgramControllerProvider
                                                .notifier,
                                          )
                                          .deleteCourseProgram(
                                            programId: courseProgram.id,
                                          );

                                      ref.invalidate(
                                        getAllCourseProgramProvider,
                                      );

                                      if (!context.mounted) return;
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                onEdit: () {
                                  CourseProgramPopup.showDialogEditCourseProgram(
                                    context: context,
                                    program: courseProgram,
                                    ref: ref,
                                  );
                                },
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.courseProgramDetail,
                                    arguments: {
                                      'courseModel': courseModel,
                                      'courseProgramModel': courseProgram,
                                    },
                                  );
                                },
                              );
                            },
                          );
                  },
                  error: (e, s) {
                    final err = ErrorMapper.map(e);

                    debugPrint('$e');

                    return CustomErrorWidget(
                      message: err.message,
                      icon: Icons.error_outline_outlined,
                      title: "Can't load course program data",
                    );
                  },
                  loading: () => LoadingWidget(),
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textBaloo2(
                      'Classes',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),

                    TextButton.icon(
                      onPressed: () {
                        // TODO: Add Class
                      },

                      icon: const Icon(Icons.add, size: 18),

                      label: textPoppins(
                        'Add',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                EmptySection(
                  icon: Icons.groups_outlined,
                  title: 'No classes yet',
                  description:
                      'Create classes and assign admins or teachers later.',
                  buttonText: 'Add Class',
                  onPressed: () {
                    // TODO: Add Class
                  },
                ),

                const SizedBox(height: 28),

                textBaloo2(
                  'Management',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),

                const SizedBox(height: 12),

                ManagementButton(
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Manage Admins',
                  description: 'Manage admins who have access to this course.',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.manageAdminPage,
                      arguments: {'courseModel': courseModel},
                    );
                  },
                ),

                const SizedBox(height: 10),

                ManagementButton(
                  icon: Icons.people_outline,
                  title: 'Manage Students',
                  description: 'View students enrolled in this course.',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.manageStudent,
                      arguments: {'courseModel': courseModel},
                    );
                  },
                ),

                const SizedBox(height: 10),

                ManagementButton(
                  icon: Icons.people_outline,
                  title: 'Manage Enrollments',
                  description: 'View enrollments request in this course.',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.manageEnrollment,
                      arguments: {'courseModel': courseModel},
                    );
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,

                  child: Button(
                    text: 'Edit Course',
                    textColor: AppColors.lightText,
                    bgColor: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    borderRadius: BorderRadius.circular(12),

                    onPressed: () {
                      CoursePopup.showDialogUpdateCourseData(
                        context: context,
                        courseData: courseModel,
                        ref: ref,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
