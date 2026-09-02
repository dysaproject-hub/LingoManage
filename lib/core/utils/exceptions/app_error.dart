import 'package:lingo_manage/core/utils/exceptions/app_error_type.dart';

class AppError implements Exception {
  final AppErrorType type;
  final String code;
  final String message;

  const AppError({
    required this.type,
    required this.code,
    required this.message,
  });

  @override
  String toString() {
    return 'AppError($code): $message';
  }
}