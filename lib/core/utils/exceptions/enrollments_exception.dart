class EnrollmentException implements Exception {
  final String code;
  final String message;

  const EnrollmentException({
    required this.code,
    required this.message,
  });

  factory EnrollmentException.alreadyExists() {
    return const EnrollmentException(
      code: 'ENROLLMENT_ALREADY_EXISTS',
      message: 'You already enrolled in this course',
    );
  }

  factory EnrollmentException.courseNotFound() {
    return const EnrollmentException(
      code: 'COURSE_NOT_FOUND',
      message: 'Course not found.',
    );
  }

  factory EnrollmentException.courseInactive() {
    return const EnrollmentException(
      code: 'COURSE_INACTIVE',
      message: 'This course is currently inactive.',
    );
  }

  factory EnrollmentException.unauthorized() {
    return const EnrollmentException(
      code: 'UNAUTHORIZED',
      message: 'You are not authorized to perform this action.',
    );
  }

  factory EnrollmentException.invalidStatusTransition() {
    return const EnrollmentException(
      code: 'INVALID_STATUS_TRANSITION',
      message: 'Invalid enrollment status transition.',
    );
  }

  @override
  String toString() {
    return 'EnrollmentException($code): $message';
  }
}