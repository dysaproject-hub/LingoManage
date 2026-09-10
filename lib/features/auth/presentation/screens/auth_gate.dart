import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/constants/user_role.dart';
import 'package:lingo_manage/core/utils/exceptions/app_error_mapper.dart';
import 'package:lingo_manage/features/admin/presentation/screen/admin_dashboard_page.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_controller.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';
import 'package:lingo_manage/features/auth/presentation/screens/welcome_page.dart';
import 'package:lingo_manage/features/organization/models/organization_model.dart';
import 'package:lingo_manage/features/organization/presentation/providers/organization_provider.dart';
import 'package:lingo_manage/features/organization/presentation/screens/organization_onboarding_page.dart';
import 'package:lingo_manage/shared/screens/error_page.dart';
import 'package:lingo_manage/shared/widgets/buttons/button_widget.dart';
import 'package:lingo_manage/shared/widgets/loadings/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const WelcomePage();
        }

        switch (user.role) {
          case UserRole.instructor:
            return const _InstructorSessionGate();
          case UserRole.student:
            return _StudentBlockedScreen(
              onSignOut: () => ref.read(authController.notifier).signOut(),
            );
          default:
            return Scaffold(
              body: Center(
                child: textPoppins(
                  'Peran akun tidak dikenali',
                  color: AppColors.black,
                ),
              ),
            );
        }
      },
      loading: () => const _SplashScreen(),
      error: (error, stack) {
        final err = ErrorMapper.map(error);
        return ErrorPage(message: err.message);
      },
    );
  }

}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
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
                'assets/app_icon/app_icon.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 16),
              textBaloo2(
                'LingoManage',
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
              const SizedBox(height: 24),
              const LoadingWidget(),
              const SizedBox(height: 12),
              textPoppins(
                'Memuat...',
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

class _InstructorSessionGate extends ConsumerWidget {
  const _InstructorSessionGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgState = ref.watch(myOrganizationProvider);

    return orgState.when(
      loading: () => const _SplashScreen(),
      error: (error, _) {
        final err = ErrorMapper.map(error);
        return ErrorPage(message: err.message);
      },
      data: (org) {
        if (OrganizationModel.needsOnboarding(org)) {
          return OrganizationOnboardingPage(existing: org);
        }
        return const AdminDashboardPage();
      },
    );
  }
}

class _StudentBlockedScreen extends StatelessWidget {
  final VoidCallback onSignOut;

  const _StudentBlockedScreen({required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightText,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textBaloo2(
                'Akses Siswa Tidak Tersedia',
                fontSize: 24,
                fontWeight: FontWeight.w800,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              textPoppins(
                'Fase 1 hanya untuk instruktur. Calon siswa mendaftar lewat formulir web publik kursus.',
                fontSize: 13,
                color: AppColors.mutedText,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Button(
                  text: 'Keluar',
                  textColor: AppColors.lightText,
                  bgColor: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  borderRadius: BorderRadius.circular(12),
                  onPressed: onSignOut,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
