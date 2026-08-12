import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_manage/core/constants/firestore_collections.dart';
import 'package:lingo_manage/core/constants/user_role.dart';
import 'package:lingo_manage/core/models/app_users.dart';

class AdminCourseDatasources {
  final FirebaseFirestore _db;

  AdminCourseDatasources(this._db);

  Future<void> addAdminToCourse({
    required String courseId,
    required String adminId,
  }) async {
    await _db.collection(FirestoreCollection.courseAdminsCollection).add({
      'courseId': courseId,
      'adminId': adminId,
      'role': 'admin',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<AppUser?> findAdminByEmail(String email) async {
  final snapshot = await _db
      .collection(FirestoreCollection.usersCollection)
      .where('email', isEqualTo: email)
      .where('role', isEqualTo: UserRole.admin)
      .limit(1)
      .get();

  if (snapshot.docs.isEmpty) {
    return null;
  }

  final doc = snapshot.docs.first;

  return AppUser.fromMap(
    doc.id,
    doc.data(),
  );
}
}
