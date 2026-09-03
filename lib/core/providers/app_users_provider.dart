import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/data/datasources/user_datasources.dart';
import 'package:lingo_manage/core/data/repository/user_repository.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/core/providers/app_users_controller.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final appUserDatasourcesProvider = Provider<UserDatasources>((ref) {
  final SupabaseClient client = ref.watch(supabaseProvider);
  return UserDatasources(client);
});

final appUserRepositoryProvider = Provider((ref) {
  final datasources = ref.watch(appUserDatasourcesProvider);
  return UserRepository(datasources);
});

final appUserControllerProvider =
    AsyncNotifierProvider<AppUserController, AppUser>(AppUserController.new);

final profileEditProvider = StateProvider<String?>((ref) => null);

final imageProfileProvider =
    AsyncNotifierProvider<ImageProfileNotifier, String?>(
      ImageProfileNotifier.new,
    );
