import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/core/utils/education_level_enum.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';

final authController = AsyncNotifierProvider<AuthController, AppUser?>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    final auth = ref.watch(firebaseAuthProvider);
    final repo = ref.watch(authRepositoryProvider);

    final currentUser = auth.currentUser;

    if (currentUser == null) return null;

    try {
      return await repo.getCurrentUser(currentUser.uid);
    } catch (_) {
      return null;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password);
      return user;
    });
  }

  Future<void> registerAdmin({
    required String email,
    required String password,
    required String fullname,
    required String nickname,
    required String phone,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref
          .watch(authRepositoryProvider)
          .registerAdmin(
            email: email,
            password: password,
            fullname: fullname,
            nickname: nickname,
            phone: phone,
          );
      return user;
    });
  }

  Future<void> registerStudent({
    required String email,
    required String password,
    required String fullname,
    required String nickname,
    required String phone,
    required String address,
    required String schoolName,
    required EducationLevel educationalLevel,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref
          .watch(authRepositoryProvider)
          .registerStudent(
            email: email,
            password: password,
            fullname: fullname,
            nickname: nickname,
            phone: phone,
            address: address,
            schoolName: schoolName,
            educationalLevel: educationalLevel,
          );
      return user;
    });
  }

  Future<void> signOut() async {
    await ref.watch(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }
}
