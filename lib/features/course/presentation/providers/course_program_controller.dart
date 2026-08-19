import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_program_provider.dart';

class CourseProgramController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addCourseProgram({
    required String courseId,
    required String name,
    required String? description,

    required int registrationFee,
    required int monthlyFee,

    required bool isActive,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .watch(courseProgramRepositoryProvider)
          .addProgram(
            courseId: courseId,
            name: name,
            description: description,
            registrationFee: registrationFee,
            monthlyFee: monthlyFee,
            isActive: isActive,
          );
    });
  }
}
