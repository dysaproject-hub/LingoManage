import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/providers/app_users_provider.dart';
import 'package:lingo_manage/features/organization/models/organization_model.dart';
import 'package:lingo_manage/features/organization/presentation/providers/organization_provider.dart';
import 'package:lingo_manage/shared/widgets/buttons/button_widget.dart';
import 'package:lingo_manage/shared/widgets/loadings/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/popups/organizations_section/organization_popup.dart';
import 'package:lingo_manage/shared/widgets/text/text_field_widget.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class OrganizationOnboardingPage extends ConsumerStatefulWidget {
  final OrganizationModel? existing;

  const OrganizationOnboardingPage({super.key, this.existing});

  @override
  ConsumerState<OrganizationOnboardingPage> createState() =>
      _OrganizationOnboardingPageState();
}

class _OrganizationOnboardingPageState
    extends ConsumerState<OrganizationOnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _qrisUrlController = TextEditingController();
  final _paymentNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final org = widget.existing;
    if (org != null) {
      _nameController.text = org.name;
      _bankNameController.text = org.bankName ?? '';
      _accountNumberController.text = org.accountNumber ?? '';
      _accountNameController.text = org.accountName ?? '';
      _qrisUrlController.text = org.qrisUrl ?? '';
      _paymentNotesController.text = org.paymentNotes ?? '';
    }
  }

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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(appUserControllerProvider).valueOrNull;
    if (user == null) return;

    try {
      await ref
          .read(organizationControllerProvider.notifier)
          .save(
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
          const SnackBar(content: Text('Gagal menyimpan organisasi')),
        );
        return;
      }

      ref.invalidate(myOrganizationProvider);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final saveState = ref.watch(organizationControllerProvider);
    final user = ref.watch(appUserControllerProvider);

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: AppColors.lightText,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  textBaloo2(
                    'Setup Organisasi',
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                  const SizedBox(height: 8),
                  textPoppins(
                    'Lengkapi profil organisasi dan rekening penerima pembayaran siswa.',
                    fontSize: 13,
                    color: AppColors.mutedText,
                  ),
                  const SizedBox(height: 16),
                  user.when(data: (data) {
                    return SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Button(
                      text: "Join Using Organization Id",
                      textColor: AppColors.lightText,
                      bgColor: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      borderRadius: BorderRadius.circular(10),
                      onPressed: () {

                        OrganizationPopup.showDialogJoinOrganization(
                          context: context,
                          ref: ref,
                          adminId: data.uid,
                        );
                      },
                    ),
                  );
                  }, error: (e, s) {
                    return textPoppins("Fitur join menggunakan ID organisasi dalam gangguan, silahkan coba lagi nanti atau setup organisasi anda sendiri");
                  }, loading: () => LoadingWidget(size: 16,)),
                  const SizedBox(height: 28),
                  _label('Nama Organisasi'),
                  const SizedBox(height: 6),
                  textFieldWidget(
                    labelText: 'Contoh: Lingo English Course',
                    controller: _nameController,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  _label('Nama Bank'),
                  const SizedBox(height: 6),
                  textFieldWidget(
                    labelText: 'Contoh: BCA',
                    controller: _bankNameController,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  _label('Nomor Rekening'),
                  const SizedBox(height: 6),
                  textFieldWidget(
                    labelText: 'Nomor rekening tujuan',
                    controller: _accountNumberController,
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  _label('Atas Nama Rekening'),
                  const SizedBox(height: 6),
                  textFieldWidget(
                    labelText: 'Nama pemilik rekening',
                    controller: _accountNameController,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  _label('URL QRIS (opsional)'),
                  const SizedBox(height: 6),
                  textFieldWidget(
                    labelText: 'Link gambar QRIS',
                    controller: _qrisUrlController,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),
                  _label('Catatan Pembayaran (opsional)'),
                  const SizedBox(height: 6),
                  textFieldWidget(
                    labelText: 'Instruksi tambahan untuk siswa',
                    controller: _paymentNotesController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: saveState.isLoading
                        ? const Center(child: LoadingWidget())
                        : Button(
                            text: 'Simpan & Lanjut',
                            textColor: AppColors.lightText,
                            bgColor: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            borderRadius: BorderRadius.circular(12),
                            onPressed: _submit,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return textPoppins(text, fontSize: 12, fontWeight: FontWeight.w600);
  }
}
