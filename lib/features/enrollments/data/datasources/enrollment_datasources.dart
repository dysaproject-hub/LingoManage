import 'package:flutter/widgets.dart';
import 'package:lingo_manage/core/constants/database_table_name.dart';
import 'package:lingo_manage/core/utils/exceptions/enrollments_exception.dart';
import 'package:lingo_manage/core/utils/status_enrollments_enum.dart';
import 'package:lingo_manage/features/enrollments/models/enrollment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnrollmentDatasources {
  final SupabaseClient _db;

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

    final data = {
      'student_id': studentId,
      'fullname': studentFullName,
      'phone': studentPhoneNumber,
      'education_level': studentEducationLevel,
      'school_name': studentSchoolName,
      'address': studentAddress,
      'course_id': courseId,
      'program_id': programId,
      'status': status,
      'enrolled_at': null,
    };

    final enrollmentRef = await _db
        .from(DatabaseTableName.enrollmentsCollection)
        .insert(data);

    return EnrollmentModel.fromMap(enrollmentRef['id'], data);
  }

  Future<void> deleteEnrollment({required String enrollmentId}) async {
    debugPrint("START DELETE");
    await _db
        .from(DatabaseTableName.enrollmentsCollection)
        .delete()
        .eq('id', enrollmentId);
    debugPrint("FINISH DELETE");
  }

  Future<void> updateStatusEnrollment({
    required String enrollmentId,
    required String statusEnrollment,
  }) async {
    final reference = _db.from(DatabaseTableName.enrollmentsCollection);

    return statusEnrollment == StatusEnrollments.approved.label
        ? await reference.update({
            'status': statusEnrollment,
            'enrolled_at': DateTime.now(),
          })
        : await reference.update({'status': statusEnrollment});
  }

  Future<EnrollmentModel> getEnrollmentById({
    required String enrollmentId,
  }) async {
    final doc = await _db
        .from(DatabaseTableName.enrollmentsCollection)
        .select()
        .eq('id', enrollmentId)
        .maybeSingle();

    if (doc == null) {
      throw Exception("Enrollment data doesn't found");
    }

    return EnrollmentModel.fromMap(doc['id'] as String, doc);
  }

  Future<List<EnrollmentModel>> getEnrollmentsByStudentId({
    required String studentId,
  }) async {
    final snapshot = await _db
        .from(DatabaseTableName.enrollmentsCollection)
        .select()
        .eq('student_id', studentId);

    return snapshot
        .map((doc) => EnrollmentModel.fromMap(doc['id'] as String, doc))
        .toList();
  }

  Future<List<EnrollmentModel>> getEnrollmentsByCourseIdAndStatusPending({
    required String courseId,
  }) async {
    final snapshot = await _db
        .from(DatabaseTableName.enrollmentsCollection)
        .select()
        .eq('course_id', courseId)
        .eq('status', StatusEnrollments.pending.label);

    return snapshot
        .map((doc) => EnrollmentModel.fromMap(doc['id'] as String, doc))
        .toList();
  }

  Future<EnrollmentModel?> getActiveEnrollment({
    required String studentId,
    required String courseId,
  }) async {
    final String pending = StatusEnrollments.pending.label;
    final String approved = StatusEnrollments.approved.label;

    final snapshot = await _db
        .from(DatabaseTableName.enrollmentsCollection)
        .select()
        .eq('student_id', studentId)
        .eq('course_id', courseId)
        .inFilter('status', [pending, approved]);

    if (snapshot.isEmpty) {
      return null;
    }

    final doc = snapshot.first;

    return EnrollmentModel.fromMap(doc['id'] as String, doc);
  }
}
