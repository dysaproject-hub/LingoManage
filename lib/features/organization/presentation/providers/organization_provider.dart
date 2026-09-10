import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/user_role.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';
import 'package:lingo_manage/features/organization/data/datasources/organization_datasources.dart';
import 'package:lingo_manage/features/organization/data/repository/organization_repository.dart';
import 'package:lingo_manage/features/organization/models/organization_model.dart';

final organizationDatasourcesProvider = Provider<OrganizationDatasources>((ref) {
  return OrganizationDatasources(ref.watch(supabaseProvider));
});

final organizationRepositoryProvider = Provider<OrganizationRepository>((ref) {
  return OrganizationRepository(ref.watch(organizationDatasourcesProvider));
});

final myOrganizationProvider = FutureProvider<OrganizationModel?>((ref) async {
  final user = await ref.watch(authStateProvider.future);

  if (user == null || user.role != UserRole.instructor) {
    return null;
  }

  return ref
      .read(organizationRepositoryProvider)
      .getByOwnerId(user.uid);
});

final organizationControllerProvider =
    AsyncNotifierProvider<OrganizationController, void>(
      OrganizationController.new,
    );

class OrganizationController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> save({
    required String ownerId,
    required String name,
    required String bankName,
    required String accountNumber,
    required String accountName,
    String? qrisUrl,
    String? paymentNotes,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(organizationRepositoryProvider).save(
        ownerId: ownerId,
        name: name,
        bankName: bankName,
        accountNumber: accountNumber,
        accountName: accountName,
        qrisUrl: qrisUrl,
        paymentNotes: paymentNotes,
      );

      ref.invalidate(myOrganizationProvider);
    });
  }
}
