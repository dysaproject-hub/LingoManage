class OrganizationModel {
  final String id;
  final String name;
  final String ownerId;
  final String? bankName;
  final String? accountNumber;
  final String? accountName;
  final String? qrisUrl;
  final String? paymentNotes;
  final DateTime? createdAt;

  OrganizationModel({
    required this.id,
    required this.name,
    required this.ownerId,
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.qrisUrl,
    this.paymentNotes,
    this.createdAt,
  });

  factory OrganizationModel.fromMap(Map<String, dynamic> data) {
    return OrganizationModel(
      id: data['id'] as String,
      name: data['name'] as String? ?? '',
      ownerId: data['owner_id'] as String,
      bankName: data['bank_name'] as String?,
      accountNumber: data['account_number'] as String?,
      accountName: data['account_name'] as String?,
      qrisUrl: data['qris_url'] as String?,
      paymentNotes: data['payment_notes'] as String?,
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'] as String)
          : null,
    );
  }

  /// Onboarding wajib jika rekening pembayaran belum lengkap.
  static bool needsOnboarding(OrganizationModel? org) {
    if (org == null) return true;

    final nameOk = org.name.trim().isNotEmpty;
    final bankOk = (org.bankName ?? '').trim().isNotEmpty;
    final accountOk = (org.accountNumber ?? '').trim().isNotEmpty;
    final accountNameOk = (org.accountName ?? '').trim().isNotEmpty;

    return !nameOk || !bankOk || !accountOk || !accountNameOk;
  }
}
