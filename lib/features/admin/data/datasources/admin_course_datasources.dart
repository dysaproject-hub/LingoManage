// import 'package:flutter/widgets.dart';
// import 'package:lingo_manage/core/constants/database_table_name.dart';
// import 'package:lingo_manage/core/constants/user_role.dart';
// import 'package:lingo_manage/core/models/app_users.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AdminCourseDatasources {
//   final SupabaseClient _db;

//   AdminCourseDatasources(this._db);

//   Future<void> addAdminToOrganization({
//     required String organizationId,
//     required String adminId,
//   }) async {
//     try {
//       final existing = await _db
//           .from(DatabaseTableName.organizationMemberCollection)
//           .select()
//           .eq('organization_id', organizationId)
//           .eq('admin_id', adminId);

//       if (existing.isNotEmpty) {
//         throw Exception('Admin has been added in this course');
//       }

//       final data = {
//         'organization_id': organizationId,
//         'admin_id': adminId,
//         'role': UserRole.instructor,
//       };

//       await _db.from(DatabaseTableName.organizationMemberCollection).insert(data);
//     } catch (e) {
//       debugPrint("$e");
//     }
//   }

//   Future<AppUser?> findAdminByEmail(String email) async {
//     try {
//       debugPrint("=== SEARCH ADMIN ===");

//       debugPrint("=== SELECT ADMIN ===");
//       final snapshot = await _db
//           .from(DatabaseTableName.usersCollection)
//           .select()
//           .eq('email', email)
//           .eq('role', UserRole.instructor)
//           .maybeSingle();

//       debugPrint("=== FINISH ADMIN ===");

//       if (snapshot == null || snapshot.isEmpty) {
//         debugPrint("=== NO ADMIN ===");
//         return null;
//       }

//       debugPrint("=== RETURN ADMIN ===");
//       return AppUser.fromMap(snapshot['id'] as String, snapshot);
//     } catch (e) {
//       debugPrint("$e");
//     }

//     return null;
//   }

//   Future<List<AppUser>> getCourseAdmins({required String organizationId}) async {
//     final snapshot = await _db
//         .from(DatabaseTableName.organizationMemberCollection)
//         .select()
//         .eq('organization_id', organizationId);

//     final List<AppUser> admins = [];

//     for (final data in snapshot) {
//       final adminId = data['admin_id'] as String;

//       final userDoc = await _db
//           .from(DatabaseTableName.usersCollection)
//           .select()
//           .eq('id', adminId)
//           .maybeSingle();

//       if (userDoc == null) {
//         continue;
//       }

//       final user = AppUser.fromMap(userDoc['id'] as String, userDoc);

//       if (user.role == UserRole.instructor) {
//         admins.add(user);
//       }
//     }

//     return admins;
//   }

//   Future<void> removeAdminFromCourse({
//     required String organizationId,
//     required String adminId,
//   }) async {
//     await _db
//         .from(DatabaseTableName.organizationMemberCollection)
//         .delete()
//         .eq('organization_id', organizationId)
//         .eq('admin_id', adminId);
//   }
// }