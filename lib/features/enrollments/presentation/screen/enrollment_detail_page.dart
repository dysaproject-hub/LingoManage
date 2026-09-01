import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/utils/currency_formatters.dart';
import 'package:lingo_manage/core/utils/status_enrollments_enum.dart';
import 'package:lingo_manage/features/course/models/course_program_model.dart';
import 'package:lingo_manage/features/enrollments/models/enrollment_model.dart';
import 'package:lingo_manage/features/enrollments/presentation/providers/enrollment_provider.dart';
import 'package:lingo_manage/features/student/presentation/provider/student_provider.dart';
import 'package:lingo_manage/shared/widgets/buttons/button_widget.dart';
import 'package:lingo_manage/shared/widgets/cards/fee_card.dart';
import 'package:lingo_manage/shared/widgets/items/row_detail_data.dart';
import 'package:lingo_manage/shared/widgets/popups/enrollment_section/enrollment_popup.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class EnrollmentDetailPage extends ConsumerWidget {
  final String courseName;
  final CourseProgramModel programModel;

  final EnrollmentModel enrollmentModel;

  const EnrollmentDetailPage({
    super.key,
    required this.courseName,
    required this.programModel,
    required this.enrollmentModel,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = StatusEnrollmentsExtension.statusColor(
      enrollmentModel: enrollmentModel,
    );

    return Scaffold(
      backgroundColor: AppColors.lightText,

      appBar: AppBar(
        backgroundColor: AppColors.lightText,
        elevation: 0,

        title: textPoppins(
          'Enrollment Detail',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.08),

                  borderRadius: BorderRadius.circular(18),

                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.18),
                  ),
                ),

                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,

                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),

                      child: Icon(
                        _getStatusIcon(),
                        color: statusColor,
                        size: 32,
                      ),
                    ),

                    const SizedBox(height: 14),

                    textBaloo2(
                      StatusEnrollmentsExtension.statusTitle(enrollmentModel: enrollmentModel),
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 6),

                    textPoppins(
                      StatusEnrollmentsExtension.statusDescription(enrollmentModel: enrollmentModel),
                      fontSize: 12,
                      color: AppColors.mutedText,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: textPoppins(
                        enrollmentModel.status.toUpperCase(),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightText,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              textBaloo2(
                'Course Information',
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: AppColors.lightText,

                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(
                    color: AppColors.mutedText.withValues(alpha: 0.15),
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailRow(
                      icon: Icons.school_outlined,
                      title: 'Course',
                      value: courseName,
                    ),

                    const SizedBox(height: 16),

                    DetailRow(
                      icon: Icons.menu_book_outlined,
                      title: 'Program',
                      value: programModel.name,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              textBaloo2(
                'Fee Information',
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: FeeCard(
                      icon: Icons.receipt_long_outlined,
                      title: 'Registration',
                      value: formatRupiah(programModel.registrationFee),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: FeeCard(
                      icon: Icons.calendar_month_outlined,
                      title: 'Monthly',
                      value: formatRupiah(programModel.monthlyFee),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              textBaloo2(
                'Student Information',
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: AppColors.lightText,

                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(
                    color: AppColors.mutedText.withValues(alpha: 0.15),
                  ),
                ),

                child: Column(
                  children: [
                    DetailRow(
                      icon: Icons.person_outline,
                      title: 'Full Name',
                      value: enrollmentModel.studentFullName,
                    ),

                    const SizedBox(height: 16),

                    DetailRow(
                      icon: Icons.phone_outlined,
                      title: 'Phone Number',
                      value: enrollmentModel.studentPhoneNumber,
                    ),

                    const SizedBox(height: 16),

                    DetailRow(
                      icon: Icons.school_outlined,
                      title: 'Education',
                      value: enrollmentModel.studentEducationLevel,
                    ),

                    const SizedBox(height: 16),

                    DetailRow(
                      icon: Icons.business_outlined,
                      title: 'School / Institution',
                      value: enrollmentModel.studentSchoolName,
                    ),

                    const SizedBox(height: 16),

                    DetailRow(
                      icon: Icons.location_on_outlined,
                      title: 'Address',
                      value: enrollmentModel.studentAddress,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              textBaloo2(
                'Enrollment Information',
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),

                  borderRadius: BorderRadius.circular(14),
                ),

                child: Row(
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      color: AppColors.primary,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textPoppins(
                            'Enrollment ID',
                            fontSize: 10,
                            color: AppColors.mutedText,
                          ),

                          const SizedBox(height: 3),

                          textPoppins(
                            enrollmentModel.id,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              if (enrollmentModel.status.toLowerCase() == 'approved')
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: 'View My Course',
                    textColor: AppColors.lightText,
                    bgColor: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    borderRadius: BorderRadius.circular(12),
                    onPressed: () {
                      // TODO:
                      // Navigasi ke course student
                    },
                  ),
                ),

              if (enrollmentModel.status.toLowerCase() == 'pending')
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.orange,
                        size: 20,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: textPoppins(
                          'Please wait while the course administrator reviews your enrollment.',
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 30),

              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Button(
                  text: 'Cancel Enrollment',
                  textColor: AppColors.lightText,
                  bgColor: AppColors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  borderRadius: BorderRadius.circular(12),
                  onPressed: () {
                    EnrollmentPopup.cancelEnrollmentAlert(
                      context,
                      courseName,
                      programModel,
                      () async {
                        try {
                          Navigator.pop(context);
                          await ref
                              .read(enrollmentControllerProvider.notifier)
                              .deleteEnrollment(
                                enrollmentId: enrollmentModel.id,
                              );

                          ref.invalidate(getStudentCourseProvider);

                          if (!context.mounted) return;

                          Navigator.pop(context);
                        } catch (e) {
                          if (!context.mounted) return;

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Gagal membatalkan enrollment'),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (enrollmentModel.status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle_outline;

      case 'rejected':
        return Icons.cancel_outlined;

      case 'active':
        return Icons.verified_outlined;

      case 'pending':
      default:
        return Icons.hourglass_empty;
    }
  }
}
