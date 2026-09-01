import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/features/enrollments/models/enrollment_model.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class StudentCard extends ConsumerWidget {
  final EnrollmentModel enrollmentModel;

  const StudentCard({
    super.key,
    required this.enrollmentModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

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
      ),
    );
  }
}
