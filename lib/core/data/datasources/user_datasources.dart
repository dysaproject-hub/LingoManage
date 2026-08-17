import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingo_manage/core/constants/firestore_collections.dart';
import 'package:lingo_manage/core/models/app_users.dart';

class UserDatasources {
  final FirebaseFirestore _firestore;

  UserDatasources(this._firestore);

  Future<AppUser> getDataUser(String uid) async {
    final docSnapshot = await _firestore
        .collection(FirestoreCollection.usersCollection)
        .doc(uid)
        .get();

    if (!docSnapshot.exists || docSnapshot.data() == null) {
      throw Exception("User data not found.");
    }

    return AppUser.fromMap(uid, docSnapshot.data()!);
  }

  Future<void> updateDataUser({
    required String uid,
    String? fullname,
    String? nickname,
    String? phone,
    String? address,
    String? schoolName,
    String? educationLevel,
  }) async {
    final Map<String, dynamic> data = {};

    if (fullname != null) {
      data["fullname"] = fullname;
    }

    if (nickname != null) {
      data["nickname"] = nickname;
    }

    if (phone != null) {
      data["phone"] = phone;
    }

    if (address != null) {
      data["address"] = address;
    }

    if (schoolName != null) {
      data["schoolName"] = schoolName;
    }

    if (schoolName != null) {
      data["educationLevel"] = educationLevel;
    }

    if (data.isEmpty) return;

    await _firestore
        .collection(FirestoreCollection.usersCollection)
        .doc(uid)
        .update(data);
  }
}
