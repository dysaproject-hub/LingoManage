import 'package:lingo_manage/core/constants/database_table_name.dart';
import 'package:lingo_manage/features/course/models/course_program_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourseProgramDatasources {
  final SupabaseClient _db;

  CourseProgramDatasources(this._db);

  Future<CourseProgramModel> addProgram({
    required String courseId,
    required String name,
    required String? description,

    required int registrationFee,
    required int monthlyFee,
  }) async {
    final data = {
      'course_id': courseId,
      'name': name,
      'description': description,
      'registration_fee': registrationFee,
      'monthly_fee': monthlyFee,
    };

    final programRef = await _db
        .from(DatabaseTableName.programsCollection)
        .insert(data)
        .single();

    return CourseProgramModel.fromMap(programRef['id'] as String, data);
  }

  Future<void> deleteCourseProgram({required String programId}) async {
    await _db
        .from(DatabaseTableName.programsCollection)
        .delete()
        .eq('id', programId);
  }

  Future<void> updateProgram({
    required String programId,
    required String programName,
    required String description,
    required int registrationFee,
    required int monthlyFee,
  }) async {
    await _db
        .from(DatabaseTableName.programsCollection)
        .update({
          'name': programName,
          'description': description,
          'registration_fee': registrationFee,
          'monthly_fee': monthlyFee,
        })
        .eq('id', programId);
  }

  Future<List<CourseProgramModel>> getAllCourseProgram({
    required String courseId,
  }) async {
    final snapshot = await _db
        .from(DatabaseTableName.programsCollection)
        .select()
        .eq('course_id', courseId);

    return snapshot.map((data) {
      return CourseProgramModel.fromMap(data['id'] as String, data);
    }).toList();
  }

  Future<CourseProgramModel> getProgramById({required String programId}) async {
    final doc = await _db
        .from(DatabaseTableName.programsCollection)
        .select()
        .eq('id', programId)
        .maybeSingle();

    if (doc == null) {
      throw Exception("Program doesn't found!");
    }

    return CourseProgramModel.fromMap(doc['id'] as String, doc);
  }
}
