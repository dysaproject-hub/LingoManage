
class AppUser {
  final String uid;
  final String fullname;
  final String? nickname;
  final String email;
  final String phone;
  final String role;

  AppUser({
    required this.uid,
    required this.fullname,
    this.nickname,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      fullname: data['fullname'] ?? '',
      nickname: data['nickname'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullname,
      'nickname': nickname,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }
}
