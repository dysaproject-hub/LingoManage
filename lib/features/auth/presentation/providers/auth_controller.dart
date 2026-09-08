import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';

final authController = AsyncNotifierProvider<AuthController, AppUser?>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    final repo = ref.watch(authRepositoryProvider);

    final currentUser = repo.currentUser;

    if (currentUser == null) {
      return null;
    }

    return await repo.getCurrentUser(currentUser.id);
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final response = await ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password);

      final user = response.user;

      if (user == null) {
        return null;
      }

      return await ref.read(authRepositoryProvider).getCurrentUser(user.id);
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullname,
    String? nickname,
    String? phone,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final response = await ref
          .read(authRepositoryProvider)
          .signUp(
            email: email,
            password: password,
            fullname: fullname,
            nickname: nickname,
            phone: phone,
          );

      final user = response.user;

      if (user == null) {
        return null;
      }

      // Jika email confirmation aktif,
      // user mungkin belum memiliki session.
      final session = response.session;

      if (session == null) {
        return null;
      }

      return await ref.read(authRepositoryProvider).getCurrentUser(user.id);
    });
  }

  Future<void> signUpAsInstructor({
    required String email,
    required String password,
    required String fullname,
    String? nickname,
    String? phone,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);

      debugPrint('===== SIGN UP INSTRUCTOR START =====');

      final response = await repo.signUp(
        email: email,
        password: password,
        fullname: fullname,
        nickname: nickname,
        phone: phone,
      );

      debugPrint('SIGN UP SUCCESS');
      debugPrint('USER: ${response.user?.id}');
      debugPrint('SESSION: ${response.session != null}');

      final user = response.user;

      if (user == null) {
        throw Exception('User registration failed');
      }

      if (response.session == null) {
        debugPrint('NO SESSION AFTER SIGN UP');
        throw Exception('Session not available');
      }

      debugPrint('CALLING BECOME INSTRUCTOR...');

      await repo.becomeInstructor();

      debugPrint('BECOME INSTRUCTOR FINISHED');

      final updatedUser = await repo.getCurrentUser(user.id);

      debugPrint('ROLE AFTER RPC: ${updatedUser?.role}');

      return updatedUser;
    });
  }

  Future<void> resendVerificationEmail(String email) async {
    await ref.read(authRepositoryProvider).resendVerificationEmail(email);
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();

    state = const AsyncData(null);
  }
}
