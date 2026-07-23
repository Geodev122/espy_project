import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:espy_app/l10n/app_localizations.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/widgets/common/premium_button.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';

class ProfessionalDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? professional;
  final String? professionalId;
  const ProfessionalDetailsScreen({super.key, this.professional, this.professionalId});

  @override
  State<ProfessionalDetailsScreen> createState() => _ProfessionalDetailsScreenState();
}

class _ProfessionalDetailsScreenState extends State<ProfessionalDetailsScreen> {
  Map<String, dynamic>? _data;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.professional != null) {
      _data = widget.professional;
    } else if (widget.professionalId != null) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    setState(() => _loading = true);
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(widget.professionalId).get();
      if (doc.exists) {
        setState(() => _data = doc.data());
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading) return const EspyScaffold(body: Center(child: CircularProgressIndicator(color: EspyTheme.gold)));
    if (_data == null) return EspyScaffold(body: Center(child: Text(l10n.nodeDisconnected.toUpperCase(), style: const TextStyle(color: Colors.white))));

    final professional = _data!;

    return EspyScaffold(
      useCinematicBackground: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context, professional),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(l10n, professional),
                  const SizedBox(height: 40),
                  _buildSectionTitle(l10n.aboutTheNode.toUpperCase()),
                  const SizedBox(height: 16),
                  _buildBio(l10n, professional),
                  const SizedBox(height: 40),
                  _buildSectionTitle(l10n.expertiseAndServices.toUpperCase()),
                  const SizedBox(height: 20),
                  _buildExpertiseTags(professional),
                  const SizedBox(height: 48),
                  _buildActions(context, l10n, professional),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Map<String, dynamic> professional) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (professional['photoUrl'] != null)
              CachedNetworkImage(imageUrl: professional['photoUrl'], fit: BoxFit.cover)
            else
              Container(color: Colors.white10, child: const Icon(Icons.person, size: 120, color: EspyTheme.cyan)),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [EspyTheme.navyDeep.withValues(alpha: 0.9), Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(AppLocalizations l10n, Map<String, dynamic> professional) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          professional['fullNameEn'] ?? professional['name'] ?? 'SPECIALIST',
          style: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1),
        ),
        const SizedBox(height: 8),
        Text(
          professional['specialization']?.toString().toUpperCase() ?? 'CARE PROVIDER',
          style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w800, color: EspyTheme.gold, letterSpacing: 2),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Icon(Icons.location_on_rounded, size: 18, color: EspyTheme.cyan),
            const SizedBox(width: 8),
            Text(
              professional['mainLocation']?['cityName'] ?? l10n.global.toUpperCase(),
              style: GoogleFonts.montserrat(fontSize: 15, color: Colors.white70, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: EspyTheme.gold),
    );
  }

  Widget _buildBio(AppLocalizations l10n, Map<String, dynamic> professional) {
    return Text(
      professional['bio'] ?? l10n.defaultBioLong,
      style: GoogleFonts.lora(fontSize: 15, height: 1.6, color: Colors.white70),
    );
  }

  Widget _buildExpertiseTags(Map<String, dynamic> professional) {
    final tags = professional['expertise'] as List? ?? ['Clinical Care', 'Support'];
    return Wrap(
      spacing: 12, runSpacing: 12,
      children: tags.map((tag) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
        child: Text(tag.toString().toUpperCase(), style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white70)),
      )).toList(),
    );
  }

  Widget _buildActions(BuildContext context, AppLocalizations l10n, Map<String, dynamic> professional) {
    return Column(
      children: [
        PremiumButton(
          label: l10n.secureWhatsappContact.toUpperCase(),
          fullWidth: true,
          variant: PremiumButtonVariant.gold,
          icon: Icons.chat_bubble_rounded,
          onPressed: () {},
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: PremiumButton(
                label: l10n.favorite.toUpperCase(),
                variant: PremiumButtonVariant.platinum,
                icon: Icons.favorite_border_rounded,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PremiumButton(
                label: l10n.share.toUpperCase(),
                variant: PremiumButtonVariant.platinum,
                icon: Icons.share_rounded,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
