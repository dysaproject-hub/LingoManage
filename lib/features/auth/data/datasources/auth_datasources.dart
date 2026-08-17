import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingo_manage/core/constants/firestore_collections.dart';
import 'package:lingo_manage/core/constants/user_role.dart';
import 'package:lingo_manage/core/models/app_users.dart';

class AuthDatasources {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  AuthDatasources(this._db, this._auth);

  //AUTH STATE
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  //SIGNIN METHOD
  Future<AppUser> signIn(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user?.uid;

    if (uid == null) {
      throw Exception("Failed to retrieve user UID.");
    }

    final doc = await _db
        .collection(FirestoreCollection.usersCollection)
        .doc(uid)
        .get();

    return AppUser.fromMap(uid, doc.data()!);
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
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user?.uid;

    if (uid == null) {
      throw Exception("Failed to retrieve user UID.");
    }

    final data = {
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'nickname': nickname,
      'phone': phone,
      'role': UserRole.admin,
      'subscriptionStatus': subscriptionStatus,
      'studentLimit': studentLimit,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _db
        .collection(FirestoreCollection.usersCollection)
        .doc(uid)
        .set(data);

    return AppUser.fromMap(uid, {
      ...data,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    });
  }

  //REGISTER METHOD FOR STUDENT
  Future<AppUser> registerStudent({
    required String email,
    required String password,
    required String fullname,
    required String nickname,
    required String phone,
    required String address,
    required String schoolName,
    required String educationLevel,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user?.uid;

    if (uid == null) {
      throw Exception("Failed to retrieve user UID.");
    }

    final data = {
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'nickname': nickname,
      'phone': phone,
      'address': address,
      'schoolName': schoolName,
      'educationLevel': educationLevel,
      'role': UserRole.student,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _db
        .collection(FirestoreCollection.usersCollection)
        .doc(uid)
        .set(data);

    return AppUser.fromMap(uid, {
      ...data,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    });
  }

  //SIGNOUT METHOD
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  Future<AppUser> getCurrentUser(String uid) async {
    final doc = await _db
        .collection(FirestoreCollection.usersCollection)
        .doc(uid)
        .get();

    if (!doc.exists || doc.data() == null) {
      throw Exception('User data not found.');
    }

    return AppUser.fromMap(uid, doc.data()!);
  }
}
