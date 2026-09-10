import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/providers/app_users_provider.dart';
import 'package:lingo_manage/core/routes/routes.dart';
import 'package:lingo_manage/core/utils/exceptions/app_error_mapper.dart';
import 'package:lingo_manage/features/admin/presentation/widget/card_course_widget.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_provider.dart';
import 'package:lingo_manage/features/organization/presentation/providers/organization_provider.dart';
import 'package:lingo_manage/shared/widgets/app_bar/appbar_widget.dart';
import 'package:lingo_manage/shared/widgets/buttons/button_widget.dart';
import 'package:lingo_manage/shared/widgets/cards/empty_card.dart';
import 'package:lingo_manage/shared/widgets/errors/error_widget.dart';
import 'package:lingo_manage/shared/widgets/loadings/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/popups/course_section/course_popup.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  Future<void> _refreshCourses() async {
    ref.invalidate(myCoursesProvider);

    await ref.read(myCoursesProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final myCourseProvider = ref.watch(myCoursesProvider);
    final userDataProvider = ref.watch(appUserControllerProvider);
    final orgAsync = ref.watch(myOrganizationProvider);

    debugPrint("AdminDashboardPage Rebuild");
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshCourses,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppbarWidget(
                    userDataProvider: userDataProvider,
                    orgAsync: orgAsync,
                  ),

                  const SizedBox(height: 30),

                  orgAsync.when(
                    loading: () => const Center(child: LoadingWidget()),
                    error: (e, _) => CustomErrorWidget(
                      message: ErrorMapper.map(e).message,
                      title: 'Gagal memuat organisasi',
                      onRetry: () => ref.invalidate(myOrganizationProvider),
                    ),
                    data: (org) {
                      return SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  textBaloo2(
                                    'Dashboard',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  const SizedBox(height: 8),
                                  textPoppins(
                                    'Ringkasan kursus, pendaftaran, dan tagihan akan ditambahkan pada langkah berikutnya.',
                                    fontSize: 13,
                                    color: AppColors.mutedText,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: Button(
                                text: 'Pengaturan Organisasi',
                                textColor: AppColors.lightText,
                                bgColor: AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                borderRadius: BorderRadius.circular(12),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.organizationSettingsPage,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 50),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      textPoppins(
                        "Your Course",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                      const SizedBox(width: 16),
                      Button(
                        text: "Add Course",
                        textColor: AppColors.lightText,
                        bgColor: AppColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        borderRadius: BorderRadius.circular(10),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.courseFormPage,
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  myCourseProvider.when(
                    data: (data) {
                      if (data.isEmpty) {
                        return Center(
                          child: EmptySection(
                            icon: Icons.school,
                            title: "Kamu belum memiliki kursus",
                            description:
                                "Tambahkan kursus yang kamu miliki sekarang!",
                            buttonText: "Tambah Kursus",
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.courseFormPage,
                              );
                            },
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          debugPrint(data[index].name);
                          return CardCourseWidget(
                            maincolor: AppColors.accent,
                            gradientcolor: AppColors.accent,
                            courseData: data[index],
                            jumlahsiswa: "--",
                            buttoncolor: AppColors.lightText,
                            onTapCek: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.adminDetailCourse,
                                arguments: {"courseModel": data[index]},
                              );
                            },
                            onTapEdit: () {
                              CoursePopup.showDialogUpdateCourseData(
                                context: context,
                                courseData: data[index],
                                ref: ref,
                              );
                            },
                            onTapManageAdmin: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.manageAdminPage,
                                arguments: {'courseModel': data[index]},
                              );
                            },
                            onTapRemove: () {
                              CoursePopup.removeCourseAlert(
                                context,
                                data[index],
                                () async {
                                  await ref
                                      .read(courseControllerProvider.notifier)
                                      .deleteCourse(courseId: data[index].id);

                                  ref.invalidate(myCoursesProvider);

                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                    error: (e, s) {
                      final error = ErrorMapper.map(e);
                      return CustomErrorWidget(
                        message: error.message,
                        icon: Icons.error_outline,
                        title: "Can't load course data!",
                      );
                    },
                    loading: () => Center(child: LoadingWidget()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
