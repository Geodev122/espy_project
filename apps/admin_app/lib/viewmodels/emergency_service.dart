import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getEmergencySections({String? countryId}) {
    if (countryId != null) {
      return _db
          .collection('emergency_hotlines')
          .where('country_id', isEqualTo: countryId)
          .snapshots()
          .map((snap) {
            // Group by some field if needed, or just return as sections
            final items = snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
            // Assuming the collection structure matches the simplified requirement
            // We can group them by 'category' or similar if they have it
            return [{'name_en': 'Emergency Contacts', 'name_ar': 'جهات الاتصال للطوارئ', 'numbers': items}];
          });
    }

    return _db
        .collection('directory_settings')
        .doc('app_config')
        .snapshots()
        .map((snap) {
      if (snap.exists && snap.data()!.containsKey('emergency_sections')) {
        return List<Map<String, dynamic>>.from(snap.data()!['emergency_sections']);
      }
      return <Map<String, dynamic>>[];
    }).handleError((e) {
      debugPrint('Firestore Error (getEmergencySections): $e');
    });
  }

  Future<void> makeCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> sendSOSAlert(String userId, GeoPoint location) async {
    // Record interaction for SOS
    await _db.collection('directory_interactions').add({
      'type': 'sos_alert',
      'userId': userId,
      'location': {
        'lat': location.latitude,
        'lng': location.longitude,
      },
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'active',
    });
  }
}
