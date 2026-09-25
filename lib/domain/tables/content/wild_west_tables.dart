import '../../models/world.dart';
import 'table_library.dart';

const _s = WorldStyle.wildWest;

const wildWestTables = <LibraryTable>[
  LibraryTable(
    localId: 'trail_encounters',
    style: _s,
    folder: LibraryFolder.encounters,
    formula: '1d12',
    name: Tx(
      'Trail Encounters',
      'Встречи на тропе',
      'Begegnungen auf dem Trail',
      'Rencontres sur la piste',
      '小道遭遇',
    ),
    description: Tx(
      'Who rides out of the dust between one town and the next.',
      'Кто выезжает из пыли между двумя городками.',
      'Wer zwischen zwei Städten aus dem Staub geritten kommt.',
      'Qui surgit de la poussière entre deux villes.',
      '两座小镇之间，从尘土中骑马而来的人。',
    ),
    rows: [
      LibraryRow(
        Tx(
          'A stagecoach, wheel broken, its passengers arguing about a strongbox.',
          'Дилижанс со сломанным колесом; пассажиры спорят из-за сейфа.',
          'Eine Postkutsche mit gebrochenem Rad, die Fahrgäste streiten über eine Geldkassette.',
          'Une diligence à la roue cassée, dont les passagers se disputent un coffre.',
          '一辆车轮断了的驿站马车，乘客们正为一只保险箱争吵。',
        ),
      ),
      LibraryRow(
        Tx(
          '{1d4+2} outlaws with fresh wanted posters, looking for fresh horses.',
          '{1d4+2} бандита со свежими листовками о розыске ищут свежих лошадей.',
          '{1d4+2} Gesetzlose mit frischen Steckbriefen suchen frische Pferde.',
          '{1d4+2} hors-la-loi fraîchement recherchés cherchent des chevaux frais.',
          '{1d4+2}个刚上通缉令的亡命徒，正在找新马。',
        ),
      ),
      LibraryRow(
        Tx(
          'A traveling medicine show. The doctor: [[@quirks]]',
          'Бродячее шоу с чудо-снадобьями. Доктор: [[@quirks]]',
          'Eine fahrende Wunderdoktor-Show. Der Doktor: [[@quirks]]',
          'Un spectacle ambulant de remèdes miracles. Le docteur : [[@quirks]]',
          '一个巡回卖药的戏班子。那位“医生”：[[@quirks]]',
        ),
      ),
      LibraryRow(
        Tx(
          'Cattle drive: {1d6*100} head and a trail boss who wants no trouble.',
          'Перегон скота: {1d6*100} голов и старший погонщик, которому не нужны проблемы.',
          'Ein Viehtrieb: {1d6*100} Rinder und ein Treckboss, der keinen Ärger will.',
          'Un convoi de bétail : {1d6*100} têtes et un chef de piste qui ne veut pas d\'ennuis.',
          '一支赶牛队：{1d6*100}头牛，领队不想惹麻烦。',
        ),
      ),
      LibraryRow(
        Tx(
          'Trouble finds you: [[@frontier_trouble]]',
          'Беда находит вас сама: [[@frontier_trouble]]',
          'Der Ärger findet euch: [[@frontier_trouble]]',
          'Les ennuis vous trouvent : [[@frontier_trouble]]',
          '麻烦找上门来：[[@frontier_trouble]]',
        ),
      ),
      LibraryRow(
        Tx(
          'A U.S. Marshal escorting a prisoner who swears he is innocent.',
          'Маршал сопровождает арестанта, который клянётся, что невиновен.',
          'Ein US-Marshal eskortiert einen Gefangenen, der schwört, unschuldig zu sein.',
          'Un marshal escorte un prisonnier qui jure être innocent.',
          '一名联邦执法官押送着一个发誓自己无辜的犯人。',
        ),
      ),
      LibraryRow(
        Tx(
          'A prospector\'s mule, alone, carrying [[@saddlebags]]',
          'Мул старателя, один, везёт: [[@saddlebags]]',
          'Das Maultier eines Goldsuchers, allein, beladen mit: [[@saddlebags]]',
          'La mule d\'un prospecteur, seule, chargée de : [[@saddlebags]]',
          '一头淘金者的骡子，独自驮着：[[@saddlebags]]',
        ),
      ),
      LibraryRow(
        Tx(
          'A circuit preacher on a white horse, preaching to the empty plains.',
          'Странствующий проповедник на белом коне читает проповедь пустой равнине.',
          'Ein Wanderprediger auf einem Schimmel predigt der leeren Prärie.',
          'Un prêcheur itinérant sur un cheval blanc sermonne la plaine vide.',
          '一个骑白马的巡回牧师，对着空旷的平原布道。',
        ),
      ),
      LibraryRow(
        Tx(
          'Railroad surveyors with an armed escort, marking land that belongs to someone else.',
          'Железнодорожные землемеры под охраной размечают чужую землю.',
          'Eisenbahnvermesser mit bewaffneter Eskorte markieren Land, das jemand anderem gehört.',
          'Des arpenteurs du chemin de fer, escortés d\'hommes armés, jalonnent la terre d\'un autre.',
          '铁路勘测员在武装护送下，给别人的土地打桩。',
        ),
      ),
      LibraryRow(
        Tx(
          'A bounty hunter who thinks one of you matches a {faded|torn|brand-new} poster.',
          'Охотник за головами считает, что один из вас похож на {выцветшую|рваную|новенькую} листовку.',
          'Ein Kopfgeldjäger meint, einer von euch passe zu einem {verblichenen|zerrissenen|brandneuen} Steckbrief.',
          'Un chasseur de primes pense que l\'un de vous correspond à une affiche {délavée|déchirée|toute neuve}.',
          '一个赏金猎人觉得你们中有人和一张{褪色的|撕破的|崭新的}通缉令长得很像。',
        ),
      ),
      LibraryRow(
        Tx(
          'A homesteader family with a sick child, {2d6} miles from the nearest doctor.',
          'Семья поселенцев с больным ребёнком, в {2d6} милях от ближайшего врача.',
          'Eine Siedlerfamilie mit einem kranken Kind, {2d6} Meilen vom nächsten Arzt entfernt.',
          'Une famille de colons avec un enfant malade, à {2d6} milles du médecin le plus proche.',
          '一户拓荒人家的孩子病了，离最近的医生有{2d6}英里。',
        ),
      ),
      LibraryRow(
        Tx(
          'A lone rider in a long coat who shadows you for a day, then vanishes.',
          'Одинокий всадник в длинном плаще день следует за вами, потом исчезает.',
          'Ein einsamer Reiter im langen Mantel folgt euch einen Tag lang und verschwindet dann.',
          'Un cavalier solitaire en long manteau vous suit une journée, puis disparaît.',
          '一个穿长风衣的独行骑手尾随了你们一整天，然后消失了。',
        ),
      ),
    ],
  ),
  LibraryTable(
    localId: 'frontier_trouble',
    style: _s,
    folder: LibraryFolder.locale,
    formula: '2d6',
    name: Tx(
      'Frontier Trouble',
      'Беды фронтира',
      'Ärger an der Grenze',
      'Ennuis de la frontière',
      '边疆麻烦',
    ),
    description: Tx(
      'The land, the weather and the law all have it in for you.',
      'Земля, погода и закон — все против вас.',
      'Das Land, das Wetter und das Gesetz haben es auf euch abgesehen.',
      'La terre, le temps et la loi vous en veulent.',
      '土地、天气和法律都跟你过不去。',
    ),
    rows: [
      LibraryRow(
        Tx(
          'A flash flood fills the arroyo in minutes.',
          'Внезапный паводок за минуты заполняет овраг.',
          'Eine Sturzflut füllt das Trockental binnen Minuten.',
          'Une crue subite remplit l\'arroyo en quelques minutes.',
          '山洪几分钟就灌满了干河沟。',
        ),
      ),
      LibraryRow(
        Tx(
          'A horse throws a shoe {2d6} miles from town.',
          'Лошадь теряет подкову в {2d6} милях от города.',
          'Ein Pferd verliert {2d6} Meilen vor der Stadt ein Hufeisen.',
          'Un cheval perd un fer à {2d6} milles de la ville.',
          '离镇子还有{2d6}英里时，一匹马掉了马掌。',
        ),
      ),
      LibraryRow(
        Tx(
          'Rattlesnakes in the bedrolls.',
          'Гремучие змеи в спальных скатках.',
          'Klapperschlangen in den Schlafrollen.',
          'Des crotales dans les couvertures.',
          '铺盖卷里钻进了响尾蛇。',
        ),
      ),
      LibraryRow(
        Tx(
          'The water hole is dry, and there are fresh tracks leading away from it.',
          'Водопой пересох, а от него уходят свежие следы.',
          'Das Wasserloch ist ausgetrocknet, frische Spuren führen davon weg.',
          'Le point d\'eau est à sec, et des traces fraîches s\'en éloignent.',
          '水坑干了，还有新鲜的足迹从那里离开。',
        ),
      ),
      LibraryRow(
        Tx(
          'A dust storm hides the trail for {1d4} days.',
          'Пыльная буря скрывает тропу на {1d4} дн.',
          'Ein Staubsturm verdeckt den Trail für {1d4} Tage.',
          'Une tempête de poussière efface la piste pendant {1d4} jours.',
          '沙尘暴让小道{1d4}天都看不清。',
        ),
      ),
      LibraryRow(
        Tx(
          'A local sheriff takes a dislike to you. [[@quirks]]',
          'Местный шериф невзлюбил вас. [[@quirks]]',
          'Der örtliche Sheriff kann euch nicht leiden. [[@quirks]]',
          'Le shérif du coin vous prend en grippe. [[@quirks]]',
          '当地警长看你们不顺眼。[[@quirks]]',
        ),
      ),
      LibraryRow(
        Tx(
          'A prairie fire on the horizon, and the wind is turning.',
          'На горизонте степной пожар, а ветер меняется.',
          'Ein Präriefeuer am Horizont, und der Wind dreht.',
          'Un feu de prairie à l\'horizon, et le vent tourne.',
          '地平线上燃起了草原大火，而风向正在转变。',
        ),
      ),
      LibraryRow(
        Tx(
          'Someone cheated at cards and everyone thinks it was you.',
          'Кто-то сжульничал в карты, и все думают на вас.',
          'Jemand hat beim Kartenspiel betrogen, und alle glauben, ihr wart es.',
          'Quelqu\'un a triché aux cartes et tout le monde croit que c\'est vous.',
          '有人打牌出千，所有人都以为是你。',
        ),
      ),
      LibraryRow(
        Tx(
          'The river crossing is swollen; the ferryman wants {1d6} dollars a head.',
          'Брод разлился; паромщик хочет {1d6} долларов с головы.',
          'Die Furt ist angeschwollen; der Fährmann will {1d6} Dollar pro Kopf.',
          'Le gué est en crue ; le passeur demande {1d6} dollars par tête.',
          '渡口涨水了，摆渡人要每人{1d6}美元。',
        ),
      ),
      LibraryRow(
        Tx(
          'A {blizzard|heat wave|hailstorm} out of season.',
          'Не по сезону {метель|жара|град}.',
          '{Ein Schneesturm|Eine Hitzewelle|Ein Hagelsturm} zur Unzeit.',
          '{Un blizzard|Une canicule|Une averse de grêle} hors saison.',
          '反常的{暴风雪|热浪|冰雹}。',
        ),
      ),
      LibraryRow(
        Tx(
          'Your own face on a wanted poster, with the wrong name.',
          'Ваше лицо на листовке о розыске — под чужим именем.',
          'Euer eigenes Gesicht auf einem Steckbrief, mit falschem Namen.',
          'Votre propre visage sur un avis de recherche, sous un autre nom.',
          '通缉令上是你的脸，名字却不是你的。',
        ),
      ),
    ],
  ),
  LibraryTable(
    localId: 'saloon_talk',
    style: _s,
    folder: LibraryFolder.rumors,
    formula: '1d10',
    name: Tx(
      'Saloon Talk',
      'Разговоры в салуне',
      'Saloongerede',
      'Bavardages de saloon',
      '酒馆闲谈',
    ),
    description: Tx(
      'What you hear leaning on the bar with a glass of rotgut.',
      'Что слышно, если облокотиться на стойку со стаканом дешёвого пойла.',
      'Was man hört, wenn man mit einem Glas Fusel an der Theke lehnt.',
      'Ce qu\'on entend, accoudé au comptoir avec un verre de tord-boyaux.',
      '端着一杯劣酒靠在吧台上时听来的消息。',
    ),
    rows: [
      LibraryRow(
        Tx(
          'The bank in Red Mesa ships gold on Tuesdays, and the guards drink on Mondays.',
          'Банк в Ред-Мезе отправляет золото по вторникам, а охрана пьёт по понедельникам.',
          'Die Bank in Red Mesa verschickt dienstags Gold, und die Wachen trinken montags.',
          'La banque de Red Mesa expédie l\'or le mardi, et les gardes boivent le lundi.',
          '红台地的银行每周二运黄金，而护卫们每周一喝酒。',
        ),
      ),
      LibraryRow(
        Tx(
          'An old miner struck silver and died the same night. His claim map: [[@saddlebags]]',
          'Старый рудокоп нашёл серебро и умер той же ночью. Что при нём было: [[@saddlebags]]',
          'Ein alter Bergmann stieß auf Silber und starb noch in der Nacht. Bei ihm fand man: [[@saddlebags]]',
          'Un vieux mineur a trouvé de l\'argent et il est mort la nuit même. Sur lui : [[@saddlebags]]',
          '一个老矿工挖到了银矿，当晚就死了。他身上有：[[@saddlebags]]',
        ),
      ),
      LibraryRow(
        Tx(
          'The railroad will pass through here, or through the next town, and both mayors are desperate.',
          'Железная дорога пройдёт либо здесь, либо через соседний город, и оба мэра в отчаянии.',
          'Die Eisenbahn kommt entweder hier durch oder durch die Nachbarstadt, und beide Bürgermeister sind verzweifelt.',
          'Le chemin de fer passera ici ou par la ville voisine, et les deux maires sont aux abois.',
          '铁路要么经过这里，要么经过隔壁镇，两位镇长都急红了眼。',
        ),
      ),
      LibraryRow(
        Tx(
          'A gunslinger called {the Parson|Two-Bit Kate|the Widow} is riding this way.',
          'Сюда едет стрелок по прозвищу {Пастор|Кейт-Два-Гроша|Вдова}.',
          'Ein Revolverheld namens {der Pfarrer|Zwei-Groschen-Kate|die Witwe} reitet hierher.',
          'Un as de la gâchette surnommé {le Pasteur|Kate-Deux-Sous|la Veuve} arrive par ici.',
          '一个外号{“牧师”|“两毛钱凯特”|“寡妇”}的快枪手正骑马往这边来。',
        ),
      ),
      LibraryRow(
        Tx(
          'The ghost town up the canyon has lights on at night.',
          'В городе-призраке выше по каньону по ночам горит свет.',
          'In der Geisterstadt oben im Canyon brennt nachts Licht.',
          'La ville fantôme en haut du canyon a des lumières allumées la nuit.',
          '峡谷上游那座鬼镇，夜里亮着灯。',
        ),
      ),
      LibraryRow(
        Tx(
          'The cattle baron is paying {1d6*50} dollars for anyone who can find his missing daughter.',
          'Скотопромышленник платит {1d6*50} долларов тому, кто найдёт его пропавшую дочь.',
          'Der Rinderbaron zahlt {1d6*50} Dollar an jeden, der seine verschwundene Tochter findet.',
          'Le baron du bétail offre {1d6*50} dollars à qui retrouvera sa fille disparue.',
          '牛业大亨悬赏{1d6*50}美元，寻找他失踪的女儿。',
        ),
      ),
      LibraryRow(
        Tx(
          'Travelers on the south road keep running into [[@trail_encounters]]',
          'На южной дороге путники то и дело натыкаются: [[@trail_encounters]]',
          'Auf der Südstraße begegnen Reisende immer wieder: [[@trail_encounters]]',
          'Sur la route du sud, les voyageurs tombent sans cesse sur : [[@trail_encounters]]',
          '走南路的旅人总会遇上：[[@trail_encounters]]',
        ),
      ),
      LibraryRow(
        Tx(
          'The new schoolteacher is quicker with a pistol than any man in town.',
          'Новая учительница стреляет быстрее любого мужчины в городе.',
          'Die neue Lehrerin zieht schneller als jeder Mann in der Stadt.',
          'La nouvelle institutrice dégaine plus vite que n\'importe quel homme en ville.',
          '新来的女教师拔枪比镇上任何男人都快。',
        ),
      ),
      LibraryRow(
        Tx(
          'Somebody poisoned the well at the Double-K ranch.',
          'Кто-то отравил колодец на ранчо «Дабл-К».',
          'Jemand hat den Brunnen der Double-K-Ranch vergiftet.',
          'Quelqu\'un a empoisonné le puits du ranch Double-K.',
          '有人在双K牧场的井里投了毒。',
        ),
      ),
      LibraryRow(
        Tx(
          'The undertaker ordered {1d4+2} coffins before anyone died.',
          'Гробовщик заказал {1d4+2} гроба ещё до того, как кто-то умер.',
          'Der Bestatter hat {1d4+2} Särge bestellt, bevor jemand gestorben ist.',
          'Le croque-mort a commandé {1d4+2} cercueils avant que quiconque ne meure.',
          '殡葬人在还没人死之前，就订了{1d4+2}口棺材。',
        ),
      ),
    ],
  ),
  LibraryTable(
    localId: 'saddlebags',
    style: _s,
    folder: LibraryFolder.loot,
    formula: '1d20',
    name: Tx(
      'Saddlebag Finds',
      'Находки в седельных сумках',
      'Funde in Satteltaschen',
      'Trouvailles de sacoches',
      '鞍袋里的发现',
    ),
    description: Tx(
      'What turns up in a saddlebag, a strongbox or a dead man\'s vest.',
      'Что найдётся в седельной сумке, сейфе или жилете мертвеца.',
      'Was in Satteltaschen, Geldkassetten oder der Weste eines Toten steckt.',
      'Ce qu\'on trouve dans une sacoche, un coffre ou le gilet d\'un mort.',
      '鞍袋、保险箱或死人马甲里能找到的东西。',
    ),
    rows: [
      LibraryRow(
        Tx(
          '{2d6} silver dollars and a deck of marked cards.',
          '{2d6} серебряных долларов и краплёная колода.',
          '{2d6} Silberdollar und ein gezinktes Kartenspiel.',
          '{2d6} dollars d\'argent et un jeu de cartes truqué.',
          '{2d6}枚银元和一副做了记号的扑克。',
        ),
        weight: 4,
      ),
      LibraryRow(
        Tx(
          'Jerky, coffee and a tin cup with a bullet hole.',
          'Вяленое мясо, кофе и жестяная кружка с дыркой от пули.',
          'Dörrfleisch, Kaffee und ein Blechbecher mit Einschussloch.',
          'De la viande séchée, du café et une tasse en fer-blanc trouée par une balle.',
          '肉干、咖啡，还有一只带弹孔的铁皮杯。',
        ),
        weight: 3,
      ),
      LibraryRow(
        Tx(
          'A {Colt|Remington|Smith & Wesson} revolver with {1d6} rounds.',
          'Револьвер {Кольт|Ремингтон|Смит-и-Вессон} с {1d6} патронами.',
          'Ein {Colt|Remington|Smith & Wesson}-Revolver mit {1d6} Patronen.',
          'Un revolver {Colt|Remington|Smith & Wesson} avec {1d6} balles.',
          '一把{柯尔特|雷明顿|史密斯威森}左轮，装着{1d6}发子弹。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'A love letter, never sent, addressed to a woman in San Francisco.',
          'Любовное письмо, так и не отправленное, женщине в Сан-Франциско.',
          'Ein nie abgeschickter Liebesbrief an eine Frau in San Francisco.',
          'Une lettre d\'amour jamais envoyée, adressée à une femme de San Francisco.',
          '一封从未寄出的情书，收信人是旧金山的一位女子。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'A deed to a mine nobody has heard of.',
          'Купчая на шахту, о которой никто не слышал.',
          'Eine Besitzurkunde für eine Mine, von der niemand gehört hat.',
          'Un titre de propriété pour une mine dont personne n\'a entendu parler.',
          '一张谁也没听说过的矿山地契。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'Two sticks of dynamite, sweating.',
          'Две шашки динамита, покрытые испариной.',
          'Zwei Stangen Dynamit, die schwitzen.',
          'Deux bâtons de dynamite qui suintent.',
          '两根正在渗油的炸药。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'A sheriff\'s badge from a town that burned down.',
          'Значок шерифа из сгоревшего городка.',
          'Ein Sheriffstern aus einer abgebrannten Stadt.',
          'Une étoile de shérif d\'une ville qui a brûlé.',
          '一枚来自一座被烧毁小镇的警长徽章。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'A pouch of gold dust worth {1d6*10} dollars.',
          'Мешочек золотого песка на {1d6*10} долларов.',
          'Ein Beutel Goldstaub im Wert von {1d6*10} Dollar.',
          'Une bourse de poudre d\'or valant {1d6*10} dollars.',
          '一袋价值{1d6*10}美元的金沙。',
        ),
        weight: 1,
      ),
      LibraryRow(
        Tx(
          'A photograph of a gang, one face scratched out.',
          'Фотография банды, одно лицо выцарапано.',
          'Ein Foto einer Bande, ein Gesicht ausgekratzt.',
          'La photo d\'une bande, un visage gratté.',
          '一张帮派合影，其中一张脸被刮掉了。',
        ),
        weight: 1,
      ),
      LibraryRow(
        Tx(
          'A harmonica that plays a sad tune on its own at dusk.',
          'Губная гармошка, которая сама играет грустную мелодию в сумерках.',
          'Eine Mundharmonika, die in der Dämmerung von selbst ein trauriges Lied spielt.',
          'Un harmonica qui joue seul un air triste au crépuscule.',
          '一把口琴，黄昏时会自己吹出一支悲伤的曲子。',
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
      'Frontier Characters',
      'Люди фронтира',
      'Grenzland-Gestalten',
      'Figures de la frontière',
      '边疆人物',
    ),
    description: Tx(
      'Traits for ranchers, gamblers, lawmen and drifters.',
      'Черты для ранчеро, картёжников, законников и бродяг.',
      'Eigenheiten für Rancher, Spieler, Gesetzeshüter und Herumtreiber.',
      'Des traits pour éleveurs, joueurs, hommes de loi et vagabonds.',
      '牧场主、赌徒、执法者和流浪汉的特点。',
    ),
    rows: [
      LibraryRow(
        Tx(
          'Chews a toothpick and switches sides of the mouth when lying.',
          'Жуёт зубочистку и перекладывает её, когда врёт.',
          'Kaut auf einem Zahnstocher und wechselt beim Lügen die Seite.',
          'Mâchonne un cure-dent et change de côté quand il ment.',
          '嘴里叼着牙签，撒谎时就换一边。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'Quotes scripture, mostly wrong.',
          'Цитирует Писание — в основном неверно.',
          'Zitiert die Bibel, meistens falsch.',
          'Cite les Écritures, le plus souvent de travers.',
          '爱引用经文，大多引错。',
        ),
      ),
      LibraryRow(
        Tx(
          'Never takes off their {hat|spurs|gloves}, not even in church.',
          'Никогда не снимает {шляпу|шпоры|перчатки}, даже в церкви.',
          'Nimmt {den Hut|die Sporen|die Handschuhe} nie ab, nicht einmal in der Kirche.',
          'N\'enlève jamais {son chapeau|ses éperons|ses gants}, même à l\'église.',
          '从不摘下{帽子|马刺|手套}，连在教堂里也不摘。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'Talks to their horse more than to people.',
          'Разговаривает с лошадью больше, чем с людьми.',
          'Redet mehr mit dem Pferd als mit Menschen.',
          'Parle plus à son cheval qu\'aux gens.',
          '跟马说的话比跟人说的还多。',
        ),
      ),
      LibraryRow(
        Tx(
          'Keeps a tally of every man they have beaten at cards.',
          'Ведёт счёт всем, кого обыграл в карты.',
          'Führt Strichliste über jeden, den er beim Kartenspiel geschlagen hat.',
          'Tient le compte de tous ceux qu\'il a battus aux cartes.',
          '记下每一个在牌桌上输给自己的人。',
        ),
      ),
      LibraryRow(
        Tx(
          'Speaks three languages and pretends to speak none.',
          'Говорит на трёх языках, но притворяется, что не знает ни одного.',
          'Spricht drei Sprachen und tut so, als spräche er keine.',
          'Parle trois langues et fait semblant de n\'en parler aucune.',
          '会说三种语言，却装作一种也不会。',
        ),
      ),
      LibraryRow(
        Tx(
          'Whistles the same tune before every fight.',
          'Насвистывает одну и ту же мелодию перед каждой дракой.',
          'Pfeift vor jeder Schlägerei dieselbe Melodie.',
          'Siffle le même air avant chaque bagarre.',
          '每次打架前都吹同一支口哨。',
        ),
      ),
      LibraryRow(
        Tx(
          'Carries a pocket Bible with a derringer inside.',
          'Носит карманную Библию со спрятанным внутри дерринджером.',
          'Trägt eine Taschenbibel mit einem Derringer darin.',
          'Porte une bible de poche qui cache un derringer.',
          '随身带着一本袖珍圣经，里面藏着一把德林加手枪。',
        ),
      ),
      LibraryRow(
        Tx(
          'Has a glass eye and taps it when thinking.',
          'Имеет стеклянный глаз и постукивает по нему, когда думает.',
          'Hat ein Glasauge und klopft beim Nachdenken daran.',
          'A un œil de verre et le tapote en réfléchissant.',
          '装着一只玻璃假眼，思考时会敲敲它。',
        ),
      ),
      LibraryRow(
        Tx(
          'Swears they once rode with a famous outlaw. Nobody believes it; it is true.',
          'Клянётся, что когда-то скакал с известным бандитом. Никто не верит, а зря.',
          'Schwört, einst mit einem berühmten Gesetzlosen geritten zu sein. Niemand glaubt es; es stimmt.',
          'Jure avoir chevauché avec un célèbre hors-la-loi. Personne ne le croit ; c\'est vrai.',
          '发誓自己曾跟一个著名亡命徒一起闯荡。没人信——可这是真的。',
        ),
      ),
    ],
  ),
];
