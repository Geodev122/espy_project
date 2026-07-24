import 'enums.dart';

class CategoryModel {
  final String id;
  final String sectorId;
  final String nameEn;
  final String? nameAr;
  final String? description;
  final UserRole targetRole;
  final bool isOtherCategory;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.sectorId,
    required this.nameEn,
    this.nameAr,
    this.description,
    this.targetRole = UserRole.visitor,
    this.isOtherCategory = false,
    this.isActive = true,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> data) {
    return CategoryModel(
      id: data['id'] ?? '',
      sectorId: data['sectorId'] ?? data['sector']?['id'] ?? '',
      nameEn: data['nameEn'] ?? '',
      nameAr: data['nameAr'],
      description: data['description'],
      targetRole: UserRole.parse(data['targetRole']),
      isOtherCategory: data['isOtherCategory'] ?? false,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sectorId': sectorId,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'description': description,
      'targetRole': targetRole.name,
      'isOtherCategory': isOtherCategory,
      'isActive': isActive,
    };
  }
}
