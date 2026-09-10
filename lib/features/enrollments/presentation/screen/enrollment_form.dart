import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/providers/app_users_provider.dart';
import 'package:lingo_manage/core/routes/routes.dart';
import 'package:lingo_manage/core/utils/currency_formatters.dart';
import 'package:lingo_manage/core/utils/education_level_enum.dart';
import 'package:lingo_manage/core/utils/exceptions/enrollments_exception.dart';
import 'package:lingo_manage/core/utils/status_enrollments_enum.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:lingo_manage/features/course/models/course_program_model.dart';
import 'package:lingo_manage/features/enrollments/presentation/providers/enrollment_provider.dart';
import 'package:lingo_manage/features/student/presentation/provider/student_provider.dart';
import 'package:lingo_manage/shared/widgets/buttons/button_widget.dart';
import 'package:lingo_manage/shared/widgets/cards/fee_card.dart';
import 'package:lingo_manage/shared/widgets/loadings/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/items/summary_item.dart';
import 'package:lingo_manage/shared/widgets/text/text_field_widget.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class EnrollmentPage extends ConsumerStatefulWidget {
  final CourseModel course;

  // final String programId;
  // final String programName;
  // final int registrationFee;
  // final int monthlyFee;
  final CourseProgramModel programModel;

  const EnrollmentPage({
    super.key,
    required this.course,
    required this.programModel,
    // required this.programId,
    // required this.programName,
    // required this.registrationFee,
    // required this.monthlyFee,
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
          content: Text('Silakan pilih jenjang pendidikan terlebih dahulu'),
        ),
      );

      return;
    }

    final userState = ref.read(appUserControllerProvider);

    userState.when(
      data: (user) {
        const status = StatusEnrollments.pending;

        final studentFullName = _fullnameController.text;
        final studentPhoneNumber = _phoneController.text;
        final studentEducationLevel = _educationLevel?.label;
        final studentSchoolName = _schoolController.text;
        final studentAddress = _addressController.text;

        _showEnrollmentConfirmation(
          courseId: widget.course.id,
          studentId: user.uid,
          studentFullName: studentFullName,
          studentPhoneNumber: studentPhoneNumber,
          studentEducationLevel: studentEducationLevel ?? "other",
          studentSchoolName: studentSchoolName,
          studentAddress: studentAddress,
          programId: widget.programModel.id,
          status: status.label,
        );
      },
      loading: () => LoadingWidget(),
      error: (error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengambil data user')),
        );
      },
    );
  }

  void _showEnrollmentConfirmation({
    required String courseId,
    required String studentId,
    required String studentFullName,
    required String studentPhoneNumber,
    required String studentEducationLevel,
    required String studentSchoolName,
    required String studentAddress,
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

                SummaryItem(title: 'Course', value: widget.course.name),

                SummaryItem(title: 'Program', value: widget.programModel.name),

                SummaryItem(
                  title: 'Registration Fee',
                  value: formatRupiah(widget.programModel.registrationFee),
                ),

                SummaryItem(
                  title: 'Monthly Fee',
                  value: formatRupiah(widget.programModel.monthlyFee),
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
                    onPressed: () async {
                      try {
                        debugPrint("=== BUAT ENROLLMENT ===");
                        final enrollment = await ref
                            .read(enrollmentControllerProvider.notifier)
                            .addEnrollment(
                              studentId: studentId,
                              studentFullName: studentFullName,
                              studentPhoneNumber: studentPhoneNumber,
                              studentEducationLevel: studentEducationLevel,
                              studentSchoolName: studentSchoolName,
                              studentAddress: studentAddress,
                              courseId: courseId,
                              programId: programId,
                              status: status,
                            );

                        if (!context.mounted) return;

                        if (enrollment == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to create enrollment'),
                            ),
                          );
                          return;
                        }

                        debugPrint("=== BERHASIL BUAT ENROLLMENT ===");

                        ref.invalidate(getStudentCourseProvider);

                        Navigator.pop(context); // tutup bottom sheet

                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.enrollmentDetailPage,
                          arguments: {
                            'courseName': widget.course.name,
                            'programModel': widget.programModel,
                            'enrollmentModel': enrollment,
                          },
                        );

                        debugPrint("=== BERHASIL Navigate ===");
                      } on EnrollmentException catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.message)));
                      } catch (e) {
                        Navigator.pop(context);
                        debugPrint('$e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Terjadi kesalahan. Silakan coba lagi.',
                            ),
                          ),
                        );
                      }
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
                        widget.programModel.name,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: FeeCard(
                        title: 'Registration',
                        value: formatRupiah(
                          widget.programModel.registrationFee,
                        ),
                        icon: Icons.receipt_long_outlined,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: FeeCard(
                        title: 'Monthly',
                        value: formatRupiah(widget.programModel.monthlyFee),
                        icon: Icons.calendar_month_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

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

                Column(
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

                    DropdownButtonFormField<String>(
                      initialValue: _educationLevel?.label,

                      decoration: InputDecoration(
                        hintText: 'Select education level',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.mutedText.withValues(alpha: 0.25),
                          ),
                        ),

                        filled: true,
                        fillColor: AppColors.lightText,
                      ),

                      items: EducationLevel.values.map((level) {
                        return DropdownMenuItem<String>(
                          value: level.label,
                          child: textPoppins(level.label),
                        );
                      }).toList(),

                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          _educationLevel = EducationLevelExtension.fromLabel(
                            value,
                          );
                        });
                      },

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Education level is required';
                        }

                        return null;
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
                            color: AppColors.mutedText.withValues(alpha: 0.25),
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
                ),

                const SizedBox(height: 30),

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
