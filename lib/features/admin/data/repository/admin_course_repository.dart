// import 'package:lingo_manage/core/models/app_users.dart';
// import 'package:lingo_manage/features/admin/data/datasources/admin_course_datasources.dart';

// class AdminCourseRepository {
//   final AdminCourseDatasources _datasources;

//   AdminCourseRepository(this._datasources);

//   Future<void> addAdminToCourse({
//     required String organizationId,
//     required String adminId,
//   }) async {
//     await _datasources.addAdminToCourse(organizationId: organizationId, adminId: adminId);
//   }

//   Future<AppUser?> findAdminByEmail({required String email}) async {
//     return await _datasources.findAdminByEmail(email);
//   }

//   Future<List<AppUser>> getCourseAdmins({required String organizationId}) async {
//     return await _datasources.getCourseAdmins(organizationId: organizationId);
//   }

//   Future<void> removeAdminFromCourse({
//     required String organizationId,
//     required String adminId,
//   }) async {
//     return await _datasources.removeAdminFromCourse(
//       organizationId: organizationId,
//       adminId: adminId,
//     );
//   }
// }
