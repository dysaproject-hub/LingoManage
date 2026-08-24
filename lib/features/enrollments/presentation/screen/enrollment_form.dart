import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/providers/app_users_provider.dart';
import 'package:lingo_manage/core/utils/currency_formatters.dart';
import 'package:lingo_manage/core/utils/education_level_enum.dart';
import 'package:lingo_manage/core/utils/status_enrollments_enum.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:lingo_manage/features/enrollments/presentation/providers/enrollment_provider.dart';
import 'package:lingo_manage/shared/widgets/button_widget.dart';
import 'package:lingo_manage/shared/widgets/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/text_field_widget.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class EnrollmentPage extends ConsumerStatefulWidget {
  final CourseModel course;

  final String programId;
  final String programName;
  final int registrationFee;
  final int monthlyFee;

  const EnrollmentPage({
    super.key,
    required this.course,
    required this.programId,
    required this.programName,
    required this.registrationFee,
    required this.monthlyFee,
  });

  @override
  ConsumerState<EnrollmentPage> createState() => _EnrollmentPageState();
}

class _EnrollmentPageState extends ConsumerState<EnrollmentPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _schoolController = TextEditingController();
  final _addressController = TextEditingController();

  EducationLevel? _educationLevel;

  @override
  void dispose() {
    _fullnameController.dispose();
    _phoneController.dispose();
    _schoolController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  void _submitEnrollment() {
  FocusScope.of(context).unfocus();

  if (!_formKey.currentState!.validate()) {
    return;
  }

  if (_educationLevel == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Silakan pilih jenjang pendidikan terlebih dahulu',
        ),
      ),
    );

    return;
  }

  final userState = ref.read(appUserControllerProvider);

  userState.when(
    data: (user) {

      const status = StatusEnrollments.pending;

      _showEnrollmentConfirmation(
        courseId: widget.course.id,
        studentId: user.uid,
        programId: widget.programId,
        status: status.label,
      );
    },
    loading: () => LoadingWidget(),
    error: (error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengambil data user'),
        ),
      );
    },
  );
}

  void _showEnrollmentConfirmation({
    required String courseId,
    required String studentId,
    required String programId,
    required String status,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.lightText,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.mutedText.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                textBaloo2(
                  'Confirm Enrollment',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),

                const SizedBox(height: 8),

                textPoppins(
                  'Please make sure your information is correct before submitting your enrollment.',
                  fontSize: 12,
                  color: AppColors.mutedText,
                ),

                const SizedBox(height: 20),

                _SummaryItem(title: 'Course', value: widget.course.name),

                _SummaryItem(title: 'Program', value: widget.programName),

                _SummaryItem(
                  title: 'Registration Fee',
                  value: formatRupiah(widget.registrationFee),
                ),

                _SummaryItem(
                  title: 'Monthly Fee',
                  value: formatRupiah(widget.monthlyFee),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: 'Submit Enrollment',
                    textColor: AppColors.lightText,
                    bgColor: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    borderRadius: BorderRadius.circular(12),
                    onPressed: () {
                      Navigator.pop(context);

                      ref
                          .watch(enrollmentControllerProvider.notifier)
                          .addEnrollment(
                            courseId: courseId,
                            studentId: studentId,
                            programId: programId,
                            status: status,
                          );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: textPoppins(
                      'Review Again',
                      fontSize: 12,
                      color: AppColors.mutedText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = ref.watch(appUserControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.lightText,

      appBar: AppBar(
        backgroundColor: AppColors.lightText,
        elevation: 0,
        title: textPoppins(
          'Enrollment',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ========================================================
                // COURSE & PROGRAM
                // ========================================================
                textBaloo2(
                  'Your Enrollment',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),

                const SizedBox(height: 6),

                textPoppins(
                  'Review the selected course and program.',
                  fontSize: 12,
                  color: AppColors.mutedText,
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textPoppins(
                        'COURSE',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),

                      const SizedBox(height: 4),

                      textBaloo2(
                        widget.course.name,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),

                      const SizedBox(height: 14),

                      Divider(
                        color: AppColors.mutedText.withValues(alpha: 0.15),
                      ),

                      const SizedBox(height: 12),

                      textPoppins(
                        'PROGRAM',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),

                      const SizedBox(height: 4),

                      textPoppins(
                        widget.programName,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ========================================================
                // FEE
                // ========================================================
                Row(
                  children: [
                    Expanded(
                      child: _FeeCard(
                        title: 'Registration',
                        value: formatRupiah(widget.registrationFee),
                        icon: Icons.receipt_long_outlined,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _FeeCard(
                        title: 'Monthly',
                        value: formatRupiah(widget.monthlyFee),
                        icon: Icons.calendar_month_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // ========================================================
                // PERSONAL INFORMATION
                // ========================================================
                textBaloo2(
                  'Personal Information',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),

                const SizedBox(height: 6),

                textPoppins(
                  'Please provide your personal information.',
                  fontSize: 12,
                  color: AppColors.mutedText,
                ),

                const SizedBox(height: 18),

                userDataProvider.when(
                  data: (data) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FULLNAME
                        textPoppins(
                          'Full Name',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),

                        const SizedBox(height: 6),

                        textFieldWidget(
                          labelText: 'Enter your full name',
                          controller: _fullnameController,
                          keyboardType: TextInputType.name,
                        ),

                        const SizedBox(height: 16),

                        // PHONE
                        textPoppins(
                          'Phone Number',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),

                        const SizedBox(height: 6),

                        textFieldWidget(
                          labelText: 'Enter your phone number',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: 16),

                        // EDUCATION
                        textPoppins(
                          'Education Level',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),

                        const SizedBox(height: 6),

                        DropdownButtonFormField<EducationLevel>(
                          initialValue: EducationLevelExtension.fromLabel(
                            data.educationLevel,
                          ),

                          decoration: InputDecoration(
                            hintText: 'Select education level',

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.mutedText.withValues(
                                  alpha: 0.25,
                                ),
                              ),
                            ),

                            filled: true,
                            fillColor: AppColors.lightText,
                          ),

                          items: EducationLevel.values.map((
                            EducationLevel level,
                          ) {
                            return DropdownMenuItem<EducationLevel>(
                              value: level,
                              child: textPoppins(level.label),
                            );
                          }).toList(),

                          onChanged: (value) {
                            setState(() {
                              _educationLevel = value;
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        // SCHOOL
                        textPoppins(
                          'School / Institution',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),

                        const SizedBox(height: 6),

                        textFieldWidget(
                          labelText: 'Enter school or institution',
                          controller: _schoolController,
                          keyboardType: TextInputType.text,
                        ),

                        const SizedBox(height: 16),

                        // ADDRESS
                        textPoppins(
                          'Address',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),

                        const SizedBox(height: 6),

                        TextFormField(
                          controller: _addressController,
                          keyboardType: TextInputType.streetAddress,
                          maxLines: 4,

                          decoration: InputDecoration(
                            hintText: 'Enter your address',

                            alignLabelWithHint: true,

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.mutedText.withValues(
                                  alpha: 0.25,
                                ),
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.lightText,
                          ),

                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Address is required';
                            }

                            return null;
                          },
                        ),
                      ],
                    );
                  },
                  error: (e, s) => textPoppins("Sorry, something went wrong"),
                  loading: () => LoadingWidget(),
                ),

                const SizedBox(height: 30),

                // ========================================================
                // NOTICE
                // ========================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.accent,
                        size: 20,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: textPoppins(
                          'Your enrollment will be reviewed by the course administrator. You will be notified once your enrollment has been approved.',
                          fontSize: 11,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ========================================================
                // SUBMIT
                // ========================================================
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: 'Submit Enrollment',
                    textColor: AppColors.lightText,
                    bgColor: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    borderRadius: BorderRadius.circular(12),
                    onPressed: _submitEnrollment,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================================================
// FEE CARD
// ==========================================================================

class _FeeCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _FeeCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: AppColors.lightText,
        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: AppColors.mutedText.withValues(alpha: 0.18)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),

          const SizedBox(height: 8),

          textPoppins(title, fontSize: 10, color: AppColors.mutedText),

          const SizedBox(height: 3),

          textPoppins(
            value,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ],
      ),
    );
  }
}

// ==========================================================================
// SUMMARY ITEM
// ==========================================================================

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: textPoppins(title, fontSize: 12, color: AppColors.mutedText),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: textPoppins(
              value,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
