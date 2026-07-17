import 'package:flutter/material.dart';
import 'package:shared_core/theme/espy_theme.dart';
import 'cinematic_background.dart';

class EspyScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final bool extendBodyBehindAppBar;
  final bool useCinematicBackground;
  final Widget? floatingActionButton;

  const EspyScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.drawer,
    this.extendBodyBehindAppBar = true,
    this.useCinematicBackground = true,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    Widget currentBody = body;
    
    if (useCinematicBackground) {
      currentBody = CinematicBackground(child: body);
    }

    return Scaffold(
      backgroundColor: EspyTheme.navyDeep,
      appBar: appBar,
      body: currentBody,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
