class SupabaseAuthExceptionCode {
  static const String invalidCredential = 'invalid_credentials';
  static const String userNotFound = 'user_not_found';
  static const String emailAlreadyRegistered = 'email_already_registered';
  static const String weakPassword = 'weak_password';
  static const String invalidEmail = 'invalid_email';
  static const String emailNotConfirmed = 'email_not_confirmed';
  static const String userBanned = 'user_banned';
  static const String tooManyRequests = 'too_many_requests';
  static const String networkError = 'network_error';
}