import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EspyTheme {
  EspyTheme._();

  // ═══════════════════════════════════════════════════════════════════════════
  // 1. BRAND COLORS (V3 NOIR GOVERNANCE)
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Color navyDeep   = Color(0xFF0A192F); // stop 0%
  static const Color noir       = Color(0xFF1C0A08); // headings, ink
  static const Color mahogany   = Color(0xFF6B2318); // body text, subheads
  static const Color electricBlue = Color(0xFF0077FF); // interactive
  static const Color cognac     = Color(0xFFA04830); // role signal
  static const Color gold       = Color(0xFFC08428); // focal lamp
  static const Color champagne  = Color(0xFFDEBA6A); // secondary chrome
  static const Color ivory      = Color(0xFFF2E8CE); // canvas
  static const Color cyan       = Color(0xFF00D4FF); // highlights

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. GRADIENTS
  // ═══════════════════════════════════════════════════════════════════════════

  static const LinearGradient noirGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF102A43), Color(0xFF0A192F), Color(0xFF020617)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF4D03F), Color(0xFFC08428), Color(0xFF9A7B13)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient blueFlameGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00B4DB), Color(0xFF0077FF), Color(0xFF004E92)],
    stops: [0.0, 0.5, 1.0],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. TYPOGRAPHY
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get cinzelStyle => GoogleFonts.cinzel(
    fontWeight: FontWeight.w900,
    letterSpacing: 1.5,
  );

  static TextStyle get loraStyle => GoogleFonts.lora(
    fontWeight: FontWeight.w400,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // 4. THEME DATA
  // ═══════════════════════════════════════════════════════════════════════════

  static ThemeData get noirGovernanceTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: electricBlue,
      scaffoldBackgroundColor: navyDeep,
      colorScheme: const ColorScheme.dark(
        primary: electricBlue,
        secondary: gold,
        surface: Color(0xFF061226),
        background: navyDeep,
        error: Color(0xFFEF4444),
      ),
      
      // ── AppBar ────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ivory, size: 20),
        titleTextStyle: cinzelStyle.copyWith(
          fontSize: 14,
          color: ivory,
          letterSpacing: 3,
        ),
      ),

      // ── Sidebar / Drawer ──────────────────────────────────────────────
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFF061226),
        elevation: 10,
      ),

      // ── Navigation Rail ───────────────────────────────────────────────
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: const Color(0xFF061226),
        selectedIconTheme: const IconThemeData(color: electricBlue, size: 24),
        unselectedIconTheme: IconThemeData(color: ivory.withOpacity(0.4), size: 24),
        selectedLabelTextStyle: cinzelStyle.copyWith(fontSize: 10, color: electricBlue),
        unselectedLabelTextStyle: cinzelStyle.copyWith(fontSize: 10, color: ivory.withOpacity(0.4)),
      ),

      // ── Card ──────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: const Color(0xFF0A192F),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: ivory.withOpacity(0.05)),
        ),
      ),

      // ── Typography ───────────────────────────────────────────────────
      textTheme: TextTheme(
        displayLarge: cinzelStyle.copyWith(fontSize: 32, color: ivory),
        displayMedium: cinzelStyle.copyWith(fontSize: 24, color: ivory),
        titleLarge: cinzelStyle.copyWith(fontSize: 18, color: ivory),
        bodyLarge: loraStyle.copyWith(fontSize: 16, color: ivory.withOpacity(0.9)),
        bodyMedium: loraStyle.copyWith(fontSize: 14, color: ivory.withOpacity(0.7)),
        labelLarge: cinzelStyle.copyWith(fontSize: 11, fontWeight: FontWeight.bold, color: gold),
      ),

      // ── Input ────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ivory.withOpacity(0.03),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ivory.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ivory.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: electricBlue, width: 1.5),
        ),
        labelStyle: loraStyle.copyWith(fontSize: 12, color: ivory.withOpacity(0.5)),
        hintStyle: loraStyle.copyWith(fontSize: 14, color: ivory.withOpacity(0.3)),
      ),
    );
  }
}
