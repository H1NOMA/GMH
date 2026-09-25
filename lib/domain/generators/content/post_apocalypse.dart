import '../content_format.dart';

/// Dust, rust, water rights and sealed vaults.
final postApocalypseContent =
    PackContent.build(rows: _rows, names: _names, perLang: _perLang);

const _names = <String, String>{
  'scav_given': '''
Rust ¦ Ржавчина ¦ 锈
Two-Coins ¦ Два Гроша ¦ 两枚币
Scrap ¦ Хлам ¦ 废料
Dustdevil ¦ Пылевик ¦ 尘魔
Tincan ¦ Жестянка ¦ 铁罐
Sparkplug ¦ Свеча ¦ 火花塞
Ratchet ¦ Трещотка ¦ 棘轮
Cinder ¦ Окалина ¦ 余烬
Jackal ¦ Шакал ¦ 豺
Lockjaw ¦ Столбняк ¦ 咬死不放
Geiger ¦ Гейгер ¦ 盖革
Bonesaw ¦ Костопил ¦ 骨锯
Salvage ¦ Утиль ¦ 回收
Mirage ¦ Мираж ¦ 海市蜃楼
Crowbar ¦ Фомка ¦ 撬棍
Dust ¦ Пыль ¦ 尘
Hatchet ¦ Топорик ¦ 手斧
Flint ¦ Кремень ¦ 燧石
''',
  'settler_given_f': '''
Mags ¦ Мэгс ¦ 玛格丝
Dot ¦ Дот ¦ 多特
Rosie ¦ Рози ¦ 萝西
June ¦ Джун ¦ 琼
Lottie ¦ Лотти ¦ 洛蒂
Bea ¦ Би ¦ 碧
Nell ¦ Нелл ¦ 内尔
Fern ¦ Ферн ¦ 芙恩
Sadie ¦ Сэди ¦ 赛迪
Tilly ¦ Тилли ¦ 蒂莉
Ivy ¦ Айви ¦ 艾薇
Olive ¦ Олив ¦ 奥利芙
''',
  'settler_given_m': '''
Jem ¦ Джем ¦ 杰姆
Tuck ¦ Так ¦ 塔克
Abe ¦ Эйб ¦ 埃布
Cal ¦ Кэл ¦ 卡尔
Hank ¦ Хэнк ¦ 汉克
Ollie ¦ Олли ¦ 奥利
Gus ¦ Гас ¦ 格斯
Lem ¦ Лем ¦ 莱姆
Rudy ¦ Руди ¦ 鲁迪
Walt ¦ Уолт ¦ 沃尔特
Zeke ¦ Зик ¦ 齐克
Bo ¦ Бо ¦ 博
''',
};

const _rows = <String, String>{
  'cultures': '''
@scav Wasteland handles ¦ Клички пустошей ¦ Ödland-Namen ¦ Surnoms des terres désolées ¦ 废土代号
@settler Settlers ¦ Поселенцы ¦ Siedler ¦ Colons ¦ 定居者
''',
  'settler_family': '''
of Dry Creek ¦ из Сухого Ручья ¦ vom Trockenbach ¦ de Ruisseau-Sec ¦ 枯溪
of the Water Tower ¦ с Водонапорной башни ¦ vom Wasserturm ¦ du Château-d'eau ¦ 水塔
of Last Stop ¦ с Конечной ¦ von der Endstation ¦ du Terminus ¦ 终点站
of the Mall ¦ из Торгового центра ¦ aus dem Einkaufszentrum ¦ du Centre commercial ¦ 商场
of Glass Flats ¦ со Стеклянной равнины ¦ von der Glasebene ¦ de la Plaine-de-Verre ¦ 玻璃滩
of the Dam ¦ с Плотины ¦ vom Staudamm ¦ du Barrage ¦ 大坝
of Route Nine ¦ с Девятой трассы ¦ von der Route Neun ¦ de la Route Neuf ¦ 九号公路
of the Silo ¦ с Элеватора ¦ vom Silo ¦ du Silo ¦ 粮仓
of Crater Town ¦ из Кратерного городка ¦ aus Kraterstadt ¦ de Cratère-Ville ¦ 陨坑镇
of the Old Airport ¦ со Старого аэропорта ¦ vom Alten Flughafen ¦ du Vieil Aéroport ¦ 旧机场
of Rusty Bridge ¦ с Ржавого моста ¦ von der Rostbrücke ¦ du Pont-Rouillé ¦ 锈桥
''',
  'settler_full': '''
{=given} {=family} ¦ {=given} {=family} ¦ {=given} {=family} ¦ {=given} {=family} ¦ {=family}的{=given}
''',
  'epithet': '''
the Unkillable ¦ Неубиваемый~Неубиваемая ¦ der Unverwüstliche~die Unverwüstliche ¦ l'Increvable ¦ 杀不死的
Glowbones ¦ Светящиеся Кости ¦ Leuchtknochen ¦ Os-Luisants ¦ 荧骨
Waterfinder ¦ Искатель Воды~Искательница Воды ¦ der Wasserfinder~die Wasserfinderin ¦ Trouve-l'Eau ¦ 寻水者
the Last Mechanic ¦ Последний Механик ¦ der letzte Mechaniker~die letzte Mechanikerin ¦ le Dernier Mécano ¦ 最后的机械师
Half-Mask ¦ Полумаска ¦ Halbmaske ¦ Demi-Masque ¦ 半面罩
Dust-Walker ¦ Бредущий по Пыли~Бредущая по Пыли ¦ Staubwanderer~Staubwanderin ¦ Marche-Poussière ¦ 行尘者
the Mayor of Nothing ¦ Мэр Пустоты ¦ der Bürgermeister von Nirgendwo~die Bürgermeisterin von Nirgendwo ¦ le Maire de Nulle-Part~la Mairesse de Nulle-Part ¦ 虚无镇长
Six-Fingers ¦ Шестипалый~Шестипалая ¦ Sechsfinger ¦ Six-Doigts ¦ 六指
Tank ¦ Танк ¦ Panzer ¦ Tank ¦ 坦克
Stormchaser ¦ Ловец Бурь ¦ Sturmjäger~Sturmjägerin ¦ Chasseur-d'Orages~Chasseuse-d'Orages ¦ 追风者
''',
  'ancestry': '''
@settler vault-born ¦ рождённый в убежище~рождённая в убежище ¦ Bunkerkind ¦ né dans un abri~née dans un abri ¦ 避难所出生
@scav wasteland-born ¦ дитя пустоши ¦ Ödlandkind ¦ enfant des terres désolées ¦ 废土出生
@settler from settler farming stock ¦ из фермеров-поселенцев ¦ aus einer Siedlerbauernfamilie ¦ issu de fermiers colons~issue de fermiers colons ¦ 定居点农户出身
mutant ¦ мутант~мутантка ¦ Mutant~Mutantin ¦ mutant~mutante ¦ 变异人
@scav road nomad ¦ кочевник дорог~кочевница дорог ¦ Straßennomade~Straßennomadin ¦ nomade de la route ¦ 公路游民
survivor from before the Collapse ¦ переживший Крах~пережившая Крах ¦ Überlebender aus der Zeit vor dem Zusammenbruch~Überlebende aus der Zeit vor dem Zusammenbruch ¦ survivant d'avant l'Effondrement~survivante d'avant l'Effondrement ¦ 崩溃前的幸存者
''',
  'role': '''
scavenger ¦ мусорщик~мусорщица ¦ Schrottsammler~Schrottsammlerin ¦ récupérateur~récupératrice ¦ 拾荒者
water merchant ¦ торговец водой~торговка водой ¦ Wasserhändler~Wasserhändlerin ¦ marchand d'eau~marchande d'eau ¦ 水商
caravan guard ¦ охранник каравана~охранница каравана ¦ Karawanenwache ¦ garde de caravane ¦ 商队护卫
settlement mechanic ¦ механик поселения ¦ Siedlungsmechaniker~Siedlungsmechanikerin ¦ mécano de la colonie ¦ 定居点机械师
road warrior ¦ воин дорог ¦ Straßenkrieger~Straßenkriegerin ¦ guerrier de la route~guerrière de la route ¦ 公路战士
radio preacher ¦ радиопроповедник~радиопроповедница ¦ Radioprediger~Radiopredigerin ¦ prêcheur radio~prêcheuse radio ¦ 电台传道人
field medic ¦ полевой медик ¦ Feldsanitäter~Feldsanitäterin ¦ médecin de terrain ¦ 战地医护
seed keeper ¦ хранитель семян~хранительница семян ¦ Saatgutwächter~Saatgutwächterin ¦ gardien des semences~gardienne des semences ¦ 种子守护人
bounty tracker ¦ охотник за наградой~охотница за наградой ¦ Kopfgeldjäger~Kopfgeldjägerin ¦ traqueur de primes~traqueuse de primes ¦ 赏金追踪者
rotgut brewer ¦ самогонщик~самогонщица ¦ Schnapsbrenner~Schnapsbrennerin ¦ bouilleur de gnôle~bouilleuse de gnôle ¦ 私酒酿造者
cartographer of ruins ¦ картограф руин ¦ Ruinenkartograf~Ruinenkartografin ¦ cartographe des ruines ¦ 废墟制图师
former vault overseer ¦ бывший смотритель убежища~бывшая смотрительница убежища ¦ ehemaliger Bunkeraufseher~ehemalige Bunkeraufseherin ¦ ancien intendant d'abri~ancienne intendante d'abri ¦ 前避难所主管
''',
  'appearance': '''
goggles pushed up on a sunburned forehead ¦ очки-гогглы, поднятые на обгоревший лоб ¦ eine Schutzbrille auf der sonnenverbrannten Stirn ¦ des lunettes relevées sur un front brûlé par le soleil ¦ 推到晒伤额头上的护目镜
armor made from road signs ¦ доспех из дорожных знаков ¦ eine Rüstung aus Verkehrsschildern ¦ une armure faite de panneaux routiers ¦ 用路牌拼成的盔甲
a gas mask worn around the neck like jewelry ¦ противогаз на шее, как украшение ¦ eine Gasmaske, wie Schmuck um den Hals getragen ¦ un masque à gaz porté au cou comme un bijou ¦ 像首饰一样挂在脖子上的防毒面具
radiation blotches down one arm ¦ радиационные пятна вдоль руки ¦ Strahlenflecken den ganzen Arm hinab ¦ des taches de radiation le long d'un bras ¦ 一条手臂上满是辐射斑
a necklace of bottle caps ¦ ожерелье из бутылочных крышек ¦ eine Halskette aus Kronkorken ¦ un collier de capsules ¦ 瓶盖串成的项链
a prosthetic leg made from a car jack ¦ протез ноги из автомобильного домкрата ¦ eine Beinprothese aus einem Wagenheber ¦ une jambe prothétique faite d'un cric ¦ 用千斤顶做成的假腿
''',
  'motivation': '''
find a working water purifier ¦ найти исправный водоочиститель ¦ einen funktionierenden Wasserfilter finden ¦ trouver un purificateur d'eau qui marche ¦ 找到一台能用的净水器
reach the green valley from the old stories ¦ добраться до зелёной долины из старых историй ¦ das grüne Tal aus den alten Geschichten erreichen ¦ atteindre la vallée verte des vieilles histoires ¦ 抵达老故事里的绿色山谷
repair the settlement's generator before winter ¦ починить генератор поселения до зимы ¦ den Generator der Siedlung vor dem Winter reparieren ¦ réparer le générateur de la colonie avant l'hiver ¦ 在冬天前修好定居点的发电机
avenge a caravan wiped out by raiders ¦ отомстить за караван, уничтоженный налётчиками ¦ eine von Plünderern ausgelöschte Karawane rächen ¦ venger une caravane anéantie par des pillards ¦ 为被掠夺者屠灭的商队复仇
learn what caused the Collapse ¦ узнать, что вызвало Крах ¦ herausfinden, was den Zusammenbruch verursacht hat ¦ découvrir ce qui a causé l'Effondrement ¦ 查明崩溃的起因
plant a real orchard ¦ посадить настоящий сад ¦ einen echten Obstgarten anpflanzen ¦ planter un vrai verger ¦ 种出一片真正的果园
''',
  'secret': '''
knows the code to a sealed vault ¦ знает код от запечатанного убежища ¦ kennt den Code eines versiegelten Bunkers ¦ connaît le code d'un abri scellé ¦ 知道一座封闭避难所的密码
used to ride with the raiders ¦ когда-то ездил с налётчиками~когда-то ездила с налётчиками ¦ ist früher mit den Plünderern gefahren ¦ roulait autrefois avec les pillards ¦ 曾经和掠夺者一起混过
is slowly mutating ¦ медленно мутирует ¦ mutiert langsam ¦ mute lentement ¦ 正在缓慢变异
poisoned the old well to drive out rivals ¦ отравил старый колодец, чтобы выжить соперников~отравила старый колодец, чтобы выжить соперников ¦ hat den alten Brunnen vergiftet, um Rivalen zu vertreiben ¦ a empoisonné le vieux puits pour chasser des rivaux ¦ 为了赶走对手而在老井里下了毒
hides a working radio and talks to someone on it ¦ прячет рабочую рацию и с кем-то по ней говорит ¦ versteckt ein funktionierendes Funkgerät und spricht darüber mit jemandem ¦ cache une radio qui marche et parle à quelqu'un ¦ 藏着一台能用的电台，并在与某人通话
is not immune to the plague, only lucky ¦ не имеет иммунитета к чуме — просто везёт ¦ ist nicht immun gegen die Seuche, nur vom Glück verfolgt ¦ n'est pas immunisé contre la peste, seulement chanceux~n'est pas immunisée contre la peste, seulement chanceuse ¦ 并非对瘟疫免疫，只是运气好
''',
  'settle_size': '''
@Village a camp of {#2d6*5} survivors ¦ лагерь на {#2d6*5} выживших ¦ ein Lager mit {#2d6*5} Überlebenden ¦ un camp de {#2d6*5} survivants ¦ 住着{#2d6*5}名幸存者的营地
@Village a walled settlement of about {#4d6*10} people ¦ обнесённое стеной поселение, около {#4d6*10} жителей ¦ eine ummauerte Siedlung mit etwa {#4d6*10} Menschen ¦ une colonie fortifiée d'environ {#4d6*10} habitants ¦ 约{#4d6*10}人的围墙定居点
@Town a trade town of some {#3d6*100} people ¦ торговый город, около {#3d6*100} жителей ¦ eine Handelsstadt mit rund {#3d6*100} Menschen ¦ une ville marchande d'environ {#3d6*100} habitants ¦ 约{#3d6*100}人的贸易镇
@City a rebuilt city-state of {#2d10*1000} souls ¦ отстроенный город-государство, {#2d10*1000} душ ¦ ein wiederaufgebauter Stadtstaat mit {#2d10*1000} Seelen ¦ une cité-État reconstruite de {#2d10*1000} âmes ¦ {#2d10*1000}人的重建城邦
''',
  'settle_feature': '''
a water tower painted with the town's rules ¦ водонапорная башня, расписанная правилами города ¦ ein Wasserturm, bemalt mit den Regeln der Stadt ¦ un château d'eau peint des règles de la ville ¦ 写满镇规的水塔
walls built from stacked buses ¦ стены из поставленных друг на друга автобусов ¦ Mauern aus gestapelten Bussen ¦ des murs faits de bus empilés ¦ 用叠起来的公交车筑成的城墙
a greenhouse made of windshields ¦ теплица из лобовых стёкол ¦ ein Gewächshaus aus Windschutzscheiben ¦ une serre faite de pare-brise ¦ 用挡风玻璃搭成的温室
a crashed airliner used as a meeting hall ¦ разбитый авиалайнер, ставший залом собраний ¦ ein abgestürztes Passagierflugzeug als Versammlungshalle ¦ un avion de ligne écrasé servant de salle commune ¦ 坠毁客机改成的议事厅
a market held in a dry swimming pool ¦ рынок в высохшем бассейне ¦ ein Markt in einem trockenen Schwimmbecken ¦ un marché installé dans une piscine vide ¦ 设在干涸泳池里的集市
a shrine of old-world toys ¦ святилище из игрушек старого мира ¦ ein Schrein aus Spielzeug der alten Welt ¦ un autel de jouets de l'ancien monde ¦ 旧世界玩具堆成的神龛
wind turbines that squeal all night ¦ ветряки, которые визжат всю ночь ¦ Windräder, die die ganze Nacht quietschen ¦ des éoliennes qui grincent toute la nuit ¦ 整夜吱吱作响的风力发电机
a library everyone guards but nobody reads ¦ библиотека, которую все охраняют, но никто не читает ¦ eine Bibliothek, die alle bewachen, aber niemand liest ¦ une bibliothèque que tous gardent mais que personne ne lit ¦ 人人守护却无人阅读的图书馆
a radio mast that still broadcasts music ¦ радиомачта, которая всё ещё передаёт музыку ¦ ein Funkmast, der noch Musik sendet ¦ un mât radio qui diffuse encore de la musique ¦ 仍在播放音乐的无线电塔
a crater lake that glows at night ¦ кратерное озеро, светящееся по ночам ¦ ein Kratersee, der nachts leuchtet ¦ un lac de cratère qui luit la nuit ¦ 夜里发光的陨坑湖
''',
  'settle_trouble': '''
the water filter is failing ¦ водяной фильтр выходит из строя ¦ der Wasserfilter versagt ¦ le filtre à eau est en train de lâcher ¦ 净水滤芯快要失效了
raiders demand a tribute of fuel ¦ налётчики требуют дань топливом ¦ Plünderer verlangen Tribut in Treibstoff ¦ des pillards exigent un tribut en carburant ¦ 掠夺者要求用燃料进贡
a dust storm has buried the southern gate ¦ пылевая буря засыпала южные ворота ¦ ein Staubsturm hat das Südtor verschüttet ¦ une tempête de poussière a enseveli la porte sud ¦ 沙尘暴掩埋了南门
a sickness is spreading from the new arrivals ¦ от новоприбывших расходится болезнь ¦ eine Krankheit breitet sich von den Neuankömmlingen aus ¦ une maladie se propage depuis les nouveaux venus ¦ 疾病从新来的人身上蔓延开来
the seed stock has been stolen ¦ украли семенной фонд ¦ das Saatgut wurde gestohlen ¦ la réserve de semences a été volée ¦ 种子储备被偷了
mutant beasts are digging under the walls ¦ звери-мутанты делают подкоп под стены ¦ mutierte Bestien graben unter den Mauern ¦ des bêtes mutantes creusent sous les murs ¦ 变异野兽正在城墙下挖洞
two families are fighting over the last working truck ¦ две семьи дерутся за последний исправный грузовик ¦ zwei Familien streiten um den letzten fahrtüchtigen Laster ¦ deux familles se disputent le dernier camion en état de marche ¦ 两家人为最后一辆能开的卡车争斗
the radio has started broadcasting orders ¦ радио начало передавать приказы ¦ das Radio hat begonnen, Befehle zu senden ¦ la radio s'est mise à diffuser des ordres ¦ 电台开始播放命令
the leader has vanished in the ruins ¦ вожак пропал в руинах ¦ der Anführer ist in den Ruinen verschwunden ¦ le chef a disparu dans les ruines ¦ 首领在废墟里失踪了
the old vault next door has opened ¦ соседнее старое убежище открылось ¦ der alte Bunker nebenan hat sich geöffnet ¦ le vieil abri voisin s'est ouvert ¦ 隔壁的老避难所打开了
''',
  'settle_authority': '''
a warlord with a working tank ¦ полевой командир с исправным танком ¦ ein Kriegsherr mit einem fahrtüchtigen Panzer ¦ un seigneur de guerre qui possède un tank en état de marche ¦ 拥有一辆能开坦克的军阀
a council of mothers ¦ совет матерей ¦ ein Rat der Mütter ¦ un conseil de mères ¦ 母亲议会
whoever controls the water ¦ тот, кто распоряжается водой ¦ wer auch immer das Wasser kontrolliert ¦ celui qui contrôle l'eau ¦ 掌控水源的人
a former vault overseer with old-world manners ¦ бывший смотритель убежища с манерами старого мира ¦ ein ehemaliger Bunkeraufseher mit Manieren der alten Welt ¦ un ancien intendant d'abri aux manières de l'ancien monde ¦ 带着旧世界做派的前避难所主管
a mechanic-priest who talks to engines ¦ механик-жрец, разговаривающий с моторами ¦ ein Mechanikerpriester, der mit Motoren spricht ¦ un mécano-prêtre qui parle aux moteurs ¦ 与引擎对话的机械祭司
a vote by raised hands every morning ¦ голосование поднятием рук каждое утро ¦ eine Abstimmung per Handzeichen, jeden Morgen ¦ un vote à main levée chaque matin ¦ 每天早上举手表决
a caravan boss who owns the only road ¦ глава каравана, владеющий единственной дорогой ¦ ein Karawanenboss, dem die einzige Straße gehört ¦ un chef de caravane qui possède la seule route ¦ 占着唯一道路的商队头目
a doctor everyone owes their life to ¦ врач, которому все обязаны жизнью ¦ eine Ärztin, der alle ihr Leben verdanken ¦ une médecin à qui chacun doit la vie ¦ 人人都欠她一条命的医生
''',
  'est_type': '''
water bar ¦ водяной бар ¦ Wasserbar ¦ bar à eau ¦ 水吧
trading post ¦ фактория ¦ Handelsposten ¦ comptoir ¦ 交易站
chop shop ¦ разборка ¦ Schrottwerkstatt ¦ atelier de casse ¦ 拆车铺
fighting pit ¦ бойцовская яма ¦ Kampfgrube ¦ fosse de combat ¦ 角斗坑
bunkhouse ¦ ночлежка ¦ Schlafbaracke ¦ dortoir ¦ 大通铺
medic tent ¦ медицинская палатка ¦ Sanitätszelt ¦ tente médicale ¦ 医疗帐篷
''',
  'est_adj': '''
Rusty ¦ ржавый~ржавая ¦ Rostigen ¦ rouillé~rouillée ¦ 锈
Radiant ¦ сияющий~сияющая ¦ Strahlenden ¦ radieux~radieuse ¦ 辐光
Dusty ¦ пыльный~пыльная ¦ Staubigen ¦ poussiéreux~poussiéreuse ¦ 尘土
Thirsty ¦ жаждущий~жаждущая ¦ Durstigen ¦ assoiffé~assoiffée ¦ 渴
Two-Headed ¦ двухголовый~двухголовая ¦ Zweiköpfigen ¦ à deux têtes ¦ 双头
Burnt ¦ горелый~горелая ¦ Verbrannten ¦ brûlé~brûlée ¦ 焦
Lucky ¦ счастливый~счастливая ¦ Glücklichen ¦ chanceux~chanceuse ¦ 幸运
Broken ¦ сломанный~сломанная ¦ Kaputten ¦ cassé~cassée ¦ 破
Glowing ¦ светящийся~светящаяся ¦ Glühenden ¦ luisant~luisante ¦ 发光
Mad ¦ бешеный~бешеная ¦ Tollen ¦ enragé~enragée ¦ 疯
''',
  'est_noun': '''
Coyote ¦ койот#m ¦ Schakal#m ¦ Coyote#m ¦ 郊狼
Cockroach ¦ таракан#m ¦ Kakerlake#f ¦ Blatte#f ¦ 蟑螂
Canteen ¦ фляга#f ¦ Feldflasche#f ¦ Gourde#f ¦ 水壶
Tire ¦ покрышка#f ¦ Reifen#m ¦ Pneu#m ¦ 轮胎
Vulture ¦ стервятник#m ¦ Geier#m ¦ Vautour#m ¦ 秃鹫
Pump ¦ помпа#f ¦ Pumpe#f ¦ Pompe#f ¦ 水泵
Gecko ¦ геккон#m ¦ Gecko#m ¦ Gecko#m ¦ 壁虎
Wrench ¦ ключ#m ¦ Schraubenschlüssel#m ¦ Clé#f ¦ 扳手
Scorpion ¦ скорпион#m ¦ Skorpion#m ¦ Scorpion#m ¦ 蝎子
Bus ¦ автобус#m ¦ Bus#m ¦ Bus#m ¦ 巴士
Dune ¦ дюна#f ¦ Düne#f ¦ Dune#f ¦ 沙丘
Rat ¦ крыса#f ¦ Ratte#f ¦ Rat#m ¦ 鼠
Bottle ¦ бутылка#f ¦ Flasche#f ¦ Bouteille#f ¦ 瓶
''',
  'est_specialty': '''
clean water by the cup, no questions asked ¦ чистая вода чашками, без вопросов ¦ sauberes Wasser becherweise, ohne Fragen ¦ de l'eau propre au gobelet, sans questions ¦ 按杯卖的净水，不问来路
lizard skewers with hot sauce ¦ шашлычки из ящериц с острым соусом ¦ Echsenspieße mit scharfer Soße ¦ des brochettes de lézard sauce piquante ¦ 配辣酱的烤蜥蜴串
repairs paid in bullets ¦ ремонт за патроны ¦ Reparaturen, bezahlt in Patronen ¦ des réparations payées en balles ¦ 用子弹支付的维修
cage fights every full moon ¦ бои в клетке каждое полнолуние ¦ Käfigkämpfe bei jedem Vollmond ¦ des combats en cage à chaque pleine lune ¦ 每逢满月的笼斗
maps of safe routes, updated weekly ¦ карты безопасных маршрутов, обновляемые каждую неделю ¦ Karten sicherer Routen, wöchentlich aktualisiert ¦ des cartes de routes sûres, mises à jour chaque semaine ¦ 每周更新的安全路线图
cactus liquor that burns twice ¦ кактусовая настойка, которая жжёт дважды ¦ Kaktusschnaps, der zweimal brennt ¦ un alcool de cactus qui brûle deux fois ¦ 烧两遍喉咙的仙人掌酒
anti-radiation pills, maybe real ¦ таблетки от радиации — может быть, настоящие ¦ Strahlenschutztabletten, vielleicht echt ¦ des pilules antiradiations, peut-être vraies ¦ 抗辐射药片，也许是真的
a jukebox with three songs ¦ музыкальный автомат с тремя песнями ¦ eine Jukebox mit drei Liedern ¦ un juke-box à trois chansons ¦ 只有三首歌的点唱机
beds behind a locked steel door ¦ койки за запертой стальной дверью ¦ Betten hinter einer verschlossenen Stahltür ¦ des lits derrière une porte d'acier verrouillée ¦ 锁在钢门后的床铺
stitches and bone-setting at fair prices ¦ швы и вправление костей по честной цене ¦ Nähte und Knochenrichten zu fairen Preisen ¦ points de suture et remise d'os à prix honnête ¦ 价格公道的缝合与接骨
''',
  'est_patron': '''
a caravan master counting water jugs ¦ глава каравана, пересчитывающий кувшины с водой ¦ ein Karawanenführer, der Wasserkrüge zählt ¦ un chef de caravane qui compte ses jarres d'eau ¦ 数着水罐的商队首领
a mutant who tips generously ¦ мутант, щедро дающий на чай ¦ ein Mutant, der großzügig Trinkgeld gibt ¦ un mutant qui laisse de généreux pourboires ¦ 出手大方的变异人
a raider on truce day ¦ налётчик в день перемирия ¦ ein Plünderer am Tag des Waffenstillstands ¦ un pillard en jour de trêve ¦ 停战日来访的掠夺者
a vault dweller seeing the sky for the first time ¦ житель убежища, впервые увидевший небо ¦ ein Bunkerbewohner, der zum ersten Mal den Himmel sieht ¦ un habitant d'abri qui voit le ciel pour la première fois ¦ 第一次见到天空的避难所居民
a child selling scrap to buy medicine ¦ ребёнок, продающий хлам, чтобы купить лекарство ¦ ein Kind, das Schrott verkauft, um Medizin zu kaufen ¦ un enfant qui vend de la ferraille pour acheter des remèdes ¦ 卖废品买药的孩子
an old-world veteran with a rusty medal ¦ ветеран старого мира с ржавой медалью ¦ ein Veteran der alten Welt mit rostigem Orden ¦ un vétéran de l'ancien monde à la médaille rouillée ¦ 戴着生锈勋章的旧世界老兵
a trader with a two-headed dog ¦ торговка с двухголовой собакой ¦ eine Händlerin mit einem zweiköpfigen Hund ¦ une marchande avec un chien à deux têtes ¦ 带着双头狗的商人
a preacher who charges for blessings ¦ проповедник, берущий плату за благословения ¦ ein Prediger, der für Segen Geld nimmt ¦ un prêcheur qui fait payer ses bénédictions ¦ 为祝福收费的传道人
''',
  'hook_title': '''
Water Rights ¦ Право на воду ¦ Wasserrechte ¦ Le Droit à l'eau ¦ 水权
The Last Seed Bank ¦ Последний семенной банк ¦ Die letzte Saatgutbank ¦ La Dernière Banque de semences ¦ 最后的种子库
Convoy to Nowhere ¦ Конвой в никуда ¦ Konvoi ins Nirgendwo ¦ Convoi vers nulle part ¦ 驶向虚无的车队
The Vault Opens at Dawn ¦ Убежище открывается на рассвете ¦ Der Bunker öffnet im Morgengrauen ¦ L'Abri s'ouvre à l'aube ¦ 避难所将在黎明开启
Radio Silence ¦ Радиомолчание ¦ Funkstille ¦ Silence radio ¦ 无线电静默
Salt and Diesel ¦ Соль и солярка ¦ Salz und Diesel ¦ Sel et gazole ¦ 盐与柴油
The Green Rumor ¦ Зелёный слух ¦ Das grüne Gerücht ¦ La Rumeur verte ¦ 绿色传闻
King of the Overpass ¦ Король эстакады ¦ König der Überführung ¦ Le Roi du viaduc ¦ 高架桥之王
The Glass Desert Run ¦ Рывок через Стеклянную пустыню ¦ Die Fahrt durch die Glaswüste ¦ La Traversée du désert de verre ¦ 穿越玻璃沙漠
The Doctor's Price ¦ Цена доктора ¦ Der Preis der Ärztin ¦ Le Prix du docteur ¦ 医生的代价
''',
  'hook_who': '''
a settlement elder with a dying well ¦ старейшина поселения с пересыхающим колодцем ¦ ein Siedlungsältester mit einem versiegenden Brunnen ¦ un ancien de la colonie dont le puits se tarit ¦ 井快要干涸的定居点长老
a vault kid who walked out alone ¦ подросток из убежища, вышедший наружу в одиночку ¦ ein Bunkerkind, das allein herausgekommen ist ¦ un gamin d'abri sorti tout seul ¦ 独自走出避难所的孩子
a raider who wants to switch sides ¦ налётчик, желающий перейти на другую сторону ¦ ein Plünderer, der die Seiten wechseln will ¦ un pillard qui veut changer de camp ¦ 想要倒戈的掠夺者
a caravan master missing a wagon ¦ глава каравана, недосчитавшийся повозки ¦ ein Karawanenführer, dem ein Wagen fehlt ¦ un chef de caravane à qui il manque un chariot ¦ 少了一辆车的商队首领
a mechanic who found a plane that flies ¦ механик, нашедшая исправный самолёт ¦ eine Mechanikerin, die ein flugfähiges Flugzeug gefunden hat ¦ une mécano qui a trouvé un avion en état de voler ¦ 发现了一架能飞的飞机的机械师
a mutant mother protecting her village ¦ мать-мутантка, защищающая свою деревню ¦ eine mutierte Mutter, die ihr Dorf beschützt ¦ une mère mutante qui protège son village ¦ 守护村庄的变异人母亲
the voice on the radio ¦ голос по радио ¦ die Stimme im Radio ¦ la voix à la radio ¦ 电台里的声音
a doctor with a stolen vaccine ¦ врач с украденной вакциной ¦ eine Ärztin mit einem gestohlenen Impfstoff ¦ une médecin avec un vaccin volé ¦ 带着偷来疫苗的医生
twin scavengers with half a map each ¦ близнецы-мусорщики, у каждого по половине карты ¦ Schrottsammler-Zwillinge mit je einer halben Karte ¦ des jumeaux récupérateurs avec chacun une moitié de carte ¦ 各拿半张地图的双胞胎拾荒者
an old man who remembers rain ¦ старик, который помнит дождь ¦ ein alter Mann, der sich an Regen erinnert ¦ un vieil homme qui se souvient de la pluie ¦ 还记得下雨是什么样的老人
''',
  'hook_wants': '''
escort a water tanker across raider country ¦ провести водовоз через земли налётчиков ¦ einen Wassertanker durch Plündererland eskortieren ¦ escorter un camion-citerne d'eau à travers le pays des pillards ¦ 护送一辆水罐车穿越掠夺者地盘
find the source of the radio signal ¦ найти источник радиосигнала ¦ die Quelle des Funksignals finden ¦ trouver la source du signal radio ¦ 找到无线电信号的源头
recover the stolen seed stock ¦ вернуть украденный семенной фонд ¦ das gestohlene Saatgut zurückholen ¦ récupérer la réserve de semences volée ¦ 夺回被盗的种子储备
negotiate peace between two settlements ¦ заключить мир между двумя поселениями ¦ Frieden zwischen zwei Siedlungen aushandeln ¦ négocier la paix entre deux colonies ¦ 促成两个定居点之间的和平
open a sealed vault ¦ открыть запечатанное убежище ¦ einen versiegelten Bunker öffnen ¦ ouvrir un abri scellé ¦ 打开一座封闭的避难所
hunt the beast that drags off livestock ¦ выследить зверя, утаскивающего скот ¦ die Bestie jagen, die das Vieh verschleppt ¦ traquer la bête qui emporte le bétail ¦ 猎杀那头拖走牲畜的野兽
salvage a working reactor core ¦ добыть исправное ядро реактора ¦ einen funktionierenden Reaktorkern bergen ¦ récupérer un cœur de réacteur en état de marche ¦ 打捞一个还能用的反应堆核心
bring a doctor back from the city-state ¦ привезти врача из города-государства ¦ eine Ärztin aus dem Stadtstaat zurückbringen ¦ ramener une médecin de la cité-État ¦ 从城邦请回一位医生
win the great race across the salt flats ¦ выиграть большую гонку через солончаки ¦ das große Rennen über die Salzebene gewinnen ¦ gagner la grande course à travers les salines ¦ 赢得横穿盐滩的大赛
deliver a sealed message to the warlord ¦ доставить запечатанное послание полевому командиру ¦ dem Kriegsherrn eine versiegelte Botschaft überbringen ¦ remettre un message scellé au seigneur de guerre ¦ 把一封密封的信交给军阀
''',
  'hook_obstacle': '''
a radiation storm is rolling in ¦ надвигается радиационная буря ¦ ein Strahlungssturm zieht auf ¦ une tempête radioactive approche ¦ 一场辐射风暴正在逼近
the only road runs through a raider camp ¦ единственная дорога проходит через лагерь налётчиков ¦ die einzige Straße führt durch ein Plündererlager ¦ la seule route traverse un camp de pillards ¦ 唯一的路穿过掠夺者营地
the truck has fuel for half the distance ¦ топлива в грузовике хватит на полпути ¦ der Laster hat Treibstoff für die halbe Strecke ¦ le camion n'a du carburant que pour la moitié du trajet ¦ 卡车的燃料只够跑一半路程
the vault's defenses are still active ¦ защита убежища всё ещё работает ¦ die Abwehranlagen des Bunkers sind noch aktiv ¦ les défenses de l'abri sont toujours actives ¦ 避难所的防御系统仍在运作
the guide is going blind from the sun ¦ проводник слепнет от солнца ¦ der Führer erblindet an der Sonne ¦ le guide devient aveugle à cause du soleil ¦ 向导的眼睛快被太阳晒瞎了
the settlement will not trust outsiders ¦ поселение не доверяет чужакам ¦ die Siedlung traut keinen Fremden ¦ la colonie ne fait pas confiance aux étrangers ¦ 定居点不信任外人
the bridge collapsed last winter ¦ мост обрушился прошлой зимой ¦ die Brücke ist letzten Winter eingestürzt ¦ le pont s'est effondré l'hiver dernier ¦ 桥在去年冬天塌了
a cult of the old machines guards the target ¦ цель охраняет культ старых машин ¦ ein Kult der alten Maschinen schützt das Ziel ¦ un culte des vieilles machines protège la cible ¦ 目标受到一个崇拜旧机器的邪教保护
there is water for only three days ¦ воды осталось на три дня ¦ es gibt nur Wasser für drei Tage ¦ il n'y a de l'eau que pour trois jours ¦ 水只够喝三天
the plague has closed the trade routes ¦ чума закрыла торговые пути ¦ die Seuche hat die Handelswege geschlossen ¦ la peste a fermé les routes commerciales ¦ 瘟疫封锁了商路
''',
  'hook_twist': '''
the raiders are starving refugees ¦ налётчики — голодающие беженцы ¦ die Plünderer sind hungernde Flüchtlinge ¦ les pillards sont des réfugiés affamés ¦ 掠夺者其实是饥饿的难民
the vault is full of people still asleep ¦ убежище полно всё ещё спящих людей ¦ der Bunker ist voller noch schlafender Menschen ¦ l'abri est plein de gens encore endormis ¦ 避难所里满是仍在沉睡的人
the radio voice is an old recording ¦ голос по радио — старая запись ¦ die Stimme im Radio ist eine alte Aufnahme ¦ la voix à la radio est un vieil enregistrement ¦ 电台里的声音只是一段旧录音
the water is what made the mutants ¦ именно вода породила мутантов ¦ das Wasser hat die Mutanten erst erschaffen ¦ c'est l'eau qui a créé les mutants ¦ 正是这水造就了变异人
the patron plans to sell the settlement ¦ заказчик собирается продать поселение ¦ der Auftraggeber will die Siedlung verkaufen ¦ le commanditaire compte vendre la colonie ¦ 委托人打算把定居点卖掉
the green valley is real, and defended ¦ зелёная долина существует — и её охраняют ¦ das grüne Tal ist real – und wird verteidigt ¦ la vallée verte existe, et elle est défendue ¦ 绿色山谷是真的，而且有人守卫
the warlord is the settlement leader's brother ¦ полевой командир — брат главы поселения ¦ der Kriegsherr ist der Bruder der Siedlungsleiterin ¦ le seigneur de guerre est le frère de la cheffe de la colonie ¦ 军阀是定居点首领的兄弟
the old world is not entirely gone ¦ старый мир ушёл не совсем ¦ die alte Welt ist nicht ganz verschwunden ¦ l'ancien monde n'a pas tout à fait disparu ¦ 旧世界并未完全消失
the vaccine only works on the vault-born ¦ вакцина действует только на рождённых в убежищах ¦ der Impfstoff wirkt nur bei Bunkergeborenen ¦ le vaccin ne fonctionne que sur les enfants des abris ¦ 疫苗只对避难所出生的人有效
the beast is guarding its young ¦ зверь охраняет детёнышей ¦ die Bestie bewacht ihre Jungen ¦ la bête protège ses petits ¦ 那头野兽在守护它的幼崽
''',
  'loot_container': '''
Scavenger's shopping cart ¦ Тележка мусорщика ¦ Einkaufswagen eines Schrottsammlers ¦ Caddie de récupérateur ¦ 拾荒者的购物车
Raider's saddlebags ¦ Седельные сумки налётчика ¦ Satteltaschen eines Plünderers ¦ Sacoches de pillard ¦ 掠夺者的鞍袋
Rusted vault locker ¦ Ржавый шкафчик из убежища ¦ Verrosteter Bunkerspind ¦ Casier d'abri rouillé ¦ 生锈的避难所储物柜
Overturned supply truck ¦ Перевёрнутый грузовик с припасами ¦ Umgestürzter Versorgungslaster ¦ Camion de ravitaillement renversé ¦ 翻倒的补给卡车
Dead courier's backpack ¦ Рюкзак мёртвого курьера ¦ Rucksack eines toten Kuriers ¦ Sac à dos d'un coursier mort ¦ 死去信使的背包
Cache buried under a road sign ¦ Тайник, зарытый под дорожным знаком ¦ Vergrabenes Versteck unter einem Straßenschild ¦ Cache enterrée sous un panneau ¦ 埋在路牌下的藏匿点
Old-world bank safe ¦ Банковский сейф старого мира ¦ Banksafe der alten Welt ¦ Coffre de banque de l'ancien monde ¦ 旧世界的银行保险箱
Cult offering pile ¦ Груда подношений культа ¦ Opferhaufen eines Kults ¦ Tas d'offrandes d'un culte ¦ 邪教的供品堆
''',
  'loot_coin': '''
{#3d6*5} bottle caps ¦ бутылочные крышки: {#3d6*5} ¦ {#3d6*5} Kronkorken ¦ {#3d6*5} capsules ¦ {#3d6*5}枚瓶盖
{#2d6*10} rounds of ammunition, the real currency ¦ патроны — настоящая валюта: {#2d6*10} ¦ {#2d6*10} Schuss Munition, die wahre Währung ¦ {#2d6*10} cartouches, la vraie monnaie ¦ {#2d6*10}发子弹——真正的硬通货
{#1d4+1} jerry cans of fuel ¦ канистры с топливом: {#1d4+1} ¦ {#1d4+1} Kanister Treibstoff ¦ {#1d4+1} jerricans de carburant ¦ {#1d4+1}桶燃料
water chits for {#2d6*5} liters ¦ водяные талоны на {#2d6*5} литров ¦ Wassermarken für {#2d6*5} Liter ¦ des bons d'eau pour {#2d6*5} litres ¦ 可兑换{#2d6*5}升水的水票
''',
  'loot_item': '''
bottles of purified water ×{#1d4+1} ¦ бутылки очищенной воды ×{#1d4+1} ¦ Flaschen gereinigtes Wasser ×{#1d4+1} ¦ bouteilles d'eau purifiée ×{#1d4+1} ¦ 净化水 ×{#1d4+1}
a sawed-off shotgun wrapped in tape ¦ обрез, обмотанный изолентой ¦ eine mit Klebeband umwickelte abgesägte Schrotflinte ¦ un fusil à canon scié entouré de ruban adhésif ¦ 缠着胶带的短管霰弹枪
rad pills ×{#1d6+1} ¦ таблетки от радиации ×{#1d6+1} ¦ Strahlentabletten ×{#1d6+1} ¦ pilules antiradiations ×{#1d6+1} ¦ 抗辐射药 ×{#1d6+1}
a working Geiger counter ¦ исправный счётчик Гейгера ¦ ein funktionierender Geigerzähler ¦ un compteur Geiger qui fonctionne ¦ 一台能用的盖革计数器
cans of peaches ×{#2d4} ¦ консервированные персики ×{#2d4} ¦ Dosenpfirsiche ×{#2d4} ¦ conserves de pêches ×{#2d4} ¦ 黄桃罐头 ×{#2d4}
a solar panel with only one crack ¦ солнечная панель всего с одной трещиной ¦ ein Solarpanel mit nur einem Riss ¦ un panneau solaire avec une seule fissure ¦ 只有一道裂纹的太阳能板
spark plugs ×{#1d6+1} ¦ свечи зажигания ×{#1d6+1} ¦ Zündkerzen ×{#1d6+1} ¦ bougies d'allumage ×{#1d6+1} ¦ 火花塞 ×{#1d6+1}
a machete sharpened on a curb ¦ мачете, заточенное о бордюр ¦ eine an der Bordsteinkante geschärfte Machete ¦ une machette aiguisée sur un trottoir ¦ 在路沿上磨利的砍刀
sealed antibiotics ×{#1d3+1} ¦ запечатанные антибиотики ×{#1d3+1} ¦ versiegelte Antibiotika ×{#1d3+1} ¦ antibiotiques encore scellés ×{#1d3+1} ¦ 未开封的抗生素 ×{#1d3+1}
a gas mask with fresh filters ¦ противогаз со свежими фильтрами ¦ eine Gasmaske mit frischen Filtern ¦ un masque à gaz aux filtres neufs ¦ 装着新滤罐的防毒面具
a hand-crank radio ¦ радиоприёмник с ручной динамо-машиной ¦ ein Kurbelradio ¦ une radio à manivelle ¦ 手摇收音机
packets of old-world vegetable seeds ×{#1d6+1} ¦ пакетики семян овощей старого мира ×{#1d6+1} ¦ Samentütchen mit Gemüse der alten Welt ×{#1d6+1} ¦ sachets de graines de légumes de l'ancien monde ×{#1d6+1} ¦ 旧世界蔬菜种子包 ×{#1d6+1}
a crossbow made from car springs ¦ арбалет из автомобильных рессор ¦ eine Armbrust aus Autofedern ¦ une arbalète faite de ressorts de voiture ¦ 用汽车弹簧做的弩
cans of motor oil ×{#1d4+1} ¦ банки моторного масла ×{#1d4+1} ¦ Dosen Motoröl ×{#1d4+1} ¦ bidons d'huile moteur ×{#1d4+1} ¦ 机油罐 ×{#1d4+1}
a leather duster lined with kevlar ¦ кожаный плащ с кевларовой подкладкой ¦ ein Ledermantel mit Kevlarfutter ¦ un cache-poussière en cuir doublé de kevlar ¦ 衬着凯夫拉的皮风衣
binoculars with one working side ¦ бинокль, в котором цел только один окуляр ¦ ein Fernglas, bei dem nur eine Seite funktioniert ¦ des jumelles dont un seul oculaire marche ¦ 只有一边能用的望远镜
''',
  'loot_curio': '''
a snow globe of a city that no longer exists ¦ снежный шар с городом, которого больше нет ¦ eine Schneekugel mit einer Stadt, die es nicht mehr gibt ¦ une boule à neige d'une ville qui n'existe plus ¦ 一座已不复存在的城市的水晶球
a vinyl record in perfect condition ¦ виниловая пластинка в идеальном состоянии ¦ eine Schallplatte in perfektem Zustand ¦ un vinyle en parfait état ¦ 品相完美的黑胶唱片
a photograph of green fields ¦ фотография зелёных полей ¦ ein Foto grüner Felder ¦ une photo de champs verdoyants ¦ 一张绿色田野的照片
a keycard to a vault no one has found ¦ ключ-карта от убежища, которое никто не нашёл ¦ eine Schlüsselkarte zu einem Bunker, den niemand gefunden hat ¦ un badge d'un abri que personne n'a trouvé ¦ 一座无人找到的避难所的门禁卡
a child's lunchbox with a letter inside ¦ детский ланчбокс с письмом внутри ¦ eine Kinderbrotdose mit einem Brief darin ¦ une boîte à goûter d'enfant contenant une lettre ¦ 装着一封信的儿童饭盒
a working wristwatch ¦ исправные наручные часы ¦ eine funktionierende Armbanduhr ¦ une montre-bracelet qui marche ¦ 一块还在走的手表
a jar of real honey ¦ банка настоящего мёда ¦ ein Glas echter Honig ¦ un pot de vrai miel ¦ 一罐真正的蜂蜜
a comic book missing its last page ¦ комикс без последней страницы ¦ ein Comic ohne letzte Seite ¦ une bande dessinée sans sa dernière page ¦ 缺了最后一页的漫画书
''',
  'faction_noun': '''
@Tribe Clan ¦ Клан ¦ Clan ¦ Clan ¦ 部族
@Other Convoy ¦ Конвой ¦ Konvoi ¦ Convoi ¦ 车队
@Cult Church ¦ Церковь ¦ Kirche ¦ Église ¦ 教会
@Kingdom Republic ¦ Республика ¦ Republik ¦ République ¦ 共和国
@Guild Traders ¦ Торговцы ¦ Händlerbund ¦ Marchands ¦ 商会
@Tribe Horde ¦ Орда ¦ Horde ¦ Horde ¦ 部落
@Order Rangers ¦ Рейнджеры ¦ Ranger ¦ Rangers ¦ 游骑兵
@Family Family ¦ Семья ¦ Familie ¦ Famille ¦ 家族
''',
  'faction_of': '''
of the Last Well ¦ Последнего Колодца ¦ des Letzten Brunnens ¦ du Dernier Puits ¦ 末井
of the Burning Road ¦ Горящей Дороги ¦ der Brennenden Straße ¦ de la Route brûlante ¦ 燃路
of the Rusted Crown ¦ Ржавой Короны ¦ der Rostigen Krone ¦ de la Couronne rouillée ¦ 锈冠
of the Glass Desert ¦ Стеклянной Пустыни ¦ der Glaswüste ¦ du Désert de verre ¦ 玻璃沙漠
of the Seventh Silo ¦ Седьмого Элеватора ¦ des Siebten Silos ¦ du Septième Silo ¦ 第七粮仓
of the Broken Dam ¦ Разрушенной Плотины ¦ des Gebrochenen Damms ¦ du Barrage brisé ¦ 断坝
of the Green Promise ¦ Зелёного Обета ¦ des Grünen Versprechens ¦ de la Promesse verte ¦ 绿誓
of the Dust ¦ Пыли ¦ des Staubes ¦ de la Poussière ¦ 尘土
of the Iron Sun ¦ Железного Солнца ¦ der Eisernen Sonne ¦ du Soleil de fer ¦ 铁日
of the Open Sky ¦ Открытого Неба ¦ des Offenen Himmels ¦ du Ciel ouvert ¦ 开阔天空
''',
  'faction_goal': '''
control every source of clean water ¦ контролировать все источники чистой воды ¦ jede Quelle sauberen Wassers kontrollieren ¦ contrôler chaque source d'eau propre ¦ 控制所有干净水源
rebuild the old government ¦ восстановить старое правительство ¦ die alte Regierung wiederaufbauen ¦ rebâtir l'ancien gouvernement ¦ 重建旧政府
be the first to reach the fabled green valley ¦ первыми добраться до легендарной зелёной долины ¦ als Erste das sagenhafte grüne Tal erreichen ¦ atteindre la première la vallée verte légendaire ¦ 率先抵达传说中的绿色山谷
restart the reactor at the dam ¦ перезапустить реактор на плотине ¦ den Reaktor am Damm wieder anfahren ¦ redémarrer le réacteur du barrage ¦ 重启大坝的反应堆
drive every mutant out of the region ¦ изгнать из края всех мутантов ¦ alle Mutanten aus der Region vertreiben ¦ chasser tous les mutants de la région ¦ 把所有变异人清出这片区域
keep the old roads open for trade ¦ держать старые дороги открытыми для торговли ¦ die alten Straßen für den Handel offen halten ¦ garder les vieilles routes ouvertes au commerce ¦ 保持旧道路通商畅通
open every sealed vault ¦ открыть все запечатанные убежища ¦ jeden versiegelten Bunker öffnen ¦ ouvrir tous les abris scellés ¦ 打开所有封闭的避难所
preserve the knowledge of the old world ¦ сохранить знания старого мира ¦ das Wissen der alten Welt bewahren ¦ préserver le savoir de l'ancien monde ¦ 保存旧世界的知识
''',
  'faction_method': '''
water rationing as a weapon ¦ водные пайки как оружие ¦ Wasserrationierung als Waffe ¦ le rationnement de l'eau comme arme ¦ 以配水为武器
armored convoys and toll gates ¦ бронированные конвои и заставы ¦ gepanzerte Konvois und Zollschranken ¦ convois blindés et barrières de péage ¦ 装甲车队与收费关卡
radio sermons every night ¦ радиопроповеди каждую ночь ¦ Radiopredigten jede Nacht ¦ des sermons radio chaque nuit ¦ 每晚的电台布道
trading medicine for loyalty ¦ лекарства в обмен на верность ¦ Medizin gegen Loyalität ¦ échanger des remèdes contre la loyauté ¦ 用药品换取忠诚
raids at dawn ¦ налёты на рассвете ¦ Überfälle im Morgengrauen ¦ des raids à l'aube ¦ 黎明突袭
marriages between settlements ¦ браки между поселениями ¦ Heiraten zwischen Siedlungen ¦ des mariages entre colonies ¦ 定居点之间的联姻
old-world weapons they barely understand ¦ оружие старого мира, которое они едва понимают ¦ Waffen der alten Welt, die sie kaum verstehen ¦ des armes de l'ancien monde qu'ils comprennent à peine ¦ 他们几乎弄不懂的旧世界武器
teaching children to read ¦ обучение детей грамоте ¦ Kindern das Lesen beibringen ¦ apprendre à lire aux enfants ¦ 教孩子们识字
''',
  'faction_symbol': '''
a steering wheel with a skull ¦ руль с черепом ¦ ein Lenkrad mit Totenkopf ¦ un volant orné d'un crâne ¦ 带骷髅的方向盘
a green sprout in a cracked helmet ¦ зелёный росток в треснувшей каске ¦ ein grüner Spross in einem gesprungenen Helm ¦ une pousse verte dans un casque fendu ¦ 裂开头盔里的一株绿芽
a drop of water inside a gear ¦ капля воды внутри шестерни ¦ ein Wassertropfen in einem Zahnrad ¦ une goutte d'eau dans un engrenage ¦ 齿轮中的一滴水
a crossed-out radiation symbol ¦ перечёркнутый знак радиации ¦ ein durchgestrichenes Strahlenzeichen ¦ un symbole de radiation barré ¦ 被划掉的辐射标志
a crown of bottle caps ¦ корона из бутылочных крышек ¦ eine Krone aus Kronkorken ¦ une couronne de capsules ¦ 瓶盖王冠
a burning tire ¦ горящая покрышка ¦ ein brennender Reifen ¦ un pneu en flammes ¦ 燃烧的轮胎
an open book with a key ¦ раскрытая книга с ключом ¦ ein offenes Buch mit einem Schlüssel ¦ un livre ouvert avec une clé ¦ 放着钥匙的打开的书
a two-headed eagle made of scrap ¦ двуглавый орёл из металлолома ¦ ein doppelköpfiger Adler aus Schrott ¦ un aigle bicéphale fait de ferraille ¦ 废铁拼成的双头鹰
''',
  'weather_sky': '''
a copper-colored sky without a cloud ¦ небо медного цвета без единого облака ¦ ein kupferfarbener Himmel ohne eine Wolke ¦ un ciel cuivré sans un nuage ¦ 铜色的天空，万里无云
a radiation storm glows green on the horizon ¦ на горизонте зеленеет радиационная буря ¦ ein Strahlungssturm leuchtet grün am Horizont ¦ une tempête radioactive luit en vert à l'horizon ¦ 辐射风暴在地平线上泛着绿光
acid drizzle pits the metal roofs ¦ кислотная морось разъедает металлические крыши ¦ saurer Nieselregen zerfrisst die Blechdächer ¦ une bruine acide ronge les toits en tôle ¦ 酸性毛毛雨腐蚀着铁皮屋顶
a wall of dust rises in the west ¦ на западе поднимается стена пыли ¦ im Westen erhebt sich eine Staubwand ¦ un mur de poussière se lève à l'ouest ¦ 西边升起一堵沙尘墙
a blood-orange sunset glows through the smog ¦ кроваво-оранжевый закат пробивается сквозь смог ¦ ein blutorangener Sonnenuntergang glüht durch den Smog ¦ un couchant orange sang luit à travers le smog ¦ 透过烟霾的血橙色落日
rare rain, and everyone runs outside with buckets ¦ редкий дождь — и все выбегают с вёдрами ¦ seltener Regen, und alle rennen mit Eimern hinaus ¦ une pluie rare, et tout le monde sort avec des seaux ¦ 难得下雨，所有人都提着桶冲出门
a pale sun behind an ash-grey haze ¦ бледное солнце за пепельной дымкой ¦ eine blasse Sonne hinter aschgrauem Dunst ¦ un soleil pâle derrière une brume couleur de cendre ¦ 灰烬般的薄雾后面挂着苍白的太阳
stars so bright the night is never dark ¦ звёзды так ярки, что ночь не бывает тёмной ¦ Sterne so hell, dass die Nacht nie dunkel wird ¦ des étoiles si vives que la nuit n'est jamais noire ¦ 星星亮得让夜晚从不黑暗
''',
  'weather_air': '''
the heat makes the road shimmer like water ¦ от жары дорога мерцает, как вода ¦ die Hitze lässt die Straße wie Wasser flimmern ¦ la chaleur fait miroiter la route comme de l'eau ¦ 热浪让路面像水一样闪烁
the wind carries grit that stings the eyes ¦ ветер несёт песок, режущий глаза ¦ der Wind trägt Sand, der in den Augen brennt ¦ le vent charrie du sable qui pique les yeux ¦ 风卷着沙砾，刺得眼睛生疼
the Geiger counters tick a little faster today ¦ счётчики Гейгера сегодня трещат чуть чаще ¦ die Geigerzähler ticken heute etwas schneller ¦ les compteurs Geiger crépitent un peu plus vite aujourd'hui ¦ 盖革计数器今天响得快了一点
a bitter cold settles after sunset ¦ после заката опускается злой холод ¦ nach Sonnenuntergang legt sich bittere Kälte über das Land ¦ un froid mordant s'installe après le coucher du soleil ¦ 日落后刺骨的寒冷降临
the air smells of burnt rubber ¦ воздух пахнет горелой резиной ¦ die Luft riecht nach verbranntem Gummi ¦ l'air sent le caoutchouc brûlé ¦ 空气里是烧焦橡胶的味道
dry lightning cracks without a drop of rain ¦ сухие молнии бьют без единой капли дождя ¦ trockene Blitze zucken ohne einen Tropfen Regen ¦ des éclairs secs frappent sans une goutte de pluie ¦ 干雷劈下，却不见一滴雨
the dead highway lies in total silence ¦ мёртвая трасса погружена в полную тишину ¦ auf der toten Autobahn herrscht völlige Stille ¦ l'autoroute morte baigne dans un silence total ¦ 死寂的公路上鸦雀无声
a warm wind brings the smell of distant fires ¦ тёплый ветер приносит запах далёких пожаров ¦ ein warmer Wind bringt den Geruch ferner Feuer ¦ un vent chaud apporte l'odeur de feux lointains ¦ 暖风送来远处火灾的气味
''',
  'weather_omen': '''
a flock of birds flies over, the first in years ¦ пролетает стая птиц — первая за много лет ¦ ein Vogelschwarm fliegt vorüber, der erste seit Jahren ¦ une volée d'oiseaux passe, la première depuis des années ¦ 一群鸟飞过，多年来第一次
an old car alarm starts wailing by itself ¦ старая автосигнализация начинает выть сама по себе ¦ eine alte Autoalarmanlage heult von selbst los ¦ une vieille alarme de voiture se met à hurler toute seule ¦ 一辆旧车的警报器自己响了起来
the radio plays a song nobody has heard ¦ радио играет песню, которую никто не слышал ¦ das Radio spielt ein Lied, das niemand kennt ¦ la radio joue une chanson que personne n'a entendue ¦ 电台播放着一首没人听过的歌
a green shoot appears in the ash ¦ в пепле пробивается зелёный росток ¦ ein grüner Trieb erscheint in der Asche ¦ une pousse verte apparaît dans la cendre ¦ 灰烬中冒出了一株绿芽
the dogs all howl toward the dead city ¦ все собаки воют в сторону мёртвого города ¦ alle Hunde heulen zur toten Stadt hin ¦ tous les chiens hurlent vers la ville morte ¦ 所有的狗都朝着死城嚎叫
a satellite streaks across the sky and falls ¦ спутник прочерчивает небо и падает ¦ ein Satellit zieht über den Himmel und stürzt ab ¦ un satellite traverse le ciel et tombe ¦ 一颗卫星划过天空坠落
the streetlights of a ruined town flicker on ¦ в разрушенном городе мигают и загораются фонари ¦ die Straßenlaternen einer Ruinenstadt flackern auf ¦ les réverbères d'une ville en ruine s'allument en clignotant ¦ 废弃小镇的路灯闪烁着亮了起来
the well water tastes sweet for one day ¦ вода в колодце один день кажется сладкой ¦ das Brunnenwasser schmeckt einen Tag lang süß ¦ l'eau du puits a un goût sucré pendant un jour ¦ 井水有一天尝起来是甜的
''',
  'rumor_source': '''
a caravan driver at the water bar ¦ водитель каравана в водяном баре ¦ ein Karawanenfahrer in der Wasserbar ¦ un conducteur de caravane au bar à eau ¦ 水吧里的商队司机
a message scratched on a road sign ¦ послание, нацарапанное на дорожном знаке ¦ eine in ein Straßenschild geritzte Nachricht ¦ un message gravé sur un panneau routier ¦ 刻在路牌上的留言
the settlement's radio operator ¦ радист поселения ¦ die Funkerin der Siedlung ¦ l'opérateur radio de la colonie ¦ 定居点的无线电员
a captured raider ¦ пленный налётчик ¦ ein gefangener Plünderer ¦ un pillard capturé ¦ 被俘的掠夺者
a mutant hermit ¦ отшельник-мутант ¦ ein mutierter Einsiedler ¦ un ermite mutant ¦ 变异隐士
children playing at war ¦ дети, играющие в войну ¦ Kinder, die Krieg spielen ¦ des enfants qui jouent à la guerre ¦ 玩打仗游戏的孩子们
a note in a bottle ¦ записка в бутылке ¦ ein Zettel in einer Flaschenpost ¦ un mot dans une bouteille ¦ 漂流瓶里的字条
an old-world billboard, freshly painted over ¦ рекламный щит старого мира, недавно перекрашенный ¦ eine Reklametafel der alten Welt, frisch übermalt ¦ un panneau de l'ancien monde, fraîchement repeint ¦ 刚被重新涂写的旧世界广告牌
''',
  'rumor_text': '''
there is a city in the north where the lights still work ¦ на севере есть город, где до сих пор горит свет ¦ im Norden gibt es eine Stadt, in der noch Licht brennt ¦ il y a une ville au nord où l'électricité marche encore ¦ 北方有座城市，灯还亮着
the warlord's tank is out of fuel ¦ у танка полевого командира кончилось топливо ¦ dem Panzer des Kriegsherrn ist der Treibstoff ausgegangen ¦ le tank du seigneur de guerre n'a plus de carburant ¦ 军阀的坦克没油了
someone is poisoning wells along the old highway ¦ кто-то травит колодцы вдоль старой трассы ¦ jemand vergiftet Brunnen entlang der alten Autobahn ¦ quelqu'un empoisonne les puits le long de la vieille autoroute ¦ 有人在旧公路沿线的井里下毒
a vault opened and everyone inside was still young ¦ одно убежище открылось — и все внутри были всё ещё молоды ¦ ein Bunker öffnete sich, und alle darin waren noch jung ¦ un abri s'est ouvert, et tous ceux à l'intérieur étaient encore jeunes ¦ 一座避难所打开了，里面的人都还年轻
a jet fighter lies buried under the salt flats ¦ под солончаками погребён истребитель ¦ unter der Salzebene liegt ein vergrabener Kampfjet ¦ un avion de chasse est enterré sous les salines ¦ 盐滩下埋着一架战斗机
mutants can smell water through rock ¦ мутанты чуют воду сквозь камень ¦ Mutanten riechen Wasser durch Fels ¦ les mutants sentent l'eau à travers la roche ¦ 变异人隔着岩石也能闻到水
the Rangers are recruiting again ¦ рейнджеры снова набирают людей ¦ die Ranger werben wieder an ¦ les Rangers recrutent de nouveau ¦ 游骑兵又开始招人了
a trader sells real coffee for a fortune ¦ торговец продаёт настоящий кофе за целое состояние ¦ ein Händler verkauft echten Kaffee für ein Vermögen ¦ un marchand vend du vrai café à prix d'or ¦ 有个商人在高价兜售真正的咖啡
the dam holds back a lake of clean water ¦ плотина сдерживает озеро чистой воды ¦ der Damm hält einen See sauberen Wassers zurück ¦ le barrage retient un lac d'eau propre ¦ 大坝后面蓄着一湖净水
the plague started in the city-state's labs ¦ чума началась в лабораториях города-государства ¦ die Seuche begann in den Laboren des Stadtstaats ¦ la peste a commencé dans les laboratoires de la cité-État ¦ 瘟疫始于城邦的实验室
''',
};

const _perLang = <String, Map<String, String>>{
  'en': {
    'settle_name': '{settle_pre}{settle_suf}',
    'settle_pre': '''
Rust
Dust
Scrap
Dry
Salt
Ash
Bone
Tin
Glass
Rad
''',
    'settle_suf': '''
town
water
gulch
creek
flats
yard
hole
stop
''',
  },
  'ru': {
    'settle_name': '{settle_suf} «{settle_pre}»',
    'settle_pre': '''
Ржавчина
Пыль
Хлам
Соль
Пепел
Кость
Жесть
Стекло
Сушь
Колонка
''',
    'settle_suf': '''
Посёлок
Лагерь
Стоянка
Форт
Застава
''',
  },
  'de': {
    'settle_name': '{settle_pre}{settle_suf}',
    'settle_pre': '''
Rost
Staub
Schrott
Dürr
Salz
Asche
Knochen
Blech
Glas
Strahl
''',
    'settle_suf': '''
stadt
wasser
schlucht
bach
ebene
hof
loch
halt
''',
  },
  'fr': {
    'settle_name': '{settle_suf}-{settle_pre}',
    'settle_pre': '''
Rouille
Poussière
Ferraille
Sel
Cendre
Os
Tôle
Verre
Soif
''',
    'settle_suf': '''
Camp
Fort
Puits
Relais
Halte
Bourg
''',
  },
  'zh': {
    'settle_name': '{settle_pre}{settle_suf}',
    'settle_pre': '''
锈
尘
废铁
旱
盐
灰
骨
铁皮
玻璃
辐射
''',
    'settle_suf': '''
镇
水
沟
溪
滩
场
坑
站
''',
  },
};
