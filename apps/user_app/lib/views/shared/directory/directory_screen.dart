import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/directory_view_model.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import 'package:espy_app/l10n/app_localizations.dart';
import '../map/map_explore_screen.dart';

class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Keeping it simple for now as it was redirected to MapExploreScreen
    // but wrapping it in our standard structure
    return const EspyScaffold(
      useCinematicBackground: false,
      body: MapExploreScreen(),
    );
  }
}
