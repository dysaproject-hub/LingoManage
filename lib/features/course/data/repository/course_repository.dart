import 'package:lingo_manage/features/course/data/datasources/course_datasources.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';

class CourseRepository {
  final CourseDatasources _datasources;

  CourseRepository(this._datasources);

  Future<List<CourseModel>> getMyCourse() async {
    return await _datasources.getMyCourses();
  }

  Future<CourseModel> getCourseById({required String courseId}) async {
    return await _datasources.getCourseById(courseId);
  }

  Future<CourseModel> addCourse({
    required String name,
    required String description,
  }) async {
    return await _datasources.addCourse(name: name, description: description);
  }

  Future<void> updateCourse({
    required String courseId,
    required String name,
    required String description,
  }) async {
    return await _datasources.updateCourse(
      courseId: courseId,
      name: name,
      description: description,
    );
  }

  Future<void> deleteCourse({required String courseId}) async {
    return await _datasources.deleteCourse(courseId);
  }
}
