import 'package:lingo_manage/features/course/data/datasources/course_datasources.dart';
import 'package:lingo_manage/features/course/data/datasources/course_program_datasources.dart';
import 'package:lingo_manage/features/enrollments/data/datasources/enrollment_datasources.dart';
import 'package:lingo_manage/features/enrollments/models/enrollment_model.dart';
import 'package:lingo_manage/features/student/data/datasources/student_course_datasources.dart';
import 'package:lingo_manage/features/student/models/student_course_model.dart';

class StudentCourseRepository {
  final EnrollmentDatasources _enrollmentDatasources;
  final CourseDatasources _courseDatasources;
  final CourseProgramDatasources _programDatasources;

  final StudentCourseDatasources _studentCourseDatasources;

  StudentCourseRepository(
    this._enrollmentDatasources,
    this._courseDatasources,
    this._programDatasources,
    this._studentCourseDatasources,
  );

  Future<List<StudentCourseData>> getStudentCourseData({
    required String studentId,
  }) async {
    final enrollments = await _enrollmentDatasources.getEnrollmentsByStudentId(
      studentId: studentId,
    );

    final result = <StudentCourseData>[];

    for (final enrollment in enrollments) {
      final course = await _courseDatasources.getCourseById(
        enrollment.courseId,
      );

      final programs = await _programDatasources.getProgramById(
        programId: enrollment.programId,
      );

      result.add(
        StudentCourseData(
          course: course,
          enrollment: enrollment,
          program: programs,
        ),
      );
    }

    return result;
  }

  Future<List<EnrollmentModel>> approvedStudentByCourseId({
    required String courseId,
  }) async {
    return await _studentCourseDatasources.approvedStudentByCourseId(
      courseId: courseId,
    );
  }
}
