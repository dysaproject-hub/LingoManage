import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_manage/core/constants/firestore_collections.dart';
import 'package:lingo_manage/features/enrollments/models/enrollment_model.dart';

class EnrollmentDatasources {
  final FirebaseFirestore _db;

  EnrollmentDatasources(this._db);

  Future<EnrollmentModel> addEnrollments({
    required String studentId,
    required String studentFullName,
    required String studentPhoneNumber,
    required String studentEducationLevel,
    required String studentSchoolName,
    required String studentAddress,
    required String courseId,
    required String programId,
    required String status,
  }) async {
    final enrollmentRef = _db
        .collection(FirestoreCollection.enrollmentsCollection)
        .doc();

    final data = {
      'studentId': studentId,
      'studentFullname': studentFullName,
      'studentPhoneNumber': studentPhoneNumber,
      'studentEducationLevel': studentEducationLevel,
      'studentSchoolName': studentSchoolName,
      'studentAddress': studentAddress,
      'courseId': courseId,
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

  Future<EnrollmentModel> getEnrollmentById({
    required String enrollmentId,
  }) async {
    final doc = await _db
        .collection(FirestoreCollection.enrollmentsCollection)
        .doc(enrollmentId)
        .get();

    if (!doc.exists || doc.data() == null) {
      throw Exception("Enrollment data doesn't found");
    }

    return EnrollmentModel.fromMap(doc.id, doc.data()!);
  }

  Future<List<EnrollmentModel>> getEnrollmentsByStudentId({
    required String studentId,
  }) async {
    final snapshot = await _db
        .collection(FirestoreCollection.enrollmentsCollection)
        .where('studentId', isEqualTo: studentId)
        .get();

    return snapshot.docs
        .map((doc) => EnrollmentModel.fromMap(doc.id, doc.data()))
        .toList();
  }
}
