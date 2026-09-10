import 'package:lingo_manage/features/organization/data/datasources/organization_datasources.dart';
import 'package:lingo_manage/features/organization/models/organization_model.dart';

class OrganizationRepository {
  final OrganizationDatasources _datasources;

  OrganizationRepository(this._datasources);

  Future<OrganizationModel?> getByOwnerId(String ownerId) {
    return _datasources.getByOwnerId(ownerId);
  }

  Future<OrganizationModel> save({
    required String ownerId,
    required String name,
    required String bankName,
    required String accountNumber,
    required String accountName,
    String? qrisUrl,
    String? paymentNotes,
  }) {
    return _datasources.save(
      ownerId: ownerId,
      name: name,
      bankName: bankName,
      accountNumber: accountNumber,
      accountName: accountName,
      qrisUrl: qrisUrl,
      paymentNotes: paymentNotes,
    );
  }
}
