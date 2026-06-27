import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme.dart';
import '../../widgets/common/premium_button.dart' as common;

class ProfessionalDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> professional;
  const ProfessionalDetailsScreen({super.key, required this.professional});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: EspyTheme.lightBlueFlame),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderInfo(l10n),
                    const SizedBox(height: 40),
                    _buildSectionTitle(l10n.aboutTheNode.toUpperCase()),
                    const SizedBox(height: 16),
                    _buildBio(l10n),
                    const SizedBox(height: 40),
                    _buildSectionTitle(l10n.expertiseAndServices.toUpperCase()),
                    const SizedBox(height: 20),
                    _buildExpertiseTags(),
                    const SizedBox(height: 48),
                    _buildActions(context, l10n),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 450,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: EspyTheme.navyDeep),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (professional['photoUrl'] != null)
              CachedNetworkImage(
                imageUrl: professional['photoUrl'],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.white10,
                  child: const Center(
                    child: CircularProgressIndicator(color: EspyTheme.cyan),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.white10,
                  child: const Icon(Icons.error, color: EspyTheme.cyan),
                ),
              )
            else
              Container(
                color: Colors.white10,
                child:
                    const Icon(Icons.person, size: 160, color: EspyTheme.cyan),
              ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: const [0.0, 0.4, 1.0],
                    colors: [
                      EspyTheme.platinum.withOpacity(0.95),
                      EspyTheme.platinum.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: FadeInLeft(
                child: Text(
                  professional['fullNameEn'] ??
                      professional['name'] ??
                      l10n.verified,
                  style: GoogleFonts.cinzel(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: EspyTheme.navyDeep,
                    height: 1.1,
                  ),
                ),
              ),
            ),
            if (professional['isVerified'] == true)
              FadeInRight(
                  child: const Icon(Icons.verified_rounded,
                      color: EspyTheme.royalBlue, size: 32)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          professional['specialization']?.toString().toUpperCase() ??
              'CARE PROVIDER',
          style: GoogleFonts.cinzel(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: EspyTheme.gold,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Icon(Icons.location_on_rounded,
                size: 18, color: EspyTheme.royalBlue),
            const SizedBox(width: 8),
            Text(
              professional['mainLocation']?['cityName'] ?? 'Lebanon',
              style: GoogleFonts.lora(
                  fontSize: 15, color: EspyTheme.navyDeep.withOpacity(0.6), fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const Icon(Icons.star_rounded, size: 20, color: EspyTheme.gold),
            const SizedBox(width: 4),
            Text(
              '4.9',
              style:
                  GoogleFonts.lora(fontWeight: FontWeight.w900, fontSize: 16, color: EspyTheme.navyDeep),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.cinzel(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 3,
        color: EspyTheme.royalBlue.withOpacity(0.6),
      ),
    );
  }

  Widget _buildBio(AppLocalizations l10n) {
    return FadeInUp(
      child: Text(
        professional['bio'] ?? l10n.defaultBioLong,
        style: GoogleFonts.lora(
          fontSize: 16,
          height: 1.8,
          color: EspyTheme.navyDeep.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildExpertiseTags() {
    final tags = professional['expertise'] as List? ??
        ['Clinical Care', 'Emergency Response', 'Patient Support'];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: tags
          .map((tag) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: EspyTheme.royalBlue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: EspyTheme.royalBlue.withOpacity(0.2)),
                ),
                child: Text(
                  tag.toString().toUpperCase(),
                  style: GoogleFonts.cinzel(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: EspyTheme.royalBlue),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildActions(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        common.PremiumButton(
          label: l10n.secureWhatsappContact.toUpperCase(),
          fullWidth: true,
          variant: common.PremiumButtonVariant.gold,
          icon: Icons.chat_bubble_rounded,
          onPressed: () {},
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: common.PremiumButton(
                label: l10n.favorite.toUpperCase(),
                variant: common.PremiumButtonVariant.outline,
                icon: Icons.favorite_border_rounded,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: common.PremiumButton(
                label: l10n.share.toUpperCase(),
                variant: common.PremiumButtonVariant.outline,
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
