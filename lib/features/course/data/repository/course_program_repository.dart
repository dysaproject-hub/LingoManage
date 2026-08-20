import 'package:lingo_manage/features/course/data/datasources/course_program_datasources.dart';
import 'package:lingo_manage/features/course/models/course_program_model.dart';

class CourseProgramRepository {
  final CourseProgramDatasources _datasources;

  CourseProgramRepository(this._datasources);

  Future<CourseProgramModel> addProgram({
    required String courseId,
    required String name,
    required String? description,

    required int registrationFee,
    required int monthlyFee,

    required bool isActive,
  }) async {
    return await _datasources.addProgram(
      courseId: courseId,
      name: name,
      description: description,
      registrationFee: registrationFee,
      monthlyFee: monthlyFee,
    );
  }

  Future<void> deleteProgram({required String programId}) async {
    await _datasources.deleteCourseProgram(programId: programId);
  }

  Future<void> updateProgram({
    required String programId,
    required String programName,
    required String description,
    required int registrationFee,
    required int monthlyFee,
  }) async {
    await _datasources.updateProgram(
      programId: programId,
      programName: programName,
      description: description,
      registrationFee: registrationFee,
      monthlyFee: monthlyFee,
    );
  }

  Future<List<CourseProgramModel>> getAllCourseProgram({
    required String courseId,
  }) async {
    return await _datasources.getAllCourseProgram(courseId: courseId);
  }
}
