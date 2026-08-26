import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/routes/routes.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:lingo_manage/features/course/presentation/providers/course_program_provider.dart';
import 'package:lingo_manage/shared/widgets/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class StudentDetailCoursePage extends ConsumerStatefulWidget {
  final CourseModel course;

  const StudentDetailCoursePage({super.key, required this.course});

  @override
  ConsumerState<StudentDetailCoursePage> createState() =>
      _StudentDetailCoursePageState();
}

class _StudentDetailCoursePageState
    extends ConsumerState<StudentDetailCoursePage> {
  @override
  Widget build(BuildContext context) {
    final courseProgramDataList = ref.watch(
      getAllCourseProgramProvider(widget.course.id),
    );

    return Scaffold(
      backgroundColor: AppColors.lightText,

      appBar: AppBar(
        backgroundColor: AppColors.lightText,
        elevation: 0,
        title: textPoppins(
          'Course Detail',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // COURSE ICON
                    Container(
                      width: 60,
                      height: 60,

                      decoration: BoxDecoration(
                        color: AppColors.lightText.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: const Icon(
                        Icons.school_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // COURSE NAME
                    textBaloo2(
                      widget.course.name,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),

                    const SizedBox(height: 8),

                    // COURSE DESCRIPTION
                    textPoppins(
                      widget.course.description?.isNotEmpty == true
                          ? widget.course.description!
                          : 'No description available.',
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 
              // ABOUT COURSE
              // 
              textBaloo2(
                'About Course',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),

              const SizedBox(height: 10),

              textPoppins(
                widget.course.description?.isNotEmpty == true
                    ? widget.course.description!
                    : 'This course does not have a description yet.',
                fontSize: 13,
                color: AppColors.mutedText,
              ),

              const SizedBox(height: 28),

              // 
              // PROGRAM SECTION
              // 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textBaloo2(
                    'Available Programs',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: textPoppins(
                      'Programs',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              courseProgramDataList.when(
                data: (data) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final courseProgram = data[index];
                      return _ProgramCard(
                        programName: courseProgram.name,
                        description: courseProgram.description ?? '-',
                        registrationFee: courseProgram.registrationFee,
                        monthlyFee: courseProgram.monthlyFee,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.enrollmentForm,
                            arguments: {
                              'courseModel': widget.course,
                              'programModel': courseProgram,
                            },
                          );
                        },
                      );
                    },
                  );
                },
                error: (e, s) => textPoppins("Sorry, something went wrong!"),
                loading: () => LoadingWidget(),
              ),

              const SizedBox(height: 28),

              // 
              // INFORMATION
              // 
              textBaloo2(
                'Important Information',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),

              const SizedBox(height: 12),

              _InformationItem(
                icon: Icons.info_outline,
                title: 'Registration',
                description:
                    'Registration fee may apply depending on the selected program.',
              ),

              const SizedBox(height: 10),

              _InformationItem(
                icon: Icons.calendar_month_outlined,
                title: 'Class Schedule',
                description:
                    'Class schedule will be provided after your enrollment is approved.',
              ),

              const SizedBox(height: 10),

              _InformationItem(
                icon: Icons.people_outline,
                title: 'Class',
                description:
                    'You will be assigned to a class after your enrollment is approved.',
              ),

              const SizedBox(height: 30),

              // 
              // BOTTOM INFORMATION
              // 
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.20),
                  ),
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline, color: AppColors.accent),

                    const SizedBox(width: 12),

                    Expanded(
                      child: textPoppins(
                        'Choose the program that suits your learning needs before registering.',
                        fontSize: 12,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final String programName;
  final String description;
  final int registrationFee;
  final int monthlyFee;
  final VoidCallback onPressed;

  const _ProgramCard({
    required this.programName,
    required this.description,
    required this.registrationFee,
    required this.monthlyFee,
    required this.onPressed,
  });

  String formatRupiah(int value) {
    final text = value.toString();

    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && (text.length - i) % 3 == 0) {
        buffer.write('.');
      }

      buffer.write(text[i]);
    }

    return 'Rp ${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.lightText,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: AppColors.mutedText.withValues(alpha: 0.20)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,

                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(Icons.menu_book_outlined, color: AppColors.accent),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: textBaloo2(
                  programName,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          textPoppins(description, fontSize: 12, color: AppColors.mutedText),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _FeeItem(
                  title: 'Registration',
                  value: formatRupiah(registrationFee),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _FeeItem(
                  title: 'Monthly',
                  value: formatRupiah(monthlyFee),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: onPressed,

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,

                padding: const EdgeInsets.symmetric(vertical: 13),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              child: textPoppins(
                'Choose Program',
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// FEE ITEM


class _FeeItem extends StatelessWidget {
  final String title;
  final String value;

  const _FeeItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: AppColors.mutedText.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textPoppins(title, fontSize: 10, color: AppColors.mutedText),

          const SizedBox(height: 3),

          textPoppins(
            value,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ],
      ),
    );
  }
}


// INFORMATION ITEM


class _InformationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InformationItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,

          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),

          child: Icon(icon, size: 20, color: AppColors.primary),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textPoppins(
                title,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),

              const SizedBox(height: 3),

              textPoppins(
                description,
                fontSize: 11,
                color: AppColors.mutedText,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
