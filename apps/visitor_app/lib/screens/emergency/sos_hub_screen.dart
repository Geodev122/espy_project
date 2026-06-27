import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme.dart';
import 'package:shared_core/services/emergency_service.dart';
import 'package:shared_core/services/locale_service.dart';

class SOSHubScreen extends StatefulWidget {
  const SOSHubScreen({super.key});

  @override
  State<SOSHubScreen> createState() => _SOSHubScreenState();
}

class _SOSHubScreenState extends State<SOSHubScreen> {
  final EmergencyService _emergencyService = EmergencyService();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: EspyTheme.navyDeep,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text(""), // Removed title text
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Skin
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A192F), Color(0xFF0D253F), Color(0xFF0A192F)],
                ),
              ),
            ),
          ),
          
          // Animated Glows
          Positioned(
            top: -100,
            left: -100,
            child: Opacity(
              opacity: 0.15,
              child: Container(
                width: 400, height: 400,
                decoration: const BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Colors.redAccent, Colors.transparent])),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(l10n),
                Expanded(child: _buildEmergencyContacts(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        children: [
          Pulse(
            infinite: true,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent.withOpacity(0.1),
                border: Border.all(color: Colors.redAccent.withOpacity(0.2), width: 1),
              ),
              child: const Icon(Icons.emergency_share_rounded, color: Colors.redAccent, size: 42),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "CRITICAL CHANNELS",
            style: GoogleFonts.cinzel(
              color: EspyTheme.gold,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 6,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Immediate network response units and medical assistance coordinates.",
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContacts(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeService = Provider.of<LocaleService>(context, listen: false);
    final isAr = localeService.locale.languageCode == 'ar';

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _emergencyService.getEmergencySections(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: EspyTheme.gold));
        }

        final sections = snapshot.data ?? [];

        if (sections.isEmpty) {
          return Center(
            child: Text(
              l10n.noEmergencyChannels.toUpperCase(),
              style: GoogleFonts.cinzel(
                color: Colors.white24,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
          itemCount: sections.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return FadeInUp(
              delay: Duration(milliseconds: 100 + (index * 150)),
              child: _buildContactSection(sections[index], isAr),
            );
          },
        );
      },
    );
  }

  Widget _buildContactSection(Map<String, dynamic> section, bool isAr) {
    final List numbers = section['numbers'] ?? [];
    final String title = (isAr ? section['name_ar'] : section['name_en']) ?? section['name_en'] ?? 'OTHER';

    return Column(
      crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isAr ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isAr) Container(width: 4, height: 16, decoration: BoxDecoration(color: EspyTheme.gold, borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                title.toUpperCase(),
                style: GoogleFonts.cinzel(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 3),
              ),
            ),
            if (isAr) Container(width: 4, height: 16, decoration: BoxDecoration(color: EspyTheme.gold, borderRadius: BorderRadius.circular(2))),
          ],
        ),
        const SizedBox(height: 20),
        ...numbers.map((number) => _buildContactCard(number, isAr)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildContactCard(Map<String, dynamic> contact, bool isAr) {
    final String label = (isAr ? contact['label_ar'] : contact['label_en']) ?? contact['label_en'] ?? 'Agency';
    final String number = contact['number'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: InkWell(
            onTap: () {
              HapticFeedback.heavyImpact();
              _emergencyService.makeCall(number);
            },
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.phone_forwarded_rounded, color: Colors.redAccent, size: 24),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          label.toUpperCase(),
                          style: GoogleFonts.cinzel(
                              fontWeight: FontWeight.w900, fontSize: 14, color: Colors.white, letterSpacing: 1),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          number,
                          style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: EspyTheme.gold,
                              letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
