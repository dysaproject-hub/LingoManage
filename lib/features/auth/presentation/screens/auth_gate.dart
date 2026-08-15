import 'dart:async';

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

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _isSplashFinished = false;

  @override
  void initState() {
    super.initState();

    _startSplash();
  }

  Future<void> _startSplash() async {
    // Minimal waktu splash
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    setState(() {
      _isSplashFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("AuthGate Rebuild");

    final authState = ref.watch(authStateProvider);


    if (!_isSplashFinished) {
      return _buildSplashScreen(context);
    }


    return authState.when(
      data: (user) {
        if (user == null) {
          return const WelcomePage();
        }

        if (user.role == UserRole.student) {
          return const StudentHomePage();
        }

        if (user.role == UserRole.admin) {
          return const AdminDashboardPage();
        }

        return Scaffold(
          body: Center(
            child: textPoppins(
              'Role tidak valid',
              color: AppColors.black,
            ),
          ),
        );
      },

      loading: () {
        return _buildSplashScreen(context);
      },

      error: (error, stack) {
        debugPrint('AuthGate error: $error');

        return Scaffold(
          body: Center(
            child: textPoppins(
              "Maaf terjadi kesalahan",
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

              textPoppins(
                "Loading...",
                color: AppColors.black,
                fontSize: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}