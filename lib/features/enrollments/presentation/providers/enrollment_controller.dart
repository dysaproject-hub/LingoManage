import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/features/enrollments/models/enrollment_model.dart';
import 'package:lingo_manage/features/enrollments/presentation/providers/enrollment_provider.dart';

class EnrollmentController extends AsyncNotifier<EnrollmentModel?> {
  @override
  Future<EnrollmentModel?> build() async {
    return null;
  }

  Future<EnrollmentModel?> addEnrollment({
    required String studentId,
    required String studentFullName,
    required String studentPhoneNumber,
    required String studentEducationLevel,
    required String studentSchoolName,
    required String studentAddress,
    required String courseId,
    required String programId,
    required String status,
  }) async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      return await ref
          .read(enrollmentRepositoryProvider)
          .addEnrollment(
            studentId: studentId,
            studentFullName: studentFullName,
            studentPhoneNumber: studentPhoneNumber,
            studentEducationLevel: studentEducationLevel,
            studentSchoolName: studentSchoolName,
            studentAddress: studentAddress,
            courseId: courseId,
            programId: programId,
            status: status,
          );
    });

    state = result;

    return result.value;
  }

  Future<EnrollmentModel?> getEnrollmentById({
    required String enrollmentId,
  }) async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      return await ref
          .read(enrollmentRepositoryProvider)
          .getEnrollmentById(enrollmentId: enrollmentId);
    });

    state = result;

    return result.value;
  }

  Future<void> deleteEnrollment({required String enrollmentId}) async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      await ref
          .read(enrollmentRepositoryProvider)
          .deleteEnrollment(enrollmentId: enrollmentId);
    });

    state = result;
  }
}
