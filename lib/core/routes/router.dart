import 'package:flutter/material.dart';
import 'package:lingo_manage/core/routes/routes.dart';
import 'package:lingo_manage/features/admin/presentation/screen/admin_dashboard_page.dart';
import 'package:lingo_manage/features/admin/presentation/screen/manage_admin_page.dart';
import 'package:lingo_manage/features/admin/presentation/screen/manage_enrollment_page.dart';
import 'package:lingo_manage/features/auth/presentation/screens/auth_gate.dart';
import 'package:lingo_manage/features/auth/presentation/screens/verifikasi_email.dart';
import 'package:lingo_manage/features/course/presentation/screens/admin_detail_course_page.dart';
import 'package:lingo_manage/features/course/presentation/screens/course_form.dart';
import 'package:lingo_manage/features/course/presentation/screens/detail_course_page.dart';
import 'package:lingo_manage/features/course/presentation/screens/student_detail_course_page.dart';
import 'package:lingo_manage/features/enrollments/presentation/screen/enrollment_detail_page.dart';
import 'package:lingo_manage/features/enrollments/presentation/screen/enrollment_form.dart';
import 'package:lingo_manage/features/student/presentation/screens/manage_student_page.dart';
import 'package:lingo_manage/features/student/presentation/screens/student_home_page.dart';
import 'package:lingo_manage/shared/screens/error_page.dart';
import 'package:lingo_manage/shared/screens/pofile_user.dart';

class AppRouter {
  static Route<dynamic>? generate(RouteSettings settings) {
    debugPrint('================================');
    debugPrint('ROUTE NAME: ${settings.name}');
    debugPrint('ROUTE ARGUMENTS: ${settings.arguments}');
    debugPrint('================================');

    final args = settings.arguments as Map<String, dynamic>? ?? {};

    if (settings.name?.startsWith('/') == true &&
        settings.name!.contains('error=')) {
      return MaterialPageRoute(builder: (_) => const AuthGate());
    }

    switch (settings.name) {
      case AppRoutes.studentHomePage:
        return MaterialPageRoute(builder: (_) => StudentHomePage());

      case AppRoutes.adminPage:
        return MaterialPageRoute(builder: (_) => AdminDashboardPage());

      case AppRoutes.authGate:
        return MaterialPageRoute(builder: (_) => AuthGate());

      case AppRoutes.courseFormPage:
        return MaterialPageRoute(builder: (_) => CourseForm());

      case AppRoutes.profileUserPage:
        return MaterialPageRoute(builder: (_) => ProfileUser());

      case AppRoutes.manageAdminPage:
        final courseModel = args['courseModel'];
        return MaterialPageRoute(
          builder: (_) => ManageAdminPage(courseModel: courseModel),
        );

      case AppRoutes.adminDetailCourse:
        final courseModel = args['courseModel'];
        return MaterialPageRoute(
          builder: (_) => AdminDetailCoursePage(courseModel: courseModel),
        );

      case AppRoutes.courseProgramDetail:
        final courseModel = args['courseModel'];
        final programModel = args['courseProgramModel'];
        return MaterialPageRoute(
          builder: (_) =>
              ProgramDetailPage(program: programModel, course: courseModel),
        );

      case AppRoutes.studentDetailCourse:
        final courseModel = args['courseModel'];
        return MaterialPageRoute(
          builder: (_) => StudentDetailCoursePage(course: courseModel),
        );

      case AppRoutes.enrollmentForm:
        final courseModel = args['courseModel'];
        final programModel = args['programModel'];
        return MaterialPageRoute(
          builder: (_) =>
              EnrollmentPage(course: courseModel, programModel: programModel),
        );

      case AppRoutes.enrollmentDetailPage:
        final courseName = args['courseName'];
        final programModel = args['programModel'];
        final enrollmentModel = args['enrollmentModel'];
        return MaterialPageRoute(
          builder: (_) => EnrollmentDetailPage(
            courseName: courseName,
            programModel: programModel,
            enrollmentModel: enrollmentModel,
          ),
        );

      case AppRoutes.manageEnrollment:
        final courseModel = args['courseModel'];
        return MaterialPageRoute(
          builder: (_) => ManageEnrollmentPage(courseModel: courseModel),
        );

      case AppRoutes.manageStudent:
        final courseModel = args['courseModel'];
        return MaterialPageRoute(
          builder: (_) => ManageStudentPage(courseModel: courseModel),
        );

      case AppRoutes.emailVerificationPage:
        final email = args['email'];
        return MaterialPageRoute(
          builder: (_) => EmailVerificationPage(email: email),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => ErrorPage(message: "Page Not Found"),
        );
    }
  }
}
