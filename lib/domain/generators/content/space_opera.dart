import '../content_format.dart';

/// Star empires, smugglers and silent alien ships.
final spaceOperaContent =
    PackContent.build(rows: _rows, names: _names, perLang: _perLang);

const _names = <String, String>{
  'spacer_given_f': '''
Juno ¦ Джуно ¦ 朱诺
Vega ¦ Вега ¦ 维加
Ines ¦ Инес ¦ 伊内丝
Amara ¦ Амара ¦ 阿玛拉
Kira ¦ Кира ¦ 基拉
Reya ¦ Рея ¦ 蕾娅
Oriane ¦ Ориана ¦ 奥丽安
Selin ¦ Селин ¦ 塞琳
Nadia ¦ Надя ¦ 娜迪娅
Ximena ¦ Химена ¦ 希梅娜
Asha ¦ Аша ¦ 阿莎
Lyra ¦ Лира ¦ 莱拉
Tove ¦ Туве ¦ 托薇
''',
  'spacer_given_m': '''
Orion ¦ Орион ¦ 奥利安
Cassius ¦ Кассий ¦ 卡修斯
Dex ¦ Декс ¦ 德克斯
Tomas ¦ Томас ¦ 托马斯
Rian ¦ Риан ¦ 瑞安
Emeka ¦ Эмека ¦ 埃梅卡
Yusuf ¦ Юсуф ¦ 优素福
Callum ¦ Каллум ¦ 卡勒姆
Anders ¦ Андерс ¦ 安德斯
Kai ¦ Кай ¦ 凯
Mirek ¦ Мирек ¦ 米雷克
Santiago ¦ Сантьяго ¦ 圣地亚哥
Teodor ¦ Теодор ¦ 特奥多尔
''',
  'spacer_family': '''
Okafor-Lind ¦ Окафор-Линд ¦ 奥卡福-林德
Marchetti ¦ Маркетти ¦ 马尔凯蒂
Ishikawa ¦ Исикава ¦ 石川
Drummond ¦ Драммонд ¦ 德拉蒙德
Adeyemi ¦ Адейеми ¦ 阿德耶米
Kestrel ¦ Кестрел ¦ 凯斯特雷尔
Halloran ¦ Хэллоран ¦ 哈洛兰
Novak ¦ Новак ¦ 诺瓦克
Sandoval ¦ Сандовал ¦ 桑多瓦尔
Brightwater ¦ Брайтуотер ¦ 布赖特沃特
Farrow ¦ Фэрроу ¦ 法罗
Oduya ¦ Одуя ¦ 奥杜亚
Reinholt ¦ Райнхольт ¦ 莱因霍尔特
Tanaka-Bell ¦ Танака-Белл ¦ 田中-贝尔
''',
  'alien_given': '''
{alien_pre}{alien_end}
{alien_pre}{alien_mid}{alien_end}
''',
  'alien_pre': '''
Xar ¦ Ксар ¦ 夏尔
Vek ¦ Век ¦ 维克
Qua ¦ Ква ¦ 夸
Ith ¦ Ит ¦ 伊斯
Kri ¦ Кри ¦ 克里
Zo ¦ Зо ¦ 佐
Thrae ¦ Трэй ¦ 斯雷
Ool ¦ Ул ¦ 乌尔
Nak ¦ Нак ¦ 纳克
Syr ¦ Сир ¦ 希尔
''',
  'alien_mid': '''
ra ¦ ра ¦ 拉
ix ¦ икс ¦ 伊克斯
uu ¦ уу ¦ 乌
ssa ¦ сса ¦ 萨
ko ¦ ко ¦ 科
tel ¦ тел ¦ 泰尔
''',
  'alien_end': '''
'ath ¦ 'ат ¦ 阿斯
'eth ¦ 'эт ¦ 埃斯
un ¦ ун ¦ 恩
orr ¦ орр ¦ 奥尔
'is ¦ 'ис ¦ 伊丝
ae ¦ э ¦ 埃
ek ¦ ек ¦ 埃克
uun ¦ уун ¦ 乌恩
sha ¦ ша ¦ 莎
''',
};

const _rows = <String, String>{
  'cultures': '''
@spacer Spacers ¦ Космолётчики ¦ Raumfahrer ¦ Spatiaux ¦ 星际旅人
@alien Alien ¦ Инопланетные ¦ Außerirdisch ¦ Extraterrestres ¦ 外星种族
''',
  'alien_family': '''
of the Ninth Brood ¦ из Девятого выводка ¦ aus der Neunten Brut ¦ de la Neuvième Couvée ¦ 第九巢
of the Drowned Moon ¦ с Утонувшей луны ¦ vom Ertrunkenen Mond ¦ de la Lune noyée ¦ 沉月
of the Glass Reef ¦ со Стеклянного рифа ¦ vom Gläsernen Riff ¦ du Récif de verre ¦ 玻璃礁
of the Long Silence ¦ из Долгого Безмолвия ¦ aus der Langen Stille ¦ du Long Silence ¦ 长寂
of the Third Hive ¦ из Третьего улья ¦ aus dem Dritten Schwarm ¦ de la Troisième Ruche ¦ 第三蜂巢
of the Burning Ring ¦ с Пылающего кольца ¦ vom Brennenden Ring ¦ de l'Anneau ardent ¦ 燃环
of the Deep Current ¦ из Глубинного течения ¦ aus der Tiefen Strömung ¦ du Courant profond ¦ 深流
of the Seven Suns ¦ из рода Семи солнц ¦ von den Sieben Sonnen ¦ des Sept Soleils ¦ 七日
of the Hollow Star ¦ с Полой звезды ¦ vom Hohlen Stern ¦ de l'Étoile creuse ¦ 空星
of the Silver Spawning ¦ из Серебряного нереста ¦ aus dem Silbernen Laich ¦ du Frai d'argent ¦ 银卵
''',
  'alien_full': '''
{=given} {=family} ¦ {=given} {=family} ¦ {=given} {=family} ¦ {=given} {=family} ¦ {=family}的{=given}
''',
  'epithet': '''
Starfall ¦ Звездопад ¦ Sternenfall ¦ Chute-d'Étoiles ¦ 星陨
the Ghost of Kessler Station ¦ Призрак станции Кесслер ¦ das Gespenst der Kessler-Station ¦ le Fantôme de la station Kessler ¦ 凯斯勒站幽灵
Two-Jumps ¦ Два Прыжка ¦ Zwei-Sprünge ¦ Deux-Sauts ¦ 两跃
the Hull-Walker ¦ Ходящий по Обшивке~Ходящая по Обшивке ¦ der Hüllenläufer~die Hüllenläuferin ¦ l'Arpenteur de Coque~l'Arpenteuse de Coque ¦ 舱壳行者
Vacuum-Proof ¦ Вакуумостойкий~Вакуумостойкая ¦ Vakuumfest ¦ Anti-Vide ¦ 真空不侵
the Admiral ¦ Адмирал ¦ der Admiral~die Admiralin ¦ l'Amiral~l'Amirale ¦ “将军”
Cold-Sleep ¦ Криосон ¦ Kälteschlaf ¦ Cryo ¦ 冷眠
Void-Lucky ¦ Везунчик Пустоты~Везунья Пустоты ¦ Leerenglück ¦ Chance-du-Vide ¦ 虚空幸运儿
the Last Pilot of Vey ¦ Последний пилот Вея ¦ der letzte Pilot von Vey~die letzte Pilotin von Vey ¦ le Dernier Pilote de Vey~la Dernière Pilote de Vey ¦ 维伊的最后一名飞行员
Red-Shift ¦ Красное Смещение ¦ Rotverschiebung ¦ Décalage-Rouge ¦ 红移
''',
  'ancestry': '''
@spacer human from the core worlds ¦ человек из Центральных миров ¦ Mensch aus den Kernwelten ¦ humain des Mondes centraux~humaine des Mondes centraux ¦ 核心星域人类
@spacer station-born human ¦ уроженец станции~уроженка станции ¦ Stationsgeborener~Stationsgeborene ¦ humain né sur une station~humaine née sur une station ¦ 空间站出生的人类
@alien Vesh ¦ веш ¦ Vesh ¦ Vesh ¦ 维什人
@alien Korr ¦ корр ¦ Korr ¦ Korr ¦ 科尔人
@alien Tallan ¦ таллан~талланка ¦ Tallaner~Tallanerin ¦ Tallan~Tallane ¦ 塔兰人
synthetic android ¦ синтетический андроид ¦ synthetischer Androide ¦ androïde synthétique ¦ 合成人
@spacer gene-adapted colonist ¦ генетически адаптированный колонист~генетически адаптированная колонистка ¦ genetisch angepasster Kolonist~genetisch angepasste Kolonistin ¦ colon génétiquement adapté~colone génétiquement adaptée ¦ 基因改造殖民者
''',
  'role': '''
freighter captain ¦ капитан грузовика ¦ Frachterkapitän~Frachterkapitänin ¦ capitaine de cargo ¦ 货船船长
smuggler ¦ контрабандист~контрабандистка ¦ Schmuggler~Schmugglerin ¦ contrebandier~contrebandière ¦ 走私犯
station mechanic ¦ механик станции ¦ Stationsmechaniker~Stationsmechanikerin ¦ mécanicien de station~mécanicienne de station ¦ 空间站机械师
imperial customs officer ¦ имперский таможенник~имперская таможенница ¦ imperialer Zollbeamter~imperiale Zollbeamtin ¦ douanier impérial~douanière impériale ¦ 帝国海关官员
xenobiologist ¦ ксенобиолог ¦ Xenobiologe~Xenobiologin ¦ xénobiologiste ¦ 外星生物学家
bounty hunter ¦ охотник за головами~охотница за головами ¦ Kopfgeldjäger~Kopfgeldjägerin ¦ chasseur de primes~chasseuse de primes ¦ 赏金猎人
diplomatic envoy ¦ дипломатический посланник~дипломатическая посланница ¦ diplomatischer Gesandter~diplomatische Gesandte ¦ envoyé diplomatique~envoyée diplomatique ¦ 外交使节
navigator for hire ¦ наёмный штурман ¦ Navigator zur Miete~Navigatorin zur Miete ¦ navigateur à louer~navigatrice à louer ¦ 受雇领航员
cantina owner ¦ хозяин кантины~хозяйка кантины ¦ Kantinenwirt~Kantinenwirtin ¦ patron de cantina~patronne de cantina ¦ 酒吧老板
veteran of the frontier war ¦ ветеран пограничной войны ¦ Veteran des Grenzkriegs~Veteranin des Grenzkriegs ¦ vétéran de la guerre des confins ¦ 边境战争老兵
salvage diver ¦ ныряльщик за обломками~ныряльщица за обломками ¦ Bergungstaucher~Bergungstaucherin ¦ plongeur de récupération~plongeuse de récupération ¦ 残骸打捞员
temple keeper of a dead religion ¦ хранитель храма мёртвой религии~хранительница храма мёртвой религии ¦ Tempelhüter einer toten Religion~Tempelhüterin einer toten Religion ¦ gardien du temple d'une religion morte~gardienne du temple d'une religion morte ¦ 已消亡宗教的神殿守护人
''',
  'appearance': '''
a flight suit covered in faded mission patches ¦ лётный комбинезон в выцветших нашивках миссий ¦ ein Fluganzug voller verblasster Missionsabzeichen ¦ une combinaison de vol couverte d'écussons de mission délavés ¦ 贴满褪色任务徽章的飞行服
skin with the faint blue tint of long cryosleep ¦ кожа с лёгким голубым оттенком от долгого криосна ¦ Haut mit dem bläulichen Ton langen Kälteschlafs ¦ une peau légèrement bleutée par un long cryosommeil ¦ 长期冷冻休眠留下的淡蓝肤色
a translator implant blinking at the temple ¦ имплант-переводчик, мигающий на виске ¦ ein Übersetzerimplantat, das an der Schläfe blinkt ¦ un implant traducteur qui clignote à la tempe ¦ 太阳穴上闪烁的翻译植入体
magnetic boots worn even in full gravity ¦ магнитные ботинки, которые не снимаются даже при гравитации ¦ Magnetstiefel, selbst bei voller Schwerkraft getragen ¦ des bottes magnétiques portées même en gravité normale ¦ 在有重力的地方也穿着磁力靴
an imperial medal pinned upside down ¦ имперская медаль, приколотая вверх ногами ¦ ein kopfüber angesteckter imperialer Orden ¦ une médaille impériale épinglée à l'envers ¦ 倒着别的帝国勋章
eyes adapted to a dimmer sun ¦ глаза, привыкшие к тусклому солнцу ¦ Augen, die an eine schwächere Sonne gewöhnt sind ¦ des yeux adaptés à un soleil plus pâle ¦ 适应了暗淡恒星的双眼
''',
  'motivation': '''
buy a ship of their own ¦ купить собственный корабль ¦ ein eigenes Schiff kaufen ¦ acheter son propre vaisseau ¦ 买下属于自己的飞船
find the coordinates of a lost homeworld ¦ найти координаты потерянной родной планеты ¦ die Koordinaten einer verlorenen Heimatwelt finden ¦ retrouver les coordonnées d'un monde natal perdu ¦ 找到失落母星的坐标
clear their name with the Imperial Navy ¦ очистить своё имя перед Имперским флотом ¦ den eigenen Namen bei der Imperialen Flotte reinwaschen ¦ laver son nom auprès de la Flotte impériale ¦ 在帝国舰队面前洗清罪名
get home before the jump gate closes forever ¦ вернуться домой, пока врата не закрылись навсегда ¦ nach Hause kommen, bevor das Sprungtor für immer schließt ¦ rentrer avant que la porte de saut ne se ferme à jamais ¦ 在跃迁门永久关闭前回家
pay the crew what it is owed ¦ выплатить экипажу всё, что ему должны ¦ der Crew zahlen, was ihr zusteht ¦ payer à l'équipage ce qui lui est dû ¦ 付清欠船员的工钱
be the first to chart a nebula ¦ первым нанести туманность на карту~первой нанести туманность на карту ¦ als Erstes einen Nebel kartieren ¦ être le premier à cartographier une nébuleuse~être la première à cartographier une nébuleuse ¦ 成为第一个绘制某星云图的人
''',
  'secret': '''
was built, not born ¦ был создан, а не рождён~была создана, а не рождена ¦ wurde gebaut, nicht geboren ¦ a été construit, pas né~a été construite, pas née ¦ 是被制造出来的，而非出生
works for the enemy fleet ¦ работает на вражеский флот ¦ arbeitet für die feindliche Flotte ¦ travaille pour la flotte ennemie ¦ 在为敌方舰队效力
carries a stolen star map in an implant ¦ хранит в импланте украденную звёздную карту ¦ trägt eine gestohlene Sternkarte im Implantat ¦ cache une carte stellaire volée dans un implant ¦ 植入体里藏着一张偷来的星图
is the last survivor of a planet the Empire erased ¦ последний выживший с планеты, стёртой Империей~последняя выжившая с планеты, стёртой Империей ¦ ist der letzte Überlebende eines vom Imperium ausgelöschten Planeten~ist die letzte Überlebende eines vom Imperium ausgelöschten Planeten ¦ est le dernier survivant d'une planète effacée par l'Empire~est la dernière survivante d'une planète effacée par l'Empire ¦ 是被帝国抹除的星球上最后的幸存者
hears transmissions from a dead ship ¦ слышит передачи с мёртвого корабля ¦ empfängt Funksprüche eines toten Schiffes ¦ capte les transmissions d'un vaisseau mort ¦ 能收到一艘死船发来的讯号
sold an old crew to pirates ¦ продал прежний экипаж пиратам~продала прежний экипаж пиратам ¦ hat die alte Crew an Piraten verkauft ¦ a vendu son ancien équipage à des pirates ¦ 把旧船员出卖给了海盗
''',
  'settle_size': '''
@Landmark an outpost with a crew of {#2d6*5} ¦ аванпост на {#2d6*5} человек ¦ ein Außenposten mit {#2d6*5} Leuten Besatzung ¦ un avant-poste de {#2d6*5} membres d'équipage ¦ 驻员{#2d6*5}人的前哨站
@Town an orbital station of {#3d6*100} people ¦ орбитальная станция, около {#3d6*100} жителей ¦ eine Orbitalstation mit {#3d6*100} Bewohnern ¦ une station orbitale de {#3d6*100} habitants ¦ 住着{#3d6*100}人的轨道空间站
@City a colony city of {#2d10*5000} settlers ¦ колониальный город, около {#2d10*5000} поселенцев ¦ eine Kolonialstadt mit {#2d10*5000} Siedlern ¦ une ville coloniale de {#2d10*5000} colons ¦ 有{#2d10*5000}名殖民者的殖民城市
@Plane a hive world of {#1d6+1} billion souls ¦ мир-улей, население — {#1d6+1} млрд ¦ eine Makropolwelt mit {#1d6+1} Milliarden Seelen ¦ un monde-ruche de {#1d6+1} milliards d'âmes ¦ 人口{#1d6+1}0亿的巢都世界
''',
  'settle_feature': '''
a docking ring older than the Empire ¦ стыковочное кольцо старше Империи ¦ ein Andockring, älter als das Imperium ¦ un anneau d'amarrage plus ancien que l'Empire ¦ 比帝国还古老的对接环
hydroponic gardens that feed half the sector ¦ гидропонные сады, кормящие полсектора ¦ Hydrokulturgärten, die den halben Sektor ernähren ¦ des jardins hydroponiques qui nourrissent la moitié du secteur ¦ 供养半个星区的水培花园
an alien ruin built into the station's core ¦ руины пришельцев, встроенные в ядро станции ¦ eine Alien-Ruine im Kern der Station ¦ une ruine extraterrestre intégrée au cœur de la station ¦ 嵌在空间站核心里的外星遗迹
a cantina where every species is welcome ¦ кантина, где рады любому виду ¦ eine Kantine, in der jede Spezies willkommen ist ¦ une cantina où toutes les espèces sont bienvenues ¦ 欢迎所有种族的酒吧
a viewing deck facing a black hole ¦ смотровая палуба с видом на чёрную дыру ¦ ein Aussichtsdeck mit Blick auf ein Schwarzes Loch ¦ un pont d'observation face à un trou noir ¦ 正对黑洞的观景甲板
a shipyard building a vessel no one ordered ¦ верфь, строящая корабль, который никто не заказывал ¦ eine Werft, die ein Schiff baut, das niemand bestellt hat ¦ un chantier naval qui construit un vaisseau que nul n'a commandé ¦ 正在建造一艘无人订购的飞船的船坞
a memorial wall listing ships lost in the war ¦ мемориальная стена с названиями кораблей, погибших на войне ¦ eine Gedenkwand mit den im Krieg verlorenen Schiffen ¦ un mur du souvenir listant les vaisseaux perdus à la guerre ¦ 刻着战争中损失舰船名字的纪念墙
artificial gravity that fails on Tuesdays ¦ искусственная гравитация, отказывающая по вторникам ¦ künstliche Schwerkraft, die dienstags ausfällt ¦ une gravité artificielle qui lâche le mardi ¦ 每逢周二就失灵的人造重力
a market in the shadow of a dead star ¦ рынок в тени мёртвой звезды ¦ ein Markt im Schatten eines toten Sterns ¦ un marché à l'ombre d'une étoile morte ¦ 死星阴影下的市集
a comm tower that receives signals from the future ¦ башня связи, принимающая сигналы из будущего ¦ ein Funkturm, der Signale aus der Zukunft empfängt ¦ une tour de communication qui capte des signaux du futur ¦ 能接收未来讯号的通讯塔
''',
  'settle_trouble': '''
life support is failing in the lower rings ¦ на нижних кольцах отказывает система жизнеобеспечения ¦ die Lebenserhaltung versagt in den unteren Ringen ¦ le support vital lâche dans les anneaux inférieurs ¦ 下层环区的生命维持系统正在失灵
an imperial blockade has cut off supplies ¦ имперская блокада перекрыла поставки ¦ eine imperiale Blockade hat den Nachschub abgeschnitten ¦ un blocus impérial a coupé les ravitaillements ¦ 帝国封锁切断了补给
a parasite is spreading through the water recyclers ¦ паразит распространяется через водоочистители ¦ ein Parasit breitet sich über die Wasseraufbereitung aus ¦ un parasite se propage par les recycleurs d'eau ¦ 一种寄生虫正通过水循环系统扩散
pirates demand tribute every cycle ¦ пираты требуют дань каждый цикл ¦ Piraten fordern jeden Zyklus Tribut ¦ des pirates exigent un tribut à chaque cycle ¦ 海盗每个周期都来索要贡品
an alien ship has parked in orbit and will not answer ¦ инопланетный корабль встал на орбите и не отвечает ¦ ein fremdes Schiff parkt im Orbit und antwortet nicht ¦ un vaisseau extraterrestre s'est garé en orbite et ne répond pas ¦ 一艘外星飞船停在轨道上，毫无回应
the governor has declared martial law ¦ губернатор ввёл военное положение ¦ die Gouverneurin hat das Kriegsrecht verhängt ¦ la gouverneure a décrété la loi martiale ¦ 总督宣布了戒严
the jump beacon has gone silent ¦ прыжковый маяк замолчал ¦ die Sprungbake ist verstummt ¦ la balise de saut s'est tue ¦ 跃迁信标失去了信号
miners are on strike after a cave-in ¦ шахтёры бастуют после обвала ¦ Bergleute streiken nach einem Einsturz ¦ les mineurs sont en grève après un éboulement ¦ 矿工因塌方而罢工
refugees keep arriving from a war nobody reports ¦ прибывают беженцы с войны, о которой никто не сообщает ¦ ständig kommen Flüchtlinge aus einem Krieg, über den niemand berichtet ¦ des réfugiés arrivent d'une guerre dont personne ne parle ¦ 难民不断从一场无人报道的战争中涌来
the station AI has started asking questions ¦ ИИ станции начал задавать вопросы ¦ die Stations-KI hat begonnen, Fragen zu stellen ¦ l'IA de la station a commencé à poser des questions ¦ 空间站AI开始提问了
''',
  'settle_authority': '''
an imperial governor counting the days to retirement ¦ имперский губернатор, считающий дни до отставки ¦ ein imperialer Gouverneur, der die Tage bis zur Pension zählt ¦ un gouverneur impérial qui compte les jours avant la retraite ¦ 数着日子等退休的帝国总督
the mining guild's board of directors ¦ правление гильдии шахтёров ¦ der Vorstand der Bergbaugilde ¦ le conseil d'administration de la guilde minière ¦ 矿业行会董事会
a station AI with a legal mandate ¦ ИИ станции с законными полномочиями ¦ eine Stations-KI mit gesetzlichem Mandat ¦ une IA de station dotée d'un mandat légal ¦ 拥有法定授权的空间站AI
a council of captains who vote by cargo weight ¦ совет капитанов, голосующих весом груза ¦ ein Rat von Kapitänen, die nach Frachtgewicht abstimmen ¦ un conseil de capitaines qui votent au poids de leur cargaison ¦ 按货物重量投票的船长议会
an alien matriarch nobody may look at directly ¦ инопланетная матриарх, на которую нельзя смотреть прямо ¦ eine fremde Matriarchin, die niemand direkt ansehen darf ¦ une matriarche extraterrestre qu'on ne peut regarder en face ¦ 不能直视的外星女族长
a rebel commander posing as a mayor ¦ командир повстанцев, выдающий себя за мэра ¦ ein Rebellenkommandant, der sich als Bürgermeister ausgibt ¦ un commandant rebelle qui se fait passer pour maire ¦ 冒充市长的叛军指挥官
the chief medical officer, for lack of anyone else ¦ главный врач — просто потому, что больше некому ¦ die Chefärztin, mangels Alternative ¦ la médecin-chef, faute de mieux ¦ 首席医疗官，只因别无人选
a corporate charter with a human face ¦ корпоративный устав с человеческим лицом ¦ ein Firmenstatut mit menschlichem Gesicht ¦ une charte d'entreprise à visage humain ¦ 一张带着人脸的公司章程
''',
  'est_type': '''
cantina ¦ кантина ¦ Kantine ¦ cantina ¦ 酒吧
docking-bay diner ¦ закусочная у стыковочного шлюза ¦ Imbiss am Andockplatz ¦ snack du quai d'amarrage ¦ 泊位小餐馆
parts and salvage dealer ¦ лавка запчастей и утиля ¦ Ersatzteil- und Bergungshändler ¦ marchand de pièces et de récupération ¦ 零件与废品商店
zero-g gym ¦ спортзал в невесомости ¦ Schwerelos-Fitnessstudio ¦ salle de sport en apesanteur ¦ 零重力健身房
xeno-cuisine restaurant ¦ ресторан инопланетной кухни ¦ Xeno-Restaurant ¦ restaurant de cuisine xéno ¦ 外星料理餐厅
crew hostel ¦ хостел для экипажей ¦ Crewherberge ¦ auberge pour équipages ¦ 船员旅舍
''',
  'est_adj': '''
Drifting ¦ дрейфующий~дрейфующая ¦ Treibenden ¦ à la dérive ¦ 漂流
Lost ¦ потерянный~потерянная ¦ Verlorenen ¦ perdu~perdue ¦ 迷失
Red ¦ красный~красная ¦ Roten ¦ rouge ¦ 红
Frozen ¦ замёрзший~замёрзшая ¦ Gefrorenen ¦ gelé~gelée ¦ 冰封
Silent ¦ безмолвный~безмолвная ¦ Stummen ¦ silencieux~silencieuse ¦ 寂静
Burning ¦ пылающий~пылающая ¦ Brennenden ¦ ardent~ardente ¦ 燃烧
Hollow ¦ полый~полая ¦ Hohlen ¦ creux~creuse ¦ 空心
Blue ¦ синий~синяя ¦ Blauen ¦ bleu~bleue ¦ 蓝
Dancing ¦ танцующий~танцующая ¦ Tanzenden ¦ dansant~dansante ¦ 起舞
Twin ¦ двойной~двойная ¦ Doppelten ¦ jumeau~jumelle ¦ 双子
''',
  'est_noun': '''
Comet ¦ комета#f ¦ Schweifstern#m ¦ Comète#f ¦ 彗星
Nebula ¦ туманность#f ¦ Nebel#m ¦ Nébuleuse#f ¦ 星云
Airlock ¦ шлюз#m ¦ Schleuse#f ¦ Sas#m ¦ 气闸
Star ¦ звезда#f ¦ Stern#m ¦ Soleil#m ¦ 星
Moon ¦ луна#f ¦ Mond#m ¦ Lune#f ¦ 月
Engine ¦ двигатель#m ¦ Triebwerk#m ¦ Moteur#m ¦ 引擎
Orbit ¦ орбита#f ¦ Orbit#m ¦ Station#f ¦ 轨道
Void ¦ пустота#f ¦ Leere#f ¦ Vide#m ¦ 虚空
Rocket ¦ ракета#f ¦ Rakete#f ¦ Fusée#f ¦ 火箭
Pilot ¦ пилот#m ¦ Flieger#m ¦ Pilote#m ¦ 飞行员
Quasar ¦ квазар#m ¦ Quasar#m ¦ Quasar#m ¦ 类星体
Beacon ¦ маяк#m ¦ Bake#f ¦ Balise#f ¦ 信标
Kraken ¦ кракен#m ¦ Kalmar#m ¦ Kraken#m ¦ 巨妖
''',
  'est_specialty': '''
drinks served in zero gravity ¦ напитки, которые подают в невесомости ¦ Getränke, serviert in Schwerelosigkeit ¦ des boissons servies en apesanteur ¦ 在失重环境中供应的饮品
a navigator for hire in the back booth ¦ наёмный штурман в дальней кабинке ¦ ein Navigator zur Miete in der hinteren Nische ¦ un navigateur à louer dans le box du fond ¦ 后排卡座里待雇的领航员
real Earth coffee, allegedly ¦ настоящий земной кофе — по слухам ¦ echter Erdkaffee, angeblich ¦ du vrai café terrien, paraît-il ¦ 据说是真正的地球咖啡
spare parts for ships that no longer exist ¦ запчасти к кораблям, которых больше нет ¦ Ersatzteile für Schiffe, die es nicht mehr gibt ¦ des pièces pour des vaisseaux qui n'existent plus ¦ 早已不存在的飞船的备件
a band of four species playing one song ¦ оркестр из четырёх видов, играющий одну песню ¦ eine Band aus vier Spezies, die ein einziges Lied spielt ¦ un groupe de quatre espèces jouant une seule chanson ¦ 由四个种族组成、只会演奏一首歌的乐队
stew made from something that is still moving ¦ рагу из чего-то, что всё ещё шевелится ¦ Eintopf aus etwas, das sich noch bewegt ¦ un ragoût de quelque chose qui bouge encore ¦ 用还在蠕动的东西炖的汤
bunks rented by the sleep cycle ¦ койки, которые сдают на один цикл сна ¦ Kojen, vermietet pro Schlafzyklus ¦ des couchettes louées au cycle de sommeil ¦ 按睡眠周期出租的床铺
a star chart wall updated by the patrons ¦ стена со звёздной картой, которую дополняют посетители ¦ eine Sternkartenwand, die Gäste aktualisieren ¦ un mur de cartes stellaires mis à jour par les clients ¦ 由客人们不断更新的星图墙
no weapons, enforced by a very large bouncer ¦ никакого оружия — за этим следит очень крупный вышибала ¦ keine Waffen, durchgesetzt von einem sehr großen Türsteher ¦ pas d'armes, règle imposée par un très grand videur ¦ 禁止携带武器，由一位巨型保镖严格执行
the best view of the nebula in the sector ¦ лучший вид на туманность во всём секторе ¦ der beste Blick auf den Nebel im ganzen Sektor ¦ la plus belle vue sur la nébuleuse du secteur ¦ 全星区观赏星云的最佳位置
''',
  'est_patron': '''
a Vesh diplomat pretending to be a tourist ¦ вешский дипломат, выдающий себя за туриста ¦ ein Vesh-Diplomat, der sich als Tourist ausgibt ¦ un diplomate vesh qui se fait passer pour un touriste ¦ 假扮游客的维什外交官
a retired admiral who tips in medals ¦ отставной адмирал, дающий чаевые медалями ¦ ein Admiral im Ruhestand, der mit Orden Trinkgeld gibt ¦ un amiral retraité qui laisse des médailles en pourboire ¦ 用勋章付小费的退役海军上将
a smuggler waiting for a ship three days late ¦ контрабандистка, ждущая корабль, опаздывающий на три дня ¦ eine Schmugglerin, die auf ein Schiff mit drei Tagen Verspätung wartet ¦ une contrebandière qui attend un vaisseau en retard de trois jours ¦ 在等一艘晚了三天的船的走私犯
a Korr who speaks only through a translator box ¦ корр, говорящий только через коробку-переводчик ¦ ein Korr, der nur über einen Übersetzerkasten spricht ¦ un Korr qui ne parle qu'à travers un boîtier traducteur ¦ 只通过翻译盒说话的科尔人
an off-duty customs officer with a fat wallet ¦ таможенник не при исполнении с толстым кошельком ¦ ein Zollbeamter außer Dienst mit dicker Geldbörse ¦ un douanier en congé au portefeuille bien garni ¦ 钱包鼓鼓的休班海关官员
a young pilot selling a secondhand ship ¦ молодая пилотесса, продающая подержанный корабль ¦ eine junge Pilotin, die ein gebrauchtes Schiff verkauft ¦ une jeune pilote qui vend un vaisseau d'occasion ¦ 在卖二手飞船的年轻飞行员
a pilgrim bound for a holy black hole ¦ паломник, летящий к священной чёрной дыре ¦ ein Pilger auf dem Weg zu einem heiligen Schwarzen Loch ¦ un pèlerin en route vers un trou noir sacré ¦ 前往神圣黑洞朝圣的旅人
an android who has forgotten who owns it ¦ андроид, забывший, кому принадлежит ¦ ein Androide, der vergessen hat, wem er gehört ¦ un androïde qui a oublié à qui il appartient ¦ 忘了自己主人是谁的仿生人
''',
  'hook_title': '''
The Ghost Ship of Tau Veris ¦ Корабль-призрак Тау Верис ¦ Das Geisterschiff von Tau Veris ¦ Le Vaisseau fantôme de Tau Veris ¦ 陶维里斯的幽灵船
Coordinates in a Lullaby ¦ Координаты в колыбельной ¦ Koordinaten in einem Wiegenlied ¦ Des coordonnées dans une berceuse ¦ 摇篮曲里的坐标
The Emperor's Spare Heir ¦ Запасной наследник императора ¦ Der Ersatzerbe des Kaisers ¦ L'Héritier de rechange de l'empereur ¦ 皇帝的备用继承人
Silence at the Jump Gate ¦ Тишина у прыжковых врат ¦ Stille am Sprungtor ¦ Silence à la porte de saut ¦ 跃迁门前的寂静
Cargo: One Sleeping God ¦ Груз: один спящий бог ¦ Fracht: ein schlafender Gott ¦ Cargaison : un dieu endormi ¦ 货物：一位沉睡之神
The Long Way Around the Sun ¦ Долгий путь вокруг солнца ¦ Der lange Weg um die Sonne ¦ Le Long Détour autour du soleil ¦ 绕日远行
Mutiny on the Kestrel ¦ Бунт на «Пустельге» ¦ Meuterei auf der Kestrel ¦ Mutinerie à bord du Kestrel ¦ “红隼号”叛变
Dead Reckoning ¦ Счисление вслепую ¦ Koppelnavigation ¦ Navigation à l'estime ¦ 盲航推算
Stars Don't Lie ¦ Звёзды не лгут ¦ Sterne lügen nicht ¦ Les étoiles ne mentent pas ¦ 星辰不会说谎
A Treaty Written in Light ¦ Договор, написанный светом ¦ Ein in Licht geschriebener Vertrag ¦ Un traité écrit en lumière ¦ 以光写就的条约
''',
  'hook_who': '''
a stranded Tallan scholar ¦ застрявшая талланская учёная ¦ eine gestrandete tallanische Gelehrte ¦ une érudite tallane échouée ¦ 滞留在此的塔兰学者
an imperial officer on the run from her own fleet ¦ имперская офицерша, бегущая от собственного флота ¦ eine imperiale Offizierin auf der Flucht vor der eigenen Flotte ¦ une officière impériale en fuite devant sa propre flotte ¦ 正在躲避自家舰队的帝国军官
a salvage crew that found something alive ¦ бригада мусорщиков, нашедшая нечто живое ¦ eine Bergungscrew, die etwas Lebendiges gefunden hat ¦ une équipe de récupération qui a trouvé quelque chose de vivant ¦ 发现了活物的打捞队
the ship's own AI ¦ ИИ собственного корабля ¦ die eigene Schiffs-KI ¦ l'IA du vaisseau lui-même ¦ 飞船自己的AI
a girl who claims to be a deposed queen ¦ девочка, называющая себя свергнутой королевой ¦ ein Mädchen, das behauptet, eine abgesetzte Königin zu sein ¦ une fillette qui prétend être une reine déchue ¦ 自称是被废黜女王的女孩
a mining colony's union leader ¦ профсоюзный лидер шахтёрской колонии ¦ die Gewerkschaftsführerin einer Bergbaukolonie ¦ le leader syndical d'une colonie minière ¦ 矿业殖民地的工会领袖
a Vesh priest with a forbidden relic ¦ вешский жрец с запретной реликвией ¦ ein Vesh-Priester mit einer verbotenen Reliquie ¦ un prêtre vesh détenteur d'une relique interdite ¦ 持有禁忌圣物的维什祭司
a debt collector who actually needs help ¦ коллектор, которому на самом деле нужна помощь ¦ ein Schuldeneintreiber, der tatsächlich Hilfe braucht ¦ un recouvreur de dettes qui a vraiment besoin d'aide ¦ 其实需要帮助的讨债人
a famous holo-star hiding from the press ¦ знаменитая голозвезда, скрывающаяся от прессы ¦ ein berühmter Holostar auf der Flucht vor der Presse ¦ une célèbre holostar qui fuit la presse ¦ 躲避媒体的著名全息明星
the last officer of a disbanded fleet ¦ последний офицер расформированного флота ¦ der letzte Offizier einer aufgelösten Flotte ¦ le dernier officier d'une flotte dissoute ¦ 一支已解散舰队的最后一名军官
''',
  'hook_wants': '''
run sealed cargo past an imperial blockade ¦ провезти опечатанный груз через имперскую блокаду ¦ versiegelte Fracht durch eine imperiale Blockade bringen ¦ faire passer une cargaison scellée à travers un blocus impérial ¦ 把密封货物运过帝国封锁线
find a ship that vanished in hyperspace ¦ найти корабль, исчезнувший в гиперпространстве ¦ ein im Hyperraum verschwundenes Schiff finden ¦ retrouver un vaisseau disparu dans l'hyperespace ¦ 找到一艘在超空间中消失的飞船
escort a peace envoy to a hostile world ¦ сопроводить мирную посланницу на враждебную планету ¦ eine Friedensgesandte zu einer feindseligen Welt eskortieren ¦ escorter une envoyée de paix vers un monde hostile ¦ 护送和平使节前往敌对星球
steal a star map from an imperial archive ¦ украсть звёздную карту из имперского архива ¦ eine Sternkarte aus einem imperialen Archiv stehlen ¦ voler une carte stellaire dans une archive impériale ¦ 从帝国档案馆偷出一张星图
evacuate a colony before its sun flares ¦ эвакуировать колонию до вспышки её солнца ¦ eine Kolonie evakuieren, bevor ihre Sonne ausbricht ¦ évacuer une colonie avant l'éruption de son soleil ¦ 在恒星耀斑爆发前撤离殖民地
recover a black box from a derelict warship ¦ достать чёрный ящик с брошенного военного корабля ¦ die Blackbox eines verlassenen Kriegsschiffs bergen ¦ récupérer la boîte noire d'un vaisseau de guerre abandonné ¦ 从废弃战舰上取回黑匣子
win a smugglers' race through an asteroid field ¦ выиграть гонку контрабандистов через астероидное поле ¦ ein Schmugglerrennen durch ein Asteroidenfeld gewinnen ¦ gagner une course de contrebandiers dans un champ d'astéroïdes ¦ 赢下穿越小行星带的走私者竞速
negotiate first contact with a silent species ¦ провести первый контакт с безмолвным видом ¦ den Erstkontakt mit einer stummen Spezies aushandeln ¦ négocier le premier contact avec une espèce muette ¦ 与一个沉默的种族进行首次接触
free a crew held in an imperial labor camp ¦ освободить экипаж из имперского трудового лагеря ¦ eine Crew aus einem imperialen Arbeitslager befreien ¦ libérer un équipage détenu dans un camp de travail impérial ¦ 解救被关在帝国劳改营中的船员
bring back an heir before the succession vote ¦ доставить наследника до голосования о престолонаследии ¦ einen Erben vor der Thronfolgeabstimmung zurückbringen ¦ ramener un héritier avant le vote de succession ¦ 在继承投票前把继承人接回来
''',
  'hook_obstacle': '''
an imperial dreadnought patrols the only route ¦ имперский дредноут патрулирует единственный маршрут ¦ ein imperialer Schlachtkreuzer patrouilliert die einzige Route ¦ un cuirassé impérial patrouille sur la seule route ¦ 一艘帝国无畏舰在唯一的航线上巡逻
the jump drive has one jump left ¦ прыжкового двигателя хватит лишь на один прыжок ¦ der Sprungantrieb schafft nur noch einen Sprung ¦ le moteur de saut n'a plus qu'un saut ¦ 跃迁引擎只够再跳一次
a bounty hunter is already on the job ¦ за дело уже взялся охотник за головами ¦ ein Kopfgeldjäger ist bereits auf den Fall angesetzt ¦ un chasseur de primes est déjà sur le coup ¦ 一名赏金猎人已经接下了这单
the target world has no breathable air ¦ на целевой планете нет пригодного для дыхания воздуха ¦ die Zielwelt hat keine atembare Luft ¦ le monde visé n'a pas d'air respirable ¦ 目标星球没有可呼吸的空气
a solar storm will blind every sensor for days ¦ солнечная буря ослепит все датчики на несколько дней ¦ ein Sonnensturm wird alle Sensoren tagelang blenden ¦ une tempête solaire aveuglera tous les capteurs pendant des jours ¦ 一场太阳风暴将让所有传感器失明数日
the ship's papers are forged and about to expire ¦ документы корабля поддельные и скоро истекают ¦ die Schiffspapiere sind gefälscht und laufen bald ab ¦ les papiers du vaisseau sont faux et vont expirer ¦ 飞船证件是伪造的，而且快过期了
the crew is split on whether to do it at all ¦ экипаж разделился во мнениях, стоит ли вообще браться ¦ die Crew ist uneins, ob man es überhaupt tun soll ¦ l'équipage est divisé sur l'opportunité de le faire ¦ 船员们对是否接这活意见不一
an alien custom forbids speaking to outsiders ¦ обычай пришельцев запрещает говорить с чужаками ¦ ein fremder Brauch verbietet es, mit Außenstehenden zu sprechen ¦ une coutume extraterrestre interdit de parler aux étrangers ¦ 一项外星习俗禁止与外人交谈
the only fuel depot is held by pirates ¦ единственная заправочная база в руках пиратов ¦ das einzige Treibstofflager ist in Piratenhand ¦ le seul dépôt de carburant est tenu par des pirates ¦ 唯一的燃料补给站被海盗占据
the navigation charts are ninety years out of date ¦ навигационные карты устарели на девяносто лет ¦ die Navigationskarten sind neunzig Jahre veraltet ¦ les cartes de navigation ont quatre-vingt-dix ans de retard ¦ 导航星图已经过时九十年了
''',
  'hook_twist': '''
the cargo is a refugee in cryosleep ¦ груз — беженец в криосне ¦ die Fracht ist ein Flüchtling im Kälteschlaf ¦ la cargaison est un réfugié en cryosommeil ¦ 货物是一名冷冻休眠中的难民
the patron is a future version of a crew member ¦ заказчик — будущая версия одного из членов экипажа ¦ der Auftraggeber ist eine zukünftige Version eines Crewmitglieds ¦ le commanditaire est une version future d'un membre de l'équipage ¦ 委托人是某位船员未来的自己
the Empire staged the whole crisis ¦ Империя сама устроила весь кризис ¦ das Imperium hat die ganze Krise inszeniert ¦ l'Empire a orchestré toute la crise ¦ 整场危机都是帝国一手策划的
the aliens are the original inhabitants of this human colony ¦ пришельцы — коренные жители этой человеческой колонии ¦ die Fremden sind die Ureinwohner dieser Menschenkolonie ¦ les extraterrestres sont les habitants d'origine de cette colonie humaine ¦ 外星人才是这个人类殖民地的原住民
the ghost ship broadcasts a warning, not a distress call ¦ корабль-призрак передаёт предупреждение, а не сигнал бедствия ¦ das Geisterschiff sendet eine Warnung, keinen Notruf ¦ le vaisseau fantôme émet un avertissement, pas un appel de détresse ¦ 幽灵船发出的是警告，而非求救
the rebels are worse than the Empire ¦ повстанцы хуже Империи ¦ die Rebellen sind schlimmer als das Imperium ¦ les rebelles sont pires que l'Empire ¦ 叛军比帝国更糟
the heir does not want to be found ¦ наследник не хочет, чтобы его нашли ¦ der Erbe will nicht gefunden werden ¦ l'héritier ne veut pas être retrouvé ¦ 继承人根本不想被找到
the star map leads to a weapon ¦ звёздная карта ведёт к оружию ¦ die Sternkarte führt zu einer Waffe ¦ la carte stellaire mène à une arme ¦ 星图指向一件武器
the ship's AI has been lying for years ¦ ИИ корабля лжёт уже много лет ¦ die Schiffs-KI lügt seit Jahren ¦ l'IA du vaisseau ment depuis des années ¦ 飞船AI已经撒谎多年
the reward is paid in a currency that died with the war ¦ награду платят в валюте, исчезнувшей вместе с войной ¦ die Belohnung wird in einer Währung gezahlt, die mit dem Krieg verschwand ¦ la récompense est payée dans une monnaie disparue avec la guerre ¦ 报酬用的是一种随战争一同消失的货币
''',
  'loot_container': '''
Captain's safe from a derelict ¦ Сейф капитана с брошенного корабля ¦ Kapitänssafe eines Wracks ¦ Coffre du capitaine d'une épave ¦ 废弃飞船的船长保险箱
Smuggler's hidden cargo compartment ¦ Тайный грузовой отсек контрабандиста ¦ Verstecktes Frachtfach eines Schmugglers ¦ Compartiment caché d'un contrebandier ¦ 走私者的隐藏货舱
Imperial supply crate ¦ Имперский ящик снабжения ¦ Imperiale Nachschubkiste ¦ Caisse de ravitaillement impériale ¦ 帝国补给箱
Alien burial capsule ¦ Погребальная капсула пришельцев ¦ Außerirdische Grabkapsel ¦ Capsule funéraire extraterrestre ¦ 外星墓葬舱
Pirate captain's footlocker ¦ Сундук пиратского капитана ¦ Seekiste eines Piratenkapitäns ¦ Cantine de capitaine pirate ¦ 海盗船长的储物箱
Escape pod emergency kit ¦ Аварийный набор спасательной капсулы ¦ Notfallset einer Rettungskapsel ¦ Trousse de secours d'une capsule de sauvetage ¦ 逃生舱应急包
Mining drone's ore hopper ¦ Рудный бункер дрона-шахтёра ¦ Erztrichter einer Bergbaudrohne ¦ Trémie à minerai d'un drone minier ¦ 采矿无人机的矿斗
Diplomat's sealed pouch ¦ Опечатанная сумка дипломата ¦ Versiegelte Diplomatentasche ¦ Valise diplomatique scellée ¦ 外交官的密封公文袋
''',
  'loot_coin': '''
{#3d6*100} imperial credits on a chit ¦ имперские кредиты на чипе: {#3d6*100} ¦ {#3d6*100} imperiale Credits auf einem Chip ¦ {#3d6*100} crédits impériaux sur une puce ¦ 芯片上的{#3d6*100}帝国信用点
{#2d6*25} in bent alien coins ¦ гнутые инопланетные монеты на {#2d6*25} ¦ {#2d6*25} in verbogenen Alien-Münzen ¦ {#2d6*25} en pièces extraterrestres tordues ¦ 价值{#2d6*25}的弯曲外星硬币
fuel vouchers worth {#4d6*20} ¦ топливные талоны на {#4d6*20} ¦ Treibstoffgutscheine im Wert von {#4d6*20} ¦ des bons de carburant d'une valeur de {#4d6*20} ¦ 价值{#4d6*20}的燃料券
{#1d4+1} bars of refined iridium ¦ слитки очищенного иридия: {#1d4+1} ¦ {#1d4+1} Barren raffiniertes Iridium ¦ {#1d4+1} lingots d'iridium raffiné ¦ {#1d4+1}根精炼铱锭
''',
  'loot_item': '''
medpacks ×{#1d4+1} ¦ медпакеты ×{#1d4+1} ¦ Medipacks ×{#1d4+1} ¦ kits médicaux ×{#1d4+1} ¦ 医疗包 ×{#1d4+1}
a blaster pistol with a custom grip ¦ бластерный пистолет с особой рукоятью ¦ eine Blasterpistole mit Spezialgriff ¦ un pistolet blaster à la crosse personnalisée ¦ 定制握把的爆能手枪
power cells ×{#2d4} ¦ энергоячейки ×{#2d4} ¦ Energiezellen ×{#2d4} ¦ cellules d'énergie ×{#2d4} ¦ 能量电池 ×{#2d4}
a vacuum suit patched in three places ¦ скафандр, залатанный в трёх местах ¦ ein an drei Stellen geflickter Raumanzug ¦ une combinaison spatiale rapiécée en trois endroits ¦ 补了三处的真空服
an alien crystal that sings in starlight ¦ инопланетный кристалл, поющий в звёздном свете ¦ ein Alien-Kristall, der im Sternenlicht singt ¦ un cristal extraterrestre qui chante à la lumière des étoiles ¦ 在星光下会歌唱的外星水晶
ration tubes ×{#2d6} ¦ тюбики с пайком ×{#2d6} ¦ Rationstuben ×{#2d6} ¦ tubes de ration ×{#2d6} ¦ 口粮管 ×{#2d6}
a navigation drive with a corrupted route ¦ навигационный накопитель с повреждённым маршрутом ¦ ein Navigationsspeicher mit beschädigter Route ¦ un disque de navigation à l'itinéraire corrompu ¦ 航线已损坏的导航存储器
grav-grenades ×{#1d3+1} ¦ гравигранаты ×{#1d3+1} ¦ Gravgranaten ×{#1d3+1} ¦ grenades gravitiques ×{#1d3+1} ¦ 重力手雷 ×{#1d3+1}
a hull-repair kit ¦ ремкомплект для обшивки ¦ ein Hüllenreparaturset ¦ un kit de réparation de coque ¦ 船壳修补套件
bottles of Vesh swamp wine ×{#1d4+1} ¦ бутылки вешского болотного вина ×{#1d4+1} ¦ Flaschen Vesh-Sumpfwein ×{#1d4+1} ¦ bouteilles de vin des marais vesh ×{#1d4+1} ¦ 维什沼泽酒 ×{#1d4+1}
an imperial officer's dress sword ¦ парадная шпага имперского офицера ¦ ein Galadegen eines imperialen Offiziers ¦ l'épée d'apparat d'un officier impérial ¦ 帝国军官的礼仪佩剑
a portable shield emitter, low on charge ¦ портативный излучатель щита, почти разряженный ¦ ein tragbarer Schildemitter mit wenig Ladung ¦ un émetteur de bouclier portable presque déchargé ¦ 电量不足的便携式护盾发生器
seed canisters of an extinct plant ×{#1d3+1} ¦ контейнеры с семенами вымершего растения ×{#1d3+1} ¦ Saatgutbehälter einer ausgestorbenen Pflanze ×{#1d3+1} ¦ réserves de graines d'une plante éteinte ×{#1d3+1} ¦ 已灭绝植物的种子罐 ×{#1d3+1}
a translator earpiece with a rude vocabulary ¦ наушник-переводчик с грубым словарём ¦ ein Übersetzer-Ohrstück mit unhöflichem Wortschatz ¦ une oreillette traductrice au vocabulaire grossier ¦ 词汇粗鲁的翻译耳机
a compact drone that obeys one command ¦ компактный дрон, выполняющий одну-единственную команду ¦ eine kompakte Drohne, die einem einzigen Befehl gehorcht ¦ un drone compact qui n'obéit qu'à un seul ordre ¦ 只服从一条指令的小型无人机
a crate of imperial propaganda posters ¦ ящик имперских агитплакатов ¦ eine Kiste imperialer Propagandaplakate ¦ une caisse d'affiches de propagande impériale ¦ 一箱帝国宣传海报
''',
  'loot_curio': '''
a music box from a planet that no longer exists ¦ музыкальная шкатулка с планеты, которой больше нет ¦ eine Spieldose von einem Planeten, den es nicht mehr gibt ¦ une boîte à musique d'une planète qui n'existe plus ¦ 来自一颗已不复存在的星球的八音盒
a photograph of the crew taken tomorrow ¦ снимок экипажа, сделанный завтра ¦ ein Foto der Crew, aufgenommen morgen ¦ une photo de l'équipage prise demain ¦ 一张明天拍摄的船员合影
a vial of water from a lost homeworld's ocean ¦ флакон воды из океана потерянной родины ¦ ein Fläschchen Wasser aus dem Ozean einer verlorenen Heimatwelt ¦ une fiole d'eau de l'océan d'un monde natal perdu ¦ 一瓶来自失落母星海洋的水
a tiny egg that is warm and ticking ¦ крошечное тёплое яйцо, внутри которого что-то тикает ¦ ein winziges Ei, das warm ist und tickt ¦ un œuf minuscule, tiède et qui fait tic-tac ¦ 一颗温热并在滴答作响的小蛋
a medal for a battle that never happened ¦ медаль за битву, которой никогда не было ¦ ein Orden für eine Schlacht, die nie stattfand ¦ une médaille pour une bataille qui n'a jamais eu lieu ¦ 为一场从未发生的战役颁发的勋章
a star chart drawn by hand on fabric ¦ звёздная карта, нарисованная от руки на ткани ¦ eine handgezeichnete Sternkarte auf Stoff ¦ une carte stellaire dessinée à la main sur du tissu ¦ 手绘在布上的星图
a key to a room in the imperial palace ¦ ключ от комнаты в императорском дворце ¦ ein Schlüssel zu einem Raum im Kaiserpalast ¦ la clé d'une chambre du palais impérial ¦ 皇宫某个房间的钥匙
a love letter in a language nobody speaks ¦ любовное письмо на языке, на котором никто не говорит ¦ ein Liebesbrief in einer Sprache, die niemand spricht ¦ une lettre d'amour dans une langue que personne ne parle ¦ 一封用无人会说的语言写的情书
''',
  'faction_noun': '''
@Order Fleet ¦ Флот ¦ Flotte ¦ Flotte ¦ 舰队
@Guild Trade Guild ¦ Торговая гильдия ¦ Handelsgilde ¦ Guilde marchande ¦ 贸易行会
@Kingdom Dominion ¦ Доминион ¦ Dominion ¦ Dominion ¦ 自治领
@Cult Choir ¦ Хор ¦ Chor ¦ Chœur ¦ 圣咏会
@Company Consortium ¦ Консорциум ¦ Konsortium ¦ Consortium ¦ 财团
@Other Alliance ¦ Альянс ¦ Allianz ¦ Alliance ¦ 联盟
@Civilization Concord ¦ Согласие ¦ Eintracht ¦ Concorde ¦ 协约
@Family Dynasty ¦ Династия ¦ Dynastie ¦ Dynastie ¦ 王朝
''',
  'faction_of': '''
of the Pale Star ¦ Бледной Звезды ¦ des Bleichen Sterns ¦ de l'Étoile pâle ¦ 苍星
of the Far Reach ¦ Дальнего Предела ¦ der Fernen Weiten ¦ des Confins lointains ¦ 远域
of the Seventh Moon ¦ Седьмой Луны ¦ des Siebten Mondes ¦ de la Septième Lune ¦ 第七月
of the Silent Sun ¦ Безмолвного Солнца ¦ der Stummen Sonne ¦ du Soleil muet ¦ 寂日
of the Broken Gate ¦ Сломанных Врат ¦ des Zerbrochenen Tores ¦ de la Porte brisée ¦ 碎门
of the Iron Nebula ¦ Железной Туманности ¦ des Eisernen Nebels ¦ de la Nébuleuse de fer ¦ 铁星云
of the Endless Night ¦ Бесконечной Ночи ¦ der Endlosen Nacht ¦ de la Nuit sans fin ¦ 永夜
of the Golden Orbit ¦ Золотой Орбиты ¦ des Goldenen Orbits ¦ de l'Orbite dorée ¦ 金轨
of the Last Light ¦ Последнего Света ¦ des Letzten Lichts ¦ de la Dernière Lumière ¦ 余光
of the Twin Suns ¦ Двух Солнц ¦ der Zwillingssonnen ¦ des Soleils jumeaux ¦ 双日
''',
  'faction_goal': '''
control every jump gate in the sector ¦ контролировать все прыжковые врата сектора ¦ jedes Sprungtor im Sektor kontrollieren ¦ contrôler toutes les portes de saut du secteur ¦ 控制星区内所有跃迁门
restore the fallen Republic ¦ восстановить павшую Республику ¦ die gefallene Republik wiederherstellen ¦ restaurer la République déchue ¦ 复兴覆灭的共和国
make first contact before the Empire does ¦ установить первый контакт раньше Империи ¦ den Erstkontakt vor dem Imperium herstellen ¦ établir le premier contact avant l'Empire ¦ 抢在帝国之前完成首次接触
terraform a world no one else wants ¦ терраформировать мир, никому не нужный ¦ eine Welt terraformen, die sonst niemand will ¦ terraformer un monde dont personne ne veut ¦ 改造一颗无人问津的星球
place their heir on the imperial throne ¦ посадить своего наследника на императорский трон ¦ den eigenen Erben auf den Kaiserthron setzen ¦ placer leur héritier sur le trône impérial ¦ 将自家继承人扶上帝座
awaken the ancient machine beneath the moon ¦ пробудить древнюю машину под луной ¦ die uralte Maschine unter dem Mond erwecken ¦ éveiller l'antique machine sous la lune ¦ 唤醒月面下的古老机器
free every android in the core worlds ¦ освободить всех андроидов Центральных миров ¦ jeden Androiden der Kernwelten befreien ¦ libérer tous les androïdes des Mondes centraux ¦ 解放核心星域的所有仿生人
corner the market in hyperspace fuel ¦ монополизировать рынок гиперпространственного топлива ¦ den Markt für Hyperraumtreibstoff beherrschen ¦ accaparer le marché du carburant hyperspatial ¦ 垄断超空间燃料市场
''',
  'faction_method': '''
privateers with letters of marque ¦ каперы с патентами ¦ Kaperfahrer mit Kaperbriefen ¦ des corsaires munis de lettres de marque ¦ 持有私掠许可的私掠船
diplomatic marriages across species ¦ дипломатические браки между видами ¦ diplomatische Ehen zwischen Spezies ¦ des mariages diplomatiques entre espèces ¦ 跨种族的外交联姻
spies in every customs office ¦ шпионы в каждой таможне ¦ Spione in jedem Zollamt ¦ des espions dans chaque bureau de douane ¦ 每个海关都安插了间谍
secret shipyards in the asteroid belt ¦ тайные верфи в поясе астероидов ¦ geheime Werften im Asteroidengürtel ¦ des chantiers navals secrets dans la ceinture d'astéroïdes ¦ 小行星带里的秘密船坞
propaganda on every frequency ¦ пропаганда на всех частотах ¦ Propaganda auf allen Frequenzen ¦ de la propagande sur toutes les fréquences ¦ 在每个频段播放宣传
deciding who gets the fuel ¦ контроль над тем, кто получает топливо ¦ die Kontrolle darüber, wer Treibstoff bekommt ¦ décider qui reçoit le carburant ¦ 控制谁能拿到燃料
ancient alien technology they barely understand ¦ древние технологии пришельцев, которые они едва понимают ¦ uralte Alien-Technologie, die sie kaum verstehen ¦ une technologie extraterrestre antique qu'ils comprennent à peine ¦ 他们几乎不理解的古老外星科技
patience measured in centuries ¦ терпение, измеряемое веками ¦ Geduld, gemessen in Jahrhunderten ¦ une patience qui se compte en siècles ¦ 以世纪计算的耐心
''',
  'faction_symbol': '''
a ringed planet pierced by a sword ¦ окольцованная планета, пронзённая мечом ¦ ein beringter Planet, von einem Schwert durchbohrt ¦ une planète à anneaux transpercée d'une épée ¦ 被剑刺穿的环状行星
seven stars in a closed circle ¦ семь звёзд в замкнутом круге ¦ sieben Sterne in einem geschlossenen Kreis ¦ sept étoiles en cercle fermé ¦ 围成闭环的七颗星
an open hand holding a comet ¦ раскрытая ладонь, держащая комету ¦ eine offene Hand, die einen Kometen hält ¦ une main ouverte tenant une comète ¦ 托着彗星的张开手掌
a black sun with a silver corona ¦ чёрное солнце с серебряной короной ¦ eine schwarze Sonne mit silberner Korona ¦ un soleil noir à la couronne d'argent ¦ 带银色日冕的黑太阳
a stylized airlock door, half open ¦ стилизованная дверь шлюза, приоткрытая ¦ eine stilisierte, halb offene Schleusentür ¦ une porte de sas stylisée, entrouverte ¦ 半开的风格化气闸门
two moons eclipsing each other ¦ две луны, затмевающие друг друга ¦ zwei Monde, die einander verfinstern ¦ deux lunes qui s'éclipsent l'une l'autre ¦ 相互掩食的双月
an eye drawn in orbit lines ¦ глаз из орбитальных линий ¦ ein Auge aus Umlaufbahnen ¦ un œil fait de lignes d'orbite ¦ 由轨道线构成的眼睛
a crown floating above a void ¦ корона, парящая над пустотой ¦ eine Krone, die über der Leere schwebt ¦ une couronne flottant au-dessus du vide ¦ 悬浮在虚空之上的王冠
''',
  'weather_sky': '''
a gas giant fills half the sky, banded in amber ¦ газовый гигант в янтарных полосах занимает полнеба ¦ ein bernsteingestreifter Gasriese füllt den halben Himmel ¦ une géante gazeuse striée d'ambre emplit la moitié du ciel ¦ 琥珀色条纹的气态巨行星占据了半边天空
twin suns set in a smear of violet ¦ два солнца садятся в фиолетовом мареве ¦ zwei Sonnen gehen in violettem Schimmer unter ¦ deux soleils se couchent dans un halo violet ¦ 双日在紫色霞光中落下
an ion storm crackles across the viewports ¦ ионная буря потрескивает на иллюминаторах ¦ ein Ionensturm knistert über die Sichtfenster ¦ une tempête ionique crépite sur les hublots ¦ 离子风暴在舷窗上噼啪作响
the station passes into the planet's shadow ¦ станция уходит в тень планеты ¦ die Station tritt in den Schatten des Planeten ¦ la station passe dans l'ombre de la planète ¦ 空间站进入了行星的阴影
a meteor shower streaks silently past ¦ метеорный дождь беззвучно проносится мимо ¦ ein Meteorschauer zieht lautlos vorbei ¦ une pluie de météores file en silence ¦ 一场流星雨无声地划过
a nebula glows green behind the docking ring ¦ туманность светится зелёным за стыковочным кольцом ¦ ein Nebel leuchtet grün hinter dem Andockring ¦ une nébuleuse luit en vert derrière l'anneau d'amarrage ¦ 星云在对接环后泛着绿光
dust storms turn the colony dome orange ¦ пылевые бури окрашивают купол колонии в оранжевый ¦ Staubstürme färben die Kolonie-Kuppel orange ¦ des tempêtes de poussière teintent le dôme de la colonie en orange ¦ 沙尘暴把殖民地穹顶染成橙色
a sky so full of stars it looks crowded ¦ небо так полно звёзд, что кажется тесным ¦ ein Himmel so voller Sterne, dass er überfüllt wirkt ¦ un ciel si plein d'étoiles qu'il semble bondé ¦ 星星多得让天空显得拥挤
''',
  'weather_air': '''
recycled air tastes faintly of metal ¦ переработанный воздух слегка отдаёт металлом ¦ die aufbereitete Luft schmeckt leicht nach Metall ¦ l'air recyclé a un léger goût de métal ¦ 循环空气带着淡淡的金属味
the gravity feels a fraction too light ¦ гравитация кажется чуть слабее нормы ¦ die Schwerkraft fühlt sich eine Spur zu leicht an ¦ la gravité semble un rien trop légère ¦ 重力感觉稍微轻了一点
the hum of the reactor is louder than usual ¦ гул реактора громче обычного ¦ das Summen des Reaktors ist lauter als sonst ¦ le bourdonnement du réacteur est plus fort que d'habitude ¦ 反应堆的嗡鸣比平时更响
a cold draft leaks from a badly sealed hatch ¦ из плохо загерметизированного люка тянет холодом ¦ ein kalter Zug dringt aus einer schlecht versiegelten Luke ¦ un courant froid fuit d'une écoutille mal scellée ¦ 一股冷风从密封不严的舱门漏进来
humid heat from the hydroponics fogs the corridors ¦ влажная жара из гидропоники туманит коридоры ¦ feuchte Hitze aus der Hydrokultur vernebelt die Gänge ¦ la chaleur humide des cultures hydroponiques embue les couloirs ¦ 水培区的湿热让走廊雾气弥漫
the thin atmosphere leaves everyone short of breath ¦ разреженная атмосфера не даёт отдышаться ¦ die dünne Atmosphäre lässt alle nach Luft ringen ¦ l'atmosphère ténue essouffle tout le monde ¦ 稀薄的大气让每个人都喘不过气
static builds up on every surface ¦ на всех поверхностях скапливается статика ¦ auf jeder Oberfläche baut sich statische Ladung auf ¦ l'électricité statique s'accumule partout ¦ 每个表面都积满了静电
the smell of ozone lingers after the jump ¦ после прыжка пахнет озоном ¦ nach dem Sprung hängt Ozongeruch in der Luft ¦ une odeur d'ozone persiste après le saut ¦ 跃迁之后弥漫着臭氧味
''',
  'weather_omen': '''
every clock on the station loses the same second ¦ все часы на станции теряют одну и ту же секунду ¦ jede Uhr der Station verliert dieselbe Sekunde ¦ toutes les horloges de la station perdent la même seconde ¦ 空间站所有时钟都丢了同一秒
a dead satellite suddenly starts transmitting ¦ мёртвый спутник вдруг начинает передачу ¦ ein toter Satellit beginnt plötzlich zu senden ¦ un satellite mort se met soudain à émettre ¦ 一颗死卫星突然开始发送讯号
a comet appears that no chart predicted ¦ появляется комета, которую не предсказывала ни одна карта ¦ ein Komet erscheint, den keine Karte vorhersagte ¦ une comète apparaît, qu'aucune carte n'avait prévue ¦ 出现了一颗没有星图预测到的彗星
the Vesh aboard refuse to leave their quarters ¦ веши на борту отказываются выходить из кают ¦ die Vesh an Bord weigern sich, ihre Quartiere zu verlassen ¦ les Vesh à bord refusent de quitter leurs quartiers ¦ 船上的维什人拒绝离开舱室
every plant in hydroponics turns toward the same wall ¦ все растения в гидропонике поворачиваются к одной стене ¦ alle Pflanzen der Hydrokultur wenden sich derselben Wand zu ¦ toutes les plantes hydroponiques se tournent vers le même mur ¦ 水培区所有植物都转向同一面墙
the navigation computer plots a course on its own ¦ навигационный компьютер сам прокладывает курс ¦ der Navigationscomputer plottet eigenmächtig einen Kurs ¦ l'ordinateur de navigation trace un cap tout seul ¦ 导航计算机自行规划了一条航线
a distress call arrives in the captain's own voice ¦ сигнал бедствия приходит голосом самого капитана ¦ ein Notruf kommt in der Stimme des Kapitäns selbst ¦ un appel de détresse arrive avec la voix du capitaine ¦ 一段求救讯号用的竟是船长本人的声音
the stars outside seem to shift by a hair ¦ звёзды за бортом будто сдвигаются на волосок ¦ die Sterne draußen scheinen sich um ein Haar zu verschieben ¦ les étoiles au-dehors semblent se décaler d'un cheveu ¦ 舱外的星辰似乎挪动了一丝
''',
  'rumor_source': '''
a dockworker on a double shift ¦ докер на двойной смене ¦ ein Dockarbeiter in Doppelschicht ¦ un docker en double poste ¦ 连上两班的码头工人
an intercepted imperial transmission ¦ перехваченная имперская передача ¦ ein abgefangener imperialer Funkspruch ¦ une transmission impériale interceptée ¦ 截获的帝国通讯
a Tallan fortune-teller ¦ талланская гадалка ¦ eine tallanische Wahrsagerin ¦ une diseuse de bonne aventure tallane ¦ 塔兰算命师
the cantina's android bartender ¦ андроид-бармен кантины ¦ der Androidenbarkeeper der Kantine ¦ le barman androïde de la cantina ¦ 酒吧的仿生人酒保
a freighter pilot fresh off a long haul ¦ пилот грузовика, только что из дальнего рейса ¦ eine Frachterpilotin direkt von einer Langstrecke ¦ une pilote de cargo tout juste revenue d'un long trajet ¦ 刚跑完长途的货船飞行员
graffiti scratched into a maintenance duct ¦ надпись, нацарапанная в техническом коробе ¦ in einen Wartungsschacht geritztes Graffiti ¦ un graffiti gravé dans une gaine technique ¦ 刻在维修管道里的涂鸦
a bored customs clerk ¦ скучающий таможенный клерк ¦ ein gelangweilter Zollangestellter ¦ un employé des douanes qui s'ennuie ¦ 无聊的海关职员
a black-box recording from a wreck ¦ запись чёрного ящика с обломков ¦ eine Blackbox-Aufzeichnung aus einem Wrack ¦ un enregistrement de boîte noire tiré d'une épave ¦ 残骸中黑匣子里的录音
''',
  'rumor_text': '''
the Emperor died years ago and the court rules through a hologram ¦ император мёртв уже много лет, а двор правит через голограмму ¦ der Kaiser ist seit Jahren tot und der Hof regiert über ein Hologramm ¦ l'empereur est mort depuis des années et la cour règne par hologramme ¦ 皇帝早已驾崩多年，宫廷一直通过全息影像统治
a jump gate opened by itself last cycle ¦ в прошлом цикле прыжковые врата открылись сами собой ¦ letzten Zyklus hat sich ein Sprungtor von selbst geöffnet ¦ une porte de saut s'est ouverte toute seule au dernier cycle ¦ 上个周期有一座跃迁门自己打开了
the Vesh can hear hyperspace ¦ веши слышат гиперпространство ¦ die Vesh können den Hyperraum hören ¦ les Vesh entendent l'hyperespace ¦ 维什人能听见超空间
a derelict warship full of gold drifts in the asteroid belt ¦ в поясе астероидов дрейфует брошенный крейсер, полный золота ¦ im Asteroidengürtel treibt ein verlassenes Kriegsschiff voller Gold ¦ une épave de vaisseau de guerre pleine d'or dérive dans la ceinture d'astéroïdes ¦ 小行星带里有一艘满载黄金的废弃战舰
the colony's water is being shipped off-world in secret ¦ воду колонии тайно вывозят с планеты ¦ das Wasser der Kolonie wird heimlich abtransportiert ¦ l'eau de la colonie est expédiée en secret hors du monde ¦ 殖民地的水正被秘密运往星外
the station AI has fallen in love with a pilot ¦ ИИ станции влюбился в пилотессу ¦ die Stations-KI hat sich in eine Pilotin verliebt ¦ l'IA de la station est tombée amoureuse d'une pilote ¦ 空间站AI爱上了一名飞行员
the war starts again next month ¦ в следующем месяце война начнётся снова ¦ nächsten Monat beginnt der Krieg von Neuem ¦ la guerre reprend le mois prochain ¦ 下个月战争又要开始了
someone is buying every old navigation chart ¦ кто-то скупает все старые навигационные карты ¦ jemand kauft alle alten Navigationskarten auf ¦ quelqu'un rachète toutes les vieilles cartes de navigation ¦ 有人在收购所有旧导航星图
the new governor is an alien in disguise ¦ новый губернатор — замаскированный пришелец ¦ der neue Gouverneur ist ein getarnter Außerirdischer ¦ le nouveau gouverneur est un extraterrestre déguisé ¦ 新总督是乔装的外星人
a ship came back from the galaxy's edge with no crew ¦ корабль вернулся с края галактики без экипажа ¦ ein Schiff kehrte ohne Crew vom Rand der Galaxis zurück ¦ un vaisseau est revenu des confins de la galaxie sans équipage ¦ 一艘船从银河边缘归来，船上空无一人
''',
};

const _perLang = <String, Map<String, String>>{
  'en': {
    'settle_name': '{settle_pre} {settle_suf}',
    'settle_pre': '''
Kepler's
Halcyon
Verity
Tycho
Meridian
Cassini
Harmony
Perihelion
Vesper
Orison
''',
    'settle_suf': '''
Rest
Station
Reach
Landing
Deep
Outpost
Haven
Prime
''',
  },
  'ru': {
    'settle_name': '{settle_suf} «{settle_pre}»',
    'settle_pre': '''
Кеплер
Гальцион
Верити
Тихо
Меридиан
Кассини
Гармония
Перигелий
Веспер
Орисон
''',
    'settle_suf': '''
Станция
Колония
Порт
Аванпост
Гавань
Форпост
''',
  },
  'de': {
    'settle_name': '{settle_pre}-{settle_suf}',
    'settle_pre': '''
Kepler
Halcyon
Verity
Tycho
Meridian
Cassini
Harmonie
Perihel
Vesper
Orison
''',
    'settle_suf': '''
Station
Hafen
Kolonie
Außenposten
Zuflucht
Basis
''',
  },
  'fr': {
    'settle_name': '{settle_suf} {settle_pre}',
    'settle_pre': '''
Kepler
Halcyon
Verity
Tycho
Méridien
Cassini
Harmonie
Périhélie
Vesper
Orison
''',
    'settle_suf': '''
Station
Port
Colonie
Avant-poste
Refuge
Base
''',
  },
  'zh': {
    'settle_name': '{settle_pre}{settle_suf}',
    'settle_pre': '''
开普勒
哈尔西恩
维里蒂
第谷
子午
卡西尼
和谐
近日点
暮星
祈祷
''',
    'settle_suf': '''
空间站
港
殖民地
前哨
避风港
基地
''',
  },
};
