class CountryModel {
  final String id;
  final String nameEn;
  final String? nameAr;
  final String? flagEmoji;

  CountryModel({
    required this.id,
    required this.nameEn,
    this.nameAr,
    this.flagEmoji,
  });

  factory CountryModel.fromMap(Map<String, dynamic> data) {
    return CountryModel(
      id: data['id'] ?? '',
      nameEn: data['nameEn'] ?? data['name_en'] ?? '',
      nameAr: data['nameAr'] ?? data['name_ar'],
      flagEmoji: data['flagEmoji'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'flagEmoji': flagEmoji,
    };
  }
}
