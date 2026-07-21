import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/espy_repository.dart';
import '../../../viewmodels/taxonomy_view_model.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';

class TaxonomyManagerScreen extends StatelessWidget {
  const TaxonomyManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaxonomyViewModel(context.read<EspyRepository>()),
      child: const _TaxonomyManagerView(),
    );
  }
}

class _TaxonomyManagerView extends StatelessWidget {
  const _TaxonomyManagerView();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TaxonomyViewModel>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("TAXONOMY PROTOCOLS", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildHeader("ACTIVE SECTORS"),
                ...viewModel.sectors.map((s) => _buildSectorTile(context, s, viewModel)),
                const SizedBox(height: 32),
                _buildHeader("TOP CATEGORIES"),
                ...viewModel.categories.map((c) => _buildCategoryTile(context, c, viewModel)),
              ],
            ),
    );
  }

  Widget _buildHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(text, style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black38, letterSpacing: 2)),
    );
  }

  Widget _buildSectorTile(BuildContext context, Map<String, dynamic> sector, TaxonomyViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(LucideIcons.globe, color: EspyTheme.royalBlue, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(sector['nameEn']?.toString().toUpperCase() ?? 'UNTITLED', style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 12)),
            ),
            IconButton(icon: const Icon(Icons.edit_rounded, size: 18), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, Map<String, dynamic> cat, TaxonomyViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(LucideIcons.tag, color: EspyTheme.gold, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(cat['nameEn']?.toString().toUpperCase() ?? 'UNTITLED', style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 11)),
            ),
            IconButton(icon: const Icon(Icons.edit_rounded, size: 18), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
