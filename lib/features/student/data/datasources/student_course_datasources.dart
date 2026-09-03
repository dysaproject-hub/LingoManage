import 'package:lingo_manage/core/constants/database_table_name.dart';
import 'package:lingo_manage/core/utils/status_enrollments_enum.dart';
import 'package:lingo_manage/features/enrollments/models/enrollment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentCourseDatasources {
  final SupabaseClient _db;

  StudentCourseDatasources(this._db);

  Future<List<EnrollmentModel>> approvedStudentByCourseId({
    required String courseId,
  }) async {
    final studentRef = await _db
        .from(DatabaseTableName.enrollmentsCollection)
        .select()
        .eq('course_id', courseId)
        .eq('status', StatusEnrollments.approved.label);

    return studentRef.map((doc) {
      return EnrollmentModel.fromMap(doc['id'] as String, doc);
    }).toList();
  }
}
