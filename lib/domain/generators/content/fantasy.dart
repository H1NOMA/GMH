import '../content_format.dart';

/// High fantasy: villages, barrows, dragons and hedge wizards.
final fantasyContent =
    PackContent.build(rows: _rows, names: _names, perLang: _perLang);

const _names = <String, String>{
  'human_given_f': '''
Maren ¦ Марен ¦ 玛伦
Elspeth ¦ Элспет ¦ 埃尔斯佩思
Isolde ¦ Изольда ¦ 伊索尔德
Rowena ¦ Ровена ¦ 罗文娜
Adela ¦ Адела ¦ 阿黛拉
Gwendolyn ¦ Гвендолин ¦ 格温德琳
Tamsin ¦ Тамсин ¦ 塔姆辛
Wilhelmina ¦ Вильгельмина ¦ 威廉明娜
Edda ¦ Эдда ¦ 埃达
Liesel ¦ Лизель ¦ 莉泽尔
Catrin ¦ Катрин ¦ 卡特琳
Odile ¦ Одиль ¦ 奥迪尔
Mirabel ¦ Мирабель ¦ 米拉贝尔
Hester ¦ Эстер ¦ 赫丝特
''',
  'human_given_m': '''
Aldric ¦ Олдрик ¦ 奥德里克
Tobias ¦ Тобиас ¦ 托拜厄斯
Garrick ¦ Гаррик ¦ 加里克
Osric ¦ Осрик ¦ 奥斯里克
Bertram ¦ Бертрам ¦ 伯特伦
Hal ¦ Хэл ¦ 哈尔
Emeric ¦ Эмерик ¦ 埃默里克
Roderick ¦ Родерик ¦ 罗德里克
Wystan ¦ Уистан ¦ 威斯坦
Anselm ¦ Ансельм ¦ 安塞尔姆
Conrad ¦ Конрад ¦ 康拉德
Piers ¦ Пирс ¦ 皮尔斯
Leofric ¦ Леофрик ¦ 利奥弗里克
Jory ¦ Джори ¦ 乔里
''',
  'human_family': '''
Thorne ¦ Торн ¦ 索恩
Ashdown ¦ Эшдаун ¦ 阿什当
Merriweather ¦ Мерриуэзер ¦ 梅里韦瑟
Holloway ¦ Холлоуэй ¦ 霍洛韦
Fairbrook ¦ Фэйрбрук ¦ 费尔布鲁克
Blackwood ¦ Блэквуд ¦ 布莱克伍德
Coldwell ¦ Колдуэлл ¦ 科尔德威尔
Harrow ¦ Харроу ¦ 哈罗
Greaves ¦ Гривз ¦ 格里夫斯
Wexley ¦ Уэксли ¦ 韦克斯利
Brandt ¦ Брандт ¦ 布兰特
Tallow ¦ Таллоу ¦ 塔洛
Marchbank ¦ Марчбэнк ¦ 马奇班克
Penhallow ¦ Пенхэллоу ¦ 彭哈洛
''',
  'elf_given': '''
{elf_pre}{elf_end}
{elf_pre}{elf_mid}{elf_end}
''',
  'elf_pre': '''
Ael ¦ Эл ¦ 埃尔
Cae ¦ Кэ ¦ 凯
Ela ¦ Эла ¦ 埃拉
Fin ¦ Фин ¦ 芬
Gal ¦ Гал ¦ 加尔
Ith ¦ Ит ¦ 伊斯
Lir ¦ Лир ¦ 利尔
Mel ¦ Мел ¦ 梅尔
Syl ¦ Сил ¦ 希尔
Thal ¦ Тал ¦ 塔尔
Vae ¦ Вэ ¦ 维
Ny ¦ Ни ¦ 尼
''',
  'elf_mid': '''
la ¦ ла ¦ 拉
ri ¦ ри ¦ 里
na ¦ на ¦ 纳
the ¦ те ¦ 瑟
lo ¦ ло ¦ 洛
dri ¦ дри ¦ 德里
ven ¦ вен ¦ 文
sa ¦ са ¦ 萨
''',
  'elf_end_f': '''
wen ¦ вен ¦ 雯
iel ¦ иэль ¦ 叶儿
ith ¦ ит ¦ 伊丝
eth ¦ эт ¦ 艾丝
ya ¦ ия ¦ 娅
ne ¦ нэ ¦ 妮
lise ¦ лис ¦ 莉丝
wyn ¦ вин ¦ 温
''',
  'elf_end_m': '''
ion ¦ ион ¦ 伊恩
as ¦ ас ¦ 亚斯
or ¦ ор ¦ 奥
ath ¦ ат ¦ 阿斯
ond ¦ онд ¦ 昂德
dir ¦ дир ¦ 迪尔
ros ¦ рос ¦ 罗斯
an ¦ ан ¦ 安
''',
  'elf_family': '{elf_house_pre}{elf_house_end}',
  'elf_house_pre': '''
Ar ¦ Ар ¦ 阿尔
Ely ¦ Эли ¦ 埃利
Ilu ¦ Илу ¦ 伊鲁
Nai ¦ Най ¦ 奈
Quel ¦ Квел ¦ 奎尔
Sil ¦ Сил ¦ 西尔
Tir ¦ Тир ¦ 蒂尔
Ul ¦ Ул ¦ 乌尔
''',
  'elf_house_end': '''
anor ¦ анор ¦ 阿诺
evar ¦ эвар ¦ 埃瓦
inde ¦ инде ¦ 因德
oris ¦ орис ¦ 奥里斯
ueth ¦ уэт ¦ 韦斯
andar ¦ андар ¦ 安达尔
ostir ¦ остир ¦ 奥斯蒂尔
''',
  'dwarf_given': '{dwarf_pre}{dwarf_end}',
  'dwarf_pre': '''
Bor ¦ Бор ¦ 博尔
Dur ¦ Дур ¦ 杜尔
Grim ¦ Грим ¦ 格里姆
Hal ¦ Хал ¦ 哈尔
Kaz ¦ Каз ¦ 卡兹
Mor ¦ Мор ¦ 莫尔
Thor ¦ Тор ¦ 索尔
Brun ¦ Брун ¦ 布伦
Dag ¦ Даг ¦ 达格
Orm ¦ Орм ¦ 奥姆
''',
  'dwarf_end_f': '''
hild ¦ хильд ¦ 希尔德
dis ¦ дис ¦ 迪丝
runa ¦ руна ¦ 露娜
wynn ¦ винн ¦ 温
gard ¦ гард ¦ 嘉德
ella ¦ элла ¦ 艾拉
ra ¦ ра ¦ 拉
dra ¦ дра ¦ 德拉
''',
  'dwarf_end_m': '''
in ¦ ин ¦ 因
grim ¦ грим ¦ 格林
rik ¦ рик ¦ 里克
dan ¦ дан ¦ 丹
ulf ¦ ульф ¦ 乌尔夫
nar ¦ нар ¦ 纳尔
bek ¦ бек ¦ 贝克
rok ¦ рок ¦ 罗克
''',
};

const _rows = <String, String>{
  'cultures': '''
@human Human ¦ Человеческие ¦ Menschlich ¦ Humains ¦ 人类
@elf Elvish ¦ Эльфийские ¦ Elfisch ¦ Elfiques ¦ 精灵
@dwarf Dwarvish ¦ Дварфийские ¦ Zwergisch ¦ Nains ¦ 矮人
''',
  'human_race': 'human ¦ человек ¦ Mensch ¦ humain~humaine ¦ 人类',
  'elf_race': 'elf ¦ эльф~эльфийка ¦ Elf~Elfe ¦ elfe ¦ 精灵',
  'dwarf_race': 'dwarf ¦ дварф~дварфийка ¦ Zwerg~Zwergin ¦ nain~naine ¦ 矮人',
  'dwarf_family': '''
Ironbeard ¦ Железнобород ¦ Eisenbart ¦ Barbe-de-Fer ¦ 铁须
Stonefist ¦ Камнерук ¦ Steinfaust ¦ Poing-de-Pierre ¦ 石拳
Hammerfall ¦ Молотобой ¦ Hammerschlag ¦ Frappe-Marteau ¦ 锤击
Deepdelver ¦ Глубокоруд ¦ Tiefgräber ¦ Creuse-Profond ¦ 深掘
Goldvein ¦ Златожил ¦ Goldader ¦ Veine-d'Or ¦ 金脉
Flintbrow ¦ Кремнелоб ¦ Feuersteinstirn ¦ Front-de-Silex ¦ 燧眉
Coalbeard ¦ Углебород ¦ Kohlenbart ¦ Barbe-de-Charbon ¦ 煤须
Stoneshield ¦ Камнещит ¦ Steinschild ¦ Bouclier-de-Pierre ¦ 石盾
Forgefire ¦ Горнопламень ¦ Essenfeuer ¦ Feu-de-Forge ¦ 炉火
Axebiter ¦ Секирогрыз ¦ Axtbeißer ¦ Mord-Hache ¦ 啃斧
Silverpick ¦ Среброкир ¦ Silberpicke ¦ Pic-d'Argent ¦ 银镐
''',
  'epithet': '''
the Grey ¦ Серый~Серая ¦ der Graue~die Graue ¦ le Gris~la Grise ¦ 灰袍
the Lame ¦ Хромой~Хромая ¦ der Lahme~die Lahme ¦ le Boiteux~la Boiteuse ¦ 跛足者
Twice-Drowned ¦ Дважды Утопленный~Дважды Утопленная ¦ der Zweimal-Ertrunkene~die Zweimal-Ertrunkene ¦ le Deux-Fois-Noyé~la Deux-Fois-Noyée ¦ 两度溺水者
the Unlucky ¦ Невезучий~Невезучая ¦ der Glücklose~die Glücklose ¦ le Malchanceux~la Malchanceuse ¦ 倒霉鬼
Oathbreaker ¦ Клятвопреступник~Клятвопреступница ¦ der Eidbrecher~die Eidbrecherin ¦ le Parjure~la Parjure ¦ 背誓者
the Quiet ¦ Тихий~Тихая ¦ der Stille~die Stille ¦ le Taciturne~la Taciturne ¦ 寡言者
Ravenfriend ¦ Друг Воронов~Подруга Воронов ¦ der Rabenfreund~die Rabenfreundin ¦ l'Ami des Corbeaux~l'Amie des Corbeaux ¦ 鸦友
Half-Hand ¦ Полурукий~Полурукая ¦ Halbhand ¦ Demi-Main ¦ 半掌
the Lantern ¦ Фонарь ¦ die Laterne ¦ la Lanterne ¦ 提灯人
Ashborn ¦ Рождённый в Пепле~Рождённая в Пепле ¦ der Aschegeborene~die Aschegeborene ¦ Né-des-Cendres~Née-des-Cendres ¦ 灰烬所生
''',
  'ancestry': '''
@human human ¦ человек ¦ Mensch ¦ humain~humaine ¦ 人类
@elf elf ¦ эльф~эльфийка ¦ Elf~Elfe ¦ elfe ¦ 精灵
@dwarf dwarf ¦ дварф~дварфийка ¦ Zwerg~Zwergin ¦ nain~naine ¦ 矮人
halfling ¦ полурослик ¦ Halbling ¦ halfelin~halfeline ¦ 半身人
@human half-elf ¦ полуэльф~полуэльфийка ¦ Halbelf~Halbelfe ¦ demi-elfe ¦ 半精灵
gnome ¦ гном~гномка ¦ Gnom~Gnomin ¦ gnome ¦ 侏儒
half-orc ¦ полуорк ¦ Halbork~Halborkin ¦ demi-orc ¦ 半兽人
''',
  'role': '''
blacksmith ¦ кузнец ¦ Schmied~Schmiedin ¦ forgeron~forgeronne ¦ 铁匠
herbalist ¦ травник~травница ¦ Kräuterkundiger~Kräuterkundige ¦ herboriste ¦ 草药师
ferry keeper ¦ паромщик~паромщица ¦ Fährmann~Fährfrau ¦ passeur~passeuse ¦ 摆渡人
temple acolyte ¦ храмовый послушник~храмовая послушница ¦ Tempeldiener~Tempeldienerin ¦ acolyte du temple ¦ 神殿侍僧
retired mercenary ¦ отставной наёмник~отставная наёмница ¦ Söldner im Ruhestand~Söldnerin im Ruhestand ¦ mercenaire à la retraite ¦ 退役佣兵
travelling tinker ¦ бродячий лудильщик~бродячая лудильщица ¦ fahrender Kesselflicker~fahrende Kesselflickerin ¦ rétameur ambulant~rétameuse ambulante ¦ 游方补锅匠
court scribe ¦ переписчик при дворе~переписчица при дворе ¦ Hofschreiber~Hofschreiberin ¦ scribe de la cour ¦ 宫廷书记官
rat-catcher ¦ крысолов~крысоловка ¦ Rattenfänger~Rattenfängerin ¦ chasseur de rats~chasseuse de rats ¦ 捕鼠人
village healer ¦ деревенский лекарь~деревенская знахарка ¦ Dorfheiler~Dorfheilerin ¦ guérisseur du village~guérisseuse du village ¦ 乡村医者
innkeeper ¦ трактирщик~трактирщица ¦ Wirt~Wirtin ¦ aubergiste ¦ 客栈老板
hedge wizard ¦ деревенский колдун~деревенская колдунья ¦ Heckenmagier~Heckenmagierin ¦ mage de campagne ¦ 乡野术士
bounty hunter ¦ охотник за головами~охотница за головами ¦ Kopfgeldjäger~Kopfgeldjägerin ¦ chasseur de primes~chasseuse de primes ¦ 赏金猎人
sergeant of the watch ¦ сержант городской стражи ¦ Wachtmeister~Wachtmeisterin ¦ sergent du guet ¦ 城卫军士
wandering minstrel ¦ странствующий менестрель ¦ fahrender Spielmann~fahrende Spielfrau ¦ ménestrel errant~ménestrelle errante ¦ 流浪吟游诗人
''',
  'appearance': '''
a lord's signet ring worn on a cord ¦ перстень с печатью лорда на шнурке ¦ ein Siegelring eines Lords an einer Schnur ¦ une chevalière de seigneur portée en pendentif ¦ 用绳子挂着一枚领主印戒
chainmail under a patched cloak ¦ кольчуга под залатанным плащом ¦ ein Kettenhemd unter einem geflickten Umhang ¦ une cotte de mailles sous une cape rapiécée ¦ 打补丁的斗篷下穿着锁子甲
a pointed hat with a singed brim ¦ остроконечная шляпа с опалёнными полями ¦ ein Spitzhut mit versengter Krempe ¦ un chapeau pointu au bord roussi ¦ 帽檐烧焦的尖顶帽
a holy symbol worn smooth by thumbs ¦ священный символ, стёртый пальцами до гладкости ¦ ein von Daumen glattgeriebenes heiliges Symbol ¦ un symbole sacré poli par les pouces ¦ 被拇指摩挲得光滑的圣徽
braids tied with a dozen iron rings ¦ косы, стянутые дюжиной железных колец ¦ Zöpfe mit einem Dutzend Eisenringen ¦ des tresses nouées d'une douzaine d'anneaux de fer ¦ 发辫上扣着十几枚铁环
a hawk's feather pinned to the hood ¦ ястребиное перо, приколотое к капюшону ¦ eine Falkenfeder am Kapuzenrand ¦ une plume de faucon épinglée au capuchon ¦ 兜帽上别着一根鹰羽
''',
  'motivation': '''
reclaim a lost family sword from a barrow ¦ вернуть из кургана родовой меч ¦ ein verlorenes Familienschwert aus einem Hügelgrab holen ¦ reprendre l'épée familiale perdue dans un tumulus ¦ 从古墓中取回遗失的家传宝剑
be knighted before the next harvest ¦ получить рыцарское звание до следующей жатвы ¦ vor der nächsten Ernte zum Ritter geschlagen werden ¦ être adoubé avant la prochaine moisson~être adoubée avant la prochaine moisson ¦ 在下次收获前受封骑士
break a curse laid on their bloodline ¦ снять проклятие со своего рода ¦ einen Fluch von der eigenen Blutlinie nehmen ¦ lever la malédiction qui frappe sa lignée ¦ 破除加在血脉上的诅咒
map the old dwarven roads ¦ нанести на карту старые дварфийские дороги ¦ die alten Zwergenstraßen kartieren ¦ cartographier les anciennes routes naines ¦ 绘制古老的矮人道路地图
learn a spell only one dead wizard knew ¦ выучить заклинание, которое знал лишь один покойный маг ¦ einen Zauber lernen, den nur ein toter Magier kannte ¦ apprendre un sort que seul un mage défunt connaissait ¦ 学会一个只有已故法师才知道的法术
see the dragon of the old songs with their own eyes ¦ своими глазами увидеть дракона из старых песен ¦ den Drachen aus den alten Liedern mit eigenen Augen sehen ¦ voir de ses yeux le dragon des vieilles chansons ¦ 亲眼见到古老歌谣中的巨龙
''',
  'secret': '''
is a changeling without knowing it ¦ подменыш и сам об этом не знает~подменыш и сама об этом не знает ¦ ist ein Wechselbalg, ohne es zu wissen ¦ est un changelin sans le savoir ¦ 是个被调包的妖精孩子，自己却不知道
serves a banished god in secret ¦ тайно служит изгнанному богу ¦ dient heimlich einem verbannten Gott ¦ sert en secret un dieu banni ¦ 暗中侍奉一位被放逐的神祇
sold their true name to a fey lord ¦ продал своё истинное имя владыке фей~продала своё истинное имя владыке фей ¦ hat den eigenen wahren Namen an einen Feenfürsten verkauft ¦ a vendu son vrai nom à un seigneur féerique ¦ 把自己的真名卖给了妖精领主
carries a letter proving the king is a bastard ¦ носит при себе письмо, доказывающее, что король — бастард ¦ trägt einen Brief bei sich, der beweist, dass der König ein Bastard ist ¦ porte une lettre prouvant que le roi est un bâtard ¦ 身藏一封信，能证明国王是私生子
deserted from the army in the last war ¦ дезертировал из армии в прошлую войну~дезертировала из армии в прошлую войну ¦ ist im letzten Krieg desertiert ¦ a déserté pendant la dernière guerre ¦ 在上一场战争中当了逃兵
hears the voice of a sword at night ¦ по ночам слышит голос меча ¦ hört nachts die Stimme eines Schwertes ¦ entend la nuit la voix d'une épée ¦ 夜里能听见一柄剑在说话
''',
  'settle_size': '''
@Village hamlet of {#2d6*5} souls ¦ хутор на {#2d6*5} душ ¦ Weiler mit {#2d6*5} Seelen ¦ hameau de {#2d6*5} âmes ¦ {#2d6*5}口人的小村落
@Village village of about {#4d6*20} people ¦ деревня, около {#4d6*20} жителей ¦ Dorf mit etwa {#4d6*20} Einwohnern ¦ village d'environ {#4d6*20} habitants ¦ 约{#4d6*20}人的村庄
@Town market town of some {#3d6*250} people ¦ торговый городок, около {#3d6*250} жителей ¦ Marktflecken mit rund {#3d6*250} Einwohnern ¦ bourg marchand d'environ {#3d6*250} habitants ¦ 约{#3d6*250}人的集镇
@City walled city of {#2d10*2000} souls ¦ город-крепость на {#2d10*2000} душ ¦ ummauerte Stadt mit {#2d10*2000} Seelen ¦ cité fortifiée de {#2d10*2000} âmes ¦ 有{#2d10*2000}人口的城郭
''',
  'settle_feature': '''
a leaning bell tower that rings on its own ¦ покосившаяся колокольня, звонящая сама по себе ¦ ein schiefer Glockenturm, der von selbst läutet ¦ un clocher penché qui sonne tout seul ¦ 一座会自己响起的歪斜钟楼
a bridge built on the bones of a giant ¦ мост, построенный на костях великана ¦ eine Brücke auf den Knochen eines Riesen ¦ un pont bâti sur les os d'un géant ¦ 建在巨人骸骨上的桥
a market held only by moonlight ¦ рынок, открытый лишь при луне ¦ ein Markt, der nur bei Mondschein stattfindet ¦ un marché qui ne se tient qu'au clair de lune ¦ 只在月光下开张的集市
an ancient oak where oaths are sworn ¦ древний дуб, у которого приносят клятвы ¦ eine uralte Eiche, unter der Eide geschworen werden ¦ un chêne antique où l'on prête serment ¦ 一棵见证誓言的古橡树
a ruined wizard's tower no one will enter ¦ разрушенная башня мага, куда никто не входит ¦ ein verfallener Magierturm, den niemand betritt ¦ une tour de mage en ruine où nul n'entre ¦ 无人敢进的法师塔废墟
hot springs that smell faintly of copper ¦ горячие источники с лёгким запахом меди ¦ heiße Quellen, die leicht nach Kupfer riechen ¦ des sources chaudes qui sentent un peu le cuivre ¦ 带着淡淡铜味的温泉
a statue of a hero whose face has been chiselled off ¦ статуя героя со сбитым лицом ¦ eine Heldenstatue mit abgemeißeltem Gesicht ¦ la statue d'un héros au visage effacé au burin ¦ 一尊面孔被凿掉的英雄雕像
walls covered in a thousand handprints ¦ стены, покрытые тысячей отпечатков ладоней ¦ Mauern voller tausend Handabdrücke ¦ des murs couverts de mille empreintes de mains ¦ 印满上千个手印的城墙
a shrine where travelers leave a single shoe ¦ святилище, где путники оставляют по одному башмаку ¦ ein Schrein, an dem Reisende je einen Schuh zurücklassen ¦ un sanctuaire où les voyageurs laissent une chaussure ¦ 旅人会留下一只鞋的神龛
a mill whose wheel turns against the current ¦ мельница, чьё колесо крутится против течения ¦ eine Mühle, deren Rad gegen die Strömung läuft ¦ un moulin dont la roue tourne à contre-courant ¦ 水车逆流而转的磨坊
''',
  'settle_trouble': '''
wolves have taken three shepherds this month ¦ волки загрызли трёх пастухов за месяц ¦ Wölfe haben diesen Monat drei Hirten gerissen ¦ les loups ont emporté trois bergers ce mois-ci ¦ 本月已有三个牧人被狼叼走
the well has turned bitter overnight ¦ вода в колодце за ночь стала горькой ¦ der Brunnen ist über Nacht bitter geworden ¦ l'eau du puits est devenue amère en une nuit ¦ 井水一夜之间变苦了
the lord's tax collector has vanished with the ledger ¦ сборщик податей исчез вместе с книгой учёта ¦ der Steuereintreiber des Lords ist mit dem Kassenbuch verschwunden ¦ le collecteur d'impôts du seigneur a disparu avec le registre ¦ 领主的税吏带着账簿失踪了
two families feud over a boundary stone ¦ две семьи враждуют из-за межевого камня ¦ zwei Familien streiten um einen Grenzstein ¦ deux familles se déchirent pour une borne ¦ 两家人为一块界石结仇
the dead in the churchyard will not stay buried ¦ мертвецы на погосте не желают лежать в могилах ¦ die Toten auf dem Kirchhof bleiben nicht begraben ¦ les morts du cimetière refusent de rester enterrés ¦ 墓园里的死人不肯安息
a goblin warband demands a toll on the road ¦ отряд гоблинов требует пошлину на дороге ¦ eine Goblinbande verlangt Wegzoll ¦ une bande de gobelins exige un péage sur la route ¦ 一伙哥布林在路上强收过路费
the harvest rots in the fields for no reason ¦ урожай гниёт на полях без всякой причины ¦ die Ernte verfault grundlos auf den Feldern ¦ la récolte pourrit aux champs sans raison ¦ 庄稼无缘无故地烂在地里
children speak of a friend no adult can see ¦ дети рассказывают о друге, которого не видят взрослые ¦ Kinder erzählen von einem Freund, den kein Erwachsener sieht ¦ les enfants parlent d'un ami qu'aucun adulte ne voit ¦ 孩子们说起一个大人看不见的朋友
a knight errant has declared the bridge closed ¦ странствующий рыцарь объявил мост закрытым ¦ ein fahrender Ritter hat die Brücke für gesperrt erklärt ¦ un chevalier errant a déclaré le pont fermé ¦ 一位游侠骑士宣布封锁了那座桥
the new priest preaches a doctrine no one recognizes ¦ новый жрец проповедует никому не знакомое учение ¦ der neue Priester predigt eine Lehre, die niemand kennt ¦ le nouveau prêtre prêche une doctrine inconnue ¦ 新来的祭司宣讲着无人听过的教义
''',
  'settle_authority': '''
an aging baron who trusts no one ¦ стареющий барон, который никому не доверяет ¦ ein alternder Baron, der niemandem traut ¦ un baron vieillissant qui ne se fie à personne ¦ 一位谁也不信任的年迈男爵
a council of three quarrelling guildmasters ¦ совет трёх вечно спорящих цеховых старшин ¦ ein Rat aus drei zerstrittenen Gildenmeistern ¦ un conseil de trois maîtres de guilde querelleurs ¦ 三位争吵不休的行会会长组成的议会
the abbess of the hill monastery ¦ настоятельница монастыря на холме ¦ die Äbtissin des Bergklosters ¦ l'abbesse du monastère de la colline ¦ 山上修道院的女院长
an elected reeve nobody voted for ¦ выборный староста, за которого никто не голосовал ¦ ein gewählter Vogt, den keiner gewählt hat ¦ un bailli élu pour qui personne n'a voté ¦ 一位没人投过票的“民选”村长
a young knight holding the keep for an absent lord ¦ молодой рыцарь, удерживающий замок для отсутствующего лорда ¦ ein junger Ritter, der die Burg für einen abwesenden Herrn hält ¦ un jeune chevalier qui garde le donjon pour un seigneur absent ¦ 替缺席领主镇守城堡的年轻骑士
the eldest of the founding families ¦ старейшина рода основателей ¦ die Älteste der Gründerfamilien ¦ l'aînée des familles fondatrices ¦ 开村家族中辈分最高的长者
a retired adventurer who bought the title ¦ бывший искатель приключений, купивший титул ¦ ein ehemaliger Abenteurer, der sich den Titel gekauft hat ¦ un ancien aventurier qui a acheté son titre ¦ 花钱买来头衔的退休冒险者
a druid circle that rules by omen ¦ круг друидов, правящий по знамениям ¦ ein Druidenzirkel, der nach Vorzeichen herrscht ¦ un cercle de druides qui gouverne selon les présages ¦ 依照征兆治理的德鲁伊议会
''',
  'est_type': '''
roadside inn ¦ придорожный постоялый двор ¦ Gasthaus an der Landstraße ¦ auberge de bord de route ¦ 路边客栈
tavern ¦ таверна ¦ Schenke ¦ taverne ¦ 酒馆
apothecary ¦ аптекарская лавка ¦ Apotheke ¦ apothicairerie ¦ 药铺
armorer's shop ¦ оружейная мастерская ¦ Waffenschmiede ¦ armurerie ¦ 军械铺
curiosity shop ¦ лавка диковин ¦ Kuriositätenladen ¦ boutique de curiosités ¦ 珍奇铺
bathhouse ¦ баня ¦ Badehaus ¦ bains publics ¦ 澡堂
''',
  'est_adj': '''
Golden ¦ золотой~золотая ¦ Goldenen ¦ doré~dorée ¦ 金
Drunken ¦ пьяный~пьяная ¦ Betrunkenen ¦ ivre ¦ 醉
One-Eyed ¦ одноглазый~одноглазая ¦ Einäugigen ¦ borgne ¦ 独眼
Sleeping ¦ спящий~спящая ¦ Schlafenden ¦ endormi~endormie ¦ 睡
Laughing ¦ смеющийся~смеющаяся ¦ Lachenden ¦ rieur~rieuse ¦ 笑
Silver ¦ серебряный~серебряная ¦ Silbernen ¦ argenté~argentée ¦ 银
Crooked ¦ кривой~кривая ¦ Krummen ¦ tordu~tordue ¦ 歪
Wandering ¦ бродячий~бродячая ¦ Wandernden ¦ errant~errante ¦ 游
Black ¦ чёрный~чёрная ¦ Schwarzen ¦ noir~noire ¦ 黑
Green ¦ зелёный~зелёная ¦ Grünen ¦ vert~verte ¦ 青
''',
  'est_noun': '''
Stag ¦ олень#m ¦ Hirsch#m ¦ Cerf#m ¦ 鹿
Hen ¦ курица#f ¦ Henne#f ¦ Poule#f ¦ 母鸡
Dragon ¦ дракон#m ¦ Lindwurm#m ¦ Dragon#m ¦ 龙
Lantern ¦ фонарь#m ¦ Laterne#f ¦ Lanterne#f ¦ 灯
Fox ¦ лиса#f ¦ Fuchs#m ¦ Renard#m ¦ 狐
Kettle ¦ котелок#m ¦ Kessel#m ¦ Chaudron#m ¦ 铜壶
Crown ¦ корона#f ¦ Krone#f ¦ Couronne#f ¦ 冠
Boar ¦ кабан#m ¦ Eber#m ¦ Sanglier#m ¦ 野猪
Owl ¦ сова#f ¦ Kauz#m ¦ Chouette#f ¦ 鸮
Harp ¦ арфа#f ¦ Harfe#f ¦ Harpe#f ¦ 琴
Bell ¦ колокол#m ¦ Glocke#f ¦ Cloche#f ¦ 钟
Mermaid ¦ русалка#f ¦ Nixe#f ¦ Sirène#f ¦ 人鱼
Griffin ¦ грифон#m ¦ Greif#m ¦ Griffon#m ¦ 狮鹫
''',
  'est_specialty': '''
a pepper stew that has simmered for eleven years ¦ перечная похлёбка, которая варится уже одиннадцать лет ¦ ein Pfeffereintopf, der seit elf Jahren köchelt ¦ un ragoût poivré qui mijote depuis onze ans ¦ 一锅已经炖了十一年的胡椒炖肉
honey mead brewed from a grandmother's recipe ¦ медовуха по бабушкиному рецепту ¦ Honigmet nach Großmutters Rezept ¦ un hydromel brassé selon la recette d'une aïeule ¦ 按祖母配方酿的蜂蜜酒
rooms with locks no thief has ever opened ¦ комнаты с замками, которые не вскрыл ни один вор ¦ Zimmer mit Schlössern, die noch kein Dieb geknackt hat ¦ des chambres aux serrures qu'aucun voleur n'a forcées ¦ 房间门锁从没被小偷撬开过
maps of the local ruins, mostly accurate ¦ карты окрестных руин, по большей части верные ¦ Karten der Ruinen ringsum, meist zutreffend ¦ des cartes des ruines alentour, souvent exactes ¦ 附近遗迹的地图，大体准确
potions sold with no questions asked ¦ зелья, которые продают без лишних вопросов ¦ Tränke, verkauft ohne Fragen ¦ des potions vendues sans poser de questions ¦ 不问来路的药水买卖
a bard contest every full moon ¦ состязание бардов каждое полнолуние ¦ ein Bardenwettstreit bei jedem Vollmond ¦ un concours de bardes à chaque pleine lune ¦ 每逢月圆举办的吟游诗人比赛
blades sharpened while you wait ¦ заточка клинков при вас ¦ Klingen, geschliffen während man wartet ¦ des lames affûtées pendant qu'on patiente ¦ 立等可取的磨刀服务
a notice board thick with job offers ¦ доска объявлений, увешанная заказами ¦ ein Anschlagbrett voller Aufträge ¦ un tableau d'annonces couvert d'offres de travail ¦ 贴满委托的告示板
smoked eel and black bread ¦ копчёный угорь и чёрный хлеб ¦ Räucheraal und Schwarzbrot ¦ de l'anguille fumée et du pain noir ¦ 熏鳗鱼配黑面包
a back room for games of chance ¦ задняя комната для азартных игр ¦ ein Hinterzimmer für Glücksspiele ¦ une arrière-salle pour les jeux de hasard ¦ 供人赌博的后屋
''',
  'est_patron': '''
a dwarf who pays only in uncut gems ¦ дварф, который платит лишь неогранёнными камнями ¦ ein Zwerg, der nur mit ungeschliffenen Edelsteinen zahlt ¦ un nain qui ne paie qu'en gemmes brutes ¦ 只用未切割宝石付账的矮人
a hooded ranger who never takes off her gloves ¦ следопытка в капюшоне, никогда не снимающая перчаток ¦ eine Waldläuferin mit Kapuze, die nie die Handschuhe auszieht ¦ une rôdeuse encapuchonnée qui ne quitte jamais ses gants ¦ 从不摘手套的兜帽女游侠
a retired knight telling the same war story ¦ отставной рыцарь, рассказывающий одну и ту же военную байку ¦ ein Ritter außer Dienst, der immer dieselbe Kriegsgeschichte erzählt ¦ un chevalier retraité qui raconte toujours la même histoire de guerre ¦ 总讲同一个战争故事的退役骑士
an apprentice wizard hiding from a master ¦ ученик мага, прячущийся от учителя ¦ ein Zauberlehrling auf der Flucht vor dem Meister ¦ un apprenti sorcier qui se cache de son maître ¦ 躲着师父的学徒法师
a pilgrim with a very heavy reliquary ¦ паломник с очень тяжёлым ковчегом ¦ ein Pilger mit einem sehr schweren Reliquiar ¦ un pèlerin chargé d'un très lourd reliquaire ¦ 背着沉重圣物匣的朝圣者
a merchant counting coins under the table ¦ купец, пересчитывающий монеты под столом ¦ ein Händler, der unter dem Tisch Münzen zählt ¦ un marchand qui compte ses pièces sous la table ¦ 在桌下数钱的商人
twin sisters who finish each other's threats ¦ сёстры-близнецы, договаривающие угрозы друг за друга ¦ Zwillingsschwestern, die einander die Drohungen vollenden ¦ des sœurs jumelles qui terminent les menaces l'une de l'autre ¦ 互相接着说狠话的双胞胎姐妹
a talking cat that insists it is a duke ¦ говорящий кот, уверяющий, что он герцог ¦ ein sprechender Kater, der darauf besteht, ein Herzog zu sein ¦ un chat parlant qui prétend être duc ¦ 坚称自己是公爵的会说话的猫
''',
  'hook_title': '''
The Bell Beneath the Lake ¦ Колокол на дне озера ¦ Die Glocke unter dem See ¦ La Cloche sous le lac ¦ 湖底之钟
A Crown of Wet Clay ¦ Корона из сырой глины ¦ Eine Krone aus nassem Ton ¦ Une couronne d'argile humide ¦ 湿泥之冠
The Last Honest Toll ¦ Последняя честная пошлина ¦ Der letzte ehrliche Zoll ¦ Le Dernier Péage honnête ¦ 最后一笔公道的过路费
Wolves at the Wedding ¦ Волки на свадьбе ¦ Wölfe auf der Hochzeit ¦ Des loups à la noce ¦ 婚礼上的狼
The Saint Who Walked Away ¦ Святая, которая ушла ¦ Die Heilige, die davonging ¦ La Sainte qui s'en alla ¦ 出走的圣女
Salt for the Barrow King ¦ Соль для Курганного короля ¦ Salz für den Hügelkönig ¦ Du sel pour le Roi du Tertre ¦ 献给古墓之王的盐
A Map Drawn in Blood ¦ Карта, начерченная кровью ¦ Eine mit Blut gezeichnete Karte ¦ Une carte tracée au sang ¦ 血绘地图
The Tower That Was Not There Yesterday ¦ Башня, которой вчера не было ¦ Der Turm, der gestern nicht da war ¦ La Tour qui n'était pas là hier ¦ 昨天还不存在的塔
Seven Candles for the Drowned ¦ Семь свечей для утопленников ¦ Sieben Kerzen für die Ertrunkenen ¦ Sept Chandelles pour les noyés ¦ 为溺亡者点的七支蜡烛
The Dragon's Unpaid Debt ¦ Неоплаченный долг дракона ¦ Die unbezahlte Schuld des Drachen ¦ La Dette impayée du dragon ¦ 巨龙未还的债
''',
  'hook_who': '''
a desperate miller whose daughter has vanished ¦ отчаявшийся мельник, у которого пропала дочь ¦ ein verzweifelter Müller, dessen Tochter verschwunden ist ¦ un meunier désespéré dont la fille a disparu ¦ 女儿失踪、心急如焚的磨坊主
a dying knight with an unfinished quest ¦ умирающий рыцарь с неисполненным обетом ¦ ein sterbender Ritter mit einer unvollendeten Queste ¦ un chevalier mourant à la quête inachevée ¦ 使命未竟、奄奄一息的骑士
the youngest heir of a bankrupt noble house ¦ младшая наследница разорившегося знатного рода ¦ die jüngste Erbin eines bankrotten Adelshauses ¦ la cadette d'une maison noble ruinée ¦ 破产贵族家中最年幼的继承人
a nervous temple treasurer ¦ нервный казначей храма ¦ ein nervöser Tempelschatzmeister ¦ un trésorier du temple nerveux ¦ 神色紧张的神殿司库
a goblin chieftain seeking peace ¦ гоблинский вождь, ищущий мира ¦ ein Goblinhäuptling, der Frieden sucht ¦ un chef gobelin en quête de paix ¦ 寻求和平的哥布林首领
an elven envoy with no escort ¦ эльфийская посланница без охраны ¦ eine elfische Gesandte ohne Eskorte ¦ une émissaire elfe sans escorte ¦ 孤身前来的精灵使节
the guild of chimney sweeps ¦ гильдия трубочистов ¦ die Zunft der Schornsteinfeger ¦ la guilde des ramoneurs ¦ 扫烟囱工会
a witch who lives beyond the marsh ¦ ведьма, что живёт за болотом ¦ eine Hexe, die jenseits des Moors lebt ¦ une sorcière qui vit au-delà du marais ¦ 住在沼泽另一头的女巫
a ghost bound to a mill ¦ призрак, привязанный к мельнице ¦ ein an eine Mühle gebundener Geist ¦ un fantôme lié à un moulin ¦ 被困在磨坊里的鬼魂
the town's disgraced former champion ¦ опальный бывший чемпион города ¦ der in Ungnade gefallene frühere Stadtmeister ¦ l'ancien champion déchu de la ville ¦ 声名扫地的前城镇冠军
''',
  'hook_wants': '''
recover a stolen reliquary ¦ вернуть украденный ковчег с мощами ¦ ein gestohlenes Reliquiar zurückholen ¦ récupérer un reliquaire volé ¦ 夺回被盗的圣物匣
escort a sealed coffin to the capital ¦ доставить запечатанный гроб в столицу ¦ einen versiegelten Sarg in die Hauptstadt geleiten ¦ escorter un cercueil scellé jusqu'à la capitale ¦ 护送一口密封的棺材前往王都
clear a barrow before the solstice ¦ очистить курган до солнцестояния ¦ ein Hügelgrab vor der Sonnenwende säubern ¦ nettoyer un tumulus avant le solstice ¦ 在至日之前清理一座古墓
find out who poisoned the lord's hounds ¦ выяснить, кто отравил гончих лорда ¦ herausfinden, wer die Hunde des Lords vergiftet hat ¦ découvrir qui a empoisonné les chiens du seigneur ¦ 查出是谁毒死了领主的猎犬
deliver a love letter to a rival's castle ¦ доставить любовное письмо в замок соперника ¦ einen Liebesbrief in die Burg eines Rivalen bringen ¦ livrer une lettre d'amour au château d'un rival ¦ 把一封情书送进对手的城堡
negotiate with a dragon over stolen sheep ¦ договориться с драконом об украденных овцах ¦ mit einem Drachen über gestohlene Schafe verhandeln ¦ négocier avec un dragon au sujet de moutons volés ¦ 就被偷的羊群与巨龙谈判
retrieve a true name from a hag's collection ¦ вызволить истинное имя из коллекции карги ¦ einen wahren Namen aus der Sammlung einer Vettel holen ¦ reprendre un vrai nom dans la collection d'une guenaude ¦ 从鬼婆的收藏中取回一个真名
guard a bridge for three nights ¦ охранять мост три ночи ¦ drei Nächte lang eine Brücke bewachen ¦ garder un pont pendant trois nuits ¦ 守桥三夜
bring back a cure from a lost monastery ¦ принести лекарство из затерянного монастыря ¦ ein Heilmittel aus einem verschollenen Kloster holen ¦ rapporter un remède d'un monastère oublié ¦ 从失落的修道院带回解药
prove the smith did not murder the reeve ¦ доказать, что кузнец не убивал старосту ¦ beweisen, dass der Schmied den Vogt nicht ermordet hat ¦ prouver que le forgeron n'a pas tué le bailli ¦ 证明铁匠并未杀害村长
''',
  'hook_obstacle': '''
the road is held by deserters turned bandits ¦ дорогу держат дезертиры, ставшие разбойниками ¦ Deserteure, die zu Räubern wurden, halten die Straße ¦ la route est tenue par des déserteurs devenus brigands ¦ 道路被沦为强盗的逃兵把守
a rival band of adventurers wants the same prize ¦ соперничающий отряд искателей приключений метит в ту же награду ¦ eine rivalisierende Abenteurergruppe will denselben Preis ¦ une compagnie rivale d'aventuriers convoite le même prix ¦ 一支敌对冒险队也盯上了同一件宝物
the only guide is a notorious liar ¦ единственный проводник — известный лжец ¦ der einzige Führer ist ein notorischer Lügner ¦ le seul guide est un menteur notoire ¦ 唯一的向导是出了名的骗子
the river has flooded the only ford ¦ река затопила единственный брод ¦ der Fluss hat die einzige Furt überflutet ¦ la rivière a noyé le seul gué ¦ 河水淹没了唯一的浅滩
the local lord forbids anyone to go near ¦ местный лорд запрещает кому-либо приближаться ¦ der örtliche Lord verbietet jede Annäherung ¦ le seigneur local interdit à quiconque d'approcher ¦ 当地领主禁止任何人靠近
it must be done before the next full moon ¦ всё нужно успеть до следующего полнолуния ¦ es muss vor dem nächsten Vollmond geschehen ¦ il faut agir avant la prochaine pleine lune ¦ 必须在下个满月前完成
a curse turns the reward to lead ¦ проклятие обращает награду в свинец ¦ ein Fluch verwandelt die Belohnung in Blei ¦ une malédiction change la récompense en plomb ¦ 一道诅咒会把报酬变成铅块
the church declares the task heresy ¦ церковь объявляет это дело ересью ¦ die Kirche erklärt die Aufgabe zur Ketzerei ¦ l'Église déclare la tâche hérétique ¦ 教会宣称此事是异端行径
the target is guarded by a sleeping giant ¦ цель охраняет спящий великан ¦ ein schlafender Riese bewacht das Ziel ¦ la cible est gardée par un géant endormi ¦ 目标由一位沉睡的巨人守护
nobody will speak of it for fear of a witch ¦ никто не говорит об этом из страха перед ведьмой ¦ aus Angst vor einer Hexe spricht niemand darüber ¦ personne n'ose en parler par peur d'une sorcière ¦ 人们因惧怕女巫而闭口不谈
''',
  'hook_twist': '''
the patron is the true culprit ¦ заказчик и есть настоящий виновник ¦ der Auftraggeber ist der wahre Schuldige ¦ le commanditaire est le vrai coupable ¦ 委托人才是真正的元凶
the monster is protecting the villagers ¦ чудовище защищает деревенских ¦ das Ungeheuer beschützt die Dorfbewohner ¦ le monstre protège les villageois ¦ 怪物其实在保护村民
the treasure is a living person ¦ сокровище — живой человек ¦ der Schatz ist ein lebender Mensch ¦ le trésor est une personne vivante ¦ 宝藏是一个活人
the victim faked their own death ¦ жертва инсценировала собственную смерть ¦ das Opfer hat den eigenen Tod vorgetäuscht ¦ la victime a simulé sa propre mort ¦ 受害者假死脱身
two factions hired the party for opposite goals ¦ две стороны наняли отряд ради противоположных целей ¦ zwei Parteien haben die Gruppe für gegensätzliche Ziele angeheuert ¦ deux factions ont engagé le groupe pour des buts opposés ¦ 两方势力为相反的目的雇用了队伍
the map leads somewhere else entirely ¦ карта ведёт совсем в другое место ¦ die Karte führt ganz woanders hin ¦ la carte mène tout autre part ¦ 地图指向的是完全不同的地方
the old legend was a warning, not a promise ¦ старая легенда была предупреждением, а не обещанием ¦ die alte Legende war eine Warnung, kein Versprechen ¦ la vieille légende était un avertissement, pas une promesse ¦ 古老的传说是警告，而非许诺
a party member's family is involved ¦ в деле замешана семья одного из героев ¦ die Familie eines Gruppenmitglieds steckt mit drin ¦ la famille d'un membre du groupe est impliquée ¦ 队伍中某人的家人也牵涉其中
the reward was promised to three other groups ¦ награду уже пообещали ещё трём отрядам ¦ die Belohnung wurde schon drei anderen Gruppen versprochen ¦ la récompense a déjà été promise à trois autres groupes ¦ 这份报酬早已许诺给另外三队人马
success will wake something much worse ¦ успех разбудит нечто куда худшее ¦ ein Erfolg weckt etwas weit Schlimmeres ¦ réussir réveillera quelque chose de bien pire ¦ 成功会唤醒更可怕的东西
''',
  'loot_container': '''
Bandit's strongbox ¦ Сундучок разбойника ¦ Geldkassette eines Räubers ¦ Coffret de brigand ¦ 强盗的钱匣
Knight's saddlebags ¦ Седельные сумки рыцаря ¦ Satteltaschen eines Ritters ¦ Sacoches de chevalier ¦ 骑士的鞍袋
Mouldering barrow hoard ¦ Истлевший клад из кургана ¦ Modriger Hügelgrabschatz ¦ Trésor moisi d'un tumulus ¦ 古墓里发霉的窖藏
Wizard's locked satchel ¦ Запертая сумка мага ¦ Verschlossene Tasche eines Magiers ¦ Besace verrouillée de mage ¦ 法师上锁的挎包
Scattered leavings of a dragon hoard ¦ Остатки драконьего клада ¦ Verstreute Reste eines Drachenhorts ¦ Restes épars d'un trésor de dragon ¦ 龙窟散落的残宝
Smuggler's false-bottomed crate ¦ Ящик контрабандиста с двойным дном ¦ Schmugglerkiste mit doppeltem Boden ¦ Caisse de contrebandier à double fond ¦ 走私者的夹底木箱
Temple offering chest ¦ Храмовый ящик для подношений ¦ Opferstock eines Tempels ¦ Tronc d'offrandes du temple ¦ 神殿的供奉箱
Goblin chieftain's sack ¦ Мешок гоблинского вождя ¦ Sack eines Goblinhäuptlings ¦ Sac d'un chef gobelin ¦ 哥布林首领的口袋
''',
  'loot_coin': '''
{#3d6*10} gold crowns ¦ золотые кроны: {#3d6*10} ¦ {#3d6*10} Goldkronen ¦ {#3d6*10} couronnes d'or ¦ {#3d6*10}枚金冠币
{#4d6*10} silver pennies and {#2d6} gold crowns ¦ серебряные пенни: {#4d6*10}, золотые кроны: {#2d6} ¦ {#4d6*10} Silberpfennige und {#2d6} Goldkronen ¦ {#4d6*10} deniers d'argent et {#2d6} couronnes d'or ¦ {#4d6*10}枚银便士和{#2d6}枚金冠币
a pouch of {#2d6*5} copper bits and a bent silver ring ¦ кошель с медяками ({#2d6*5}) и гнутое серебряное кольцо ¦ ein Beutel mit {#2d6*5} Kupferlingen und ein verbogener Silberring ¦ une bourse de {#2d6*5} piécettes de cuivre et un anneau d'argent tordu ¦ 一袋{#2d6*5}枚铜币和一枚弯曲的银戒指
{#1d4+1} gold ingots stamped with a forgotten crest ¦ золотые слитки с забытым гербом: {#1d4+1} ¦ {#1d4+1} Goldbarren mit einem vergessenen Wappen ¦ {#1d4+1} lingots d'or frappés d'un blason oublié ¦ {#1d4+1}根刻着失传纹章的金锭
''',
  'loot_item': '''
healing draughts ×{#1d4+1} ¦ лечебные зелья ×{#1d4+1} ¦ Heiltränke ×{#1d4+1} ¦ potions de soins ×{#1d4+1} ¦ 治疗药剂 ×{#1d4+1}
a silvered dagger with a chipped pommel ¦ посеребрённый кинжал со сколотым навершием ¦ ein versilberter Dolch mit angeschlagenem Knauf ¦ une dague argentée au pommeau ébréché ¦ 柄头有缺口的镀银匕首
a scroll of minor warding, slightly scorched ¦ свиток малого оберега, слегка обгоревший ¦ eine Schriftrolle mit kleinem Schutzzauber, leicht angesengt ¦ un parchemin de protection mineure, un peu roussi ¦ 略微烧焦的小型守护卷轴
bolts of dyed silk ×{#1d6+1} ¦ рулоны крашеного шёлка ×{#1d6+1} ¦ Ballen gefärbter Seide ×{#1d6+1} ¦ rouleaux de soie teinte ×{#1d6+1} ¦ 染色丝绸 ×{#1d6+1}
iron rations ×{#2d4} ¦ походные пайки ×{#2d4} ¦ eiserne Rationen ×{#2d4} ¦ rations de voyage ×{#2d4} ¦ 干粮 ×{#2d4}
a masterwork lute missing two strings ¦ лютня тонкой работы без двух струн ¦ eine meisterhafte Laute, der zwei Saiten fehlen ¦ un luth de maître auquel manquent deux cordes ¦ 缺了两根弦的精制鲁特琴
arrows fletched with owl feathers ×{#2d6} ¦ стрелы с совиным оперением ×{#2d6} ¦ Pfeile mit Eulenfedern ×{#2d6} ¦ flèches empennées de plumes de chouette ×{#2d6} ¦ 猫头鹰羽箭 ×{#2d6}
a garnet the size of a thumb ¦ гранат размером с большой палец ¦ ein daumengroßer Granat ¦ un grenat gros comme un pouce ¦ 拇指大小的石榴石
jars of rare spice ×{#1d4+1} ¦ баночки редких пряностей ×{#1d4+1} ¦ Tiegel mit seltenen Gewürzen ×{#1d4+1} ¦ pots d'épices rares ×{#1d4+1} ¦ 珍稀香料罐 ×{#1d4+1}
a shield bearing a stranger's coat of arms ¦ щит с чужим гербом ¦ ein Schild mit fremdem Wappen ¦ un bouclier aux armes d'un inconnu ¦ 绘有陌生纹章的盾牌
candles of blessed wax ×{#1d6+1} ¦ свечи из освящённого воска ×{#1d6+1} ¦ Kerzen aus geweihtem Wachs ×{#1d6+1} ¦ chandelles de cire bénite ×{#1d6+1} ¦ 祝圣蜡烛 ×{#1d6+1}
a potion that smells of thunder ¦ зелье, пахнущее грозой ¦ ein Trank, der nach Gewitter riecht ¦ une potion qui sent l'orage ¦ 一瓶闻起来有雷雨气息的药水
a fine cloak lined with fox fur ¦ добротный плащ на лисьем меху ¦ ein feiner Umhang mit Fuchspelzfutter ¦ une belle cape doublée de renard ¦ 狐皮里衬的精致斗篷
lockpicks in an oilcloth roll ¦ отмычки в промасленном свёртке ¦ Dietriche in einer Öltuchrolle ¦ des crochets dans un rouleau de toile cirée ¦ 油布包着的一套开锁工具
a spellbook with half its pages cut out ¦ книга заклинаний, из которой вырезана половина страниц ¦ ein Zauberbuch, aus dem die Hälfte der Seiten geschnitten ist ¦ un grimoire dont on a découpé la moitié des pages ¦ 被割掉一半书页的法术书
bottles of dwarven brandy ×{#1d4+1} ¦ бутылки дварфийского бренди ×{#1d4+1} ¦ Flaschen Zwergenbrand ×{#1d4+1} ¦ bouteilles d'eau-de-vie naine ×{#1d4+1} ¦ 矮人白兰地 ×{#1d4+1}
''',
  'loot_curio': '''
a music box that plays a tune nobody knows ¦ музыкальная шкатулка, играющая мелодию, которой никто не знает ¦ eine Spieldose mit einer Melodie, die niemand kennt ¦ une boîte à musique jouant un air inconnu de tous ¦ 奏着无人知晓的曲子的八音盒
a glass eye that sometimes blinks ¦ стеклянный глаз, который иногда моргает ¦ ein Glasauge, das manchmal blinzelt ¦ un œil de verre qui cligne parfois ¦ 偶尔会眨一下的玻璃眼珠
a letter addressed to one of the heroes ¦ письмо, адресованное одному из героев ¦ ein Brief an eines der Gruppenmitglieder ¦ une lettre adressée à l'un des héros ¦ 一封写给队伍中某人的信
a key that fits no lock in this world ¦ ключ, не подходящий ни к одному замку этого мира ¦ ein Schlüssel, der in kein Schloss dieser Welt passt ¦ une clé qui n'ouvre aucune serrure de ce monde ¦ 一把打不开这世上任何锁的钥匙
a tiny portrait of a crowned child ¦ крошечный портрет коронованного ребёнка ¦ ein winziges Porträt eines gekrönten Kindes ¦ un minuscule portrait d'enfant couronné ¦ 一幅戴冠孩童的小肖像
a feather that falls upward ¦ перо, падающее вверх ¦ eine Feder, die nach oben fällt ¦ une plume qui tombe vers le haut ¦ 一根向上飘落的羽毛
a dragon scale warm to the touch ¦ тёплая на ощупь драконья чешуйка ¦ eine Drachenschuppe, die sich warm anfühlt ¦ une écaille de dragon tiède au toucher ¦ 摸起来温热的龙鳞
dice carved from a saint's knucklebones ¦ игральные кости, вырезанные из костяшек святого ¦ Würfel, geschnitzt aus den Fingerknochen eines Heiligen ¦ des dés taillés dans les osselets d'un saint ¦ 用圣人指骨刻成的骰子
''',
  'faction_noun': '''
@Order Order ¦ Орден ¦ Orden ¦ Ordre ¦ 骑士团
@Guild Guild ¦ Гильдия ¦ Gilde ¦ Guilde ¦ 行会
@Cult Circle ¦ Круг ¦ Zirkel ¦ Cercle ¦ 秘会
@Company Free Company ¦ Вольная рота ¦ Freie Kompanie ¦ Compagnie franche ¦ 自由佣兵团
@Order Brotherhood ¦ Братство ¦ Bruderschaft ¦ Confrérie ¦ 兄弟会
@Family House ¦ Дом ¦ Haus ¦ Maison ¦ 家族
@Cult Cabal ¦ Клика ¦ Kabale ¦ Cabale ¦ 密党
@Tribe Clan ¦ Клан ¦ Clan ¦ Clan ¦ 氏族
''',
  'faction_of': '''
of the Grey Flame ¦ Серого Пламени ¦ der Grauen Flamme ¦ de la Flamme grise ¦ 灰焰
of the Broken Chain ¦ Разорванной Цепи ¦ der Zerbrochenen Kette ¦ de la Chaîne brisée ¦ 断链
of the Silent Bell ¦ Безмолвного Колокола ¦ der Stummen Glocke ¦ de la Cloche muette ¦ 静钟
of the Thorned Rose ¦ Тернистой Розы ¦ der Dornenrose ¦ de la Rose épineuse ¦ 荆棘玫瑰
of the Last Lantern ¦ Последнего Фонаря ¦ der Letzten Laterne ¦ de la Dernière Lanterne ¦ 末灯
of the Iron Oath ¦ Железной Клятвы ¦ des Eisernen Eides ¦ du Serment de fer ¦ 铁誓
of the Seventh Star ¦ Седьмой Звезды ¦ des Siebten Sterns ¦ de la Septième Étoile ¦ 第七星
of the Ashen Crown ¦ Пепельной Короны ¦ der Aschenen Krone ¦ de la Couronne de cendre ¦ 灰烬王冠
of the Hollow Oak ¦ Дуплистого Дуба ¦ der Hohlen Eiche ¦ du Chêne creux ¦ 空心橡树
of the Red Hand ¦ Красной Руки ¦ der Roten Hand ¦ de la Main rouge ¦ 赤手
''',
  'faction_goal': '''
restore the old royal line ¦ восстановить старую королевскую династию ¦ die alte Königslinie wiederherstellen ¦ restaurer l'ancienne lignée royale ¦ 复辟古老的王室血脉
control every river toll in the kingdom ¦ взять под контроль все речные пошлины королевства ¦ jeden Flusszoll des Reiches kontrollieren ¦ contrôler tous les péages fluviaux du royaume ¦ 掌控王国所有的河道关税
wake a sleeping god ¦ пробудить спящего бога ¦ einen schlafenden Gott erwecken ¦ réveiller un dieu endormi ¦ 唤醒一位沉睡的神祇
drive magic out of the realm ¦ изгнать магию из королевства ¦ die Magie aus dem Reich vertreiben ¦ chasser la magie du royaume ¦ 将魔法逐出王国
protect travelers on the old roads ¦ защищать путников на старых дорогах ¦ Reisende auf den alten Straßen beschützen ¦ protéger les voyageurs sur les vieilles routes ¦ 守护古道上的旅人
reforge a legendary sword from its scattered shards ¦ собрать и перековать осколки легендарного меча ¦ ein legendäres Schwert aus seinen verstreuten Splittern neu schmieden ¦ reforger une épée légendaire à partir de ses éclats ¦ 以散落的碎片重铸一柄传奇之剑
buy a seat on the king's council ¦ купить место в королевском совете ¦ sich einen Sitz im Kronrat erkaufen ¦ acheter un siège au conseil du roi ¦ 买下御前会议的一席之地
keep the dragons asleep for another century ¦ удержать драконов во сне ещё на век ¦ die Drachen ein weiteres Jahrhundert schlafen lassen ¦ garder les dragons endormis un siècle de plus ¦ 让巨龙再沉睡一百年
''',
  'faction_method': '''
bribery and carefully arranged marriages ¦ взятки и тщательно устроенные браки ¦ Bestechung und sorgfältig arrangierte Ehen ¦ pots-de-vin et mariages arrangés avec soin ¦ 贿赂与精心安排的联姻
assassins disguised as pilgrims ¦ убийцы под видом паломников ¦ als Pilger verkleidete Meuchler ¦ des assassins déguisés en pèlerins ¦ 伪装成朝圣者的刺客
charity that creates quiet debts ¦ благотворительность, порождающая тихие долги ¦ Wohltätigkeit, die stille Schulden schafft ¦ une charité qui crée des dettes silencieuses ¦ 用施舍换来无声的人情债
forged charters and false heirs ¦ поддельные грамоты и ложные наследники ¦ gefälschte Urkunden und falsche Erben ¦ fausses chartes et faux héritiers ¦ 伪造文书与冒牌继承人
open battle with hired swords ¦ открытый бой силами наёмников ¦ offene Schlachten mit gekauften Klingen ¦ la bataille ouverte avec des lames louées ¦ 雇佣刀剑，公开开战
secrets gathered by servants and cooks ¦ тайны, собранные слугами и кухарками ¦ Geheimnisse, gesammelt von Dienern und Köchen ¦ des secrets recueillis par valets et cuisiniers ¦ 由仆役和厨子搜集的秘密
rituals at forgotten standing stones ¦ ритуалы у забытых менгиров ¦ Rituale an vergessenen Menhiren ¦ des rituels aux menhirs oubliés ¦ 在被遗忘的立石旁举行仪式
patient purchase of land, field by field ¦ терпеливая скупка земель, поле за полем ¦ geduldiger Landkauf, Feld für Feld ¦ l'achat patient de terres, champ après champ ¦ 耐心地一块一块收购土地
''',
  'faction_symbol': '''
a candle inside a closed fist ¦ свеча в сжатом кулаке ¦ eine Kerze in geschlossener Faust ¦ une chandelle dans un poing fermé ¦ 握在拳中的蜡烛
a key crossed with a quill ¦ ключ, скрещённый с пером ¦ ein Schlüssel, gekreuzt mit einer Feder ¦ une clé croisée avec une plume ¦ 钥匙与羽毛笔交叉
a white stag with no eyes ¦ белый олень без глаз ¦ ein weißer Hirsch ohne Augen ¦ un cerf blanc sans yeux ¦ 无眼的白鹿
three drops of blood on a silver field ¦ три капли крови на серебряном поле ¦ drei Blutstropfen auf silbernem Grund ¦ trois gouttes de sang sur champ d'argent ¦ 银底上的三滴血
an hourglass wrapped in ivy ¦ песочные часы, обвитые плющом ¦ eine von Efeu umrankte Sanduhr ¦ un sablier enlacé de lierre ¦ 缠着常春藤的沙漏
a broken sword pointing downward ¦ сломанный меч остриём вниз ¦ ein zerbrochenes, nach unten weisendes Schwert ¦ une épée brisée pointée vers le bas ¦ 剑尖朝下的断剑
a crescent moon holding a coin ¦ полумесяц, держащий монету ¦ ein Halbmond, der eine Münze hält ¦ un croissant de lune tenant une pièce ¦ 托着一枚硬币的新月
an owl with a crown of thorns ¦ сова в терновом венце ¦ eine Eule mit Dornenkrone ¦ une chouette couronnée d'épines ¦ 戴荆棘冠的猫头鹰
''',
  'weather_sky': '''
low grey clouds drag across the hills ¦ низкие серые тучи ползут над холмами ¦ tiefe graue Wolken schleppen sich über die Hügel ¦ des nuages bas et gris traînent sur les collines ¦ 低垂的灰云拖过山丘
a hard blue sky without a single cloud ¦ резкое синее небо без единого облака ¦ ein hartes, wolkenloses Blau ¦ un ciel d'un bleu dur, sans un nuage ¦ 万里无云的湛蓝天空
thunderheads pile up in the west ¦ на западе громоздятся грозовые тучи ¦ im Westen türmen sich Gewitterwolken ¦ des nuages d'orage s'amoncellent à l'ouest ¦ 西边雷雨云层层堆积
fine drizzle soaks through every cloak ¦ мелкая морось пропитывает любой плащ ¦ feiner Nieselregen durchdringt jeden Umhang ¦ une bruine fine transperce chaque cape ¦ 细雨绵绵，湿透每件斗篷
thick morning fog hides the road ¦ густой утренний туман скрывает дорогу ¦ dichter Morgennebel verschluckt die Straße ¦ un épais brouillard matinal cache la route ¦ 浓重的晨雾吞没了道路
the first snow of the year falls in fat flakes ¦ первый в году снег падает крупными хлопьями ¦ der erste Schnee des Jahres fällt in dicken Flocken ¦ la première neige de l'année tombe à gros flocons ¦ 今年的第一场雪纷纷扬扬
a red sunset bleeds across the whole sky ¦ красный закат заливает всё небо ¦ ein roter Sonnenuntergang blutet über den Himmel ¦ un couchant rouge saigne sur tout le ciel ¦ 血红的晚霞铺满天空
a pale sun hangs behind a veil of high haze ¦ бледное солнце висит за пеленой высокой дымки ¦ eine blasse Sonne hängt hinter hohem Dunst ¦ un soleil pâle pend derrière un voile de brume ¦ 苍白的太阳挂在高空薄雾之后
''',
  'weather_air': '''
the wind smells of wet leaves and woodsmoke ¦ ветер пахнет мокрой листвой и дымом очагов ¦ der Wind riecht nach nassem Laub und Holzrauch ¦ le vent sent les feuilles mouillées et la fumée de bois ¦ 风中带着湿叶与柴烟的气味
the air is still and heavy as a held breath ¦ воздух тих и тяжёл, как затаённое дыхание ¦ die Luft steht still und schwer wie angehaltener Atem ¦ l'air est immobile et lourd comme un souffle retenu ¦ 空气凝滞沉重，像屏住的呼吸
a biting north wind finds every gap in the armor ¦ пронизывающий северный ветер находит каждую щель в доспехах ¦ ein beißender Nordwind findet jede Lücke in der Rüstung ¦ une bise mordante trouve chaque faille de l'armure ¦ 凛冽的北风钻进盔甲的每道缝隙
warm gusts carry pollen and birdsong ¦ тёплые порывы несут пыльцу и птичьи трели ¦ warme Böen tragen Blütenstaub und Vogelgesang ¦ des bourrasques tièdes portent pollen et chants d'oiseaux ¦ 暖风裹挟着花粉与鸟鸣
the cold is sharp enough to crack stones ¦ мороз такой, что трескаются камни ¦ die Kälte ist scharf genug, um Steine zu sprengen ¦ le froid est assez vif pour fendre les pierres ¦ 冷得能把石头冻裂
the damp gets into bones and bowstrings alike ¦ сырость пробирает и кости, и тетивы ¦ die Feuchtigkeit kriecht in Knochen und Bogensehnen ¦ l'humidité gagne les os comme les cordes d'arc ¦ 湿气钻进骨头，也浸透弓弦
the air hums faintly, as before a storm of magic ¦ воздух едва слышно гудит, как перед магической бурей ¦ die Luft summt leise wie vor einem Magiesturm ¦ l'air bourdonne faiblement, comme avant une tempête magique ¦ 空气微微嗡鸣，如同魔法风暴将至
a dry wind raises dust devils on the road ¦ сухой ветер поднимает на дороге пылевые вихри ¦ ein trockener Wind wirbelt Staubteufel auf der Straße auf ¦ un vent sec soulève des tourbillons de poussière sur la route ¦ 干燥的风在路上卷起尘旋
''',
  'weather_omen': '''
crows gather on the rooftops and do not caw ¦ вороны собираются на крышах и молчат ¦ Krähen sammeln sich auf den Dächern und schweigen ¦ les corneilles se rassemblent sur les toits sans croasser ¦ 乌鸦聚在屋顶，却一声不叫
a double rainbow ends at the old gallows ¦ двойная радуга упирается в старую виселицу ¦ ein doppelter Regenbogen endet am alten Galgen ¦ un double arc-en-ciel finit au vieux gibet ¦ 一道双彩虹落在旧绞架上
dogs howl at noon ¦ собаки воют в полдень ¦ Hunde heulen zur Mittagsstunde ¦ les chiens hurlent à midi ¦ 正午时分群犬嚎叫
the church bells ring a half-tone flat ¦ церковные колокола звонят на полтона ниже ¦ die Kirchenglocken klingen einen Halbton zu tief ¦ les cloches sonnent un demi-ton trop bas ¦ 教堂钟声低了半个音
a shooting star falls toward the mountains ¦ падающая звезда летит к горам ¦ eine Sternschnuppe fällt in Richtung der Berge ¦ une étoile filante tombe vers les montagnes ¦ 一颗流星坠向群山
milk curdles in every pail ¦ молоко скисает в каждом ведре ¦ in jedem Eimer wird die Milch sauer ¦ le lait tourne dans chaque seau ¦ 每只桶里的牛奶都结了块
the moon rises red and swollen ¦ луна восходит красной и распухшей ¦ der Mond geht rot und aufgebläht auf ¦ la lune se lève rouge et enflée ¦ 月亮升起时又红又大
no omen at all, which the old folk find worse ¦ никаких знамений — и старики считают это худшим знаком ¦ gar kein Vorzeichen – was die Alten noch schlimmer finden ¦ aucun présage, ce que les anciens trouvent pire ¦ 毫无异象——老人们觉得这更糟
''',
  'rumor_source': '''
a drunk wagon driver ¦ пьяный возница ¦ ein betrunkener Fuhrmann ¦ un charretier ivre ¦ 喝醉的车夫
the miller's gossiping wife ¦ болтливая жена мельника ¦ die geschwätzige Frau des Müllers ¦ la femme bavarde du meunier ¦ 爱嚼舌根的磨坊主妻子
a traveling priest ¦ странствующий жрец ¦ ein reisender Priester ¦ un prêtre itinérant ¦ 云游的祭司
children playing in the square ¦ дети, играющие на площади ¦ Kinder, die auf dem Platz spielen ¦ des enfants qui jouent sur la place ¦ 在广场上玩耍的孩子们
a guard coming off night watch ¦ стражник после ночной смены ¦ ein Wächter nach der Nachtwache ¦ un garde qui sort de la ronde de nuit ¦ 刚下夜班的守卫
a peddler with too many opinions ¦ коробейник, у которого на всё есть мнение ¦ ein Hausierer mit zu vielen Meinungen ¦ un colporteur qui a un avis sur tout ¦ 什么都要评论一番的货郎
the innkeeper, in a whisper ¦ трактирщик, шёпотом ¦ der Wirt, im Flüsterton ¦ l'aubergiste, à voix basse ¦ 压低嗓音的客栈老板
a letter found in a dead man's boot ¦ письмо из сапога мертвеца ¦ ein Brief aus dem Stiefel eines Toten ¦ une lettre trouvée dans la botte d'un mort ¦ 从死人靴子里找到的信
''',
  'rumor_text': '''
the old baron's ghost has been seen counting coins in the chapel ¦ призрака старого барона видели в часовне: он пересчитывал монеты ¦ der Geist des alten Barons wurde in der Kapelle beim Münzenzählen gesehen ¦ on a vu le fantôme du vieux baron compter des pièces dans la chapelle ¦ 有人看见老男爵的鬼魂在礼拜堂里数钱
a dragon egg was sold at the last fair for a single copper ¦ на прошлой ярмарке драконье яйцо продали за один медяк ¦ auf dem letzten Markt wurde ein Drachenei für einen Kupferling verkauft ¦ un œuf de dragon a été vendu une piécette à la dernière foire ¦ 上次集市上有人用一枚铜币卖掉了一颗龙蛋
the queen is already dead and the court is hiding it ¦ королева уже мертва, а двор это скрывает ¦ die Königin ist längst tot und der Hof verheimlicht es ¦ la reine est déjà morte et la cour le cache ¦ 女王早已驾崩，宫廷一直秘不发丧
the bandits in the forest are really the lord's own men ¦ разбойники в лесу — на самом деле люди лорда ¦ die Räuber im Wald sind in Wahrheit die Männer des Lords ¦ les brigands de la forêt sont en fait les hommes du seigneur ¦ 林中强盗其实是领主自己的人
the new well was dug straight into a buried temple ¦ новый колодец вырыли прямо в погребённом храме ¦ der neue Brunnen wurde mitten in einen verschütteten Tempel gegraben ¦ le nouveau puits a été creusé en plein dans un temple enfoui ¦ 新井正好挖进了一座被掩埋的神殿
the elves are buying up all the iron in the valley ¦ эльфы скупают всё железо в долине ¦ die Elfen kaufen alles Eisen im Tal auf ¦ les elfes achètent tout le fer de la vallée ¦ 精灵们正在收购山谷里所有的铁
a hermit in the hills cures any fever for a song ¦ отшельник в холмах лечит любую лихорадку за одну песню ¦ ein Einsiedler in den Hügeln heilt jedes Fieber für ein Lied ¦ un ermite des collines guérit toute fièvre contre une chanson ¦ 山里的隐士唱一首歌就能治好任何热病
this year's tax will be paid in firstborn lambs ¦ подать в этом году будут брать первыми ягнятами ¦ die Steuer wird dieses Jahr in erstgeborenen Lämmern erhoben ¦ cette année, l'impôt se paiera en agneaux premiers-nés ¦ 今年的税要用头胎羊羔来交
someone keeps leaving flowers on the witch's grave ¦ кто-то приносит цветы на могилу ведьмы ¦ jemand legt immer wieder Blumen auf das Grab der Hexe ¦ quelqu'un dépose des fleurs sur la tombe de la sorcière ¦ 有人一直在女巫的坟前献花
the hero of the old ballads is alive and keeps pigs ¦ герой старых баллад жив и разводит свиней ¦ der Held der alten Balladen lebt und züchtet Schweine ¦ le héros des vieilles ballades est vivant et élève des cochons ¦ 老歌谣里的英雄还活着，正在养猪
''',
};

const _perLang = <String, Map<String, String>>{
  'en': {
    'settle_pre': '''
Ash
Oak
Thorn
Raven
Mill
Stone
Holly
Wolf
Salt
Bright
Elder
Cold
''',
    'settle_suf': '''
ford
wick
bury
dale
holm
stead
mere
cross
hollow
gate
''',
  },
  'ru': {
    'settle_pre': '''
Бело
Черно
Камено
Дубо
Сосно
Волко
Вороно
Ясно
Красно
Липо
''',
    'settle_suf': '''
горск
речье
дол
полье
бродье
озерье
град
мостье
''',
  },
  'de': {
    'settle_pre': '''
Eichen
Asch
Raben
Stein
Wolfs
Salz
Dorn
Kalt
Mühl
Hollen
Birken
Hohen
''',
    'settle_suf': '''
furt
bach
au
feld
heim
berg
rode
hausen
tal
''',
  },
  'fr': {
    'settle_pre': '''
Beau
Roche
Clair
Mont
Chêne
Grand
Fonte
Pierre
Vieux
Noir
''',
    'settle_suf': '''
fort
val
bois
champ
pré
lac
ville
fontaine
''',
  },
  'zh': {
    'settle_pre': '''
青石
白鹿
黑水
柳
枫
鹰
狼
铁
雾
松
''',
    'settle_suf': '''
镇
村
堡
桥
渡
集
屯
坞
''',
  },
};
