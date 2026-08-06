import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/constants/user_role.dart';
import 'package:lingo_manage/features/admin/presentation/screen/admin_dashboard_page.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';
import 'package:lingo_manage/features/auth/presentation/screens/welcome_page.dart';
import 'package:lingo_manage/features/student/presentation/screens/student_home_page.dart';
import 'package:lingo_manage/shared/widgets/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return WelcomePage();
        }

        if (user.role == UserRole.student) {
          return StudentHomePage();
        }

        if (user.role == UserRole.admin) {
          return AdminDashboardPage();
        }

        // Role tidak dikenali
        return Scaffold(body: Center(child: textPoppins('Role tidak valid')));
      },
      error: (error, stack) =>
          Scaffold(body: Center(child: textPoppins("Maaf terjadi kesalahan"))),
      loading: () => Scaffold(
        body: Center(
          child: Column(
            children: [
              const LoadingWidget(),
              const SizedBox(),
              textPoppins("Loading...", color: AppColors.black),
            ],
          ),
        ),
      ),
    );
  }
}
