import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xffFF6B6B);
  static const Color secondary = Color(0xffFF8E53);

  static const LinearGradient gradient = LinearGradient(
    colors: [
      primary,
      secondary,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}