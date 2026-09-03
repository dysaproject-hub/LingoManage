import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/providers/app_users_provider.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_program_provider.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_provider.dart';
import 'package:lingo_manage/features/enrollments/models/enrollment_model.dart';
import 'package:lingo_manage/features/enrollments/presentation/providers/enrollment_provider.dart';
import 'package:lingo_manage/features/student/data/datasources/student_course_datasources.dart';
import 'package:lingo_manage/features/student/data/repository/student_course_repository.dart';

final studentCourseDataSourcesProvider = Provider<StudentCourseDatasources>((
  ref,
) {
  final client = ref.watch(supabaseProvider);

  return StudentCourseDatasources(client);
});

final studentCourseRepositoryProvider = Provider<StudentCourseRepository>((
  ref,
) {
  final enrollmentDatasources = ref.watch(enrollmentDatasourcesProvider);
  final courseDatasources = ref.watch(courseDatasourceProvider);
  final programDatasources = ref.watch(courseProgramDatasourcesProvider);
  final studentCourseDatasources = ref.watch(studentCourseDataSourcesProvider);
  return StudentCourseRepository(
    enrollmentDatasources,
    courseDatasources,
    programDatasources,
    studentCourseDatasources,
  );
});

final getStudentCourseProvider = FutureProvider((ref) async {
  final userData = await ref.watch(appUserControllerProvider.future);
  return ref
      .read(studentCourseRepositoryProvider)
      .getStudentCourseData(studentId: userData.uid);
});

final approvedStudentByCourseProvider =
    FutureProvider.family<List<EnrollmentModel>, String>((ref, courseId) {
  return ref
      .read(studentCourseRepositoryProvider)
      .approvedStudentByCourseId(
        courseId: courseId,
      );
});