import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppColors {
  static const secondary = Color(0xFF3B76F6);
  static const accent = Color.fromARGB(255, 30, 6, 101);
  static const accentDark = Color(0xfff6f1fc);
  static const textDark = Color(0xFF53585A);
  static const textLight = Color(0xFFF5F5F5);
  static const textFaded = Color(0xFF9899A5);
  static const iconLight = Color(0xFFB1B4C0);
  static const secoundaryLight = Color(0xfff6f1fc);
  static const iconDark = Color(0xFFB1B3C1);
  static const textHighlight = secondary;
  static const cardLight = Color(0xFFF9FAFE);
  static const primary = Color.fromARGB(255, 55, 7, 156);
  static const redLight = Color(0xffF1416C);
  static const errorLight = Color(0xffffeff3);
  static const cardDark = Color(0xFF354054);
  static const backgroundLight = Color(0xfffbf9f6);
  static const backgroundDark = Color(0xFF0d1117);
}

abstract class _LightColors {
  static const background = AppColors.backgroundLight;
  static const card = AppColors.cardLight;
  static const accent = AppColors.accent;
}

abstract class _DarkColors {
  static const background = AppColors.backgroundDark;
  static const card = AppColors.cardDark;
  static const accent = AppColors.accentDark;
}

abstract class AppTheme {
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  static ThemeData light() => ThemeData(
        visualDensity: visualDensity,
        accentColor: _LightColors.accent,
        textTheme: GoogleFonts.mulishTextTheme().apply(bodyColor: AppColors.textDark, displayColor: Colors.blueGrey[800]),
        scaffoldBackgroundColor: _LightColors.background,
        cardColor: _LightColors.card,
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        dialogTheme: const DialogTheme(backgroundColor: _LightColors.card),
        iconTheme: const IconThemeData(color: AppColors.iconDark),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
          accentColor: _LightColors.accent,
          brightness: Brightness.light,
          cardColor: _LightColors.card,
          backgroundColor: _LightColors.background,
          errorColor: AppColors.redLight,
        ),
      );

  /// Dark theme and its settings.
  static ThemeData dark() => ThemeData(
        visualDensity: visualDensity,
        textTheme: GoogleFonts.interTextTheme().apply(
          bodyColor: AppColors.textLight,
          displayColor: Colors.white
        ),
        scaffoldBackgroundColor: _DarkColors.background,
        cardColor: _DarkColors.card,
        dialogTheme: const DialogTheme(
          backgroundColor: _DarkColors.background,
          alignment: Alignment.bottomCenter,
          actionsPadding: EdgeInsets.all(20),
        ),
        accentColor: _DarkColors.accent,
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        iconTheme: const IconThemeData(color: AppColors.iconLight),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
          accentColor: _DarkColors.accent,
          brightness: Brightness.dark,
          cardColor: _DarkColors.card,
          backgroundColor: _DarkColors.background,
          errorColor: AppColors.redLight,
        ),
      );
}
