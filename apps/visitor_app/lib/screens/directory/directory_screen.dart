import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/theme/espy_theme.dart';
import '../../widgets/common/premium_card.dart';
import 'professional_details_screen.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  final FirestoreService _firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _firestore.getAllActiveServices(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
              }
              final services = snapshot.data ?? [];
              if (services.isEmpty) return _buildEmpty();

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: services.length,
                itemBuilder: (context, index) => FadeInUp(
                  delay: Duration(milliseconds: index * 50),
                  child: _buildServiceCard(services[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Text("AVAILABLE SERVICES", style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2, color: EspyTheme.navyDeep)),
          const Spacer(),
          const Icon(Icons.sort_rounded, color: EspyTheme.gold),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: EspyTheme.navyDeep.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text("NO SERVICES DISCOVERED", style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, color: EspyTheme.navyDeep.withOpacity(0.3))),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return GestureDetector(
      onTap: () {
        // Navigate to professional details if possible
        final profId = service['professionalId'] ?? service['institutionId'];
        if (profId != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ProfessionalDetailsScreen(professionalId: profId)));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: PremiumCard(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                  color: EspyTheme.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.business_center_rounded, color: EspyTheme.gold),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service['title'] ?? 'Service', style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 13, color: EspyTheme.navyDeep)),
                    Text(service['category'] ?? 'General', style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.bold, color: EspyTheme.royalBlue, letterSpacing: 1)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: EspyTheme.gold),
            ],
          ),
        ),
      ),
    );
  }
}
