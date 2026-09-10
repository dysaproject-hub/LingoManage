import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/providers/app_users_provider.dart';
import 'package:lingo_manage/core/utils/exceptions/app_error_mapper.dart';
import 'package:lingo_manage/features/organization/models/organization_model.dart';
import 'package:lingo_manage/features/organization/presentation/providers/organization_provider.dart';
import 'package:lingo_manage/shared/widgets/buttons/button_widget.dart';
import 'package:lingo_manage/shared/widgets/errors/error_widget.dart';
import 'package:lingo_manage/shared/widgets/loadings/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/text/text_field_widget.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class OrganizationSettingsPage extends ConsumerStatefulWidget {
  const OrganizationSettingsPage({super.key});

  @override
  ConsumerState<OrganizationSettingsPage> createState() =>
      _OrganizationSettingsPageState();
}

class _OrganizationSettingsPageState
    extends ConsumerState<OrganizationSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _qrisUrlController = TextEditingController();
  final _paymentNotesController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    _qrisUrlController.dispose();
    _paymentNotesController.dispose();
    super.dispose();
  }

  void _fillFromOrg(OrganizationModel org) {
    if (_initialized) return;
    _nameController.text = org.name;
    _bankNameController.text = org.bankName ?? '';
    _accountNumberController.text = org.accountNumber ?? '';
    _accountNameController.text = org.accountName ?? '';
    _qrisUrlController.text = org.qrisUrl ?? '';
    _paymentNotesController.text = org.paymentNotes ?? '';
    _initialized = true;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(appUserControllerProvider).valueOrNull;
    if (user == null) return;

    await ref.read(organizationControllerProvider.notifier).save(
      ownerId: user.uid,
      name: _nameController.text,
      bankName: _bankNameController.text,
      accountNumber: _accountNumberController.text,
      accountName: _accountNameController.text,
      qrisUrl: _qrisUrlController.text,
      paymentNotes: _paymentNotesController.text,
    );

    if (!mounted) return;

    if (ref.read(organizationControllerProvider).hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan perubahan')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Organisasi berhasil disimpan')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final orgAsync = ref.watch(myOrganizationProvider);
    final saveState = ref.watch(organizationControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.lightText,
      appBar: AppBar(
        backgroundColor: AppColors.lightText,
        elevation: 0,
        title: textPoppins(
          'Pengaturan Organisasi',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: orgAsync.when(
        loading: () => const Center(child: LoadingWidget()),
        error: (e, _) => CustomErrorWidget(
          message: ErrorMapper.map(e).message,
          title: 'Gagal memuat data',
          onRetry: () => ref.invalidate(myOrganizationProvider),
        ),
        data: (org) {
          if (org != null) {
            _fillFromOrg(org);
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textPoppins(
                      'Rekening ini ditampilkan ke calon siswa saat mendaftar.',
                      fontSize: 12,
                      color: AppColors.mutedText,
                    ),
                    const SizedBox(height: 20),
                    _field('Nama Organisasi', _nameController, required: true),
                    _field('Nama Bank', _bankNameController, required: true),
                    _field(
                      'Nomor Rekening',
                      _accountNumberController,
                      required: true,
                      keyboard: TextInputType.number,
                    ),
                    _field(
                      'Atas Nama Rekening',
                      _accountNameController,
                      required: true,
                    ),
                    _field('URL QRIS (opsional)', _qrisUrlController),
                    _field(
                      'Catatan Pembayaran (opsional)',
                      _paymentNotesController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: saveState.isLoading
                          ? const Center(child: LoadingWidget())
                          : Button(
                              text: 'Simpan',
                              textColor: AppColors.lightText,
                              bgColor: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              borderRadius: BorderRadius.circular(12),
                              onPressed: _save,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    bool required = false,
    TextInputType? keyboard,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textPoppins(label, fontSize: 12, fontWeight: FontWeight.w600),
          const SizedBox(height: 6),
          textFieldWidget(
            labelText: label,
            controller: controller,
            keyboardType: keyboard,
            maxLines: maxLines,
            validator: required
                ? (v) => v == null || v.trim().isEmpty ? 'Wajib diisi' : null
                : null,
          ),
        ],
      ),
    );
  }
}
