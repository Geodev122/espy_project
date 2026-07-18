class CountryModel {
  final String id;
  final String nameEn;
  final String nameAr;
  final String code;
  final String currency;
  final String phoneCode;

  CountryModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.code,
    required this.currency,
    required this.phoneCode,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] ?? '',
      nameEn: json['name_en'] ?? '',
      nameAr: json['name_ar'] ?? '',
      code: json['code'] ?? '',
      currency: json['currency'] ?? 'USD',
      phoneCode: json['phone_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_en': nameEn,
      'name_ar': nameAr,
      'code': code,
      'currency': currency,
      'phone_code': phoneCode,
    };
  }
}
