import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';
import 'package:lingo_manage/features/enrollments/data/datasources/enrollment_datasources.dart';
import 'package:lingo_manage/features/enrollments/data/repository/enrollment_repository.dart';
import 'package:lingo_manage/features/enrollments/models/enrollment_model.dart';
import 'package:lingo_manage/features/enrollments/presentation/providers/enrollment_controller.dart';

final enrollmentDatasourcesProvider = Provider<EnrollmentDatasources>((ref) {
  final client = ref.watch(supabaseProvider);

  return EnrollmentDatasources(client);
});

final enrollmentRepositoryProvider = Provider<EnrollmentRepository>((ref) {
  final datasources = ref.watch(enrollmentDatasourcesProvider);
  return EnrollmentRepository(datasources);
});

final enrollmentControllerProvider =
    AsyncNotifierProvider<EnrollmentController, EnrollmentModel?>(
      EnrollmentController.new,
    );

final studentEnrollmentsProvider =
    FutureProvider.family<List<EnrollmentModel>, String>((
      ref,
      studentId,
    ) async {
      return ref
          .read(enrollmentRepositoryProvider)
          .getEnrollmentByStudentId(studentId: studentId);
    });

final getEnrollmentByCourseIdAndStatusPending =
    FutureProvider.family<List<EnrollmentModel>, String>((ref, courseId) async {
      return ref
          .read(enrollmentRepositoryProvider)
          .getEnrollmentByCourseIdAndStatusPending(courseId: courseId);
    });
