import '../../models/world.dart';
import '../content_format.dart';
import '../grammar.dart';
import 'common.dart';
import 'fantasy.dart';

export 'common.dart' show commonContent;

/// The pack-specific content of [style].
PackContent packContent(WorldStyle style) => switch (style) {
      WorldStyle.fantasy => fantasyContent,
      _ => fantasyContent,
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
