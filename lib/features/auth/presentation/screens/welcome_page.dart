import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/utils/auth_page_enum.dart';
import 'package:lingo_manage/core/utils/media_query_helper.dart';
import 'package:lingo_manage/features/auth/presentation/screens/login_page.dart';
import 'package:lingo_manage/features/auth/presentation/screens/register_admin.dart';
import 'package:lingo_manage/shared/widgets/buttons/button_widget.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomePage> {
  AuthPageEnum currentPage = AuthPageEnum.welcome;

  void changePage(AuthPageEnum page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (currentPage) {
      case AuthPageEnum.login:
        return LoginPage(
          onBack: () => changePage(AuthPageEnum.welcome),
          onRegister: () => changePage(AuthPageEnum.registerAdmin),
        );

      case AuthPageEnum.registerAdmin:
        return RegisterAdmin(
          onBack: () => changePage(AuthPageEnum.welcome),
          onLogin: () => changePage(AuthPageEnum.login),
        );

      case AuthPageEnum.registerStudent:
      case AuthPageEnum.welcome:
        return _buildWelcomePage(context);
    }
  }

  Widget _buildWelcomePage(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.lightText,
      body: SafeArea(
        bottom: false,
        child: Flex(
          direction: Axis.vertical,
          children: [
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/app_icon/app_icon.png',
                      width: 200,
                      height: 200,
                    ),
                    textBaloo2(
                      'LingoManage',
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                    textPoppins(
                      'Kelola kursus tanpa spreadsheet',
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: AppColors.black,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: SafeArea(
                child: Container(
                  width: MediaQueryHelper.getScreenWidth(context),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 32,
                      left: 32,
                      right: 32,
                      bottom: 8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textBaloo2(
                              'Selamat datang!',
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppColors.lightText,
                            ),
                            textPoppins(
                              'Masuk sebagai instruktur untuk mengelola kursus.',
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: AppColors.lightText,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Button(
                              text: 'Masuk',
                              textColor: AppColors.lightText,
                              bgColor: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              borderRadius: BorderRadius.circular(100),
                              paddingVertical: 12,
                              paddingHorizontal: 48,
                              onPressed: () => changePage(AuthPageEnum.login),
                            ),
                            const SizedBox(width: 16),
                            Button(
                              text: 'Daftar',
                              textColor: AppColors.lightText,
                              bgColor: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              borderRadius: BorderRadius.circular(100),
                              paddingVertical: 12,
                              paddingHorizontal: 48,
                              onPressed: () =>
                                  changePage(AuthPageEnum.registerAdmin),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
