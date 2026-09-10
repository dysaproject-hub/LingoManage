import 'package:flutter/cupertino.dart';
import 'package:lingo_manage/core/constants/database_table_name.dart';
import 'package:lingo_manage/features/organization/models/organization_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrganizationDatasources {
  final SupabaseClient _client;

  OrganizationDatasources(this._client);

  Future<OrganizationModel?> getByOwnerId(String ownerId) async {
    try {
      final doc = await _client
          .from(DatabaseTableName.organizationsCollection)
          .select()
          .eq('owner_id', ownerId)
          .maybeSingle();

      if (doc == null) {
        return null;
      }

      return OrganizationModel.fromMap(doc);
    } catch (e) {
      debugPrint("$e");
    }

    return null;
  }

  Future<OrganizationModel> save({
    required String ownerId,
    required String name,
    required String bankName,
    required String accountNumber,
    required String accountName,
    String? qrisUrl,
    String? paymentNotes,
  }) async {
    try {
      final payload = {
        'name': name.trim(),
        'bank_name': bankName.trim(),
        'account_number': accountNumber.trim(),
        'account_name': accountName.trim(),
        'qris_url': qrisUrl?.trim().isEmpty == true ? null : qrisUrl?.trim(),
        'payment_notes': paymentNotes?.trim().isEmpty == true
            ? null
            : paymentNotes?.trim(),
      };

      final existing = await getByOwnerId(ownerId);

      if (existing == null) {
        final inserted = await _client
            .from(DatabaseTableName.organizationsCollection)
            .insert({...payload, 'owner_id': ownerId})
            .select()
            .single();

        //INSERT TO ORGANIZATION MEMBER
        await _client
            .from(DatabaseTableName.organizationMemberCollection)
            .insert({
              'organization_id': inserted['id'],
              'admin_id': ownerId,
              'role': 'owner',
            });

        return OrganizationModel.fromMap(inserted);
      }

      final updated = await _client
          .from(DatabaseTableName.organizationsCollection)
          .update(payload)
          .eq('owner_id', ownerId)
          .select()
          .single();

      return OrganizationModel.fromMap(updated);
    } catch (e) {
      debugPrint("$e");
    }

    return OrganizationModel.fromMap({});
  }
}
