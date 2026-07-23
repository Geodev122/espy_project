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
      // 1. Sectors & Their Styling Templates
      _log("Seeding Sectors...");
      final sectors = {
        'health': {
          'nameEn': 'Health', 
          'nameAr': 'القطاع الطبي', 
          'iconName': 'heart', 
          'colorHex': '0xFFE91E63', 
          'displayOrder': 1,
          'template': {
            'accentColor': '0xFFE91E63',
            'iconName': 'medical_services',
            'visibleFields': ['Title', 'Price', 'Location', 'Tags', 'Image'],
          }
        },
        'mental_health': {
          'nameEn': 'Mental Health', 
          'nameAr': 'القطاع النفسي', 
          'iconName': 'brain', 
          'colorHex': '0xFF9C27B0', 
          'displayOrder': 2,
          'template': {
            'accentColor': '0xFF9C27B0',
            'iconName': 'psychology',
            'visibleFields': ['Title', 'Location', 'Tags', 'Provider Profile'],
          }
        },
        'social': {
          'nameEn': 'Social', 
          'nameAr': 'القطاع الاجتماعي', 
          'iconName': 'users', 
          'colorHex': '0xFF4CAF50', 
          'displayOrder': 3,
          'template': {
            'accentColor': '0xFF4CAF50',
            'iconName': 'groups',
            'visibleFields': ['Title', 'Location', 'Tags'],
          }
        },
        'legal': {
          'nameEn': 'Legal', 
          'nameAr': 'القطاع القانوني', 
          'iconName': 'scale', 
          'colorHex': '0xFF795548', 
          'displayOrder': 4,
          'template': {
            'accentColor': '0xFF1565C0',
            'iconName': 'gavel',
            'visibleFields': ['Title', 'Price', 'Location', 'Provider Profile'],
          }
        },
        'other_care': {
          'nameEn': 'Other Care', 
          'nameAr': 'قطاع الخدمات الأخرى', 
          'iconName': 'help', 
          'colorHex': '0xFF607D8B', 
          'displayOrder': 5,
          'template': {
            'accentColor': '0xFF607D8B',
            'iconName': 'support_agent',
            'visibleFields': ['Title', 'Price', 'Location', 'Tags'],
          }
        },
      };

      for (var entry in sectors.entries) {
        final sectorData = Map<String, dynamic>.from(entry.value);
        final templateData = sectorData.remove('template') as Map<String, dynamic>;
        
        await repo.updateSectorBranding(entry.key, sectorData);
        await repo.upsertTemplate(
          entry.key, 
          List<String>.from(templateData['visibleFields']),
          accentColor: templateData['accentColor'],
          iconName: templateData['iconName'],
        );
      }

      // 2. Global Visitor Request Template
      _log("Seeding Global Request Template...");
      await repo.upsertTemplate(
        'GLOBAL_VISITOR_REQUEST',
        ['Title', 'Description', 'Urgency', 'Location'],
        accentColor: '0xFFF9A825', // Espy Gold
        iconName: 'campaign',
      );

      // 3. Categories
      _log("Seeding Categories...");
      final categories = [
        {'id': 'doctors', 'sectorId': 'health', 'nameEn': 'Doctors', 'nameAr': 'أطباء', 'targetRole': 'PROFESSIONAL'},
        {'id': 'nurses', 'sectorId': 'health', 'nameEn': 'Nurses', 'nameAr': 'ممرضون', 'targetRole': 'PROFESSIONAL'},
        {'id': 'psychologists', 'sectorId': 'mental_health', 'nameEn': 'Psychologists', 'nameAr': 'أخصائي نفس', 'targetRole': 'PROFESSIONAL'},
        {'id': 'lawyers', 'sectorId': 'legal', 'nameEn': 'Lawyers', 'nameAr': 'محامون', 'targetRole': 'PROFESSIONAL'},
      ];

      for (var cat in categories) {
        await repo.updateCategory(cat['id']!, cat);
      }

      // 4. Metadata Tags
      _log("Seeding Tags...");
      final serviceTags = {
        'online': {'id': 'online', 'nameEn': 'Online Delivery', 'nameAr': 'خدمة عبر الإنترنت'},
        'face_to_face': {'id': 'face_to_face', 'nameEn': 'Face to Face', 'nameAr': 'خدمة وجهاً لوجه'},
        'field': {'id': 'field', 'nameEn': 'Field Delivery', 'nameAr': 'خدمة ميدانية'},
        'consultation': {'id': 'consultation', 'nameEn': 'Consultation', 'nameAr': 'استشارة'},
      };

      for (var t in serviceTags.values) { await repo.upsertServiceTag(t); }

      final priceTags = {
        'free': {'id': 'free', 'nameEn': 'Free Service', 'nameAr': 'خدمة مجانية', 'category': 'FREE'},
        'subsidized': {'id': 'subsidized', 'nameEn': 'Subsidised Service', 'nameAr': 'خدمة مدعومة', 'category': 'SUBSIDIZED'},
        'full_fee': {'id': 'full_fee', 'nameEn': 'Full Fee Service', 'nameAr': 'خدمة برسوم كاملة', 'category': 'PAID'},
      };

      for (var t in priceTags.values) { await repo.upsertPriceTag(t); }

      setState(() { _status = "PROTOCOL SEEDING COMPLETE"; });
    } catch (e) {
      debugPrint("SEED ERROR: $e");
      setState(() { _status = "ERROR: $e"; });
    } finally {
      if (mounted) setState(() { _isSeeding = false; });
    }
  }

  void _log(String msg) {
     debugPrint("[SEED] $msg");
     setState(() { _status = msg; });
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(_status, textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
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
