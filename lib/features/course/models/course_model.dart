import 'package:lingo_manage/core/utils/parse_date_helper.dart';

class CourseModel {
  final String id;
  final String ownerId;

  final String name;
  final String address;
  final String? description;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  CourseModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory CourseModel.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return CourseModel(
      id: id,
      ownerId: data['owner_id'] ?? '',
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      description: data['description'] ?? '',
      createdAt: parseDateTime(data['created_at']),
      updatedAt: parseDateTime(data['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'owner_id': ownerId,
      'name': name,
      'description': description,
      'address': address,
    };
  }
}