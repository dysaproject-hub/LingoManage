import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/constants/regex.dart';
import 'package:lingo_manage/core/utils/education_level_enum.dart';
import 'package:lingo_manage/core/utils/firebase_exceptions_message.dart';
import 'package:lingo_manage/core/utils/media_query_helper.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_controller.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';
import 'package:lingo_manage/shared/widgets/button_widget.dart';
import 'package:lingo_manage/shared/widgets/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/text_field_widget.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class RegisterStudent extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onLogin;
  const RegisterStudent({
    super.key,
    required this.onBack,
    required this.onLogin,
  });

  @override
  ConsumerState<RegisterStudent> createState() => _RegisterStudentState();
}

class _RegisterStudentState extends ConsumerState<RegisterStudent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _schoolNameController = TextEditingController();

  EducationLevel? selectedLevel;

  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullnameController.dispose();
    _nicknameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _schoolNameController.dispose();
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
                            return "Invalid email format";
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
                            return "The password must be filled in!";
                          }

                          if (value.length < 8) {
                            return "The password must has minimum 8 characters!";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      textFieldWidget(
                        labelText: "Full Name",
                        controller: _fullnameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Full name field cannot be empty!";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      textFieldWidget(
                        labelText: "Nick Name",
                        controller: _nicknameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nick name field cannot be empty!";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      textFieldWidget(
                        keyboardType: TextInputType.number,
                        labelText: "Phone",
                        controller: _phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "The phone field is required!";
                          }

                          final phone = int.tryParse(value);

                          if (phone == null) {
                            return "Phone must be a number!";
                          }

                          if (phone < 1) {
                            return "Invalid phone number!";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      textFieldWidget(
                        keyboardType: TextInputType.text,
                        labelText: "Address",
                        controller: _addressController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "The address field is required!";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      textFieldWidget(
                        keyboardType: TextInputType.text,
                        labelText: "School Name",
                        controller: _schoolNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "The school name field is required!";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      DropdownButtonFormField<EducationLevel>(
                        dropdownColor: AppColors.lightText,
                        initialValue: selectedLevel,
                        decoration: InputDecoration(
                          labelText: 'Educational Level',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors
                                  .primary,
                              width: 2.0,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                          labelStyle: GoogleFonts.poppins(
                            color: AppColors.black.withAlpha(100),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        items: EducationLevel.values.map((
                          EducationLevel level,
                        ) {
                          return DropdownMenuItem<EducationLevel>(
                            value: level,
                            child: textPoppins(level.label),
                          );
                        }).toList(),
                        onChanged: (EducationLevel? newValue) {
                          setState(() {
                            selectedLevel = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                authState.isLoading
                    ? const LoadingWidget()
                    : FlexibleButton(
                        text: "Register",
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

                          await notifier.registerStudent(
                            email: _emailController.text,
                            password: _passwordController.text,
                            fullname: _fullnameController.text,
                            nickname: _nicknameController.text,
                            phone: _phoneController.text,
                            address: _addressController.text,
                            schoolName: _schoolNameController.text,
                            educationalLevel: selectedLevel ?? EducationLevel.other,
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
                      "Already have an account?",
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                    Button(
                      text: "Login",
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
