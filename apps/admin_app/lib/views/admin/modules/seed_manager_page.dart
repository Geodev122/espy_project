import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/espy_repository.dart';
import '../../../widgets/common/premium_button.dart';
import '../../../widgets/common/espy_scaffold.dart';

class SeedManagerPage extends StatefulWidget {
  const SeedManagerPage({super.key});

  @override
  State<SeedManagerPage> createState() => _SeedManagerPageState();
}

class _SeedManagerPageState extends State<SeedManagerPage> {
  bool _isSeeding = false;
  String _status = "Protocol Ready for Seeding";

  Future<void> _runSeed() async {
    setState(() { _isSeeding = true; _status = "Initializing Seeding Protocol..."; });
    final repo = context.read<EspyRepository>();

    try {
      // 1. Sectors
      final sectors = {
        'health': {'nameEn': 'Health', 'nameAr': 'القطاع الطبي', 'iconName': 'heart', 'colorHex': '0xFFE91E63', 'displayOrder': 1},
        'mental_health': {'nameEn': 'Mental Health', 'nameAr': 'القطاع النفسي', 'iconName': 'brain', 'colorHex': '0xFF9C27B0', 'displayOrder': 2},
        'social': {'nameEn': 'Social', 'nameAr': 'القطاع الاجتماعي', 'iconName': 'users', 'colorHex': '0xFF4CAF50', 'displayOrder': 3},
        'legal': {'nameEn': 'Legal', 'nameAr': 'القطاع القانوني', 'iconName': 'scale', 'colorHex': '0xFF795548', 'displayOrder': 4},
        'other_care': {'nameEn': 'Other Care', 'nameAr': 'قطاع الخدمات الأخرى', 'iconName': 'help', 'colorHex': '0xFF607D8B', 'displayOrder': 5},
      };

      for (var entry in sectors.entries) {
        await repo.updateSectorBranding(entry.key, entry.value);
      }

      // 2. Tags
      final serviceTags = {
        'online': {'id': 'online', 'nameEn': 'Online Delivery', 'nameAr': 'خدمة عبر الإنترنت'},
        'face_to_face': {'id': 'face_to_face', 'nameEn': 'Face to Face', 'nameAr': 'خدمة وجهاً لوجه'},
        'field': {'id': 'field', 'nameEn': 'Field Delivery', 'nameAr': 'خدمة ميدانية'},
        'consultation': {'id': 'consultation', 'nameEn': 'Consultation', 'nameAr': 'استشارة'},
        'operation': {'id': 'operation', 'nameEn': 'Operation', 'nameAr': 'عملية'},
        'training': {'id': 'training', 'nameEn': 'Training', 'nameAr': 'تدريب'},
        'case_management': {'id': 'case_management', 'nameEn': 'Case Management', 'nameAr': 'إدارة حالة'},
        'rent': {'id': 'rent', 'nameEn': 'Rent', 'nameAr': 'إيجار'},
        'nfi_dist': {'id': 'nfi_dist', 'nameEn': 'NFI Distribution', 'nameAr': 'توزيع مواد غير غذائية'},
        'distribution': {'id': 'distribution', 'nameEn': 'Distribution', 'nameAr': 'توزيع'},
        'tele_support': {'id': 'tele_support', 'nameEn': 'Tele-support', 'nameAr': 'دعم عبر الهاتف'},
        'group_session': {'id': 'group_session', 'nameEn': 'Group Session', 'nameAr': 'جلسة جماعية'},
        'awareness': {'id': 'awareness', 'nameEn': 'Awareness Campaign', 'nameAr': 'حملة توعية'},
        'referral': {'id': 'referral', 'nameEn': 'Referral', 'nameAr': 'إحالة'},
        'emergency': {'id': 'emergency', 'nameEn': 'Emergency Response', 'nameAr': 'استجابة طارئة'},
        'rehabilitation': {'id': 'rehabilitation', 'nameEn': 'Rehabilitation', 'nameAr': 'إعادة تأهيل'},
        'counseling': {'id': 'counseling', 'nameEn': 'Counseling', 'nameAr': 'إرشاد'},
      };

      for (var t in serviceTags.values) { await repo.upsertServiceTag(t); }

      final priceTags = {
        'free': {'id': 'free', 'nameEn': 'Free Service', 'nameAr': 'خدمة مجانية', 'category': 'FREE'},
        'subsidized': {'id': 'subsidized', 'nameEn': 'Subsidised Service', 'nameAr': 'خدمة مدعومة', 'category': 'SUBSIDIZED'},
        'full_fee': {'id': 'full_fee', 'nameEn': 'Full Fee Service', 'nameAr': 'خدمة برسوم كاملة', 'category': 'PAID'},
        'discounted': {'id': 'discounted', 'nameEn': 'Discounted Rate', 'nameAr': 'خدمة بسعر مخفض', 'category': 'PAID'},
        'sliding_scale': {'id': 'sliding_scale', 'nameEn': 'Sliding Scale', 'nameAr': 'خدمة برسوم متدرجة حسب القدرة', 'category': 'SUBSIDIZED'},
        'donation': {'id': 'donation', 'nameEn': 'Donation-based', 'nameAr': 'خدمة قائمة على التبرع', 'category': 'FREE'},
      };

      for (var t in priceTags.values) { await repo.upsertPriceTag(t); }

      final pinCategories = {
        'clinic': {'id': 'clinic', 'nameEn': 'Private Clinic', 'nameAr': 'عيادة خاصة', 'iconBase': 'hospital'},
        'office': {'id': 'office', 'nameEn': 'Private Office', 'nameAr': 'مكتب خاص', 'iconBase': 'briefcase'},
        'phcc': {'id': 'phcc', 'nameEn': 'PHCC', 'nameAr': 'مركز رعاية صحية أولية', 'iconBase': 'heart'},
        'org': {'id': 'org', 'nameEn': 'Organization', 'nameAr': 'منظمة', 'iconBase': 'globe'},
        'company': {'id': 'company', 'nameEn': 'Company Office', 'nameAr': 'مكتب شركة', 'iconBase': 'building'},
        'home': {'id': 'home', 'nameEn': 'Home', 'nameAr': 'منزل', 'iconBase': 'home'},
        'hospital': {'id': 'hospital', 'nameEn': 'Hospital', 'nameAr': 'مستشفى', 'iconBase': 'hospital'},
        'school': {'id': 'school', 'nameEn': 'School', 'nameAr': 'مدرسة', 'iconBase': 'book'},
        'community_center': {'id': 'community_center', 'nameEn': 'Community Center', 'nameAr': 'مركز مجتمعي', 'iconBase': 'users'},
        'shelter': {'id': 'shelter', 'nameEn': 'Shelter', 'nameAr': 'مأوى', 'iconBase': 'tent'},
        'mobile_unit': {'id': 'mobile_unit', 'nameEn': 'Mobile Unit', 'nameAr': 'وحدة متنقلة', 'iconBase': 'truck'},
        'pharmacy': {'id': 'pharmacy', 'nameEn': 'Pharmacy', 'nameAr': 'صيدلية', 'iconBase': 'pill'},
      };

      for (var t in pinCategories.values) { await repo.upsertPinCategory(t); }

      final presenceTags = {
        '24_7': {'id': '24_7', 'nameEn': '24/7', 'nameAr': 'متاح 24/7'},
        'regular': {'id': 'regular', 'nameEn': 'Regular Working Hours', 'nameAr': 'ساعات العمل العادية'},
        'specific': {'id': 'specific', 'nameEn': 'Specific Days', 'nameAr': 'أيام محددة'},
        'appointment': {'id': 'appointment', 'nameEn': 'Appointment Only', 'nameAr': 'عبر موعد مسبق'},
        'seasonal': {'id': 'seasonal', 'nameEn': 'Seasonal', 'nameAr': 'موسمي'},
      };

      for (var t in presenceTags.values) { await repo.upsertPresenceTag(t); }

      setState(() { _status = "PROTOCOL SEEDING COMPLETE"; });
    } catch (e) {
      setState(() { _status = "ERROR: $e"; });
    } finally {
      setState(() { _isSeeding = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(title: Text("SEEDING PROTOCOL", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            if (!_isSeeding)
              PremiumButton(label: "INITIALIZE SEED", onPressed: _runSeed),
            if (_isSeeding)
              const CircularProgressIndicator(color: EspyTheme.gold),
          ],
        ),
      ),
    );
  }
}
