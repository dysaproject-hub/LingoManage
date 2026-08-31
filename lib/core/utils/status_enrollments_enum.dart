import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/features/enrollments/models/enrollment_model.dart';

enum StatusEnrollments { pending, approved, rejected, cancelled }

extension StatusEnrollmentsExtension on StatusEnrollments {
  String get label {
    switch (this) {
      case StatusEnrollments.pending:
        return 'pending';
      case StatusEnrollments.approved:
        return 'approved';
      case StatusEnrollments.rejected:
        return 'rejected';
      case StatusEnrollments.cancelled:
        return 'cancelled';
    }
  }

  static Color statusColor({
    required EnrollmentModel enrollmentModel
  }) {
    switch (enrollmentModel.status.toLowerCase()) {
      case 'approved':
        return AppColors.success;

      case 'rejected':
        return Colors.red;

      case 'active':
        return AppColors.primary;

      case 'pending':
      default:
        return Colors.orange;
    }
  }
}
