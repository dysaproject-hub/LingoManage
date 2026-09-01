import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_manage/core/constants/firestore_collections.dart';
import 'package:lingo_manage/core/utils/status_enrollments_enum.dart';
import 'package:lingo_manage/features/enrollments/models/enrollment_model.dart';

class StudentCourseDatasources {
  final FirebaseFirestore _db;

  StudentCourseDatasources(this._db);

  Future<List<EnrollmentModel>> approvedStudentByCourseId({
    required String courseId,
  }) async {
    final studentRef = await _db
        .collection(FirestoreCollection.enrollmentsCollection)
        .where('courseId', isEqualTo: courseId)
        .where('status', isEqualTo: StatusEnrollments.approved.label)
        .get();

    return studentRef.docs.map((doc) {
      return EnrollmentModel.fromMap(doc.id, doc.data());
    }).toList();
  }
}
