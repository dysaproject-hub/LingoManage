import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/utils/status_enrollments_enum.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_program_provider.dart';
import 'package:lingo_manage/features/enrollments/models/enrollment_model.dart';
import 'package:lingo_manage/features/enrollments/presentation/providers/enrollment_provider.dart';
import 'package:lingo_manage/features/student/presentation/provider/student_provider.dart';
import 'package:lingo_manage/shared/widgets/popups/enrollment_section/enrollment_popup.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class EnrollmentCard extends ConsumerWidget {
  final CourseModel courseModel;
  final EnrollmentModel enrollmentModel;

  const EnrollmentCard({
    super.key,
    required this.courseModel,
    required this.enrollmentModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseProgramProvider = ref.watch(
      courseProgramControllerProvider.notifier,
    );

    return Card(
      color: AppColors.lightText,

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),

        leading: CircleAvatar(
          backgroundColor: AppColors.primary,

          child: textBaloo2(
            enrollmentModel.studentFullName.isNotEmpty
                ? enrollmentModel.studentFullName[0].toUpperCase()
                : '?',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.lightText,
          ),
        ),

        title: textPoppins(
          enrollmentModel.studentFullName,
          fontWeight: FontWeight.w600,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
        ),

        subtitle: textPoppins(
          enrollmentModel.studentEducationLevel,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
          fontSize: 12,
          color: AppColors.mutedText,
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Rejected Enrollment
            IconButton(
              onPressed: () async {
                final program = await courseProgramProvider.getProgramById(
                  programId: enrollmentModel.programId,
                );

                if (!context.mounted) return;

                return EnrollmentPopup.rejectedEnrollmentDialog(
                  context,
                  enrollmentModel,
                  program!.name,
                  () async {
                    return await ref
                        .read(enrollmentControllerProvider.notifier)
                        .updateStatusEnrollment(
                          enrollmentId: enrollmentModel.id,
                          statusEnrollment: StatusEnrollments.rejected.label,
                        );
                  },
                );
              },
              icon: Icon(Icons.cancel_outlined, color: AppColors.red),
            ),

            //Approved Enrollment
            IconButton(
              onPressed: () async {
                final program = await courseProgramProvider.getProgramById(
                  programId: enrollmentModel.programId,
                );

                if (!context.mounted) return;

                return EnrollmentPopup.approvalDialog(
                  context,
                  enrollmentModel,
                  program!.name,
                  () async {
                    await ref
                        .read(enrollmentControllerProvider.notifier)
                        .updateStatusEnrollment(
                          enrollmentId: enrollmentModel.id,
                          statusEnrollment: StatusEnrollments.approved.label,
                        );

                    if (!context.mounted) return;

                    Navigator.pop(context);

                    ref.invalidate(getEnrollmentByCourseIdAndStatusPending);
                    ref.invalidate(approvedStudentByCourseProvider);
                  },
                );
              },
              icon: Icon(
                Icons.check_circle_outline_outlined,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
