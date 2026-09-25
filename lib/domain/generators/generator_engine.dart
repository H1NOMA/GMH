import 'dart:math';

import '../dice/dice_engine.dart';
import '../models/entity_kind.dart';
import '../models/world.dart';
import 'content/content.dart';
import 'content_format.dart';
import 'grammar.dart';
import 'generator_models.dart';

export 'generator_models.dart';

typedef LibraryResolver = FragmentLibrary Function(
    WorldStyle style, String language);

/// Produces names and composite results (NPCs, settlements, hooks…) from
/// the pack content. All randomness comes from [random], so a seeded
/// engine is fully deterministic.
class GeneratorEngine {
  final Random random;
  final LibraryResolver _libraryFor;

  GeneratorEngine({Random? random, LibraryResolver? libraryFor})
      : random = random ?? Random(),
        _libraryFor = libraryFor ?? generatorLibrary;

  static int _seq = 0;

  static const abilityKeys = [
    'strength',
    'dexterity',
    'constitution',
    'intelligence',
    'wisdom',
    'charisma',
  ];

  static String normalizeLanguage(String language) =>
      generatorLanguages.contains(language) ? language : 'en';

  FragmentLibrary library(WorldStyle style, String language) =>
      _libraryFor(style, normalizeLanguage(language));

  // ------------------------------------------------------------- names

  List<NameCulture> cultures(WorldStyle style, String language) => [
        for (final f in library(style, language).list('cultures') ?? const [])
          if (f.tag != null) NameCulture(f.tag!, f.text),
      ];

  /// [count] names (1–10) of [cultureId] (random per name when null).
  List<GeneratedName> names({
    required WorldStyle style,
    required String language,
    NameGender gender = NameGender.any,
    int count = 5,
    String? cultureId,
    bool epithets = false,
  }) {
    final context = _context(style, language);
    final known = cultures(style, language);
    return [
      for (var i = 0; i < count.clamp(1, 10); i++)
        _name(
          context,
          cultureId: known.any((c) => c.id == cultureId)
              ? cultureId!
              : _randomCulture(context),
          gender: _gender(gender),
          epithet: epithets,
        ),
    ];
  }

  String _gender(NameGender gender) => switch (gender) {
        NameGender.feminine => 'f',
        NameGender.masculine => 'm',
        NameGender.any => random.nextBool() ? 'f' : 'm',
      };

  String _randomCulture(GrammarContext context) {
    final all = context.library.list('cultures') ?? const [];
    final ids = [for (final f in all) ?f.tag];
    return ids.isEmpty ? '' : ids[random.nextInt(ids.length)];
  }

  GeneratedName _name(
    GrammarContext parent, {
    required String cultureId,
    required String gender,
    bool epithet = false,
  }) {
    final c = cultureId;
    final context = parent.child({'gender': gender});
    final lib = context.library;
    final given = Grammar.expand('{${c}_given}', context);
    var full = given;
    if (lib.has('${c}_family')) {
      context.vars['given'] = given;
      context.vars['family'] = Grammar.expand('{${c}_family}', context);
      full = Grammar.expand(
          lib.has('${c}_full') ? '{${c}_full}' : '{full_name}', context);
    }
    String? epithetText;
    var display = full;
    if (epithet && lib.has('epithet')) {
      epithetText = Grammar.expand('{epithet}', context);
      context.vars['name'] = full;
      context.vars['epithet'] = epithetText;
      display = Grammar.expand('{with_epithet}', context);
    }
    final note =
        lib.has('${c}_note') ? Grammar.expand('{${c}_note}', context) : null;
    final race = lib.list(context.resolve('${c}_race'))?.first.text;
    return GeneratedName(
      name: full,
      gender: gender,
      cultureId: c,
      epithet: epithetText,
      display: display,
      note: note,
      race: race,
    );
  }

  // --------------------------------------------------------- composites

  /// A fresh result of [kind] (anything but [GeneratorKind.names]).
  GeneratedResult generate(
    GeneratorKind kind, {
    required WorldStyle style,
    required String language,
  }) {
    if (kind == GeneratorKind.names) {
      throw ArgumentError('Use names() for the name generator');
    }
    final lang = normalizeLanguage(language);
    final context = _context(style, lang);
    if (kind == GeneratorKind.npc) {
      context.vars['gender'] = random.nextBool() ? 'f' : 'm';
    }
    final specs = _specs[kind]!;
    final produced = <String, GeneratedField>{};
    for (final spec in [
      ...specs.where((s) => s.early),
      ...specs.where((s) => !s.early),
    ]) {
      produced[spec.key] = _produce(spec, context, style);
    }
    return GeneratedResult(
      id: 'g${DateTime.now().microsecondsSinceEpoch}-${_seq++}',
      kind: kind,
      style: style,
      language: lang,
      fields: [for (final s in specs) produced[s.key]!],
      titleKey: _titleKeys[kind],
      vars: Map.unmodifiable(context.vars),
      used: Set.unmodifiable(context.used),
    );
  }

  /// [result] with only [fieldKey] regenerated; it never reuses a
  /// fragment already used by the result.
  GeneratedResult rerollField(GeneratedResult result, String fieldKey) {
    final spec = _specs[result.kind]
        ?.where((s) => s.key == fieldKey)
        .firstOrNull;
    if (spec == null) return result;
    final context = GrammarContext(
      random: random,
      library: library(result.style, result.language),
      used: Set.of(result.used),
      vars: Map.of(result.vars),
    );
    final old = result.value(fieldKey);
    var field = _produce(spec, context, result.style);
    // Name-like fields are built from parts; retry a few times rather
    // than show the same text again.
    for (var i = 0; i < 4 && field.value == old; i++) {
      field = _produce(spec, context, result.style);
    }
    return result.copyWith(
      fields: [
        for (final f in result.fields) f.key == fieldKey ? field : f,
      ],
      vars: Map.unmodifiable(context.vars),
      used: Set.unmodifiable(context.used),
    );
  }

  /// Regenerates every field, keeping the card identity.
  GeneratedResult rerollAll(GeneratedResult result) {
    final fresh = generate(result.kind,
        style: result.style, language: result.language);
    return GeneratedResult(
      id: result.id,
      kind: fresh.kind,
      style: fresh.style,
      language: fresh.language,
      fields: fresh.fields,
      titleKey: fresh.titleKey,
      vars: fresh.vars,
      used: fresh.used,
    );
  }

  GrammarContext _context(WorldStyle style, String language) =>
      GrammarContext(random: random, library: library(style, language));

  GeneratedField _produce(
      _Spec spec, GrammarContext context, WorldStyle style) {
    context.takeFirstTag();
    final value = spec.produce != null
        ? spec.produce!(this, context)
        : Grammar.expand(spec.template!, context);
    final tag = context.takeFirstTag();
    spec.onTag?.call(this, context, tag);
    return GeneratedField(
      key: spec.key,
      label: spec.label,
      value: Grammar.capitalize(value),
      tag: tag,
    );
  }

  static const _titleKeys = {
    GeneratorKind.npc: 'name',
    GeneratorKind.settlement: 'name',
    GeneratorKind.establishment: 'name',
    GeneratorKind.hook: 'title',
    GeneratorKind.loot: 'container',
    GeneratorKind.faction: 'name',
  };

  static final Map<GeneratorKind, List<_Spec>> _specs = {
    GeneratorKind.npc: [
      _Spec('name', produce: (e, c) {
        final culture = c.vars['culture'] ?? e._randomCulture(c);
        c.vars['culture'] = culture;
        return e._name(c, cultureId: culture, gender: c.vars['gender']!).name;
      }),
      const _Spec('epithet', template: '{epithet}'),
      _Spec('ancestry', template: '{ancestry}', early: true,
          onTag: (e, c, tag) {
        final known = [
          for (final f in c.library.list('cultures') ?? const <Fragment>[])
            f.tag
        ];
        if (tag != null && known.contains(tag)) {
          c.vars['culture'] = tag;
        } else {
          c.vars.remove('culture');
        }
      }),
      const _Spec('role', template: '{role}'),
      const _Spec('age', template: '{age}'),
      const _Spec('appearance', template: '{appearance}'),
      const _Spec('trait', template: '{trait}'),
      const _Spec('motivation', template: '{motivation}'),
      const _Spec('secret', template: '{secret}'),
      const _Spec('voice', template: '{voice}'),
      _Spec('attributes', produce: (e, c) {
        final dice = DiceEngine(random: e.random);
        final scores = [
          for (var i = 0; i < abilityKeys.length; i++)
            dice.roll('4d6kh3').total,
        ];
        c.vars['stats'] = scores.join(',');
        return e._statLine(c.library, scores);
      }),
    ],
    GeneratorKind.settlement: const [
      _Spec('name', template: '{settle_name}'),
      _Spec('size', template: '{settle_size}'),
      _Spec('feature', template: '{settle_feature}'),
      _Spec('trouble', template: '{settle_trouble}'),
      _Spec('authority', template: '{settle_authority}'),
    ],
    GeneratorKind.establishment: [
      const _Spec('name', template: '{est_name}'),
      const _Spec('type', template: '{est_type}'),
      _Spec('owner', produce: (e, c) {
        final name = e._name(c,
            cultureId: e._randomCulture(c),
            gender: e.random.nextBool() ? 'f' : 'm');
        final owner = c.child({'owner': name.name, 'gender': name.gender});
        return Grammar.expand('{owner_line}', owner);
      }),
      const _Spec('specialty', template: '{est_specialty}'),
      const _Spec('patron', template: '{est_patron}'),
    ],
    GeneratorKind.hook: const [
      _Spec('title', template: '{hook_title}'),
      _Spec('who', template: '{hook_who}'),
      _Spec('wants', template: '{hook_wants}'),
      _Spec('obstacle', template: '{hook_obstacle}'),
      _Spec('twist', template: '{hook_twist}'),
    ],
    GeneratorKind.loot: const [
      _Spec('container', template: '{loot_container}'),
      _Spec('coins', template: '{loot_coin}'),
      _Spec('item1', label: 'item', template: '{loot_item}'),
      _Spec('item2', label: 'item', template: '{loot_item}'),
      _Spec('item3', label: 'item', template: '{loot_item}'),
      _Spec('curio', template: '{loot_curio}'),
    ],
    GeneratorKind.faction: const [
      _Spec('name', template: '{faction_name}'),
      _Spec('goal', template: '{faction_goal}'),
      _Spec('method', template: '{faction_method}'),
      _Spec('symbol', template: '{faction_symbol}'),
    ],
    GeneratorKind.weather: const [
      _Spec('sky', template: '{weather_sky}'),
      _Spec('air', template: '{weather_air}'),
      _Spec('omen', template: '{weather_omen}'),
    ],
    GeneratorKind.rumor: const [
      _Spec('rumor', template: '{rumor_text}'),
      _Spec('source', template: '{rumor_source}'),
      _Spec('truth', template: '{rumor_truth}'),
    ],
  };

  /// Field label keys in use, per kind (for the UI and tests).
  static List<String> fieldKeys(GeneratorKind kind) =>
      [for (final s in _specs[kind] ?? const <_Spec>[]) s.key];

  static Set<String> get labelKeys => {
        for (final specs in _specs.values)
          for (final s in specs) s.label,
      };

  String _statLine(FragmentLibrary lib, List<int> scores) {
    final abbr = lib.list('stat_abbr') ?? const <Fragment>[];
    return [
      for (var i = 0; i < scores.length; i++)
        '${i < abbr.length ? abbr[i].text : abilityKeys[i]} ${scores[i]}',
    ].join(' · ');
  }

  // ------------------------------------------------------------ mapping

  String _genderWord(FragmentLibrary lib, String? gender) {
    for (final f in lib.list('gender_word') ?? const <Fragment>[]) {
      if (f.tag == gender) return f.text;
    }
    return '';
  }

  /// A saved name becomes a character.
  EntityDraft nameToEntity(
      GeneratedName name, WorldStyle style, String language) {
    final lib = library(style, language);
    return EntityDraft(
      kind: EntityKind.character,
      name: name.name,
      summary: name.note ?? '',
      attributes: {
        'gender': _genderWord(lib, name.gender),
        if (name.epithet != null) 'title': name.epithet,
        if (name.race != null) 'race': name.race,
      },
    );
  }

  /// What [result] becomes when saved: the entity kind, name, summary and
  /// template attributes. [label] localizes field labels used inside
  /// multi-part text attributes.
  EntityDraft toEntity(GeneratedResult result, FieldLabeler label) {
    String v(String key) => result.value(key);
    String labeled(String key) => '${label(key)}: ${v(key)}';
    final lib = library(result.style, result.language);
    switch (result.kind) {
      case GeneratorKind.names:
        throw ArgumentError('Names are saved through nameToEntity');
      case GeneratorKind.npc:
        final scores = (result.vars['stats'] ?? '')
            .split(',')
            .map(int.tryParse)
            .toList();
        return EntityDraft(
          kind: EntityKind.character,
          name: v('name'),
          summary: [v('role'), v('trait')].join(' · '),
          attributes: {
            'title': v('epithet'),
            'race': v('ancestry'),
            'gender': _genderWord(lib, result.vars['gender']),
            'age': v('age'),
            'occupation': v('role'),
            'personalityTraits': v('trait'),
            'goals': v('motivation'),
            'secrets': v('secret'),
            'voice': v('voice'),
            'notes': v('appearance'),
            for (var i = 0; i < abilityKeys.length && i < scores.length; i++)
              if (scores[i] != null) abilityKeys[i]: scores[i],
          },
        );
      case GeneratorKind.settlement:
        return EntityDraft(
          kind: EntityKind.location,
          name: v('name'),
          summary: v('size'),
          attributes: {
            'locationType': result.field('size')?.tag ?? 'Other',
            'population': v('size'),
            'government': v('authority'),
            'sights': v('feature'),
            'hooks': v('trouble'),
          },
        );
      case GeneratorKind.establishment:
        return EntityDraft(
          kind: EntityKind.location,
          name: v('name'),
          summary: [v('type'), v('specialty')].join(' · '),
          attributes: {
            'locationType': 'Other',
            'inhabitants': [labeled('owner'), labeled('patron')].join('\n'),
            'sights': v('specialty'),
          },
        );
      case GeneratorKind.hook:
        return EntityDraft(
          kind: EntityKind.quest,
          name: v('title'),
          summary: [
            labeled('who'),
            labeled('wants'),
            labeled('obstacle'),
            labeled('twist'),
          ].join('\n'),
          attributes: {
            'status': 'Idea',
            'objectives': [
              {'text': v('wants'), 'done': false},
              {'text': v('obstacle'), 'done': false},
            ],
          },
        );
      case GeneratorKind.loot:
        return EntityDraft(
          kind: EntityKind.item,
          name: v('container'),
          summary: v('curio'),
          attributes: {
            'itemType': 'Treasure',
            'value': v('coins'),
            'properties': [
              v('item1'),
              v('item2'),
              v('item3'),
              v('curio'),
            ].join('\n'),
          },
        );
      case GeneratorKind.faction:
        return EntityDraft(
          kind: EntityKind.faction,
          name: v('name'),
          summary: v('goal'),
          attributes: {
            'factionType': result.field('name')?.tag ?? 'Other',
            'ideology': [v('goal'), labeled('method')].join('\n'),
            'resources': labeled('symbol'),
          },
        );
      case GeneratorKind.weather:
        final text = [v('sky'), v('air'), v('omen')].join('\n');
        return EntityDraft(
          kind: EntityKind.concept,
          name: shorten(v('sky')),
          summary: text,
          attributes: {'category': label('weather'), 'notes': text},
        );
      case GeneratorKind.rumor:
        return EntityDraft(
          kind: EntityKind.concept,
          name: shorten(v('rumor')),
          summary: v('rumor'),
          attributes: {
            'category': label('rumor'),
            'notes': [labeled('source'), labeled('truth')].join('\n'),
          },
        );
    }
  }

  /// Trims [text] to about [max] characters at a word boundary.
  static String shorten(String text, [int max = 60]) {
    if (text.length <= max) return text;
    final cut = text.lastIndexOf(' ', max);
    return '${text.substring(0, cut > max ~/ 2 ? cut : max).trimRight()}…';
  }
}

typedef _Produce = String Function(GeneratorEngine engine, GrammarContext c);
typedef _OnTag = void Function(
    GeneratorEngine engine, GrammarContext c, String? tag);

class _Spec {
  final String key;
  final String _label;
  final String? template;
  final _Produce? produce;
  final _OnTag? onTag;

  /// Generated before the others (it sets variables they read).
  final bool early;

  const _Spec(
    this.key, {
    String? label,
    this.template,
    this.produce,
    this.onTag,
    this.early = false,
  }) : _label = label ?? key;

  String get label => _label;
}
