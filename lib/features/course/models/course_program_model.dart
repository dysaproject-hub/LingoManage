import 'package:lingo_manage/core/utils/parse_date_helper.dart';

class CourseProgramModel {
  final String id;
  final String courseId;
  final String name;
  final String? description;

  final int registrationFee;
  final int monthlyFee;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  CourseProgramModel({
    required this.id,
    required this.courseId,
    required this.name,
    this.description,
    required this.registrationFee,
    required this.monthlyFee,
    this.createdAt,
    this.updatedAt,
  });

  factory CourseProgramModel.fromMap(String id, Map<String, dynamic> data) {
    return CourseProgramModel(
      id: id,
      courseId: data['course_id'],
      name: data['name'],
      description: data['description'],
      registrationFee: data['registration_fee'],
      monthlyFee: data['monthly_fee'],
      createdAt: parseDateTime(data['created_at']),
      updatedAt: parseDateTime(data['updated_at']),
    );
  }
}
