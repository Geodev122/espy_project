class CityModel {
  final String id;
  final String regionId;
  final String nameEn;
  final String? nameAr;
  final double? lat;
  final double? lng;
  final int? population;

  CityModel({
    required this.id,
    required this.regionId,
    required this.nameEn,
    this.nameAr,
    this.lat,
    this.lng,
    this.population,
  });

  factory CityModel.fromMap(Map<String, dynamic> data) {
    return CityModel(
      id: data['id'] ?? '',
      regionId: data['regionId'] ?? data['region']?['id'] ?? '',
      nameEn: data['nameEn'] ?? '',
      nameAr: data['nameAr'],
      lat: data['lat'] != null ? double.tryParse(data['lat'].toString()) : null,
      lng: data['lng'] != null ? double.tryParse(data['lng'].toString()) : null,
      population: data['population'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'regionId': regionId,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'lat': lat,
      'lng': lng,
      'population': population,
    };
  }
}
