import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Standard Seeding logic for Espy Taxonomy v7.0
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final db = FirebaseFirestore.instance;

  print("--- SEEDING ESPY TAXONOMY v7.0 ---");

  // 1. Sectors
  final sectors = {
    'health': {'nameEn': 'Health', 'nameAr': 'القطاع الطبي', 'iconName': 'heart', 'colorHex': '0xFFE91E63', 'displayOrder': 1},
    'mental_health': {'nameEn': 'Mental Health', 'nameAr': 'القطاع النفسي', 'iconName': 'brain', 'colorHex': '0xFF9C27B0', 'displayOrder': 2},
    'social': {'nameEn': 'Social', 'nameAr': 'القطاع الاجتماعي', 'iconName': 'users', 'colorHex': '0xFF4CAF50', 'displayOrder': 3},
    'legal': {'nameEn': 'Legal', 'nameAr': 'القطاع القانوني', 'iconName': 'scale', 'colorHex': '0xFF795548', 'displayOrder': 4},
    'other_care': {'nameEn': 'Other Care', 'nameAr': 'قطاع الخدمات الأخرى', 'iconName': 'help', 'colorHex': '0xFF607D8B', 'displayOrder': 5},
  };

  for (var entry in sectors.entries) {
    await db.collection('directory_sectors').doc(entry.key).set(entry.value);
    print("Seeded Sector: ${entry.key}");
  }

  // 2. Categories
  final categories = [
    // Health
    {'id': 'doctors', 'sectorId': 'health', 'nameEn': 'Doctors', 'nameAr': 'أطباء'},
    {'id': 'nurses', 'sectorId': 'health', 'nameEn': 'Nurses & Midwives', 'nameAr': 'ممرضون وقابلات قانونيات'},
    {'id': 'nutritionists', 'sectorId': 'health', 'nameEn': 'Nutritionists', 'nameAr': 'أخصائيو تغذية'},
    {'id': 'allied_health', 'sectorId': 'health', 'nameEn': 'Allied Health Specialists', 'nameAr': 'أخصائيو المهن الطبية المساعدة'},
    {'id': 'other_health', 'sectorId': 'health', 'nameEn': 'Other Health', 'nameAr': 'خدمات طبية أخرى', 'isOtherCategory': true},
    // Mental Health
    {'id': 'psychologists', 'sectorId': 'mental_health', 'nameEn': 'Psychologists', 'nameAr': 'أخصائيو علم نفس'},
    {'id': 'psychiatrists', 'sectorId': 'mental_health', 'nameEn': 'Psychiatrists', 'nameAr': 'أطباء نفسيون'},
    {'id': 'psychosocial', 'sectorId': 'mental_health', 'nameEn': 'Psycho-social Workers', 'nameAr': 'عاملون في الدعم النفسي والاجتماعي'},
    {'id': 'other_mental', 'sectorId': 'mental_health', 'nameEn': 'Other Mental Health', 'nameAr': 'خدمات صحة نفسية أخرى', 'isOtherCategory': true},
    // Social
    {'id': 'family_child', 'sectorId': 'social', 'nameEn': 'Family & Child Specialists', 'nameAr': 'أخصائيو الأسرة والطفل'},
    {'id': 'community_org', 'sectorId': 'social', 'nameEn': 'Community Organizers', 'nameAr': 'منظمو المجتمع'},
    {'id': 'economic_support', 'sectorId': 'social', 'nameEn': 'Economic Support Officers', 'nameAr': 'مسؤولو الدعم الاقتصادي'},
    {'id': 'other_social', 'sectorId': 'social', 'nameEn': 'Other Social', 'nameAr': 'خدمات اجتماعية أخرى', 'isOtherCategory': true},
    // Legal
    {'id': 'lawyers', 'sectorId': 'legal', 'nameEn': 'Lawyers', 'nameAr': 'محامون'},
    {'id': 'advocates', 'sectorId': 'legal', 'nameEn': 'Advocates', 'nameAr': 'مدافعون حقوقيون'},
    {'id': 'mediators', 'sectorId': 'legal', 'nameEn': 'Mediators & Arbitrators', 'nameAr': 'وسطاء ومحكمون'},
    {'id': 'other_legal', 'sectorId': 'legal', 'nameEn': 'Other Legal', 'nameAr': 'خدمات قانونية أخرى', 'isOtherCategory': true},
    // Other Care
    {'id': 'housing', 'sectorId': 'other_care', 'nameEn': 'Housing Providers', 'nameAr': 'مزودو السكن'},
    {'id': 'educators', 'sectorId': 'other_care', 'nameEn': 'Educators & Teachers', 'nameAr': 'تربويون ومعلمون'},
    {'id': 'coaches', 'sectorId': 'other_care', 'nameEn': 'Life Coaches & Counselors', 'nameAr': 'مدربو حياة ومستشارون'},
    {'id': 'other_care_cat', 'sectorId': 'other_care', 'nameEn': 'Other Care', 'nameAr': 'خدمات رعاية أخرى', 'isOtherCategory': true},
  ];

  for (var cat in categories) {
    final id = cat['id'] as String;
    await db.collection('directory_categories').doc(id).set(cat);
    print("Seeded Category: $id");
  }

  // 3. Service Tags
  final serviceTags = {
    'online': {'nameEn': 'Online Delivery', 'nameAr': 'خدمة عبر الإنترنت'},
    'face_to_face': {'nameEn': 'Face to Face', 'nameAr': 'خدمة وجهاً لوجه'},
    'field': {'nameEn': 'Field Delivery', 'nameAr': 'خدمة ميدانية'},
    'consultation': {'nameEn': 'Consultation', 'nameAr': 'استشارة'},
    'operation': {'nameEn': 'Operation', 'nameAr': 'عملية'},
    'training': {'nameEn': 'Training', 'nameAr': 'تدريب'},
    'case_management': {'nameEn': 'Case Management', 'nameAr': 'إدارة حالة'},
    'rent': {'nameEn': 'Rent', 'nameAr': 'إيجار'},
    'nfi_dist': {'nameEn': 'NFI Distribution', 'nameAr': 'توزيع مواد غير غذائية'},
    'distribution': {'nameEn': 'Distribution', 'nameAr': 'توزيع'},
    'tele_support': {'nameEn': 'Tele-support', 'nameAr': 'دعم عبر الهاتف'},
    'group_session': {'nameEn': 'Group Session', 'nameAr': 'جلسة جماعية'},
    'awareness': {'nameEn': 'Awareness Campaign', 'nameAr': 'حملة توعية'},
    'referral': {'nameEn': 'Referral', 'nameAr': 'إحالة'},
    'emergency': {'nameEn': 'Emergency Response', 'nameAr': 'استجابة طارئة'},
    'rehabilitation': {'nameEn': 'Rehabilitation', 'nameAr': 'إعادة تأهيل'},
    'counseling': {'nameEn': 'Counseling', 'nameAr': 'إرشاد'},
  };

  for (var entry in serviceTags.entries) {
    await db.collection('directory_service_tags').doc(entry.key).set(entry.value);
  }

  // 4. Price Tags
  final priceTags = {
    'free': {'nameEn': 'Free Service', 'nameAr': 'خدمة مجانية', 'category': 'FREE'},
    'subsidized': {'nameEn': 'Subsidised Service', 'nameAr': 'خدمة مدعومة', 'category': 'SUBSIDIZED'},
    'full_fee': {'nameEn': 'Full Fee Service', 'nameAr': 'خدمة برسوم كاملة', 'category': 'PAID'},
    'discounted': {'nameEn': 'Discounted Rate', 'nameAr': 'خدمة بسعر مخفض', 'category': 'PAID'},
    'sliding_scale': {'nameEn': 'Sliding Scale', 'nameAr': 'خدمة برسوم متدرجة حسب القدرة', 'category': 'SUBSIDIZED'},
    'donation': {'nameEn': 'Donation-based', 'nameAr': 'خدمة قائمة على التبرع', 'category': 'FREE'},
  };

  for (var entry in priceTags.entries) {
    await db.collection('directory_price_tags').doc(entry.key).set(entry.value);
  }

  // 5. Pin Categories
  final pinCategories = {
    'clinic': {'nameEn': 'Private Clinic', 'nameAr': 'عيادة خاصة', 'iconBase': 'hospital'},
    'office': {'nameEn': 'Private Office', 'nameAr': 'مكتب خاص', 'iconBase': 'briefcase'},
    'phcc': {'nameEn': 'PHCC', 'nameAr': 'مركز رعاية صحية أولية', 'iconBase': 'heart'},
    'org': {'nameEn': 'Organization', 'nameAr': 'منظمة', 'iconBase': 'globe'},
    'company': {'nameEn': 'Company Office', 'nameAr': 'مكتب شركة', 'iconBase': 'building'},
    'home': {'nameEn': 'Home', 'nameAr': 'منزل', 'iconBase': 'home'},
    'hospital': {'nameEn': 'Hospital', 'nameAr': 'مستشفى', 'iconBase': 'hospital'},
    'school': {'nameEn': 'School', 'nameAr': 'مدرسة', 'iconBase': 'book'},
    'community_center': {'nameEn': 'Community Center', 'nameAr': 'مركز مجتمعي', 'iconBase': 'users'},
    'shelter': {'nameEn': 'Shelter', 'nameAr': 'مأوى', 'iconBase': 'tent'},
    'mobile_unit': {'nameEn': 'Mobile Unit', 'nameAr': 'وحدة متنقلة', 'iconBase': 'truck'},
    'pharmacy': {'nameEn': 'Pharmacy', 'nameAr': 'صيدلية', 'iconBase': 'pill'},
  };

  for (var entry in pinCategories.entries) {
    await db.collection('directory_pin_categories').doc(entry.key).set(entry.value);
  }

  // 6. Presence Tags
  final presenceTags = {
    '24_7': {'nameEn': '24/7', 'nameAr': 'متاح 24/7'},
    'regular': {'nameEn': 'Regular Working Hours', 'nameAr': 'ساعات العمل العادية'},
    'specific': {'nameEn': 'Specific Days', 'nameAr': 'أيام محددة'},
    'appointment': {'nameEn': 'Appointment Only', 'nameAr': 'عبر موعد مسبق'},
    'seasonal': {'nameEn': 'Seasonal', 'nameAr': 'موسمي'},
  };

  for (var entry in presenceTags.entries) {
    await db.collection('directory_presence_tags').doc(entry.key).set(entry.value);
  }

  print("--- SEEDING COMPLETE ---");
}
