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

  Future<List<CourseModel>> getAllCourses() async {
    return await _datasources.getAllCourses();
  }

  Future<CourseModel> addCourse({
    required String name,
    required String description,
    required String address,
  }) async {
    return await _datasources.addCourse(name: name, description: description, address: address);
  }

  Future<void> updateCourse({
    required String courseId,
    required String name,
    required String description,
    required String address,
  }) async {
    return await _datasources.updateCourse(
      courseId: courseId,
      name: name,
      description: description,
      address: address,
    );
  }

  Future<void> deleteCourse({required String courseId}) async {
    return await _datasources.deleteCourse(courseId);
  }
}
