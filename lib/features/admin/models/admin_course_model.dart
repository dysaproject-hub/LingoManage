class AdminCourseModel {
  final String id;
  final String courseId;
  final String adminId;
  final String role;

  AdminCourseModel({
    required this.id,
    required this.courseId,
    required this.adminId,
    required this.role,
  });

  factory AdminCourseModel.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return AdminCourseModel(
      id: id,
      courseId: data['courseId'] ?? '',
      adminId: data['adminId'] ?? '',
      role: data['role'] ?? 'admin',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'adminId': adminId,
      'role': role,
    };
  }
}