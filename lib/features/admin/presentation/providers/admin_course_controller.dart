// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lingo_manage/core/models/app_users.dart';
// import 'package:lingo_manage/features/admin/presentation/providers/admin_course_provider.dart';
// import 'package:lingo_manage/features/course/presentation/providers/course_provider.dart';

// class AdminCourseController extends AsyncNotifier<void> {
//   @override
//   Future<void> build() async {}

//   Future<void> addAdminToCourse({
//     required String organizationId,
//     required String adminId,
//   }) async {
//     state = const AsyncLoading();

//     state = await AsyncValue.guard(() async {
//       await ref
//           .read(adminCourseRepositoryProvider)
//           .addAdminToCourse(organizationId: organizationId, adminId: adminId);
//     });

//     ref.invalidate(myCoursesProvider);
//   }

//   Future<AppUser?> findAdminByEmail(String email) async {
//     state = const AsyncLoading();

//     AppUser? result;

//     state = await AsyncValue.guard(() async {
//       result = await ref
//           .read(adminCourseRepositoryProvider)
//           .findAdminByEmail(email: email);
//     });

//     return result;
//   }

//   Future<void> removeAdminFromCourse({
//     required String organizationId,
//     required String adminId,
//   }) async {
//     state = const AsyncLoading();

//     state = await AsyncValue.guard(() async {
//       await ref
//           .read(adminCourseRepositoryProvider)
//           .removeAdminFromCourse(organizationId: organizationId, adminId: adminId);
//     });

//     ref.invalidate(courseAdminsProvider(organizationId));
//     ref.invalidate(myCoursesProvider);
//   }
// }
