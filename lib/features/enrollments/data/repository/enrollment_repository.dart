import 'package:lingo_manage/features/enrollments/data/datasources/enrollment_datasources.dart';
import 'package:lingo_manage/features/enrollments/models/enrollment_model.dart';

class EnrollmentRepository {
  final EnrollmentDatasources _datasources;

  EnrollmentRepository(this._datasources);

  Future<EnrollmentModel> addEnrollment({
    required String courseId,
    required String studentId,
    required String programId,
    required String status,
  }) async {
    return await _datasources.addEnrollments(
      courseId: courseId,
      studentId: studentId,
      programId: programId,
      status: status,
    );
  }
}
