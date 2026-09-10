import 'package:lingo_manage/features/organization/data/datasources/organization_member_datasources.dart';

class OrganizationMemberRepository {
  final OrganizationMemberDatasources _datasources;

  OrganizationMemberRepository(this._datasources);

  Future<void> joinToOrganization({
    required String organizationId,
    required String adminId,
  }) async {
    return _datasources.joinToOrganization(
      organizationId: organizationId,
      adminId: adminId,
    );
  }
}
