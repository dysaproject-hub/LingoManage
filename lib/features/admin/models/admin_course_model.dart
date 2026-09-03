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
      courseId: data['course_id'] ?? '',
      adminId: data['admin_id'] ?? '',
      role: data['role'] ?? 'admin',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'course_id': courseId,
      'admin_id': adminId,
      'role': role,
    };
  }
}