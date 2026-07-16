import 'package:flutter/material.dart';

/// GMH design system — dark fantasy: candle-lit parchment on aged oak,
/// ember-gold accents, serif display faces. Inspired by D&D rulebooks,
/// Baldur's Gate menus and Obsidian's calm density.
abstract final class GmhColors {
  static const background = Color(0xFF14100B);
  static const surface = Color(0xFF1D1712);
  static const surfaceRaised = Color(0xFF262019);
  static const surfaceHigh = Color(0xFF322A20);
  static const border = Color(0xFF3D3428);

  static const ember = Color(0xFFD9A441); // primary accent
  static const emberBright = Color(0xFFF0C775);
  static const arcane = Color(0xFF8E7CC3); // secondary accent
  static const blood = Color(0xFFA84332);

  static const parchment = Color(0xFFE8DCC8); // primary text
  static const parchmentDim = Color(0xFFB3A68F); // secondary text
  static const parchmentFaint = Color(0xFF7A6F5C); // hint text

  static const success = Color(0xFF7D9B6A);
  static const danger = Color(0xFFC4574A);
}

abstract final class GmhTheme {
  static const serifFallback = [
    'Georgia',
    'Palatino',
    'Times New Roman',
    'serif',
  ];

  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: GmhColors.ember,
      onPrimary: Color(0xFF241A08),
      secondary: GmhColors.arcane,
      onSecondary: Color(0xFF1A1424),
      surface: GmhColors.surface,
      onSurface: GmhColors.parchment,
      surfaceContainerHighest: GmhColors.surfaceHigh,
      onSurfaceVariant: GmhColors.parchmentDim,
      outline: GmhColors.border,
      error: GmhColors.danger,
      onError: Colors.white,
    );

    TextStyle display(double size, {FontWeight weight = FontWeight.w600}) =>
        TextStyle(
          fontFamilyFallback: serifFallback,
          fontSize: size,
          fontWeight: weight,
          color: GmhColors.parchment,
          letterSpacing: 0.3,
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: GmhColors.background,
      canvasColor: GmhColors.surface,
      dividerColor: GmhColors.border,
      splashFactory: InkSparkle.splashFactory,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displayLarge: display(40),
        displayMedium: display(32),
        displaySmall: display(26),
        headlineLarge: display(30),
        headlineMedium: display(24),
        headlineSmall: display(20),
        titleLarge: display(18),
        titleMedium: display(15, weight: FontWeight.w600),
        bodyLarge: const TextStyle(fontSize: 15, color: GmhColors.parchment, height: 1.5),
        bodyMedium: const TextStyle(fontSize: 13.5, color: GmhColors.parchment, height: 1.45),
        bodySmall: const TextStyle(fontSize: 12, color: GmhColors.parchmentDim),
        labelLarge: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600, color: GmhColors.parchment),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: GmhColors.background,
        foregroundColor: GmhColors.parchment,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: display(19),
      ),
      cardTheme: const CardThemeData(
        color: GmhColors.surfaceRaised,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: GmhColors.border),
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: GmhColors.surfaceRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          side: BorderSide(color: GmhColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GmhColors.surface,
        hintStyle: const TextStyle(color: GmhColors.parchmentFaint),
        labelStyle: const TextStyle(color: GmhColors.parchmentDim),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: GmhColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: GmhColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: GmhColors.ember, width: 1.4),
        ),
        isDense: true,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: GmhColors.parchmentDim,
        textColor: GmhColors.parchment,
        dense: true,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: GmhColors.surfaceHigh,
        side: const BorderSide(color: GmhColors.border),
        labelStyle: const TextStyle(fontSize: 12, color: GmhColors.parchment),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: GmhColors.surfaceHigh,
        contentTextStyle: TextStyle(color: GmhColors.parchment),
        behavior: SnackBarBehavior.floating,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: GmhColors.surface,
        indicatorColor: GmhColors.ember.withValues(alpha: 0.22),
        iconTheme: WidgetStatePropertyAll(
            const IconThemeData(color: GmhColors.parchmentDim)),
        labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(fontSize: 11.5, color: GmhColors.parchmentDim)),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: GmhColors.ember,
        unselectedLabelColor: GmhColors.parchmentDim,
        indicatorColor: GmhColors.ember,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: GmhColors.ember,
        foregroundColor: Color(0xFF241A08),
      ),
      dividerTheme: const DividerThemeData(
        color: GmhColors.border,
        thickness: 1,
        space: 1,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: GmhColors.surfaceRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: GmhColors.border),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: GmhColors.surfaceHigh,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: GmhColors.border),
        ),
        textStyle: const TextStyle(fontSize: 12, color: GmhColors.parchment),
      ),
    );
  }
}
