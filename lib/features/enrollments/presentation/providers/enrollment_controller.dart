import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/features/enrollments/presentation/providers/enrollment_provider.dart';

class EnrollmentController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addEnrollment({
    required String courseId,
    required String studentId,
    required String programId,
    required String status,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .watch(enrollmentRepositoryProvider)
          .addEnrollment(
            courseId: courseId,
            studentId: studentId,
            programId: programId,
            status: status,
          );
    });
  }
}
