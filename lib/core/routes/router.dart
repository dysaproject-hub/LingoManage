import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/routes/routes.dart';
import 'package:lingo_manage/features/admin/presentation/screen/admin_dashboard_page.dart';
import 'package:lingo_manage/features/auth/presentation/screens/login_page.dart';
import 'package:lingo_manage/features/auth/presentation/screens/register_admin.dart';
import 'package:lingo_manage/features/auth/presentation/screens/register_student.dart';
import 'package:lingo_manage/features/auth/presentation/screens/welcome_page.dart';
import 'package:lingo_manage/features/student/presentation/screens/student_home_page.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class AppRouter {
  static Route<dynamic>? generate(RouteSettings settings) {
    // final args = settings.arguments as Map<String, dynamic>? ?? {};

    switch (settings.name) {
      case AppRoutes.welcomePage:
        return MaterialPageRoute(builder: (_) => WelcomePage());

      case AppRoutes.loginPage:
        return MaterialPageRoute(builder: (_) => LoginPage());

      case AppRoutes.registerAdminPage:
        return MaterialPageRoute(builder: (_) => RegisterAdmin());

      case AppRoutes.registerStudentPage:
        return MaterialPageRoute(builder: (_) => RegisterStudent());

      case AppRoutes.studentHomePage:
        return MaterialPageRoute(builder: (_) => StudentHomePage());

      case AppRoutes.adminPage:
        return MaterialPageRoute(builder: (_) => AdminDashboardPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: textPoppins("Page Not Found", color: AppColors.black),
            ),
          ),
        );
    }
  }
}
