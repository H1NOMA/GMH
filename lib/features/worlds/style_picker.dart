import 'package:flutter/material.dart';

import '../../app/l10n_ext.dart';
import '../../app/packs/setting_packs.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/world.dart';

/// Grid of every setting pack: icon, name, one-line hint and a palette
/// swatch rendered in the pack's own colors, so users see the look before
/// committing to it.
class StylePickerGrid extends StatelessWidget {
  final WorldStyle selected;
  final ValueChanged<WorldStyle> onChanged;

  const StylePickerGrid({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final columns = (constraints.maxWidth / 200).floor().clamp(1, 4);
      const gap = 8.0;
      final packs = SettingPacks.all;
      // Row by row, so tiles side by side share one height even when one
      // hint wraps to fewer lines than its neighbour's.
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var start = 0; start < packs.length; start += columns) ...[
            if (start > 0) const SizedBox(height: gap),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = start; i < start + columns; i++) ...[
                    if (i > start) const SizedBox(width: gap),
                    Expanded(
                      child: i < packs.length
                          ? _StyleTile(
                              pack: packs[i],
                              selected: packs[i].style == selected,
                              onTap: () => onChanged(packs[i].style),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      );
    });
  }
}

class _StyleTile extends StatelessWidget {
  final SettingPack pack;
  final bool selected;
  final VoidCallback onTap;

  const _StyleTile({
    required this.pack,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final own = pack.palette(brightness);
    // The tile previews the pack's palette, but the outline and label stay
    // in the surrounding theme so the grid reads as one control.
    final accent = GmhColors.ember;
    return Semantics(
      selected: selected,
      button: true,
      label: pack.style.localizedName(context),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selected
                ? accent.withValues(alpha: 0.07)
                : Colors.transparent,
          ),
          // A border in the decoration would inset the content by its
          // width, so the thicker selected outline would make that tile
          // taller than its neighbours; painted on top it takes no room.
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? accent : GmhColors.border,
              width: selected ? 1.8 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Swatch(palette: own, icon: pack.icon),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pack.style.localizedName(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (selected)
                          Icon(Icons.check_circle, size: 16, color: accent),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pack.style.localizedHint(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 11,
                          height: 1.25,
                          color: GmhColors.parchmentDim),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A 40px square in the pack's background with its accent icon and a
/// secondary-color dot: a thumbnail of the pack's identity.
class _Swatch extends StatelessWidget {
  final GmhPalette palette;
  final IconData icon;
  const _Swatch({required this.palette, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: palette.border),
      ),
      child: Stack(
        children: [
          Center(child: Icon(icon, size: 20, color: palette.ember)),
          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: palette.arcane,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
