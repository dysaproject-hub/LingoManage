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
    debugPrint("AuthGate Rebuild");

    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const WelcomePage();
        }

        switch (user.role) {
          case UserRole.student:
            return const StudentHomePage();
          case UserRole.admin:
            return const AdminDashboardPage();
          default:
            return Scaffold(
              body: Center(
                child: textPoppins('Invalid Role', color: AppColors.black),
              ),
            );
        }
      },
      loading: () => _buildSplashScreen(context),
      error: (error, stack) {
        debugPrint('AuthGate error: $error');
        return Scaffold(
          body: Center(
            child: textPoppins(
              "Sorry, Something Went Wrong!",
              color: AppColors.black,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSplashScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightText,
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/app_icon/app_icon.png",
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 16),
              textBaloo2(
                "LingoManage",
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
              const SizedBox(height: 24),
              const LoadingWidget(),
              const SizedBox(height: 12),
              textPoppins("Loading...", color: AppColors.black, fontSize: 12),
            ],
          ),
        ),
      ),
    );
  }
}
