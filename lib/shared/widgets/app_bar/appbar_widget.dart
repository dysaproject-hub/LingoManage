import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/core/routes/routes.dart';
import 'package:lingo_manage/features/organization/models/organization_model.dart';
import 'package:lingo_manage/shared/widgets/buttons/button_widget.dart';
import 'package:lingo_manage/shared/widgets/loadings/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class AppbarWidget extends StatelessWidget {
  final AsyncValue<AppUser> userDataProvider;
  final AsyncValue<OrganizationModel?>? orgAsync;
  const AppbarWidget({
    super.key,
    required this.userDataProvider,
    this.orgAsync,
  });

  @override
  Widget build(BuildContext context) {
    final displayName =
        userDataProvider.valueOrNull?.nickname?.isNotEmpty == true
        ? userDataProvider.value!.nickname!
        : userDataProvider.valueOrNull?.fullname ?? 'Instruktur';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: textBaloo2(
                'Halo, $displayName',
                fontSize: 26,
                fontWeight: FontWeight.w800,
                maxlines: 2,
              ),
            ),
            SizedBox(width: 40),

            CustomIconButton(
              boxColor: AppColors.success,
              iconColor: AppColors.lightText,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.profileUserPage);
              },
              iconData: Icons.person,
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),
        const SizedBox(height: 8),
        orgAsync == null
            ? SizedBox.shrink()
            : orgAsync!.when(
                data: (org) {
                  return textPoppins(
                    org?.name ?? 'Organisasi',
                    fontSize: 14,
                    color: AppColors.mutedText,
                  );
                },
                loading: () => const Center(child: LoadingWidget()),
                error: (e, _) => textPoppins('Organisasi'),
              ),
      ],
    );
  }
}
