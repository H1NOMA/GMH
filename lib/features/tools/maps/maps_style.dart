import 'package:flutter/material.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/maps/map_geometry.dart';
import '../../../domain/maps/map_pin.dart';

IconData pinIconData(MapPinIcon icon) => switch (icon) {
  MapPinIcon.pin => Icons.place,
  MapPinIcon.castle => Icons.castle,
  MapPinIcon.town => Icons.location_city,
  MapPinIcon.dungeon => Icons.stairs,
  MapPinIcon.cave => Icons.landslide,
  MapPinIcon.forest => Icons.forest,
  MapPinIcon.mountain => Icons.terrain,
  MapPinIcon.port => Icons.anchor,
  MapPinIcon.danger => Icons.dangerous,
  MapPinIcon.treasure => Icons.diamond,
  MapPinIcon.quest => Icons.priority_high,
  MapPinIcon.camp => Icons.local_fire_department,
  MapPinIcon.npc => Icons.person_pin,
  MapPinIcon.portal => Icons.cyclone,
  MapPinIcon.note => Icons.sticky_note_2,
};

String pinIconLabel(AppLocalizations l, MapPinIcon icon) => switch (icon) {
  MapPinIcon.pin => l.mapsIconPin,
  MapPinIcon.castle => l.mapsIconCastle,
  MapPinIcon.town => l.mapsIconTown,
  MapPinIcon.dungeon => l.mapsIconDungeon,
  MapPinIcon.cave => l.mapsIconCave,
  MapPinIcon.forest => l.mapsIconForest,
  MapPinIcon.mountain => l.mapsIconMountain,
  MapPinIcon.port => l.mapsIconPort,
  MapPinIcon.danger => l.mapsIconDanger,
  MapPinIcon.treasure => l.mapsIconTreasure,
  MapPinIcon.quest => l.mapsIconQuest,
  MapPinIcon.camp => l.mapsIconCamp,
  MapPinIcon.npc => l.mapsIconNpc,
  MapPinIcon.portal => l.mapsIconPortal,
  MapPinIcon.note => l.mapsIconNote,
};

String pinColorLabel(AppLocalizations l, MapPinColor color) => switch (color) {
  MapPinColor.auto => l.mapsColorAuto,
  MapPinColor.ember => l.mapsColorAccent,
  MapPinColor.red => l.mapsColorRed,
  MapPinColor.orange => l.mapsColorOrange,
  MapPinColor.yellow => l.mapsColorYellow,
  MapPinColor.green => l.mapsColorGreen,
  MapPinColor.teal => l.mapsColorTeal,
  MapPinColor.blue => l.mapsColorBlue,
  MapPinColor.purple => l.mapsColorPurple,
  MapPinColor.pink => l.mapsColorPink,
  MapPinColor.gray => l.mapsColorGray,
};

/// Theme-safe color of a pin. [entityColor] is the linked entry's color,
/// which [MapPinColor.auto] follows.
Color pinColor(MapPinColor color, {Color? entityColor}) {
  Color fixed(int argb) => adaptiveAccent(Color(argb));
  return switch (color) {
    MapPinColor.auto => entityColor ?? GmhColors.ember,
    MapPinColor.ember => GmhColors.ember,
    MapPinColor.red => fixed(0xFFD4483C),
    MapPinColor.orange => fixed(0xFFE07A2A),
    MapPinColor.yellow => fixed(0xFFD9AE1E),
    MapPinColor.green => fixed(0xFF55A04A),
    MapPinColor.teal => fixed(0xFF2A9D8F),
    MapPinColor.blue => fixed(0xFF3D7DD8),
    MapPinColor.purple => fixed(0xFF8E5BD0),
    MapPinColor.pink => fixed(0xFFD6559A),
    MapPinColor.gray => fixed(0xFF8A8580),
  };
}

String measureRuleLabel(AppLocalizations l, MeasureRule rule) =>
    switch (rule) {
      MeasureRule.straight => l.mapsRuleStraight,
      MeasureRule.gridSimple => l.mapsRuleGrid,
      MeasureRule.gridAlternating => l.mapsRuleAlternating,
    };

/// Round marker of a pin: the symbol on its color, ringed with the surface
/// color so it reads on any map image.
class PinBadge extends StatelessWidget {
  final MapPinIcon icon;
  final Color color;
  final double size;
  final bool selected;
  final bool faded;

  const PinBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 32,
    this.selected = false,
    this.faded = false,
  });

  @override
  Widget build(BuildContext context) {
    final fill = faded ? color.withValues(alpha: 0.55) : color;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? GmhColors.parchment : GmhColors.surface,
          width: selected ? 3 : 2,
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(pinIconData(icon), size: size * 0.55, color: readableOn(color)),
    );
  }
}

/// How far a text button's label starts from its own edge. A button that
/// sits under text is shifted by this much so its label lines up with it.
double textButtonInset(BuildContext context) =>
    Theme.of(context)
        .textButtonTheme
        .style
        ?.padding
        ?.resolve(const {})
        ?.resolve(Directionality.of(context))
        .left ??
    12;
