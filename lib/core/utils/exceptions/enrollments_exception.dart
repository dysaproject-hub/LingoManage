import 'package:lingo_manage/core/utils/exceptions/app_error.dart';
import 'package:lingo_manage/core/utils/exceptions/app_error_type.dart';

class EnrollmentException extends AppError {
  const EnrollmentException({
    required super.type,
    required super.code,
    required super.message,
  });

  factory EnrollmentException.alreadyExists() {
    return const EnrollmentException(
      type: AppErrorType.conflict,
      code: 'ENROLLMENT_ALREADY_EXISTS',
      message: 'You already enrolled in this course.',
    );
  }

  factory EnrollmentException.courseNotFound() {
    return const EnrollmentException(
      type: AppErrorType.notFound,
      code: 'COURSE_NOT_FOUND',
      message: 'Course not found.',
    );
  }

  factory EnrollmentException.courseInactive() {
    return const EnrollmentException(
      type: AppErrorType.validation,
      code: 'COURSE_INACTIVE',
      message: 'This course is currently inactive.',
    );
  }

  factory EnrollmentException.unauthorized() {
    return const EnrollmentException(
      type: AppErrorType.unauthorized,
      code: 'UNAUTHORIZED',
      message: 'You are not authorized to perform this action.',
    );
  }

  factory EnrollmentException.invalidStatusTransition() {
    return const EnrollmentException(
      type: AppErrorType.validation,
      code: 'INVALID_STATUS_TRANSITION',
      message: 'Invalid enrollment status transition.',
    );
  }
}