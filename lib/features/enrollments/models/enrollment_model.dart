class EnrollmentModel {
  final String id;
  final String courseId;
  final String studentId;
  final String programId;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EnrollmentModel({
    required this.id,
    required this.courseId,
    required this.studentId,
    required this.programId,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory EnrollmentModel.fromMap(String id, Map<String, dynamic> data) {
    return EnrollmentModel(
      id: id,
      courseId: data['courseId'],
      studentId: data['studentId'],
      programId: data['programId'],
      status: data['status'],
    );
  }
}
