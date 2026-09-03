import 'package:flutter/cupertino.dart';
import 'package:lingo_manage/core/constants/database_table_name.dart';
import 'package:lingo_manage/core/constants/user_role.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthDatasources {
  final SupabaseClient _client;

  AuthDatasources(this._client);

  //AUTH STATE
  Stream<User?> get authStateChanges =>
      _client.auth.onAuthStateChange.map((event) => event.session?.user);

  //SIGNIN METHOD
  Future<AppUser> signIn(String email, String password) async {
    final userCredential = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user?.id;

    if (uid == null) {
      throw Exception("Failed to retrieve user UID.");
    }

    final row = await _client
        .from(DatabaseTableName.usersCollection)
        .select()
        .eq("id", uid)
        .maybeSingle();

    if (row == null) {
      throw Exception('User profile not found.');
    }

    return AppUser.fromMap(uid, row);
  }

  //RESEND VERIFICATION METHOD
  Future<void> resendVerificationEmail(String email) async {
  await _client.auth.resend(
    type: OtpType.signup,
    email: email,
  );
}

  //REGISTER METHOD FOR ADMIN
  Future<AppUser> registerAdmin({
    required String email,
    required String password,
    required String fullname,
    required String nickname,
    required String phone,
    required String subscriptionStatus,
    required int studentLimit,
  }) async {
    final userCredential = await _client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: 'lingomanage-dev://login-callback/'
    );

    final user = userCredential.user;

    if (user == null) {
      throw Exception('Failed to create account.');
    }

    if (userCredential.session == null) {
      debugPrint('Registration successful, email verification required.');
    }

//     if (userCredential.user != null && userCredential.session == null) {
//   // Email confirmation aktif
//   // Arahkan ke halaman "Verifikasi Email"
  
// }

    debugPrint('User: ${userCredential.user}');
    debugPrint('Session: ${userCredential.session}');

    final uid = userCredential.user?.id;

    if (uid == null) {
      throw Exception("Failed to retrieve user UID.");
    }

    final data = {
      'id': uid,
      'email': email,
      'fullname': fullname,
      'nickname': nickname,
      'phone': phone,
      'role': UserRole.admin,
      'subscription_status': subscriptionStatus,
      'student_limit': studentLimit,
    };

    final row = await _client
        .from(DatabaseTableName.usersCollection)
        .insert(data)
        .select()
        .single();

    return AppUser.fromMap(uid, row);
  }

  //REGISTER METHOD FOR STUDENT
  Future<AppUser> registerStudent({
    required String email,
    required String password,
    required String fullname,
    required String nickname,
    required String phone,
    required String address,
  }) async {
    final userCredential = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final uid = userCredential.user?.id;

    if (uid == null) {
      throw Exception("Failed to retrieve user UID.");
    }

    final data = {
      'id': uid,
      'email': email,
      'fullname': fullname,
      'nickname': nickname,
      'phone': phone,
      'address': address,
      'role': UserRole.student,
    };

    final row = await _client
        .from(DatabaseTableName.usersCollection)
        .insert(data)
        .select()
        .single();

    return AppUser.fromMap(uid, row);
  }

  //SIGNOUT METHOD
  Future<void> signOut() async {
    return await _client.auth.signOut();
  }

  Future<AppUser> getCurrentUser(String uid) async {
    final doc = await _client
        .from(DatabaseTableName.usersCollection)
        .select()
        .eq('id', uid)
        .maybeSingle();

    if (doc == null) {
      throw Exception('User profile not found.');
    }

    return AppUser.fromMap(uid, doc);
  }
}
