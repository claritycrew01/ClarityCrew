import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class ClarityTheme {
  ClarityTheme._();

  static ThemeData lightTheme({
    double textScale = 1.0,
    double contrastLevel = 1.0,
    bool reducedMotion = false,
    String fontFamily = 'Inter',
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily,
      colorScheme: ColorScheme.light(
        primary: ClarityColors.primary,
        secondary: ClarityColors.secondary,
        surface: ClarityColors.surface,
        error: ClarityColors.error,
        onPrimary: ClarityColors.textOnPrimary,
        onSecondary: ClarityColors.textPrimary,
        onSurface: ClarityColors.textPrimary,
      ),
      scaffoldBackgroundColor: ClarityColors.background,
      dividerColor: ClarityColors.divider,
      cardTheme: _cardTheme,
      appBarTheme: _appBarTheme,
      bottomNavigationBarTheme: _bottomNavTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      textButtonTheme: _textButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      chipTheme: _chipTheme,
      progressIndicatorTheme: _progressTheme,
      checkboxTheme: _checkboxTheme,
      sliderTheme: _sliderTheme,
    );

    return base.copyWith(
      textTheme: TextTheme(
        displayLarge: ClarityTypography.displayLarge,
        displayMedium: ClarityTypography.displayMedium,
        displaySmall: ClarityTypography.displaySmall,
        headlineLarge: ClarityTypography.headlineLarge,
        headlineMedium: ClarityTypography.headlineMedium,
        headlineSmall: ClarityTypography.headlineSmall,
        titleLarge: ClarityTypography.titleLarge,
        titleMedium: ClarityTypography.titleMedium,
        titleSmall: ClarityTypography.titleSmall,
        bodyLarge: ClarityTypography.bodyLarge,
        bodyMedium: ClarityTypography.bodyMedium,
        bodySmall: ClarityTypography.bodySmall,
        labelLarge: ClarityTypography.labelLarge,
        labelMedium: ClarityTypography.labelMedium,
        labelSmall: ClarityTypography.labelSmall,
      ),
    );
  }

  static final CardTheme _cardTheme = CardTheme(
    elevation: 0,
    color: ClarityColors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: ClarityColors.divider, width: 0.5),
    ),
    clipBehavior: Clip.antiAlias,
    margin: const EdgeInsets.only(bottom: 12),
  );

  static const AppBarTheme _appBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    backgroundColor: ClarityColors.surface,
    foregroundColor: ClarityColors.textPrimary,
    surfaceTintColor: Colors.transparent,
    titleSpacing: 0,
  );

  static const BottomNavigationBarThemeData _bottomNavTheme =
      BottomNavigationBarThemeData(
    elevation: 0,
    backgroundColor: ClarityColors.surface,
    selectedItemColor: ClarityColors.primary,
    unselectedItemColor: ClarityColors.textTertiary,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
    unselectedLabelStyle: TextStyle(fontSize: 12),
  );

  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: ClarityColors.primary,
          foregroundColor: ClarityColors.textOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: ClarityTypography.labelLarge,
          shadowColor: ClarityColors.cardShadow,
        ),
      );

  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ClarityColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

  static OutlinedButtonThemeData get _outlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ClarityColors.primary,
          side: const BorderSide(color: ClarityColors.primaryLight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  static InputDecorationTheme get _inputDecorationTheme =>
      InputDecorationTheme(
        filled: true,
        fillColor: ClarityColors.surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ClarityColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ClarityColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: ClarityColors.focusBorder, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ClarityColors.error),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );

  static ChipThemeData get _chipTheme => ChipThemeData(
        backgroundColor: ClarityColors.surfaceAlt,
        selectedColor: ClarityColors.primary.withOpacity(0.15),
        labelStyle: ClarityTypography.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );

  static const ProgressIndicatorThemeData _progressTheme =
      ProgressIndicatorThemeData(
    color: ClarityColors.primary,
    linearTrackColor: ClarityColors.divider,
  );

  static CheckboxThemeData get _checkboxTheme => CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return ClarityColors.primary;
          }
          return Colors.transparent;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      );

  static SliderThemeData get _sliderTheme => SliderThemeData(
        activeTrackColor: ClarityColors.primary,
        inactiveTrackColor: ClarityColors.divider,
        thumbColor: ClarityColors.primary,
        overlayColor: ClarityColors.primary.withOpacity(0.12),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
      );
}
