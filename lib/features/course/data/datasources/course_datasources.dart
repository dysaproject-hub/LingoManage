import 'package:flutter/widgets.dart';
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

    debugPrint("GET COURSE");
    debugPrint("UID: $uid");

    final snapshot = await _client
        .from(DatabaseTableName.organizationMemberCollection)
        .select()
        .eq('admin_id', uid)
        .order('created_at', ascending: false);

    debugPrint("GOT A SNAPSHOT");
    debugPrint("COURSE ADMIN DATA: $snapshot");

    final courseIds = snapshot
        .map((doc) => doc['course_id'] as String)
        .toList();

    debugPrint("COURSE IDS: $courseIds");

    final courses = await Future.wait(
      courseIds.map((courseId) async {
        debugPrint("GET COURSE: $courseId");

        final courseDoc = await _client
            .from(DatabaseTableName.coursesCollection)
            .select()
            .eq('id', courseId)
            .maybeSingle();

        debugPrint("RESULT COURSE $courseId: $courseDoc");

        if (courseDoc == null) {
          throw Exception(
            "Course tidak ditemukan / tidak bisa diakses: $courseId",
          );
        }

        return CourseModel.fromMap(courseDoc['id'] as String, courseDoc);
      }),
    );

    debugPrint("RETURN ALL: ${courses.length}");

    return courses;
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
    required String organizationId,
    required String address,
  }) async {
    final uid = _currentUserId;

    if (uid.isEmpty) {
      throw Exception('User belum login');
    }

    try {
      debugPrint("=== START INSERT COURSE ===");
      debugPrint("UID: $uid");

      final courseRow = await _client
          .from(DatabaseTableName.coursesCollection)
          .insert({
            'owner_id': uid,
            'name': name,
            'description': description,
            'organization_id': organizationId,
            'address': address,
          })
          .select()
          .single();

      debugPrint("=== FINISH INSERT COURSE ===");
      debugPrint("COURSE ROW: $courseRow");

      return CourseModel.fromMap(courseRow['id'] as String, courseRow);
    } catch (e, stackTrace) {
      debugPrint("=== ADD COURSE ERROR ===");
      debugPrint("ERROR: $e");
      debugPrint("STACKTRACE: $stackTrace");

      rethrow;
    }
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
        .update({'name': name, 'description': description, 'address': address})
        .eq('id', courseId);
  }

  /// DELETE COURSE
  Future<void> deleteCourse(String courseId) async {
    await _client
        .from(DatabaseTableName.coursesCollection)
        .delete()
        .eq('id', courseId);
  }
}
