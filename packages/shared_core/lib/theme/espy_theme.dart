import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class EspyTheme {
  EspyTheme._();

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

  static const Color electricBlue  = royalBlue;
  static const Color cyan          = skyBlue;
  static const Color noir          = Color(0xFF020617);
  static const Color mahogany      = Color(0xFF451A03);
  static const Color navy          = navyDeep;

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

  static const LinearGradient goldRule = LinearGradient(
    colors: [Colors.transparent, gold, gold, Colors.transparent],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  static SystemUiOverlayStyle get systemUIOverlayDark => const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: platinum,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static TextStyle get cinzelStyle => GoogleFonts.montserrat(
    fontWeight: FontWeight.w900,
    letterSpacing: 1.5,
  );

  static TextStyle get loraStyle => GoogleFonts.montserrat(
    fontWeight: FontWeight.w400,
  );

  static TextStyle get wordmarkStyle => GoogleFonts.montserrat(
    fontSize: 36, fontWeight: FontWeight.w900, color: textWordmark, letterSpacing: 10,
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
    );
  }

  static ThemeData get noirGovernanceTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: electricBlue,
      scaffoldBackgroundColor: Color(0xFF0A192F),
      colorScheme: const ColorScheme.dark(
        primary: electricBlue,
        secondary: gold,
        surface: Color(0xFF061226),
        error: Color(0xFFEF4444),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFF2E8CE), size: 20),
        titleTextStyle: cinzelStyle.copyWith(
          fontSize: 14,
          color: Color(0xFFF2E8CE),
          letterSpacing: 3,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: cinzelStyle.copyWith(fontSize: 32, color: Color(0xFFF2E8CE)),
        displayMedium: cinzelStyle.copyWith(fontSize: 24, color: Color(0xFFF2E8CE)),
        titleLarge: cinzelStyle.copyWith(fontSize: 18, color: Color(0xFFF2E8CE)),
        bodyLarge: loraStyle.copyWith(fontSize: 16, color: Color(0xFFF2E8CE).withOpacity(0.9)),
        bodyMedium: loraStyle.copyWith(fontSize: 14, color: Color(0xFFF2E8CE).withOpacity(0.7)),
        labelLarge: cinzelStyle.copyWith(fontSize: 11, fontWeight: FontWeight.bold, color: gold),
      ),
    );
  }
}
