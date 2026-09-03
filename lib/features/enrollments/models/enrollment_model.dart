import 'package:lingo_manage/core/utils/parse_date_helper.dart';

class EnrollmentModel {
  final String id;
  final String studentId;
  final String studentFullName;
  final String studentPhoneNumber;
  final String studentEducationLevel;
  final String studentSchoolName;
  final String studentAddress;
  final String courseId;
  final String programId;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? enrolledAt;

  EnrollmentModel({
    required this.id,
    required this.studentId,
    required this.studentFullName,
    required this.studentPhoneNumber,
    required this.studentEducationLevel,
    required this.studentSchoolName,
    required this.studentAddress,
    required this.courseId,
    required this.programId,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.enrolledAt,
  });

  factory EnrollmentModel.fromMap(String id, Map<String, dynamic> data) {
    return EnrollmentModel(
      id: id,
      studentId: data['student_id'],
      studentFullName: data['fullname'],
      studentPhoneNumber: data['phone'],
      studentEducationLevel: data['education_level'],
      studentSchoolName: data['school_name'],
      studentAddress: data['address'],
      courseId: data['course_id'],
      programId: data['program_id'],
      status: data['status'],
      createdAt: parseDateTime(data['created_at']),
      updatedAt: parseDateTime(data['updated_at']),
      enrolledAt: parseDateTime(data['enrolled_at']),
    );
  }
}
