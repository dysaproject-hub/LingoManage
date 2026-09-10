import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';
import 'package:lingo_manage/features/organization/data/datasources/organization_member_datasources.dart';
import 'package:lingo_manage/features/organization/data/repository/orgnization_member_repository.dart';
import 'package:lingo_manage/features/organization/presentation/providers/organization_provider.dart';

final organizationMemberDatasources = Provider<OrganizationMemberDatasources>((
  ref,
) {
  return OrganizationMemberDatasources(ref.watch(supabaseProvider));
});

final organizationMemberRepositoryProvider =
    Provider<OrganizationMemberRepository>((ref) {
      return OrganizationMemberRepository(
        ref.watch(organizationMemberDatasources),
      );
    });

final organizationMemberControllerProvider =
    AsyncNotifierProvider<OrganizationMemberController, void>(
      OrganizationMemberController.new,
    );

class OrganizationMemberController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> joinToOrganization({
    required String organizationId,
    required String adminId,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref
          .read(organizationMemberRepositoryProvider)
          .joinToOrganization(organizationId: organizationId, adminId: adminId);

      ref.invalidate(myOrganizationProvider);
    });
  }
}
