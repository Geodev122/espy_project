class RegionModel {
  final String id;
  final String countryId;
  final String nameEn;
  final String? nameAr;
  final String? regionCode;

  RegionModel({
    required this.id,
    required this.countryId,
    required this.nameEn,
    this.nameAr,
    this.regionCode,
  });

  factory RegionModel.fromMap(Map<String, dynamic> data) {
    return RegionModel(
      id: data['id'] ?? '',
      countryId: data['countryId'] ?? data['country']?['id'] ?? '',
      nameEn: data['nameEn'] ?? '',
      nameAr: data['nameAr'],
      regionCode: data['regionCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'countryId': countryId,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'regionCode': regionCode,
    };
  }
}
