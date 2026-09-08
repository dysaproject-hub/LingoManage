import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthDatasource {
  final SupabaseClient _supabase;

  AuthDatasource(this._supabase);

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullname,
    String? nickname,
    String? phone,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
      data: {'fullname': fullname, 'nickname': nickname, 'phone': phone},
    );
  }

  Future<void> becomeInstructor() async {
    try {
      debugPrint('================================');
      debugPrint('CALLING BECOME INSTRUCTOR RPC');
      debugPrint('UID: ${_supabase.auth.currentUser?.id}');
      debugPrint('EMAIL: ${_supabase.auth.currentUser?.email}');
      debugPrint('================================');

      await _supabase.rpc('become_instructor');

      debugPrint('================================');
      debugPrint('BECOME INSTRUCTOR RPC SUCCESS');
      debugPrint('================================');
    } catch (e, stackTrace) {
      debugPrint('================================');
      debugPrint('BECOME INSTRUCTOR RPC ERROR');
      debugPrint('ERROR: $e');
      debugPrint('STACK: $stackTrace');
      debugPrint('================================');

      rethrow;
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<void> resendVerificationEmail(String email) async {
    await _supabase.auth.resend(type: OtpType.signup, email: email);
  }

  User? get currentUser => _supabase.auth.currentUser;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
