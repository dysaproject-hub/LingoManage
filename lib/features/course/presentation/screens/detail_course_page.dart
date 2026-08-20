import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/utils/currency_formatters.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:lingo_manage/features/course/models/course_program_model.dart';
import 'package:lingo_manage/features/course/presentation/widget/card_info_widget.dart';
import 'package:lingo_manage/shared/widgets/button_widget.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class ProgramDetailPage extends ConsumerStatefulWidget {
  final CourseProgramModel program;
  final CourseModel course;

  const ProgramDetailPage({
    super.key,
    required this.program,
    required this.course,
  });

  @override
  ConsumerState<ProgramDetailPage> createState() => _ProgramDetailPageState();
}

class _ProgramDetailPageState extends ConsumerState<ProgramDetailPage> {

  @override
  Widget build(BuildContext context) {
    final program = widget.program;

    return Scaffold(
      backgroundColor: AppColors.lightText,

      appBar: AppBar(
        backgroundColor: AppColors.lightText,
        elevation: 0,
        title: textPoppins(
          "Program Detail",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: textBaloo2(
                              program.name,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.lightText,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      textPoppins(
                        program.description ?? "No description available.",
                        fontSize: 13,
                        color: AppColors.lightText.withValues(alpha: 0.85),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                textBaloo2(
                  "Program Information",
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),

                const SizedBox(height: 12),

                InfoCard(
                  icon: Icons.school_outlined,
                  title: "Program Name",
                  value: program.name,
                ),

                const SizedBox(height: 10),

                InfoCard(
                  icon: Icons.description_outlined,
                  title: "Description",
                  value: program.description ?? "No description available.",
                ),

                const SizedBox(height: 10),

                InfoCard(
                  icon: Icons.payments_outlined,
                  title: "Registration Fee",
                  value: formatRupiah(program.registrationFee),
                ),

                const SizedBox(height: 10),

                InfoCard(
                  icon: Icons.calendar_month_outlined,
                  title: "Monthly Fee",
                  value: formatRupiah(program.monthlyFee),
                ),

                const SizedBox(height: 24),

                textBaloo2("Course", fontSize: 20, fontWeight: FontWeight.w700),

                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: AppColors.lightText,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: AppColors.mutedText.withValues(alpha: 0.2),
                    ),
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,

                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: const Icon(
                          Icons.school,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            textPoppins(
                              "Course",
                              fontSize: 11,
                              color: AppColors.mutedText,
                            ),

                            const SizedBox(height: 3),

                            textPoppins(
                              widget.course.name,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    textBaloo2(
                      "Classes",
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),

                    Button(
                      text: "Add Class",
                      textColor: AppColors.lightText,
                      bgColor: AppColors.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      borderRadius: BorderRadius.circular(10),
                      onPressed: () {
                        // TODO:
                        // Navigate ke Add Class Page
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: AppColors.mutedText.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Column(
                    children: [
                      Icon(
                        Icons.class_outlined,
                        size: 40,
                        color: AppColors.mutedText,
                      ),

                      const SizedBox(height: 10),

                      textPoppins(
                        "No classes yet",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),

                      const SizedBox(height: 4),

                      textPoppins(
                        "Create a class for this program.",
                        fontSize: 12,
                        color: AppColors.mutedText,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
