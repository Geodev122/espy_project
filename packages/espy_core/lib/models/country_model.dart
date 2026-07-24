class CountryModel {
  final String id;
  final String nameEn;
  final String? nameAr;
  final String? flagEmoji;
  final String? isoCode;
  final String? currency;
  final String? timezone;

  CountryModel({
    required this.id,
    required this.nameEn,
    this.nameAr,
    this.flagEmoji,
    this.isoCode,
    this.currency,
    this.timezone,
  });

  factory CountryModel.fromMap(Map<String, dynamic> data) {
    return CountryModel(
      id: data['id'] ?? '',
      nameEn: data['nameEn'] ?? data['name_en'] ?? '',
      nameAr: data['nameAr'] ?? data['name_ar'],
      flagEmoji: data['flagEmoji'] ?? data['flag_emoji'],
      isoCode: data['isoCode'] ?? data['iso_code'],
      currency: data['currency'],
      timezone: data['timezone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'flagEmoji': flagEmoji,
      'isoCode': isoCode,
      'currency': currency,
      'timezone': timezone,
    };
  }
}
