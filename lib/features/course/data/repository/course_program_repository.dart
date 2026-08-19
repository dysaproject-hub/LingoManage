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
      isActive: isActive,
    );
  }
}
