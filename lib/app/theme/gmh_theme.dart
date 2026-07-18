import 'package:flutter/material.dart';

import '../../domain/models/world.dart';

/// GMH design system — a fantasy atmosphere in a modern productivity shell
/// (Notion/Obsidian/Linear-inspired): soft rounded corners, calm density,
/// hover states, subtle depth, and full light & dark themes.
///
/// [GmhPalette] holds the actual colors; [GmhColors] is a facade of static
/// getters over the active palette so feature code can keep referencing
/// `GmhColors.x` while the theme switches at runtime.
@immutable
class GmhPalette {
  final Brightness brightness;
  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color surfaceHigh;
  final Color border;
  final Color ember;
  final Color emberBright;
  final Color onEmber;
  final Color arcane;
  final Color blood;
  final Color parchment;
  final Color parchmentDim;
  final Color parchmentFaint;
  final Color success;
  final Color danger;

  const GmhPalette({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceHigh,
    required this.border,
    required this.ember,
    required this.emberBright,
    required this.onEmber,
    required this.arcane,
    required this.blood,
    required this.parchment,
    required this.parchmentDim,
    required this.parchmentFaint,
    required this.success,
    required this.danger,
  });
}

/// Candle-lit dark: aged oak surfaces, ember gold, readable parchment text.
const gmhDarkPalette = GmhPalette(
  brightness: Brightness.dark,
  background: Color(0xFF14100B),
  surface: Color(0xFF1D1712),
  surfaceRaised: Color(0xFF262019),
  surfaceHigh: Color(0xFF322A20),
  border: Color(0xFF3D3428),
  ember: Color(0xFFD9A441),
  emberBright: Color(0xFFF0C775),
  onEmber: Color(0xFF241A08),
  arcane: Color(0xFF8E7CC3),
  blood: Color(0xFFA84332),
  parchment: Color(0xFFE8DCC8),
  parchmentDim: Color(0xFFB3A68F),
  parchmentFaint: Color(0xFF7A6F5C),
  success: Color(0xFF7D9B6A),
  danger: Color(0xFFC4574A),
);

/// Daylight parchment: warm paper, dark ink, deep gold accents —
/// high contrast while keeping the fantasy warmth.
const gmhLightPalette = GmhPalette(
  brightness: Brightness.light,
  background: Color(0xFFF6F1E7),
  surface: Color(0xFFFCF9F2),
  surfaceRaised: Color(0xFFFFFFFF),
  surfaceHigh: Color(0xFFEFE7D7),
  border: Color(0xFFDCD2BF),
  ember: Color(0xFFA8731A),
  emberBright: Color(0xFF7E5610),
  onEmber: Color(0xFFFFF6E0),
  arcane: Color(0xFF6B54A8),
  blood: Color(0xFFA84332),
  parchment: Color(0xFF2A2113),
  parchmentDim: Color(0xFF5C5240),
  parchmentFaint: Color(0xFF8B8069),
  success: Color(0xFF4C7A3D),
  danger: Color(0xFFB33B2E),
);

/// Neon noir: deep blue-black chrome, electric cyan primaries, magenta
/// secondaries — worked for contrast, not just saturation. Text stays cool
/// and readable; accents glow without burning the eyes.
const gmhCyberDarkPalette = GmhPalette(
  brightness: Brightness.dark,
  background: Color(0xFF0A0E17),
  surface: Color(0xFF0F1624),
  surfaceRaised: Color(0xFF151E31),
  surfaceHigh: Color(0xFF1C2942),
  border: Color(0xFF283A5E),
  ember: Color(0xFF2FD9E4),
  emberBright: Color(0xFF8CF2F8),
  onEmber: Color(0xFF03181C),
  arcane: Color(0xFFE05CFF),
  blood: Color(0xFFFF4365),
  parchment: Color(0xFFD7E1F4),
  parchmentDim: Color(0xFF90A2C6),
  parchmentFaint: Color(0xFF5A6A8E),
  success: Color(0xFF3DDC97),
  danger: Color(0xFFFF5C64),
);

/// Daylight chrome: cool paper-white surfaces with deep teal primaries and
/// violet secondaries — the same cyberpunk identity, tuned dark enough on
/// light backgrounds to keep AA contrast.
const gmhCyberLightPalette = GmhPalette(
  brightness: Brightness.light,
  background: Color(0xFFEDF1F8),
  surface: Color(0xFFF7FAFD),
  surfaceRaised: Color(0xFFFFFFFF),
  surfaceHigh: Color(0xFFDFE7F3),
  border: Color(0xFFC3D0E5),
  ember: Color(0xFF067F8C),
  emberBright: Color(0xFF045A64),
  onEmber: Color(0xFFE7FDFF),
  arcane: Color(0xFF8A2BC9),
  blood: Color(0xFFC42B52),
  parchment: Color(0xFF16223A),
  parchmentDim: Color(0xFF44557C),
  parchmentFaint: Color(0xFF7284A8),
  success: Color(0xFF1F8A5D),
  danger: Color(0xFFC93A44),
);

/// Facade over the active palette. The app root keeps [palette] in sync with
/// the resolved theme (see `GmhApp`); widgets read `GmhColors.x` as before.
abstract final class GmhColors {
  static GmhPalette palette = gmhDarkPalette;

  static Color get background => palette.background;
  static Color get surface => palette.surface;
  static Color get surfaceRaised => palette.surfaceRaised;
  static Color get surfaceHigh => palette.surfaceHigh;
  static Color get border => palette.border;
  static Color get ember => palette.ember;
  static Color get emberBright => palette.emberBright;
  static Color get arcane => palette.arcane;
  static Color get blood => palette.blood;
  static Color get parchment => palette.parchment;
  static Color get parchmentDim => palette.parchmentDim;
  static Color get parchmentFaint => palette.parchmentFaint;
  static Color get success => palette.success;
  static Color get danger => palette.danger;
}

/// Facade for the active world style. The shell sets [current] from the open
/// world (and the world picker resets it), so widgets — including the kind
/// label slang in `l10n_ext.dart` — follow the world without plumbing the
/// style through every constructor.
abstract final class GmhStyle {
  static WorldStyle current = WorldStyle.fantasy;

  static GmhPalette paletteFor(WorldStyle style, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return switch (style) {
      WorldStyle.fantasy => dark ? gmhDarkPalette : gmhLightPalette,
      WorldStyle.cyberpunk =>
        dark ? gmhCyberDarkPalette : gmhCyberLightPalette,
    };
  }

  static ThemeData themeFor(WorldStyle style, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return switch (style) {
      WorldStyle.fantasy => dark ? GmhTheme.dark() : GmhTheme.light(),
      WorldStyle.cyberpunk =>
        dark ? GmhTheme.cyberDark() : GmhTheme.cyberLight(),
    };
  }
}

abstract final class GmhTheme {
  static const serifFallback = [
    'Georgia',
    'Palatino',
    'Times New Roman',
    'serif',
  ];

  static ThemeData dark() => _build(gmhDarkPalette);
  static ThemeData light() => _build(gmhLightPalette);
  static ThemeData cyberDark() => _build(gmhCyberDarkPalette);
  static ThemeData cyberLight() => _build(gmhCyberLightPalette);

  static ThemeData _build(GmhPalette p) {
    final isDark = p.brightness == Brightness.dark;
    final scheme = ColorScheme(
      brightness: p.brightness,
      primary: p.ember,
      onPrimary: p.onEmber,
      secondary: p.arcane,
      onSecondary: isDark ? const Color(0xFF1A1424) : Colors.white,
      surface: p.surface,
      onSurface: p.parchment,
      surfaceContainerHighest: p.surfaceHigh,
      onSurfaceVariant: p.parchmentDim,
      outline: p.border,
      error: p.danger,
      onError: Colors.white,
    );

    TextStyle display(double size, {FontWeight weight = FontWeight.w600}) =>
        TextStyle(
          fontFamilyFallback: serifFallback,
          fontSize: size,
          fontWeight: weight,
          color: p.parchment,
          letterSpacing: 0.3,
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: p.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      canvasColor: p.surface,
      dividerColor: p.border,
      splashFactory: InkSparkle.splashFactory,
      hoverColor: p.parchment.withValues(alpha: 0.04),
      focusColor: p.ember.withValues(alpha: 0.12),
    );

    final shadow = isDark
        ? Colors.black.withValues(alpha: 0.45)
        : const Color(0xFF3D3020).withValues(alpha: 0.18);

    RoundedRectangleBorder rounded(double radius, {bool bordered = true}) =>
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: bordered ? BorderSide(color: p.border) : BorderSide.none,
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
        bodyLarge: TextStyle(fontSize: 15, color: p.parchment, height: 1.5),
        bodyMedium:
            TextStyle(fontSize: 13.5, color: p.parchment, height: 1.45),
        bodySmall: TextStyle(fontSize: 12, color: p.parchmentDim),
        labelLarge: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600, color: p.parchment),
      ),
      // Smooth, quick page transitions everywhere.
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      }),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.parchment,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: display(19),
      ),
      cardTheme: CardThemeData(
        color: p.surfaceRaised,
        elevation: isDark ? 0 : 1.5,
        shadowColor: shadow,
        margin: EdgeInsets.zero,
        shape: rounded(14),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surfaceRaised,
        elevation: 14,
        shadowColor: shadow,
        shape: rounded(20),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surfaceRaised,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        showDragHandle: true,
        dragHandleColor: p.parchmentFaint,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? p.surface : Colors.white,
        hintStyle: TextStyle(color: p.parchmentFaint),
        labelStyle: TextStyle(color: p.parchmentDim),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: p.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: p.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: p.ember, width: 1.6),
        ),
        isDense: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.ember,
          foregroundColor: p.onEmber,
          minimumSize: const Size(64, 42),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11)),
          textStyle:
              const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.ember,
          minimumSize: const Size(56, 40),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          textStyle:
              const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.parchment,
          side: BorderSide(color: p.border),
          minimumSize: const Size(64, 42),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11)),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: p.parchmentDim,
        textColor: p.parchment,
        dense: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: p.surfaceHigh,
        side: BorderSide(color: p.border),
        labelStyle: TextStyle(fontSize: 12, color: p.parchment),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? p.surfaceHigh : const Color(0xFF322A20),
        contentTextStyle:
            const TextStyle(color: Color(0xFFE8DCC8), fontSize: 13),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.surface,
        indicatorColor: p.ember.withValues(alpha: 0.2),
        iconTheme:
            WidgetStatePropertyAll(IconThemeData(color: p.parchmentDim)),
        labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 11.5, color: p.parchmentDim)),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: p.ember,
        unselectedLabelColor: p.parchmentDim,
        indicatorColor: p.ember,
        dividerColor: p.border,
        overlayColor:
            WidgetStatePropertyAll(p.parchment.withValues(alpha: 0.05)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.ember,
        foregroundColor: p.onEmber,
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme:
          DividerThemeData(color: p.border, thickness: 1, space: 1),
      popupMenuTheme: PopupMenuThemeData(
        color: p.surfaceRaised,
        elevation: 10,
        shadowColor: shadow,
        shape: rounded(12),
        textStyle: TextStyle(fontSize: 13.5, color: p.parchment),
        menuPadding: const EdgeInsets.symmetric(vertical: 6),
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 350),
        decoration: BoxDecoration(
          color: isDark ? p.surfaceHigh : const Color(0xFF322A20),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: p.border),
        ),
        textStyle: const TextStyle(fontSize: 12, color: Color(0xFFE8DCC8)),
      ),
      scrollbarTheme: ScrollbarThemeData(
        radius: const Radius.circular(8),
        thickness: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.hovered) ? 8.0 : 5.0),
        thumbColor:
            WidgetStatePropertyAll(p.parchmentFaint.withValues(alpha: 0.5)),
      ),
      checkboxTheme: CheckboxThemeData(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        side: BorderSide(color: p.parchmentFaint, width: 1.5),
      ),
    );
  }
}
