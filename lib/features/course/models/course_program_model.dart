class CourseProgramModel {
  final String id;
  final String courseId;
  final String name;
  final String? description;

  final int registrationFee;
  final int monthlyFee;

  final bool isActive;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  CourseProgramModel({
    required this.id,
    required this.courseId,
    required this.name,
    this.description,
    required this.registrationFee,
    required this.monthlyFee,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory CourseProgramModel.fromMap(String id, Map<String, dynamic> data) {
    return CourseProgramModel(
      id: id,
      courseId: data['courseId'],
      name: data['name'],
      description: data['description'],
      registrationFee: data['registrationFee'],
      monthlyFee: data['monthlyFee'],
      isActive: data['isActive'],
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }
}
