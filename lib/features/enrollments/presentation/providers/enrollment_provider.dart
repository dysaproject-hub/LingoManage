import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';
import 'package:lingo_manage/features/enrollments/data/datasources/enrollment_datasources.dart';
import 'package:lingo_manage/features/enrollments/data/repository/enrollment_repository.dart';
import 'package:lingo_manage/features/enrollments/presentation/providers/enrollment_controller.dart';

final enrollmentDatasourcesProvider = Provider<EnrollmentDatasources>((ref) {
  final db = ref.watch(firebaseFirestoreProvider);

  return EnrollmentDatasources(db);
});

final enrollmentRepositoryProvider = Provider<EnrollmentRepository>((ref) {
  final datasources = ref.watch(enrollmentDatasourcesProvider);
  return EnrollmentRepository(datasources);
});

final enrollmentControllerProvider =
    AsyncNotifierProvider<EnrollmentController, void>(EnrollmentController.new);
