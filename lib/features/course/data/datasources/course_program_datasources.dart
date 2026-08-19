import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_manage/core/constants/firestore_collections.dart';
import 'package:lingo_manage/features/course/models/course_program_model.dart';

class CourseProgramDatasources {
  final FirebaseFirestore _db;

  CourseProgramDatasources(this._db);

  Future<CourseProgramModel> addProgram({
    required String courseId,
    required String name,
    required String? description,

    required int registrationFee,
    required int monthlyFee,

    required bool isActive,
  }) async {
    final programRef = _db
        .collection(FirestoreCollection.programsCollection)
        .doc();

    final data = {
      'courseId': courseId,
      'name': name,
      'registrationFee': registrationFee,
      'monthlyFee': monthlyFee,
      'isActive': isActive,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await programRef.set(data);

    return CourseProgramModel.fromMap(programRef.id, {
      ...data,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    });
  }
}
