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
    final existing = await _db
        .collection(FirestoreCollection.courseAdminsCollection)
        .where('courseId', isEqualTo: courseId)
        .where('adminId', isEqualTo: adminId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      throw Exception('Admin has been added in this course');
    }

    final data = {
      'courseId': courseId,
      'adminId': adminId,
      'role': UserRole.admin,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _db.collection(FirestoreCollection.courseAdminsCollection).add(data);
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

    return AppUser.fromMap(doc.id, doc.data());
  }

  Future<List<AppUser>> getCourseAdmins({required String courseId}) async {
    final snapshot = await _db
        .collection(FirestoreCollection.courseAdminsCollection)
        .where('courseId', isEqualTo: courseId)
        .get();

    final List<AppUser> admins = [];

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final adminId = data['adminId'];

      if (adminId == null) {
        continue;
      }

      final userDoc = await _db
          .collection(FirestoreCollection.usersCollection)
          .doc(adminId)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        continue;
      }

      final user = AppUser.fromMap(userDoc.id, userDoc.data()!);

      if (user.role == UserRole.admin) {
        admins.add(user);
      }
    }

    return admins;
  }

  Future<void> removeAdminFromCourse({
    required String courseId,
    required String adminId,
  }) async {
    final snapshot = await _db
        .collection(FirestoreCollection.courseAdminsCollection)
        .where('courseId', isEqualTo: courseId)
        .where('adminId', isEqualTo: adminId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception('Admin tidak ditemukan di course ini.');
    }

    final doc = snapshot.docs.first;

    await doc.reference.delete();
  }
}
