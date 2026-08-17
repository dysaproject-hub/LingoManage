import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/providers/app_users_provider.dart';
import 'package:lingo_manage/core/routes/routes.dart';
import 'package:lingo_manage/features/admin/presentation/widget/card_course_widget.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_provider.dart';
import 'package:lingo_manage/shared/widgets/appbar_widget.dart';
import 'package:lingo_manage/shared/widgets/button_widget.dart';
import 'package:lingo_manage/shared/widgets/card_widget.dart';
import 'package:lingo_manage/shared/widgets/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/popup_widget.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

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
                  AppbarWidget(userDataProvider: userDataProvider),

                  const SizedBox(height: 50),

                  CardWithStrokeWidget(
                    title: "Welcome!",
                    description: "Let's manage your course now!",
                    image: Image.asset("assets/ilustration/ilustration_1.png"),
                    borderRadius: 15,
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
                          child: textPoppins("You don't have a course yet"),
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
                            onTapCek: () {},
                            onTapEdit: () {
                              PopupWidget.showDialogUpdateCourseData(
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
                              PopupWidget.removeCourseAlert(
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
                      debugPrint('$e');
                      return textPoppins("Sorry, Something Went Wrong!");
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
