import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/features/admin/data/datasources/admin_course_datasources.dart';
import 'package:lingo_manage/features/admin/data/repository/admin_course_repository.dart';
import 'package:lingo_manage/features/admin/presentation/providers/admin_course_controller.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';

final adminCourseDatasourcesProvider = Provider((ref) {
  final db = ref.watch(firebaseFirestoreProvider);
  return AdminCourseDatasources(db);
});

final adminCourseRepositoryProvider = Provider((ref) {
  final datasource = ref.watch(adminCourseDatasourcesProvider);
  return AdminCourseRepository(datasource);
});

final adminCourseControllerProvider =
    AsyncNotifierProvider<AdminCourseController, void>(
      AdminCourseController.new,
    );

final courseAdminsProvider =
    FutureProvider.family<List<AppUser>, String>((ref, courseId) async {
  return ref
      .read(adminCourseRepositoryProvider)
      .getCourseAdmins(
        courseId: courseId,
      );
});