import '../content_format.dart';

/// Hidden courts, haunted leases and magic behind the coffee counter.
final urbanFantasyContent =
    PackContent.build(rows: _rows, names: _names, perLang: _perLang);

const _names = <String, String>{
  'city_given_f': '''
Maya ¦ Майя ¦ 玛雅
Zoe ¦ Зои ¦ 佐伊
Imani ¦ Имани ¦ 伊玛尼
Chloe ¦ Хлоя ¦ 克洛伊
Mariana ¦ Мариана ¦ 玛丽安娜
Aisha ¦ Аиша ¦ 艾莎
Hannah ¦ Ханна ¦ 汉娜
Rosa ¦ Роза ¦ 罗莎
Keiko ¦ Кэйко ¦ 惠子
Tessa ¦ Тесса ¦ 泰莎
Danielle ¦ Даниэль ¦ 达妮埃尔
Freya ¦ Фрейя ¦ 芙蕾雅
''',
  'city_given_m': '''
Marcus ¦ Маркус ¦ 马库斯
Leo ¦ Лео ¦ 利奥
Andre ¦ Андре ¦ 安德烈
Samir ¦ Самир ¦ 萨米尔
Owen ¦ Оуэн ¦ 欧文
Daniel ¦ Дэниел ¦ 丹尼尔
Theo ¦ Тео ¦ 西奥
Jamal ¦ Джамал ¦ 贾迈勒
Nico ¦ Нико ¦ 尼科
Ethan ¦ Итан ¦ 伊森
Victor ¦ Виктор ¦ 维克托
Ravi ¦ Рави ¦ 拉维
''',
  'city_family': '''
Okafor ¦ Окафор ¦ 奥卡福
Reyes ¦ Рейес ¦ 雷耶斯
Nakamura ¦ Накамура ¦ 中村
Byrne ¦ Бирн ¦ 伯恩
Fischer ¦ Фишер ¦ 菲舍尔
Delgado ¦ Дельгадо ¦ 德尔加多
Mensah ¦ Менса ¦ 门萨
Sullivan ¦ Салливан ¦ 沙利文
Haddad ¦ Хаддад ¦ 哈达德
Lindgren ¦ Линдгрен ¦ 林德格伦
Moreno ¦ Морено ¦ 莫雷诺
Chen ¦ Чэнь ¦ 陈
Abernathy ¦ Эбернети ¦ 阿伯内西
''',
};

const _rows = <String, String>{
  'cultures': '''
@city City folk ¦ Горожане ¦ Stadtleute ¦ Citadins ¦ 城市居民
@fae Fae courts ¦ Дворы фейри ¦ Feenhöfe ¦ Cours féeriques ¦ 妖精宫廷
''',
  'fae_given': '''
Thistledown ¦ Чертополох ¦ Distelflaum ¦ Duvet-de-Chardon ¦ 蓟绒
Nightjar ¦ Козодой ¦ Nachtschwalbe ¦ Engoulevent ¦ 夜鹰
Moth-Silk ¦ Мотыльковый Шёлк ¦ Mottenseide ¦ Soie-de-Phalène ¦ 蛾丝
Bramble ¦ Ежевика ¦ Brombeer ¦ Ronce ¦ 荆棘
Hollyhock ¦ Мальва ¦ Stockrose ¦ Rose-Trémière ¦ 蜀葵
Frost ¦ Иней ¦ Raureif ¦ Givre ¦ 霜
Rook ¦ Грач ¦ Saatkrähe ¦ Freux ¦ 秃鼻鸦
Wisteria ¦ Глициния ¦ Glyzinie ¦ Glycine ¦ 紫藤
Cinderbloom ¦ Пепельный Цвет ¦ Aschblüte ¦ Fleur-de-Cendre ¦ 烬花
Quill ¦ Перо ¦ Kiel ¦ Plume ¦ 翎
Nettle ¦ Крапива ¦ Nessel ¦ Ortie ¦ 荨麻
Hazel ¦ Лещина ¦ Hasel ¦ Noisette ¦ 榛
''',
  'fae_family': '''
of the Autumn Court ¦ из Осеннего двора ¦ vom Herbsthof ¦ de la Cour d'Automne ¦ 秋之宫廷
of the Winter Court ¦ из Зимнего двора ¦ vom Winterhof ¦ de la Cour d'Hiver ¦ 冬之宫廷
of the Thorn Court ¦ из Тернового двора ¦ vom Dornenhof ¦ de la Cour des Épines ¦ 荆棘宫廷
of the Twilight Court ¦ из Сумеречного двора ¦ vom Dämmerhof ¦ de la Cour du Crépuscule ¦ 暮光宫廷
of the Lantern Court ¦ из Фонарного двора ¦ vom Laternenhof ¦ de la Cour des Lanternes ¦ 灯笼宫廷
of the Drowned Court ¦ из Утонувшего двора ¦ vom Ertrunkenen Hof ¦ de la Cour Noyée ¦ 溺水宫廷
of the Hollow Hill ¦ из Полого холма ¦ vom Hohlen Hügel ¦ de la Colline Creuse ¦ 空丘
of the Glass Court ¦ из Стеклянного двора ¦ vom Gläsernen Hof ¦ de la Cour de Verre ¦ 琉璃宫廷
''',
  'fae_full': '''
{=given} {=family} ¦ {=given} {=family} ¦ {=given} {=family} ¦ {=given} {=family} ¦ {=family}的{=given}
''',
  'epithet': '''
the Night Mayor ¦ Ночной Мэр ¦ der Nachtbürgermeister~die Nachtbürgermeisterin ¦ le Maire de la Nuit~la Mairesse de la Nuit ¦ 夜市长
Iron-Pocket ¦ Железный Карман ¦ Eisentasche ¦ Poche-de-Fer ¦ 铁口袋
the Witch of Line Seven ¦ Колдун Седьмой линии~Ведьма Седьмой линии ¦ der Hexer der Linie Sieben~die Hexe der Linie Sieben ¦ le Sorcier de la Ligne Sept~la Sorcière de la Ligne Sept ¦ 七号线女巫
Salt-and-Sage ¦ Соль-и-Шалфей ¦ Salz-und-Salbei ¦ Sel-et-Sauge ¦ 盐与鼠尾草
Doorknocker ¦ Открывающий Двери~Открывающая Двери ¦ Türklopfer ¦ Heurtoir ¦ 叩门人
the Rooftop Saint ¦ Святой с Крыш~Святая с Крыш ¦ der Dachheilige~die Dachheilige ¦ le Saint des Toits~la Sainte des Toits ¦ 屋顶圣徒
Changeling-Kid ¦ Подкидыш ¦ Wechselkind ¦ l'Enfant-Changé ¦ 调包儿
Lucky Thirteen ¦ Счастливчик Тринадцать~Счастливица Тринадцать ¦ Glückszahl Dreizehn ¦ Treize-Porte-Bonheur ¦ 幸运十三
the Last Train ¦ Последний Поезд ¦ der Letzte Zug ¦ le Dernier Train ¦ 末班车
Ghost-Talker ¦ Говорящий с Призраками~Говорящая с Призраками ¦ Geistersprecher~Geistersprecherin ¦ Parle-aux-Fantômes ¦ 通鬼者
''',
  'ancestry': '''
@city human ¦ человек ¦ Mensch ¦ humain~humaine ¦ 人类
@city human with the Sight ¦ человек с даром ясновидения ¦ Mensch mit dem Zweiten Gesicht ¦ humain doté de la Vue~humaine dotée de la Vue ¦ 拥有灵视的人类
@fae changeling ¦ подменыш ¦ Wechselbalg ¦ changelin~changeline ¦ 调包儿
@fae exiled fae ¦ изгнанный фейри~изгнанная фейри ¦ verbannter Fae~verbannte Fae ¦ fae exilé~fae exilée ¦ 被放逐的妖精
werewolf ¦ оборотень ¦ Werwolf~Werwölfin ¦ loup-garou~louve-garou ¦ 狼人
vampire ¦ вампир~вампирша ¦ Vampir~Vampirin ¦ vampire ¦ 吸血鬼
@city born into a family of witches ¦ из рода ведьм ¦ aus einer Hexenfamilie ¦ né dans une lignée de sorcières~née dans une lignée de sorcières ¦ 女巫世家出身
''',
  'role': '''
bartender at a supernatural bar ¦ бармен в баре для потусторонних ¦ Barkeeper in einer übernatürlichen Bar~Barkeeperin in einer übernatürlichen Bar ¦ barman d'un bar surnaturel~barmaid d'un bar surnaturel ¦ 超自然酒吧的酒保
occult bookshop owner ¦ владелец оккультного книжного~владелица оккультного книжного ¦ Besitzer eines okkulten Buchladens~Besitzerin eines okkulten Buchladens ¦ propriétaire d'une librairie occulte ¦ 神秘学书店老板
paramedic who sees ghosts ¦ фельдшер скорой, видящий призраков~фельдшерица скорой, видящая призраков ¦ Rettungssanitäter, der Geister sieht~Rettungssanitäterin, die Geister sieht ¦ ambulancier qui voit les fantômes~ambulancière qui voit les fantômes ¦ 能看见鬼的急救员
night-shift taxi driver ¦ ночной таксист~ночная таксистка ¦ Nachttaxifahrer~Nachttaxifahrerin ¦ chauffeur de taxi de nuit~chauffeuse de taxi de nuit ¦ 夜班出租车司机
detective of the unexplained ¦ детектив по необъяснимым делам ¦ Ermittler für Unerklärliches~Ermittlerin für Unerklärliches ¦ enquêteur de l'inexpliqué~enquêtrice de l'inexpliqué ¦ 超自然侦探
tattoo artist who inks wards ¦ татуировщик, набивающий обереги~татуировщица, набивающая обереги ¦ Tätowierer, der Schutzzeichen sticht~Tätowiererin, die Schutzzeichen sticht ¦ tatoueur de sceaux protecteurs~tatoueuse de sceaux protecteurs ¦ 刺护身符文的纹身师
pawnbroker for cursed goods ¦ скупщик проклятых вещей~скупщица проклятых вещей ¦ Pfandleiher für verfluchte Waren~Pfandleiherin für verfluchte Waren ¦ prêteur sur gages d'objets maudits~prêteuse sur gages d'objets maudits ¦ 专收诅咒物品的当铺老板
city council aide ¦ помощник городского советника~помощница городского советника ¦ Referent im Stadtrat~Referentin im Stadtrat ¦ assistant d'un conseiller municipal~assistante d'un conseiller municipal ¦ 市议员助理
street musician ¦ уличный музыкант~уличная музыкантша ¦ Straßenmusiker~Straßenmusikerin ¦ musicien de rue~musicienne de rue ¦ 街头艺人
folklore graduate student ¦ аспирант-фольклорист~аспирантка-фольклористка ¦ Doktorand der Volkskunde~Doktorandin der Volkskunde ¦ doctorant en folklore~doctorante en folklore ¦ 民俗学研究生
subway maintenance worker ¦ ремонтник метро ¦ Wartungsarbeiter der U-Bahn~Wartungsarbeiterin der U-Bahn ¦ agent d'entretien du métro~agente d'entretien du métro ¦ 地铁维修工
landlord of a haunted building ¦ хозяин дома с привидениями~хозяйка дома с привидениями ¦ Vermieter eines Spukhauses~Vermieterin eines Spukhauses ¦ propriétaire d'un immeuble hanté ¦ 鬼楼房东
''',
  'appearance': '''
a hoodie with iron nails sewn into the lining ¦ толстовка с железными гвоздями, вшитыми в подкладку ¦ ein Hoodie mit ins Futter eingenähten Eisennägeln ¦ un sweat à capuche aux clous de fer cousus dans la doublure ¦ 衬里缝着铁钉的连帽衫
eyes that catch the light like a cat's ¦ глаза, отражающие свет, как кошачьи ¦ Augen, die Licht wie Katzenaugen reflektieren ¦ des yeux qui reflètent la lumière comme ceux d'un chat ¦ 像猫一样反光的眼睛
a phone case covered in protective runes ¦ чехол телефона, покрытый защитными рунами ¦ eine Handyhülle voller Schutzrunen ¦ une coque de téléphone couverte de runes protectrices ¦ 刻满护身符文的手机壳
a tailored suit, always a century out of date ¦ сшитый на заказ костюм, всегда отстающий от моды на век ¦ ein Maßanzug, stets ein Jahrhundert aus der Mode ¦ un costume sur mesure, toujours démodé d'un siècle ¦ 总是落后一个世纪的定制西装
wildflowers growing in the hair ¦ полевые цветы, растущие прямо в волосах ¦ Wildblumen, die im Haar wachsen ¦ des fleurs sauvages qui poussent dans les cheveux ¦ 头发里长着野花
a coffee cup that never seems to empty ¦ стаканчик кофе, который, кажется, никогда не пустеет ¦ ein Kaffeebecher, der nie leer zu werden scheint ¦ un gobelet de café qui ne semble jamais se vider ¦ 仿佛永远喝不完的咖啡杯
''',
  'motivation': '''
pay off a debt to a fae noble ¦ расплатиться с долгом перед знатным фейри ¦ eine Schuld bei einem Feenadligen begleichen ¦ rembourser une dette envers un noble féerique ¦ 还清欠妖精贵族的债
keep the supernatural secret from their family ¦ скрыть сверхъестественное от своей семьи ¦ das Übernatürliche vor der eigenen Familie verbergen ¦ cacher le surnaturel à sa famille ¦ 对家人隐瞒超自然之事
find out who cursed the apartment ¦ найти того, кто проклял квартиру ¦ herausfinden, wer die Wohnung verflucht hat ¦ trouver qui a maudit l'appartement ¦ 找出诅咒公寓的人
get a true name back ¦ вернуть себе истинное имя ¦ den eigenen wahren Namen zurückbekommen ¦ récupérer son vrai nom ¦ 取回自己的真名
stay human ¦ остаться человеком ¦ ein Mensch bleiben ¦ rester humain~rester humaine ¦ 保持人类之身
make rent this month ¦ наскрести на аренду в этом месяце ¦ diesen Monat die Miete zusammenbekommen ¦ payer le loyer ce mois-ci ¦ 凑齐这个月的房租
''',
  'secret': '''
made a deal at a crossroads ¦ заключил сделку на перекрёстке~заключила сделку на перекрёстке ¦ hat an einer Kreuzung einen Pakt geschlossen ¦ a conclu un pacte à un carrefour ¦ 在十字路口做过交易
is a sleeper agent for the fae ¦ спящий агент фейри ¦ ist ein Schläfer im Dienst der Feen ¦ est un agent dormant des fées ¦ 是妖精安插的潜伏者
feeds a ghost in the basement ¦ подкармливает призрака в подвале ¦ füttert einen Geist im Keller ¦ nourrit un fantôme dans la cave ¦ 在地下室里喂养一个鬼魂
has not aged since 1974 ¦ не стареет с 1974 года ¦ ist seit 1974 nicht gealtert ¦ n'a pas vieilli depuis 1974 ¦ 自1974年以来就没有变老
sold a friend's memories to a collector ¦ продал воспоминания друга коллекционеру~продала воспоминания друга коллекционеру ¦ hat die Erinnerungen eines Freundes an einen Sammler verkauft ¦ a vendu les souvenirs d'un ami à un collectionneur ¦ 把朋友的记忆卖给了收藏家
is wanted by the Night Court ¦ разыскивается Ночным судом ¦ wird vom Nachtgericht gesucht ¦ est recherché par la Cour de la Nuit~est recherchée par la Cour de la Nuit ¦ 正被夜之法庭通缉
''',
  'settle_size': '''
@Landmark a single haunted block of {#2d6*20} residents ¦ один квартал с привидениями, {#2d6*20} жителей ¦ ein einzelner Spukblock mit {#2d6*20} Bewohnern ¦ un pâté de maisons hanté de {#2d6*20} résidents ¦ 住着{#2d6*20}人的闹鬼街区
@Town a neighborhood of about {#3d6*500} people ¦ район, около {#3d6*500} жителей ¦ ein Viertel mit etwa {#3d6*500} Menschen ¦ un quartier d'environ {#3d6*500} habitants ¦ 约{#3d6*500}人的社区
@City a borough of some {#2d10*20000} people ¦ округ, около {#2d10*20000} жителей ¦ ein Bezirk mit rund {#2d10*20000} Menschen ¦ un arrondissement d'environ {#2d10*20000} habitants ¦ 约{#2d10*20000}人的城区
@Plane a hidden market between worlds, population unknowable ¦ скрытый рынок между мирами, население неисчислимо ¦ ein verborgener Markt zwischen den Welten, Bevölkerung unbestimmbar ¦ un marché caché entre les mondes, population incalculable ¦ 世界之间的隐秘市集，人口无从统计
''',
  'settle_feature': '''
a subway station that appears on no map ¦ станция метро, которой нет на картах ¦ eine U-Bahn-Station, die auf keinem Plan steht ¦ une station de métro absente des plans ¦ 地图上不存在的地铁站
a park where the fae hold court at midnight ¦ парк, где в полночь собирается двор фейри ¦ ein Park, in dem die Feen um Mitternacht Hof halten ¦ un parc où les fées tiennent leur cour à minuit ¦ 妖精午夜开庭的公园
an all-night diner that serves anyone ¦ круглосуточная закусочная, где обслуживают кого угодно ¦ ein Nachtdiner, der jeden bedient ¦ un diner ouvert jour et nuit qui sert tout le monde ¦ 谁都接待的24小时餐馆
a bridge whose troll charges tolls in secrets ¦ мост, где тролль берёт плату секретами ¦ eine Brücke mit einem Troll, der Maut in Geheimnissen verlangt ¦ un pont gardé par un troll qui exige un péage en secrets ¦ 桥下的巨魔以秘密收取过路费
graffiti that rearranges itself overnight ¦ граффити, которые за ночь сами собой перестраиваются ¦ Graffiti, das sich über Nacht neu anordnet ¦ des graffitis qui se réarrangent pendant la nuit ¦ 一夜之间自行重排的涂鸦
a laundromat that doubles as neutral ground ¦ прачечная, служащая нейтральной территорией ¦ ein Waschsalon, der als neutraler Boden dient ¦ une laverie qui sert de terrain neutre ¦ 兼作中立地带的自助洗衣店
a library whose basement goes down forever ¦ библиотека, подвал которой уходит вниз бесконечно ¦ eine Bibliothek, deren Keller endlos hinabführt ¦ une bibliothèque dont le sous-sol descend sans fin ¦ 地下室深不见底的图书馆
a rooftop garden tended by pigeons ¦ сад на крыше, за которым ухаживают голуби ¦ ein Dachgarten, den Tauben pflegen ¦ un jardin sur le toit entretenu par des pigeons ¦ 由鸽子照料的屋顶花园
a cemetery with free wifi and restless tenants ¦ кладбище с бесплатным вайфаем и беспокойными жильцами ¦ ein Friedhof mit kostenlosem WLAN und unruhigen Bewohnern ¦ un cimetière avec wifi gratuit et locataires agités ¦ 有免费无线网和不安分住户的墓地
a streetlight that shows the lost their way home ¦ фонарь, указывающий заблудившимся дорогу домой ¦ eine Straßenlaterne, die Verirrten den Heimweg zeigt ¦ un réverbère qui montre le chemin aux égarés ¦ 为迷路者照亮回家路的路灯
''',
  'settle_trouble': '''
someone is stealing people's shadows ¦ кто-то крадёт у людей тени ¦ jemand stiehlt die Schatten der Menschen ¦ quelqu'un vole les ombres des gens ¦ 有人在偷人们的影子
a vampire turf war is spilling into the streets ¦ война вампиров за территорию выплёскивается на улицы ¦ ein Revierkrieg der Vampire schwappt auf die Straßen ¦ une guerre de territoire entre vampires déborde dans les rues ¦ 吸血鬼的地盘之争蔓延到了街头
the neighborhood's protective wards are failing ¦ защитные обереги района слабеют ¦ die Schutzzeichen des Viertels versagen ¦ les protections du quartier faiblissent ¦ 社区的防护结界正在失效
a developer is bulldozing a fae ring ¦ застройщик сносит круг фейри ¦ ein Bauträger walzt einen Feenring nieder ¦ un promoteur rase un cercle de fées ¦ 开发商正在推平一个妖精环
the dead have started calling the emergency line ¦ мёртвые начали звонить в службу спасения ¦ die Toten rufen den Notruf an ¦ les morts se sont mis à appeler les urgences ¦ 死者开始拨打急救电话
a werewolf pack has lost its alpha ¦ стая оборотней лишилась вожака ¦ ein Werwolfrudel hat seinen Anführer verloren ¦ une meute de loups-garous a perdu son chef ¦ 一个狼人群失去了头狼
the river spirit demands a sacrifice ¦ дух реки требует жертву ¦ der Flussgeist verlangt ein Opfer ¦ l'esprit du fleuve exige un sacrifice ¦ 河灵要求献祭
every mirror in the district shows a stranger ¦ каждое зеркало в районе показывает незнакомца ¦ jeder Spiegel im Bezirk zeigt einen Fremden ¦ chaque miroir du quartier montre un inconnu ¦ 区里每面镜子里都照出一个陌生人
a hex app is going viral ¦ приложение для порчи становится вирусным ¦ eine Fluch-App geht viral ¦ une appli de malédictions devient virale ¦ 一款下咒应用正在疯传
time runs slow on one street ¦ на одной улице время течёт медленнее ¦ in einer Straße vergeht die Zeit langsamer ¦ le temps passe plus lentement dans une rue ¦ 有一条街上的时间走得特别慢
''',
  'settle_authority': '''
a city councilor who is secretly a dragon ¦ городской советник, втайне являющийся драконом ¦ ein Stadtrat, der insgeheim ein Drache ist ¦ un conseiller municipal qui est secrètement un dragon ¦ 暗地里是一条龙的市议员
the Night Court, meeting under the bridge ¦ Ночной суд, заседающий под мостом ¦ das Nachtgericht, das unter der Brücke tagt ¦ la Cour de la Nuit, qui siège sous le pont ¦ 在桥下开庭的夜之法庭
a coven that runs the local bakery ¦ ковен, держащий местную пекарню ¦ ein Hexenzirkel, der die örtliche Bäckerei führt ¦ un cercle de sorcières qui tient la boulangerie du coin ¦ 经营本地面包房的女巫集会
a precinct captain who looks the other way ¦ капитан участка, который смотрит в другую сторону ¦ ein Revierleiter, der wegsieht ¦ un capitaine de commissariat qui ferme les yeux ¦ 睁一只眼闭一只眼的分局局长
an ancient vampire who owns the real estate ¦ древний вампир, которому принадлежит вся недвижимость ¦ ein uralter Vampir, dem die Immobilien gehören ¦ un vampire ancien qui possède l'immobilier ¦ 拥有全部房产的古老吸血鬼
the neighborhood association, which is more than it seems ¦ ассоциация жильцов, которая не так проста ¦ der Nachbarschaftsverein, der mehr ist, als er scheint ¦ l'association de quartier, qui cache bien son jeu ¦ 远比表面复杂的社区协会
a werewolf alpha who runs a construction firm ¦ альфа оборотней, владеющий строительной фирмой ¦ ein Werwolfalpha, der eine Baufirma leitet ¦ un alpha loup-garou à la tête d'une entreprise de BTP ¦ 经营建筑公司的狼人头领
a retired wizard who writes the zoning laws ¦ маг на пенсии, пишущий правила застройки ¦ ein pensionierter Zauberer, der die Bauordnung schreibt ¦ un mage retraité qui rédige le plan d'urbanisme ¦ 负责撰写区划法规的退休巫师
''',
  'est_type': '''
supernatural bar ¦ бар для потусторонних ¦ übernatürliche Bar ¦ bar surnaturel ¦ 超自然酒吧
occult bookshop ¦ оккультный книжный ¦ okkulter Buchladen ¦ librairie occulte ¦ 神秘学书店
all-night diner ¦ круглосуточная закусочная ¦ Nachtdiner ¦ diner ouvert toute la nuit ¦ 通宵餐馆
tattoo parlor ¦ тату-салон ¦ Tattoostudio ¦ salon de tatouage ¦ 纹身店
herbal apothecary ¦ травяная аптека ¦ Kräuterapotheke ¦ herboristerie ¦ 草药铺
vintage shop ¦ винтажный магазин ¦ Vintageladen ¦ friperie ¦ 古着店
''',
  'est_adj': '''
Crooked ¦ кривой~кривая ¦ Schiefen ¦ tordu~tordue ¦ 歪
Silver ¦ серебряный~серебряная ¦ Silbernen ¦ argenté~argentée ¦ 银
Midnight ¦ полуночный~полуночная ¦ Mitternächtlichen ¦ de minuit ¦ 午夜
Enchanted ¦ заколдованный~заколдованная ¦ Verzauberten ¦ enchanté~enchantée ¦ 魔法
Hungry ¦ голодный~голодная ¦ Hungrigen ¦ affamé~affamée ¦ 饥饿
Sleepless ¦ бессонный~бессонная ¦ Schlaflosen ¦ insomniaque ¦ 不眠
Neon ¦ неоновый~неоновая ¦ Leuchtenden ¦ néon ¦ 霓虹
Wandering ¦ бродячий~бродячая ¦ Wandernden ¦ errant~errante ¦ 游荡
Lucky ¦ счастливый~счастливая ¦ Glücklichen ¦ chanceux~chanceuse ¦ 幸运
Hidden ¦ скрытый~скрытая ¦ Verborgenen ¦ caché~cachée ¦ 隐秘
''',
  'est_noun': '''
Fox ¦ лис#m ¦ Fuchs#m ¦ Renard#m ¦ 狐
Moon ¦ луна#f ¦ Mond#m ¦ Lune#f ¦ 月
Key ¦ ключ#m ¦ Schlüssel#m ¦ Clé#f ¦ 钥匙
Crow ¦ ворона#f ¦ Krähe#f ¦ Corneille#f ¦ 乌鸦
Door ¦ дверь#f ¦ Tür#f ¦ Porte#f ¦ 门
Cat ¦ кот#m ¦ Kater#m ¦ Chat#m ¦ 猫
Teacup ¦ чашка#f ¦ Teetasse#f ¦ Tasse#f ¦ 茶杯
Candle ¦ свеча#f ¦ Kerze#f ¦ Bougie#f ¦ 烛
Lantern ¦ фонарь#m ¦ Laterne#f ¦ Lanterne#f ¦ 灯笼
Wolf ¦ волк#m ¦ Wolf#m ¦ Loup#m ¦ 狼
Hand ¦ рука#f ¦ Hand#f ¦ Main#f ¦ 手
Thorn ¦ шип#m ¦ Dorn#m ¦ Ronce#f ¦ 刺
Owl ¦ филин#m ¦ Eule#f ¦ Hibou#m ¦ 枭
''',
  'est_specialty': '''
drinks that taste like a memory ¦ напитки со вкусом воспоминаний ¦ Getränke, die nach Erinnerungen schmecken ¦ des boissons au goût de souvenir ¦ 喝起来像回忆的饮品
books that choose their readers ¦ книги, которые сами выбирают читателей ¦ Bücher, die sich ihre Leser aussuchen ¦ des livres qui choisissent leurs lecteurs ¦ 会自己挑选读者的书
pie that cures heartbreak for one night ¦ пирог, на одну ночь излечивающий разбитое сердце ¦ Kuchen, der für eine Nacht Liebeskummer heilt ¦ une tarte qui guérit un chagrin d'amour pour une nuit ¦ 能治愈一夜心碎的馅饼
protective tattoos, the first one free ¦ защитные татуировки, первая бесплатно ¦ Schutztattoos, das erste gratis ¦ des tatouages protecteurs, le premier offert ¦ 护身纹身，第一个免费
herbal remedies for supernatural ailments ¦ травяные средства от сверхъестественных хворей ¦ Kräutermittel gegen übernatürliche Leiden ¦ des remèdes aux herbes pour les maux surnaturels ¦ 治疗超自然病症的草药
a back booth where deals are witnessed ¦ дальняя кабинка, где сделки заключают при свидетелях ¦ eine hintere Nische, in der Abmachungen bezeugt werden ¦ une banquette du fond où l'on témoigne des pactes ¦ 可为交易作见证的后排卡座
coats that remember their previous owners ¦ пальто, помнящие прежних хозяев ¦ Mäntel, die sich an ihre früheren Besitzer erinnern ¦ des manteaux qui se souviennent de leurs anciens propriétaires ¦ 记得前任主人的大衣
open-mic nights for banshees ¦ вечера открытого микрофона для банши ¦ Open-Mic-Abende für Banshees ¦ des scènes ouvertes pour banshees ¦ 报丧女妖的开放麦之夜
coffee strong enough to see through glamour ¦ кофе, достаточно крепкий, чтобы видеть сквозь чары ¦ Kaffee, stark genug, um durch Feenblendwerk zu sehen ¦ un café assez fort pour voir à travers les illusions ¦ 浓得能看穿幻术的咖啡
lost-and-found for things lost in other worlds ¦ бюро находок для вещей, потерянных в других мирах ¦ ein Fundbüro für in anderen Welten verlorene Dinge ¦ des objets trouvés pour les choses perdues dans d'autres mondes ¦ 专收异界遗失物的失物招领处
''',
  'est_patron': '''
a vampire who only orders tomato juice ¦ вампир, заказывающий только томатный сок ¦ ein Vampir, der nur Tomatensaft bestellt ¦ un vampire qui ne commande que du jus de tomate ¦ 只点番茄汁的吸血鬼
a fae noble slumming it in sneakers ¦ знатный фейри, снизошедший до кроссовок ¦ ein Feenadliger, der sich in Turnschuhen unters Volk mischt ¦ un noble féerique qui s'encanaille en baskets ¦ 穿着运动鞋来体验民间的妖精贵族
a tired detective with a notebook of impossible cases ¦ уставшая сыщица с блокнотом невозможных дел ¦ eine müde Ermittlerin mit einem Notizbuch unmöglicher Fälle ¦ une enquêtrice épuisée au carnet rempli d'affaires impossibles ¦ 带着一本不可能案件笔记的疲惫侦探
a ghost who still pays for coffee ¦ призрак, который до сих пор платит за кофе ¦ ein Geist, der immer noch für seinen Kaffee bezahlt ¦ un fantôme qui paie toujours son café ¦ 至今还付咖啡钱的鬼魂
a werewolf on the night before the full moon ¦ оборотень накануне полнолуния ¦ ein Werwolf in der Nacht vor Vollmond ¦ un loup-garou la veille de la pleine lune ¦ 满月前夜的狼人
a student who just learned magic is real ¦ студентка, только что узнавшая, что магия существует ¦ eine Studentin, die gerade erfahren hat, dass Magie echt ist ¦ une étudiante qui vient d'apprendre que la magie existe ¦ 刚得知魔法真实存在的大学生
a street witch selling luck by the ounce ¦ уличная ведьма, продающая удачу на граммы ¦ eine Straßenhexe, die Glück grammweise verkauft ¦ une sorcière de rue qui vend la chance au gramme ¦ 论克卖运气的街头女巫
a gargoyle on its night off ¦ горгулья в выходной ¦ ein Wasserspeier an seinem freien Abend ¦ une gargouille pendant sa soirée de congé ¦ 休息之夜的石像鬼
''',
  'hook_title': '''
The Last Train to Nowhere ¦ Последний поезд в никуда ¦ Der letzte Zug nach Nirgendwo ¦ Le Dernier Train pour nulle part ¦ 开往虚无的末班车
A Lease Signed in Blood ¦ Договор аренды, подписанный кровью ¦ Ein mit Blut unterschriebener Mietvertrag ¦ Un bail signé avec du sang ¦ 以血签下的租约
The Changeling Next Door ¦ Подменыш по соседству ¦ Der Wechselbalg von nebenan ¦ Le Changelin d'à côté ¦ 隔壁的调包儿
Midnight at the Laundromat ¦ Полночь в прачечной ¦ Mitternacht im Waschsalon ¦ Minuit à la laverie ¦ 洗衣店的午夜
Shadow Theft ¦ Кража тени ¦ Schattendiebstahl ¦ Vol d'ombre ¦ 偷影
The Troll Bridge Toll ¦ Плата у моста тролля ¦ Der Brückenzoll des Trolls ¦ Le Péage du pont du troll ¦ 巨魔桥的过路费
Nine Lives, Eight Used ¦ Девять жизней, восемь потрачено ¦ Neun Leben, acht verbraucht ¦ Neuf vies, huit épuisées ¦ 九条命，已用八条
The Coven's Bake Sale ¦ Благотворительная выпечка ковена ¦ Der Kuchenbasar des Hexenzirkels ¦ La Vente de gâteaux du cercle ¦ 女巫集会的烘焙义卖
Dead Air ¦ Мёртвый эфир ¦ Totes Signal ¦ Silence d'antenne ¦ 死寂电波
Rent Is Due at Moonrise ¦ Аренда — к восходу луны ¦ Die Miete ist bei Mondaufgang fällig ¦ Le loyer est dû au lever de la lune ¦ 月出之时交房租
''',
  'hook_who': '''
a fae exile who needs a human witness ¦ изгнанный фейри, которому нужен свидетель-человек ¦ ein verbannter Fae, der einen menschlichen Zeugen braucht ¦ un fae exilé qui a besoin d'un témoin humain ¦ 需要一位人类证人的放逐妖精
a ghost who wants to finish her novel ¦ призрак писательницы, желающей закончить роман ¦ ein Geist, der ihren Roman beenden will ¦ une fantôme qui veut finir son roman ¦ 想写完小说的女鬼
a vampire landlord with a pest problem ¦ вампир-домовладелец с проблемой вредителей ¦ ein Vampirvermieter mit Ungezieferproblem ¦ un propriétaire vampire qui a un problème de nuisibles ¦ 被害虫困扰的吸血鬼房东
a teenage witch whose spell went viral ¦ юная ведьма, чьё заклинание стало вирусным ¦ eine junge Hexe, deren Zauber viral ging ¦ une jeune sorcière dont le sort est devenu viral ¦ 咒语在网上爆红的少女女巫
a werewolf cop investigating her own pack ¦ оборотень-полицейская, расследующая дела своей стаи ¦ eine Werwolf-Polizistin, die gegen ihr eigenes Rudel ermittelt ¦ une policière louve-garou qui enquête sur sa propre meute ¦ 调查自己狼群的狼人女警
a troll who lost his bridge ¦ тролль, лишившийся своего моста ¦ ein Troll, der seine Brücke verloren hat ¦ un troll qui a perdu son pont ¦ 丢了桥的巨魔
a city planner who keeps seeing doors that are not there ¦ градостроитель, которая видит несуществующие двери ¦ eine Stadtplanerin, die Türen sieht, die es nicht gibt ¦ une urbaniste qui voit des portes qui n'existent pas ¦ 总看见不存在的门的城市规划师
the owner of a pawnshop full of cursed goods ¦ владелец ломбарда, полного проклятых вещей ¦ der Besitzer einer Pfandleihe voller verfluchter Waren ¦ le patron d'une boutique de prêt sur gages remplie d'objets maudits ¦ 满是诅咒物品的当铺老板
a banshee who predicted her own death ¦ банши, предсказавшая собственную смерть ¦ eine Banshee, die ihren eigenen Tod vorhergesagt hat ¦ une banshee qui a prédit sa propre mort ¦ 预言了自己死亡的报丧女妖
a gargoyle who saw the murder ¦ горгулья, видевшая убийство ¦ ein Wasserspeier, der den Mord gesehen hat ¦ une gargouille qui a vu le meurtre ¦ 目睹了凶案的石像鬼
''',
  'hook_wants': '''
recover a stolen shadow before sunrise ¦ вернуть украденную тень до рассвета ¦ einen gestohlenen Schatten vor Sonnenaufgang zurückholen ¦ récupérer une ombre volée avant l'aube ¦ 在日出前找回被偷的影子
broker a truce between two vampire houses ¦ примирить два вампирских дома ¦ einen Waffenstillstand zwischen zwei Vampirhäusern vermitteln ¦ négocier une trêve entre deux maisons de vampires ¦ 调停两个吸血鬼家族之间的停战
find the fae ring before it is paved over ¦ найти круг фейри, пока его не закатали в асфальт ¦ den Feenring finden, bevor er zubetoniert wird ¦ trouver le cercle de fées avant qu'on ne le bétonne ¦ 在妖精环被铺成马路前找到它
bring a lost child back from the other side ¦ вернуть потерявшегося ребёнка с той стороны ¦ ein verlorenes Kind von der anderen Seite zurückholen ¦ ramener un enfant perdu de l'autre côté ¦ 把迷失在另一边的孩子带回来
delete a hex app from every phone ¦ удалить приложение для порчи со всех телефонов ¦ eine Fluch-App von allen Handys löschen ¦ supprimer une appli de malédictions de tous les téléphones ¦ 把下咒应用从每部手机上删除
protect a witness from the Night Court ¦ защитить свидетеля от Ночного суда ¦ einen Zeugen vor dem Nachtgericht schützen ¦ protéger un témoin de la Cour de la Nuit ¦ 保护一名证人免受夜之法庭的追究
exorcise a building before the inspection ¦ изгнать духов из дома до проверки ¦ ein Gebäude vor der Inspektion austreiben ¦ exorciser un immeuble avant l'inspection ¦ 在检查前为一栋楼驱魔
track the werewolf who is breaking the treaty ¦ выследить оборотня, нарушающего договор ¦ den Werwolf aufspüren, der den Vertrag bricht ¦ traquer le loup-garou qui viole le traité ¦ 追踪那个违反条约的狼人
buy back a soul from a pawnshop ¦ выкупить душу из ломбарда ¦ eine Seele aus der Pfandleihe zurückkaufen ¦ racheter une âme au mont-de-piété ¦ 从当铺赎回一个灵魂
get a ghost to leave the radio station ¦ уговорить призрака покинуть радиостанцию ¦ einen Geist dazu bringen, den Radiosender zu verlassen ¦ convaincre un fantôme de quitter la station de radio ¦ 让一个鬼魂离开电台
''',
  'hook_obstacle': '''
the ordinary police are closing in ¦ обычная полиция уже идёт по следу ¦ die gewöhnliche Polizei rückt näher ¦ la police ordinaire se rapproche ¦ 普通警察正在逼近
iron and salt don't work on this one ¦ железо и соль на этого не действуют ¦ Eisen und Salz wirken bei diesem nicht ¦ le fer et le sel ne marchent pas sur celui-ci ¦ 铁和盐对这个家伙都不管用
the only witness is a cat ¦ единственный свидетель — кошка ¦ die einzige Zeugin ist eine Katze ¦ le seul témoin est un chat ¦ 唯一的证人是一只猫
the deal was signed with a true name ¦ сделка подписана истинным именем ¦ der Pakt wurde mit einem wahren Namen unterzeichnet ¦ le pacte a été signé d'un vrai nom ¦ 那份契约是用真名签下的
the Night Court forbids interference ¦ Ночной суд запрещает вмешательство ¦ das Nachtgericht verbietet jede Einmischung ¦ la Cour de la Nuit interdit toute ingérence ¦ 夜之法庭禁止插手
it must be solved before the full moon ¦ разобраться надо до полнолуния ¦ es muss vor dem Vollmond gelöst werden ¦ il faut résoudre ça avant la pleine lune ¦ 必须在满月前解决
the victim's family knows nothing about magic ¦ семья жертвы ничего не знает о магии ¦ die Familie des Opfers weiß nichts von Magie ¦ la famille de la victime ignore tout de la magie ¦ 受害者的家人对魔法一无所知
the subway line to the site no longer exists ¦ линии метро к месту больше нет ¦ die U-Bahn-Linie dorthin existiert nicht mehr ¦ la ligne de métro qui y mène n'existe plus ¦ 通往那里的地铁线已经不存在了
the fae accept payment only in years of life ¦ фейри принимают оплату только годами жизни ¦ die Feen nehmen nur Lebensjahre als Bezahlung ¦ les fées n'acceptent que des années de vie en paiement ¦ 妖精只收寿命作为报酬
someone is livestreaming the whole thing ¦ кто-то ведёт прямую трансляцию всего происходящего ¦ jemand streamt das Ganze live ¦ quelqu'un diffuse tout en direct ¦ 有人在全程直播
''',
  'hook_twist': '''
the patron stole the shadow ¦ тень украл сам заказчик ¦ der Auftraggeber hat den Schatten selbst gestohlen ¦ c'est le commanditaire qui a volé l'ombre ¦ 偷影子的正是委托人
the ghost was never human ¦ призрак никогда не был человеком ¦ der Geist war nie ein Mensch ¦ le fantôme n'a jamais été humain ¦ 那个鬼魂从来就不是人
the werewolf is protecting a human child ¦ оборотень защищает человеческого ребёнка ¦ der Werwolf beschützt ein Menschenkind ¦ le loup-garou protège un enfant humain ¦ 狼人在保护一个人类孩子
the vampire houses staged the feud for profit ¦ вампирские дома разыграли вражду ради выгоды ¦ die Vampirhäuser haben die Fehde aus Profitgründen inszeniert ¦ les maisons de vampires ont monté la querelle par intérêt ¦ 吸血鬼家族为牟利而上演了这场争斗
the city itself is waking up ¦ просыпается сам город ¦ die Stadt selbst erwacht ¦ la ville elle-même se réveille ¦ 城市本身正在苏醒
the missing child chose to stay ¦ пропавший ребёнок решил остаться ¦ das verschwundene Kind hat sich entschieden zu bleiben ¦ l'enfant disparu a choisi de rester ¦ 失踪的孩子选择了留下
the hex app is keeping something worse away ¦ приложение для порчи отгоняет нечто похуже ¦ die Fluch-App hält etwas Schlimmeres fern ¦ l'appli de malédictions tient à distance quelque chose de pire ¦ 下咒应用其实在挡住更可怕的东西
one of the heroes signed a fae contract as a child ¦ один из героев в детстве подписал договор с фейри ¦ eines der Gruppenmitglieder hat als Kind einen Feenvertrag unterschrieben ¦ l'un des héros a signé un contrat féerique enfant ¦ 队伍中某人小时候签过妖精契约
the Night Court judge is the victim ¦ судья Ночного суда и есть жертва ¦ die Richterin des Nachtgerichts ist das Opfer ¦ la juge de la Cour de la Nuit est la victime ¦ 夜之法庭的法官就是受害者
the building is haunted by its future tenants ¦ в доме обитают призраки его будущих жильцов ¦ im Haus spuken seine zukünftigen Mieter ¦ l'immeuble est hanté par ses futurs locataires ¦ 这栋楼闹的是未来租户的鬼
''',
  'loot_container': '''
Witch's enchanted tote bag ¦ Заговорённая сумка ведьмы ¦ Verzauberte Einkaufstasche einer Hexe ¦ Tote bag enchanté d'une sorcière ¦ 女巫的魔法帆布袋
Vampire's safety deposit box ¦ Банковская ячейка вампира ¦ Schließfach eines Vampirs ¦ Coffre-fort bancaire d'un vampire ¦ 吸血鬼的银行保险箱
Lost-and-found box from the subway ¦ Коробка из бюро находок метро ¦ Fundkiste aus der U-Bahn ¦ Carton des objets trouvés du métro ¦ 地铁失物招领箱
Troll's stash under the bridge ¦ Тайник тролля под мостом ¦ Brückenversteck eines Trolls ¦ Cachette d'un troll sous le pont ¦ 巨魔藏在桥下的宝贝
Fae gift basket, not to be eaten ¦ Подарочная корзина фейри — не есть ¦ Feen-Geschenkkorb, nicht zum Essen ¦ Panier-cadeau féerique, à ne pas manger ¦ 妖精礼篮（别吃）
Ghost's shoebox under the floor ¦ Обувная коробка призрака под полом ¦ Schuhkarton eines Geistes unter den Dielen ¦ Boîte à chaussures d'un fantôme sous le plancher ¦ 鬼魂藏在地板下的鞋盒
Back-room safe of an occult shop ¦ Сейф в подсобке оккультной лавки ¦ Tresor im Hinterzimmer eines Okkultladens ¦ Coffre de l'arrière-boutique d'une boutique occulte ¦ 神秘学商店后屋的保险箱
Werewolf's gym bag ¦ Спортивная сумка оборотня ¦ Sporttasche eines Werwolfs ¦ Sac de sport d'un loup-garou ¦ 狼人的运动包
''',
  'loot_coin': '''
{#3d6*10} dollars in slightly damp cash ¦ слегка влажная наличность — {#3d6*10} долларов ¦ {#3d6*10} Dollar in leicht feuchtem Bargeld ¦ {#3d6*10} dollars en liquide légèrement humide ¦ {#3d6*10}美元现金，有点潮
fae gold worth {#2d6*20} until sunrise ¦ золото фейри на {#2d6*20} — до рассвета ¦ Feengold im Wert von {#2d6*20}, bis Sonnenaufgang ¦ de l'or féerique valant {#2d6*20} jusqu'à l'aube ¦ 价值{#2d6*20}的妖精金币，日出即失效
a gift card worth {#4d6*5}, curse included ¦ подарочная карта на {#4d6*5} с проклятием в придачу ¦ eine Geschenkkarte über {#4d6*5}, samt Fluch ¦ une carte cadeau de {#4d6*5}, malédiction comprise ¦ 一张余额{#4d6*5}还附带诅咒的礼品卡
{#1d6+1} very old silver dimes ¦ очень старые серебряные монетки: {#1d6+1} ¦ {#1d6+1} sehr alte Silbermünzen ¦ {#1d6+1} pièces d'argent très anciennes ¦ {#1d6+1}枚很老的银角子
''',
  'loot_item': '''
iron nails ×{#2d6} ¦ железные гвозди ×{#2d6} ¦ Eisennägel ×{#2d6} ¦ clous de fer ×{#2d6} ¦ 铁钉 ×{#2d6}
a salt shaker blessed three times ¦ солонка, трижды освящённая ¦ ein dreimal gesegneter Salzstreuer ¦ une salière bénie trois fois ¦ 被祝福过三次的盐瓶
a phone with a direct line to the dead ¦ телефон с прямой линией к мёртвым ¦ ein Handy mit einer direkten Leitung zu den Toten ¦ un téléphone avec une ligne directe vers les morts ¦ 能直接打给死者的手机
protective charms ×{#1d4+1} ¦ защитные амулеты ×{#1d4+1} ¦ Schutzamulette ×{#1d4+1} ¦ charmes protecteurs ×{#1d4+1} ¦ 护身符 ×{#1d4+1}
a silver-plated baseball bat ¦ посеребрённая бейсбольная бита ¦ ein versilberter Baseballschläger ¦ une batte de baseball argentée ¦ 镀银棒球棍
chalk that draws real doors ¦ мел, рисующий настоящие двери ¦ Kreide, die echte Türen zeichnet ¦ une craie qui dessine de vraies portes ¦ 能画出真门的粉笔
energy drinks brewed by a witch ×{#1d4+1} ¦ энергетики, сваренные ведьмой ×{#1d4+1} ¦ von einer Hexe gebraute Energydrinks ×{#1d4+1} ¦ boissons énergisantes brassées par une sorcière ×{#1d4+1} ¦ 女巫调制的能量饮料 ×{#1d4+1}
a metro card that works on any line, even closed ones ¦ проездной, работающий на любой линии, даже закрытой ¦ eine Fahrkarte, die auf jeder Linie gilt, auch auf stillgelegten ¦ un pass de métro valable sur toutes les lignes, même fermées ¦ 能乘任何线路（包括停运线路）的地铁卡
bundles of dried sage ×{#1d6+1} ¦ пучки сушёного шалфея ×{#1d6+1} ¦ Bündel getrockneten Salbeis ×{#1d6+1} ¦ bouquets de sauge séchée ×{#1d6+1} ¦ 干鼠尾草束 ×{#1d6+1}
a leather jacket that makes its wearer hard to notice ¦ кожаная куртка, делающая владельца неприметным ¦ eine Lederjacke, die ihren Träger unauffällig macht ¦ une veste en cuir qui rend son porteur difficile à remarquer ¦ 让穿着者难以被注意到的皮夹克
a spray can of warding paint ¦ баллончик защитной краски ¦ eine Spraydose mit Schutzfarbe ¦ une bombe de peinture protectrice ¦ 一罐防护结界喷漆
a vintage lighter that never runs dry ¦ старинная зажигалка, которая никогда не кончается ¦ ein altes Feuerzeug, das nie leer wird ¦ un vieux briquet qui ne s'épuise jamais ¦ 永远打不完火的老式打火机
vials of holy water ×{#1d4+1} ¦ флаконы святой воды ×{#1d4+1} ¦ Fläschchen Weihwasser ×{#1d4+1} ¦ fioles d'eau bénite ×{#1d4+1} ¦ 圣水瓶 ×{#1d4+1}
a skeleton key that fits any apartment ¦ отмычка, подходящая к любой квартире ¦ ein Dietrich, der in jede Wohnung passt ¦ un passe-partout qui ouvre n'importe quel appartement ¦ 能开任何公寓的万能钥匙
a lunchbox that keeps food fresh forever ¦ ланчбокс, сохраняющий еду свежей навсегда ¦ eine Brotdose, die Essen ewig frisch hält ¦ une boîte à repas qui garde la nourriture fraîche pour toujours ¦ 能让食物永远新鲜的饭盒
a compact mirror that shows true faces ¦ пудреница с зеркальцем, показывающим истинные лица ¦ ein Taschenspiegel, der wahre Gesichter zeigt ¦ un miroir de poche qui montre les vrais visages ¦ 能照出真面目的粉盒镜
''',
  'loot_curio': '''
a jar holding someone's laughter ¦ банка с чьим-то смехом ¦ ein Glas mit dem Lachen eines Menschen ¦ un bocal contenant le rire de quelqu'un ¦ 装着某人笑声的罐子
a photograph that changes every night ¦ фотография, меняющаяся каждую ночь ¦ ein Foto, das sich jede Nacht verändert ¦ une photographie qui change chaque nuit ¦ 每晚都会变化的照片
a business card for a company that closes in 2090 ¦ визитка компании, которая закроется в 2090 году ¦ eine Visitenkarte einer Firma, die 2090 schließt ¦ la carte de visite d'une entreprise qui fermera en 2090 ¦ 一张2090年才会倒闭的公司的名片
a feather from something that is not a bird ¦ перо существа, которое не птица ¦ eine Feder von etwas, das kein Vogel ist ¦ une plume de quelque chose qui n'est pas un oiseau ¦ 一根来自非鸟类之物的羽毛
a cassette of a ghost's favorite songs ¦ кассета с любимыми песнями призрака ¦ eine Kassette mit den Lieblingsliedern eines Geistes ¦ une cassette des chansons préférées d'un fantôme ¦ 录着鬼魂最爱歌曲的磁带
an acorn that hums lullabies ¦ жёлудь, напевающий колыбельные ¦ eine Eichel, die Wiegenlieder summt ¦ un gland qui fredonne des berceuses ¦ 会哼摇篮曲的橡果
a receipt for a soul, stamped PAID ¦ квитанция за душу со штампом «ОПЛАЧЕНО» ¦ eine Quittung für eine Seele, gestempelt „BEZAHLT“ ¦ un reçu pour une âme, tamponné « PAYÉ » ¦ 一张盖着“已付”印章的灵魂收据
a door handle with no door ¦ дверная ручка без двери ¦ eine Türklinke ohne Tür ¦ une poignée de porte sans porte ¦ 没有门的门把手
''',
  'faction_noun': '''
@Cult Coven ¦ Ковен ¦ Hexenzirkel ¦ Cercle ¦ 女巫集会
@Kingdom Court ¦ Двор ¦ Hof ¦ Cour ¦ 宫廷
@Family House ¦ Дом ¦ Haus ¦ Maison ¦ 家族
@Tribe Pack ¦ Стая ¦ Rudel ¦ Meute ¦ 狼群
@Order Order ¦ Орден ¦ Orden ¦ Ordre ¦ 修会
@Other Association ¦ Ассоциация ¦ Verein ¦ Association ¦ 协会
@Company Agency ¦ Агентство ¦ Agentur ¦ Agence ¦ 事务所
@Guild Guild ¦ Гильдия ¦ Gilde ¦ Guilde ¦ 行会
''',
  'faction_of': '''
of the Crossroads ¦ Перекрёстка ¦ der Kreuzung ¦ du Carrefour ¦ 十字路口
of the Last Train ¦ Последнего Поезда ¦ des Letzten Zuges ¦ du Dernier Train ¦ 末班车
of the Silver Moon ¦ Серебряной Луны ¦ des Silbernen Mondes ¦ de la Lune d'argent ¦ 银月
of Salt and Iron ¦ Соли и Железа ¦ von Salz und Eisen ¦ du Sel et du Fer ¦ 盐与铁
of the Hidden Door ¦ Скрытой Двери ¦ der Verborgenen Tür ¦ de la Porte cachée ¦ 暗门
of the Midnight Diner ¦ Полночной Закусочной ¦ des Mitternachtsdiners ¦ du Diner de minuit ¦ 午夜餐馆
of Seventh Street ¦ Седьмой Улицы ¦ der Siebten Straße ¦ de la Septième Rue ¦ 第七街
of the Broken Mirror ¦ Разбитого Зеркала ¦ des Zerbrochenen Spiegels ¦ du Miroir brisé ¦ 碎镜
of the Evening Star ¦ Вечерней Звезды ¦ des Abendsterns ¦ de l'Étoile du soir ¦ 长庚星
of the Rooftops ¦ Крыш ¦ der Dächer ¦ des Toits ¦ 屋顶
''',
  'faction_goal': '''
keep magic hidden from the ordinary world ¦ скрывать магию от обычного мира ¦ die Magie vor der gewöhnlichen Welt verbergen ¦ cacher la magie au monde ordinaire ¦ 让魔法不被凡俗世界发现
reveal magic to everyone at once ¦ открыть магию всем разом ¦ die Magie allen auf einmal enthüllen ¦ révéler la magie à tous d'un coup ¦ 一次性向所有人揭露魔法
buy up every haunted building ¦ скупить все дома с привидениями ¦ jedes Spukhaus aufkaufen ¦ racheter tous les immeubles hantés ¦ 买下每一栋闹鬼的楼
reopen the doors to the fae realm ¦ вновь открыть двери в царство фейри ¦ die Tore ins Feenreich wieder öffnen ¦ rouvrir les portes du royaume féerique ¦ 重开通往妖精国度的大门
protect humans who stumble into the hidden world ¦ защищать людей, случайно попавших в скрытый мир ¦ Menschen schützen, die in die verborgene Welt stolpern ¦ protéger les humains qui tombent dans le monde caché ¦ 保护误入隐秘世界的人类
control the city's ley lines ¦ контролировать лей-линии города ¦ die Leylinien der Stadt kontrollieren ¦ contrôler les lignes telluriques de la ville ¦ 控制城市的地脉
win a seat on the Night Court ¦ получить место в Ночном суде ¦ einen Sitz im Nachtgericht erringen ¦ obtenir un siège à la Cour de la Nuit ¦ 在夜之法庭谋得一席
cure vampirism ¦ излечить вампиризм ¦ den Vampirismus heilen ¦ guérir le vampirisme ¦ 治愈吸血鬼症
''',
  'faction_method': '''
real estate and zoning law ¦ недвижимость и правила застройки ¦ Immobilien und Bauordnung ¦ l'immobilier et le droit de l'urbanisme ¦ 房地产与区划法
favors owed and collected ¦ услуги — задолженные и взысканные ¦ Gefallen, geschuldet und eingefordert ¦ des faveurs dues et réclamées ¦ 欠下与讨回的人情
a network of pigeons and stray cats ¦ сеть из голубей и бродячих кошек ¦ ein Netzwerk aus Tauben und Streunerkatzen ¦ un réseau de pigeons et de chats errants ¦ 由鸽子和流浪猫组成的情报网
glamour and very good lawyers ¦ чары и очень хорошие юристы ¦ Blendwerk und sehr gute Anwälte ¦ des illusions et de très bons avocats ¦ 幻术加上非常厉害的律师
bake sales that fund protective wards ¦ распродажи выпечки, финансирующие обереги ¦ Kuchenbasare, die Schutzzeichen finanzieren ¦ des ventes de gâteaux qui financent les protections ¦ 为防护结界筹资的烘焙义卖
viral videos with hidden sigils ¦ вирусные видео со скрытыми сигилами ¦ virale Videos mit versteckten Siegeln ¦ des vidéos virales aux sceaux cachés ¦ 暗藏符印的病毒视频
night patrols on the rooftops ¦ ночные патрули на крышах ¦ nächtliche Streifen auf den Dächern ¦ des patrouilles nocturnes sur les toits ¦ 屋顶上的夜间巡逻
contracts signed with true names ¦ договоры, подписанные истинными именами ¦ mit wahren Namen unterzeichnete Verträge ¦ des contrats signés de vrais noms ¦ 以真名签下的契约
''',
  'faction_symbol': '''
a key crossed with a subway token ¦ ключ, скрещённый с жетоном метро ¦ ein Schlüssel, gekreuzt mit einer U-Bahn-Münze ¦ une clé croisée avec un jeton de métro ¦ 与地铁代币交叉的钥匙
a crescent moon inside a coffee cup ¦ полумесяц в чашке кофе ¦ ein Halbmond in einer Kaffeetasse ¦ un croissant de lune dans une tasse de café ¦ 咖啡杯里的新月
a door with an eye for a knob ¦ дверь с глазом вместо ручки ¦ eine Tür mit einem Auge als Knauf ¦ une porte dont la poignée est un œil ¦ 门把手是一只眼睛的门
a silver paw print ¦ серебряный отпечаток лапы ¦ ein silberner Pfotenabdruck ¦ une empreinte de patte en argent ¦ 银色的爪印
a thorned rose around a streetlight ¦ роза с шипами, обвившая фонарный столб ¦ eine Dornenrose um eine Straßenlaterne ¦ une rose épineuse enroulée autour d'un réverbère ¦ 缠绕路灯的带刺玫瑰
a pigeon wearing a crown ¦ голубь в короне ¦ eine Taube mit Krone ¦ un pigeon couronné ¦ 戴王冠的鸽子
a triangle of salt with a nail in the middle ¦ треугольник из соли с гвоздём посередине ¦ ein Salzdreieck mit einem Nagel in der Mitte ¦ un triangle de sel avec un clou au centre ¦ 中间钉着钉子的盐三角
a spray-painted seven-pointed star ¦ нарисованная баллончиком семиконечная звезда ¦ ein gesprühter siebenzackiger Stern ¦ une étoile à sept branches peinte à la bombe ¦ 喷漆画的七角星
''',
  'weather_sky': '''
orange city glow hides every star ¦ оранжевое зарево города скрывает все звёзды ¦ das orange Stadtleuchten verdeckt jeden Stern ¦ la lueur orange de la ville cache toutes les étoiles ¦ 城市的橙色光晕掩盖了所有星星
a thunderstorm rattles the skyscraper windows ¦ гроза сотрясает окна небоскрёбов ¦ ein Gewitter lässt die Fenster der Wolkenkratzer klirren ¦ un orage fait trembler les vitres des gratte-ciel ¦ 雷暴震得摩天楼的窗户嗡嗡作响
a full moon hangs between two towers ¦ полная луна висит между двумя башнями ¦ ein Vollmond hängt zwischen zwei Hochhäusern ¦ une pleine lune pend entre deux tours ¦ 一轮满月悬在两座高楼之间
drizzle turns the streets into mirrors ¦ морось превращает улицы в зеркала ¦ Nieselregen verwandelt die Straßen in Spiegel ¦ la bruine change les rues en miroirs ¦ 毛毛雨把街道变成了镜子
the first snow muffles the traffic ¦ первый снег приглушает шум машин ¦ der erste Schnee dämpft den Verkehr ¦ la première neige étouffe la circulation ¦ 初雪让车流声变得沉闷
a heat wave keeps everyone out on the fire escapes ¦ из-за жары все сидят на пожарных лестницах ¦ eine Hitzewelle treibt alle auf die Feuertreppen ¦ une canicule pousse tout le monde sur les escaliers de secours ¦ 热浪让所有人都待在消防梯上
low clouds swallow the tops of the towers ¦ низкие облака проглатывают верхушки башен ¦ tiefe Wolken verschlucken die Spitzen der Hochhäuser ¦ des nuages bas avalent le sommet des tours ¦ 低云吞没了高楼的顶端
a strange green aurora flickers over the river ¦ странное зелёное сияние мерцает над рекой ¦ ein seltsames grünes Polarlicht flackert über dem Fluss ¦ une étrange aurore verte vacille au-dessus du fleuve ¦ 河面上闪烁着奇异的绿色极光
''',
  'weather_air': '''
the air smells of rain on hot asphalt ¦ воздух пахнет дождём на горячем асфальте ¦ die Luft riecht nach Regen auf heißem Asphalt ¦ l'air sent la pluie sur l'asphalte chaud ¦ 空气里是雨水落在热沥青上的味道
steam rises from the manholes ¦ из канализационных люков поднимается пар ¦ Dampf steigt aus den Gullys ¦ de la vapeur monte des bouches d'égout ¦ 蒸汽从井盖里冒出来
a warm wind carries music from nowhere ¦ тёплый ветер доносит музыку неведомо откуда ¦ ein warmer Wind trägt Musik von nirgendwoher ¦ un vent tiède porte une musique venue de nulle part ¦ 暖风送来不知从何处传来的音乐
the cold makes the streetlights buzz ¦ от холода фонари гудят ¦ die Kälte lässt die Straßenlaternen summen ¦ le froid fait bourdonner les réverbères ¦ 寒冷让路灯嗡嗡作响
the air tastes faintly of copper and magic ¦ воздух слегка отдаёт медью и магией ¦ die Luft schmeckt leicht nach Kupfer und Magie ¦ l'air a un léger goût de cuivre et de magie ¦ 空气里隐约有铜和魔法的味道
the wind between the buildings howls like wolves ¦ ветер между домами воет, как волки ¦ der Wind zwischen den Häusern heult wie Wölfe ¦ le vent entre les immeubles hurle comme des loups ¦ 楼宇间的风像狼一样嚎叫
a sticky humidity clings to everything ¦ липкая влажность облепляет всё ¦ eine klebrige Schwüle haftet an allem ¦ une humidité poisseuse colle à tout ¦ 黏糊糊的潮气附着在一切上
the city is unusually, unnervingly quiet ¦ город необычно, пугающе тих ¦ die Stadt ist ungewöhnlich, beunruhigend still ¦ la ville est étrangement, inquiétamment calme ¦ 城市异乎寻常地安静，令人不安
''',
  'weather_omen': '''
every cat in the neighborhood sits facing east ¦ все кошки района сидят мордой на восток ¦ jede Katze im Viertel sitzt nach Osten gewandt ¦ tous les chats du quartier sont assis face à l'est ¦ 社区里每只猫都面朝东坐着
the subway announces a stop that does not exist ¦ в метро объявляют несуществующую станцию ¦ die U-Bahn kündigt eine Haltestelle an, die es nicht gibt ¦ le métro annonce un arrêt qui n'existe pas ¦ 地铁广播报出一个不存在的站名
crows gather on the power lines in perfect silence ¦ вороны собираются на проводах в полном молчании ¦ Krähen sammeln sich völlig stumm auf den Stromleitungen ¦ des corbeaux se rassemblent sur les fils électriques en silence ¦ 乌鸦聚在电线上，一声不吭
every traffic light turns red at once ¦ все светофоры разом загораются красным ¦ alle Ampeln schalten gleichzeitig auf Rot ¦ tous les feux passent au rouge en même temps ¦ 所有红绿灯同时变红
a fairy ring of mushrooms appears in a parking lot ¦ на парковке появляется ведьмин круг из грибов ¦ auf einem Parkplatz erscheint ein Hexenring aus Pilzen ¦ un cercle de champignons apparaît sur un parking ¦ 停车场里长出了一圈蘑菇仙环
the church bells ring for no one ¦ церковные колокола звонят ни для кого ¦ die Kirchenglocken läuten für niemanden ¦ les cloches sonnent pour personne ¦ 教堂的钟为无人而鸣
every radio catches the same old song ¦ все радио ловят одну и ту же старую песню ¦ jedes Radio empfängt dasselbe alte Lied ¦ toutes les radios captent la même vieille chanson ¦ 每台收音机都收到同一首老歌
shadows move half a second late ¦ тени двигаются с опозданием в полсекунды ¦ Schatten bewegen sich eine halbe Sekunde zu spät ¦ les ombres bougent avec une demi-seconde de retard ¦ 影子的动作慢了半秒
''',
  'rumor_source': '''
a barista who hears everything ¦ бариста, который слышит всё ¦ ein Barista, der alles hört ¦ un barista qui entend tout ¦ 什么都能听到的咖啡师
an anonymous post on a local forum ¦ анонимный пост на местном форуме ¦ ein anonymer Beitrag in einem lokalen Forum ¦ un message anonyme sur un forum local ¦ 本地论坛上的一条匿名帖子
a ghost at the bus stop ¦ призрак на автобусной остановке ¦ ein Geist an der Bushaltestelle ¦ un fantôme à l'arrêt de bus ¦ 公交站的鬼魂
a pixie selling flowers ¦ пикси, торгующая цветами ¦ eine Pixie, die Blumen verkauft ¦ un lutin qui vend des fleurs ¦ 卖花的小精灵
the neighborhood group chat ¦ групповой чат района ¦ der Gruppenchat der Nachbarschaft ¦ la discussion de groupe du quartier ¦ 社区群聊
a tired cop at the end of a shift ¦ уставший коп в конце смены ¦ ein müder Cop am Schichtende ¦ un flic fatigué en fin de service ¦ 快下班的疲惫警察
a tarot reader in the park ¦ таролог в парке ¦ eine Tarotleserin im Park ¦ une tireuse de tarot dans le parc ¦ 公园里的塔罗占卜师
graffiti in a language only the fae can read ¦ граффити на языке, который читают только фейри ¦ Graffiti in einer Sprache, die nur Feen lesen ¦ des graffitis dans une langue que seules les fées lisent ¦ 只有妖精能读懂的涂鸦
''',
  'rumor_text': '''
the new coffee chain is a front for a vampire house ¦ новая сеть кофеен — прикрытие вампирского дома ¦ die neue Kaffeekette ist eine Tarnung für ein Vampirhaus ¦ la nouvelle chaîne de cafés sert de façade à une maison de vampires ¦ 新开的连锁咖啡店是某个吸血鬼家族的幌子
the fae are recruiting humans with good handwriting ¦ фейри вербуют людей с хорошим почерком ¦ die Feen werben Menschen mit schöner Handschrift an ¦ les fées recrutent des humains à la belle écriture ¦ 妖精在招募字写得好的人类
there is a door in the library that opens only on Tuesdays ¦ в библиотеке есть дверь, открывающаяся только по вторникам ¦ in der Bibliothek gibt es eine Tür, die sich nur dienstags öffnet ¦ il y a une porte à la bibliothèque qui ne s'ouvre que le mardi ¦ 图书馆里有扇门只在周二打开
the mayor has cast no reflection for years ¦ мэр уже много лет не отражается в зеркалах ¦ der Bürgermeister hat seit Jahren kein Spiegelbild ¦ le maire n'a plus de reflet depuis des années ¦ 市长多年来都没有倒影
a werewolf won the city marathon ¦ городской марафон выиграл оборотень ¦ ein Werwolf hat den Stadtmarathon gewonnen ¦ un loup-garou a gagné le marathon de la ville ¦ 城市马拉松的冠军是个狼人
the river spirit is in love with a bridge engineer ¦ дух реки влюблён в инженера-мостостроителя ¦ der Flussgeist ist in eine Brückeningenieurin verliebt ¦ l'esprit du fleuve est amoureux d'une ingénieure des ponts ¦ 河灵爱上了一位桥梁工程师
someone is selling bottled luck, and it works ¦ кто-то продаёт удачу в бутылках — и она действует ¦ jemand verkauft Glück in Flaschen, und es wirkt ¦ quelqu'un vend de la chance en bouteille, et ça marche ¦ 有人在卖瓶装好运，而且真的管用
the old theater is haunted by an entire audience ¦ в старом театре обитают призраки целого зрительного зала ¦ im alten Theater spukt ein ganzes Publikum ¦ le vieux théâtre est hanté par tout un public ¦ 老剧院里闹的是一整场观众的鬼
a dragon is bidding on the harbor redevelopment ¦ дракон участвует в торгах за реконструкцию гавани ¦ ein Drache bietet für die Neugestaltung des Hafens ¦ un dragon participe à l'appel d'offres pour le port ¦ 有条龙在竞标港口改造项目
the Night Court is looking for a new judge ¦ Ночной суд ищет нового судью ¦ das Nachtgericht sucht eine neue Richterin ¦ la Cour de la Nuit cherche un nouveau juge ¦ 夜之法庭在物色新法官
''',
};

const _perLang = <String, Map<String, String>>{
  'en': {
    'settle_name': '{settle_pre} {settle_suf}',
    'settle_pre': '''
Mercy
Lantern
Crossroads
Hollow
Rook
Maple
Canal
Sparrow
Gallows
Old Bridge
''',
    'settle_suf': '''
Heights
Hill
Row
Market
Park
Yards
Square
End
''',
  },
  'ru': {
    'settle_name': '{settle_suf} «{settle_pre}»',
    'settle_pre': '''
Милосердие
Фонарь
Перекрёсток
Грач
Клён
Канал
Воробей
Старый мост
Виселица
Лощина
''',
    'settle_suf': '''
Квартал
Район
Холм
Рынок
Сквер
''',
  },
  'de': {
    'settle_name': '{settle_pre}{settle_suf}',
    'settle_pre': '''
Laternen
Raben
Ahorn
Kanal
Spatzen
Galgen
Gnaden
Altbrücken
''',
    'settle_suf': '''
viertel
hügel
markt
park
platz
gasse
''',
  },
  'fr': {
    'settle_name': '{settle_suf} {settle_pre}',
    'settle_pre': '''
des Lanternes
du Corbeau
des Érables
du Canal
des Moineaux
de la Miséricorde
du Vieux-Pont
des Pendus
''',
    'settle_suf': '''
Quartier
Butte
Place
Faubourg
Marché
Parc
''',
  },
  'zh': {
    'settle_name': '{settle_pre}{settle_suf}',
    'settle_pre': '''
灯笼
乌鸦
枫叶
运河
麻雀
慈悲
旧桥
十字
''',
    'settle_suf': '''
街区
坡
市场
公园
广场
巷
''',
  },
};
