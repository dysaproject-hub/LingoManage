import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/features/admin/data/datasources/admin_course_datasources.dart';

class AdminCourseRepository {
  final AdminCourseDatasources _datasources;

  AdminCourseRepository(this._datasources);

  Future<void> addAdminToCourse({
    required String courseId,
    required String adminId,
  }) async {
    await _datasources.addAdminToCourse(courseId: courseId, adminId: adminId);
  }

  Future<AppUser?> findAdminByEmail({required String email}) async {
    return await _datasources.findAdminByEmail(email);
  }
}
