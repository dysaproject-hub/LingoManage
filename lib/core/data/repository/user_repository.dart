import 'package:lingo_manage/core/data/datasources/user_datasources.dart';
import 'package:lingo_manage/core/models/app_users.dart';

class UserRepository {
  final UserDatasources _datasources;

  UserRepository(this._datasources);

  Future<AppUser> getDataUser({required String uid}) async {
    return await _datasources.getDataUser(uid);
  }

  Future<void> updateDataUser({
    required String uid,
    String? fullname,
    String? nickname,
    String? phone,
    String? address,
    String? schoolName,
    String? educationLevel
  }) async {
    return await _datasources.updateDataUser(uid: uid, fullname: fullname, nickname: nickname, phone: phone, address: address, schoolName: schoolName, educationLevel: educationLevel);
  }
}
