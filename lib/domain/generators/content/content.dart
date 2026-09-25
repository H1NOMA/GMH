import '../../models/world.dart';
import '../content_format.dart';
import '../grammar.dart';
import 'common.dart';
import 'cosmic_horror.dart';
import 'cyberpunk.dart';
import 'fantasy.dart';
import 'gothic_horror.dart';
import 'post_apocalypse.dart';
import 'space_opera.dart';
import 'steampunk.dart';
import 'urban_fantasy.dart';
import 'wild_west.dart';
import 'wuxia.dart';

export 'common.dart' show commonContent;

/// The pack-specific content of [style].
PackContent packContent(WorldStyle style) => switch (style) {
      WorldStyle.fantasy => fantasyContent,
      WorldStyle.cyberpunk => cyberpunkContent,
      WorldStyle.spaceOpera => spaceOperaContent,
      WorldStyle.gothicHorror => gothicHorrorContent,
      WorldStyle.cosmicHorror => cosmicHorrorContent,
      WorldStyle.postApocalypse => postApocalypseContent,
      WorldStyle.steampunk => steampunkContent,
      WorldStyle.urbanFantasy => urbanFantasyContent,
      WorldStyle.wildWest => wildWestContent,
      WorldStyle.wuxia => wuxiaContent,
    };

final Map<(WorldStyle, String), FragmentLibrary> _libraries = {};

/// Pack lists layered over the shared lists, for one language.
FragmentLibrary generatorLibrary(WorldStyle style, String language) =>
    _libraries.putIfAbsent(
      (style, language),
      () => LayeredLibrary(
        [
          packContent(style).library(language),
          commonContent.library(language),
        ],
        exclusive: patternLists,
      ),
    );

/// Naming patterns a pack may replace instead of extend.
const patternLists = {
  'full_name',
  'with_epithet',
  'owner_line',
  'est_name',
  'settle_name',
  'faction_name',
};
