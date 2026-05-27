import 'package:flutter/material.dart';

class PitStopColors {
  const PitStopColors._();

  static const shopWarm50 = Color(0xfff5e9d9);
  static const shopWarm300 = Color(0xffc9a876);
  static const shopWarm700 = Color(0xff6b4423);
  static const diagCool50 = Color(0xffe8f4f4);
  static const diagCool500 = Color(0xff1a7b7b);
  static const diagCool900 = Color(0xff0a3737);
  static const alertRed = Color(0xffc0392b);
  static const warningAmber = Color(0xffe67e22);
  static const successGreen = Color(0xff27ae60);
  static const paper = Color(0xffffffff);
}

class PitStopText {
  const PitStopText._();

  static const header = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    height: 1.15,
    color: PitStopColors.diagCool900,
  );

  static const sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: PitStopColors.diagCool900,
  );

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: PitStopColors.diagCool900,
  );

  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    height: 1.2,
    color: PitStopColors.shopWarm700,
  );

  static const mono = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
    color: PitStopColors.diagCool900,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}

class PitStopSpacing {
  const PitStopSpacing._();

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
}

class PitStopTheme {
  const PitStopTheme._();

  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: PitStopColors.diagCool500,
        primary: PitStopColors.diagCool500,
        secondary: PitStopColors.shopWarm300,
        surface: PitStopColors.shopWarm50,
        error: PitStopColors.alertRed,
      ),
      scaffoldBackgroundColor: PitStopColors.shopWarm50,
      textTheme: const TextTheme(
        headlineMedium: PitStopText.header,
        titleMedium: PitStopText.sectionTitle,
        bodyMedium: PitStopText.body,
        labelSmall: PitStopText.caption,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: PitStopColors.diagCool500,
          foregroundColor: PitStopColors.paper,
          textStyle: PitStopText.sectionTitle,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      useMaterial3: true,
    );
  }
}
