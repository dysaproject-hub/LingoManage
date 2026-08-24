import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_manage/core/constants/firestore_collections.dart';
import 'package:lingo_manage/features/enrollments/models/enrollment_model.dart';

class EnrollmentDatasources {
  final FirebaseFirestore _db;

  EnrollmentDatasources(this._db);

  Future<EnrollmentModel> addEnrollments({
    required String courseId,
    required String studentId,
    required String programId,
    required String status,
  }) async {
    final enrollmentRef = _db
        .collection(FirestoreCollection.enrollmentsCollection)
        .doc();

    final data = {
      'courseId': courseId,
      'studentId': studentId,
      'programId': programId,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await enrollmentRef.set(data);

    return EnrollmentModel.fromMap(enrollmentRef.id, {
      ...data,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    });
  }
}
