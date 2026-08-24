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
}
