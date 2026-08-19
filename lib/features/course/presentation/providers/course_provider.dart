import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/features/course/data/datasources/course_datasources.dart';
import 'package:lingo_manage/features/course/data/repository/course_repository.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_controller.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';

/// DATASOURCE
final courseDatasourceProvider = Provider<CourseDatasources>((ref) {
  final db = ref.watch(firebaseFirestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);

  return CourseDatasources(db, auth);
});

/// REPOSITORY
final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  final datasource = ref.watch(courseDatasourceProvider);

  return CourseRepository(datasource);
});

/// GET MY COURSES
final myCoursesProvider = FutureProvider<List<CourseModel>>((ref) async {
  final authState = ref.watch(authStateProvider);

  final user = authState.valueOrNull;

  if (user == null) {
    return [];
  }

  final repository = ref.watch(courseRepositoryProvider);

  return repository.getMyCourse();
});

/// COURSE CONTROLLER
final courseControllerProvider =
    AsyncNotifierProvider<CourseController, void>(
  CourseController.new,
);

/// GET COURSE CONTROLLER
final getCourseControllerProvider = FutureProvider<List<CourseModel>>((ref) async {
  final authState = ref.watch(authStateProvider);

  final user = authState.valueOrNull;

  if (user == null) {
    return [];
  }

  final repository = ref.watch(courseRepositoryProvider);

  return repository.getAllCourses();
});

final courseDetailProvider =
    FutureProvider.family<CourseModel, String>((ref, courseId) async {
  return ref
      .read(courseRepositoryProvider)
      .getCourseById(courseId: courseId);
});