import '../content_format.dart';

/// Fog-bound coastal towns, forbidden books and things below the tide.
final cosmicHorrorContent =
    PackContent.build(rows: _rows, names: _names, perLang: _perLang);

const _names = <String, String>{
  'town_given_f': '''
Abigail ¦ Эбигейл ¦ 阿比盖尔
Prudence ¦ Пруденс ¦ 普鲁登丝
Hattie ¦ Хэтти ¦ 海蒂
Lavinia ¦ Лавиния ¦ 拉维尼娅
Mercy ¦ Мерси ¦ 默西
Eudora ¦ Юдора ¦ 尤多拉
Constance ¦ Констанс ¦ 康斯坦丝
Ruth ¦ Рут ¦ 露丝
Delphine ¦ Дельфина ¦ 德尔菲娜
Winifred ¦ Уинифред ¦ 威妮弗雷德
Opal ¦ Опал ¦ 奥珀尔
Ada ¦ Ада ¦ 艾达
''',
  'town_given_m': '''
Ezra ¦ Эзра ¦ 以斯拉
Silas ¦ Сайлас ¦ 赛拉斯
Josiah ¦ Джосайя ¦ 约西亚
Amos ¦ Эймос ¦ 阿莫斯
Cyrus ¦ Сайрус ¦ 赛勒斯
Thaddeus ¦ Таддеус ¦ 撒迪厄斯
Walter ¦ Уолтер ¦ 沃尔特
Elias ¦ Элайас ¦ 伊莱亚斯
Horace ¦ Хорас ¦ 霍勒斯
Gideon ¦ Гидеон ¦ 基甸
Rufus ¦ Руфус ¦ 鲁弗斯
Nathaniel ¦ Натаниэл ¦ 纳撒尼尔
''',
  'town_family': '''
Pellham ¦ Пеллэм ¦ 佩勒姆
Hollister ¦ Холлистер ¦ 霍利斯特
Crane ¦ Крейн ¦ 克兰
Aldridge ¦ Олдридж ¦ 奥尔德里奇
Blackwell ¦ Блэкуэлл ¦ 布莱克韦尔
Pickett ¦ Пиккет ¦ 皮克特
Sayer ¦ Сэйер ¦ 塞耶
Thorndike ¦ Торндайк ¦ 桑代克
Wainwright ¦ Уэйнрайт ¦ 温赖特
Coffin ¦ Коффин ¦ 科芬
Hobbs ¦ Хоббс ¦ 霍布斯
Latham ¦ Лэтэм ¦ 莱瑟姆
Weatherby ¦ Уэзерби ¦ 韦瑟比
''',
  'scholar_given_f': '''
Helena ¦ Хелена ¦ 海伦娜
Irene ¦ Ирэн ¦ 艾琳
Margarethe ¦ Маргарете ¦ 玛格丽特
Sofia ¦ София ¦ 索菲娅
Beatrix ¦ Беатрикс ¦ 贝娅特丽克丝
Yevgenia ¦ Евгения ¦ 叶夫根尼娅
Colette ¦ Колетт ¦ 科莱特
Amelia ¦ Амелия ¦ 阿米莉亚
Rosalind ¦ Розалинд ¦ 罗莎琳德
Nadezhda ¦ Надежда ¦ 娜杰日达
Ingeborg ¦ Ингеборг ¦ 英格堡
Lucienne ¦ Люсьенна ¦ 吕西安娜
''',
  'scholar_given_m': '''
Albrecht ¦ Альбрехт ¦ 阿尔布雷希特
Émile ¦ Эмиль ¦ 埃米尔
Konstantin ¦ Константин ¦ 康斯坦丁
Ignatius ¦ Игнатиус ¦ 伊格内修斯
Lionel ¦ Лайонел ¦ 莱昂内尔
Viktor ¦ Виктор ¦ 维克多
Percival ¦ Персиваль ¦ 珀西瓦尔
Anselmo ¦ Ансельмо ¦ 安塞尔莫
Rudolf ¦ Рудольф ¦ 鲁道夫
Julian ¦ Джулиан ¦ 朱利安
Theodor ¦ Теодор ¦ 西奥多
Leopold ¦ Леопольд ¦ 利奥波德
''',
  'scholar_family': '''
Vandermeer ¦ Вандермеер ¦ 范德米尔
Ashcombe ¦ Эшком ¦ 阿什科姆
Kessler ¦ Кесслер ¦ 凯斯勒
Delacourt ¦ Делакур ¦ 德拉库尔
Brandauer ¦ Брандауэр ¦ 布兰道尔
Ferrante ¦ Ферранте ¦ 费兰特
Whitlock ¦ Уитлок ¦ 惠特洛克
Moreland ¦ Морленд ¦ 莫兰
Castellan ¦ Кастеллан ¦ 卡斯特兰
Eberhardt ¦ Эберхардт ¦ 埃伯哈特
Quennell ¦ Кеннелл ¦ 昆内尔
Rostand ¦ Ростан ¦ 罗斯唐
Ivashko ¦ Ивашко ¦ 伊瓦什科
''',
};

const _rows = <String, String>{
  'cultures': '''
@town New England townsfolk ¦ Жители Новой Англии ¦ Neuengländer ¦ Gens de Nouvelle-Angleterre ¦ 新英格兰镇民
@scholar Scholars and émigrés ¦ Учёные и эмигранты ¦ Gelehrte und Emigranten ¦ Érudits et émigrés ¦ 学者与移民
''',
  'epithet': '''
the Professor ¦ Профессор ¦ der Professor~die Professorin ¦ le Professeur~la Professeure ¦ 教授
Two-Shadows ¦ Две Тени ¦ Zweischatten ¦ Deux-Ombres ¦ 双影
the Survivor of Kettle Hill ¦ Выживший с Кеттл-Хилла~Выжившая с Кеттл-Хилла ¦ der Überlebende von Kettle Hill~die Überlebende von Kettle Hill ¦ le Survivant de Kettle Hill~la Survivante de Kettle Hill ¦ 凯特尔山幸存者
Salt-Eyes ¦ Соляные Глаза ¦ Salzauge ¦ Yeux-de-Sel ¦ 盐眼
the Dreamer ¦ Сновидец~Сновидица ¦ der Träumer~die Träumerin ¦ le Rêveur~la Rêveuse ¦ 梦者
Lucky Penny ¦ Счастливый Пенни ¦ Glückspfennig ¦ Sou-Porte-Bonheur ¦ 幸运便士
the Undrowned ¦ Неутонувший~Неутонувшая ¦ der Unertrunkene~die Unertrunkene ¦ le Non-Noyé~la Non-Noyée ¦ 不溺者
Whisper-Deaf ¦ Глухой к Шёпоту~Глухая к Шёпоту ¦ Flüstertaub ¦ Sourd-aux-Murmures~Sourde-aux-Murmures ¦ 听不见低语者
the Archivist ¦ Архивариус ¦ der Archivar~die Archivarin ¦ l'Archiviste ¦ 档案员
Grey-at-Twenty ¦ Седой-в-Двадцать~Седая-в-Двадцать ¦ Grau-mit-Zwanzig ¦ Gris-à-Vingt-Ans~Grise-à-Vingt-Ans ¦ 二十白头
''',
  'ancestry': '''
@town old-stock New Englander ¦ потомственный житель Новой Англии~потомственная жительница Новой Англии ¦ Neuengländer aus alter Familie~Neuengländerin aus alter Familie ¦ Yankee de vieille souche ¦ 新英格兰世家后裔
@scholar European émigré ¦ европейский эмигрант~европейская эмигрантка ¦ europäischer Emigrant~europäische Emigrantin ¦ émigré européen~émigrée européenne ¦ 欧洲移民
@town from a fishing village ¦ родом из рыбацкой деревни ¦ aus einem Fischerdorf ¦ issu d'un village de pêcheurs~issue d'un village de pêcheurs ¦ 渔村出身
@scholar city-bred academic ¦ выросший в городе учёный~выросшая в городе учёная ¦ in der Stadt aufgewachsener Akademiker~in der Stadt aufgewachsene Akademikerin ¦ universitaire citadin~universitaire citadine ¦ 城里长大的学者
of strangely old blood ¦ со странно древней кровью ¦ von seltsam altem Blut ¦ au sang étrangement ancien ¦ 血统古怪而古老
@town a hill farmer's child ¦ сын фермера с холмов~дочь фермера с холмов ¦ Bauernkind aus dem Hügelland ¦ enfant de fermier des collines ¦ 山区农家子弟
''',
  'role': '''
private investigator ¦ частный детектив ¦ Privatdetektiv~Privatdetektivin ¦ détective privé~détective privée ¦ 私家侦探
university librarian ¦ университетский библиотекарь~университетская библиотекарша ¦ Universitätsbibliothekar~Universitätsbibliothekarin ¦ bibliothécaire universitaire ¦ 大学图书管理员
newspaper reporter ¦ газетный репортёр ¦ Zeitungsreporter~Zeitungsreporterin ¦ reporter de presse ¦ 报社记者
asylum orderly ¦ санитар лечебницы~санитарка лечебницы ¦ Anstaltspfleger~Anstaltspflegerin ¦ infirmier d'asile~infirmière d'asile ¦ 疯人院护工
antiquarian bookseller ¦ букинист~букинистка ¦ Antiquar~Antiquarin ¦ bouquiniste ¦ 古籍书商
lighthouse keeper ¦ смотритель маяка~смотрительница маяка ¦ Leuchtturmwärter~Leuchtturmwärterin ¦ gardien de phare~gardienne de phare ¦ 灯塔看守人
country doctor ¦ сельский врач ¦ Landarzt~Landärztin ¦ médecin de campagne ¦ 乡村医生
professor of archaeology ¦ профессор археологии ¦ Professor für Archäologie~Professorin für Archäologie ¦ professeur d'archéologie ¦ 考古学教授
bootlegger ¦ бутлегер ¦ Schwarzbrenner~Schwarzbrennerin ¦ contrebandier d'alcool~contrebandière d'alcool ¦ 私酒贩子
spiritualist medium ¦ спиритический медиум ¦ spiritistisches Medium ¦ médium spirite ¦ 通灵灵媒
police detective ¦ полицейский детектив ¦ Kriminalkommissar~Kriminalkommissarin ¦ inspecteur de police~inspectrice de police ¦ 警探
fishing boat captain ¦ капитан рыболовецкого судна ¦ Kapitän eines Fischkutters~Kapitänin eines Fischkutters ¦ capitaine de chalutier ¦ 渔船船长
''',
  'appearance': '''
a tweed suit smelling of old paper ¦ твидовый костюм, пахнущий старой бумагой ¦ ein Tweedanzug, der nach altem Papier riecht ¦ un costume de tweed qui sent le vieux papier ¦ 散发旧纸味的粗花呢西装
round spectacles mended with wire ¦ круглые очки, подвязанные проволокой ¦ eine runde, mit Draht geflickte Brille ¦ des lunettes rondes réparées avec du fil de fer ¦ 用铁丝修补过的圆框眼镜
a hand that trembles when the sea is mentioned ¦ рука, дрожащая при упоминании моря ¦ eine Hand, die zittert, wenn vom Meer die Rede ist ¦ une main qui tremble quand on parle de la mer ¦ 一提到大海就发抖的手
hair gone white in a single night ¦ волосы, поседевшие за одну ночь ¦ Haare, die in einer einzigen Nacht weiß wurden ¦ des cheveux devenus blancs en une seule nuit ¦ 一夜之间变白的头发
a rain-soaked trench coat ¦ промокший плащ-тренч ¦ ein regennasser Trenchcoat ¦ un trench-coat trempé de pluie ¦ 被雨淋透的风衣
eyes set a little too wide that rarely blink ¦ чуть слишком широко посаженные глаза, редко моргающие ¦ etwas zu weit auseinanderstehende Augen, die selten blinzeln ¦ des yeux un peu trop écartés qui clignent rarement ¦ 间距略宽、很少眨动的眼睛
''',
  'motivation': '''
finish a dead mentor's research ¦ завершить исследование покойного наставника ¦ die Forschung eines toten Mentors vollenden ¦ achever les recherches d'un mentor défunt ¦ 完成已故导师的研究
find out why the dreams began ¦ выяснить, почему начались сны ¦ herausfinden, warum die Träume begannen ¦ découvrir pourquoi les rêves ont commencé ¦ 查明那些梦为何开始
keep a sibling out of the asylum ¦ уберечь брата или сестру от лечебницы ¦ ein Geschwister vor der Anstalt bewahren ¦ éviter l'asile à un frère ou une sœur ¦ 不让兄弟姐妹被关进疯人院
publish the story no editor will print ¦ опубликовать историю, которую не печатает ни один редактор ¦ die Geschichte veröffentlichen, die kein Redakteur drucken will ¦ publier l'histoire qu'aucun rédacteur n'imprimera ¦ 发表一篇没有编辑肯刊登的报道
burn a certain book before anyone reads it ¦ сжечь одну книгу, пока её никто не прочёл ¦ ein gewisses Buch verbrennen, bevor es jemand liest ¦ brûler un certain livre avant que quiconque le lise ¦ 在有人读到之前烧掉某本书
learn what really happened on the expedition ¦ узнать, что на самом деле случилось в экспедиции ¦ erfahren, was auf der Expedition wirklich geschah ¦ apprendre ce qui s'est vraiment passé pendant l'expédition ¦ 弄清那次探险中究竟发生了什么
''',
  'secret': '''
has read one page of the forbidden book ¦ прочёл одну страницу запретной книги~прочла одну страницу запретной книги ¦ hat eine Seite des verbotenen Buches gelesen ¦ a lu une page du livre interdit ¦ 读过禁书中的一页
hears the sea even far inland ¦ слышит море даже вдали от берега ¦ hört das Meer selbst tief im Landesinneren ¦ entend la mer même loin à l'intérieur des terres ¦ 即使身处内陆也能听见海声
has a grandmother nobody has ever seen ¦ имеет бабушку, которую никто никогда не видел ¦ hat eine Großmutter, die niemand je gesehen hat ¦ a une grand-mère que personne n'a jamais vue ¦ 有一位谁也没见过的祖母
draws the same symbol in their sleep ¦ во сне рисует один и тот же символ ¦ zeichnet im Schlaf immer dasselbe Symbol ¦ dessine le même symbole en dormant ¦ 睡梦中总画同一个符号
took something from the dig site ¦ унёс кое-что с места раскопок~унесла кое-что с места раскопок ¦ hat etwas von der Ausgrabungsstätte mitgenommen ¦ a emporté quelque chose du chantier de fouilles ¦ 从发掘现场带走了某样东西
attended the ceremony in the woods, once ¦ однажды побывал на обряде в лесу~однажды побывала на обряде в лесу ¦ war einmal bei der Zeremonie im Wald ¦ a assisté une fois à la cérémonie dans les bois ¦ 曾经参加过一次林中的仪式
''',
  'settle_size': '''
@Village a fishing hamlet of {#2d6*10} people ¦ рыбацкий посёлок на {#2d6*10} человек ¦ ein Fischerweiler mit {#2d6*10} Leuten ¦ un hameau de pêcheurs de {#2d6*10} âmes ¦ {#2d6*10}人的小渔村
@Village a decaying village of about {#4d6*25} people ¦ приходящая в упадок деревня, около {#4d6*25} жителей ¦ ein verfallendes Dorf mit etwa {#4d6*25} Einwohnern ¦ un village décrépit d'environ {#4d6*25} habitants ¦ 约{#4d6*25}人的破败村庄
@Town a college town of some {#3d6*400} people ¦ университетский городок, около {#3d6*400} жителей ¦ eine Universitätsstadt mit rund {#3d6*400} Einwohnern ¦ une ville universitaire d'environ {#3d6*400} habitants ¦ 约{#3d6*400}人的大学城
@City a port city of {#2d10*10000} souls ¦ портовый город, {#2d10*10000} душ ¦ eine Hafenstadt mit {#2d10*10000} Seelen ¦ une ville portuaire de {#2d10*10000} âmes ¦ {#2d10*10000}人口的港口城市
''',
  'settle_feature': '''
a church with its steeple sawn off ¦ церковь со спиленным шпилем ¦ eine Kirche mit abgesägtem Turm ¦ une église au clocher scié ¦ 尖顶被锯掉的教堂
a harbor where no gulls land ¦ гавань, где не садятся чайки ¦ ein Hafen, in dem keine Möwen landen ¦ un port où aucune mouette ne se pose ¦ 没有海鸥落脚的港口
a university library with a locked sixth floor ¦ университетская библиотека с запертым шестым этажом ¦ eine Universitätsbibliothek mit verschlossenem sechstem Stock ¦ une bibliothèque universitaire au sixième étage verrouillé ¦ 六楼上锁的大学图书馆
standing stones older than the colony ¦ менгиры старше самой колонии ¦ Menhire, älter als die Kolonie ¦ des menhirs plus anciens que la colonie ¦ 比殖民地还古老的立石
houses whose windows all face the sea ¦ дома, все окна которых смотрят на море ¦ Häuser, deren Fenster alle zum Meer zeigen ¦ des maisons dont toutes les fenêtres donnent sur la mer ¦ 所有窗户都朝向大海的房屋
a sealed mine on the hill ¦ заколоченная шахта на холме ¦ eine versiegelte Mine auf dem Hügel ¦ une mine condamnée sur la colline ¦ 山上一座被封死的矿井
a museum of curiosities nobody visits ¦ музей диковин, который никто не посещает ¦ ein Kuriositätenmuseum, das niemand besucht ¦ un musée de curiosités que personne ne visite ¦ 无人参观的奇物博物馆
a swamp that glows faintly at night ¦ болото, слабо светящееся по ночам ¦ ein Sumpf, der nachts schwach leuchtet ¦ un marais qui luit faiblement la nuit ¦ 夜里泛着微光的沼泽
a lighthouse that shines inland ¦ маяк, светящий вглубь суши ¦ ein Leuchtturm, der landeinwärts leuchtet ¦ un phare qui éclaire vers l'intérieur des terres ¦ 灯光照向内陆的灯塔
an observatory with its telescope pointed down ¦ обсерватория с телескопом, направленным вниз ¦ eine Sternwarte, deren Teleskop nach unten zeigt ¦ un observatoire au télescope pointé vers le sol ¦ 望远镜朝下的天文台
''',
  'settle_trouble': '''
fishermen return with nets full of unknown fish ¦ рыбаки возвращаются с сетями, полными неведомой рыбы ¦ Fischer kehren mit Netzen voller unbekannter Fische zurück ¦ les pêcheurs rentrent avec des filets pleins de poissons inconnus ¦ 渔民带回满网从未见过的鱼
a professor has vanished from a locked room ¦ профессор исчез из запертой комнаты ¦ ein Professor ist aus einem verschlossenen Raum verschwunden ¦ un professeur a disparu d'une pièce fermée à clé ¦ 一位教授从上锁的房间里消失了
the whole town shares the same dream ¦ весь город видит один и тот же сон ¦ die ganze Stadt träumt denselben Traum ¦ toute la ville fait le même rêve ¦ 全镇的人都做着同一个梦
a meteorite fell in the Pickett farm's field ¦ на поле фермы Пиккетов упал метеорит ¦ ein Meteorit fiel auf das Feld der Picketts ¦ une météorite est tombée dans le champ des Pickett ¦ 一块陨石落在皮克特家的田里
strangers have bought the old church ¦ незнакомцы купили старую церковь ¦ Fremde haben die alte Kirche gekauft ¦ des inconnus ont acheté la vieille église ¦ 陌生人买下了老教堂
the asylum is overcrowded with people who draw spirals ¦ лечебница переполнена людьми, рисующими спирали ¦ die Anstalt ist überfüllt mit Menschen, die Spiralen zeichnen ¦ l'asile déborde de gens qui dessinent des spirales ¦ 疯人院里挤满了画螺旋的人
the tide has not come in for three days ¦ прилив не приходит уже три дня ¦ die Flut ist seit drei Tagen nicht gekommen ¦ la marée n'est pas montée depuis trois jours ¦ 潮水已经三天没有涨了
a newspaper printed tomorrow's obituaries ¦ газета напечатала завтрашние некрологи ¦ eine Zeitung hat die Nachrufe von morgen gedruckt ¦ un journal a imprimé les nécrologies de demain ¦ 一份报纸登出了明天的讣告
cattle are found arranged in perfect circles ¦ скот находят выложенным идеальными кругами ¦ Vieh wird in perfekten Kreisen angeordnet gefunden ¦ on trouve le bétail disposé en cercles parfaits ¦ 牲畜被发现排成完美的圆圈
the bootleggers have stopped using the old cove ¦ бутлегеры перестали пользоваться старой бухтой ¦ die Schmuggler meiden plötzlich die alte Bucht ¦ les contrebandiers ont cessé d'utiliser la vieille crique ¦ 私酒贩子不再使用那个老海湾了
''',
  'settle_authority': '''
a mayor from the oldest family in town ¦ мэр из старейшего рода города ¦ ein Bürgermeister aus der ältesten Familie der Stadt ¦ un maire issu de la plus vieille famille de la ville ¦ 出身镇上最古老家族的镇长
a sheriff who has stopped asking questions ¦ шериф, переставший задавать вопросы ¦ ein Sheriff, der aufgehört hat, Fragen zu stellen ¦ un shérif qui a cessé de poser des questions ¦ 已经不再追问的警长
the dean of the university ¦ декан университета ¦ der Dekan der Universität ¦ le doyen de l'université ¦ 大学院长
a church elder who preaches a strange gospel ¦ церковный старейшина, проповедующий странное учение ¦ ein Kirchenältester, der ein seltsames Evangelium predigt ¦ un ancien de l'église qui prêche un étrange évangile ¦ 宣讲怪异福音的教会长老
the cannery owner who employs everyone ¦ владелец консервного завода, на котором работают все ¦ der Konservenfabrikant, bei dem alle arbeiten ¦ le patron de la conserverie qui emploie tout le monde ¦ 雇用了所有人的罐头厂老板
a town council that meets behind drawn curtains ¦ городской совет, заседающий за задёрнутыми шторами ¦ ein Stadtrat, der hinter zugezogenen Vorhängen tagt ¦ un conseil municipal qui se réunit rideaux tirés ¦ 拉上窗帘开会的镇议会
the widow who holds every mortgage ¦ вдова, у которой заложены все дома ¦ die Witwe, die alle Hypotheken hält ¦ la veuve qui détient toutes les hypothèques ¦ 握有所有抵押契据的寡妇
a federal agent who never gives his real name ¦ федеральный агент, никогда не называющий настоящего имени ¦ ein Bundesagent, der nie seinen echten Namen nennt ¦ un agent fédéral qui ne donne jamais son vrai nom ¦ 从不透露真名的联邦探员
''',
  'est_type': '''
speakeasy ¦ подпольный бар ¦ Flüsterkneipe ¦ bar clandestin ¦ 地下酒吧
boarding house ¦ пансион ¦ Pension ¦ pension de famille ¦ 寄宿公寓
antiquarian bookshop ¦ букинистическая лавка ¦ Antiquariat ¦ librairie ancienne ¦ 古籍书店
diner ¦ закусочная ¦ Imbiss ¦ petit restaurant ¦ 小餐馆
pharmacy ¦ аптека ¦ Drogerie ¦ pharmacie ¦ 药房
harbor chandlery ¦ портовая лавка снаряжения ¦ Schiffsausrüster ¦ shipchandler ¦ 港口船具店
''',
  'est_adj': '''
Drowned ¦ утонувший~утонувшая ¦ Ertrunkenen ¦ noyé~noyée ¦ 溺
Silent ¦ безмолвный~безмолвная ¦ Stillen ¦ silencieux~silencieuse ¦ 静
Grey ¦ серый~серая ¦ Grauen ¦ gris~grise ¦ 灰
Salted ¦ просоленный~просоленная ¦ Gesalzenen ¦ salé~salée ¦ 咸
Sunken ¦ затонувший~затонувшая ¦ Versunkenen ¦ englouti~engloutie ¦ 沉
Nameless ¦ безымянный~безымянная ¦ Namenlosen ¦ sans nom ¦ 无名
Crooked ¦ кривой~кривая ¦ Schiefen ¦ tordu~tordue ¦ 歪
Blind ¦ слепой~слепая ¦ Blinden ¦ aveugle ¦ 盲
Dreaming ¦ грезящий~грезящая ¦ Träumenden ¦ rêveur~rêveuse ¦ 梦
Tarnished ¦ потускневший~потускневшая ¦ Angelaufenen ¦ terni~ternie ¦ 锈蚀
''',
  'est_noun': '''
Anchor ¦ якорь#m ¦ Anker#m ¦ Grappin#m ¦ 锚
Gull ¦ чайка#f ¦ Möwe#f ¦ Mouette#f ¦ 鸥
Lamp ¦ лампа#f ¦ Lampe#f ¦ Lampe#f ¦ 灯
Whale ¦ кит#m ¦ Wal#m ¦ Baleine#f ¦ 鲸
Compass ¦ компас#m ¦ Kompass#m ¦ Compas#m ¦ 罗盘
Oyster ¦ устрица#f ¦ Auster#f ¦ Moule#f ¦ 牡蛎
Lighthouse ¦ маяк#m ¦ Leuchtturm#m ¦ Phare#m ¦ 灯塔
Eel ¦ угорь#m ¦ Aal#m ¦ Congre#m ¦ 鳗
Pilgrim ¦ пилигрим#m ¦ Pilger#m ¦ Pèlerin#m ¦ 朝圣者
Star ¦ звезда#f ¦ Stern#m ¦ Comète#f ¦ 星
Key ¦ ключ#m ¦ Schlüssel#m ¦ Clé#f ¦ 钥匙
Net ¦ сеть#f ¦ Netz#m ¦ Filet#m ¦ 网
''',
  'est_specialty': '''
bathtub gin served in teacups ¦ самодельный джин, подаваемый в чайных чашках ¦ Badewannengin in Teetassen ¦ du gin de baignoire servi dans des tasses à thé ¦ 用茶杯盛的私酿杜松子酒
clam chowder with an odd aftertaste ¦ похлёбка из моллюсков со странным послевкусием ¦ Muschelsuppe mit seltsamem Nachgeschmack ¦ une chaudrée de palourdes à l'arrière-goût étrange ¦ 余味古怪的蛤蜊浓汤
rare books kept behind a curtain ¦ редкие книги за занавеской ¦ seltene Bücher hinter einem Vorhang ¦ des livres rares cachés derrière un rideau ¦ 藏在帘子后面的珍本书
rooms with a sea view, whether you want one or not ¦ комнаты с видом на море — хотите вы того или нет ¦ Zimmer mit Meerblick, ob man will oder nicht ¦ des chambres avec vue sur la mer, qu'on le veuille ou non ¦ 不管你愿不愿意，房间都朝着大海
a telephone that sometimes rings from nowhere ¦ телефон, который иногда звонит неведомо откуда ¦ ein Telefon, das manchmal von nirgendwo klingelt ¦ un téléphone qui sonne parfois de nulle part ¦ 偶尔会莫名响起的电话
sleeping draughts sold without prescription ¦ снотворное без рецепта ¦ Schlaftrunk ohne Rezept ¦ des somnifères vendus sans ordonnance ¦ 不需处方就能买到的安眠药
maps of the coast marked with red circles ¦ карты побережья с красными кружками ¦ Küstenkarten mit roten Kreisen ¦ des cartes de la côte marquées de cercles rouges ¦ 标着红圈的海岸地图
jazz on a gramophone that plays too slow ¦ джаз на граммофоне, который играет слишком медленно ¦ Jazz auf einem Grammofon, das zu langsam spielt ¦ du jazz sur un gramophone qui tourne trop lentement ¦ 留声机放的爵士乐总是慢半拍
a card game whose rules nobody explains ¦ карточная игра, правил которой никто не объясняет ¦ ein Kartenspiel, dessen Regeln niemand erklärt ¦ un jeu de cartes dont personne n'explique les règles ¦ 一种没人解释规则的纸牌游戏
fresh fish every morning, even in winter ¦ свежая рыба каждое утро, даже зимой ¦ jeden Morgen frischer Fisch, selbst im Winter ¦ du poisson frais chaque matin, même en hiver ¦ 每天早上都有鲜鱼，冬天也不例外
''',
  'est_patron': '''
a graduate student who has not slept in days ¦ аспирант, не спавший несколько дней ¦ ein Doktorand, der seit Tagen nicht geschlafen hat ¦ un doctorant qui n'a pas dormi depuis des jours ¦ 好几天没睡觉的研究生
an old sailor who won't talk about his last voyage ¦ старый моряк, не желающий говорить о последнем плавании ¦ ein alter Seemann, der nicht über seine letzte Fahrt spricht ¦ un vieux marin qui refuse de parler de son dernier voyage ¦ 绝口不提最后一次出海的老水手
a medium who reads tea leaves for free ¦ медиум, бесплатно гадающая на чаинках ¦ ein Medium, das umsonst aus Teeblättern liest ¦ une médium qui lit gratuitement dans les feuilles de thé ¦ 免费看茶叶占卜的灵媒
a federal agent posing as a salesman ¦ федеральный агент под видом коммивояжёра ¦ ein Bundesagent, der sich als Vertreter ausgibt ¦ un agent fédéral qui se fait passer pour un représentant ¦ 冒充推销员的联邦探员
a pale family who always sit in the same corner ¦ бледное семейство, всегда сидящее в одном углу ¦ eine bleiche Familie, die immer in derselben Ecke sitzt ¦ une famille blême toujours assise dans le même coin ¦ 总坐在同一个角落的苍白一家人
a painter whose canvases all show the same door ¦ художник, на всех картинах которого одна и та же дверь ¦ ein Maler, dessen Bilder alle dieselbe Tür zeigen ¦ un peintre dont tous les tableaux montrent la même porte ¦ 每幅画都画着同一扇门的画家
a bootlegger with a bandaged hand ¦ бутлегер с забинтованной рукой ¦ ein Schwarzbrenner mit verbundener Hand ¦ un contrebandier à la main bandée ¦ 手上缠着绷带的私酒贩子
a retired professor who answers questions with questions ¦ профессор на пенсии, отвечающий вопросом на вопрос ¦ ein emeritierter Professor, der Fragen mit Fragen beantwortet ¦ un professeur retraité qui répond aux questions par des questions ¦ 总以问题回答问题的退休教授
''',
  'hook_title': '''
The Sixth Floor ¦ Шестой этаж ¦ Der sechste Stock ¦ Le Sixième Étage ¦ 六楼
What the Tide Left ¦ Что оставил прилив ¦ Was die Flut zurückließ ¦ Ce que la marée a laissé ¦ 潮水留下的东西
A Letter from the Expedition ¦ Письмо из экспедиции ¦ Ein Brief von der Expedition ¦ Une lettre de l'expédition ¦ 来自探险队的信
The Stars Are Wrong Tonight ¦ Сегодня звёзды не на месте ¦ Heute Nacht stehen die Sterne falsch ¦ Ce soir, les étoiles sont fausses ¦ 今夜星位有误
Salt in the Wound ¦ Соль на рану ¦ Salz in der Wunde ¦ Du sel sur la plaie ¦ 伤口上的盐
The Pickett Farm Incident ¦ Происшествие на ферме Пиккетов ¦ Der Vorfall auf der Pickett-Farm ¦ L'Incident de la ferme Pickett ¦ 皮克特农场事件
Hymns for Something Below ¦ Гимны для того, что внизу ¦ Hymnen für etwas dort unten ¦ Des hymnes pour ce qui est en bas ¦ 献给地底之物的圣歌
The Man Who Came Back Wrong ¦ Человек, который вернулся не таким ¦ Der Mann, der falsch zurückkam ¦ L'Homme revenu différent ¦ 回来后不对劲的人
Nine Pages Missing ¦ Недостаёт девяти страниц ¦ Neun fehlende Seiten ¦ Neuf pages manquantes ¦ 缺失的九页
The Lighthouse Keeper's Log ¦ Журнал смотрителя маяка ¦ Das Logbuch des Leuchtturmwärters ¦ Le Journal du gardien de phare ¦ 灯塔看守人的日志
''',
  'hook_who': '''
a wife whose husband came back from sea a stranger ¦ жена, чей муж вернулся из моря чужим ¦ eine Ehefrau, deren Mann als Fremder von der See zurückkam ¦ une épouse dont le mari est revenu de la mer en étranger ¦ 丈夫出海归来后形同陌路的妻子
a librarian who found a book that should not exist ¦ библиотекарша, нашедшая книгу, которой не должно существовать ¦ eine Bibliothekarin, die ein Buch fand, das es nicht geben dürfte ¦ une bibliothécaire qui a trouvé un livre qui ne devrait pas exister ¦ 发现了一本本不该存在的书的图书管理员
a frightened graduate student ¦ напуганный аспирант ¦ ein verängstigter Doktorand ¦ un doctorant terrifié ¦ 吓坏了的研究生
the heir of a family with a sealed attic ¦ наследник семьи с заколоченным чердаком ¦ der Erbe einer Familie mit versiegeltem Dachboden ¦ l'héritier d'une famille au grenier condamné ¦ 一个阁楼被封死的家族的继承人
a sheriff at the end of his rope ¦ шериф на пределе сил ¦ ein Sheriff am Ende seiner Kräfte ¦ un shérif à bout de forces ¦ 已经走投无路的警长
a journalist who took one photograph too many ¦ журналист, сделавший на один снимок больше, чем следовало ¦ ein Journalist, der ein Foto zu viel gemacht hat ¦ un journaliste qui a pris une photo de trop ¦ 多拍了一张照片的记者
an asylum patient with perfect recall ¦ пациентка лечебницы с безупречной памятью ¦ eine Anstaltspatientin mit perfektem Gedächtnis ¦ une patiente d'asile à la mémoire parfaite ¦ 记忆力完美的疯人院病人
the last member of a failed expedition ¦ последний участник провалившейся экспедиции ¦ das letzte Mitglied einer gescheiterten Expedition ¦ le dernier membre d'une expédition ratée ¦ 一次失败探险的最后一名成员
a girl who speaks a language no one taught her ¦ девочка, говорящая на языке, которому её никто не учил ¦ ein Mädchen, das eine Sprache spricht, die ihr niemand beigebracht hat ¦ une fillette qui parle une langue que personne ne lui a apprise ¦ 会说一种没人教过她的语言的女孩
a bootlegger who saw lights in the cove ¦ бутлегер, видевший огни в бухте ¦ ein Schmuggler, der Lichter in der Bucht gesehen hat ¦ un contrebandier qui a vu des lumières dans la crique ¦ 在海湾里看见了亮光的私酒贩子
''',
  'hook_wants': '''
retrieve a stolen manuscript before it is read aloud ¦ вернуть украденную рукопись, пока её не прочли вслух ¦ ein gestohlenes Manuskript zurückholen, bevor es laut gelesen wird ¦ récupérer un manuscrit volé avant qu'il ne soit lu à voix haute ¦ 在被大声诵读之前找回被盗的手稿
find a missing professor ¦ найти пропавшего профессора ¦ einen verschwundenen Professor finden ¦ retrouver un professeur disparu ¦ 找到失踪的教授
learn what the meteorite brought with it ¦ узнать, что принёс с собой метеорит ¦ herausfinden, was der Meteorit mitgebracht hat ¦ découvrir ce que la météorite a apporté ¦ 查清陨石带来了什么
spend a night in the lighthouse ¦ провести ночь на маяке ¦ eine Nacht im Leuchtturm verbringen ¦ passer une nuit dans le phare ¦ 在灯塔里过一夜
stop the ceremony at the next new moon ¦ остановить обряд в следующее новолуние ¦ die Zeremonie beim nächsten Neumond verhindern ¦ empêcher la cérémonie à la prochaine nouvelle lune ¦ 在下一个新月阻止仪式
decipher a dead man's notebook ¦ расшифровать записную книжку мертвеца ¦ das Notizbuch eines Toten entziffern ¦ déchiffrer le carnet d'un mort ¦ 破译一个死人的笔记本
get a patient out of the asylum ¦ вызволить пациента из лечебницы ¦ einen Patienten aus der Anstalt holen ¦ faire sortir un patient de l'asile ¦ 把一名病人从疯人院里弄出来
map the caves under the town ¦ составить карту пещер под городом ¦ die Höhlen unter der Stadt kartieren ¦ cartographier les grottes sous la ville ¦ 绘制镇子下方洞穴的地图
prove the drowning was no accident ¦ доказать, что утопление не было несчастным случаем ¦ beweisen, dass das Ertrinken kein Unfall war ¦ prouver que la noyade n'était pas un accident ¦ 证明那次溺亡并非意外
buy back a statue sold at auction ¦ выкупить статуэтку, проданную на аукционе ¦ eine versteigerte Statue zurückkaufen ¦ racheter une statue vendue aux enchères ¦ 赎回一尊被拍卖的雕像
''',
  'hook_obstacle': '''
the townsfolk shut their doors to outsiders ¦ горожане закрывают двери перед чужаками ¦ die Einheimischen verschließen ihre Türen vor Fremden ¦ les habitants ferment leur porte aux étrangers ¦ 镇民们对外人紧闭门户
every copy of the text drives its reader to obsession ¦ каждая копия текста доводит читателя до одержимости ¦ jede Abschrift des Textes treibt ihren Leser in die Besessenheit ¦ chaque copie du texte rend son lecteur obsédé ¦ 每一份抄本都会让读者陷入执念
the police are paid to look away ¦ полиции платят, чтобы она не вмешивалась ¦ die Polizei wird bezahlt, um wegzusehen ¦ la police est payée pour détourner les yeux ¦ 警察收了钱故意视而不见
a storm cuts the town off from the world ¦ буря отрезает город от мира ¦ ein Sturm schneidet die Stadt von der Welt ab ¦ une tempête coupe la ville du monde ¦ 一场风暴让小镇与世隔绝
the only witness is in the asylum ¦ единственный свидетель — в лечебнице ¦ der einzige Zeuge sitzt in der Anstalt ¦ le seul témoin est à l'asile ¦ 唯一的证人在疯人院里
the investigators' sanity is already fraying ¦ рассудок сыщиков уже на пределе ¦ der Verstand der Ermittler beginnt bereits zu bröckeln ¦ la raison des enquêteurs s'effiloche déjà ¦ 调查员们的理智已开始动摇
the university denies anything happened ¦ университет отрицает, что что-либо произошло ¦ die Universität bestreitet, dass etwas geschehen ist ¦ l'université nie que quoi que ce soit se soit passé ¦ 大学否认发生过任何事
the tunnels flood at high tide ¦ во время прилива туннели затапливает ¦ die Tunnel laufen bei Flut voll ¦ les tunnels sont inondés à marée haute ¦ 涨潮时隧道会被淹没
someone else is burning the evidence ¦ кто-то другой сжигает улики ¦ jemand anderes verbrennt die Beweise ¦ quelqu'un d'autre brûle les preuves ¦ 有人正在烧毁证据
the cult has members in every family ¦ у культа есть последователи в каждой семье ¦ der Kult hat Anhänger in jeder Familie ¦ le culte a des membres dans chaque famille ¦ 邪教在每个家庭都有信徒
''',
  'hook_twist': '''
the patron wrote the book they seek ¦ заказчик сам написал книгу, которую они ищут ¦ der Auftraggeber hat das gesuchte Buch selbst geschrieben ¦ le commanditaire a écrit le livre qu'ils cherchent ¦ 委托人正是他们在找的那本书的作者
the missing professor opened the door on purpose ¦ пропавший профессор открыл дверь нарочно ¦ der verschwundene Professor hat die Tür absichtlich geöffnet ¦ le professeur disparu a ouvert la porte exprès ¦ 失踪的教授是故意打开那扇门的
the cult is trying to keep something asleep ¦ культ пытается удержать нечто во сне ¦ der Kult versucht, etwas schlafen zu lassen ¦ le culte tente de maintenir quelque chose endormi ¦ 邪教其实是在让某物继续沉睡
one of the investigators descends from the thing below ¦ один из сыщиков происходит от того, что внизу ¦ einer der Ermittler stammt von dem Ding dort unten ab ¦ l'un des enquêteurs descend de la chose d'en bas ¦ 某位调查员是地底之物的后裔
the town made its bargain long ago ¦ город давно заключил свою сделку ¦ die Stadt hat ihren Handel längst geschlossen ¦ la ville a conclu son marché il y a longtemps ¦ 这个小镇早已做过交易
the monster is only a messenger ¦ чудовище — всего лишь посланник ¦ das Ungeheuer ist nur ein Bote ¦ le monstre n'est qu'un messager ¦ 那怪物只是个信使
the expedition never came back; these are copies ¦ экспедиция так и не вернулась — это копии ¦ die Expedition kam nie zurück – das sind Kopien ¦ l'expédition n'est jamais revenue : ce sont des copies ¦ 探险队从未归来——这些都是复制品
the stars really are wrong, and getting worse ¦ звёзды и правда не на месте, и становится всё хуже ¦ die Sterne stehen wirklich falsch – und es wird schlimmer ¦ les étoiles sont vraiment fausses, et c'est de pire en pire ¦ 星位确实有误，而且越来越糟
the asylum is the safest place in town ¦ лечебница — самое безопасное место в городе ¦ die Anstalt ist der sicherste Ort der Stadt ¦ l'asile est l'endroit le plus sûr de la ville ¦ 疯人院是镇上最安全的地方
reading the final page is the only way to stop it ¦ остановить это можно, только прочитав последнюю страницу ¦ nur das Lesen der letzten Seite kann es aufhalten ¦ seule la lecture de la dernière page peut l'arrêter ¦ 唯一的阻止办法就是读完最后一页
''',
  'loot_container': '''
Dead professor's briefcase ¦ Портфель покойного профессора ¦ Aktentasche eines toten Professors ¦ Serviette d'un professeur défunt ¦ 已故教授的公文包
Bootlegger's crate in a sea cave ¦ Ящик бутлегера в морской пещере ¦ Schmugglerkiste in einer Meereshöhle ¦ Caisse de contrebandier dans une grotte marine ¦ 海蚀洞里的私酒箱
Locked sea chest washed ashore ¦ Запертый морской сундук, выброшенный на берег ¦ Angespülte verschlossene Seekiste ¦ Coffre de marin verrouillé rejeté sur la plage ¦ 冲上岸的上锁航海箱
Cultist's altar drawer ¦ Ящик культистского алтаря ¦ Altarschublade eines Kultisten ¦ Tiroir d'autel de cultiste ¦ 邪教徒的祭坛抽屉
Asylum evidence box ¦ Коробка с уликами из лечебницы ¦ Beweiskiste aus der Anstalt ¦ Boîte à pièces de l'asile ¦ 疯人院的证物箱
Expedition footlocker ¦ Сундук экспедиции ¦ Expeditionskiste ¦ Cantine d'expédition ¦ 探险队的储物箱
Family attic trunk ¦ Сундук с семейного чердака ¦ Truhe vom Familiendachboden ¦ Malle du grenier familial ¦ 家族阁楼上的旧箱
Mislabeled museum storage crate ¦ Ящик из музейного хранилища с неверной биркой ¦ Falsch beschriftete Museumskiste ¦ Caisse de réserve de musée mal étiquetée ¦ 贴错标签的博物馆库房箱
''',
  'loot_coin': '''
{#3d6*5} dollars in worn banknotes ¦ потёртые банкноты на {#3d6*5} долларов ¦ {#3d6*5} Dollar in abgegriffenen Scheinen ¦ {#3d6*5} dollars en billets usés ¦ {#3d6*5}美元的旧钞票
a roll of {#2d6*10} dollars tied with fishing line ¦ пачка на {#2d6*10} долларов, перевязанная леской ¦ ein mit Angelschnur gebündeltes Bündel von {#2d6*10} Dollar ¦ une liasse de {#2d6*10} dollars nouée avec du fil de pêche ¦ 用钓线捆着的{#2d6*10}美元
{#1d6+1} gold coins of no known nation ¦ золотые монеты неведомой страны: {#1d6+1} ¦ {#1d6+1} Goldmünzen keines bekannten Landes ¦ {#1d6+1} pièces d'or d'aucune nation connue ¦ {#1d6+1}枚不属于任何已知国家的金币
a cheque for {#4d6*25} dollars, signed by a dead man ¦ чек на {#4d6*25} долларов, подписанный мертвецом ¦ ein Scheck über {#4d6*25} Dollar, unterschrieben von einem Toten ¦ un chèque de {#4d6*25} dollars signé par un mort ¦ 一张死人签名的{#4d6*25}美元支票
''',
  'loot_item': '''
a revolver with {#1d4+1} rounds left ¦ револьвер, в котором осталось патронов: {#1d4+1} ¦ ein Revolver mit noch {#1d4+1} Schuss ¦ un revolver auquel il reste {#1d4+1} balles ¦ 还剩{#1d4+1}发子弹的左轮手枪
a flashlight with a failing battery ¦ фонарик с садящейся батарейкой ¦ eine Taschenlampe mit schwacher Batterie ¦ une lampe torche à la pile faiblissante ¦ 电池快没电的手电筒
flasks of bootleg whiskey ×{#1d4+1} ¦ фляжки самогонного виски ×{#1d4+1} ¦ Flachmänner mit Schwarzbrand-Whiskey ×{#1d4+1} ¦ flasques de whisky de contrebande ×{#1d4+1} ¦ 私酿威士忌酒壶 ×{#1d4+1}
a camera with undeveloped film ¦ фотоаппарат с непроявленной плёнкой ¦ eine Kamera mit unentwickeltem Film ¦ un appareil photo à la pellicule non développée ¦ 装着未冲洗胶卷的相机
a first-aid kit from the war ¦ армейская аптечка времён войны ¦ ein Verbandskasten aus dem Krieg ¦ une trousse de secours datant de la guerre ¦ 战时留下的急救箱
sticks of dynamite ×{#1d3+1} ¦ динамитные шашки ×{#1d3+1} ¦ Dynamitstangen ×{#1d3+1} ¦ bâtons de dynamite ×{#1d3+1} ¦ 雷管炸药 ×{#1d3+1}
a translated fragment of an older text ¦ переведённый отрывок более древнего текста ¦ ein übersetztes Fragment eines älteren Textes ¦ un fragment traduit d'un texte plus ancien ¦ 一段更古老文本的译文残片
a brass sextant ¦ латунный секстант ¦ ein Messingsextant ¦ un sextant en laiton ¦ 黄铜六分仪
whale-oil candles ×{#1d6+1} ¦ свечи из китового жира ×{#1d6+1} ¦ Kerzen aus Waltran ×{#1d6+1} ¦ bougies à l'huile de baleine ×{#1d6+1} ¦ 鲸油蜡烛 ×{#1d6+1}
a diving helmet with a cracked faceplate ¦ водолазный шлем с треснувшим стеклом ¦ ein Taucherhelm mit gesprungener Sichtscheibe ¦ un casque de scaphandrier à la vitre fêlée ¦ 面窗开裂的潜水头盔
a train ticket to a town on no map ¦ билет на поезд до города, которого нет ни на одной карте ¦ eine Fahrkarte in eine Stadt, die auf keiner Karte steht ¦ un billet de train pour une ville absente des cartes ¦ 一张开往地图上不存在的小镇的火车票
tins of sardines ×{#2d4} ¦ банки сардин ×{#2d4} ¦ Sardinendosen ×{#2d4} ¦ boîtes de sardines ×{#2d4} ¦ 沙丁鱼罐头 ×{#2d4}
a professor's annotated star chart ¦ звёздная карта с пометками профессора ¦ eine vom Professor kommentierte Sternkarte ¦ une carte du ciel annotée par un professeur ¦ 教授批注过的星图
a straight razor engraved with initials ¦ опасная бритва с гравировкой инициалов ¦ ein Rasiermesser mit eingravierten Initialen ¦ un rasoir coupe-chou gravé d'initiales ¦ 刻着姓名缩写的折叠剃刀
a gramophone record with no label ¦ граммофонная пластинка без этикетки ¦ eine Schallplatte ohne Etikett ¦ un disque de gramophone sans étiquette ¦ 没有标签的唱片
bottles of smelling salts ×{#1d4+1} ¦ флаконы нюхательной соли ×{#1d4+1} ¦ Fläschchen Riechsalz ×{#1d4+1} ¦ flacons de sels ×{#1d4+1} ¦ 嗅盐瓶 ×{#1d4+1}
''',
  'loot_curio': '''
a small statue that is always wet ¦ маленькая статуэтка, которая всегда мокрая ¦ eine kleine Statue, die immer nass ist ¦ une petite statue toujours mouillée ¦ 一尊永远湿漉漉的小雕像
a seashell that whispers in a language no one speaks ¦ ракушка, шепчущая на языке, на котором никто не говорит ¦ eine Muschel, die in einer Sprache flüstert, die niemand spricht ¦ un coquillage qui murmure dans une langue inconnue ¦ 用无人会说的语言低语的贝壳
a photograph with one person too many ¦ фотография, на которой на одного человека больше ¦ ein Foto, auf dem eine Person zu viel ist ¦ une photographie avec une personne de trop ¦ 照片里多出了一个人
a compass that points at the nearest investigator ¦ компас, указывающий на ближайшего сыщика ¦ ein Kompass, der auf den nächsten Ermittler zeigt ¦ une boussole qui pointe vers l'enquêteur le plus proche ¦ 指针总指向最近那位调查员的罗盘
a jar of black sand that is never still ¦ банка чёрного песка, который никогда не бывает неподвижен ¦ ein Glas schwarzen Sandes, der nie stillsteht ¦ un bocal de sable noir jamais immobile ¦ 一罐永不静止的黑沙
a key of an unfamiliar green metal ¦ ключ из незнакомого зелёного металла ¦ ein Schlüssel aus unbekanntem grünem Metall ¦ une clé faite d'un étrange métal vert ¦ 用陌生绿色金属制成的钥匙
a child's drawing of the thing under the pier ¦ детский рисунок того, что живёт под пирсом ¦ eine Kinderzeichnung des Dings unter dem Pier ¦ un dessin d'enfant représentant la chose sous la jetée ¦ 画着码头下那东西的儿童画
a pocket watch that runs backward ¦ карманные часы, идущие назад ¦ eine Taschenuhr, die rückwärts läuft ¦ une montre de poche qui tourne à l'envers ¦ 倒着走的怀表
''',
  'faction_noun': '''
@Cult Hermetic Order ¦ Герметический орден ¦ Hermetischer Orden ¦ Ordre hermétique ¦ 赫尔墨斯修会
@Other Society ¦ Общество ¦ Gesellschaft ¦ Société ¦ 学会
@Cult Church ¦ Церковь ¦ Kirche ¦ Église ¦ 教会
@Company Foundation ¦ Фонд ¦ Stiftung ¦ Fondation ¦ 基金会
@Other Club ¦ Клуб ¦ Klub ¦ Club ¦ 俱乐部
@Order Lodge ¦ Ложа ¦ Loge ¦ Loge ¦ 会所
@Family Family ¦ Семья ¦ Familie ¦ Famille ¦ 家族
@Guild Fellowship ¦ Содружество ¦ Gemeinschaft ¦ Fraternité ¦ 联谊会
''',
  'faction_of': '''
of the Drowned Choir ¦ Утонувшего Хора ¦ des Ertrunkenen Chores ¦ du Chœur noyé ¦ 溺亡唱诗班
of the Green Lamp ¦ Зелёной Лампы ¦ der Grünen Lampe ¦ de la Lampe verte ¦ 绿灯
of the Seventh Tide ¦ Седьмого Прилива ¦ der Siebten Flut ¦ de la Septième Marée ¦ 第七潮
of the Open Eye ¦ Открытого Глаза ¦ des Offenen Auges ¦ de l'Œil ouvert ¦ 睁眼
of the Starless Sky ¦ Беззвёздного Неба ¦ des Sternlosen Himmels ¦ du Ciel sans étoiles ¦ 无星之天
of the Deep Well ¦ Глубокого Колодца ¦ des Tiefen Brunnens ¦ du Puits profond ¦ 深井
of the Pale Lantern ¦ Бледного Фонаря ¦ der Bleichen Laterne ¦ de la Lanterne pâle ¦ 苍灯
of the Coiled Serpent ¦ Свернувшегося Змея ¦ der Geringelten Schlange ¦ du Serpent lové ¦ 盘蛇
of the Final Page ¦ Последней Страницы ¦ der Letzten Seite ¦ de la Dernière Page ¦ 终页
of Salt and Silence ¦ Соли и Безмолвия ¦ von Salz und Stille ¦ du Sel et du Silence ¦ 盐与寂静
''',
  'faction_goal': '''
open the door beneath the harbor ¦ открыть дверь под гаванью ¦ die Tür unter dem Hafen öffnen ¦ ouvrir la porte sous le port ¦ 打开港口下的那扇门
keep the old texts out of human hands ¦ не допустить, чтобы древние тексты попали в руки людей ¦ die alten Texte aus Menschenhand fernhalten ¦ tenir les vieux textes hors de portée des hommes ¦ 不让古老文本落入人类之手
raise a new generation for the ones below ¦ вырастить новое поколение для тех, кто внизу ¦ eine neue Generation für jene dort unten heranziehen ¦ élever une nouvelle génération pour ceux d'en bas ¦ 为地底之物培育新的一代
map the dreams of every sleeper in the county ¦ нанести на карту сны каждого спящего в округе ¦ die Träume aller Schläfer der Grafschaft kartieren ¦ cartographier les rêves de chaque dormeur du comté ¦ 绘制全郡每个沉睡者的梦境
bury the truth about the 1846 expedition ¦ похоронить правду об экспедиции 1846 года ¦ die Wahrheit über die Expedition von 1846 begraben ¦ enterrer la vérité sur l'expédition de 1846 ¦ 埋葬关于1846年探险的真相
make the town prosperous, whatever it costs ¦ сделать город процветающим любой ценой ¦ die Stadt wohlhabend machen, koste es, was es wolle ¦ rendre la ville prospère, quel qu'en soit le prix ¦ 不计代价让小镇繁荣
contact the voice in the static ¦ связаться с голосом в радиопомехах ¦ Kontakt mit der Stimme im Rauschen aufnehmen ¦ contacter la voix dans les parasites ¦ 联络静电噪音中的那个声音
recover every fragment of the green stone ¦ собрать все осколки зелёного камня ¦ jedes Fragment des grünen Steins zurückholen ¦ récupérer chaque fragment de la pierre verte ¦ 寻回绿石的每一块碎片
''',
  'faction_method': '''
charity suppers where the soup is never finished ¦ благотворительные ужины, где суп никогда не доедают ¦ Wohltätigkeitsessen, bei denen die Suppe nie aufgegessen wird ¦ des dîners de charité où la soupe n'est jamais finie ¦ 汤永远喝不完的慈善晚宴
donations to the university library ¦ пожертвования университетской библиотеке ¦ Spenden an die Universitätsbibliothek ¦ des dons à la bibliothèque universitaire ¦ 向大学图书馆捐赠
marriages into every old family ¦ браки со всеми старыми семьями ¦ Heiraten in jede alte Familie ¦ des mariages avec chaque vieille famille ¦ 与每个老家族联姻
anonymous letters and patient blackmail ¦ анонимные письма и терпеливый шантаж ¦ anonyme Briefe und geduldige Erpressung ¦ lettres anonymes et chantage patient ¦ 匿名信与耐心的勒索
hypnosis disguised as medicine ¦ гипноз под видом лечения ¦ Hypnose, getarnt als Medizin ¦ l'hypnose déguisée en médecine ¦ 伪装成医疗的催眠
radio broadcasts late at night ¦ поздние ночные радиопередачи ¦ Radiosendungen spät in der Nacht ¦ des émissions de radio tard dans la nuit ¦ 深夜的电台广播
buying up the coastline lot by lot ¦ скупка побережья, участок за участком ¦ der Aufkauf der Küste, Parzelle für Parzelle ¦ le rachat du littoral, parcelle après parcelle ¦ 一块一块地收购海岸线
ceremonies at the standing stones ¦ обряды у менгиров ¦ Zeremonien an den Menhiren ¦ des cérémonies aux menhirs ¦ 在立石旁举行仪式
''',
  'faction_symbol': '''
an eye with a spiral pupil ¦ глаз со спиральным зрачком ¦ ein Auge mit spiralförmiger Pupille ¦ un œil à la pupille en spirale ¦ 瞳孔呈螺旋状的眼睛
a lamp with a green flame ¦ лампа с зелёным пламенем ¦ eine Lampe mit grüner Flamme ¦ une lampe à la flamme verte ¦ 燃着绿焰的灯
a fish with a human hand ¦ рыба с человеческой рукой ¦ ein Fisch mit einer Menschenhand ¦ un poisson à main humaine ¦ 长着人手的鱼
seven dots around a closed door ¦ семь точек вокруг закрытой двери ¦ sieben Punkte um eine geschlossene Tür ¦ sept points autour d'une porte close ¦ 围绕紧闭之门的七个点
a star with one arm too many ¦ звезда с лишним лучом ¦ ein Stern mit einem Arm zu viel ¦ une étoile à une branche de trop ¦ 多了一个角的星
an anchor wrapped in seaweed ¦ якорь, обвитый водорослями ¦ ein von Tang umwickelter Anker ¦ une ancre enlacée d'algues ¦ 缠着海藻的锚
a book held shut by a chain ¦ книга, стянутая цепью ¦ ein mit einer Kette verschlossenes Buch ¦ un livre fermé par une chaîne ¦ 被锁链捆住的书
a wave shaped like a crown ¦ волна в форме короны ¦ eine Welle in Form einer Krone ¦ une vague en forme de couronne ¦ 形如王冠的浪
''',
  'weather_sky': '''
a low, greenish overcast hangs over the bay ¦ низкая зеленоватая облачность нависла над заливом ¦ eine tiefe, grünliche Wolkendecke hängt über der Bucht ¦ un plafond bas et verdâtre pèse sur la baie ¦ 低垂发绿的阴云笼罩着海湾
sea fog rolls in and swallows the streetlights ¦ морской туман наползает и глотает фонари ¦ Seenebel zieht herein und verschluckt die Straßenlaternen ¦ le brouillard marin avance et avale les réverbères ¦ 海雾涌来，吞没了路灯
a storm builds far out at sea but never comes closer ¦ далеко в море собирается буря, но не приближается ¦ weit draußen auf See baut sich ein Sturm auf, ohne näher zu kommen ¦ une tempête se forme au large sans jamais approcher ¦ 远海上风暴在酝酿，却始终不靠近
stars in patterns no almanac describes ¦ звёзды в узорах, которых нет ни в одном альманахе ¦ Sterne in Mustern, die kein Almanach beschreibt ¦ des étoiles en motifs qu'aucun almanach ne décrit ¦ 星星排成历书上从未记载的图案
a thin cold rain that never quite stops ¦ мелкий холодный дождь, который всё никак не кончится ¦ ein dünner, kalter Regen, der nie ganz aufhört ¦ une pluie fine et froide qui ne cesse jamais tout à fait ¦ 细冷的雨总也停不下来
a flat grey sky with no visible sun ¦ плоское серое небо без видимого солнца ¦ ein flacher grauer Himmel ohne sichtbare Sonne ¦ un ciel gris et plat, sans soleil visible ¦ 平板灰暗、看不见太阳的天空
heat lightning flickers without thunder ¦ зарницы мерцают без грома ¦ Wetterleuchten flackert ohne Donner ¦ des éclairs de chaleur vacillent sans tonnerre ¦ 热闪不断，却没有雷声
an aurora, impossibly far south ¦ полярное сияние — невозможно далеко на юге ¦ ein Polarlicht, unmöglich weit im Süden ¦ une aurore, impossiblement loin au sud ¦ 极光出现在不可能的南方
''',
  'weather_air': '''
the air smells of low tide and old pennies ¦ воздух пахнет отливом и старыми монетками ¦ die Luft riecht nach Ebbe und alten Pennys ¦ l'air sent la marée basse et les vieux sous ¦ 空气中有退潮和旧硬币的味道
a clammy chill clings to every coat ¦ липкий холод цепляется к каждому пальто ¦ eine klamme Kälte klebt an jedem Mantel ¦ un froid moite colle à chaque manteau ¦ 湿冷的寒气黏在每件大衣上
the wind hums a single low note ¦ ветер гудит на одной низкой ноте ¦ der Wind summt einen einzigen tiefen Ton ¦ le vent bourdonne sur une seule note grave ¦ 风哼着同一个低音
the fog muffles every footstep ¦ туман глушит каждый шаг ¦ der Nebel dämpft jeden Schritt ¦ le brouillard étouffe chaque pas ¦ 雾气吞掉了每一声脚步
it is warm in a way that fits no season ¦ тепло, как ни в одно время года ¦ es ist warm, passend zu keiner Jahreszeit ¦ il fait doux, sans saison particulière ¦ 暖得不合任何季节
the humidity makes old paper curl ¦ от сырости старая бумага сворачивается ¦ die Feuchtigkeit lässt altes Papier sich wellen ¦ l'humidité fait gondoler le vieux papier ¦ 潮气让旧纸卷了边
the air is so still the sea looks painted ¦ воздух так неподвижен, что море кажется нарисованным ¦ die Luft ist so still, dass das Meer gemalt wirkt ¦ l'air est si immobile que la mer semble peinte ¦ 空气静得让大海像是画上去的
a smell of ozone and fish drifts inland ¦ запах озона и рыбы тянется вглубь суши ¦ ein Geruch nach Ozon und Fisch zieht landeinwärts ¦ une odeur d'ozone et de poisson gagne l'intérieur des terres ¦ 臭氧与鱼腥味向内陆飘去
''',
  'weather_omen': '''
every dog faces the sea and whines ¦ все собаки поворачиваются к морю и скулят ¦ alle Hunde wenden sich dem Meer zu und winseln ¦ tous les chiens se tournent vers la mer et gémissent ¦ 所有的狗都面朝大海呜咽
the church organ plays a note by itself ¦ церковный орган сам по себе берёт ноту ¦ die Kirchenorgel spielt von selbst einen Ton ¦ l'orgue de l'église joue une note tout seul ¦ 教堂管风琴自己发出了一个音
every clock in town stops at 3:33 ¦ все часы в городе останавливаются в 3:33 ¦ alle Uhren der Stadt bleiben um 3:33 stehen ¦ toutes les horloges de la ville s'arrêtent à 3 h 33 ¦ 镇上所有的钟都停在3点33分
dead fish wash ashore in a perfect line ¦ мёртвую рыбу выбрасывает на берег ровной линией ¦ tote Fische werden in einer perfekten Linie angespült ¦ des poissons morts s'échouent en une ligne parfaite ¦ 死鱼被冲上岸，排成一条完美的直线
radios pick up a voice counting backward ¦ радиоприёмники ловят голос, ведущий обратный отсчёт ¦ Radios empfangen eine Stimme, die rückwärts zählt ¦ les radios captent une voix qui compte à rebours ¦ 收音机里传来倒数的声音
the gulls fly inland in silence ¦ чайки молча улетают вглубь суши ¦ die Möwen fliegen schweigend landeinwärts ¦ les mouettes volent en silence vers l'intérieur des terres ¦ 海鸥无声地飞向内陆
someone has chalked a spiral on every door ¦ кто-то нарисовал мелом спираль на каждой двери ¦ jemand hat eine Spirale an jede Tür gekreidet ¦ quelqu'un a tracé une spirale à la craie sur chaque porte ¦ 有人在每扇门上都用粉笔画了螺旋
the lighthouse beam turns the wrong way ¦ луч маяка вращается в обратную сторону ¦ der Leuchtturmstrahl dreht sich falsch herum ¦ le faisceau du phare tourne dans le mauvais sens ¦ 灯塔光束朝反方向旋转
''',
  'rumor_source': '''
a fisherman mending nets ¦ рыбак, чинящий сети ¦ ein Fischer, der Netze flickt ¦ un pêcheur qui ravaude ses filets ¦ 正在补网的渔夫
an unsigned letter to the editor ¦ неподписанное письмо в редакцию ¦ ein unsignierter Leserbrief ¦ un courrier des lecteurs non signé ¦ 一封未署名的读者来信
a nervous librarian ¦ нервная библиотекарша ¦ eine nervöse Bibliothekarin ¦ une bibliothécaire nerveuse ¦ 紧张兮兮的图书管理员
an asylum patient's ravings ¦ бред пациента лечебницы ¦ das Gefasel eines Anstaltspatienten ¦ les divagations d'un patient de l'asile ¦ 疯人院病人的胡言乱语
the bartender at the speakeasy ¦ бармен подпольного бара ¦ der Barkeeper in der Flüsterkneipe ¦ le barman du bar clandestin ¦ 地下酒吧的酒保
a telegram meant for someone else ¦ телеграмма, предназначенная другому ¦ ein Telegramm, das für jemand anderen bestimmt war ¦ un télégramme destiné à quelqu'un d'autre ¦ 一封本该发给别人的电报
a traveling salesman ¦ коммивояжёр ¦ ein Handlungsreisender ¦ un voyageur de commerce ¦ 旅行推销员
notes in the margins of a secondhand book ¦ пометки на полях подержанной книги ¦ Randnotizen in einem gebrauchten Buch ¦ des notes dans les marges d'un livre d'occasion ¦ 二手书页边的批注
''',
  'rumor_text': '''
the Hollister family has not aged in thirty years ¦ семья Холлистер не постарела за тридцать лет ¦ die Familie Hollister ist seit dreißig Jahren nicht gealtert ¦ la famille Hollister n'a pas vieilli depuis trente ans ¦ 霍利斯特一家三十年来都没有变老
the new cannery pays its workers in gold ¦ новый консервный завод платит рабочим золотом ¦ die neue Konservenfabrik zahlt ihre Arbeiter in Gold ¦ la nouvelle conserverie paie ses ouvriers en or ¦ 新开的罐头厂用金子付工钱
a professor burned half the library catalogue ¦ профессор сжёг половину библиотечного каталога ¦ ein Professor hat den halben Bibliothekskatalog verbrannt ¦ un professeur a brûlé la moitié du catalogue de la bibliothèque ¦ 一位教授烧掉了图书馆一半的目录
there is a town at the bottom of the reservoir, and its lights still come on ¦ на дне водохранилища есть город, и его огни всё ещё загораются ¦ auf dem Grund des Stausees liegt eine Stadt, deren Lichter noch angehen ¦ il y a une ville au fond du réservoir, et ses lumières s'allument encore ¦ 水库底下有座小镇，灯至今还会亮起
the drowned sailor came to his own funeral ¦ утонувший моряк пришёл на собственные похороны ¦ der ertrunkene Seemann kam zu seiner eigenen Beerdigung ¦ le marin noyé est venu à ses propres funérailles ¦ 溺死的水手出席了自己的葬礼
the meteorite is growing ¦ метеорит растёт ¦ der Meteorit wächst ¦ la météorite grandit ¦ 那块陨石在长大
children sing a rhyme nobody taught them ¦ дети поют стишок, которому их никто не учил ¦ Kinder singen einen Reim, den ihnen niemand beigebracht hat ¦ des enfants chantent une comptine que personne ne leur a apprise ¦ 孩子们在唱一首没人教过的童谣
the federal men took something out of the marsh ¦ федералы вывезли что-то с болота ¦ die Bundesleute haben etwas aus dem Sumpf geholt ¦ les fédéraux ont sorti quelque chose du marais ¦ 联邦探员从沼泽里运走了什么东西
the lighthouse keeper died a month ago and the light still turns ¦ смотритель маяка умер месяц назад, а свет всё ещё вращается ¦ der Leuchtturmwärter ist seit einem Monat tot, und das Licht dreht sich noch ¦ le gardien du phare est mort depuis un mois et la lumière tourne toujours ¦ 灯塔看守人已经死了一个月，灯却还在转
the church bought every copy of the town history ¦ церковь скупила все экземпляры истории города ¦ die Kirche hat jedes Exemplar der Stadtchronik aufgekauft ¦ l'église a acheté tous les exemplaires de l'histoire de la ville ¦ 教会买下了所有的镇志
''',
};

const _latinPre = '''
Dun
Salt
Crow
Ash
Mill
Gull
Ember
Pike
Wren
Stone
''';

const _latinSuf = '''
mouth
haven
port
bury
field
cove
marsh
ton
''';

const _perLang = <String, Map<String, String>>{
  'en': {'settle_pre': _latinPre, 'settle_suf': _latinSuf},
  'de': {'settle_pre': _latinPre, 'settle_suf': _latinSuf},
  'fr': {'settle_pre': _latinPre, 'settle_suf': _latinSuf},
  'ru': {
    'settle_pre': '''
Дан
Солт
Кроу
Эш
Милл
Галл
Эмбер
Пайк
Рен
Стоун
''',
    'settle_suf': '''
маут
хейвен
порт
бери
филд
коув
марш
тон
''',
  },
  'zh': {
    'settle_pre': '''
邓
索尔特
克罗
阿什
米尔
格尔
恩伯
派克
雷恩
斯通
''',
    'settle_suf': '''
茅斯
黑文
波特
伯里
菲尔德
科夫
马什
顿
''',
  },
};
