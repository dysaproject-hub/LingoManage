import 'package:flutter/cupertino.dart';
import 'package:lingo_manage/core/constants/database_table_name.dart';
import 'package:lingo_manage/core/constants/user_role.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrganizationMemberDatasources {
  final SupabaseClient _db;

  OrganizationMemberDatasources(this._db);

  Future<void> joinToOrganization({
    required String organizationId,
    required String adminId,
  }) async {
    try {
      final data = {
        'organization_id': organizationId,
        'admin_id': adminId,
        'role': UserRole.instructor,
      };

      await _db
          .from(DatabaseTableName.organizationMemberCollection)
          .insert(data);
    } catch (e) {
      debugPrint("$e");
    }
  }
}
