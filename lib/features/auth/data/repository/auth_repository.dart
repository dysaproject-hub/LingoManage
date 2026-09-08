import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/features/auth/data/datasources/auth_datasources.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final AuthDatasource _datasource;
  final SupabaseClient _supabase;

  AuthRepository(
    this._datasource,
    this._supabase,
  );

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullname,
    String? nickname,
    String? phone,
  }) {
    return _datasource.signUp(
      email: email,
      password: password,
      fullname: fullname,
      nickname: nickname,
      phone: phone,
    );
  }

  Future<void> becomeInstructor() async {
  await _datasource.becomeInstructor();
}

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _datasource.signIn(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() {
    return _datasource.signOut();
  }

  Future<void> resendVerificationEmail(String email) {
    return _datasource.resendVerificationEmail(email);
  }

  User? get currentUser => _datasource.currentUser;

  Stream<AuthState> get authStateChanges =>
      _datasource.authStateChanges;

  Future<AppUser?> getCurrentUser(String uid) async {
    final response = await _supabase
        .from('users')
        .select()
        .eq('id', uid)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return AppUser.fromMap(uid, response);
  }
}