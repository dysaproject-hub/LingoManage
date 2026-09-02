import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/utils/exceptions/app_error_mapper.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:lingo_manage/features/student/presentation/provider/student_provider.dart';
import 'package:lingo_manage/shared/widgets/cards/card_student.dart';
import 'package:lingo_manage/shared/widgets/errors/error_widget.dart';
import 'package:lingo_manage/shared/widgets/loadings/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';

class ManageStudentPage extends ConsumerStatefulWidget {
  final CourseModel courseModel;
  const ManageStudentPage({super.key, required this.courseModel});

  @override
  ConsumerState<ManageStudentPage> createState() => _ManageStudentPageState();
}

class _ManageStudentPageState extends ConsumerState<ManageStudentPage> {
  @override
  Widget build(BuildContext context) {
    final approvedStudentByCourseId = ref.watch(
      approvedStudentByCourseProvider(widget.courseModel.id),
    );

    return Scaffold(
      backgroundColor: AppColors.lightText,
      appBar: AppBar(
        backgroundColor: AppColors.lightText,
        title: textPoppins(
          'Manage Students',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textBaloo2(
                widget.courseModel.name,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),

              textPoppins(
                'Manage students in this course.',
                fontSize: 13,
                color: AppColors.mutedText,
              ),

              const SizedBox(height: 24),

              textBaloo2('Students', fontSize: 18, fontWeight: FontWeight.w700),

              const SizedBox(height: 8),

              Expanded(
                child: approvedStudentByCourseId.when(
                  data: (enrollments) {
                    if (enrollments.isEmpty) {
                      return Center(
                        child: textPoppins("No students in this course yet."),
                      );
                    }
                    return ListView.builder(
                      itemCount: enrollments.length,
                      itemBuilder: (context, index) {
                        return StudentCard(enrollmentModel: enrollments[index]);
                      },
                    );
                  },
                  error: (e, s) {
                    final err = ErrorMapper.map(e);

                    return CustomErrorWidget(
                      message: err.message,
                      title: "Can't load student data",
                    );
                  },
                  loading: () => const LoadingWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
