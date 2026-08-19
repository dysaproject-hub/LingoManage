import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:lingo_manage/features/student/presentation/widget/card_course_widget.dart';
import 'package:lingo_manage/shared/widgets/carousel_indicator.dart';

class CourseCarouselWidget extends StatefulWidget {
  final List<CourseModel> data;

  const CourseCarouselWidget({
    super.key,
    required this.data,
  });

  @override
  State<CourseCarouselWidget> createState() => _CourseCarouselState();
}

class _CourseCarouselState extends State<CourseCarouselWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              final index =
                  (notification.metrics.pixels / 300).round();

              if (index != _currentIndex &&
                  index >= 0 &&
                  index < widget.data.length) {
                setState(() {
                  _currentIndex = index;
                });
              }
            }

            return false;
          },
          child: SizedBox(
            height: 170,
            child: CarouselView.builder(
              itemExtent: 300,
              itemSnapping: true,
              shrinkExtent: 300,
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                return CardCourseWidgetStudent(
                  margin: EdgeInsets.only(right: 16),
                  maincolor: AppColors.primary,
                  gradientcolor: AppColors.primary,
                  courseData: widget.data[index],
                  jumlahsiswa: "--",
                  buttoncolor: AppColors.lightText,
                  onTapCek: () {},
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 8),

        CarouselIndicator(
          currentIndex: _currentIndex,
          data: widget.data,
        ),
      ],
    );
  }
}