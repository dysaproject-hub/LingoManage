import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:lingo_manage/features/course/models/course_program_model.dart';
import 'package:lingo_manage/features/enrollments/models/enrollment_model.dart';

class StudentCourseData {
  final EnrollmentModel enrollment;
  final CourseModel course;
  final CourseProgramModel program;

  StudentCourseData({
    required this.course,
    required this.enrollment,
    required this.program,
  });

  factory StudentCourseData.fromMap(Map<String, dynamic> json) {
    return StudentCourseData(
      course: json['courseModel'],
      enrollment: json["enrollmentModel"],
      program: json["courseProgramModel"],
    );
  }
}
