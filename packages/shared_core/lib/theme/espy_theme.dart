// ─────────────────────────────────────────────────────────────────────────────
// EspyTheme — Unified Core Theme v4.5
// Hope, Healing, Humanity
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class EspyTheme {
  EspyTheme._();

  // ═══════════════════════════════════════════════════════════════════════════
  // 1. COLORS
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Color navyDeep   = Color(0xFF0A2342); 
  static const Color navyMid    = Color(0xFF0D3060); 
  static const Color navyLight  = Color(0xFF1A5298); 
  static const Color royalMid   = Color(0xFF2979C0); 
  static const Color royalBlue  = Color(0xFF1565C0); 
  static const Color skyBlue    = Color(0xFF64B5F6); 

  static const Color goldDark   = Color(0xFFF57F17); 
  static const Color gold       = Color(0xFFF9A825); 
  static const Color goldLight  = Color(0xFFFFD54F); 

  static const Color white      = Color(0xFFFFFFFF);
  static const Color platinum   = Color(0xFFF5F9FF); 
  static const Color iceBlue    = Color(0xFFE3F2FD); 

  static const Color textPrimary      = Color(0xFF0A2342); 
  static const Color textSecondary    = Color(0x8C0A2342); 
  static const Color textOnDark       = Color(0xFFE3F2FD); 
  static const Color textOnDarkMuted  = Color(0xFFBBDEFB); 
  static const Color textWordmark     = Color(0xFF1A3C6E); 

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);

  static const Color teal = success;

  // Aliases
  static const Color navy = navyDeep;
  static const Color noir = navyDeep;
  static const Color electricBlue = royalBlue;
  static const Color cyan = skyBlue;

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. GRADIENTS
  // ═══════════════════════════════════════════════════════════════════════════

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.28, 0.62, 0.82, 1.0],
    colors: [navyDeep, navyMid, navyLight, royalMid, skyBlue],
  );

  static const LinearGradient flameBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0055FF), royalBlue, skyBlue],
    stops: [0.0, 0.4, 1.0],
  );

  static const LinearGradient cyanFlame = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0099BB), Color(0xFF00D4FF), Color(0xFFA0EFFF)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient lightBlueFlame = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [platinum, iceBlue, Color(0xFFBBDEFB)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient metallicGold = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldLight, gold, goldDark],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient metallicNoir = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navyDeep, navyMid, Color(0xFF020617)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient walletGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navyDeep, navyMid, royalBlue],
  );

  static const LinearGradient rechargeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gold, goldDark],
  );

  static const LinearGradient goldRule = LinearGradient(
    colors: [Colors.transparent, gold, gold, Colors.transparent],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. TYPOGRAPHY
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get wordmarkStyle => GoogleFonts.montserrat(
    fontSize: 36, fontWeight: FontWeight.w900, color: textWordmark, letterSpacing: 10,
  );

  static TextStyle get taglineStyle => GoogleFonts.montserrat(
    fontSize: 10, fontWeight: FontWeight.w700, color: textOnDarkMuted, letterSpacing: 4,
  );

  static TextStyle get cinzelStyle => GoogleFonts.montserrat(
    fontWeight: FontWeight.w900, letterSpacing: 1.5,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // 4. DECORATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  static BoxDecoration get cardDecoration => BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(color: navyDeep.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 4)),
    ],
  );

  static BoxDecoration get premiumCardDecoration => BoxDecoration(
    gradient: walletGradient,
    borderRadius: BorderRadius.circular(28),
    boxShadow: [
      BoxShadow(color: navyDeep.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 15)),
    ],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // 5. SYSTEM & THEMES
  // ═══════════════════════════════════════════════════════════════════════════

  static SystemUiOverlayStyle get systemUIOverlayDark => const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: platinum,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static ThemeData get metallicTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: platinum,
      primaryColor: royalBlue,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: navyDeep, size: 20),
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 13, fontWeight: FontWeight.w900,
          letterSpacing: 2, color: navyDeep,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w900, color: navyDeep, letterSpacing: 1),
        displayMedium: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w900, color: navyDeep, letterSpacing: 1),
        bodyLarge: GoogleFonts.montserrat(fontSize: 14, color: textPrimary, fontWeight: FontWeight.w500),
        bodyMedium: GoogleFonts.montserrat(fontSize: 12, color: textSecondary, fontWeight: FontWeight.w400),
        labelLarge: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w900, color: gold, letterSpacing: 1.5),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: skyBlue.withOpacity(0.3))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: royalBlue, width: 1.5)),
        labelStyle: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: navyDeep),
        hintStyle: GoogleFonts.montserrat(fontSize: 14, color: navyDeep.withOpacity(0.3)),
        prefixIconColor: navyDeep.withOpacity(0.5),
      ),
    );
  }
}
