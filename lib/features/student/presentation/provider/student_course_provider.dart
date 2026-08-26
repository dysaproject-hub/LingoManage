import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/providers/app_users_provider.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_program_provider.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_provider.dart';
import 'package:lingo_manage/features/enrollments/presentation/providers/enrollment_provider.dart';
import 'package:lingo_manage/features/student/data/repository/student_course_repository.dart';

final studentCourseRepositoryProvider = Provider<StudentCourseRepository>((
  ref,
) {
  final enrollmentDatasources = ref.watch(enrollmentDatasourcesProvider);
  final courseDatasources = ref.watch(courseDatasourceProvider);
  final programDatasources = ref.watch(courseProgramDatasourcesProvider);
  return StudentCourseRepository(
    enrollmentDatasources,
    courseDatasources,
    programDatasources,
  );
});

final getStudentCourseProvider = FutureProvider((ref) async {
  final userData = await ref.watch(appUserControllerProvider.future);
  return ref
      .read(studentCourseRepositoryProvider)
      .getStudentCourseData(studentId: userData.uid);
});
