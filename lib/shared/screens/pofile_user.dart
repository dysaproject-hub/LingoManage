import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/constants/user_role.dart';
import 'package:lingo_manage/core/providers/app_users_provider.dart';
import 'package:lingo_manage/core/utils/education_level_enum.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_controller.dart';
import 'package:lingo_manage/shared/widgets/button_widget.dart';
import 'package:lingo_manage/shared/widgets/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/popup_widget.dart';
import 'package:lingo_manage/shared/widgets/text_field_widget.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class ProfileUser extends ConsumerStatefulWidget {
  const ProfileUser({super.key});

  @override
  ConsumerState<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends ConsumerState<ProfileUser> {
  final _fullnameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _schoolNameController = TextEditingController();

  String originalFullname = "";
  String originalNickname = "";
  String originalPhone = "";
  String originalAddress = "";
  String originalSchoolName = "";
  EducationLevel? originalEducationLevel;

  bool isEditing = false;
  EducationLevel? selectedValue;

  @override
  void dispose() {
    _fullnameController.dispose();
    _nicknameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _schoolNameController.dispose();
    super.dispose();
  }

  void startEditing() {
    if (!isEditing) {
      setState(() {
        isEditing = true;
      });
    }
  }

  void cancelEditing() {
    _fullnameController.text = originalFullname;
    _nicknameController.text = originalNickname;
    _phoneController.text = originalPhone;
    _addressController.text = originalAddress;
    _schoolNameController.text = originalSchoolName;

    setState(() {
      selectedValue = originalEducationLevel;
      isEditing = false;
    });
  }

  Future<void> saveEditing() async {
    if (!isEditing) return;

    try {
      final fullname = _fullnameController.text.trim();
      final nickname = _nicknameController.text.trim();
      final phone = _phoneController.text.trim();
      final address = _addressController.text.trim();
      final schoolName = _schoolNameController.text.trim();

      await ref
          .read(appUserControllerProvider.notifier)
          .updateDataUser(
            fullname: fullname,
            nickname: nickname,
            phone: phone,
            address: address,
            schoolName: schoolName,
            educationLevel: selectedValue?.label,
          );

      originalFullname = fullname;
      originalNickname = nickname;
      originalPhone = phone;
      originalAddress = address;
      originalSchoolName = schoolName;
      originalEducationLevel = selectedValue;

      if (!mounted) return;

      setState(() {
        isEditing = false;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: textPoppins(
            "Failed update the content: $e",
            color: AppColors.lightText,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = ref.watch(appUserControllerProvider);
    final imageProfileData = ref.watch(imageProfileProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.lightText,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      iconData: Icons.arrow_back,
                      boxColor: AppColors.lightText,
                      iconColor: AppColors.primary,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Center(
                      child: textBaloo2(
                        "Profile",
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    CustomIconButton(
                      iconData: Icons.logout,
                      boxColor: AppColors.lightText,
                      iconColor: AppColors.red,
                      onTap: () async {
                        return PopupWidget.signOutAlert(context, () async {
                          await ref.read(authController.notifier).signOut();

                          if (!context.mounted) return;

                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                imageProfileData.when(
                  data: (data) {
                    ImageProvider profileImage;

                    if (data != null && File(data).existsSync()) {
                      profileImage = FileImage(File(data));
                    } else {
                      profileImage = const AssetImage(
                        "assets/app_icon/app_icon.png",
                      );
                    }

                    return Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(1),
                          decoration: const BoxDecoration(
                            color: AppColors.lightText,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            backgroundColor: AppColors.mutedText,
                            radius: 70,
                            backgroundImage: profileImage,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              ref
                                  .read(imageProfileProvider.notifier)
                                  .pickAndSaveImage();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 25,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  error: (error, stackTrace) => textPoppins(
                    "Sorry, Something Went Wrong!",
                    color: AppColors.black,
                  ),
                  loading: () => const LoadingWidget(),
                ),
                const SizedBox(height: 50),
                userDataProvider.when(
                  data: (data) {
                    if (originalFullname.isEmpty) {
                      originalFullname = data.fullname;
                      _fullnameController.text = data.fullname;
                    }

                    if (originalNickname.isEmpty) {
                      originalNickname = data.nickname ?? "-";
                      _nicknameController.text = data.nickname ?? "-";
                    }

                    if (originalPhone.isEmpty) {
                      originalPhone = data.phone;
                      _phoneController.text = data.phone;
                    }

                    if (originalAddress.isEmpty) {
                      originalAddress = data.address ?? "-";
                      _addressController.text = data.address ?? "-";
                    }

                    if (originalSchoolName.isEmpty) {
                      originalSchoolName = data.schoolName ?? "-";
                      _schoolNameController.text = data.schoolName ?? "-";
                    }

                    if (originalEducationLevel == null && !isEditing) {
                      originalEducationLevel = EducationLevelExtension.fromLabel(data.educationLevel);
                      selectedValue = EducationLevelExtension.fromLabel(data.educationLevel);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        buildTextField(
                          controller: _fullnameController,
                          label: "Fullname",
                          icon: Icons.person,
                          isEdit: isEditing,
                          onChanged: (_) {
                            startEditing();
                          },
                        ),
                        const SizedBox(height: 12),
                        buildTextField(
                          controller: _nicknameController,
                          label: "Nickname",
                          icon: Icons.person,
                          isEdit: isEditing,
                          onChanged: (_) {
                            startEditing();
                          },
                        ),
                        const SizedBox(height: 12),
                        buildTextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          label: "Phone",
                          icon: Icons.phone,
                          isEdit: isEditing,
                          onChanged: (_) {
                            startEditing();
                          },
                        ),
                        if (data.role == UserRole.student) ...[
                          const SizedBox(height: 12),
                          buildTextField(
                            controller: _addressController,
                            label: "Address",
                            icon: Icons.location_on,
                            isEdit: isEditing,
                            onChanged: (_) {
                              startEditing();
                            },
                          ),
                          const SizedBox(height: 12),
                          buildTextField(
                            controller: _schoolNameController,
                            label: "School Name",
                            icon: Icons.school,
                            isEdit: isEditing,
                            onChanged: (_) {
                              startEditing();
                            },
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<EducationLevel>(
                            dropdownColor: AppColors.lightText,
                            initialValue: selectedValue,
                            decoration: InputDecoration(
                              labelText: 'Educational Level',
                              labelStyle: GoogleFonts.poppins(
                                color: AppColors.black.withAlpha(100),
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 2.0,
                                ),
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
                                selectedValue = newValue;
                                isEditing = true;
                              });
                            },
                          ),
                        ],
                        const SizedBox(height: 20),
                        if (isEditing)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Button(
                                text: "Cancel",
                                textColor: AppColors.black,
                                bgColor: AppColors.mutedText,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                borderRadius: BorderRadius.circular(10),
                                onPressed: () {
                                  cancelEditing();
                                },
                              ),
                              const SizedBox(width: 10),
                              Button(
                                text: "Update",
                                textColor: AppColors.lightText,
                                bgColor: AppColors.accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                borderRadius: BorderRadius.circular(10),
                                onPressed: () async {
                                  await saveEditing();
                                },
                              ),
                            ],
                          ),
                      ],
                    );
                  },
                  error: (error, stackTrace) => textPoppins(
                    "Sorry, Something Went Wrong!",
                    color: AppColors.black,
                  ),
                  loading: () => const LoadingWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
