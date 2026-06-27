class ServiceModel {
  final String id;
  final String title;
  final String? titleAr;
  final String? description;
  final String? descriptionAr;
  final String? categoryId;
  final String? sectorId;
  final String? countryId;
  final String professionalId;
  final String? institutionId;
  final String? photoUrl;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String pricingType;
  final int favoriteCount;

  ServiceModel({
    required this.id,
    required this.title,
    this.titleAr,
    this.description,
    this.descriptionAr,
    this.categoryId,
    this.sectorId,
    this.countryId,
    required this.professionalId,
    this.institutionId,
    this.photoUrl,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.pricingType = 'standard',
    this.favoriteCount = 0,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'Untitled',
      titleAr: json['titleAr'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      categoryId: json['categoryId'] as String?,
      sectorId: json['sectorId'] as String?,
      countryId: (json['countryId'] ?? json['country']) as String?,
      professionalId: json['professionalId'] as String? ?? '',
      institutionId: json['institutionId'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
      pricingType: json['pricingType'] as String? ?? 'standard',
      favoriteCount: json['favoriteCount'] ?? 0,
    );
  }
}
