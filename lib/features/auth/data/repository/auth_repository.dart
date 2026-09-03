import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/features/auth/data/datasources/auth_datasources.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final AuthDatasources _datasource;

  AuthRepository(this._datasource);

  // AUTH STATE
  Stream<User?> get authStateChanges => _datasource.authStateChanges;

  // LOGIN
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    return await _datasource.signIn(email, password);
  }

  Future<void> resendVerificationEmail(String email) async {
    return await _datasource.resendVerificationEmail(email);
  }

  // REGISTER Admin
  Future<AppUser> registerAdmin({
    required String email,
    required String password,
    required String fullname,
    required String nickname,
    required String phone,
  }) async {
    return await _datasource.registerAdmin(
      email: email,
      password: password,
      fullname: fullname,
      nickname: nickname,
      phone: phone,

      //TODO: sesuaikan nanti
      subscriptionStatus: 'free',
      studentLimit: 15,
    );
  }

  // REGISTER STUDENT
  Future<AppUser> registerStudent({
    required String email,
    required String password,
    required String fullname,
    required String nickname,
    required String phone,
    required String address,
  }) async {
    return await _datasource.registerStudent(
      email: email,
      password: password,
      fullname: fullname,
      nickname: nickname,
      phone: phone,
      address: address,
    );
  }

  // LOGOUT
  Future<void> signOut() async {
    await _datasource.signOut();
  }

  Future<AppUser> getCurrentUser(String uid) async {
    return await _datasource.getCurrentUser(uid);
  }
}
