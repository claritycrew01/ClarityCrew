import 'package:flutter/material.dart';

class ClarityColors {
  ClarityColors._();

  static const Color primary = Color(0xFF4F6DB4);
  static const Color primaryLight = Color(0xFF7B93D0);
  static const Color primaryDark = Color(0xFF3550A0);
  static const Color secondary = Color(0xFFE8A87C);
  static const Color secondaryLight = Color(0xFFF0C4A3);
  static const Color accent = Color(0xFF6BBF8A);
  static const Color accentLight = Color(0xFF96D8AE);

  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF5F6FA);
  static const Color divider = Color(0xFFE8ECF0);

  static const Color textPrimary = Color(0xFF1A1D26);
  static const Color textSecondary = Color(0xFF5A6072);
  static const Color textTertiary = Color(0xFF9CA0B0);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF6BBF8A);
  static const Color warning = Color(0xFFE8A87C);
  static const Color error = Color(0xFFD86868);
  static const Color info = Color(0xFF7B93D0);

  static const Color focusBorder = Color(0xFF4F6DB4);
  static const Color cardShadow = Color(0x1A4F6DB4);

  static const Color gradientStart = Color(0xFFF8F9FF);
  static const Color gradientEnd = Color(0xFFE8ECF8);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );

  static const LinearGradient calmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8ECF8), Color(0xFFF8F9FF)],
  );
}
