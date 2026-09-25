import '../../models/world.dart';
import 'table_library.dart';

const _s = WorldStyle.steampunk;

const steampunkTables = <LibraryTable>[
  LibraryTable(
    localId: 'street_encounters',
    style: _s,
    folder: LibraryFolder.encounters,
    formula: '1d12',
    name: Tx(
      'Cobblestone Encounters',
      'Встречи на мостовой',
      'Begegnungen auf dem Pflaster',
      'Rencontres sur les pavés',
      '石板街遭遇',
    ),
    description: Tx(
      'Smog, gaslight and brass: who you meet in the streets of the great city.',
      'Смог, газовые фонари и латунь: кого вы встречаете на улицах великого города.',
      'Smog, Gaslicht und Messing: wem ihr in den Straßen der großen Stadt begegnet.',
      'Smog, becs de gaz et laiton : qui l\'on croise dans les rues de la grande ville.',
      '煤烟、煤气灯与黄铜：在大都市街头遇见的人。',
    ),
    rows: [
      LibraryRow(
        Tx(
          'A runaway automaton, weeping oil, asks you to hide it from its maker.',
          'Сбежавший автоматон, плачущий маслом, просит спрятать его от создателя.',
          'Ein entlaufener Automat, der Öl weint, bittet euch, ihn vor seinem Erbauer zu verstecken.',
          'Un automate en fuite, pleurant de l\'huile, vous supplie de le cacher à son créateur.',
          '一台逃跑的自动人偶流着机油泪，求你把它藏起来，别让造它的人找到。',
        ),
      ),
      LibraryRow(
        Tx(
          'A pickpocket with mechanical fingers. You notice only when your {watch|purse|notebook} is gone.',
          'Карманник с механическими пальцами. Вы замечаете, лишь когда пропали {часы|кошелёк|записная книжка}.',
          'Ein Taschendieb mit mechanischen Fingern. Ihr merkt es erst, als {die Uhr|die Börse|das Notizbuch} fehlt.',
          'Un pickpocket aux doigts mécaniques. Vous ne remarquez rien avant que {votre montre|votre bourse|votre carnet} ait disparu.',
          '一个长着机械手指的扒手。直到{怀表|钱袋|笔记本}不见了你才察觉。',
        ),
      ),
      LibraryRow(
        Tx(
          'An airship drops its anchor straight through a shop roof.',
          'Дирижабль бросает якорь прямо сквозь крышу лавки.',
          'Ein Luftschiff wirft seinen Anker mitten durch ein Ladendach.',
          'Un dirigeable jette l\'ancre à travers le toit d\'une boutique.',
          '一艘飞艇的锚直接砸穿了一家店铺的屋顶。',
        ),
      ),
      LibraryRow(
        Tx(
          'A demonstration in the square goes badly: [[@contraptions]]',
          'Демонстрация на площади идёт не по плану: [[@contraptions]]',
          'Eine Vorführung auf dem Platz geht schief: [[@contraptions]]',
          'Une démonstration sur la place tourne mal : [[@contraptions]]',
          '广场上的一场演示出了岔子：[[@contraptions]]',
        ),
      ),
      LibraryRow(
        Tx(
          'A lady inventor in a hurry. [[@quirks]]',
          'Изобретательница, которая очень спешит. [[@quirks]]',
          'Eine Erfinderin in großer Eile. [[@quirks]]',
          'Une inventrice pressée. [[@quirks]]',
          '一位行色匆匆的女发明家。[[@quirks]]',
        ),
      ),
      LibraryRow(
        Tx(
          '{1d4+2} constables in steam-powered boots, chasing someone across the rooftops.',
          '{1d4+2} констебля в паровых сапогах гонятся за кем-то по крышам.',
          '{1d4+2} Konstabler in dampfbetriebenen Stiefeln jagen jemanden über die Dächer.',
          '{1d4+2} agents en bottes à vapeur poursuivent quelqu\'un sur les toits.',
          '{1d4+2}名穿着蒸汽靴的巡警在屋顶上追捕某人。',
        ),
      ),
      LibraryRow(
        Tx(
          'A street urchin sells newspapers from tomorrow, a penny each.',
          'Уличный мальчишка продаёт завтрашние газеты по пенни за штуку.',
          'Ein Gassenjunge verkauft Zeitungen von morgen, einen Penny das Stück.',
          'Un gamin des rues vend les journaux de demain, un penny pièce.',
          '一个街头小童在卖明天的报纸，一便士一份。',
        ),
      ),
      LibraryRow(
        Tx(
          'A dropped parcel, ticking. Inside: [[@pockets]]',
          'Оброненная посылка, которая тикает. Внутри: [[@pockets]]',
          'Ein fallen gelassenes Paket, das tickt. Darin: [[@pockets]]',
          'Un colis tombé par terre, qui fait tic-tac. Dedans : [[@pockets]]',
          '一个掉在地上、嘀嗒作响的包裹。里面是：[[@pockets]]',
        ),
      ),
      LibraryRow(
        Tx(
          'A labor strike blocks the bridge; the foundry owners send thugs.',
          'Забастовка перекрыла мост; владельцы литейной присылают громил.',
          'Ein Arbeiterstreik blockiert die Brücke; die Gießereibesitzer schicken Schläger.',
          'Une grève bloque le pont ; les patrons de la fonderie envoient des gros bras.',
          '罢工工人堵住了大桥，铸造厂老板派来了打手。',
        ),
      ),
      LibraryRow(
        Tx(
          'A clockwork horse throws its rider and bolts through the market.',
          'Заводная лошадь сбрасывает седока и несётся через рынок.',
          'Ein Uhrwerkpferd wirft seinen Reiter ab und prescht durch den Markt.',
          'Un cheval mécanique désarçonne son cavalier et fonce à travers le marché.',
          '一匹发条马甩下骑手，冲进了集市。',
        ),
      ),
      LibraryRow(
        Tx(
          'A spiritualist offers to contact the dead via telegraph. The line is already ringing.',
          'Спиритуалист предлагает связаться с мёртвыми по телеграфу. Аппарат уже стучит.',
          'Ein Spiritist bietet an, per Telegraf mit den Toten zu sprechen. Die Leitung klingelt bereits.',
          'Un spirite propose de contacter les morts par télégraphe. La ligne sonne déjà.',
          '一个通灵师提出用电报联络亡者，电报机已经响了起来。',
        ),
      ),
      LibraryRow(
        Tx(
          'Smog so thick the lamplighters are lost. Someone uses it to settle a debt.',
          'Смог такой густой, что фонарщики заблудились. Кто-то пользуется этим, чтобы свести счёты.',
          'Der Smog ist so dicht, dass sich die Laternenanzünder verirren. Jemand nutzt ihn, um eine Rechnung zu begleichen.',
          'Un smog si épais que les allumeurs de réverbères s\'égarent. Quelqu\'un en profite pour régler un compte.',
          '煤烟浓得连点灯人都迷了路，有人趁机了结一笔旧账。',
        ),
      ),
    ],
  ),
  LibraryTable(
    localId: 'contraptions',
    style: _s,
    folder: LibraryFolder.locale,
    formula: '1d10',
    name: Tx(
      'Contraptions Gone Wrong',
      'Механизмы вразнос',
      'Apparate außer Kontrolle',
      'Machines déréglées',
      '失控的奇巧装置',
    ),
    description: Tx(
      'When the gears slip and the boiler groans.',
      'Когда шестерни проскальзывают, а котёл стонет.',
      'Wenn die Zahnräder rutschen und der Kessel ächzt.',
      'Quand les engrenages glissent et que la chaudière gémit.',
      '齿轮打滑、锅炉呻吟的时候。',
    ),
    rows: [
      LibraryRow(
        Tx(
          'The pressure valve screams; everyone within {1d6*10} feet is scalded by steam.',
          'Клапан давления визжит; всех в радиусе {1d6*10} футов обдаёт паром.',
          'Das Druckventil kreischt; alle im Umkreis von {1d6*10} Fuß werden vom Dampf verbrüht.',
          'La soupape hurle ; tout le monde à {1d6*10} pieds est ébouillanté par la vapeur.',
          '压力阀尖啸，{1d6*10}英尺内的人都被蒸汽烫伤。',
        ),
      ),
      LibraryRow(
        Tx(
          'The difference engine prints the same prophecy on a loop.',
          'Разностная машина печатает одно и то же пророчество по кругу.',
          'Die Differenzmaschine druckt in Endlosschleife dieselbe Prophezeiung.',
          'La machine à différences imprime la même prophétie en boucle.',
          '差分机不停地循环打印同一条预言。',
        ),
      ),
      LibraryRow(
        Tx(
          'A mechanical arm grips its operator and will not let go.',
          'Механическая рука хватает своего оператора и не отпускает.',
          'Ein mechanischer Arm packt seinen Bediener und lässt nicht mehr los.',
          'Un bras mécanique agrippe son opérateur et ne le lâche plus.',
          '一只机械臂抓住了操作员，死活不松手。',
        ),
      ),
      LibraryRow(
        Tx(
          'The ornithopter\'s wings flap out of rhythm; it lurches {left|right|straight up}.',
          'Крылья орнитоптера сбиваются с ритма; его бросает {влево|вправо|вверх}.',
          'Die Flügel des Ornithopters schlagen aus dem Takt; er ruckt {nach links|nach rechts|steil nach oben}.',
          'Les ailes de l\'ornithoptère battent à contretemps ; il embarde {à gauche|à droite|vers le haut}.',
          '扑翼机的翅膀乱了节奏，猛地向{左|右|上}一歪。',
        ),
      ),
      LibraryRow(
        Tx(
          'Every clock in the building starts running backward.',
          'Все часы в здании начинают идти назад.',
          'Alle Uhren im Gebäude laufen plötzlich rückwärts.',
          'Toutes les horloges du bâtiment se mettent à tourner à l\'envers.',
          '楼里所有的钟都开始倒着走。',
        ),
      ),
      LibraryRow(
        Tx(
          'The tesla coil arcs to the nearest metal object: someone\'s {pocket watch|monocle|prosthetic leg}.',
          'Катушка Теслы бьёт разрядом в ближайший металл: в чьи-то {карманные часы|монокль|протез ноги}.',
          'Die Teslaspule schlägt in das nächste Metall: {eine Taschenuhr|ein Monokel|eine Beinprothese}.',
          'La bobine Tesla frappe l\'objet métallique le plus proche : {une montre de gousset|un monocle|une jambe prothétique}.',
          '特斯拉线圈对最近的金属物放电：某人的{怀表|单片眼镜|假腿}。',
        ),
      ),
      LibraryRow(
        Tx(
          'The automaton butler develops opinions and shares them.',
          'Автоматон-дворецкий обзаводится собственным мнением и делится им.',
          'Der Automaten-Butler entwickelt Meinungen und teilt sie mit.',
          'Le majordome automate se forge des opinions et les partage.',
          '自动管家有了自己的想法，还要说出来。',
        ),
      ),
      LibraryRow(
        Tx(
          'A boiler rupture floods the room with scalding water for {1d4} rounds.',
          'Прорыв котла заливает комнату кипятком на {1d4} раунда.',
          'Ein Kesselbruch flutet den Raum {1d4} Runden lang mit kochendem Wasser.',
          'Une chaudière éclate et inonde la pièce d\'eau bouillante pendant {1d4} rounds.',
          '锅炉破裂，滚烫的水在房间里泛滥了{1d4}轮。',
        ),
      ),
      LibraryRow(
        Tx(
          'The calculating engine\'s punch cards spell out a name: someone in this room.',
          'Перфокарты вычислительной машины складываются в имя — того, кто в этой комнате.',
          'Die Lochkarten der Rechenmaschine buchstabieren einen Namen: jemand in diesem Raum.',
          'Les cartes perforées de la machine à calculer épellent un nom : quelqu\'un dans cette pièce.',
          '计算机的穿孔卡片拼出了一个名字：就是这屋里的某个人。',
        ),
      ),
      LibraryRow(
        Tx(
          'Gears grind to a halt; the whole district loses power until repaired. The engineer: [[@quirks]]',
          'Шестерни встают; весь квартал без энергии до починки. Инженер: [[@quirks]]',
          'Die Zahnräder blockieren; das ganze Viertel ist bis zur Reparatur ohne Kraft. Der Ingenieur: [[@quirks]]',
          'Les engrenages se bloquent ; tout le quartier est privé d\'énergie jusqu\'à réparation. L\'ingénieur : [[@quirks]]',
          '齿轮卡死，整个街区停摆直到修好为止。负责的工程师：[[@quirks]]',
        ),
      ),
    ],
  ),
  LibraryTable(
    localId: 'gossip',
    style: _s,
    folder: LibraryFolder.rumors,
    formula: '1d10',
    name: Tx(
      'Salon Gossip',
      'Салонные сплетни',
      'Salonklatsch',
      'Potins de salon',
      '沙龙八卦',
    ),
    description: Tx(
      'Overheard between the sherry and the séance.',
      'Подслушано между хересом и спиритическим сеансом.',
      'Aufgeschnappt zwischen Sherry und Séance.',
      'Entendu entre le sherry et la séance de spiritisme.',
      '雪利酒与降神会之间偷听到的闲话。',
    ),
    rows: [
      LibraryRow(
        Tx(
          'Lord Ashcombe\'s heart is a clockwork replacement, and it is winding down.',
          'Сердце лорда Эшкомба — заводная замена, и завод кончается.',
          'Lord Ashcombes Herz ist ein Uhrwerkersatz, und es läuft langsam ab.',
          'Le cœur de lord Ashcombe est un mécanisme d\'horlogerie, et il se désagrège.',
          '阿什库姆勋爵的心脏是发条替代品，而且快走到头了。',
        ),
      ),
      LibraryRow(
        Tx(
          'The Royal Academy is offering {1d6*100} guineas for a working perpetual-motion engine.',
          'Королевская академия предлагает {1d6*100} гиней за работающий вечный двигатель.',
          'Die Königliche Akademie bietet {1d6*100} Guineen für ein funktionierendes Perpetuum mobile.',
          'L\'Académie royale offre {1d6*100} guinées pour un moteur à mouvement perpétuel qui fonctionne.',
          '皇家学院悬赏{1d6*100}几尼，征求一台能用的永动机。',
        ),
      ),
      LibraryRow(
        Tx(
          'A famous aeronaut vanished over the sea; her airship was found with the table set for tea.',
          'Знаменитая воздухоплавательница исчезла над морем; её дирижабль нашли со столом, накрытым к чаю.',
          'Eine berühmte Luftschifferin verschwand über dem Meer; ihr Schiff wurde mit gedecktem Teetisch gefunden.',
          'Une célèbre aéronaute a disparu au-dessus de la mer ; son dirigeable a été retrouvé, la table mise pour le thé.',
          '一位著名女飞艇员在海上失踪，人们找到她的飞艇时，茶桌还摆得好好的。',
        ),
      ),
      LibraryRow(
        Tx(
          'The underground railway has a station that is not on any map.',
          'У подземки есть станция, которой нет ни на одной карте.',
          'Die Untergrundbahn hat eine Station, die auf keiner Karte steht.',
          'Le métropolitain a une station qui ne figure sur aucun plan.',
          '地下铁路有一站不在任何地图上。',
        ),
      ),
      LibraryRow(
        Tx(
          'The Duchess hired a {clockmaker|chemist|medium} and fired all her servants the next day.',
          'Герцогиня наняла {часовщика|химика|медиума}, а на следующий день уволила всех слуг.',
          'Die Herzogin stellte {einen Uhrmacher|einen Chemiker|ein Medium} ein und entließ am nächsten Tag alle Diener.',
          'La duchesse a engagé {un horloger|un chimiste|une médium} et renvoyé tous ses domestiques le lendemain.',
          '公爵夫人雇了一位{钟表匠|化学家|灵媒}，第二天就辞退了所有仆人。',
        ),
      ),
      LibraryRow(
        Tx(
          'Someone is buying up every copper pipe in the city.',
          'Кто-то скупает все медные трубы в городе.',
          'Jemand kauft jedes Kupferrohr in der Stadt auf.',
          'Quelqu\'un rachète tous les tuyaux de cuivre de la ville.',
          '有人在收购全城所有的铜管。',
        ),
      ),
      LibraryRow(
        Tx(
          'A cabinet minister was seen leaving an automaton brothel. Or was it the minister?',
          'Министра видели выходящим из борделя с автоматонами. Или это был не министр?',
          'Ein Minister wurde beim Verlassen eines Automatensalons gesehen. Oder war es gar nicht der Minister?',
          'Un ministre a été vu sortant d\'un salon d\'automates. À moins que ce ne soit pas lui ?',
          '有人看见一位内阁大臣从自动人偶会所出来。可那真是大臣本人吗？',
        ),
      ),
      LibraryRow(
        Tx(
          'The Exhibition\'s centerpiece will be unveiled on Friday. Guards expect [[@street_encounters]]',
          'Главный экспонат выставки представят в пятницу. Охрана ожидает: [[@street_encounters]]',
          'Das Herzstück der Weltausstellung wird am Freitag enthüllt. Die Wachen rechnen mit: [[@street_encounters]]',
          'La pièce maîtresse de l\'Exposition sera dévoilée vendredi. La garde s\'attend à : [[@street_encounters]]',
          '博览会的核心展品周五揭幕。警卫们提防着：[[@street_encounters]]',
        ),
      ),
      LibraryRow(
        Tx(
          'A patent clerk has been stealing ideas from dreams.',
          'Патентный клерк крадёт идеи из снов.',
          'Ein Patentschreiber stiehlt Ideen aus Träumen.',
          'Un employé des brevets vole des idées dans les rêves.',
          '一个专利局职员一直在从梦里窃取点子。',
        ),
      ),
      LibraryRow(
        Tx(
          'The coal mines are hiring again, though nobody came back from the last shift.',
          'Угольные шахты снова нанимают, хотя с последней смены никто не вернулся.',
          'Die Kohlegruben stellen wieder ein, obwohl von der letzten Schicht niemand zurückkam.',
          'Les mines de charbon embauchent à nouveau, bien que personne ne soit revenu de la dernière équipe.',
          '煤矿又在招工了，尽管上一班的人一个都没回来。',
        ),
      ),
    ],
  ),
  LibraryTable(
    localId: 'pockets',
    style: _s,
    folder: LibraryFolder.loot,
    formula: '1d20',
    name: Tx(
      'Inventor\'s Pockets',
      'Карманы изобретателя',
      'Erfindertaschen',
      'Poches d\'inventeur',
      '发明家的口袋',
    ),
    description: Tx(
      'Trinkets, tools and prototypes carried by the tinkerers of the age.',
      'Безделушки, инструменты и прототипы, которые носят с собой мастера этого века.',
      'Krimskrams, Werkzeuge und Prototypen, die die Tüftler der Epoche mit sich tragen.',
      'Babioles, outils et prototypes que portent les bricoleurs de l\'époque.',
      '这个时代的能工巧匠随身携带的小玩意、工具和原型机。',
    ),
    rows: [
      LibraryRow(
        Tx(
          '{2d6} shillings and a brass cog of unknown purpose.',
          '{2d6} шиллингов и латунная шестерёнка неизвестного назначения.',
          '{2d6} Schilling und ein Messingzahnrad unbekannten Zwecks.',
          '{2d6} shillings et un rouage de laiton à l\'usage inconnu.',
          '{2d6}先令和一个用途不明的黄铜齿轮。',
        ),
        weight: 3,
      ),
      LibraryRow(
        Tx(
          'A pocket watch with {two|five|thirteen} hands.',
          'Карманные часы с {двумя|пятью|тринадцатью} стрелками.',
          'Eine Taschenuhr mit {zwei|fünf|dreizehn} Zeigern.',
          'Une montre de gousset à {deux|cinq|treize} aiguilles.',
          '一块有{两|五|十三}根指针的怀表。',
        ),
        weight: 3,
      ),
      LibraryRow(
        Tx(
          'Goggles that show heat as color.',
          'Очки, показывающие тепло цветом.',
          'Eine Schutzbrille, die Wärme als Farbe zeigt.',
          'Des lunettes qui montrent la chaleur en couleurs.',
          '一副能把热量显示成颜色的护目镜。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'A folding umbrella that doubles as a glider, once.',
          'Складной зонт, который один раз сработает как планер.',
          'Ein Klappschirm, der einmal als Gleiter taugt.',
          'Un parapluie pliant qui sert de planeur, une seule fois.',
          '一把折叠伞，能当一次滑翔翼用。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'A vial of phlogiston, warm to the touch.',
          'Склянка флогистона, тёплая на ощупь.',
          'Eine Phiole Phlogiston, warm in der Hand.',
          'Une fiole de phlogistique, tiède au toucher.',
          '一小瓶摸上去温热的燃素。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'A mechanical songbird that repeats the last thing said near it.',
          'Механическая певчая птичка повторяет последнее сказанное рядом.',
          'Ein mechanischer Singvogel, der das zuletzt Gesagte wiederholt.',
          'Un oiseau chanteur mécanique qui répète la dernière phrase prononcée près de lui.',
          '一只机械鸣鸟，会重复附近最后一句话。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'Blueprints for a weapon, signed by a man hanged last year.',
          'Чертежи оружия, подписанные человеком, повешенным в прошлом году.',
          'Baupläne einer Waffe, unterschrieben von einem Mann, der letztes Jahr gehängt wurde.',
          'Les plans d\'une arme, signés par un homme pendu l\'an dernier.',
          '一份武器图纸，署名者去年已被绞死。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'A pneumatic grappling pistol with {1d4} charges.',
          'Пневматический пистолет-кошка на {1d4} заряда.',
          'Eine pneumatische Enterhakenpistole mit {1d4} Ladungen.',
          'Un pistolet-grappin pneumatique à {1d4} charges.',
          '一把还剩{1d4}发的气动抓钩枪。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'A membership token for a gentlemen\'s club that officially does not exist.',
          'Членский жетон джентльменского клуба, которого официально не существует.',
          'Eine Mitgliedsmarke eines Herrenclubs, den es offiziell nicht gibt.',
          'Un jeton de membre d\'un club de gentlemen qui n\'existe officiellement pas.',
          '一枚绅士俱乐部的会员徽章，而这个俱乐部官方上并不存在。',
        ),
        weight: 1,
      ),
      LibraryRow(
        Tx(
          'A tiny aether battery that powers anything for one hour.',
          'Крошечная эфирная батарея: питает что угодно в течение часа.',
          'Eine winzige Ätherbatterie, die eine Stunde lang alles antreibt.',
          'Une minuscule pile à éther qui alimente n\'importe quoi pendant une heure.',
          '一块微型以太电池，能给任何东西供能一小时。',
        ),
        weight: 1,
      ),
    ],
  ),
  LibraryTable(
    localId: 'quirks',
    style: _s,
    folder: LibraryFolder.people,
    name: Tx(
      'Eccentric Quirks',
      'Чудачества',
      'Exzentrische Marotten',
      'Excentricités',
      '古怪癖好',
    ),
    description: Tx(
      'Habits for inventors, aristocrats, engineers and street folk.',
      'Привычки изобретателей, аристократов, инженеров и уличного люда.',
      'Eigenheiten von Erfindern, Adligen, Ingenieuren und Straßenvolk.',
      'Habitudes d\'inventeurs, d\'aristocrates, d\'ingénieurs et de gens de la rue.',
      '发明家、贵族、工程师和市井小民的习惯。',
    ),
    rows: [
      LibraryRow(
        Tx(
          'Consults a pocket barometer before every decision.',
          'Сверяется с карманным барометром перед каждым решением.',
          'Befragt vor jeder Entscheidung ein Taschenbarometer.',
          'Consulte un baromètre de poche avant chaque décision.',
          '每次做决定前都要看一眼袖珍气压计。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'Has a brass {hand|ear|eye} and polishes it while thinking.',
          'Вместо {руки|уха|глаза} у него латунный протез, который он полирует, когда думает.',
          'Hat {eine Messinghand|ein Messingohr|ein Messingauge} und poliert es beim Nachdenken.',
          'A {une main|une oreille|un œil} en laiton qu\'il astique en réfléchissant.',
          '有一只黄铜{手|耳朵|眼睛}，思考时就擦拭它。',
        ),
      ),
      LibraryRow(
        Tx(
          'Speaks in patent-office jargon: "hereinafter", "the aforesaid".',
          'Говорит языком патентного бюро: «далее именуемый», «вышеупомянутый».',
          'Spricht Patentamtsdeutsch: „im Folgenden“, „vorgenannt“.',
          'Parle le jargon des brevets : « ci-après », « susdit ».',
          '满口专利局术语：“下文简称”“前述”。',
        ),
      ),
      LibraryRow(
        Tx(
          'Wears three pairs of spectacles, stacked.',
          'Носит три пары очков одну поверх другой.',
          'Trägt drei Brillen übereinander.',
          'Porte trois paires de lunettes superposées.',
          '同时叠戴三副眼镜。',
        ),
      ),
      LibraryRow(
        Tx(
          'Is always slightly singed.',
          'Всегда слегка подпалён.',
          'Ist immer leicht angesengt.',
          'Est toujours un peu roussi.',
          '身上总带着点烧焦的痕迹。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'Keeps a diary in mirror-writing, like the old masters.',
          'Ведёт дневник зеркальным письмом, как старые мастера.',
          'Führt ein Tagebuch in Spiegelschrift, wie die alten Meister.',
          'Tient un journal en écriture spéculaire, comme les maîtres anciens.',
          '像古代大师那样，用镜像文字写日记。',
        ),
      ),
      LibraryRow(
        Tx(
          'Owns a mechanical pet that dislikes everyone but them.',
          'Держит механического питомца, который не любит никого, кроме хозяина.',
          'Besitzt ein mechanisches Haustier, das alle außer ihm verabscheut.',
          'Possède un animal mécanique qui déteste tout le monde sauf son maître.',
          '养着一只机械宠物，除了主人谁都讨厌。',
        ),
      ),
      LibraryRow(
        Tx(
          'Measures everything, including people, with a folding rule.',
          'Измеряет всё складной линейкой, включая людей.',
          'Misst alles mit einem Zollstock, auch Menschen.',
          'Mesure tout avec un mètre pliant, y compris les gens.',
          '什么都要用折尺量一量，包括人。',
        ),
      ),
      LibraryRow(
        Tx(
          'Drinks tea so strong it stains the cup black.',
          'Пьёт чай такой крепкий, что чашка чернеет.',
          'Trinkt Tee so stark, dass er die Tasse schwarz färbt.',
          'Boit un thé si fort qu\'il noircit la tasse.',
          '喝的茶浓到把杯子都染黑了。',
        ),
      ),
      LibraryRow(
        Tx(
          'Is convinced the moon is a very large clock.',
          'Уверен, что Луна — это очень большие часы.',
          'Ist überzeugt, dass der Mond eine sehr große Uhr ist.',
          'Est convaincu que la lune est une très grande horloge.',
          '坚信月亮是一座巨大的钟。',
        ),
      ),
    ],
  ),
];
