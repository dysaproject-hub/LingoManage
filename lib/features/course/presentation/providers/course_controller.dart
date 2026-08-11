import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_provider.dart';

class CourseController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// CREATE COURSE
  Future<void> addCourse({
    required String name,
    required String description,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(courseRepositoryProvider).addCourse(
            name: name,
            description: description,
          );

      ref.invalidate(myCoursesProvider);
    });
  }

  /// UPDATE COURSE
  Future<void> updateCourse({
    required String courseId,
    required String name,
    required String description,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(courseRepositoryProvider).updateCourse(
            courseId: courseId,
            name: name,
            description: description,
          );

      ref.invalidate(myCoursesProvider);
    });
  }

  /// DELETE COURSE
  Future<void> deleteCourse({
    required String courseId,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(courseRepositoryProvider).deleteCourse(
            courseId: courseId,
          );

      ref.invalidate(myCoursesProvider);
    });
  }
}