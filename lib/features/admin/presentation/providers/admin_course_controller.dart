import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/features/admin/presentation/providers/admin_course_provider.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_provider.dart';

class AdminCourseController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addAdminToCourse({
    required String courseId,
    required String adminId,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref
          .read(adminCourseRepositoryProvider)
          .addAdminToCourse(courseId: courseId, adminId: adminId);
    });

    ref.invalidate(myCoursesProvider);
  }
}
