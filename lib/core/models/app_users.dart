import 'package:lingo_manage/core/constants/user_role.dart';

class AppUser {
  final String uid;
  final String fullname;
  final String? nickname;
  final String email;
  final String phone;
  final String role;
  final String? subscriptionStatus;
  final int? studentLimit;
  final String? level;
  final String? address;

  AppUser({
    required this.uid,
    required this.fullname,
    this.nickname,
    required this.email,
    required this.phone,
    required this.role,
    this.subscriptionStatus,
    this.studentLimit,
    this.level,
    this.address,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      fullname: data['fullname'] ?? '',
      nickname: data['nickname'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? UserRole.student,
      subscriptionStatus: data['subscriptionStatus'],
      studentLimit: data['studentLimit'],
      level: data['level'],
      address: data['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullname,
      'nickname': nickname,
      'email': email,
      'phone': phone,
      'role': role,
      'subscriptionStatus': subscriptionStatus,
      'studentLimit': studentLimit,
      'level': level,
      'address': address,
    };
  }
}
