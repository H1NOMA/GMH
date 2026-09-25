import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/models/world.dart';
import '../theme/gmh_theme.dart';

/// A setting pack: everything that makes a world *feel* like its genre —
/// palette (dark + light), icon and the vocabulary that re-skins entity
/// kinds and a handful of template terms, in every supported language.
///
/// Vocabulary keys:
///  * `name`, `hint` — shown in the world-style chooser;
///  * `k.<kind>` / `kp.<kind>` — singular / plural label of an entity kind
///    (e.g. `k.character` = "Runner"); absent keys fall back to the base
///    (fantasy) labels from the ARB files;
///  * `t:<English template term>` — display override for a template
///    section title or field label (e.g. `t:Spell` = "Protocol"). Stored
///    values never change: skins are display-only.
@immutable
class SettingPack {
  final WorldStyle style;
  final IconData icon;
  final GmhPalette dark;
  final GmhPalette light;
  final Map<String, Map<String, String>> vocab;

  const SettingPack({
    required this.style,
    required this.icon,
    required this.dark,
    required this.light,
    required this.vocab,
  });

  String get id => style.name;

  GmhPalette palette(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  /// Localized term, falling back to English, then null (= use the base
  /// vocabulary).
  String? term(String languageCode, String key) =>
      vocab[languageCode]?[key] ?? vocab['en']?[key];
}

// ---------------------------------------------------------------- palettes

double _channel(double c) =>
    c <= 0.03928 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();

/// WCAG relative luminance.
double relativeLuminance(Color c) =>
    0.2126 * _channel(c.r) + 0.7152 * _channel(c.g) + 0.0722 * _channel(c.b);

/// WCAG contrast ratio (1..21).
double contrastRatio(Color a, Color b) {
  final la = relativeLuminance(a), lb = relativeLuminance(b);
  final hi = math.max(la, lb), lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

Color _mix(Color a, Color b, double t) => Color.lerp(a, b, t)!;

/// Moves [color] toward [toward] in small steps until it reaches [min]
/// contrast against [against] (or runs out of room).
Color _ensureContrast(Color color, Color against, double min, Color toward) {
  var c = color;
  for (var i = 0; i < 40 && contrastRatio(c, against) < min; i++) {
    c = _mix(c, toward, 0.06);
  }
  return c;
}

/// Derives a full [GmhPalette] from a handful of genre colors, enforcing
/// the contrast floors the whole UI relies on:
///  * body text >= 7:1 on the background, dim text >= 6:1, faint labels
///    >= 4.5:1 (AA for the small 10.5–12px captions they are used for) on
///    every surface tone;
///  * accent (links, chips, icons) >= 4.5:1 on surfaces, and its "on"
///    color >= 4.5:1 on the accent itself.
GmhPalette derivePalette({
  required Brightness brightness,
  required Color background,
  required Color surface,
  required Color accent,
  required Color secondary,
  required Color text,
}) {
  final dark = brightness == Brightness.dark;
  final ink = dark ? Colors.white : Colors.black;
  final raised = dark ? _mix(surface, text, 0.05) : Colors.white;
  final high = dark ? _mix(surface, text, 0.11) : _mix(background, text, 0.045);
  final border = dark ? _mix(surface, text, 0.17) : _mix(background, text, 0.13);

  // The strictest surface for text contrast checks.
  final worstSurface = dark ? high : high;
  final body = _ensureContrast(text, background, 7, ink);
  final dim = _ensureContrast(_mix(body, background, 0.3), worstSurface, 6, body);
  final faint =
      _ensureContrast(_mix(body, background, 0.5), worstSurface, 4.5, body);
  final ember = _ensureContrast(accent, worstSurface, 4.5, ink);
  final emberBright = dark
      ? _ensureContrast(_mix(ember, Colors.white, 0.35), worstSurface, 4.5, ink)
      : _ensureContrast(_mix(ember, Colors.black, 0.25), worstSurface, 4.5, ink);
  final onEmberCandidate = relativeLuminance(ember) > 0.3
      ? _mix(ember, Colors.black, 0.86)
      : _mix(ember, Colors.white, 0.92);
  final onEmber = _ensureContrast(
      onEmberCandidate,
      ember,
      4.5,
      relativeLuminance(ember) > 0.3 ? Colors.black : Colors.white);
  final arcane = _ensureContrast(secondary, worstSurface, 3.2, ink);
  Color status(Color base) => _ensureContrast(base, worstSurface, 3.2, ink);

  return GmhPalette(
    brightness: brightness,
    background: background,
    surface: surface,
    surfaceRaised: raised,
    surfaceHigh: high,
    border: border,
    ember: ember,
    emberBright: emberBright,
    onEmber: onEmber,
    arcane: arcane,
    blood: status(dark ? const Color(0xFFD0524A) : const Color(0xFFA8332C)),
    parchment: body,
    parchmentDim: dim,
    parchmentFaint: faint,
    success: status(dark ? const Color(0xFF6FBF73) : const Color(0xFF2E7D32)),
    danger: status(dark ? const Color(0xFFE5645B) : const Color(0xFFB3261E)),
  );
}
