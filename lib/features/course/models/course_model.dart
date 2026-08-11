class CourseModel {
  final String id;
  final String ownerId;

  final String name;
  final String? description;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  CourseModel({
    required this.id,
    required this.ownerId,
    required this.name,
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
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'name': name,
      'description': description,
    };
  }
}