import 'package:flutter/material.dart';

/// Palette shared by the whole app (same look as the Order Tracker app).
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF7C3AED);
  static const Color background = Color(0xFFF6F7FB);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFEEEEEE);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF757575);

  static const LinearGradient gradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
