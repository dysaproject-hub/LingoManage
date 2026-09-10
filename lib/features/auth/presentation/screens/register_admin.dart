import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/constants/regex.dart';
import 'package:lingo_manage/core/routes/routes.dart';
import 'package:lingo_manage/core/utils/exceptions/supabase_exceptions_message.dart';
import 'package:lingo_manage/core/utils/media_query_helper.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_controller.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';
import 'package:lingo_manage/shared/widgets/buttons/button_widget.dart';
import 'package:lingo_manage/shared/widgets/loadings/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/text/text_field_widget.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterAdmin extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onLogin;
  const RegisterAdmin({super.key, required this.onBack, required this.onLogin});

  @override
  ConsumerState<RegisterAdmin> createState() => _RegisterAdminState();
}

class _RegisterAdminState extends ConsumerState<RegisterAdmin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullnameController.dispose();
    _nicknameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authController);

    ref.listen(authController, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          if (error is AuthException) {
            final message = SupabaseExceptionMessage.auth(error);

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
                  'LingoManage',
                  fontSize: 32,
                  color: AppColors.black,
                  fontWeight: FontWeight.w800,
                ),
                textPoppins(
                  'Daftar akun instruktur',
                  fontSize: 13,
                  color: AppColors.mutedText,
                ),
                const SizedBox(height: 40),
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
                            return 'Email wajib diisi';
                          }

                          if (!Regex.emailRegex.hasMatch(value)) {
                            return 'Format email tidak valid';
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
                            return 'Kata sandi wajib diisi';
                          }

                          if (value.length < 8) {
                            return 'Kata sandi minimal 8 karakter';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      textFieldWidget(
                        labelText: 'Nama Lengkap',
                        controller: _fullnameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama lengkap wajib diisi';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      textFieldWidget(
                        labelText: 'Nama Panggilan',
                        controller: _nicknameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama panggilan wajib diisi';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      textFieldWidget(
                        keyboardType: TextInputType.number,
                        labelText: 'Nomor WhatsApp',
                        controller: _phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor WhatsApp wajib diisi';
                          }

                          if (value.trim().length < 10) {
                            return 'Nomor tidak valid';
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
                        text: 'Daftar',
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

                          await notifier.signUpAsInstructor(
                            email: _emailController.text,
                            password: _passwordController.text,
                            fullname: _fullnameController.text,
                            nickname: _nicknameController.text,
                            phone: _phoneController.text,
                          );

                          if (!context.mounted) return;

                          Navigator.pushNamed(
                            context,
                            AppRoutes.emailVerificationPage,
                            arguments: {'email': _emailController.text},
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
                      'Sudah punya akun?',
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                    Button(
                      text: 'Masuk',
                      textColor: AppColors.black,
                      bgColor: AppColors.transparent,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      paddingHorizontal: 4,
                      borderRadius: BorderRadius.circular(100),
                      onPressed: widget.onLogin,
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
