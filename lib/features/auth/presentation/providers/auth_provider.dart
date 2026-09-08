import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/database_table_name.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/features/auth/data/datasources/auth_datasources.dart';
import 'package:lingo_manage/features/auth/data/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final authDatasourcesProvider = Provider<AuthDatasource>((ref) {
  final client = ref.watch(supabaseProvider);
  return AuthDatasource(client);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.watch(authDatasourcesProvider);
  final supabase = ref.watch(supabaseProvider);

  return AuthRepository(
    datasource,
    supabase,
  );
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  final client = Supabase.instance.client;

  return client.auth.onAuthStateChange.asyncMap((authState) async {
    final user = authState.session?.user;

    if (user == null) {
      return null;
    }

    debugPrint("Supabase user: $user");

    final doc = await client
        .from(DatabaseTableName.usersCollection)
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (doc == null) {
      return null;
    }

    debugPrint("Emit AppUser");

    return AppUser.fromMap(user.id, doc);
  });
});
