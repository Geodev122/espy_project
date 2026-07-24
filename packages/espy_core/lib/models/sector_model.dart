class SectorModel {
  final String id;
  final String nameEn;
  final String? nameAr;
  final String? description;
  final String? iconName;
  final String? colorHex;
  final int displayOrder;
  final bool isActive;

  SectorModel({
    required this.id,
    required this.nameEn,
    this.nameAr,
    this.description,
    this.iconName,
    this.colorHex,
    this.displayOrder = 999,
    this.isActive = true,
  });

  factory SectorModel.fromMap(Map<String, dynamic> data) {
    return SectorModel(
      id: data['id'] ?? '',
      nameEn: data['nameEn'] ?? data['name_en'] ?? '',
      nameAr: data['nameAr'] ?? data['name_ar'],
      description: data['description'],
      iconName: data['iconName'] ?? data['icon_name'],
      colorHex: data['colorHex'] ?? data['color_hex'],
      displayOrder: data['displayOrder'] ?? 999,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'description': description,
      'iconName': iconName,
      'colorHex': colorHex,
      'displayOrder': displayOrder,
      'isActive': isActive,
    };
  }
}
