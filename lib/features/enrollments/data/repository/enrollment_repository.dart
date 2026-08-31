import 'package:lingo_manage/features/enrollments/data/datasources/enrollment_datasources.dart';
import 'package:lingo_manage/features/enrollments/models/enrollment_model.dart';

class EnrollmentRepository {
  final EnrollmentDatasources _datasources;

  EnrollmentRepository(this._datasources);

  Future<EnrollmentModel> addEnrollment({
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
    return await _datasources.addEnrollments(
      studentId: studentId,
      studentFullName: studentFullName,
      studentPhoneNumber: studentPhoneNumber,
      studentEducationLevel: studentEducationLevel,
      studentSchoolName: studentSchoolName,
      studentAddress: studentAddress,
      courseId: courseId,
      programId: programId,
      status: status,
    );
  }

  Future<void> deleteEnrollment({required String enrollmentId}) async {
    await _datasources.deleteEnrollment(enrollmentId: enrollmentId);
  }

  Future<EnrollmentModel> getEnrollmentById({
    required String enrollmentId,
  }) async {
    return await _datasources.getEnrollmentById(enrollmentId: enrollmentId);
  }

  Future<List<EnrollmentModel>> getEnrollmentByStudentId({
    required String studentId,
  }) async {
    return await _datasources.getEnrollmentsByStudentId(studentId: studentId);
  }
}
