import 'package:lingo_manage/core/constants/database_table_name.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDatasources {
  final SupabaseClient _client;

  UserDatasources(this._client);

  Future<AppUser> getDataUser(String uid) async {
    final docSnapshot = await _client
        .from(DatabaseTableName.usersCollection)
        .select()
        .eq('id', uid)
        .maybeSingle();

    if (docSnapshot == null) {
      throw Exception("User data not found.");
    }

    return AppUser.fromMap(uid, docSnapshot);
  }

  Future<void> updateDataUser({
    required String uid,
    String? fullname,
    String? nickname,
    String? phone,
  }) async {
    final Map<String, dynamic> data = {};

    if (fullname != null) {
      data["fullname"] = fullname;
    }

    if (nickname != null) {
      data["nickname"] = nickname;
    }

    if (phone != null) {
      data["phone"] = phone;
    }

    if (data.isEmpty) return;

    await _client
        .from(DatabaseTableName.usersCollection)
        .update(data)
        .eq('id', uid);
  }
}
