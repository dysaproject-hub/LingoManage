import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/providers/app_users_provider.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_provider.dart';
import 'package:lingo_manage/features/student/presentation/widget/course_carousel_widget.dart';
import 'package:lingo_manage/shared/widgets/appbar_widget.dart';
import 'package:lingo_manage/shared/widgets/card_widget.dart';
import 'package:lingo_manage/shared/widgets/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class StudentHomePage extends ConsumerStatefulWidget {
  const StudentHomePage({super.key});

  @override
  ConsumerState<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends ConsumerState<StudentHomePage> {
  Future<void> _refreshPage() async {
    ref.invalidate(getCourseControllerProvider);

    await ref.read(getCourseControllerProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = ref.watch(appUserControllerProvider);
    final courseData = ref.watch(getCourseControllerProvider);

    debugPrint("StudentHomePage Rebuild");
    return Scaffold(
      backgroundColor: AppColors.lightText,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshPage,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppbarWidget(userDataProvider: userDataProvider),
                  const SizedBox(height: 50),
                  CardWithStrokeWidget(
                    title: "Welcome!",
                    description: "Let's start your journey!",
                    image: Image.asset("assets/ilustration/ilustration_1.png"),
                    borderRadius: 15,
                  ),
                  const SizedBox(height: 50),
                  textPoppins(
                    "Recomendation to Join",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                  const SizedBox(height: 16),
                  courseData.when(
                    data: (data) {
                      return CourseCarouselWidget(data: data);
                    },
                    error: (error, s) =>
                        textPoppins("Sorry, something went wrong"),
                    loading: () => const LoadingWidget(),
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
