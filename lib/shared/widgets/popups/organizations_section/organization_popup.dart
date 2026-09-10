import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/features/organization/presentation/providers/organization_member_provider.dart';
import 'package:lingo_manage/shared/widgets/buttons/button_widget.dart';
import 'package:lingo_manage/shared/widgets/text/text_field_widget.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class OrganizationPopup {
  static void showDialogJoinOrganization({
    required BuildContext context,
    required String adminId,
    // required CourseModel courseData,
    required WidgetRef ref,
  }) {
    final TextEditingController organizationIdController =
        TextEditingController();

    final formKey = GlobalKey<FormState>();

    final notifier = ref.read(organizationMemberControllerProvider.notifier);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.lightText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: textBaloo2("Join an Organization", fontSize: 24),

          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.6,
            ),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),
                    textFieldWidget(
                      labelText: "Organization Id",
                      controller: organizationIdController,
                      textFieldType: TextFieldType.outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Organization Id is required!";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          actions: [
            Button(
              text: "Cancel",
              textColor: AppColors.black,
              bgColor: AppColors.lightText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              borderRadius: BorderRadius.circular(10),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Button(
              text: "Join",
              textColor: AppColors.lightText,
              bgColor: AppColors.accent,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              borderRadius: BorderRadius.circular(10),
              onPressed: () async {
                await notifier.joinToOrganization(
                  organizationId: organizationIdController.text.trim(),
                  adminId: adminId,
                );

                if (!context.mounted) return;

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
