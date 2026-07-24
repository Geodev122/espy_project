import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:espy_core/espy_core.dart';
import 'package:espy_app/l10n/app_localizations.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';

import 'package:glassmorphism/glassmorphism.dart';

class SOSHubScreen extends StatefulWidget {
  const SOSHubScreen({super.key});

  @override
  State<SOSHubScreen> createState() => _SOSHubScreenState();
}

class _SOSHubScreenState extends State<SOSHubScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final emergencyService = Provider.of<EmergencyService>(context);

    return EspyScaffold(
      useCinematicBackground: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location, color: emergencyService.isLocating ? EspyTheme.gold : Colors.white38),
            onPressed: emergencyService.autoDetectLocation,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(l10n, emergencyService),
          Expanded(child: _buildEmergencyContacts(context, emergencyService)),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, EmergencyService vm) {
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
                color: Colors.redAccent.withValues(alpha: 0.1),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2), width: 1),
              ),
              child: const Icon(Icons.emergency_share_rounded, color: Colors.redAccent, size: 42),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "CRITICAL CHANNELS",
            style: GoogleFonts.cinzel(color: EspyTheme.gold, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 6),
          ),
          const SizedBox(height: 12),
          if (vm.isLocating)
            FadeIn(child: const Text("AUTO-DETECTING PROTOCOL SCOPE...", style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)))
          else if (vm.detectedCountryId != null)
            Text("PROTOCOL ACTIVE IN: ${vm.detectedCountryId!.toUpperCase()}", style: const TextStyle(color: Colors.greenAccent, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1))
          else
            const Text("LOCATION OFFLINE: SHOWING GLOBAL CHANNELS", style: TextStyle(color: Colors.white24, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildEmergencyContacts(BuildContext context, EmergencyService vm) {
    final l10n = AppLocalizations.of(context)!;
    final localeService = Provider.of<LocaleService>(context, listen: false);
    final isAr = localeService.locale.languageCode == 'ar';

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: vm.getEmergencySections(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
        }
        final sections = snapshot.data ?? [];
        if (sections.isEmpty) return Center(child: Text(l10n.noEmergencyChannels.toUpperCase(), style: GoogleFonts.cinzel(color: Colors.white24, fontSize: 12)));

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
          itemCount: sections.length,
          itemBuilder: (context, index) => _buildContactSection(sections[index], isAr),
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
        Text(title.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3)),
        const SizedBox(height: 20),
        ...numbers.map((number) => _buildContactCard(number, isAr)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildContactCard(Map<String, dynamic> contact, bool isAr) {
    final String label = (isAr ? contact['label_ar'] : contact['label_en']) ?? contact['label_en'] ?? 'Agency';
    final String number = contact['number'] ?? '';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 90,
        borderRadius: 24,
        blur: 15,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withValues(alpha: 0.1), Colors.white.withValues(alpha: 0.05)],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withValues(alpha: 0.2), Colors.white.withValues(alpha: 0.05)],
        ),
        child: ListTile(
          onTap: () {
            HapticFeedback.heavyImpact();
            Provider.of<EmergencyService>(context, listen: false).makeCall(number);
          },
          leading: Container(
            padding: const EdgeInsets.all(12), 
            decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.2), shape: BoxShape.circle), 
            child: const Icon(Icons.phone_forwarded, color: Colors.redAccent, size: 20)
          ),
          title: Text(label.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 12, color: Colors.white)),
          subtitle: Text(number, style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w800, color: EspyTheme.gold)),
          trailing: const Icon(Icons.chevron_right, color: Colors.white24),
        ),
      ),
    );
  }
}
