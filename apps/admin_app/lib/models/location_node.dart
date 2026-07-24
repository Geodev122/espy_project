import 'package:cloud_firestore/cloud_firestore.dart';

class LocationNodeModel {
  final String id;
  final String userId;
  final String cityId;
  final String? pinCategoryId;
  final String? presenceTagId;
  final double lat;
  final double lng;
  final String? addressEn;
  final String? addressAr;
  final bool isMain;
  final bool isVerified;
  final String? label;

  LocationNodeModel({
    required this.id,
    required this.userId,
    required this.cityId,
    this.pinCategoryId,
    this.presenceTagId,
    required this.lat,
    required this.lng,
    this.addressEn,
    this.addressAr,
    this.isMain = false,
    this.isVerified = false,
    this.label,
  });

  factory LocationNodeModel.fromMap(Map<String, dynamic> data) {
    return LocationNodeModel(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      cityId: data['cityId'] ?? '',
      pinCategoryId: data['pinCategoryId'],
      presenceTagId: data['presenceTagId'],
      lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
      addressEn: data['addressEn'],
      addressAr: data['addressAr'],
      isMain: data['isMain'] ?? false,
      isVerified: data['isVerified'] ?? false,
      label: data['label'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'cityId': cityId,
      'pinCategoryId': pinCategoryId,
      'presenceTagId': presenceTagId,
      'lat': lat,
      'lng': lng,
      'addressEn': addressEn,
      'addressAr': addressAr,
      'isMain': isMain,
      'isVerified': isVerified,
      'label': label,
    };
  }
}
