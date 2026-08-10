import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/constants/regex.dart';
import 'package:lingo_manage/core/utils/firebase_exceptions_message.dart';
import 'package:lingo_manage/core/utils/media_query_helper.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_controller.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';
import 'package:lingo_manage/shared/widgets/button_widget.dart';
import 'package:lingo_manage/shared/widgets/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/text_field_widget.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class LoginPage extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onRegister;
  const LoginPage({
    super.key,
    required this.onBack,
    required this.onRegister,
  });

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  late bool isLogin;
  late bool onRegisterPage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authController);

    ref.listen(authController, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          if (error is FirebaseAuthException) {
            final message = FirebaseExceptionMessage.auth(error);

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          }
        },
      );
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.lightText,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: CustomIconButton(
                    boxColor: AppColors.primary,
                    iconColor: AppColors.lightText,
                    onTap: widget.onBack,
                    iconData: Icons.arrow_back,
                    borderRadius: BorderRadius.circular(100),
                    boxShadowColor: AppColors.transparent,
                  ),
                ),
                Image.asset(
                  "assets/app_icon/app_icon.png",
                  width: 150,
                  height: 150,
                ),
                textBaloo2(
                  "LingoManage",
                  fontSize: 32,
                  color: AppColors.black,
                  fontWeight: FontWeight.w800,
                ),
                const SizedBox(height: 80),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      textFieldWidget(
                        labelText: "Email",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "The email field cannot be empty!";
                          }

                          if (!Regex.emailRegex.hasMatch(value)) {
                            return "Invalid email format!";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      textFieldWidget(
                        labelText: "Password",
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        maxLines: 1,
                        keyboardType: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 16,
                            color: AppColors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "The password field must be filled in!";
                          }

                          if (value.length < 8) {
                            return "The password must has minimum 8 characters!";
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                authState.isLoading
                    ? const LoadingWidget()
                    : FlexibleButton(
                        text: "Login",
                        textColor: AppColors.lightText,
                        bgColor: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        borderRadius: BorderRadius.circular(10),
                        width: MediaQueryHelper.getScreenWidth(context),
                        onPressed: () async {
                          final notifier = ref.read(authController.notifier);

                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          await notifier.signIn(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );

                          ref.invalidate(authStateProvider);
                        },
                      ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textPoppins(
                      "Don't have an account?",
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                    Button(
                      text: "Register",
                      textColor: AppColors.black,
                      bgColor: AppColors.transparent,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      paddingHorizontal: 4,
                      borderRadius: BorderRadius.circular(100),
                      onPressed: widget.onRegister,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
