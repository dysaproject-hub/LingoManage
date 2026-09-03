import 'package:lingo_manage/core/constants/supabase_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseExceptionMessage {
  static String auth(AuthException e) {
    switch (e.code) {
      case SupabaseAuthExceptionCode.userNotFound:
        return "Email tidak terdaftar";

      case SupabaseAuthExceptionCode.weakPassword:
        return "Password salah";

      case SupabaseAuthExceptionCode.invalidCredential:
        return "Email atau password salah";

      case SupabaseAuthExceptionCode.emailAlreadyRegistered:
        return "Email sudah terdaftar";

      case SupabaseAuthExceptionCode.invalidEmail:
        return "Format email tidak valid";

      case SupabaseAuthExceptionCode.tooManyRequests:
        return "Terlalu banyak percobaan login. Coba lagi nanti.";

      case SupabaseAuthExceptionCode.networkError:
        return "Tidak ada koneksi internet.";

      default:
        return e.message;
    }
  }
}