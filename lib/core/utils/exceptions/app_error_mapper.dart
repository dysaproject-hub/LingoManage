import 'package:lingo_manage/core/constants/supabase_exceptions.dart';
import 'package:lingo_manage/core/utils/exceptions/app_error.dart';
import 'package:lingo_manage/core/utils/exceptions/app_error_type.dart';
import 'package:lingo_manage/core/utils/exceptions/enrollments_exception.dart';
import 'package:lingo_manage/core/utils/exceptions/supabase_exceptions_message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorMapper {
  static AppError map(Object error) {
    // Supabase Authentication
    if (error is AuthException) {
      return _mapSupabaseAuth(error);
    }

    // Supabase Postgrest
    if (error is PostgrestException) {
      return _mapSupabase(error);
    }

    // Enrollment business exception
    if (error is EnrollmentException) {
      return _mapEnrollment(error);
    }

    // Unknown error
    return AppError(
      type: AppErrorType.unknown,
      code: 'UNKNOWN_ERROR',
      message: 'An unexpected error occurred. Please try again.',
    );
  }

  static AppError _mapSupabaseAuth(AuthException error) {
    final message = SupabaseExceptionMessage.auth(error);

    switch (error.code) {
      case SupabaseAuthExceptionCode.userNotFound:
      case SupabaseAuthExceptionCode.invalidCredential:
        return AppError(
          type: AppErrorType.unauthorized,
          code: error.code ?? '',
          message: message,
        );

      case SupabaseAuthExceptionCode.emailAlreadyRegistered:
        return AppError(
          type: AppErrorType.conflict,
          code: error.code ?? '',
          message: message,
        );

      case SupabaseAuthExceptionCode.networkError:
        return AppError(
          type: AppErrorType.network,
          code: error.code ?? '',
          message: message,
        );

      default:
        return AppError(
          type: AppErrorType.supabase,
          code: error.code ?? '',
          message: message,
        );
    }
  }

  static AppError _mapSupabase(PostgrestException error) {
    switch (error.code) {
      case 'permission-denied':
        return AppError(
          type: AppErrorType.forbidden,
          code: error.code ?? '',
          message: 'You do not have permission to perform this action.',
        );

      case 'unauthenticated':
        return AppError(
          type: AppErrorType.unauthorized,
          code: error.code ?? '',
          message: 'Your session has expired. Please log in again.',
        );

      case 'not-found':
        return AppError(
          type: AppErrorType.notFound,
          code: error.code ?? '',
          message: 'The requested data could not be found.',
        );

      case 'unavailable':
      case 'network-request-failed':
        return AppError(
          type: AppErrorType.network,
          code: error.code ?? '',
          message: 'Unable to connect to the server.',
        );

      case 'deadline-exceeded':
        return AppError(
          type: AppErrorType.network,
          code: error.code ?? '',
          message: 'The request took too long to respond. Please try again.',
        );

      default:
        return AppError(
          type: AppErrorType.supabase,
          code: error.code ?? '',
          message: 'A service error occurred. Please try again later.',
        );
    }
  }

  static AppError _mapEnrollment(EnrollmentException error) {
    switch (error.code) {
      case 'ENROLLMENT_ALREADY_EXISTS':
        return AppError(
          type: AppErrorType.conflict,
          code: error.code,
          message: error.message,
        );

      case 'COURSE_NOT_FOUND':
        return AppError(
          type: AppErrorType.notFound,
          code: error.code,
          message: error.message,
        );

      case 'COURSE_INACTIVE':
        return AppError(
          type: AppErrorType.validation,
          code: error.code,
          message: error.message,
        );

      case 'UNAUTHORIZED':
        return AppError(
          type: AppErrorType.unauthorized,
          code: error.code,
          message: error.message,
        );

      case 'INVALID_STATUS_TRANSITION':
        return AppError(
          type: AppErrorType.validation,
          code: error.code,
          message: error.message,
        );

      default:
        return AppError(
          type: AppErrorType.unknown,
          code: error.code,
          message: error.message,
        );
    }
  }
}