import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_manage/core/constants/firestore_collections.dart';
import 'package:lingo_manage/core/utils/exceptions/enrollments_exception.dart';
import 'package:lingo_manage/core/utils/status_enrollments_enum.dart';
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
    final existingEnrollment = await getActiveEnrollment(
      studentId: studentId,
      courseId: courseId,
    );

    if (existingEnrollment != null) {
      throw EnrollmentException.alreadyExists();
    }

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

  Future<void> deleteEnrollment({required String enrollmentId}) async {
    await _db
        .collection(FirestoreCollection.enrollmentsCollection)
        .doc(enrollmentId)
        .delete();
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

  Future<EnrollmentModel?> getActiveEnrollment({
    required String studentId,
    required String courseId,
  }) async {
    final String pending = StatusEnrollments.pending.label;
    final String approved = StatusEnrollments.approved.label;

    final snapshot = await _db
        .collection(FirestoreCollection.enrollmentsCollection)
        .where('studentId', isEqualTo: studentId)
        .where('courseId', isEqualTo: courseId)
        .where('status', whereIn: [pending, approved])
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc = snapshot.docs.first;

    return EnrollmentModel.fromMap(doc.id, doc.data());
  }
}
