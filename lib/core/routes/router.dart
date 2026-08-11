import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/routes/routes.dart';
import 'package:lingo_manage/features/admin/presentation/screen/admin_dashboard_page.dart';
import 'package:lingo_manage/features/auth/presentation/screens/auth_gate.dart';
import 'package:lingo_manage/features/course/presentation/screens/course_form.dart';
import 'package:lingo_manage/features/student/presentation/screens/student_home_page.dart';
import 'package:lingo_manage/shared/screens/pofile_user.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class AppRouter {
  static Route<dynamic>? generate(RouteSettings settings) {
    // final args = settings.arguments as Map<String, dynamic>? ?? {};

    switch (settings.name) {

      case AppRoutes.studentHomePage:
        return MaterialPageRoute(builder: (_) => StudentHomePage());

      case AppRoutes.adminPage:
        return MaterialPageRoute(builder: (_) => AdminDashboardPage());

      case AppRoutes.authGate:
        return MaterialPageRoute(builder: (_) => AuthGate());

      case AppRoutes.courseFormPage:
        return MaterialPageRoute(builder: (_) => CourseForm());

      case AppRoutes.profileUser:
        return MaterialPageRoute(builder: (_) => ProfileUser());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: AppColors.darkBackground,
            body: Center(
              child: textPoppins("Page Not Found", color: AppColors.lightText),
            ),
          ),
        );
    }
  }
}
