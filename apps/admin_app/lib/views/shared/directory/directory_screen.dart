import 'package:flutter/material.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import '../map/map_explore_screen.dart';

class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Keeping it simple for now as it was redirected to MapExploreScreen
    // but wrapping it in our standard structure
    return EspyScaffold(
      useCinematicBackground: false,
      body: MapExploreScreen(),
    );
  }
}
