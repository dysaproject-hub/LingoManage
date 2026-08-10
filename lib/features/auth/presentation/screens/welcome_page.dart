import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/utils/auth_page_enum.dart';
import 'package:lingo_manage/core/utils/media_query_helper.dart';
import 'package:lingo_manage/features/auth/presentation/screens/login_page.dart';
import 'package:lingo_manage/features/auth/presentation/screens/register_admin.dart';
import 'package:lingo_manage/features/auth/presentation/screens/register_student.dart';
import 'package:lingo_manage/shared/widgets/button_widget.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class WelcomePage extends StatefulWidget {
  final bool? onRegisterPage;

  const WelcomePage({super.key, this.onRegisterPage});

  @override
  State<WelcomePage> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomePage> {
  late bool onRegisterPage;

  AuthPageEnum currentPage = AuthPageEnum.welcome;

  @override
  void initState() {
    super.initState();
    onRegisterPage = widget.onRegisterPage ?? false;
  }

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
          onBack: () {
            changePage(AuthPageEnum.welcome);
          },
          onRegister: () {
            setState(() {
              onRegisterPage = true;
              currentPage = AuthPageEnum.welcome;
            });
          },
        );

      case AuthPageEnum.registerAdmin:
        return RegisterAdmin(
          onBack: () {
            changePage(AuthPageEnum.welcome);
          },
          onLogin: () {
            changePage(AuthPageEnum.login);
          },
        );

      case AuthPageEnum.registerStudent:
        return RegisterStudent(
          onBack: () {
            changePage(AuthPageEnum.welcome);
          },
          onLogin: () {
            changePage(AuthPageEnum.login);
          },
        );

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
        child: Stack(
          children: [
            onRegisterPage
                ? Padding(
                    padding: EdgeInsets.all(16),
                    child: CustomIconButton(
                      boxColor: AppColors.primary,
                      iconColor: AppColors.lightText,
                      onTap: () {
                        setState(() {
                          onRegisterPage = false;
                        });
                      },
                      iconData: Icons.arrow_back,
                      borderRadius: BorderRadius.circular(100),
                      boxShadowColor: AppColors.transparent,
                    ),
                  )
                : const SizedBox.shrink(),
            Flex(
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
                          "assets/app_icon/app_icon.png",
                          width: 200,
                          height: 200,
                        ),
                        textBaloo2(
                          "LingoManage",
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                        textPoppins(
                          '“Effortless management, Fluent Development”',
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
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
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 32,
                          left: 32,
                          right: 32,
                          bottom: 8,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            !onRegisterPage
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      textBaloo2(
                                        "Welcome!",
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.lightText,
                                      ),
                                      textPoppins(
                                        "Let's use LingoManage now!",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: AppColors.lightText,
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: textBaloo2(
                                      "Choose The Role!",
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.lightText,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                            const SizedBox(height: 8),
                            !onRegisterPage
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Button(
                                        text: "Login",
                                        textColor: AppColors.lightText,
                                        bgColor: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        paddingVertical: 12,
                                        paddingHorizontal: 48,
                                        onPressed: () {
                                          changePage(AuthPageEnum.login);
                                        },
                                      ),
                                      const SizedBox(width: 16),
                                      Button(
                                        text: "Register",
                                        textColor: AppColors.lightText,
                                        bgColor: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        paddingVertical: 12,
                                        paddingHorizontal: 48,
                                        onPressed: () {
                                          setState(() {
                                            onRegisterPage = true;
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FlexibleButton(
                                        text: "Register as a student",
                                        textColor: AppColors.lightText,
                                        bgColor: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        width: MediaQueryHelper.getScreenWidth(
                                          context,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        paddingVertical: 12,
                                        paddingHorizontal: 48,
                                        onPressed: () {
                                          changePage(
                                            AuthPageEnum.registerStudent,
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 8),
                                      FlexibleButton(
                                        text: "Register as an admin",
                                        textColor: AppColors.lightText,
                                        bgColor: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        width: MediaQueryHelper.getScreenWidth(
                                          context,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        paddingVertical: 12,
                                        paddingHorizontal: 48,
                                        onPressed: () {
                                          changePage(
                                            AuthPageEnum.registerAdmin,
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          textPoppins(
                                            "Already have an account?",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            color: AppColors.lightText,
                                          ),
                                          Button(
                                            text: "Login",
                                            textColor: AppColors.lightText,
                                            bgColor: AppColors.transparent,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            paddingHorizontal: 8,
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                            onPressed: () {
                                              changePage(AuthPageEnum.login);
                                            },
                                          ),
                                        ],
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
          ],
        ),
      ),
    );
  }
}
