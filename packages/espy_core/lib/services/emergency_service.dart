import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../viewmodels/espy_repository.dart';

class EmergencyService extends ChangeNotifier {
  final EspyRepository _repository;
  final firestore.FirebaseFirestore _db = firestore.FirebaseFirestore.instance;

  String? _detectedCountryId;
  bool _isLocating = false;

  EmergencyService(this._repository) {
    autoDetectLocation();
  }

  String? get detectedCountryId => _detectedCountryId;
  bool get isLocating => _isLocating;

  Future<void> autoDetectLocation() async {
    _isLocating = true;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
         _isLocating = false;
         notifyListeners();
         return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _isLocating = false;
          notifyListeners();
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      
      if (placemarks.isNotEmpty) {
        final country = placemarks.first.country?.toLowerCase() ?? 'lebanon';
        _detectedCountryId = country.replaceAll(' ', '-');
        debugPrint("Detected Country: $_detectedCountryId");
      }
    } catch (e) {
      debugPrint("Location Detection Error: $e");
    } finally {
      _isLocating = false;
      notifyListeners();
    }
  }

  Stream<List<Map<String, dynamic>>> getEmergencySections({String? countryId, String? sectorId}) {
    final targetCountry = countryId ?? _detectedCountryId;

    return _repository.listSosNumbers(countryId: targetCountry, sectorId: sectorId).map((items) {
      if (items.isEmpty) return [];
      
      final Map<String, List<Map<String, dynamic>>> groups = {};
      for (var sos in items) {
        final cat = sos['categoryId'] ?? 'GENERAL';
        if (!groups.containsKey(cat)) groups[cat] = [];
        groups[cat]!.add({
          'label_en': sos['labelEn'],
          'label_ar': sos['labelAr'],
          'number': sos['number'],
          'icon': sos['categoryIcon'],
        });
      }

      return groups.entries.map((e) => {
        'name_en': e.key.toUpperCase(),
        'name_ar': e.key, 
        'numbers': e.value,
      }).toList();
    });
  }

  Future<void> makeCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> sendSOSAlert(String userId, firestore.GeoPoint location) async {
    await _db.collection('directory_interactions').add({
      'type': 'sos_alert',
      'userId': userId,
      'location': {
        'lat': location.latitude,
        'lng': location.longitude,
      },
      'timestamp': firestore.FieldValue.serverTimestamp(),
      'status': 'active',
    });
  }
}
