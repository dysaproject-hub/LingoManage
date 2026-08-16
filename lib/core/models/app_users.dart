import 'package:lingo_manage/core/constants/user_role.dart';
import 'package:lingo_manage/core/utils/education_level_enum.dart';

class AppUser {
  final String uid;
  final String fullname;
  final String? nickname;
  final String email;
  final String phone;
  final String role;
  final String? address;
  final String? schoolName;
  final EducationLevel? educationLevel;

  AppUser({
    required this.uid,
    required this.fullname,
    this.nickname,
    required this.email,
    required this.phone,
    required this.role,
    this.address,
    this.schoolName,
    this.educationLevel,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      fullname: data['fullname'] ?? '',
      nickname: data['nickname'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? UserRole.student,
      address: data['address'] ?? '',
      schoolName: data['schoolName'] ?? '',
      educationLevel: data['educationLevel'] ?? EducationLevel.other,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullname,
      'nickname': nickname,
      'email': email,
      'phone': phone,
      'role': role,
      'address': address,
      'schoolName': schoolName,
      'educationLevel': educationLevel,
    };
  }
}
