import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/utils/media_query_helper.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:lingo_manage/shared/widgets/button_widget.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class CardCourseWidget extends StatelessWidget {
  final Color maincolor;
  final Color gradientcolor;
  final CourseModel courseData;
  final String jumlahsiswa;
  final Color buttoncolor;
  final VoidCallback onTapEdit;
  final VoidCallback onTapRemove;
  final VoidCallback onTapCek;
  final VoidCallback onTapManageAdmin;

  const CardCourseWidget({
    super.key,
    required this.maincolor,
    required this.gradientcolor,
    required this.courseData,
    required this.jumlahsiswa,
    required this.buttoncolor,
    required this.onTapEdit,
    required this.onTapRemove,
    required this.onTapCek,
    required this.onTapManageAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: MediaQueryHelper.getScreenWidth(context),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [maincolor, gradientcolor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textBaloo2(
                      courseData.name,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightText,
                    ),
                    const SizedBox(width: 16),
                    textPoppins(
                      courseData.description ?? "-",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightText,
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                color: AppColors.lightText,
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == "edit") {
                    onTapEdit();
                  } else if (value == "delete") {
                    onTapRemove();
                  } else if (value == "manage_admin") {
                    onTapManageAdmin();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: "edit",
                    child: textPoppins(
                      "Edit",
                      color: AppColors.black,
                      fontSize: 12,
                    ),
                  ),
                  PopupMenuItem(
                    value: "delete",
                    child: textPoppins(
                      "Delete",
                      color: AppColors.black,
                      fontSize: 12,
                    ),
                  ),
                  PopupMenuItem(
                    value: "manage_admin",
                    child: textPoppins(
                      "Manage Admin",
                      color: AppColors.black,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_alt_rounded,
                    size: 18,
                    color: AppColors.lightText,
                  ),
                  const SizedBox(width: 8),
                  textPoppins(
                    "$jumlahsiswa students",
                    fontSize: 12,
                    color: AppColors.lightText,
                  ),
                ],
              ),
              Button(
                text: "Cek It Out!",
                textColor: AppColors.black.withAlpha(230),
                bgColor: buttoncolor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                borderRadius: BorderRadius.circular(10),
                onPressed: onTapCek,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
