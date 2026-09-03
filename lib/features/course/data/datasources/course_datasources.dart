import 'package:lingo_manage/core/constants/database_table_name.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourseDatasources {
  final SupabaseClient _client;

  CourseDatasources(this._client);

  /// GET CURRENT USER ID
  String get _currentUserId {
    final uid = _client.auth.currentUser?.id;

    if (uid == null) {
      throw Exception('User is not logged in');
    }

    return uid;
  }

  /// GET MY COURSES
  Future<List<CourseModel>> getMyCourses() async {
    final uid = _currentUserId;

    final snapshot = await _client
        .from(DatabaseTableName.courseAdminsCollection)
        .select()
        .eq('admin_id', uid)
        .order('created_at', ascending: false);

    final courseIds = snapshot.map((doc) => doc['courseId'] as String).toList();

    final courses = await Future.wait(
      courseIds.map((courseId) async {
        final courseDoc = await _client
            .from(DatabaseTableName.coursesCollection)
            .select()
            .eq('course_id', courseId).maybeSingle();

        if (courseDoc == null) {
          return null;
        }

        return CourseModel.fromMap(courseDoc['id'], courseDoc);
      }),
    );

    return courses.whereType<CourseModel>().toList();
  }

  /// GET COURSE BY ID
  Future<CourseModel> getCourseById(String courseId) async {
    final doc = await _client
        .from(DatabaseTableName.coursesCollection)
        .select()
        .eq('id', courseId)
        .select()
        .maybeSingle();

    if (doc == null) {
      throw Exception("Course doesn't found");
    }

    return CourseModel.fromMap(doc['id'] as String, doc);
  }

  Future<List<CourseModel>> getAllCourses() async {
    final snapshot = await _client
        .from(DatabaseTableName.coursesCollection)
        .select();

    return snapshot.map((doc) {
      return CourseModel.fromMap(doc['id'] as String, doc);
    }).toList();
  }

  /// ADD COURSE
  Future<CourseModel> addCourse({
    required String name,
    required String description,
    required String address,
  }) async {
    final uid = _currentUserId;

    final courseRow = await _client
        .from(DatabaseTableName.coursesCollection)
        .insert({
          'owner_id': uid,
          'name': name,
          'description': description,
          'address': address,
        })
        .select()
        .single();

    await _client.from(DatabaseTableName.courseAdminsCollection).insert({
      'course_id': courseRow['id'],
      'admin_id': uid,
      'role': 'owner',
    });

    return CourseModel.fromMap(courseRow['id'] as String, courseRow);
  }

  /// UPDATE COURSE
  Future<void> updateCourse({
    required String courseId,
    required String name,
    required String description,
    required String address,
  }) async {
    await _client
        .from(DatabaseTableName.coursesCollection)
        .update({
          'name': name,
          'description': description,
          'address': address,
        });
  }

  /// DELETE COURSE
  Future<void> deleteCourse(String courseId) async {
  await _client
      .from(DatabaseTableName.courseAdminsCollection)
      .delete()
      .eq('course_id', courseId);

  await _client
      .from(DatabaseTableName.programsCollection)
      .delete()
      .eq('course_id', courseId);

  await _client
      .from(DatabaseTableName.coursesCollection)
      .delete()
      .eq('id', courseId);
}
}
