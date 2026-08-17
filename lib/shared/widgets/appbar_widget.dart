import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/core/routes/routes.dart';
import 'package:lingo_manage/shared/widgets/button_widget.dart';
import 'package:lingo_manage/shared/widgets/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class AppbarWidget extends StatelessWidget {
  final AsyncValue<AppUser> userDataProvider;
  const AppbarWidget({super.key, required this.userDataProvider});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        userDataProvider.when(
          data: (data) {
            return Expanded(
              child: textBaloo2(
                data.nickname == null
                    ? "Hi, ${data.fullname}"
                    : "Hi, ${data.nickname}",
                fontSize: 32,
                fontWeight: FontWeight.w800,
                maxlines: 2,
                textOverFlow: TextOverflow.ellipsis
              ),
            );
          },
          error: (error, s) => textBaloo2(
            "Hi, Nice to see you!",
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
          loading: () => LoadingWidget(),
        ),

        SizedBox(width: 40,),

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
    );
  }
}
