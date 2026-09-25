/// Quick rules reference for the GM Screen: short summaries (in our own
/// words) of the conditions and a few core tables of the System
/// Reference Document 5.2.1, which is licensed under CC-BY-4.0. The
/// attribution below is shown wherever this text appears.
library;

const srdAttribution =
    'This work includes material from the System Reference Document 5.2.1 '
    '("SRD 5.2.1") by Wizards of the Coast LLC, available at '
    'https://www.dndbeyond.com/srd. The SRD 5.2.1 is licensed under the '
    'Creative Commons Attribution 4.0 International License, available at '
    'https://creativecommons.org/licenses/by/4.0/legalcode.';

/// What each condition does, by condition id then language.
const conditionRules = <String, Map<String, String>>{
  'blinded': {
    'en': "Can't see and fails any check that needs sight. Attacks against it have advantage; its own attacks have disadvantage.",
    'ru': 'Не видит и проваливает проверки, требующие зрения. Атаки по нему совершаются с преимуществом, его атаки — с помехой.',
    'de': 'Kann nicht sehen und scheitert an Proben, die Sicht erfordern. Angriffe gegen es haben Vorteil, seine eigenen Nachteil.',
    'fr': 'Ne voit pas et échoue aux tests qui exigent la vue. Les attaques contre lui ont l’avantage ; les siennes, le désavantage.',
    'zh': '无法视物，需要视觉的检定自动失败。对其的攻击具有优势，其攻击具有劣势。',
  },
  'charmed': {
    'en': "Can't attack the charmer or target it with harmful abilities or magic. The charmer has advantage on checks to interact socially with it.",
    'ru': 'Не может атаковать очарователя или направлять на него вредящие способности и магию. Очарователь совершает с преимуществом проверки социального взаимодействия с ним.',
    'de': 'Kann den Bezauberer nicht angreifen oder mit schädlichen Fähigkeiten oder Magie treffen. Der Bezauberer hat Vorteil bei sozialen Proben ihm gegenüber.',
    'fr': 'Ne peut pas attaquer le charmeur ni le cibler avec des capacités ou de la magie nuisibles. Le charmeur a l’avantage aux tests d’interaction sociale avec lui.',
    'zh': '无法攻击魅惑者，也不能以有害能力或魔法指定其为目标。魅惑者对其进行社交互动的检定具有优势。',
  },
  'deafened': {
    'en': "Can't hear and fails any check that needs hearing.",
    'ru': 'Не слышит и проваливает проверки, требующие слуха.',
    'de': 'Kann nicht hören und scheitert an Proben, die Gehör erfordern.',
    'fr': 'N’entend pas et échoue aux tests qui exigent l’ouïe.',
    'zh': '无法听见，需要听觉的检定自动失败。',
  },
  'exhaustion': {
    'en': 'Stacks in levels 1–6. Every d20 test is reduced by 2 × level and speed by 5 ft × level. At level 6 the creature dies. A long rest removes one level.',
    'ru': 'Накапливается уровнями 1–6. Каждый к20-тест уменьшается на 2 × уровень, скорость — на 5 футов × уровень. На 6-м уровне существо умирает. Продолжительный отдых снимает один уровень.',
    'de': 'Stapelt sich in Stufen 1–6. Jeder W20-Test sinkt um 2 × Stufe, die Bewegungsrate um 1,5 m × Stufe. Auf Stufe 6 stirbt die Kreatur. Eine lange Rast entfernt eine Stufe.',
    'fr': 'Se cumule par niveaux de 1 à 6. Chaque test de d20 est réduit de 2 × niveau et la vitesse de 1,50 m × niveau. Au niveau 6, la créature meurt. Un repos long retire un niveau.',
    'zh': '以 1–6 级叠加。每次 d20 检定减少 2 × 等级，速度减少 5 尺 × 等级。达到 6 级时生物死亡。一次长休移除一级。',
  },
  'frightened': {
    'en': "Disadvantage on ability checks and attacks while the source of its fear is in sight; can't willingly move closer to it.",
    'ru': 'Помеха на проверки характеристик и атаки, пока источник страха в поле зрения; не может добровольно приблизиться к нему.',
    'de': 'Nachteil bei Attributsproben und Angriffen, solange die Quelle der Furcht in Sicht ist; kann sich ihr nicht freiwillig nähern.',
    'fr': 'Désavantage aux tests de caractéristique et aux attaques tant que la source de sa peur est en vue ; ne peut pas s’en approcher volontairement.',
    'zh': '恐惧来源在视线内时，属性检定和攻击具有劣势；不能主动向其靠近。',
  },
  'grappled': {
    'en': 'Speed 0. Disadvantage on attacks against anyone but the grappler, who can drag or carry it (moving at extra cost). Ends if the grappler is incapacitated or it gets out of reach.',
    'ru': 'Скорость 0. Помеха на атаки по всем, кроме схватившего; тот может тащить или нести его (перемещение дороже). Заканчивается, если схвативший недееспособен или цель вне досягаемости.',
    'de': 'Bewegungsrate 0. Nachteil bei Angriffen gegen alle außer den Packenden, der es ziehen oder tragen kann (Bewegung kostet mehr). Endet, wenn der Packende kampfunfähig ist oder es außer Reichweite gelangt.',
    'fr': 'Vitesse 0. Désavantage aux attaques contre toute autre cible que l’agrippeur, qui peut le traîner ou le porter (déplacement plus coûteux). Prend fin si l’agrippeur est neutralisé ou hors d’allonge.',
    'zh': '速度为 0。攻击擒抱者以外的目标具有劣势；擒抱者可以拖拽或携带它（移动消耗更多）。擒抱者失能或其脱离触及范围时结束。',
  },
  'incapacitated': {
    'en': "No actions, bonus actions or reactions; concentration ends; can't speak. Rolls initiative with disadvantage.",
    'ru': 'Нет действий, бонусных действий и реакций; концентрация прерывается; не может говорить. Инициатива с помехой.',
    'de': 'Keine Aktionen, Bonusaktionen oder Reaktionen; Konzentration endet; kann nicht sprechen. Initiative mit Nachteil.',
    'fr': 'Ni actions, ni actions bonus, ni réactions ; la concentration prend fin ; ne peut pas parler. Initiative avec désavantage.',
    'zh': '无法执行动作、附赠动作或反应；专注中断；无法说话。先攻检定具有劣势。',
  },
  'invisible': {
    'en': "Can't be seen: advantage on initiative, unaffected by effects that need sight of it. Attacks against it have disadvantage; its attacks have advantage — unless the other side can see it.",
    'ru': 'Его не видно: преимущество на инициативу, на него не действуют эффекты, требующие видеть цель. Атаки по нему с помехой, его атаки — с преимуществом, если противник его не видит.',
    'de': 'Nicht zu sehen: Vorteil bei der Initiative, unberührt von Effekten, die Sicht auf es erfordern. Angriffe gegen es haben Nachteil, seine Angriffe Vorteil – außer die Gegenseite kann es sehen.',
    'fr': 'Invisible : avantage à l’initiative, insensible aux effets qui exigent de le voir. Les attaques contre lui ont le désavantage, les siennes l’avantage — sauf si l’autre camp peut le voir.',
    'zh': '无法被看见：先攻具有优势，不受需要看见它的效果影响。对其的攻击具有劣势，其攻击具有优势——除非对方能看见它。',
  },
  'paralyzed': {
    'en': 'Incapacitated, speed 0. Fails Strength and Dexterity saves. Attacks against it have advantage, and hits from within 5 ft are critical hits.',
    'ru': 'Недееспособен, скорость 0. Проваливает спасброски Силы и Ловкости. Атаки по нему с преимуществом, попадания с 5 футов — критические.',
    'de': 'Kampfunfähig, Bewegungsrate 0. Scheitert an Stärke- und Geschicklichkeitsrettungswürfen. Angriffe gegen es haben Vorteil, Treffer aus 1,5 m sind kritisch.',
    'fr': 'Neutralisé, vitesse 0. Échoue aux sauvegardes de Force et de Dextérité. Les attaques contre lui ont l’avantage et les coups à 1,50 m sont critiques.',
    'zh': '失能，速度为 0。力量和敏捷豁免自动失败。对其的攻击具有优势，5 尺内命中即为重击。',
  },
  'petrified': {
    'en': 'Turned to stone with what it wears. Incapacitated, speed 0, fails Strength and Dexterity saves; attacks against it have advantage. Resistant to all damage, immune to poison.',
    'ru': 'Превращён в камень вместе со снаряжением. Недееспособен, скорость 0, проваливает спасброски Силы и Ловкости; атаки по нему с преимуществом. Сопротивление всему урону, иммунитет к яду.',
    'de': 'Samt Ausrüstung zu Stein geworden. Kampfunfähig, Bewegungsrate 0, scheitert an Stärke- und Geschicklichkeitsrettungswürfen; Angriffe gegen es haben Vorteil. Resistent gegen allen Schaden, immun gegen Gift.',
    'fr': 'Changé en pierre avec son équipement. Neutralisé, vitesse 0, échoue aux sauvegardes de Force et de Dextérité ; les attaques contre lui ont l’avantage. Résistance à tous les dégâts, immunité au poison.',
    'zh': '连同所穿戴之物化为石头。失能，速度为 0，力量和敏捷豁免自动失败；对其的攻击具有优势。对所有伤害具有抗性，免疫毒素。',
  },
  'poisoned': {
    'en': 'Disadvantage on attack rolls and ability checks.',
    'ru': 'Помеха на броски атаки и проверки характеристик.',
    'de': 'Nachteil bei Angriffswürfen und Attributsproben.',
    'fr': 'Désavantage aux jets d’attaque et aux tests de caractéristique.',
    'zh': '攻击检定和属性检定具有劣势。',
  },
  'prone': {
    'en': 'Can only crawl, or stand up using half its speed. Its attacks have disadvantage. Attacks against it have advantage from within 5 ft, disadvantage from farther away.',
    'ru': 'Может только ползти или встать, потратив половину скорости. Его атаки с помехой. Атаки по нему с 5 футов — с преимуществом, издалека — с помехой.',
    'de': 'Kann nur kriechen oder mit halber Bewegungsrate aufstehen. Seine Angriffe haben Nachteil. Angriffe gegen es haben aus 1,5 m Vorteil, aus größerer Entfernung Nachteil.',
    'fr': 'Ne peut que ramper, ou se relever en dépensant la moitié de sa vitesse. Ses attaques ont le désavantage. Les attaques contre lui ont l’avantage à 1,50 m, le désavantage au-delà.',
    'zh': '只能爬行，或消耗一半速度站起。其攻击具有劣势。5 尺内对其攻击具有优势，更远处则具有劣势。',
  },
  'restrained': {
    'en': 'Speed 0. Attacks against it have advantage; its attacks have disadvantage. Disadvantage on Dexterity saves.',
    'ru': 'Скорость 0. Атаки по нему с преимуществом, его атаки — с помехой. Помеха на спасброски Ловкости.',
    'de': 'Bewegungsrate 0. Angriffe gegen es haben Vorteil, seine eigenen Nachteil. Nachteil bei Geschicklichkeitsrettungswürfen.',
    'fr': 'Vitesse 0. Les attaques contre lui ont l’avantage, les siennes le désavantage. Désavantage aux sauvegardes de Dextérité.',
    'zh': '速度为 0。对其的攻击具有优势，其攻击具有劣势。敏捷豁免具有劣势。',
  },
  'stunned': {
    'en': 'Incapacitated. Fails Strength and Dexterity saves. Attacks against it have advantage.',
    'ru': 'Недееспособен. Проваливает спасброски Силы и Ловкости. Атаки по нему с преимуществом.',
    'de': 'Kampfunfähig. Scheitert an Stärke- und Geschicklichkeitsrettungswürfen. Angriffe gegen es haben Vorteil.',
    'fr': 'Neutralisé. Échoue aux sauvegardes de Force et de Dextérité. Les attaques contre lui ont l’avantage.',
    'zh': '失能。力量和敏捷豁免自动失败。对其的攻击具有优势。',
  },
  'unconscious': {
    'en': 'Incapacitated and prone, drops what it holds, speed 0, unaware of its surroundings. Fails Strength and Dexterity saves; attacks against it have advantage; hits from within 5 ft are critical hits.',
    'ru': 'Недееспособен и лежит, роняет то, что держит, скорость 0, не осознаёт окружение. Проваливает спасброски Силы и Ловкости; атаки по нему с преимуществом; попадания с 5 футов — критические.',
    'de': 'Kampfunfähig und liegend, lässt fallen, was es hält, Bewegungsrate 0, nimmt die Umgebung nicht wahr. Scheitert an Stärke- und Geschicklichkeitsrettungswürfen; Angriffe gegen es haben Vorteil; Treffer aus 1,5 m sind kritisch.',
    'fr': 'Neutralisé et à terre, lâche ce qu’il tient, vitesse 0, inconscient de son environnement. Échoue aux sauvegardes de Force et de Dextérité ; les attaques contre lui ont l’avantage ; les coups à 1,50 m sont critiques.',
    'zh': '失能且倒地，掉落所持物品，速度为 0，对周围毫无察觉。力量和敏捷豁免自动失败；对其的攻击具有优势；5 尺内命中即为重击。',
  },
};

/// Typical difficulty classes: label per language, then the DC.
const difficultyLadder = <(Map<String, String>, int)>[
  ({'en': 'Very easy', 'ru': 'Очень лёгкая', 'de': 'Sehr leicht', 'fr': 'Très facile', 'zh': '非常简单'}, 5),
  ({'en': 'Easy', 'ru': 'Лёгкая', 'de': 'Leicht', 'fr': 'Facile', 'zh': '简单'}, 10),
  ({'en': 'Medium', 'ru': 'Средняя', 'de': 'Mittel', 'fr': 'Moyenne', 'zh': '中等'}, 15),
  ({'en': 'Hard', 'ru': 'Сложная', 'de': 'Schwer', 'fr': 'Difficile', 'zh': '困难'}, 20),
  ({'en': 'Very hard', 'ru': 'Очень сложная', 'de': 'Sehr schwer', 'fr': 'Très difficile', 'zh': '非常困难'}, 25),
  ({'en': 'Nearly impossible', 'ru': 'Почти невозможная', 'de': 'Fast unmöglich', 'fr': 'Quasi impossible', 'zh': '几乎不可能'}, 30),
];

/// Cover and its effect.
const coverRules = <(Map<String, String>, Map<String, String>)>[
  (
    {'en': 'Half cover', 'ru': 'Укрытие наполовину', 'de': 'Halbe Deckung', 'fr': 'Abri partiel', 'zh': '半身掩护'},
    {'en': '+2 to AC and Dexterity saves', 'ru': '+2 к КД и спасброскам Ловкости', 'de': '+2 auf RK und Geschicklichkeitsrettungswürfe', 'fr': '+2 à la CA et aux sauvegardes de Dextérité', 'zh': '护甲等级与敏捷豁免 +2'},
  ),
  (
    {'en': 'Three-quarters cover', 'ru': 'Укрытие на три четверти', 'de': 'Dreivierteldeckung', 'fr': 'Abri important', 'zh': '四分之三掩护'},
    {'en': '+5 to AC and Dexterity saves', 'ru': '+5 к КД и спасброскам Ловкости', 'de': '+5 auf RK und Geschicklichkeitsrettungswürfe', 'fr': '+5 à la CA et aux sauvegardes de Dextérité', 'zh': '护甲等级与敏捷豁免 +5'},
  ),
  (
    {'en': 'Total cover', 'ru': 'Полное укрытие', 'de': 'Volle Deckung', 'fr': 'Abri total', 'zh': '全身掩护'},
    {'en': "Can't be targeted directly", 'ru': 'Нельзя выбрать целью напрямую', 'de': 'Kann nicht direkt anvisiert werden', 'fr': 'Ne peut pas être ciblé directement', 'zh': '无法被直接指定为目标'},
  ),
];

String localized(Map<String, String> texts, String languageCode) =>
    texts[languageCode] ?? texts['en']!;
