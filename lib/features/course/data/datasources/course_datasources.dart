import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingo_manage/core/constants/firestore_collections.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';

class CourseDatasources {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  CourseDatasources(this._db, this._auth);

  /// GET CURRENT USER ID
  String get _currentUserId {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      throw Exception('User belum login');
    }

    return uid;
  }

  /// GET MY COURSES
  Future<List<CourseModel>> getMyCourses() async {
    final uid = _currentUserId;

    final snapshot = await _db
        .collection(FirestoreCollection.coursesCollection)
        .where('ownerId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map(
          (doc) => CourseModel.fromMap(
            doc.id,
            doc.data(),
          ),
        )
        .toList();
  }

  /// GET COURSE BY ID
  Future<CourseModel> getCourseById(String courseId) async {
    final doc = await _db
        .collection(FirestoreCollection.coursesCollection)
        .doc(courseId)
        .get();

    if (!doc.exists || doc.data() == null) {
      throw Exception('Course tidak ditemukan');
    }

    return CourseModel.fromMap(
      doc.id,
      doc.data()!,
    );
  }

  /// ADD COURSE
  Future<CourseModel> addCourse({
    required String name,
    required String description,
  }) async {
    final uid = _currentUserId;

    // Buat reference SEKALI
    final courseRef = _db
        .collection(FirestoreCollection.coursesCollection)
        .doc();

    final data = {
      'ownerId': uid,
      'name': name,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await courseRef.set(data);

    return CourseModel.fromMap(
      courseRef.id,
      {
        ...data,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      },
    );
  }

  /// UPDATE COURSE
  Future<void> updateCourse({
    required String courseId,
    required String name,
    required String description,
  }) async {
    await _db
        .collection(FirestoreCollection.coursesCollection)
        .doc(courseId)
        .update({
          'name': name,
          'description': description,
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }

  /// DELETE COURSE
  Future<void> deleteCourse(String courseId) async {
    await _db
        .collection(FirestoreCollection.coursesCollection)
        .doc(courseId)
        .delete();
  }
}