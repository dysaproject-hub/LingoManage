import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';
import 'package:lingo_manage/features/course/data/datasources/course_program_datasources.dart';
import 'package:lingo_manage/features/course/data/repository/course_program_repository.dart';
import 'package:lingo_manage/features/course/models/course_program_model.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_program_controller.dart';

final courseProgramDatasourcesProvider = Provider<CourseProgramDatasources>((
  ref,
) {
  final db = ref.watch(firebaseFirestoreProvider);
  return CourseProgramDatasources(db);
});

final courseProgramRepositoryProvider = Provider<CourseProgramRepository>((
  ref,
) {
  final datasources = ref.watch(courseProgramDatasourcesProvider);
  return CourseProgramRepository(datasources);
});

final courseProgramControllerProvider =
    AsyncNotifierProvider<CourseProgramController, void>(
      CourseProgramController.new,
    );

final getAllCourseProgramProvider = FutureProvider.family<List<CourseProgramModel>, String>((ref, courseId) {
  final repo = ref.watch(courseProgramRepositoryProvider);
  return repo.getAllCourseProgram(courseId: courseId);
});
