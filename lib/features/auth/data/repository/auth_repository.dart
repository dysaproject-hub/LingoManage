import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/core/utils/firebase_exceptions_message.dart';
import 'package:lingo_manage/features/auth/data/datasources/auth_datasources.dart';

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
    try {
      return await _datasource.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      throw FirebaseExceptionMessage.auth(e);
    }
  }

  // REGISTER Admin
  Future<AppUser> registerAdmin({
    required String email,
    required String password,
    required String fullname,
    required String nickname,
    required String phone,
    required String courseName,
  }) async {
    try {
      return await _datasource.registerAdmin(
        email: email,
        password: password,
        fullname: fullname,
        nickname: nickname,
        phone: phone,
        courseName: courseName,
        subscriptionStatus: 'free',
        studentLimit: 15,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseExceptionMessage.auth(e);
    }
  }

  // REGISTER STUDENT
  Future<AppUser> registerStudent({
    required String email,
    required String password,
    required String fullname,
    required String nickname,
    required String phone,
  }) async {
    try {
      return await _datasource.registerStudent(
        email: email,
        password: password,
        fullname: fullname,
        nickname: nickname,
        phone: phone,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseExceptionMessage.auth(e);
    }
  }

  // LOGOUT
  Future<void> signOut() async {
    await _datasource.signOut();
  }

  Future<AppUser> getCurrentUser(String uid) async {
    return await _datasource.getCurrentUser(uid);
  }
}
