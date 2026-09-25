/// The 15 conditions of the System Reference Document 5.2.1 (CC-BY-4.0,
/// attribution in the GM Screen tool and the Help screen), used by the
/// combat tracker's condition chips and the GM Screen reference.
///
/// Ids are stable storage values (combatants store them); names are
/// localized here. Full rules text lives with the GM Screen reference.
class SrdCondition {
  final String id;
  final Map<String, String> names;

  const SrdCondition(this.id, this.names);

  String name(String languageCode) => names[languageCode] ?? names['en']!;
}

const srdConditions = <SrdCondition>[
  SrdCondition('blinded', {'en': 'Blinded', 'ru': 'Ослеплён', 'de': 'Blind', 'fr': 'Aveuglé', 'zh': '目盲'}),
  SrdCondition('charmed', {'en': 'Charmed', 'ru': 'Очарован', 'de': 'Bezaubert', 'fr': 'Charmé', 'zh': '魅惑'}),
  SrdCondition('deafened', {'en': 'Deafened', 'ru': 'Оглох', 'de': 'Taub', 'fr': 'Assourdi', 'zh': '耳聋'}),
  SrdCondition('exhaustion', {'en': 'Exhaustion', 'ru': 'Истощение', 'de': 'Erschöpfung', 'fr': 'Épuisement', 'zh': '力竭'}),
  SrdCondition('frightened', {'en': 'Frightened', 'ru': 'Испуган', 'de': 'Verängstigt', 'fr': 'Effrayé', 'zh': '恐慌'}),
  SrdCondition('grappled', {'en': 'Grappled', 'ru': 'Схвачен', 'de': 'Gepackt', 'fr': 'Agrippé', 'zh': '受擒'}),
  SrdCondition('incapacitated', {'en': 'Incapacitated', 'ru': 'Недееспособен', 'de': 'Kampfunfähig', 'fr': 'Neutralisé', 'zh': '失能'}),
  SrdCondition('invisible', {'en': 'Invisible', 'ru': 'Невидим', 'de': 'Unsichtbar', 'fr': 'Invisible', 'zh': '隐形'}),
  SrdCondition('paralyzed', {'en': 'Paralyzed', 'ru': 'Парализован', 'de': 'Gelähmt', 'fr': 'Paralysé', 'zh': '麻痹'}),
  SrdCondition('petrified', {'en': 'Petrified', 'ru': 'Окаменел', 'de': 'Versteinert', 'fr': 'Pétrifié', 'zh': '石化'}),
  SrdCondition('poisoned', {'en': 'Poisoned', 'ru': 'Отравлен', 'de': 'Vergiftet', 'fr': 'Empoisonné', 'zh': '中毒'}),
  SrdCondition('prone', {'en': 'Prone', 'ru': 'Сбит с ног', 'de': 'Liegend', 'fr': 'À terre', 'zh': '倒地'}),
  SrdCondition('restrained', {'en': 'Restrained', 'ru': 'Опутан', 'de': 'Festgesetzt', 'fr': 'Entravé', 'zh': '束缚'}),
  SrdCondition('stunned', {'en': 'Stunned', 'ru': 'Ошеломлён', 'de': 'Betäubt', 'fr': 'Étourdi', 'zh': '震慑'}),
  SrdCondition('unconscious', {'en': 'Unconscious', 'ru': 'Без сознания', 'de': 'Bewusstlos', 'fr': 'Inconscient', 'zh': '昏迷'}),
];

SrdCondition? conditionById(String id) {
  for (final c in srdConditions) {
    if (c.id == id) return c;
  }
  return null;
}
