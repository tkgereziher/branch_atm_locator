import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF1A237E); // Deep Blue for banking
  static const Color primaryLight = Color(0xFF534BAE);
  static const Color primaryDark = Color(0xFF000051);
  
  static const Color secondary = Color(0xFF0D47A1);
  static const Color accent = Color(0xFFFFC107); // Amber for highlighting
  
  // Status Colors
  static const Color success = Color(0xFF2E7D32); // Green for "Open"
  static const Color error = Color(0xFFC62828); // Red for "Closed/Out of service"
  static const Color warning = Color(0xFFF9A825);
  
  // Neutral Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFBDBDBD);
  
  // Custom Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary, secondary],
  );
}
