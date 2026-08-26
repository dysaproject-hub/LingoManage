import 'package:cloud_firestore/cloud_firestore.dart';

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
  });

  factory EnrollmentModel.fromMap(String id, Map<String, dynamic> data) {
    return EnrollmentModel(
      id: id,
      studentId: data['studentId'],
      studentFullName: data['studentFullname'],
      studentPhoneNumber: data['studentPhoneNumber'],
      studentEducationLevel: data['studentEducationLevel'],
      studentSchoolName: data['studentSchoolName'],
      studentAddress: data['studentAddress'],
      courseId: data['courseId'],
      programId: data['programId'],
      status: data['status'],
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : data['createdAt'] as DateTime?,

      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate()
          : data['updatedAt'] as DateTime?,
    );
  }
}
