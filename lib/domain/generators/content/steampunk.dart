import '../content_format.dart';

/// Brass, smog, airships and the Royal Society.
final steampunkContent =
    PackContent.build(rows: _rows, names: _names, perLang: _perLang);

const _names = <String, String>{
  'gentry_given_f': '''
Arabella ¦ Арабелла ¦ 阿拉贝拉
Cordelia ¦ Корделия ¦ 科迪莉亚
Henrietta ¦ Генриетта ¦ 亨丽埃塔
Octavia ¦ Октавия ¦ 奥克塔维娅
Philippa ¦ Филиппа ¦ 菲莉帕
Clementine ¦ Клементина ¦ 克莱门汀
Georgiana ¦ Джорджиана ¦ 乔治亚娜
Imogen ¦ Имоджен ¦ 伊莫金
Letitia ¦ Летиция ¦ 莱蒂西娅
Violet ¦ Вайолет ¦ 维奥莱特
Beatrice ¦ Беатрис ¦ 比阿特丽斯
Florence ¦ Флоренс ¦ 弗洛伦丝
''',
  'gentry_given_m': '''
Cornelius ¦ Корнелиус ¦ 科尼利厄斯
Algernon ¦ Элджернон ¦ 阿尔杰农
Bartholomew ¦ Бартоломью ¦ 巴塞洛缪
Montague ¦ Монтегю ¦ 蒙塔古
Reginald ¦ Реджинальд ¦ 雷金纳德
Ambrose ¦ Эмброуз ¦ 安布罗斯
Fitzwilliam ¦ Фицуильям ¦ 菲茨威廉
Humphrey ¦ Хамфри ¦ 汉弗莱
Lucius ¦ Луций ¦ 卢修斯
Edmund ¦ Эдмунд ¦ 埃德蒙
Jasper ¦ Джаспер ¦ 贾斯珀
Barnaby ¦ Барнаби ¦ 巴纳比
''',
  'gentry_family': '''
Brassington ¦ Брассингтон ¦ 布拉辛顿
Fairweather-Pike ¦ Фэйрвезер-Пайк ¦ 费尔韦瑟-派克
Thistlewood ¦ Тисльвуд ¦ 西斯尔伍德
Hargreave ¦ Харгрив ¦ 哈格里夫
Quillfeather ¦ Квиллфезер ¦ 奎尔费瑟
Pemberton-Vane ¦ Пембертон-Вейн ¦ 彭伯顿-韦恩
Gearhart ¦ Гирхарт ¦ 吉尔哈特
Whitcombe ¦ Уиткомб ¦ 惠特科姆
Blackstone ¦ Блэкстоун ¦ 布莱克斯通
Kettleby ¦ Кеттлби ¦ 凯特尔比
Harrowgate ¦ Харроугейт ¦ 哈罗盖特
Wrightson ¦ Райтсон ¦ 赖特森
''',
  'guild_given_f': '''
Greta ¦ Грета ¦ 格蕾塔
Ottilie ¦ Оттилия ¦ 奥蒂莉
Mathilde ¦ Матильда ¦ 玛蒂尔德
Irma ¦ Ирма ¦ 伊尔玛
Frieda ¦ Фрида ¦ 弗里达
Lotte ¦ Лотте ¦ 洛特
Brigitte ¦ Бригитта ¦ 布丽吉特
Hedda ¦ Хедда ¦ 海达
Sabine ¦ Сабина ¦ 萨比娜
Elke ¦ Эльке ¦ 埃尔克
Ida ¦ Ида ¦ 伊达
Renate ¦ Рената ¦ 蕾娜特
''',
  'guild_given_m': '''
Kaspar ¦ Каспар ¦ 卡斯帕
Ignaz ¦ Игнац ¦ 伊格纳茨
Fritz ¦ Фриц ¦ 弗里茨
Otto ¦ Отто ¦ 奥托
Rudi ¦ Руди ¦ 鲁迪
Heinrich ¦ Генрих ¦ 海因里希
Lorenz ¦ Лоренц ¦ 洛伦茨
Gustav ¦ Густав ¦ 古斯塔夫
Ernst ¦ Эрнст ¦ 恩斯特
Karl ¦ Карл ¦ 卡尔
Viktor ¦ Виктор ¦ 维克多
Bruno ¦ Бруно ¦ 布鲁诺
''',
  'guild_family': '''
Radmacher ¦ Радмахер ¦ 拉德马赫
Schmiedel ¦ Шмидель ¦ 施米德尔
Uhrmann ¦ Урман ¦ 乌尔曼
Kupferberg ¦ Купферберг ¦ 库普弗贝格
Hammerstein ¦ Хаммерштейн ¦ 哈默施泰因
Feinhals ¦ Файнхальс ¦ 费因哈尔斯
Nietmann ¦ Нитман ¦ 尼特曼
Kolbe ¦ Кольбе ¦ 科尔贝
Federlein ¦ Федерлейн ¦ 费德莱因
Brenner ¦ Бреннер ¦ 布伦纳
Zinnober ¦ Циннобер ¦ 齐诺贝尔
Achsler ¦ Акслер ¦ 阿克斯勒
''',
};

const _rows = <String, String>{
  'cultures': '''
@gentry Gentry ¦ Знать ¦ Vornehme ¦ Gentilshommes ¦ 上流社会
@guild Guild artisans ¦ Цеховые мастера ¦ Zunfthandwerker ¦ Artisans des guildes ¦ 行会工匠
''',
  'epithet': '''
Brass-Hand ¦ Латунная Рука ¦ Messinghand ¦ Main-de-Laiton ¦ 黄铜手
the Clockwork Heart ¦ Заводное Сердце ¦ das Uhrwerkherz ¦ Cœur-Mécanique ¦ 发条之心
Sootface ¦ Чумазый~Чумазая ¦ Rußgesicht ¦ Face-de-Suie ¦ 煤灰脸
the Inventor ¦ Изобретатель~Изобретательница ¦ der Erfinder~die Erfinderin ¦ l'Inventeur~l'Inventrice ¦ 发明家
Three-Goggles ¦ Тройные Очки ¦ Dreibrille ¦ Triple-Lunettes ¦ 三镜
the Steam Duke ¦ Паровой Герцог~Паровая Герцогиня ¦ der Dampfherzog~die Dampfherzogin ¦ le Duc-Vapeur~la Duchesse-Vapeur ¦ 蒸汽公爵
Quicksilver ¦ Ртуть ¦ Quecksilber ¦ Vif-Argent ¦ 水银
the Airship Ghost ¦ Призрак Дирижабля ¦ das Luftschiffgespenst ¦ le Fantôme du Dirigeable ¦ 飞艇幽灵
Boiler-Proof ¦ Несгораемый~Несгораемая ¦ Kesselfest ¦ Pare-Chaudière ¦ 锅炉不坏
the Spider of the Exchange ¦ Паук Биржи ¦ die Spinne der Börse ¦ l'Araignée de la Bourse ¦ 交易所的蜘蛛
''',
  'ancestry': '''
@gentry old-money gentry ¦ из старой аристократии ¦ aus altem Geldadel ¦ de vieille fortune ¦ 老钱贵族
@guild guild-born artisan ¦ потомственный мастер~потомственная мастерица ¦ Zunftkind ¦ artisan de naissance ¦ 行会世家出身
@guild factory-district child ¦ дитя фабричного квартала ¦ Kind des Fabrikviertels ¦ enfant des quartiers d'usines ¦ 工厂区的孩子
@gentry returned from the colonies ¦ вернувшийся из колоний~вернувшаяся из колоний ¦ Heimkehrer aus den Kolonien~Heimkehrerin aus den Kolonien ¦ revenu des colonies~revenue des colonies ¦ 从殖民地归来的人
partly mechanical ¦ частично механический~частично механическая ¦ teilweise mechanisch ¦ en partie mécanique ¦ 半机械人
sky-born aeronaut ¦ рождённый в небе воздухоплаватель~рождённая в небе воздухоплавательница ¦ im Himmel geborener Luftfahrer~im Himmel geborene Luftfahrerin ¦ aéronaute né dans le ciel~aéronaute née dans le ciel ¦ 天空出生的飞艇人
''',
  'role': '''
airship mechanic ¦ механик дирижабля ¦ Luftschiffmechaniker~Luftschiffmechanikerin ¦ mécanicien de dirigeable~mécanicienne de dirigeable ¦ 飞艇机械师
clockmaker ¦ часовщик~часовщица ¦ Uhrmacher~Uhrmacherin ¦ horloger~horlogère ¦ 钟表匠
chimney sweep ¦ трубочист~трубочистка ¦ Schornsteinfeger~Schornsteinfegerin ¦ ramoneur~ramoneuse ¦ 扫烟囱工
inventor ¦ изобретатель~изобретательница ¦ Erfinder~Erfinderin ¦ inventeur~inventrice ¦ 发明家
factory foreman ¦ фабричный мастер ¦ Fabrikvorarbeiter~Fabrikvorarbeiterin ¦ contremaître d'usine~contremaîtresse d'usine ¦ 工厂领班
society columnist ¦ светский хроникёр ¦ Gesellschaftskolumnist~Gesellschaftskolumnistin ¦ chroniqueur mondain~chroniqueuse mondaine ¦ 社交专栏作家
pneumatic-post clerk ¦ служащий пневмопочты~служащая пневмопочты ¦ Rohrpostangestellter~Rohrpostangestellte ¦ employé de la poste pneumatique~employée de la poste pneumatique ¦ 气动邮政职员
sky pirate ¦ небесный пират~небесная пиратка ¦ Himmelspirat~Himmelspiratin ¦ pirate du ciel ¦ 天空海盗
automaton repairer ¦ ремонтник автоматонов ¦ Automatenmechaniker~Automatenmechanikerin ¦ réparateur d'automates~réparatrice d'automates ¦ 自动人偶修理工
union organizer ¦ профсоюзный агитатор ¦ Gewerkschaftsorganisator~Gewerkschaftsorganisatorin ¦ organisateur syndical~organisatrice syndicale ¦ 工会组织者
Royal Society scientist ¦ учёный Королевского общества ¦ Wissenschaftler der Königlichen Gesellschaft~Wissenschaftlerin der Königlichen Gesellschaft ¦ savant de la Société royale~savante de la Société royale ¦ 皇家学会科学家
music-hall performer ¦ артист мюзик-холла~артистка мюзик-холла ¦ Varietékünstler~Varietékünstlerin ¦ artiste de music-hall ¦ 游艺场演员
''',
  'appearance': '''
brass goggles with too many lenses ¦ латунные очки со слишком большим числом линз ¦ eine Messingbrille mit zu vielen Linsen ¦ des lunettes de laiton aux lentilles trop nombreuses ¦ 镜片多得过头的黄铜护目镜
a waistcoat full of tiny tools ¦ жилет, полный крошечных инструментов ¦ eine Weste voller winziger Werkzeuge ¦ un gilet rempli de minuscules outils ¦ 插满小工具的马甲
a clockwork hand that ticks audibly ¦ заводная рука, слышно тикающая ¦ eine Uhrwerkhand, die hörbar tickt ¦ une main mécanique au tic-tac audible ¦ 滴答作响的发条手
soot ground into every wrinkle ¦ сажа, въевшаяся в каждую морщинку ¦ Ruß in jeder Falte ¦ de la suie incrustée dans chaque ride ¦ 每道皱纹里都嵌着煤灰
a top hat with a pressure gauge ¦ цилиндр с манометром ¦ ein Zylinder mit Manometer ¦ un haut-de-forme muni d'un manomètre ¦ 装着压力表的高礼帽
burn scars from a boiler explosion ¦ ожоги от взрыва котла ¦ Brandnarben von einer Kesselexplosion ¦ des brûlures dues à l'explosion d'une chaudière ¦ 锅炉爆炸留下的烧伤疤痕
''',
  'motivation': '''
patent an invention before a rival steals it ¦ запатентовать изобретение, пока его не украл соперник ¦ eine Erfindung patentieren, bevor ein Rivale sie stiehlt ¦ breveter une invention avant qu'un rival ne la vole ¦ 赶在对手窃取前为发明申请专利
win a seat in the Royal Society ¦ получить место в Королевском обществе ¦ einen Sitz in der Königlichen Gesellschaft erringen ¦ obtenir un siège à la Société royale ¦ 在皇家学会谋得一席
free the workers of the Blackmoor mill ¦ освободить рабочих фабрики Блэкмур ¦ die Arbeiter der Blackmoor-Fabrik befreien ¦ libérer les ouvriers de la filature Blackmoor ¦ 解放布莱克莫尔工厂的工人
buy an airship and never touch the ground again ¦ купить дирижабль и больше никогда не спускаться на землю ¦ ein Luftschiff kaufen und nie wieder Boden berühren ¦ acheter un dirigeable et ne plus jamais toucher terre ¦ 买一艘飞艇，再也不踏上地面
restore the family's lost fortune ¦ вернуть утраченное семейное состояние ¦ das verlorene Familienvermögen zurückgewinnen ¦ rétablir la fortune perdue de la famille ¦ 恢复家族失去的财富
build a machine that can think ¦ построить машину, способную думать ¦ eine Maschine bauen, die denken kann ¦ construire une machine capable de penser ¦ 造出一台会思考的机器
''',
  'secret': '''
powers a prosthetic with a stolen core ¦ питает протез украденным ядром ¦ betreibt eine Prothese mit einem gestohlenen Kern ¦ alimente une prothèse avec un cœur volé ¦ 用偷来的核心驱动义肢
sabotaged the boiler that exploded last year ¦ испортил котёл, взорвавшийся в прошлом году~испортила котёл, взорвавшийся в прошлом году ¦ hat den Kessel sabotiert, der letztes Jahr explodierte ¦ a saboté la chaudière qui a explosé l'an dernier ¦ 去年爆炸的锅炉是被其蓄意破坏的
is secretly an automaton ¦ на самом деле — автоматон ¦ ist insgeheim ein Automat ¦ est secrètement un automate ¦ 其实是一具自动人偶
funds the anarchists ¦ финансирует анархистов ¦ finanziert die Anarchisten ¦ finance les anarchistes ¦ 暗中资助无政府主义者
forged the patent that made the family rich ¦ подделал патент, обогативший семью~подделала патент, обогативший семью ¦ hat das Patent gefälscht, das die Familie reich machte ¦ a falsifié le brevet qui a enrichi la famille ¦ 伪造了让家族致富的专利
owes a debt to the sky pirates ¦ в долгу перед небесными пиратами ¦ steht bei den Himmelspiraten in der Kreide ¦ a une dette envers les pirates du ciel ¦ 欠着天空海盗一笔债
''',
  'settle_size': '''
@Village a mill village of {#2d6*20} workers ¦ фабричный посёлок на {#2d6*20} рабочих ¦ ein Mühlendorf mit {#2d6*20} Arbeitern ¦ un village d'usine de {#2d6*20} ouvriers ¦ 有{#2d6*20}名工人的磨坊村
@Town a canal town of about {#3d6*300} people ¦ городок на канале, около {#3d6*300} жителей ¦ eine Kanalstadt mit etwa {#3d6*300} Einwohnern ¦ une ville de canal d'environ {#3d6*300} habitants ¦ 约{#3d6*300}人的运河镇
@City an industrial city of {#2d10*20000} souls ¦ промышленный город, {#2d10*20000} душ ¦ eine Industriestadt mit {#2d10*20000} Seelen ¦ une ville industrielle de {#2d10*20000} âmes ¦ {#2d10*20000}人口的工业城市
@Landmark a floating sky-dock of {#2d6*50} residents ¦ парящий небесный док на {#2d6*50} жителей ¦ ein schwebendes Himmelsdock mit {#2d6*50} Bewohnern ¦ un quai céleste flottant de {#2d6*50} résidents ¦ 住着{#2d6*50}人的浮空船坞
''',
  'settle_feature': '''
a clock tower that drives every machine in town ¦ часовая башня, приводящая в движение все машины города ¦ ein Uhrturm, der jede Maschine der Stadt antreibt ¦ une tour d'horloge qui fait tourner toutes les machines de la ville ¦ 驱动全城机器的钟楼
an airship mooring mast above the cathedral ¦ причальная мачта дирижаблей над собором ¦ ein Luftschiff-Ankermast über der Kathedrale ¦ un mât d'amarrage pour dirigeables au-dessus de la cathédrale ¦ 大教堂上方的飞艇系留塔
pneumatic tubes that carry letters between houses ¦ пневмотрубы, доставляющие письма между домами ¦ Rohrpostleitungen, die Briefe zwischen Häusern befördern ¦ des tubes pneumatiques qui portent le courrier de maison en maison ¦ 在各家之间传送信件的气动管道
a river that steams even in winter ¦ река, которая парит даже зимой ¦ ein Fluss, der selbst im Winter dampft ¦ une rivière qui fume même en hiver ¦ 冬天也冒着蒸汽的河
a great exhibition hall of glass and iron ¦ огромный выставочный зал из стекла и железа ¦ eine große Ausstellungshalle aus Glas und Eisen ¦ un grand palais d'exposition de verre et de fer ¦ 玻璃与钢铁建成的大展览馆
a mechanical elephant that carries passengers ¦ механический слон, возящий пассажиров ¦ ein mechanischer Elefant, der Passagiere trägt ¦ un éléphant mécanique qui transporte des passagers ¦ 载客的机械大象
a canal lock the size of a cathedral ¦ шлюз размером с собор ¦ eine Kanalschleuse, groß wie eine Kathedrale ¦ une écluse grande comme une cathédrale ¦ 大如教堂的运河船闸
so many chimneys they hide the sun ¦ столько труб, что они заслоняют солнце ¦ so viele Schornsteine, dass sie die Sonne verdecken ¦ tant de cheminées qu'elles cachent le soleil ¦ 多得遮住了太阳的烟囱
a museum of failed inventions ¦ музей неудачных изобретений ¦ ein Museum gescheiterter Erfindungen ¦ un musée des inventions ratées ¦ 失败发明博物馆
an automaton orchestra in the park ¦ оркестр автоматонов в парке ¦ ein Automatenorchester im Park ¦ un orchestre d'automates dans le parc ¦ 公园里的自动人偶乐团
''',
  'settle_trouble': '''
the mill workers are on strike ¦ фабричные рабочие бастуют ¦ die Fabrikarbeiter streiken ¦ les ouvriers de la filature sont en grève ¦ 工厂工人正在罢工
a boiler explosion has closed the main bridge ¦ взрыв котла закрыл главный мост ¦ eine Kesselexplosion hat die Hauptbrücke gesperrt ¦ l'explosion d'une chaudière a fermé le pont principal ¦ 一场锅炉爆炸让主桥封闭了
automatons are wandering away from their posts ¦ автоматоны покидают свои посты ¦ Automaten verlassen ihre Posten ¦ des automates quittent leur poste ¦ 自动人偶纷纷擅离职守
the smog has turned deadly ¦ смог стал смертельным ¦ der Smog ist tödlich geworden ¦ le smog est devenu mortel ¦ 烟雾变得致命
sky pirates are raiding the cargo docks ¦ небесные пираты грабят грузовые доки ¦ Himmelspiraten überfallen die Frachtdocks ¦ des pirates du ciel pillent les docks ¦ 天空海盗袭击了货运码头
an inventor has vanished with the city's blueprints ¦ изобретатель исчез с чертежами города ¦ ein Erfinder ist mit den Bauplänen der Stadt verschwunden ¦ un inventeur a disparu avec les plans de la ville ¦ 一位发明家带着城市的蓝图失踪了
the clock tower has started running backward ¦ часовая башня пошла назад ¦ der Uhrturm läuft plötzlich rückwärts ¦ la tour d'horloge s'est mise à tourner à l'envers ¦ 钟楼开始倒着走了
a coal shortage threatens a freezing winter ¦ нехватка угля грозит ледяной зимой ¦ ein Kohlemangel droht mit einem eisigen Winter ¦ une pénurie de charbon annonce un hiver glacial ¦ 煤炭短缺预示着严寒的冬天
a child-labor scandal has erupted at the match factory ¦ на спичечной фабрике разразился скандал с детским трудом ¦ in der Streichholzfabrik ist ein Kinderarbeitsskandal ausgebrochen ¦ un scandale de travail des enfants éclate à la fabrique d'allumettes ¦ 火柴厂爆出了童工丑闻
a dye works has poisoned the canal ¦ красильня отравила канал ¦ eine Färberei hat den Kanal vergiftet ¦ une teinturerie a empoisonné le canal ¦ 一家染坊污染了运河
''',
  'settle_authority': '''
a lord mayor in the pocket of the mill owners ¦ лорд-мэр, купленный владельцами фабрик ¦ ein Oberbürgermeister in der Tasche der Fabrikbesitzer ¦ un lord-maire à la solde des patrons d'usine ¦ 被工厂主收买的市长大人
the Guild of Engineers ¦ Гильдия инженеров ¦ die Ingenieursgilde ¦ la Guilde des ingénieurs ¦ 工程师行会
a board of shareholders who never visit ¦ совет акционеров, который никогда не приезжает ¦ ein Aktionärsrat, der nie zu Besuch kommt ¦ un conseil d'actionnaires qui ne vient jamais ¦ 从不露面的股东董事会
a calculating engine that sets the laws ¦ вычислительная машина, устанавливающая законы ¦ eine Rechenmaschine, die die Gesetze festlegt ¦ une machine à calculer qui fixe les lois ¦ 制定法律的计算机器
the Duchess, ruling from her airship ¦ герцогиня, правящая со своего дирижабля ¦ die Herzogin, die von ihrem Luftschiff aus regiert ¦ la duchesse, qui gouverne depuis son dirigeable ¦ 在飞艇上发号施令的公爵夫人
a police commissioner with clockwork constables ¦ комиссар полиции с заводными констеблями ¦ ein Polizeipräsident mit Uhrwerk-Konstablern ¦ un commissaire de police aux agents mécaniques ¦ 手下是发条警员的警察局长
a newly elected workers' council ¦ недавно избранный рабочий совет ¦ der kürzlich gewählte Arbeiterrat ¦ un conseil ouvrier élu depuis peu ¦ 刚刚选出的工人委员会
an old inventor who owns every patent ¦ старый изобретатель, которому принадлежат все патенты ¦ ein alter Erfinder, dem jedes Patent gehört ¦ un vieil inventeur qui détient tous les brevets ¦ 握有所有专利的老发明家
''',
  'est_type': '''
gin palace ¦ джин-паб ¦ Ginpalast ¦ palais du gin ¦ 杜松子酒馆
tea room ¦ чайная ¦ Teestube ¦ salon de thé ¦ 茶室
gearsmith's workshop ¦ мастерская механика ¦ Zahnradschmiede ¦ atelier d'engrenages ¦ 齿轮工坊
airship chandlery ¦ лавка снаряжения для дирижаблей ¦ Luftschiffausrüster ¦ fournitures pour dirigeables ¦ 飞艇用品店
gentlemen's club ¦ джентльменский клуб ¦ Herrenklub ¦ club de gentlemen ¦ 绅士俱乐部
pawnbroker ¦ ломбард ¦ Pfandhaus ¦ mont-de-piété ¦ 当铺
''',
  'est_adj': '''
Brass ¦ латунный~латунная ¦ Blanken ¦ de laiton ¦ 黄铜
Steaming ¦ дымящийся~дымящаяся ¦ Dampfenden ¦ fumant~fumante ¦ 冒汽
Clockwork ¦ заводной~заводная ¦ Aufgezogenen ¦ à ressort ¦ 发条
Copper ¦ медный~медная ¦ Kupfernen ¦ cuivré~cuivrée ¦ 铜
Sooty ¦ закопчённый~закопчённая ¦ Rußigen ¦ noirci~noircie ¦ 煤烟
Flying ¦ летучий~летучая ¦ Fliegenden ¦ volant~volante ¦ 飞天
Riveted ¦ клёпаный~клёпаная ¦ Genieteten ¦ riveté~rivetée ¦ 铆钉
Gilded ¦ позолоченный~позолоченная ¦ Vergoldeten ¦ doré~dorée ¦ 镀金
Whistling ¦ свистящий~свистящая ¦ Pfeifenden ¦ sifflant~sifflante ¦ 鸣笛
Mechanical ¦ механический~механическая ¦ Mechanischen ¦ mécanique ¦ 机械
''',
  'est_noun': '''
Cog ¦ шестерня#f ¦ Zahnrad#m ¦ Rouage#m ¦ 齿轮
Kettle ¦ чайник#m ¦ Kessel#m ¦ Bouilloire#f ¦ 水壶
Owl ¦ сова#f ¦ Eule#f ¦ Hibou#m ¦ 猫头鹰
Piston ¦ поршень#m ¦ Kolben#m ¦ Piston#m ¦ 活塞
Balloon ¦ аэростат#m ¦ Ballon#m ¦ Montgolfière#f ¦ 气球
Gauge ¦ манометр#m ¦ Manometer#m ¦ Jauge#f ¦ 仪表
Duchess ¦ герцогиня#f ¦ Herzogin#f ¦ Duchesse#f ¦ 公爵夫人
Beetle ¦ жук#m ¦ Käfer#m ¦ Scarabée#m ¦ 甲虫
Lamp ¦ лампа#f ¦ Lampe#f ¦ Lampe#f ¦ 灯
Rivet ¦ заклёпка#f ¦ Niete#f ¦ Rivet#m ¦ 铆钉
Swan ¦ лебедь#m ¦ Schwan#m ¦ Cygne#m ¦ 天鹅
Dirigible ¦ дирижабль#m ¦ Zeppelin#m ¦ Dirigeable#m ¦ 飞艇
Locomotive ¦ паровоз#m ¦ Lokomotive#f ¦ Locomotive#f ¦ 机车
''',
  'est_specialty': '''
gin cut with something that fizzes ¦ джин, разбавленный чем-то шипучим ¦ Gin, gestreckt mit etwas Sprudelndem ¦ du gin coupé avec quelque chose qui pétille ¦ 掺了某种气泡物的杜松子酒
tea brewed by a steam-powered samovar ¦ чай из паровой машины-самовара ¦ Tee aus einem dampfbetriebenen Samowar ¦ du thé préparé par un samovar à vapeur ¦ 蒸汽茶炊泡的茶
repairs to anything with a spring ¦ ремонт всего, где есть пружина ¦ Reparaturen an allem, was eine Feder hat ¦ la réparation de tout ce qui a un ressort ¦ 修理一切带弹簧的东西
airship berths by the night ¦ причальные места для дирижаблей на ночь ¦ Luftschiffliegeplätze für eine Nacht ¦ des places d'amarrage pour dirigeables à la nuit ¦ 按夜出租的飞艇泊位
a reading room stocked with every scientific journal ¦ читальный зал со всеми научными журналами ¦ ein Lesesaal mit allen Fachzeitschriften ¦ une salle de lecture avec toutes les revues savantes ¦ 收藏所有科学期刊的阅览室
meat pies of questionable origin ¦ мясные пироги сомнительного происхождения ¦ Fleischpasteten zweifelhafter Herkunft ¦ des tourtes à la viande d'origine douteuse ¦ 来历可疑的肉馅饼
a betting book on the airship races ¦ тотализатор на гонки дирижаблей ¦ ein Wettbuch für die Luftschiffrennen ¦ un registre de paris sur les courses de dirigeables ¦ 飞艇竞速的赌盘
loans against patents ¦ ссуды под залог патентов ¦ Kredite gegen Patente ¦ des prêts gagés sur des brevets ¦ 以专利作抵押的贷款
a mechanical fortune-teller in the corner ¦ механическая гадалка в углу ¦ eine mechanische Wahrsagerin in der Ecke ¦ une diseuse de bonne aventure mécanique dans un coin ¦ 角落里的机械算命机
private rooms where deals are signed ¦ отдельные кабинеты для подписания сделок ¦ Separees, in denen Geschäfte besiegelt werden ¦ des salons privés où se signent les affaires ¦ 签署交易用的私人包间
''',
  'est_patron': '''
an heiress disguised as a mechanic ¦ наследница, переодетая механиком ¦ eine Erbin, als Mechanikerin verkleidet ¦ une héritière déguisée en mécanicienne ¦ 伪装成机械师的女继承人
a sky pirate on shore leave ¦ небесный пират в увольнительной ¦ ein Himmelspirat auf Landgang ¦ un pirate du ciel en permission ¦ 上岸休假的天空海盗
an automaton waiting for its owner ¦ автоматон, ждущий хозяина ¦ ein Automat, der auf seinen Besitzer wartet ¦ un automate qui attend son propriétaire ¦ 在等待主人的自动人偶
a union man counting signatures ¦ профсоюзный деятель, пересчитывающий подписи ¦ ein Gewerkschafter, der Unterschriften zählt ¦ un syndicaliste qui compte les signatures ¦ 清点签名的工会成员
a scientist with singed eyebrows ¦ учёный с опалёнными бровями ¦ ein Wissenschaftler mit versengten Augenbrauen ¦ un savant aux sourcils roussis ¦ 眉毛被烧焦的科学家
a police inspector in plain clothes ¦ полицейский инспектор в штатском ¦ ein Polizeiinspektor in Zivil ¦ un inspecteur de police en civil ¦ 便衣警探
a chimney sweep with expensive tastes ¦ трубочист с дорогими вкусами ¦ ein Schornsteinfeger mit teurem Geschmack ¦ un ramoneur aux goûts de luxe ¦ 品味奢侈的扫烟囱工
a foreign prince studying engines ¦ иностранный принц, изучающий двигатели ¦ ein ausländischer Prinz, der Motoren studiert ¦ un prince étranger qui étudie les moteurs ¦ 研究引擎的外国王子
''',
  'hook_title': '''
The Clockwork Heir ¦ Заводной наследник ¦ Der Uhrwerkerbe ¦ L'Héritier mécanique ¦ 发条继承人
Smoke over Blackmoor ¦ Дым над Блэкмуром ¦ Rauch über Blackmoor ¦ Fumée sur Blackmoor ¦ 布莱克莫尔上空的烟
The Great Exhibition Theft ¦ Кража на Великой выставке ¦ Der Diebstahl auf der Großen Ausstellung ¦ Le Vol de la Grande Exposition ¦ 大博览会窃案
A Patent for Murder ¦ Патент на убийство ¦ Ein Patent auf Mord ¦ Un brevet pour un meurtre ¦ 谋杀的专利
The Last Flight of the Albatross ¦ Последний полёт «Альбатроса» ¦ Der letzte Flug der Albatros ¦ Le Dernier Vol de l'Albatros ¦ “信天翁号”的最后航程
Pressure Rising ¦ Давление растёт ¦ Steigender Druck ¦ La Pression monte ¦ 压力攀升
The Automaton Who Wept ¦ Автоматон, который плакал ¦ Der Automat, der weinte ¦ L'Automate qui pleurait ¦ 流泪的自动人偶
Strike at Midnight ¦ Забастовка в полночь ¦ Streik um Mitternacht ¦ Grève à minuit ¦ 午夜罢工
Cogs of the Crown ¦ Шестерни Короны ¦ Die Zahnräder der Krone ¦ Les Rouages de la Couronne ¦ 王冠的齿轮
The Sky Is Falling, Slowly ¦ Небо падает — медленно ¦ Der Himmel fällt, langsam ¦ Le ciel tombe, lentement ¦ 天空正在缓缓坠落
''',
  'hook_who': '''
an inventor whose prototype was stolen ¦ изобретательница, у которой украли прототип ¦ eine Erfinderin, deren Prototyp gestohlen wurde ¦ une inventrice dont on a volé le prototype ¦ 原型机被盗的发明家
a mill girl organizing a strike ¦ фабричная работница, организующая забастовку ¦ eine Fabrikarbeiterin, die einen Streik organisiert ¦ une ouvrière qui organise une grève ¦ 组织罢工的纺织女工
a duke with a failing mechanical heart ¦ герцог с отказывающим механическим сердцем ¦ ein Herzog mit versagendem mechanischem Herzen ¦ un duc au cœur mécanique défaillant ¦ 机械心脏快要失灵的公爵
an airship captain with a mutinous crew ¦ капитанша дирижабля с бунтующей командой ¦ eine Luftschiffkapitänin mit meuternder Mannschaft ¦ une capitaine de dirigeable à l'équipage mutin ¦ 船员哗变的飞艇船长
an automaton seeking its maker ¦ автоматон, ищущий своего создателя ¦ ein Automat auf der Suche nach seinem Schöpfer ¦ un automate qui cherche son créateur ¦ 寻找造物主的自动人偶
a police inspector who trusts no one ¦ полицейский инспектор, никому не доверяющий ¦ ein Polizeiinspektor, der niemandem traut ¦ un inspecteur de police qui ne se fie à personne ¦ 谁都不信任的警探
a society widow with a locked laboratory ¦ светская вдова с запертой лабораторией ¦ eine Witwe der feinen Gesellschaft mit einem verschlossenen Labor ¦ une veuve mondaine au laboratoire verrouillé ¦ 拥有一间上锁实验室的上流社会寡妇
a chimney sweep who saw something on the rooftops ¦ трубочист, видевший что-то на крышах ¦ ein Schornsteinfeger, der auf den Dächern etwas gesehen hat ¦ un ramoneur qui a vu quelque chose sur les toits ¦ 在屋顶上看见了什么的扫烟囱工
the Royal Society's youngest fellow ¦ самый молодой член Королевского общества ¦ das jüngste Mitglied der Königlichen Gesellschaft ¦ le plus jeune membre de la Société royale ¦ 皇家学会最年轻的会员
an anarchist with a conscience ¦ анархист с совестью ¦ ein Anarchist mit Gewissen ¦ un anarchiste qui a une conscience ¦ 有良知的无政府主义者
''',
  'hook_wants': '''
recover a stolen prototype engine ¦ вернуть украденный прототип двигателя ¦ einen gestohlenen Prototypmotor zurückholen ¦ récupérer un moteur prototype volé ¦ 找回被盗的原型引擎
win the transcontinental airship race ¦ выиграть трансконтинентальную гонку дирижаблей ¦ das transkontinentale Luftschiffrennen gewinnen ¦ gagner la course transcontinentale de dirigeables ¦ 赢得横跨大陆的飞艇竞速
find the saboteur in the factory ¦ найти вредителя на фабрике ¦ den Saboteur in der Fabrik finden ¦ trouver le saboteur dans l'usine ¦ 揪出工厂里的破坏者
deliver the blueprints to the Royal Society ¦ доставить чертежи в Королевское общество ¦ die Baupläne zur Königlichen Gesellschaft bringen ¦ remettre les plans à la Société royale ¦ 把蓝图送到皇家学会
protect a union leader until the vote ¦ охранять профсоюзного лидера до голосования ¦ eine Gewerkschaftsführerin bis zur Abstimmung schützen ¦ protéger une dirigeante syndicale jusqu'au vote ¦ 保护工会领袖直到投票
steal the memory drum of a calculating engine ¦ украсть барабан памяти вычислительной машины ¦ die Speichertrommel einer Rechenmaschine stehlen ¦ voler le tambour mémoire d'une machine à calculer ¦ 偷走计算机器的存储鼓
rescue a scientist from a sky pirate fortress ¦ спасти учёную из крепости небесных пиратов ¦ eine Wissenschaftlerin aus einer Himmelspiratenfestung retten ¦ sauver une savante d'une forteresse de pirates du ciel ¦ 从天空海盗的要塞中救出一名科学家
repair the clock tower before midnight ¦ починить часовую башню до полуночи ¦ den Uhrturm vor Mitternacht reparieren ¦ réparer la tour d'horloge avant minuit ¦ 在午夜前修好钟楼
expose the mill owner's poisonous dye ¦ разоблачить ядовитую краску владельца фабрики ¦ den giftigen Farbstoff des Fabrikbesitzers aufdecken ¦ dénoncer la teinture empoisonnée du patron de l'usine ¦ 揭露工厂主使用的毒染料
escort an automaton to its trial ¦ сопроводить автоматона на суд ¦ einen Automaten zu seinem Prozess eskortieren ¦ escorter un automate jusqu'à son procès ¦ 护送一具自动人偶去受审
''',
  'hook_obstacle': '''
the police are in the mill owners' pay ¦ полиция на содержании у фабрикантов ¦ die Polizei steht im Sold der Fabrikbesitzer ¦ la police est à la solde des patrons d'usine ¦ 警察拿着工厂主的钱
the airship's boiler is cracked ¦ котёл дирижабля дал трещину ¦ der Kessel des Luftschiffs hat einen Riss ¦ la chaudière du dirigeable est fêlée ¦ 飞艇的锅炉裂了
a rival inventor has hired thugs ¦ соперник-изобретатель нанял громил ¦ ein rivalisierender Erfinder hat Schläger angeheuert ¦ un inventeur rival a engagé des brutes ¦ 一位对手发明家雇了打手
the smog is so thick no one can see ¦ смог так густ, что ничего не видно ¦ der Smog ist so dicht, dass niemand etwas sieht ¦ le smog est si épais qu'on n'y voit rien ¦ 烟雾浓得什么都看不见
the patent office has sealed the records ¦ патентное бюро засекретило документы ¦ das Patentamt hat die Akten versiegelt ¦ l'office des brevets a scellé les dossiers ¦ 专利局封存了档案
the automatons obey only their maker's voice ¦ автоматоны слушаются только голоса своего создателя ¦ die Automaten gehorchen nur der Stimme ihres Schöpfers ¦ les automates n'obéissent qu'à la voix de leur créateur ¦ 自动人偶只听从造物主的声音
high society refuses to speak with workers ¦ высший свет отказывается говорить с рабочими ¦ die feine Gesellschaft spricht nicht mit Arbeitern ¦ la haute société refuse de parler aux ouvriers ¦ 上流社会拒绝与工人交谈
the only map is inside a locked music box ¦ единственная карта спрятана в запертой музыкальной шкатулке ¦ die einzige Karte liegt in einer verschlossenen Spieldose ¦ la seule carte est dans une boîte à musique verrouillée ¦ 唯一的地图锁在一个八音盒里
a strike has shut down every tram ¦ забастовка остановила все трамваи ¦ ein Streik hat alle Straßenbahnen stillgelegt ¦ une grève a arrêté tous les tramways ¦ 一场罢工让所有电车都停运了
the Duchess wants the prize for herself ¦ герцогиня хочет заполучить приз для себя ¦ die Herzogin will den Preis für sich ¦ la duchesse veut le prix pour elle-même ¦ 公爵夫人想独吞奖赏
''',
  'hook_twist': '''
the inventor stole the design first ¦ изобретатель первым украл чертёж ¦ der Erfinder hat den Entwurf zuerst gestohlen ¦ l'inventeur a volé le plan en premier ¦ 发明家自己先偷了设计
the saboteur is trying to prevent a disaster ¦ вредитель пытается предотвратить катастрофу ¦ der Saboteur versucht, eine Katastrophe zu verhindern ¦ le saboteur tente d'empêcher une catastrophe ¦ 破坏者其实是在阻止一场灾难
the automaton has a human brain ¦ у автоматона человеческий мозг ¦ der Automat hat ein menschliches Gehirn ¦ l'automate possède un cerveau humain ¦ 自动人偶里装的是人脑
a rival company organized the strike ¦ забастовку организовала конкурирующая компания ¦ eine Konkurrenzfirma hat den Streik organisiert ¦ une entreprise rivale a organisé la grève ¦ 罢工是对手公司策划的
the Duchess is the sky pirate captain ¦ герцогиня и есть капитан небесных пиратов ¦ die Herzogin ist die Kapitänin der Himmelspiraten ¦ la duchesse est la capitaine des pirates du ciel ¦ 公爵夫人正是天空海盗的船长
the engine runs on something alive ¦ двигатель работает на чём-то живом ¦ der Motor läuft mit etwas Lebendigem ¦ le moteur fonctionne grâce à quelque chose de vivant ¦ 引擎靠某种活物驱动
the patron planted the bomb ¦ бомбу подложил сам заказчик ¦ der Auftraggeber hat die Bombe selbst gelegt ¦ c'est le commanditaire qui a posé la bombe ¦ 炸弹正是委托人安放的
the clock tower controls more than time ¦ часовая башня управляет не только временем ¦ der Uhrturm steuert mehr als nur die Zeit ¦ la tour d'horloge contrôle bien plus que l'heure ¦ 钟楼控制的不只是时间
the calculating engine predicted all of this ¦ вычислительная машина предсказала всё это ¦ die Rechenmaschine hat all das vorhergesagt ¦ la machine à calculer avait tout prédit ¦ 计算机器早已预言了这一切
the missing scientist does not want to be rescued ¦ пропавшая учёная не хочет, чтобы её спасали ¦ die verschwundene Wissenschaftlerin will nicht gerettet werden ¦ la savante disparue ne veut pas être sauvée ¦ 失踪的科学家并不想被救
''',
  'loot_container': '''
Inventor's locked toolbox ¦ Запертый ящик с инструментами изобретателя ¦ Verschlossener Werkzeugkasten eines Erfinders ¦ Boîte à outils verrouillée d'un inventeur ¦ 发明家上锁的工具箱
Sky pirate's strongbox ¦ Сундук небесного пирата ¦ Geldkassette eines Himmelspiraten ¦ Coffre d'un pirate du ciel ¦ 天空海盗的钱箱
Gentleman's travel trunk ¦ Дорожный сундук джентльмена ¦ Reisekoffer eines Gentleman ¦ Malle de voyage d'un gentleman ¦ 绅士的旅行箱
Factory safe behind a portrait ¦ Фабричный сейф за портретом ¦ Fabriktresor hinter einem Porträt ¦ Coffre de l'usine derrière un portrait ¦ 肖像后面的工厂保险柜
Misdelivered pneumatic-post capsule ¦ Капсула пневмопочты, доставленная не туда ¦ Fehlgeleitete Rohrpostkapsel ¦ Capsule pneumatique mal livrée ¦ 送错的气动邮政胶囊
Crashed airship's cargo net ¦ Грузовая сеть разбившегося дирижабля ¦ Frachtnetz eines abgestürzten Luftschiffs ¦ Filet de cargaison d'un dirigeable écrasé ¦ 坠毁飞艇的货网
Automaton's hollow chest ¦ Полая грудь автоматона ¦ Hohle Brust eines Automaten ¦ Poitrine creuse d'un automate ¦ 自动人偶的空心胸腔
Pawnbroker's back shelf ¦ Задняя полка ломбарда ¦ Hinteres Regal eines Pfandleihers ¦ Étagère du fond d'un prêteur sur gages ¦ 当铺的后排货架
''',
  'loot_coin': '''
{#3d6*5} gold sovereigns ¦ золотые соверены: {#3d6*5} ¦ {#3d6*5} Goldsovereigns ¦ {#3d6*5} souverains d'or ¦ {#3d6*5}枚金镑
{#2d6*10} shillings and a pawn ticket ¦ шиллинги ({#2d6*10}) и залоговая квитанция ¦ {#2d6*10} Schilling und ein Pfandschein ¦ {#2d6*10} shillings et un reçu de prêteur sur gages ¦ {#2d6*10}先令和一张当票
a banknote for {#4d6*10} pounds ¦ банкнота на {#4d6*10} фунтов ¦ eine Banknote über {#4d6*10} Pfund ¦ un billet de {#4d6*10} livres ¦ 一张{#4d6*10}英镑的钞票
shares in a failed railway worth {#2d6*25} ¦ акции прогоревшей железной дороги на {#2d6*25} ¦ Aktien einer gescheiterten Eisenbahn im Wert von {#2d6*25} ¦ des actions d'un chemin de fer en faillite valant {#2d6*25} ¦ 一家倒闭铁路公司的股票，价值{#2d6*25}
''',
  'loot_item': '''
spare cogs and springs ×{#2d6} ¦ запасные шестерни и пружины ×{#2d6} ¦ Ersatzzahnräder und Federn ×{#2d6} ¦ rouages et ressorts de rechange ×{#2d6} ¦ 备用齿轮和弹簧 ×{#2d6}
a pocket watch with a hidden compartment ¦ карманные часы с тайником ¦ eine Taschenuhr mit Geheimfach ¦ une montre de poche à compartiment secret ¦ 带暗格的怀表
a steam pistol with a pressure gauge ¦ паровой пистолет с манометром ¦ eine Dampfpistole mit Manometer ¦ un pistolet à vapeur avec manomètre ¦ 带压力表的蒸汽手枪
vials of luminous ether ×{#1d4+1} ¦ флаконы светящегося эфира ×{#1d4+1} ¦ Fläschchen leuchtenden Äthers ×{#1d4+1} ¦ fioles d'éther lumineux ×{#1d4+1} ¦ 发光以太瓶 ×{#1d4+1}
a folding brass telescope ¦ складная латунная подзорная труба ¦ ein zusammenklappbares Messingfernrohr ¦ une longue-vue pliante en laiton ¦ 可折叠的黄铜望远镜
blueprints for half a flying machine ¦ чертежи половины летательного аппарата ¦ Baupläne für eine halbe Flugmaschine ¦ les plans de la moitié d'une machine volante ¦ 半台飞行器的蓝图
tins of fine tea ×{#1d4+1} ¦ банки хорошего чая ×{#1d4+1} ¦ Dosen feinen Tees ×{#1d4+1} ¦ boîtes de thé fin ×{#1d4+1} ¦ 上等茶叶罐 ×{#1d4+1}
a walking stick that becomes a sword ¦ трость, превращающаяся в шпагу ¦ ein Spazierstock, der zum Degen wird ¦ une canne qui se change en épée ¦ 能变成剑的手杖
an aviator's leather helmet ¦ кожаный шлем авиатора ¦ eine Lederhaube eines Fliegers ¦ un casque d'aviateur en cuir ¦ 飞行员皮帽
boxes of safety matches ×{#1d6+1} ¦ коробки спичек ×{#1d6+1} ¦ Schachteln Sicherheitszündhölzer ×{#1d6+1} ¦ boîtes d'allumettes ×{#1d6+1} ¦ 安全火柴 ×{#1d6+1}
a clockwork songbird that needs winding ¦ заводная певчая птичка, которую нужно завести ¦ ein Uhrwerk-Singvogel, der aufgezogen werden muss ¦ un oiseau chanteur mécanique à remonter ¦ 需要上发条的机械鸣鸟
a doctor's bag of patent medicines ¦ докторский саквояж с патентованными снадобьями ¦ eine Arzttasche voller Patentmedizin ¦ une trousse de médecin pleine de remèdes brevetés ¦ 装满专利药的医生包
coal briquettes ×{#2d4} ¦ угольные брикеты ×{#2d4} ¦ Kohlenbriketts ×{#2d4} ¦ briquettes de charbon ×{#2d4} ¦ 煤砖 ×{#2d4}
a top hat with a hidden pistol ¦ цилиндр со спрятанным пистолетом ¦ ein Zylinder mit verstecktem Revolver ¦ un haut-de-forme cachant un pistolet ¦ 藏着手枪的高礼帽
a folding silk parachute ¦ складной шёлковый парашют ¦ ein zusammenfaltbarer Seidenfallschirm ¦ un parachute pliable en soie ¦ 可折叠的丝绸降落伞
an automaton's spare hand ¦ запасная кисть автоматона ¦ eine Ersatzhand eines Automaten ¦ une main de rechange d'automate ¦ 自动人偶的备用手
''',
  'loot_curio': '''
a music box that plays a coded message ¦ музыкальная шкатулка, играющая шифрованное послание ¦ eine Spieldose, die eine verschlüsselte Botschaft spielt ¦ une boîte à musique qui joue un message codé ¦ 奏出密码讯息的八音盒
a punched card from a calculating engine ¦ перфокарта от вычислительной машины ¦ eine Lochkarte einer Rechenmaschine ¦ une carte perforée d'une machine à calculer ¦ 计算机器的打孔卡
a lens that shows things as they were yesterday ¦ линза, показывающая всё таким, каким оно было вчера ¦ eine Linse, die alles zeigt, wie es gestern war ¦ une lentille qui montre les choses telles qu'elles étaient hier ¦ 能照出昨日景象的透镜
a mechanical beetle that follows the heroes ¦ механический жук, следующий за героями ¦ ein mechanischer Käfer, der der Gruppe folgt ¦ un scarabée mécanique qui suit les héros ¦ 跟着主角们的机械甲虫
a ticket for an airship that sank in 1851 ¦ билет на дирижабль, затонувший в 1851 году ¦ ein Ticket für ein Luftschiff, das 1851 versank ¦ un billet pour un dirigeable englouti en 1851 ¦ 一张1851年沉没的飞艇的船票
a key shaped like a tiny gear ¦ ключ в форме крошечной шестерёнки ¦ ein Schlüssel in Form eines winzigen Zahnrads ¦ une clé en forme de minuscule engrenage ¦ 形如小齿轮的钥匙
a love letter written in engineering notation ¦ любовное письмо, написанное инженерными обозначениями ¦ ein Liebesbrief in technischer Notation ¦ une lettre d'amour rédigée en notation d'ingénieur ¦ 用工程符号写的情书
a photograph of a machine no one recognizes ¦ фотография машины, которую никто не узнаёт ¦ ein Foto einer Maschine, die niemand kennt ¦ une photographie d'une machine que personne ne reconnaît ¦ 一张没人认得的机器的照片
''',
  'faction_noun': '''
@Guild Guild ¦ Гильдия ¦ Gilde ¦ Guilde ¦ 行会
@Company Company ¦ Компания ¦ Kompanie ¦ Compagnie ¦ 公司
@Other Society ¦ Общество ¦ Gesellschaft ¦ Société ¦ 学会
@Order League ¦ Лига ¦ Liga ¦ Ligue ¦ 联盟
@Family House ¦ Дом ¦ Haus ¦ Maison ¦ 家族
@Other Union ¦ Союз ¦ Bund ¦ Union ¦ 工会
@Cult Brotherhood ¦ Братство ¦ Bruderschaft ¦ Confrérie ¦ 兄弟会
@Company Syndicate ¦ Синдикат ¦ Syndikat ¦ Syndicat ¦ 辛迪加
''',
  'faction_of': '''
of the Brass Compass ¦ Латунного Компаса ¦ des Messingkompasses ¦ du Compas de laiton ¦ 黄铜罗盘
of the Iron Gear ¦ Железной Шестерни ¦ des Eisernen Zahnrads ¦ du Rouage de fer ¦ 铁齿轮
of the Silver Piston ¦ Серебряного Поршня ¦ des Silbernen Kolbens ¦ du Piston d'argent ¦ 银活塞
of the Burning Coal ¦ Горящего Угля ¦ der Glühenden Kohle ¦ du Charbon ardent ¦ 燃煤
of the Open Sky ¦ Открытого Неба ¦ des Offenen Himmels ¦ du Ciel ouvert ¦ 长空
of the Eternal Engine ¦ Вечного Двигателя ¦ der Ewigen Maschine ¦ du Moteur éternel ¦ 永恒引擎
of the Midnight Chime ¦ Полуночного Боя ¦ des Mitternachtsschlags ¦ du Carillon de minuit ¦ 午夜钟鸣
of the Copper Rose ¦ Медной Розы ¦ der Kupfernen Rose ¦ de la Rose de cuivre ¦ 铜玫瑰
of the Steam Throne ¦ Парового Трона ¦ des Dampfthrons ¦ du Trône de vapeur ¦ 蒸汽王座
of the Seventh Spring ¦ Седьмой Пружины ¦ der Siebten Feder ¦ du Septième Ressort ¦ 第七发条
''',
  'faction_goal': '''
own every patent in the empire ¦ владеть всеми патентами империи ¦ jedes Patent des Reiches besitzen ¦ posséder tous les brevets de l'empire ¦ 垄断帝国的所有专利
give the vote to every worker ¦ дать право голоса каждому рабочему ¦ jedem Arbeiter das Wahlrecht geben ¦ donner le droit de vote à chaque ouvrier ¦ 让每个工人都有投票权
build a city in the sky ¦ построить город в небе ¦ eine Stadt am Himmel bauen ¦ bâtir une ville dans le ciel ¦ 在天空中建一座城市
replace every worker with an automaton ¦ заменить каждого рабочего автоматоном ¦ jeden Arbeiter durch einen Automaten ersetzen ¦ remplacer chaque ouvrier par un automate ¦ 用自动人偶取代每一个工人
stop the smog before the city chokes ¦ остановить смог, пока город не задохнулся ¦ den Smog stoppen, bevor die Stadt erstickt ¦ arrêter le smog avant que la ville n'étouffe ¦ 在城市窒息前阻止烟雾
restore real power to the monarchy ¦ вернуть монархии реальную власть ¦ der Monarchie wieder echte Macht verschaffen ¦ rendre un vrai pouvoir à la monarchie ¦ 让君主重掌实权
free the automatons ¦ освободить автоматонов ¦ die Automaten befreien ¦ libérer les automates ¦ 解放自动人偶
control the coal supply ¦ контролировать поставки угля ¦ die Kohleversorgung kontrollieren ¦ contrôler l'approvisionnement en charbon ¦ 控制煤炭供应
''',
  'faction_method': '''
patent lawsuits and hired thugs ¦ патентные иски и нанятые громилы ¦ Patentklagen und angeheuerte Schläger ¦ procès en brevets et brutes engagées ¦ 专利诉讼加雇来的打手
pamphlets printed overnight ¦ листовки, напечатанные за ночь ¦ über Nacht gedruckte Flugblätter ¦ des pamphlets imprimés en une nuit ¦ 连夜印好的传单
sabotage disguised as accidents ¦ саботаж под видом несчастных случаев ¦ Sabotage, getarnt als Unfälle ¦ du sabotage déguisé en accidents ¦ 伪装成意外的破坏
airship raids on rival factories ¦ налёты дирижаблей на фабрики конкурентов ¦ Luftschiffangriffe auf Konkurrenzfabriken ¦ des raids de dirigeables contre les usines rivales ¦ 用飞艇袭击对手的工厂
charity balls that fund secret weapons ¦ благотворительные балы, финансирующие тайное оружие ¦ Wohltätigkeitsbälle, die geheime Waffen finanzieren ¦ des bals de charité qui financent des armes secrètes ¦ 为秘密武器筹资的慈善舞会
calculating engines that predict the market ¦ вычислительные машины, предсказывающие рынок ¦ Rechenmaschinen, die den Markt vorhersagen ¦ des machines à calculer qui prédisent le marché ¦ 预测市场的计算机器
strikes timed to the minute ¦ забастовки, рассчитанные до минуты ¦ auf die Minute geplante Streiks ¦ des grèves réglées à la minute près ¦ 精确到分钟的罢工
marriages into old aristocratic families ¦ браки со старыми аристократическими семьями ¦ Heiraten in alte Adelsfamilien ¦ des mariages avec de vieilles familles aristocratiques ¦ 与古老贵族家庭联姻
''',
  'faction_symbol': '''
a gear with a closed eye ¦ шестерня с закрытым глазом ¦ ein Zahnrad mit geschlossenem Auge ¦ un rouage à l'œil fermé ¦ 带闭眼的齿轮
a winged top hat ¦ крылатый цилиндр ¦ ein geflügelter Zylinder ¦ un haut-de-forme ailé ¦ 带翅膀的高礼帽
a hammer crossed with a quill ¦ молот, скрещённый с пером ¦ ein Hammer, gekreuzt mit einer Feder ¦ un marteau croisé avec une plume ¦ 与羽毛笔交叉的锤子
a key inside a lightbulb ¦ ключ внутри лампочки ¦ ein Schlüssel in einer Glühbirne ¦ une clé dans une ampoule ¦ 灯泡里的钥匙
a crowned piston ¦ поршень в короне ¦ ein gekrönter Kolben ¦ un piston couronné ¦ 戴王冠的活塞
an airship over a broken chain ¦ дирижабль над разорванной цепью ¦ ein Luftschiff über einer zerbrochenen Kette ¦ un dirigeable au-dessus d'une chaîne brisée ¦ 断链上方的飞艇
a clock face with no hands ¦ циферблат без стрелок ¦ ein Zifferblatt ohne Zeiger ¦ un cadran sans aiguilles ¦ 没有指针的钟面
a copper rose with steel thorns ¦ медная роза со стальными шипами ¦ eine Kupferrose mit Stahldornen ¦ une rose de cuivre aux épines d'acier ¦ 长着钢刺的铜玫瑰
''',
  'weather_sky': '''
yellow smog hangs low over the rooftops ¦ жёлтый смог низко висит над крышами ¦ gelber Smog hängt tief über den Dächern ¦ un smog jaune pèse bas sur les toits ¦ 黄色烟雾低低地笼罩着屋顶
airships drift through a rose-colored dawn ¦ дирижабли плывут сквозь розовый рассвет ¦ Luftschiffe treiben durch eine rosafarbene Morgendämmerung ¦ des dirigeables dérivent dans une aube rose ¦ 飞艇在玫瑰色的黎明中飘过
sooty rain streaks every window ¦ грязный от сажи дождь полосует окна ¦ rußiger Regen zieht Streifen über jedes Fenster ¦ une pluie chargée de suie strie chaque fenêtre ¦ 夹着煤灰的雨在窗上留下道道污痕
a clear, cold sky after the factories close ¦ ясное холодное небо, когда фабрики закрываются ¦ ein klarer, kalter Himmel nach Fabrikschluss ¦ un ciel clair et froid après la fermeture des usines ¦ 工厂关门后晴朗寒冷的天空
thunder rolls, and every lightning rod sings ¦ гремит гром, и поют все громоотводы ¦ Donner grollt, und jeder Blitzableiter singt ¦ le tonnerre gronde et chaque paratonnerre chante ¦ 雷声滚滚，每根避雷针都在嗡鸣
steam clouds from the mills hide the moon ¦ облака пара с фабрик скрывают луну ¦ Dampfwolken der Fabriken verdecken den Mond ¦ les nuages de vapeur des usines cachent la lune ¦ 工厂的蒸汽云遮住了月亮
a brilliant sunset tinted green by chemicals ¦ яркий закат с зеленоватым химическим отливом ¦ ein prächtiger Sonnenuntergang, von Chemikalien grün getönt ¦ un couchant éclatant teinté de vert par les produits chimiques ¦ 被化学物染成绿色的绚烂晚霞
fog so thick the lamplighters get lost ¦ туман такой густой, что фонарщики теряются ¦ Nebel so dicht, dass sich die Laternenanzünder verlaufen ¦ un brouillard si épais que les allumeurs de réverbères se perdent ¦ 雾浓得连点灯人都迷了路
''',
  'weather_air': '''
the air tastes of coal and hot iron ¦ воздух отдаёт углём и раскалённым железом ¦ die Luft schmeckt nach Kohle und heißem Eisen ¦ l'air a un goût de charbon et de fer chaud ¦ 空气里是煤和热铁的味道
factory whistles echo across the river ¦ фабричные гудки разносятся над рекой ¦ Fabrikpfeifen hallen über den Fluss ¦ les sifflets des usines résonnent sur la rivière ¦ 工厂汽笛声在河面上回荡
a warm wind blows soot into every collar ¦ тёплый ветер задувает сажу за каждый воротник ¦ ein warmer Wind bläst Ruß in jeden Kragen ¦ un vent tiède souffle de la suie dans chaque col ¦ 暖风把煤灰吹进每个衣领
the damp makes every gear stiffen ¦ от сырости тугими становятся все шестерни ¦ die Feuchtigkeit lässt jedes Zahnrad klemmen ¦ l'humidité grippe chaque engrenage ¦ 潮气让每个齿轮都变得僵硬
a crisp breeze smells of roasting chestnuts ¦ свежий ветерок пахнет жареными каштанами ¦ eine frische Brise riecht nach gerösteten Maronen ¦ une brise vive sent les marrons grillés ¦ 清爽的微风里飘着烤栗子香
the hum of a thousand engines never stops ¦ гул тысячи машин не стихает ни на миг ¦ das Brummen tausender Maschinen hört nie auf ¦ le ronronnement de mille moteurs ne cesse jamais ¦ 千台机器的轰鸣从不停歇
cold air sinks from the airship docks ¦ холодный воздух опускается с доков дирижаблей ¦ kalte Luft sinkt von den Luftschiffdocks herab ¦ l'air froid descend des quais à dirigeables ¦ 冷空气从飞艇码头沉降下来
a chemical tang stings the nose ¦ химический привкус щиплет нос ¦ ein chemischer Beigeschmack sticht in der Nase ¦ une odeur chimique pique le nez ¦ 刺鼻的化学味扑面而来
''',
  'weather_omen': '''
every clock in the city strikes a minute late ¦ все часы города бьют на минуту позже ¦ jede Uhr der Stadt schlägt eine Minute zu spät ¦ chaque horloge de la ville sonne avec une minute de retard ¦ 全城的钟都晚一分钟敲响
an unmanned airship drifts overhead ¦ над головой дрейфует дирижабль без экипажа ¦ ein unbemanntes Luftschiff treibt über die Stadt ¦ un dirigeable sans équipage dérive au-dessus des toits ¦ 一艘无人飞艇从头顶飘过
the automatons stop and look at the sky ¦ автоматоны замирают и смотрят в небо ¦ die Automaten halten inne und blicken zum Himmel ¦ les automates s'arrêtent et regardent le ciel ¦ 自动人偶停下来仰望天空
pigeons refuse to land anywhere near the factory ¦ голуби не садятся возле фабрики ¦ Tauben landen nirgends in der Nähe der Fabrik ¦ les pigeons refusent de se poser près de l'usine ¦ 鸽子不肯落在工厂附近
the canal freezes overnight in midsummer ¦ канал замерзает за одну ночь — посреди лета ¦ der Kanal friert mitten im Sommer über Nacht zu ¦ le canal gèle en une nuit, en plein été ¦ 运河在盛夏一夜之间结了冰
every lamp on the street flickers in rhythm ¦ все фонари на улице мигают в едином ритме ¦ jede Laterne der Straße flackert im Takt ¦ tous les réverbères de la rue clignotent en rythme ¦ 街上所有的灯都按节奏闪烁
a mechanical bird sings a song no one taught it ¦ механическая птица поёт песню, которой её никто не учил ¦ ein mechanischer Vogel singt ein Lied, das ihm niemand beibrachte ¦ un oiseau mécanique chante un air que personne ne lui a appris ¦ 一只机械鸟唱起了没人教过的歌
the factory smoke turns pure white ¦ дым фабрик становится белоснежным ¦ der Fabrikrauch wird schneeweiß ¦ la fumée des usines devient d'un blanc pur ¦ 工厂的烟变成了纯白色
''',
  'rumor_source': '''
a newsboy shouting an extra edition ¦ мальчишка-газетчик, выкрикивающий экстренный выпуск ¦ ein Zeitungsjunge, der ein Extrablatt ausruft ¦ un crieur de journaux annonçant une édition spéciale ¦ 叫卖号外的报童
a lady's maid at the market ¦ горничная на рынке ¦ eine Zofe auf dem Markt ¦ une femme de chambre au marché ¦ 市场上的贴身女仆
a drunk engineer ¦ пьяный инженер ¦ ein betrunkener Ingenieur ¦ un ingénieur ivre ¦ 喝醉的工程师
a pneumatic message sent by mistake ¦ ошибочно отправленная пневмопочта ¦ eine versehentlich verschickte Rohrpostnachricht ¦ un message pneumatique envoyé par erreur ¦ 误发的气动邮件
an airship deckhand on shore leave ¦ палубный матрос дирижабля в увольнительной ¦ ein Luftschiffmatrose auf Landgang ¦ un matelot de dirigeable en permission ¦ 上岸休假的飞艇水手
the society pages, read between the lines ¦ светская хроника, если читать между строк ¦ die Gesellschaftsseiten, zwischen den Zeilen gelesen ¦ les pages mondaines, lues entre les lignes ¦ 社交版的字里行间
a chimney sweep's gossip ¦ болтовня трубочиста ¦ der Tratsch eines Schornsteinfegers ¦ les ragots d'un ramoneur ¦ 扫烟囱工的闲话
a talking automaton in a shop window ¦ говорящий автоматон в витрине ¦ ein sprechender Automat im Schaufenster ¦ un automate parlant dans une vitrine ¦ 橱窗里会说话的自动人偶
''',
  'rumor_text': '''
the Queen's new consort is an automaton ¦ новый супруг королевы — автоматон ¦ der neue Prinzgemahl der Königin ist ein Automat ¦ le nouveau prince consort de la reine est un automate ¦ 女王的新王夫是一具自动人偶
the Blackmoor mill puts children on the night shift ¦ фабрика Блэкмур ставит детей в ночную смену ¦ die Blackmoor-Fabrik setzt Kinder in der Nachtschicht ein ¦ la filature Blackmoor fait travailler des enfants de nuit ¦ 布莱克莫尔工厂在夜班使用童工
someone has built a perpetual motion machine in secret ¦ кто-то тайно построил вечный двигатель ¦ jemand hat im Geheimen ein Perpetuum mobile gebaut ¦ quelqu'un a construit en secret une machine à mouvement perpétuel ¦ 有人秘密造出了永动机
the sky pirates have a floating island ¦ у небесных пиратов есть летающий остров ¦ die Himmelspiraten besitzen eine schwebende Insel ¦ les pirates du ciel possèdent une île volante ¦ 天空海盗拥有一座浮空岛
the Royal Society is hiding a message from Mars ¦ Королевское общество скрывает послание с Марса ¦ die Königliche Gesellschaft verheimlicht eine Botschaft vom Mars ¦ la Société royale cache un message venu de Mars ¦ 皇家学会藏着一条来自火星的讯息
the famous inventor died years ago and his assistant signs his name ¦ знаменитый изобретатель умер много лет назад, а его имя подписывает ассистент ¦ der berühmte Erfinder ist seit Jahren tot, und sein Assistent unterschreibt für ihn ¦ le célèbre inventeur est mort depuis des années et son assistant signe à sa place ¦ 那位著名发明家早已去世，一直是助手在替他签名
a strike is planned for the Queen's birthday ¦ на день рождения королевы готовится забастовка ¦ für den Geburtstag der Königin ist ein Streik geplant ¦ une grève est prévue pour l'anniversaire de la reine ¦ 有人计划在女王生日那天罢工
someone is making the smog thicker on purpose ¦ кто-то нарочно делает смог гуще ¦ jemand macht den Smog absichtlich dichter ¦ quelqu'un épaissit le smog exprès ¦ 有人故意让烟雾变得更浓
the new railway leads nowhere ¦ новая железная дорога ведёт в никуда ¦ die neue Eisenbahn führt ins Nirgendwo ¦ le nouveau chemin de fer ne mène nulle part ¦ 新铁路通向的是一片虚无
the clock tower hides a prison ¦ в часовой башне скрыта тюрьма ¦ im Uhrturm verbirgt sich ein Gefängnis ¦ la tour d'horloge cache une prison ¦ 钟楼里藏着一座监狱
''',
};

const _perLang = <String, Map<String, String>>{
  'en': {
    'settle_pre': '''
Brass
Copper
Coal
Iron
Smoke
Gear
Kettle
Soot
Anvil
Rivet
''',
    'settle_suf': '''
bridge
borough
chester
wick
ford
mill
ton
haven
''',
  },
  'ru': {
    'settle_pre': '''
Медно
Угле
Железно
Дымо
Паро
Котло
Стале
Искро
''',
    'settle_suf': '''
град
горск
заводск
мостье
поль
''',
  },
  'de': {
    'settle_pre': '''
Messing
Kupfer
Kohlen
Eisen
Rauch
Dampf
Kessel
Ruß
Amboss
Niet
''',
    'settle_suf': '''
brück
heim
burg
stadt
hütte
werk
hafen
furt
''',
  },
  'fr': {
    'settle_pre': '''
Forge
Fer
Cuivre
Houille
Vapeur
Laiton
Rouage
Suie
''',
    'settle_suf': '''
ville
bourg
mont
pont
fort
val
''',
  },
  'zh': {
    'settle_pre': '''
黄铜
铜
煤
铁
烟
汽
锅炉
铆钉
''',
    'settle_suf': '''
城
镇
桥
港
堡
厂
''',
  },
};
