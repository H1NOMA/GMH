import 'package:flutter/material.dart';

import '../../domain/models/world.dart';
import '../theme/gmh_theme.dart';
import 'setting_pack.dart';
import 'vocab/cosmic_horror.dart';
import 'vocab/cyberpunk.dart';
import 'vocab/fantasy.dart';
import 'vocab/gothic_horror.dart';
import 'vocab/post_apocalypse.dart';
import 'vocab/space_opera.dart';
import 'vocab/steampunk.dart';
import 'vocab/urban_fantasy.dart';
import 'vocab/wild_west.dart';
import 'vocab/wuxia.dart';

export 'setting_pack.dart';

GmhPalette _dark(int bg, int surface, int accent, int secondary, int text) =>
    derivePalette(
      brightness: Brightness.dark,
      background: Color(bg),
      surface: Color(surface),
      accent: Color(accent),
      secondary: Color(secondary),
      text: Color(text),
    );

GmhPalette _light(int bg, int surface, int accent, int secondary, int text) =>
    derivePalette(
      brightness: Brightness.light,
      background: Color(bg),
      surface: Color(surface),
      accent: Color(accent),
      secondary: Color(secondary),
      text: Color(text),
    );

/// Registry of every setting pack, in chooser order. One pack per
/// [WorldStyle] value (enforced by tests).
abstract final class SettingPacks {
  static final List<SettingPack> all = [
    const SettingPack(
      style: WorldStyle.fantasy,
      icon: Icons.auto_stories,
      dark: gmhDarkPalette,
      light: gmhLightPalette,
      vocab: fantasyVocab,
    ),
    const SettingPack(
      style: WorldStyle.cyberpunk,
      icon: Icons.memory,
      dark: gmhCyberDarkPalette,
      light: gmhCyberLightPalette,
      vocab: cyberpunkVocab,
    ),
    // Starship bridge at night-cycle: navy void, amber holo, comm blue.
    SettingPack(
      style: WorldStyle.spaceOpera,
      icon: Icons.rocket_launch_outlined,
      dark: _dark(0xFF0B0F1A, 0xFF131A2A, 0xFFF2A93B, 0xFF5AB0FF, 0xFFE6ECF5),
      light: _light(0xFFF3F5F9, 0xFFFFFFFF, 0xFFB26A00, 0xFF1F5FA8, 0xFF141B2B),
      vocab: spaceOperaVocab,
    ),
    // Candlelit decay: oxblood and bone, tarnished brass.
    SettingPack(
      style: WorldStyle.gothicHorror,
      icon: Icons.nights_stay_outlined,
      dark: _dark(0xFF120C0E, 0xFF1C1316, 0xFFD4475C, 0xFFA89B7C, 0xFFE9E1D6),
      light: _light(0xFFF4EFE8, 0xFFFCFAF6, 0xFF8E1B2E, 0xFF6B5B3A, 0xFF22171A),
      vocab: gothicHorrorVocab,
    ),
    // Investigator's archive: sepia paper, typewriter ink, eldritch green.
    SettingPack(
      style: WorldStyle.cosmicHorror,
      icon: Icons.visibility_outlined,
      dark: _dark(0xFF0E1210, 0xFF161C19, 0xFF7FD1A0, 0xFFC8A96A, 0xFFE4E6DF),
      light: _light(0xFFF2EFE6, 0xFFFBF9F3, 0xFF2F6B4A, 0xFF7A5A26, 0xFF1F2420),
      vocab: cosmicHorrorVocab,
    ),
    // Rust, dust and hazard tape.
    SettingPack(
      style: WorldStyle.postApocalypse,
      icon: Icons.warning_amber_rounded,
      dark: _dark(0xFF14110D, 0xFF1E1914, 0xFFE3B23C, 0xFFC2573A, 0xFFE8DFD0),
      light: _light(0xFFF1ECE2, 0xFFFBF8F2, 0xFF8A6200, 0xFF9A3F24, 0xFF221C15),
      vocab: postApocalypseVocab,
    ),
    // Victorian workshop: soot wood, polished brass, verdigris.
    SettingPack(
      style: WorldStyle.steampunk,
      icon: Icons.settings_suggest_outlined,
      dark: _dark(0xFF15120E, 0xFF201B15, 0xFFD39B4A, 0xFF4FA39A, 0xFFEDE3D1),
      light: _light(0xFFF5EFE3, 0xFFFCF8EF, 0xFF8C5A17, 0xFF2D6E66, 0xFF241D14),
      vocab: steampunkVocab,
    ),
    // Night city behind the veil: charcoal, sodium orange, arcane violet.
    SettingPack(
      style: WorldStyle.urbanFantasy,
      icon: Icons.location_city_outlined,
      dark: _dark(0xFF0F0F14, 0xFF18181F, 0xFFB98CFF, 0xFFF29E4C, 0xFFE7E5EE),
      light: _light(0xFFF4F3F7, 0xFFFFFFFF, 0xFF6B3FC0, 0xFFA85A12, 0xFF1B1A22),
      vocab: urbanFantasyVocab,
    ),
    // Sun-bleached frontier: saddle leather, sunset, gunmetal sky.
    SettingPack(
      style: WorldStyle.wildWest,
      icon: Icons.landscape_outlined,
      dark: _dark(0xFF16110C, 0xFF211A13, 0xFFE08A3C, 0xFF7FA7B5, 0xFFEFE4D2),
      light: _light(0xFFF6EEE1, 0xFFFDF8F0, 0xFF9C4D12, 0xFF3C6676, 0xFF2A1E12),
      vocab: wildWestVocab,
    ),
    // Ink-wash scroll: charcoal ink, rice paper, cinnabar and jade.
    SettingPack(
      style: WorldStyle.wuxia,
      icon: Icons.brush_outlined,
      dark: _dark(0xFF111312, 0xFF1A1D1B, 0xFFD9534A, 0xFF5FB39A, 0xFFECE7DC),
      light: _light(0xFFF5F1E8, 0xFFFDFBF6, 0xFFA8322B, 0xFF2F7A64, 0xFF1D1B18),
      vocab: wuxiaVocab,
    ),
  ];

  static final Map<WorldStyle, SettingPack> _byStyle = {
    for (final pack in all) pack.style: pack,
  };

  static SettingPack of(WorldStyle style) =>
      _byStyle[style] ?? _byStyle[WorldStyle.fantasy]!;
}
