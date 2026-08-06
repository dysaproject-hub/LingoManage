import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingo_manage/core/constants/firebase_exceptions.dart';

class FirebaseExceptionMessage {
  static String auth(FirebaseAuthException e) {
    switch (e.code) {
      case FirebaseAuthExceptionCode.userNotFound:
        return "Email tidak terdaftar";

      case FirebaseAuthExceptionCode.wrongPassword:
        return "Password salah";

      case FirebaseAuthExceptionCode.invalidCredential:
        return "Email atau password salah";

      case FirebaseAuthExceptionCode.emailAlreadyInUse:
        return "Email sudah terdaftar";

      case FirebaseAuthExceptionCode.weakPassword:
        return "Password terlalu lemah";

      case FirebaseAuthExceptionCode.invalidEmail:
        return "Format email tidak valid";

      case FirebaseAuthExceptionCode.tooManyRequest:
        return "Terlalu banyak percobaan login. Coba lagi nanti.";

      case FirebaseAuthExceptionCode.networkRequestFailed:
        return "Tidak ada koneksi internet.";

      default:
        return e.message ?? "Terjadi kesalahan.";
    }
  }
}