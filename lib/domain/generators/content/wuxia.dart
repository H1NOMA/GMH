import '../content_format.dart';

/// Sects, sworn brothers, stolen manuals and the rivers-and-lakes.
///
/// Name parts are `pinyin ¦ Palladius Cyrillic ¦ characters`, so en/de/fr
/// read pinyin, ru reads Palladius and zh reads the real characters.
final wuxiaContent =
    PackContent.build(rows: _rows, names: _names, perLang: _perLang);

const _names = <String, String>{
  'jianghu_family': '''
Li ¦ Ли ¦ 李
Wang ¦ Ван ¦ 王
Zhang ¦ Чжан ¦ 张
Liu ¦ Лю ¦ 刘
Chen ¦ Чэнь ¦ 陈
Yang ¦ Ян ¦ 杨
Zhao ¦ Чжао ¦ 赵
Huang ¦ Хуан ¦ 黄
Zhou ¦ Чжоу ¦ 周
Wu ¦ У ¦ 吴
Xu ¦ Сюй ¦ 徐
Sun ¦ Сунь ¦ 孙
Lin ¦ Линь ¦ 林
Xiao ¦ Сяо ¦ 萧
Ye ¦ Е ¦ 叶
Su ¦ Су ¦ 苏
Shen ¦ Шэнь ¦ 沈
Han ¦ Хань ¦ 韩
Murong ¦ Мужун ¦ 慕容
Ouyang ¦ Оуян ¦ 欧阳
Shangguan ¦ Шангуань ¦ 上官
Sima ¦ Сыма ¦ 司马
Dugu ¦ Дугу ¦ 独孤
Zhuge ¦ Чжугэ ¦ 诸葛
''',
  'jianghu_given_f': '''
{jh_fa}{jh_fb}
{jh_fa}
''',
  'jianghu_given_m': '''
{jh_ma}{jh_mb}
{jh_ma}
''',
  'jh_fa': '''
Yun ¦ Юнь ¦ 云
Xue ¦ Сюэ ¦ 雪
Yue ¦ Юэ ¦ 月
Lan ¦ Лань ¦ 兰
Wan ¦ Вань ¦ 婉
Yan ¦ Янь ¦ 燕
Lian ¦ Лянь ¦ 莲
Yao ¦ Яо ¦ 瑶
Ling ¦ Лин ¦ 灵
Su ¦ Су ¦ 素
Qiu ¦ Цю ¦ 秋
Shuang ¦ Шуан ¦ 霜
''',
  'jh_fb': '''
qing ¦ цин ¦ 青
yi ¦ и ¦ 依
ning ¦ нин ¦ 宁
rong ¦ жун ¦ 蓉
xia ¦ ся ¦ 霞
ping ¦ пин ¦ 萍
zhi ¦ чжи ¦ 芷
yu ¦ юй ¦ 玉
mei ¦ мэй ¦ 梅
jun ¦ цзюнь ¦ 君
xin ¦ синь ¦ 心
luo ¦ ло ¦ 洛
''',
  'jh_ma': '''
Tian ¦ Тянь ¦ 天
Long ¦ Лун ¦ 龙
Jian ¦ Цзянь ¦ 剑
Feng ¦ Фэн ¦ 风
Hu ¦ Ху ¦ 虎
Xiao ¦ Сяо ¦ 啸
Hao ¦ Хао ¦ 豪
Chen ¦ Чэнь ¦ 辰
Zhan ¦ Чжань ¦ 展
Ting ¦ Тин ¦ 霆
Yuan ¦ Юань ¦ 渊
Kai ¦ Кай ¦ 凯
''',
  'jh_mb': '''
fei ¦ фэй ¦ 飞
yang ¦ ян ¦ 扬
kun ¦ кунь ¦ 坤
xing ¦ син ¦ 行
hong ¦ хун ¦ 鸿
ming ¦ мин ¦ 明
zhi ¦ чжи ¦ 志
lin ¦ линь ¦ 麟
chuan ¦ чуань ¦ 川
tao ¦ тао ¦ 涛
yu ¦ юй ¦ 宇
sheng ¦ шэн ¦ 胜
''',
  'jh_c1': '''
Zi ¦ Цзы ¦ 子
Bo ¦ Бо ¦ 伯
Zhong ¦ Чжун ¦ 仲
Shu ¦ Шу ¦ 叔
Ji ¦ Цзи ¦ 季
Yuan ¦ Юань ¦ 元
Wen ¦ Вэнь ¦ 文
Gong ¦ Гун ¦ 公
''',
  'jh_c2': '''
ming ¦ мин ¦ 明
qing ¦ цин ¦ 卿
heng ¦ хэн ¦ 衡
he ¦ хэ ¦ 和
qian ¦ цянь ¦ 谦
xiu ¦ сю ¦ 修
ran ¦ жань ¦ 然
zhen ¦ чжэнь ¦ 贞
zhang ¦ чжан ¦ 璋
lu ¦ лу ¦ 鲁
''',
  'cleric_given': '{cl_a}{cl_b}',
  'cl_a': '''
Hui ¦ Хуэй ¦ 慧
Xuan ¦ Сюань ¦ 玄
Kong ¦ Кун ¦ 空
Liao ¦ Ляо ¦ 了
Jing ¦ Цзин ¦ 净
Qing ¦ Цин ¦ 清
Wu ¦ У ¦ 无
Miao ¦ Мяо ¦ 妙
''',
  'cl_b': '''
ming ¦ мин ¦ 明
zhen ¦ чжэнь ¦ 真
chen ¦ чэнь ¦ 尘
xin ¦ синь ¦ 心
xu ¦ сюй ¦ 虚
zhi ¦ чжи ¦ 智
yun ¦ юнь ¦ 云
xing ¦ син ¦ 性
''',
};

const _rows = <String, String>{
  'cultures': '''
@jianghu Jianghu names ¦ Имена цзянху ¦ Jianghu-Namen ¦ Noms du jianghu ¦ 江湖人名
@cleric Monastic names ¦ Монашеские имена ¦ Ordensnamen ¦ Noms monastiques ¦ 法号道号
''',
  'jianghu_full': '''
{=family} {=given} ¦ {=family} {=given} ¦ {=family} {=given} ¦ {=family} {=given} ¦ {=family}{=given}
''',
  'jianghu_note': '''
courtesy name {jh_c1}{jh_c2} ¦ второе имя {jh_c1}{jh_c2} ¦ Zi-Name {jh_c1}{jh_c2} ¦ nom de courtoisie {jh_c1}{jh_c2} ¦ 字{jh_c1}{jh_c2}
''',
  'cleric_family_m': '''
Great Master ¦ Великий наставник ¦ Großmeister ¦ Grand Maître ¦ 大师
Daoist Master ¦ Даос-наставник ¦ Daoistenmeister ¦ Maître taoïste ¦ 道长
Chan Master ¦ Чань-наставник ¦ Chan-Meister ¦ Maître chan ¦ 禅师
''',
  'cleric_family_f': '''
Venerable Nun ¦ Почтенная монахиня ¦ Ehrwürdige Nonne ¦ Vénérable Nonne ¦ 师太
Immortal Lady ¦ Бессмертная дева ¦ Unsterbliche Dame ¦ Dame immortelle ¦ 仙姑
Daoist Mistress ¦ Даоска-наставница ¦ Daoistenmeisterin ¦ Maîtresse taoïste ¦ 女冠
''',
  'cleric_full': '''
{=family} {=given} ¦ {=family} {=given} ¦ {=family} {=given} ¦ {=family} {=given} ¦ {=given}{=family}
''',
  'epithet': '''
Jade-Faced Scholar ¦ Нефритоликий Книжник~Нефритоликая Книжница ¦ der Jadegesichtige Gelehrte~die Jadegesichtige Gelehrte ¦ le Lettré au Visage de Jade~la Lettrée au Visage de Jade ¦ 玉面书生
Nine-Fingered Blade ¦ Девятипалый Клинок ¦ Neunfingerklinge ¦ Lame-aux-Neuf-Doigts ¦ 九指刀
Drunken Immortal ¦ Пьяный Бессмертный~Пьяная Бессмертная ¦ der Trunkene Unsterbliche~die Trunkene Unsterbliche ¦ l'Immortel Ivre~l'Immortelle Ivre ¦ 醉仙
Swallow of the Southern Rivers ¦ Ласточка Южных Рек ¦ Schwalbe der Südflüsse ¦ Hirondelle des Fleuves du Sud ¦ 江南飞燕
Iron Arm ¦ Железная Рука ¦ Eisenarm ¦ Bras-de-Fer ¦ 铁臂
Ghost-Shadow Sword ¦ Меч Призрачной Тени ¦ Geisterschattenschwert ¦ Épée de l'Ombre Fantôme ¦ 鬼影剑
the Laughing Beggar ¦ Смеющийся Нищий~Смеющаяся Нищенка ¦ der Lachende Bettler~die Lachende Bettlerin ¦ le Mendiant Rieur~la Mendiante Rieuse ¦ 笑丐
Frost Blade ¦ Морозный Клинок ¦ Frostklinge ¦ Lame-de-Givre ¦ 寒霜刀
Thousand-Li Wind ¦ Ветер Тысячи Ли ¦ Tausend-Li-Wind ¦ Vent-des-Mille-Li ¦ 千里风
Jade Flute ¦ Нефритовая Флейта ¦ Jadeflöte ¦ Flûte-de-Jade ¦ 玉笛
Sleeping Dragon ¦ Спящий Дракон ¦ Schlafender Drache ¦ Dragon-Endormi ¦ 卧龙
''',
  'ancestry': '''
@jianghu disciple of the Azure Cloud Sect ¦ ученик школы Лазурных Облаков~ученица школы Лазурных Облаков ¦ Schüler der Azurwolken-Sekte~Schülerin der Azurwolken-Sekte ¦ disciple de la secte des Nuages d'azur ¦ 青云派弟子
@cleric monk of the Silent Bell Monastery ¦ монах монастыря Безмолвного Колокола~монахиня монастыря Безмолвного Колокола ¦ Mönch des Klosters der Stummen Glocke~Nonne des Klosters der Stummen Glocke ¦ moine du monastère de la Cloche muette~nonne du monastère de la Cloche muette ¦ 静钟寺僧人
@cleric Daoist of the Purple Summit ¦ даос с Пурпурной Вершины~даоска с Пурпурной Вершины ¦ Daoist vom Purpurgipfel~Daoistin vom Purpurgipfel ¦ taoïste du Pic pourpre ¦ 紫霄观道士
@jianghu wandering sword of no sect ¦ странствующий мечник без школы~странствующая мечница без школы ¦ Wanderschwertkämpfer ohne Sekte~Wanderschwertkämpferin ohne Sekte ¦ épéiste errant sans secte~épéiste errante sans secte ¦ 无门无派的游侠
@jianghu member of the Beggars' Guild ¦ член Союза нищих ¦ Mitglied der Bettlerzunft ¦ membre de la Guilde des mendiants ¦ 丐帮弟子
@jianghu heir of a declining martial family ¦ наследник угасающего боевого рода~наследница угасающего боевого рода ¦ Erbe einer niedergehenden Kampfkunstfamilie~Erbin einer niedergehenden Kampfkunstfamilie ¦ héritier d'une famille martiale déclinante~héritière d'une famille martiale déclinante ¦ 没落武林世家的传人
@jianghu follower of the demonic Blood Lotus Cult ¦ последователь демонического культа Кровавого Лотоса~последовательница демонического культа Кровавого Лотоса ¦ Anhänger des dämonischen Blutlotuskults~Anhängerin des dämonischen Blutlotuskults ¦ adepte du culte démoniaque du Lotus de sang ¦ 血莲魔教教徒
''',
  'role': '''
sword instructor ¦ наставник фехтования~наставница фехтования ¦ Schwertlehrer~Schwertlehrerin ¦ instructeur d'épée~instructrice d'épée ¦ 剑术教头
escort agency guard ¦ охранник конвойного бюро~охранница конвойного бюро ¦ Wache einer Eskortagentur ¦ garde d'une agence d'escorte ¦ 镖局镖师
innkeeper ¦ хозяин постоялого двора~хозяйка постоялого двора ¦ Wirt~Wirtin ¦ aubergiste ¦ 客栈掌柜
herbal physician ¦ лекарь-травник~лекарка-травница ¦ Kräuterarzt~Kräuterärztin ¦ médecin herboriste ¦ 草药郎中
magistrate's constable ¦ стражник уездного судьи ¦ Häscher des Präfekten~Häscherin des Präfekten ¦ sergent du magistrat ¦ 衙门捕快
wandering storyteller ¦ бродячий сказитель~бродячая сказительница ¦ wandernder Geschichtenerzähler~wandernde Geschichtenerzählerin ¦ conteur itinérant~conteuse itinérante ¦ 游方说书人
teahouse owner ¦ хозяин чайной~хозяйка чайной ¦ Teehausbesitzer~Teehausbesitzerin ¦ patron d'une maison de thé~patronne d'une maison de thé ¦ 茶馆老板
smith of famous blades ¦ кузнец прославленных клинков ¦ Schmied berühmter Klingen~Schmiedin berühmter Klingen ¦ forgeron de lames célèbres~forgeronne de lames célèbres ¦ 铸名剑的铁匠
disgraced imperial official ¦ опальный чиновник~опальная чиновница ¦ in Ungnade gefallener Beamter~in Ungnade gefallene Beamtin ¦ fonctionnaire impérial déchu~fonctionnaire impériale déchue ¦ 被贬的朝廷官员
assassin for hire ¦ наёмный убийца ¦ Auftragsmörder~Auftragsmörderin ¦ assassin à gages ¦ 雇佣刺客
beggar with hidden skills ¦ нищий, скрывающий мастерство~нищенка, скрывающая мастерство ¦ Bettler mit verborgenen Fähigkeiten~Bettlerin mit verborgenen Fähigkeiten ¦ mendiant aux talents cachés~mendiante aux talents cachés ¦ 身怀绝技的乞丐
sect elder ¦ старейшина школы ¦ Sektenältester~Sektenälteste ¦ ancien de la secte~ancienne de la secte ¦ 门派长老
''',
  'appearance': '''
a sword wrapped in plain cloth ¦ меч, обёрнутый простой тканью ¦ ein in schlichtes Tuch gewickeltes Schwert ¦ une épée enveloppée d'un simple tissu ¦ 用粗布裹着的剑
a bamboo hat pulled low over the eyes ¦ бамбуковая шляпа, надвинутая на глаза ¦ ein tief ins Gesicht gezogener Bambushut ¦ un chapeau de bambou rabattu sur les yeux ¦ 压得低低的斗笠
robes too fine for the dusty road ¦ одеяния, слишком изысканные для пыльной дороги ¦ Gewänder, zu fein für die staubige Straße ¦ des robes trop fines pour la route poussiéreuse ¦ 与风尘仆仆的道路不相称的华服
a jade pendant with a broken corner ¦ нефритовая подвеска с отбитым уголком ¦ ein Jadeanhänger mit abgebrochener Ecke ¦ un pendentif de jade à l'angle brisé ¦ 缺了一角的玉佩
white hair above a young face ¦ седые волосы при молодом лице ¦ weißes Haar über einem jungen Gesicht ¦ des cheveux blancs sur un visage jeune ¦ 年轻的面容，满头白发
a gourd of wine always at the hip ¦ тыква-фляга с вином всегда на поясе ¦ eine Kalebasse mit Wein stets am Gürtel ¦ une gourde de vin toujours à la ceinture ¦ 腰间总挂着一只酒葫芦
''',
  'motivation': '''
avenge a master murdered by a rival sect ¦ отомстить за учителя, убитого соперничающей школой ¦ einen von einer rivalisierenden Sekte ermordeten Meister rächen ¦ venger un maître assassiné par une secte rivale ¦ 为被敌对门派杀害的师父报仇
recover a stolen martial arts manual ¦ вернуть украденный трактат боевых искусств ¦ ein gestohlenes Kampfkunsthandbuch zurückholen ¦ récupérer un manuel d'arts martiaux volé ¦ 夺回被盗的武功秘籍
become the greatest sword under heaven ¦ стать первым мечом Поднебесной ¦ das größte Schwert unter dem Himmel werden ¦ devenir la plus grande épée sous le ciel ¦ 成为天下第一剑
clear the family name at court ¦ обелить имя семьи при дворе ¦ den Familiennamen bei Hofe reinwaschen ¦ laver le nom de la famille à la cour ¦ 在朝廷上为家族洗清冤屈
leave the jianghu and live in peace ¦ покинуть цзянху и жить в покое ¦ dem Jianghu den Rücken kehren und in Frieden leben ¦ quitter le jianghu et vivre en paix ¦ 退出江湖，安度余生
find a sibling lost in childhood ¦ найти брата или сестру, потерянных в детстве ¦ ein in der Kindheit verlorenes Geschwisterkind finden ¦ retrouver un frère ou une sœur perdus dans l'enfance ¦ 找到幼时失散的兄弟姐妹
''',
  'secret': '''
is the hidden heir of the demonic cult ¦ тайный наследник демонического культа~тайная наследница демонического культа ¦ ist der verborgene Erbe des Dämonenkults~ist die verborgene Erbin des Dämonenkults ¦ est l'héritier caché du culte démoniaque~est l'héritière cachée du culte démoniaque ¦ 是魔教隐藏的继承人
practices a forbidden technique that is slowly killing them ¦ практикует запретную технику, которая медленно убивает ¦ übt eine verbotene Technik, die langsam tötet ¦ pratique une technique interdite qui tue à petit feu ¦ 练了一门正在慢慢要自己命的禁术
betrayed their own master ¦ предал собственного учителя~предала собственного учителя ¦ hat den eigenen Meister verraten ¦ a trahi son propre maître ¦ 背叛过自己的师父
is a spy for the imperial court ¦ шпионит в пользу императорского двора ¦ spioniert für den Kaiserhof ¦ espionne pour la cour impériale ¦ 是朝廷安插的密探
carries half of a secret manual sewn into their robe ¦ носит зашитую в одежду половину тайного трактата ¦ trägt die Hälfte eines geheimen Handbuchs ins Gewand eingenäht ¦ porte la moitié d'un manuel secret cousue dans sa robe ¦ 衣服里缝着半本秘籍
needs an antidote every month for an old poisoning ¦ из-за давнего отравления каждый месяц нуждается в противоядии ¦ braucht wegen einer alten Vergiftung jeden Monat ein Gegengift ¦ a besoin d'un antidote chaque mois à cause d'un vieil empoisonnement ¦ 多年前中了毒，每月都需服解药
''',
  'settle_size': '''
@Village a mountain hamlet of {#2d6*5} families ¦ горная деревушка на {#2d6*5} семей ¦ ein Bergweiler mit {#2d6*5} Familien ¦ un hameau de montagne de {#2d6*5} familles ¦ {#2d6*5}户人家的山村
@Town a river town of about {#3d6*200} people ¦ речной городок, около {#3d6*200} жителей ¦ eine Flussstadt mit etwa {#3d6*200} Einwohnern ¦ une ville fluviale d'environ {#3d6*200} habitants ¦ 约{#3d6*200}人的水乡小镇
@City a prefectural city of {#2d10*10000} souls ¦ окружной город, {#2d10*10000} душ ¦ eine Präfekturstadt mit {#2d10*10000} Seelen ¦ une ville préfectorale de {#2d10*10000} âmes ¦ {#2d10*10000}人口的州府
@Landmark a sect's mountain stronghold of {#2d6*20} disciples ¦ горная твердыня школы на {#2d6*20} учеников ¦ eine Bergfestung einer Sekte mit {#2d6*20} Schülern ¦ une forteresse de montagne d'une secte de {#2d6*20} disciples ¦ 住着{#2d6*20}名弟子的门派山门
''',
  'settle_feature': '''
a teahouse where every table hides a master ¦ чайная, где за каждым столом сидит мастер ¦ ein Teehaus, an dessen jedem Tisch ein Meister sitzt ¦ une maison de thé où chaque table cache un maître ¦ 每张桌子都坐着高手的茶馆
a stone bridge where duels are fought at dawn ¦ каменный мост, на котором на рассвете сходятся в поединках ¦ eine Steinbrücke, auf der im Morgengrauen Duelle ausgetragen werden ¦ un pont de pierre où l'on se bat en duel à l'aube ¦ 黎明时分有人决斗的石桥
a waterfall said to hide a secret cave ¦ водопад, за которым, говорят, скрыта тайная пещера ¦ ein Wasserfall, hinter dem eine geheime Höhle liegen soll ¦ une cascade qui cacherait une grotte secrète ¦ 据说藏着秘洞的瀑布
a pagoda whose top floor is always locked ¦ пагода, чей верхний ярус всегда заперт ¦ eine Pagode, deren oberstes Stockwerk stets verschlossen ist ¦ une pagode dont le dernier étage est toujours fermé ¦ 顶层永远上锁的宝塔
an escort agency with a famous banner ¦ конвойное бюро со знаменитым стягом ¦ eine Eskortagentur mit berühmtem Banner ¦ une agence d'escorte à la bannière célèbre ¦ 镖旗闻名的镖局
a plum grove that blooms in the snow ¦ сливовая роща, цветущая в снегу ¦ ein Pflaumenhain, der im Schnee blüht ¦ un verger de pruniers qui fleurit sous la neige ¦ 雪中盛开的梅林
a market for antidotes and poisons ¦ рынок противоядий и ядов ¦ ein Markt für Gegengifte und Gifte ¦ un marché aux antidotes et aux poisons ¦ 专卖解药和毒药的集市
a temple bell no one can ring ¦ храмовый колокол, в который никто не может ударить ¦ eine Tempelglocke, die niemand läuten kann ¦ une cloche de temple que nul ne peut sonner ¦ 无人能敲响的寺钟
an arena where martial contests are held each spring ¦ помост, где каждую весну проходят боевые состязания ¦ eine Arena, in der jeden Frühling Kampfturniere stattfinden ¦ une arène où se tiennent chaque printemps des tournois martiaux ¦ 每年春天举办比武大会的擂台
a cliff carved with a sword manual ¦ скала с высеченным трактатом о мече ¦ eine Klippe, in die ein Schwerthandbuch gemeißelt ist ¦ une falaise gravée d'un traité d'épée ¦ 刻着剑谱的石壁
''',
  'settle_trouble': '''
a masked killer is challenging every master in town ¦ убийца в маске вызывает на бой каждого мастера в городе ¦ ein maskierter Mörder fordert jeden Meister der Stadt heraus ¦ un tueur masqué défie tous les maîtres de la ville ¦ 一名蒙面杀手正在挑战城中每一位高手
two sects are feuding over a stolen manual ¦ две школы враждуют из-за украденного трактата ¦ zwei Sekten streiten um ein gestohlenes Handbuch ¦ deux sectes se disputent un manuel volé ¦ 两个门派为一本失窃的秘籍结仇
the magistrate is taxing the martial schools into ruin ¦ уездный судья разоряет школы боевых искусств налогами ¦ der Präfekt treibt die Kampfschulen mit Steuern in den Ruin ¦ le magistrat ruine les écoles martiales à force d'impôts ¦ 知府的苛税快把武馆逼垮了
a strange poison has turned up in the wells ¦ в колодцах появился неведомый яд ¦ in den Brunnen ist ein seltsames Gift aufgetaucht ¦ un étrange poison est apparu dans les puits ¦ 井里出现了一种奇怪的毒
bandits hold the mountain pass ¦ разбойники держат горный перевал ¦ Banditen halten den Bergpass besetzt ¦ des bandits tiennent le col de montagne ¦ 山贼占据了山口
the demonic cult has returned after twenty years ¦ демонический культ вернулся спустя двадцать лет ¦ der Dämonenkult ist nach zwanzig Jahren zurück ¦ le culte démoniaque est de retour après vingt ans ¦ 魔教在二十年后卷土重来
a famous sword has vanished from the temple ¦ из храма исчез знаменитый меч ¦ ein berühmtes Schwert ist aus dem Tempel verschwunden ¦ une épée célèbre a disparu du temple ¦ 一柄名剑从寺中消失了
the escort agency has lost a shipment of silver ¦ конвойное бюро потеряло груз серебра ¦ die Eskortagentur hat eine Silberlieferung verloren ¦ l'agence d'escorte a perdu un convoi d'argent ¦ 镖局丢了一趟镖银
a young master was found dead in the arena ¦ юного мастера нашли мёртвым на помосте ¦ ein junger Meister wurde tot in der Arena gefunden ¦ un jeune maître a été retrouvé mort dans l'arène ¦ 一位少侠被发现死在擂台上
imperial soldiers are searching every house ¦ императорские солдаты обыскивают каждый дом ¦ kaiserliche Soldaten durchsuchen jedes Haus ¦ des soldats impériaux fouillent chaque maison ¦ 官兵正在挨家挨户搜查
''',
  'settle_authority': '''
a magistrate who fears the martial world ¦ уездный судья, боящийся мира боевых искусств ¦ ein Präfekt, der die Kampfkunstwelt fürchtet ¦ un magistrat qui craint le monde martial ¦ 畏惧江湖的知府
the head of the local martial school ¦ глава местной школы боевых искусств ¦ das Oberhaupt der örtlichen Kampfschule ¦ le chef de l'école martiale locale ¦ 本地武馆的馆主
an abbot who speaks only in riddles ¦ настоятель, говорящий только загадками ¦ ein Abt, der nur in Rätseln spricht ¦ un abbé qui ne parle que par énigmes ¦ 只说禅机的方丈
a merchant guild that pays the bandits ¦ купеческая гильдия, платящая разбойникам ¦ eine Kaufmannsgilde, die die Banditen bezahlt ¦ une guilde marchande qui paie les bandits ¦ 向山贼交保护费的商会
the elders of a clan settled here for centuries ¦ старейшины рода, живущего здесь веками ¦ die Ältesten eines seit Jahrhunderten ansässigen Clans ¦ les anciens d'un clan établi ici depuis des siècles ¦ 世居此地数百年的宗族长老
an imperial eunuch on a secret mission ¦ императорский евнух с тайным поручением ¦ ein kaiserlicher Eunuch in geheimer Mission ¦ un eunuque impérial en mission secrète ¦ 身负密令的宫中太监
the Beggars' Guild, from behind the scenes ¦ Союз нищих — из-за кулис ¦ die Bettlerzunft, hinter den Kulissen ¦ la Guilde des mendiants, en coulisses ¦ 幕后的丐帮
a retired master everyone still obeys ¦ отошедший от дел мастер, которого все ещё слушаются ¦ ein zurückgezogener Meister, dem alle noch gehorchen ¦ un maître retiré à qui tous obéissent encore ¦ 已退隐却仍令众人听命的前辈高人
''',
  'est_type': '''
inn ¦ постоялый двор ¦ Herberge ¦ auberge ¦ 客栈
teahouse ¦ чайная ¦ Teehaus ¦ maison de thé ¦ 茶楼
wine house ¦ винный дом ¦ Weinhaus ¦ maison de vin ¦ 酒楼
medicine shop ¦ аптекарская лавка ¦ Arzneiladen ¦ boutique de remèdes ¦ 药铺
weapon smithy ¦ оружейная кузня ¦ Waffenschmiede ¦ forge d'armes ¦ 兵器铺
escort agency ¦ конвойное бюро ¦ Eskortagentur ¦ agence d'escorte ¦ 镖局
''',
  'est_adj': '''
Drunken ¦ пьяный~пьяная ¦ Betrunkenen ¦ ivre ¦ 醉
Jade ¦ нефритовый~нефритовая ¦ Jadegrünen ¦ de jade ¦ 玉
Flying ¦ летящий~летящая ¦ Fliegenden ¦ volant~volante ¦ 飞
Golden ¦ золотой~золотая ¦ Goldenen ¦ doré~dorée ¦ 金
Hidden ¦ скрытый~скрытая ¦ Verborgenen ¦ caché~cachée ¦ 隐
Crimson ¦ багряный~багряная ¦ Purpurroten ¦ pourpre ¦ 赤
Autumn ¦ осенний~осенняя ¦ Herbstlichen ¦ d'automne ¦ 秋
Laughing ¦ смеющийся~смеющаяся ¦ Lachenden ¦ rieur~rieuse ¦ 笑
Moonlit ¦ лунный~лунная ¦ Mondbeschienenen ¦ de lune ¦ 月
Azure ¦ лазурный~лазурная ¦ Azurblauen ¦ d'azur ¦ 青
''',
  'est_noun': '''
Sage ¦ небожитель#m ¦ Mönch#m ¦ Sage#m ¦ 仙
Dragon ¦ дракон#m ¦ Lindwurm#m ¦ Dragon#m ¦ 龙
Crane ¦ журавль#m ¦ Kranich#m ¦ Grue#f ¦ 鹤
Plum Blossom ¦ слива#f ¦ Pflaumenblüte#f ¦ Fleur-de-Prunier#f ¦ 梅
Tiger ¦ тигр#m ¦ Tiger#m ¦ Tigre#m ¦ 虎
Magpie ¦ сорока#f ¦ Elster#f ¦ Pie#f ¦ 鹊
Lotus ¦ лотос#m ¦ Lotusblüte#f ¦ Lotus#m ¦ 莲
Phoenix ¦ феникс#m ¦ Phönix#m ¦ Phénix#m ¦ 凤
Sword ¦ меч#m ¦ Schwert#m ¦ Sabre#m ¦ 剑
Willow ¦ ива#f ¦ Weide#f ¦ Saule#m ¦ 柳
Cloud ¦ туча#f ¦ Wolke#f ¦ Nuée#f ¦ 云
Fox ¦ лиса#f ¦ Fuchs#m ¦ Renard#m ¦ 狐
Pine ¦ сосна#f ¦ Kiefer#f ¦ Pin#m ¦ 松
''',
  'est_specialty': '''
wine said to be three hundred years old ¦ вино, которому, говорят, триста лет ¦ Wein, angeblich dreihundert Jahre alt ¦ un vin qu'on dit vieux de trois siècles ¦ 据说有三百年的陈酿
beef and strong liquor by the pound ¦ говядина и крепкое вино на развес ¦ Rindfleisch und starker Schnaps pfundweise ¦ du bœuf et de l'alcool fort à la livre ¦ 按斤卖的牛肉和烈酒
a storyteller who knows every sect's secrets ¦ сказитель, знающий тайны всех школ ¦ ein Geschichtenerzähler, der die Geheimnisse jeder Sekte kennt ¦ un conteur qui connaît les secrets de chaque secte ¦ 知晓各派秘辛的说书人
antidotes for most common poisons ¦ противоядия от самых обычных ядов ¦ Gegengifte für die meisten gängigen Gifte ¦ des antidotes pour la plupart des poisons courants ¦ 可解大多数常见毒的解药
swords reforged overnight ¦ мечи, перекованные за ночь ¦ über Nacht neu geschmiedete Schwerter ¦ des épées reforgées en une nuit ¦ 一夜之间重铸的宝剑
jasmine tea and news from the capital ¦ жасминовый чай и новости из столицы ¦ Jasmintee und Neuigkeiten aus der Hauptstadt ¦ du thé au jasmin et des nouvelles de la capitale ¦ 茉莉花茶和京城消息
rooms where no one asks your name ¦ комнаты, где никто не спросит имени ¦ Zimmer, in denen niemand nach dem Namen fragt ¦ des chambres où personne ne demande votre nom ¦ 没人问你姓名的客房
a board of bounties posted by the sects ¦ доска наград, объявленных школами ¦ ein Brett mit Kopfgeldern der Sekten ¦ un tableau des primes affichées par les sectes ¦ 各派张贴悬赏的告示板
steamed buns famous across three provinces ¦ паровые пирожки, известные в трёх провинциях ¦ gedämpfte Teigtaschen, berühmt in drei Provinzen ¦ des brioches vapeur célèbres dans trois provinces ¦ 名扬三省的包子
safe passage for silver, guaranteed by a banner ¦ безопасная перевозка серебра под гарантию стяга ¦ sicheres Geleit für Silber, garantiert durch ein Banner ¦ un passage sûr pour l'argent, garanti par une bannière ¦ 凭镖旗担保的镖银平安
''',
  'est_patron': '''
a young master sneaking away from his sect ¦ юный мастер, тайком сбежавший из своей школы ¦ ein junger Meister, der sich von seiner Sekte fortschleicht ¦ un jeune maître qui a fui sa secte en cachette ¦ 偷偷溜出师门的少侠
an old beggar who pays in silver ¦ старый нищий, расплачивающийся серебром ¦ ein alter Bettler, der mit Silber bezahlt ¦ un vieux mendiant qui paie en argent ¦ 用银子付账的老乞丐
a masked woman who never lifts her veil ¦ женщина в маске, никогда не поднимающая вуаль ¦ eine maskierte Frau, die nie ihren Schleier hebt ¦ une femme masquée qui ne lève jamais son voile ¦ 从不摘下面纱的蒙面女子
a constable drinking on duty ¦ стражник, пьющий на службе ¦ ein Häscher, der im Dienst trinkt ¦ un sergent qui boit pendant son service ¦ 当差时喝酒的捕快
a monk eating meat in the corner ¦ монах, поедающий мясо в углу ¦ ein Mönch, der in der Ecke Fleisch isst ¦ un moine qui mange de la viande dans un coin ¦ 坐在角落吃肉的和尚
twin sword-sisters from the south ¦ сёстры-мечницы с юга ¦ Schwertschwestern aus dem Süden ¦ des sœurs épéistes du Sud ¦ 来自江南的双剑姐妹
a scholar who writes down every duel ¦ книжник, записывающий каждый поединок ¦ ein Gelehrter, der jedes Duell aufschreibt ¦ un lettré qui consigne chaque duel ¦ 记录每一场决斗的书生
an escort captain guarding a mysterious box ¦ капитан конвоя, охраняющий загадочный ларец ¦ ein Eskortführer, der eine geheimnisvolle Kiste bewacht ¦ un chef d'escorte qui garde un coffret mystérieux ¦ 看守着一只神秘箱子的镖头
''',
  'hook_title': '''
The Sword That Weeps ¦ Плачущий меч ¦ Das weinende Schwert ¦ L'Épée qui pleure ¦ 泣剑
Nine Steps to the Summit ¦ Девять шагов к вершине ¦ Neun Schritte zum Gipfel ¦ Neuf pas vers le sommet ¦ 登顶九步
Poison in the Plum Wine ¦ Яд в сливовом вине ¦ Gift im Pflaumenwein ¦ Du poison dans le vin de prune ¦ 梅酒中的毒
The Last Page of the Manual ¦ Последняя страница трактата ¦ Die letzte Seite des Handbuchs ¦ La Dernière Page du manuel ¦ 秘籍的最后一页
Blood on the Martial Stage ¦ Кровь на помосте ¦ Blut auf der Kampfbühne ¦ Du sang sur l'estrade martiale ¦ 擂台上的血
The Masked Guest of the Jade Inn ¦ Гость в маске с Нефритового постоялого двора ¦ Der maskierte Gast der Jadeherberge ¦ L'Invité masqué de l'Auberge de jade ¦ 玉客栈的蒙面客
Twenty Years of Vengeance ¦ Двадцать лет мести ¦ Zwanzig Jahre Rache ¦ Vingt ans de vengeance ¦ 二十年血仇
The Emperor's Missing Seal ¦ Пропавшая печать императора ¦ Das verschwundene Siegel des Kaisers ¦ Le Sceau disparu de l'empereur ¦ 皇帝失踪的玉玺
Snow over the Silent Bell ¦ Снег над Безмолвным Колоколом ¦ Schnee über der Stummen Glocke ¦ Neige sur la Cloche muette ¦ 静钟寺的雪
A Duel Beneath the Waterfall ¦ Поединок под водопадом ¦ Ein Duell unter dem Wasserfall ¦ Un duel sous la cascade ¦ 瀑布下的决斗
''',
  'hook_who': '''
the last disciple of a destroyed sect ¦ последний ученик уничтоженной школы ¦ der letzte Schüler einer zerstörten Sekte ¦ le dernier disciple d'une secte anéantie ¦ 一个被灭门派的最后弟子
an escort chief who lost a shipment ¦ глава конвойного бюро, потерявший груз ¦ ein Eskortchef, der eine Lieferung verloren hat ¦ un chef d'escorte qui a perdu un convoi ¦ 丢了镖的总镖头
a princess fleeing an arranged marriage ¦ принцесса, бегущая от брака по расчёту ¦ eine Prinzessin auf der Flucht vor einer arrangierten Ehe ¦ une princesse qui fuit un mariage arrangé ¦ 逃婚的公主
a dying master with no heir ¦ умирающий мастер без наследника ¦ ein sterbender Meister ohne Erben ¦ un maître mourant sans héritier ¦ 没有传人的垂死高手
a magistrate's daughter who studies the sword in secret ¦ дочь судьи, тайком изучающая фехтование ¦ die Tochter eines Präfekten, die heimlich den Schwertkampf lernt ¦ la fille d'un magistrat qui étudie l'épée en secret ¦ 偷偷习剑的知府千金
a physician who can cure every poison but one ¦ лекарь, способный исцелить от любого яда, кроме одного ¦ ein Arzt, der jedes Gift heilen kann außer einem ¦ un médecin capable de soigner tous les poisons sauf un ¦ 能解百毒唯独解不了一种的神医
an abbot hiding a fugitive ¦ настоятель, укрывающий беглеца ¦ ein Abt, der einen Flüchtling versteckt ¦ un abbé qui cache un fugitif ¦ 藏匿逃犯的方丈
a reformed bandit chief ¦ исправившийся главарь разбойников ¦ ein geläuterter Räuberhauptmann ¦ un chef brigand repenti ¦ 改邪归正的山大王
a child who witnessed the massacre ¦ ребёнок, видевший резню ¦ ein Kind, das das Massaker gesehen hat ¦ un enfant témoin du massacre ¦ 目睹了灭门惨案的孩子
the Beggars' Guild elder with the iron bowl ¦ старейшина Союза нищих с железной чашей ¦ der Älteste der Bettlerzunft mit der eisernen Schale ¦ l'ancien de la Guilde des mendiants au bol de fer ¦ 手捧铁碗的丐帮长老
''',
  'hook_wants': '''
recover the stolen sword manual ¦ вернуть украденный трактат о мече ¦ das gestohlene Schwerthandbuch zurückholen ¦ récupérer le traité d'épée volé ¦ 夺回被盗的剑谱
escort the silver shipment through bandit country ¦ провести груз серебра через земли разбойников ¦ die Silberlieferung durch Banditenland eskortieren ¦ escorter le convoi d'argent à travers le pays des bandits ¦ 护送镖银穿过山贼地界
find the antidote before the new moon ¦ найти противоядие до новолуния ¦ das Gegengift vor Neumond finden ¦ trouver l'antidote avant la nouvelle lune ¦ 在新月之前找到解药
win the martial contest to settle a feud ¦ выиграть турнир, чтобы уладить вражду ¦ das Kampfturnier gewinnen, um eine Fehde beizulegen ¦ remporter le tournoi martial pour régler une querelle ¦ 赢下比武大会以了结恩怨
smuggle a witness past the imperial checkpoints ¦ провести свидетеля мимо императорских застав ¦ einen Zeugen an den kaiserlichen Kontrollposten vorbeischmuggeln ¦ faire passer un témoin aux postes de contrôle impériaux ¦ 把一名证人偷偷带过官府关卡
unmask the killer behind the bronze mask ¦ разоблачить убийцу под бронзовой маской ¦ den Mörder hinter der Bronzemaske enttarnen ¦ démasquer le tueur au masque de bronze ¦ 揭开青铜面具杀手的真面目
deliver a letter of challenge to a rival sect ¦ доставить вызов соперничающей школе ¦ einer rivalisierenden Sekte einen Fehdebrief überbringen ¦ remettre une lettre de défi à une secte rivale ¦ 向敌对门派递送战书
bring a runaway princess back to the capital ¦ вернуть сбежавшую принцессу в столицу ¦ eine entlaufene Prinzessin in die Hauptstadt zurückbringen ¦ ramener une princesse fugitive à la capitale ¦ 把逃走的公主带回京城
protect an old master until his last disciple arrives ¦ охранять старого мастера до прибытия его последнего ученика ¦ einen alten Meister schützen, bis sein letzter Schüler eintrifft ¦ protéger un vieux maître jusqu'à l'arrivée de son dernier disciple ¦ 保护老前辈直到他的关门弟子赶到
find the hidden cave behind the waterfall ¦ найти тайную пещеру за водопадом ¦ die verborgene Höhle hinter dem Wasserfall finden ¦ trouver la grotte cachée derrière la cascade ¦ 找到瀑布后的秘洞
''',
  'hook_obstacle': '''
every sect in the region wants the same manual ¦ этот трактат нужен каждой школе в округе ¦ jede Sekte der Gegend will dasselbe Handbuch ¦ toutes les sectes de la région veulent le même manuel ¦ 方圆百里的门派都想要同一本秘籍
the imperial court has declared the party outlaws ¦ императорский двор объявил героев вне закона ¦ der Kaiserhof hat die Gruppe für vogelfrei erklärt ¦ la cour impériale a déclaré le groupe hors-la-loi ¦ 朝廷已将他们定为钦犯
the only path crosses a sect's forbidden ground ¦ единственная тропа идёт через запретные земли школы ¦ der einzige Weg führt über verbotenes Sektengebiet ¦ le seul chemin traverse le territoire interdit d'une secte ¦ 唯一的路要穿过某派禁地
a master of poisons follows them in disguise ¦ мастер ядов преследует их под личиной ¦ ein Giftmeister folgt ihnen verkleidet ¦ un maître des poisons les suit déguisé ¦ 一位用毒高手乔装尾随
the winter snows have closed the mountain roads ¦ зимние снега закрыли горные дороги ¦ der Winterschnee hat die Bergstraßen geschlossen ¦ les neiges d'hiver ont fermé les routes de montagne ¦ 冬雪封住了山路
an old debt of honor binds one of them to the enemy ¦ старый долг чести связывает одного из них с врагом ¦ eine alte Ehrenschuld bindet einen von ihnen an den Feind ¦ une vieille dette d'honneur lie l'un d'eux à l'ennemi ¦ 一笔旧日恩情让其中一人受制于敌
the witness has taken a vow of silence ¦ свидетель дал обет молчания ¦ der Zeuge hat ein Schweigegelübde abgelegt ¦ le témoin a fait vœu de silence ¦ 证人发过禁语之誓
the manual is written in a cipher only the dead master knew ¦ трактат написан шифром, известным лишь покойному мастеру ¦ das Handbuch ist in einer Geheimschrift, die nur der tote Meister kannte ¦ le manuel est chiffré d'un code que seul le maître défunt connaissait ¦ 秘籍用只有已故师父才懂的密文写成
the magistrate's soldiers guard every bridge ¦ солдаты судьи охраняют каждый мост ¦ die Soldaten des Präfekten bewachen jede Brücke ¦ les soldats du magistrat gardent chaque pont ¦ 知府的官兵把守着每一座桥
a rival hero challenges them in every town ¦ соперник вызывает их на поединок в каждом городе ¦ ein rivalisierender Held fordert sie in jeder Stadt heraus ¦ un héros rival les défie dans chaque ville ¦ 一位对手在每座城里都向他们挑战
''',
  'hook_twist': '''
the murdered master faked his death ¦ убитый мастер инсценировал свою смерть ¦ der ermordete Meister hat seinen Tod vorgetäuscht ¦ le maître assassiné a simulé sa mort ¦ 被害的师父是诈死
the manual's final technique destroys its user ¦ последняя техника трактата губит того, кто её применит ¦ die letzte Technik des Handbuchs zerstört ihren Anwender ¦ la dernière technique du manuel détruit celui qui l'emploie ¦ 秘籍的最后一招会毁掉练功之人
the demonic cult is protecting the villagers ¦ демонический культ защищает деревенских ¦ der Dämonenkult beschützt die Dorfbewohner ¦ le culte démoniaque protège les villageois ¦ 魔教其实在保护村民
the patron is the masked killer ¦ заказчик и есть убийца в маске ¦ der Auftraggeber ist der maskierte Mörder ¦ le commanditaire est le tueur masqué ¦ 委托人就是那个蒙面杀手
the princess is not a princess ¦ принцесса — вовсе не принцесса ¦ die Prinzessin ist keine Prinzessin ¦ la princesse n'est pas une princesse ¦ 那位公主根本不是公主
the silver shipment is full of stones ¦ в грузе серебра — камни ¦ die Silberlieferung ist voller Steine ¦ le convoi d'argent est rempli de pierres ¦ 镖银箱子里装的是石头
the rival sect's leader is a hero's lost parent ¦ глава враждебной школы — потерянный родитель одного из героев ¦ das Oberhaupt der feindlichen Sekte ist ein verlorenes Elternteil eines Helden ¦ le chef de la secte rivale est un parent perdu de l'un des héros ¦ 敌对门派的掌门是某位主角失散的亲人
the imperial eunuch started the feud ¦ вражду начал императорский евнух ¦ der kaiserliche Eunuch hat die Fehde angezettelt ¦ c'est l'eunuque impérial qui a déclenché la querelle ¦ 这场恩怨是宫中太监挑起的
the antidote and the poison are the same herb ¦ противоядие и яд — одна и та же трава ¦ Gegengift und Gift sind dasselbe Kraut ¦ l'antidote et le poison sont la même herbe ¦ 解药和毒药是同一种草药
the old master's last disciple is one of the heroes ¦ последний ученик старого мастера — один из героев ¦ der letzte Schüler des alten Meisters ist einer der Helden ¦ le dernier disciple du vieux maître est l'un des héros ¦ 老前辈的关门弟子就是主角之一
''',
  'loot_container': '''
Escort agency strongbox ¦ Сундук конвойного бюро ¦ Geldkiste einer Eskortagentur ¦ Coffre d'une agence d'escorte ¦ 镖局的银箱
Bandit chief's treasure hall ¦ Сокровищница главаря разбойников ¦ Schatzhalle eines Räuberhauptmanns ¦ Salle au trésor d'un chef brigand ¦ 山大王的聚宝堂
Hidden drawer in a sect library ¦ Потайной ящик в библиотеке школы ¦ Geheimschublade einer Sektenbibliothek ¦ Tiroir caché de la bibliothèque d'une secte ¦ 门派藏经阁的暗屉
Fallen master's travelling pack ¦ Дорожная котомка павшего мастера ¦ Reisebündel eines gefallenen Meisters ¦ Baluchon d'un maître tombé ¦ 殒命高手的行囊
Magistrate's confiscated goods ¦ Конфискованное судьёй имущество ¦ Beschlagnahmte Güter des Präfekten ¦ Biens confisqués du magistrat ¦ 知府查抄的赃物
Tomb of a forgotten general ¦ Гробница забытого полководца ¦ Grab eines vergessenen Generals ¦ Tombeau d'un général oublié ¦ 无名将军的古墓
Merchant's false-bottomed chest ¦ Сундук купца с двойным дном ¦ Kaufmannstruhe mit doppeltem Boden ¦ Coffre de marchand à double fond ¦ 商人的夹底箱
Temple offering box ¦ Храмовый ящик для подношений ¦ Opferkasten eines Tempels ¦ Tronc d'offrandes du temple ¦ 寺庙功德箱
''',
  'loot_coin': '''
{#3d6*10} taels of silver ¦ серебряные ляны: {#3d6*10} ¦ {#3d6*10} Tael Silber ¦ {#3d6*10} taëls d'argent ¦ {#3d6*10}两银子
a string of {#4d6*25} copper cash ¦ связка медных монет: {#4d6*25} ¦ eine Schnur mit {#4d6*25} Kupfermünzen ¦ un chapelet de {#4d6*25} sapèques de cuivre ¦ 一串{#4d6*25}文铜钱
{#1d4+1} gold ingots stamped with a bank seal ¦ золотые слитки с печатью меняльной лавки: {#1d4+1} ¦ {#1d4+1} Goldbarren mit dem Siegel eines Geldhauses ¦ {#1d4+1} lingots d'or frappés du sceau d'une banque ¦ {#1d4+1}锭盖着钱庄印记的金元宝
silver notes worth {#2d6*50} taels ¦ серебряные расписки на {#2d6*50} лянов ¦ Silberscheine im Wert von {#2d6*50} Tael ¦ des billets d'argent valant {#2d6*50} taëls ¦ 价值{#2d6*50}两的银票
''',
  'loot_item': '''
healing pills in a porcelain bottle ×{#1d4+1} ¦ целебные пилюли в фарфоровом флаконе ×{#1d4+1} ¦ Heilpillen in einem Porzellanfläschchen ×{#1d4+1} ¦ pilules de guérison dans un flacon de porcelaine ×{#1d4+1} ¦ 瓷瓶装的疗伤丹药 ×{#1d4+1}
a sword bearing a famous smith's mark ¦ меч с клеймом знаменитого кузнеца ¦ ein Schwert mit dem Zeichen eines berühmten Schmieds ¦ une épée portant la marque d'un forgeron célèbre ¦ 刻着名匠印记的剑
throwing darts ×{#2d6} ¦ метательные дротики ×{#2d6} ¦ Wurfpfeile ×{#2d6} ¦ fléchettes de jet ×{#2d6} ¦ 飞镖 ×{#2d6}
half of a martial arts manual ¦ половина трактата боевых искусств ¦ die Hälfte eines Kampfkunsthandbuchs ¦ la moitié d'un manuel d'arts martiaux ¦ 半本武功秘籍
jars of fine rice wine ×{#1d4+1} ¦ кувшины хорошего рисового вина ×{#1d4+1} ¦ Krüge feinen Reisweins ×{#1d4+1} ¦ jarres de bon vin de riz ×{#1d4+1} ¦ 上好米酒 ×{#1d4+1}
a sect elder's jade token ¦ нефритовый знак старейшины школы ¦ ein Jadeabzeichen eines Sektenältesten ¦ un jeton de jade d'un ancien de secte ¦ 门派长老的玉令牌
an antidote of uncertain effect ¦ противоядие сомнительного действия ¦ ein Gegengift unsicherer Wirkung ¦ un antidote à l'effet incertain ¦ 效果不明的解药
a folding fan with steel ribs ¦ веер со стальными спицами ¦ ein Fächer mit Stahlrippen ¦ un éventail aux baleines d'acier ¦ 精钢扇骨的折扇
bolts of southern silk ×{#1d4+1} ¦ отрезы южного шёлка ×{#1d4+1} ¦ Ballen südlicher Seide ×{#1d4+1} ¦ rouleaux de soie du Sud ×{#1d4+1} ¦ 江南丝绸 ×{#1d4+1}
a thousand-year ginseng root ¦ тысячелетний корень женьшеня ¦ eine tausendjährige Ginsengwurzel ¦ une racine de ginseng millénaire ¦ 千年人参
a bamboo flute with a hidden blade ¦ бамбуковая флейта со спрятанным клинком ¦ eine Bambusflöte mit verborgener Klinge ¦ une flûte de bambou qui dissimule une lame ¦ 藏着刀刃的竹笛
smoke pellets ×{#1d4+1} ¦ дымовые шарики ×{#1d4+1} ¦ Rauchkugeln ×{#1d4+1} ¦ boulettes fumigènes ×{#1d4+1} ¦ 烟雾弹 ×{#1d4+1}
a soft armor vest of woven silver ¦ мягкий жилет-доспех из серебряного плетения ¦ eine weiche Panzerweste aus gewebtem Silber ¦ un gilet souple de mailles d'argent ¦ 银丝编织的软甲
an imperial travel pass, slightly forged ¦ императорская подорожная, слегка подделанная ¦ ein kaiserlicher Reisepass, leicht gefälscht ¦ un laissez-passer impérial, légèrement falsifié ¦ 稍有伪造的官府路引
bundles of incense sticks ×{#1d6+1} ¦ пучки благовонных палочек ×{#1d6+1} ¦ Bündel Räucherstäbchen ×{#1d6+1} ¦ fagots de bâtonnets d'encens ×{#1d6+1} ¦ 线香 ×{#1d6+1}
a whip of braided horsehair ¦ плеть из плетёного конского волоса ¦ eine Peitsche aus geflochtenem Rosshaar ¦ un fouet de crin tressé ¦ 马鬃编成的长鞭
''',
  'loot_curio': '''
a letter of challenge sealed twenty years ago ¦ вызов на поединок, запечатанный двадцать лет назад ¦ ein vor zwanzig Jahren versiegelter Fehdebrief ¦ une lettre de défi scellée il y a vingt ans ¦ 一封二十年前封好的战书
a jade hairpin that hums near poison ¦ нефритовая шпилька, гудящая рядом с ядом ¦ eine Jadehaarnadel, die in der Nähe von Gift summt ¦ une épingle à cheveux de jade qui vibre près du poison ¦ 靠近毒物就会嗡鸣的玉簪
a portrait of the heroes painted by a stranger ¦ портрет героев, написанный незнакомцем ¦ ein Porträt der Helden, gemalt von einem Fremden ¦ un portrait des héros peint par un inconnu ¦ 陌生人画的主角们的画像
a go stone carved from black jade ¦ фишка для го из чёрного нефрита ¦ ein Go-Stein aus schwarzer Jade ¦ un pion de go taillé dans du jade noir ¦ 墨玉雕成的围棋子
a broken sword that still feels warm ¦ сломанный меч, всё ещё тёплый на ощупь ¦ ein zerbrochenes Schwert, das sich noch warm anfühlt ¦ une épée brisée encore tiède au toucher ¦ 摸起来仍有余温的断剑
a map drawn inside a fan ¦ карта, нарисованная на внутренней стороне веера ¦ eine Karte auf der Innenseite eines Fächers ¦ une carte dessinée à l'intérieur d'un éventail ¦ 画在扇面内侧的地图
a lotus seed that never rots ¦ семя лотоса, которое никогда не гниёт ¦ ein Lotussamen, der nie verrottet ¦ une graine de lotus qui ne pourrit jamais ¦ 永不腐坏的莲子
a bronze mirror that shows the past ¦ бронзовое зеркало, показывающее прошлое ¦ ein Bronzespiegel, der die Vergangenheit zeigt ¦ un miroir de bronze qui montre le passé ¦ 能照出过去的铜镜
''',
  'faction_noun': '''
@Order Sect ¦ Школа ¦ Sekte ¦ Secte ¦ 派
@Order Palace ¦ Дворец ¦ Palast ¦ Palais ¦ 宫
@Cult Cult ¦ Культ ¦ Kult ¦ Culte ¦ 教
@Guild Escort Agency ¦ Конвойное бюро ¦ Eskortagentur ¦ Agence d'escorte ¦ 镖局
@Family Manor ¦ Поместье ¦ Anwesen ¦ Manoir ¦ 山庄
@Other Alliance ¦ Союз ¦ Bund ¦ Alliance ¦ 盟
@Tribe Stronghold ¦ Твердыня ¦ Festung ¦ Forteresse ¦ 寨
@Order Monastery ¦ Монастырь ¦ Kloster ¦ Monastère ¦ 寺
''',
  'faction_of': '''
Azure Cloud ¦ Лазурных Облаков ¦ der Azurwolken ¦ des Nuages d'azur ¦ 青云
Heavenly Fragrance ¦ Небесного Аромата ¦ des Himmelsdufts ¦ du Parfum céleste ¦ 天香
Blood Lotus ¦ Кровавого Лотоса ¦ des Blutlotus ¦ du Lotus de sang ¦ 血莲
Mighty Reach ¦ Великой Дали ¦ der Fernen Macht ¦ de la Puissance lointaine ¦ 威远
Sunset Clouds ¦ Закатных Облаков ¦ der Abendwolken ¦ des Nuages du couchant ¦ 落霞
Iron Sword ¦ Железного Меча ¦ des Eisernen Schwertes ¦ de l'Épée de fer ¦ 铁剑
Mysterious Ice ¦ Сокровенного Льда ¦ des Geheimnisvollen Eises ¦ de la Glace mystérieuse ¦ 玄冰
Purple Summit ¦ Пурпурной Вершины ¦ des Purpurgipfels ¦ du Pic pourpre ¦ 紫霄
Ten Thousand Flowers ¦ Десяти Тысяч Цветов ¦ der Zehntausend Blumen ¦ des Dix Mille Fleurs ¦ 万花
Silent Bell ¦ Безмолвного Колокола ¦ der Stummen Glocke ¦ de la Cloche muette ¦ 静钟
''',
  'faction_name': '''
The {faction_of} {faction_noun} ¦ {faction_noun} {faction_of} ¦ {faction_noun} {faction_of} ¦ {faction_noun} {faction_of} ¦ {faction_of}{faction_noun}
''',
  'faction_goal': '''
unite the martial world under one leader ¦ объединить мир боевых искусств под одним вождём ¦ die Kampfkunstwelt unter einem Anführer vereinen ¦ unir le monde martial sous un seul chef ¦ 一统武林
recover the founder's lost sword manual ¦ вернуть утраченный трактат основателя ¦ das verlorene Schwerthandbuch des Gründers zurückgewinnen ¦ retrouver le traité d'épée perdu du fondateur ¦ 寻回祖师失传的剑谱
avenge a massacre twenty years old ¦ отомстить за резню двадцатилетней давности ¦ ein zwanzig Jahre altes Massaker rächen ¦ venger un massacre vieux de vingt ans ¦ 为二十年前的灭门惨案复仇
overthrow the corrupt court ¦ свергнуть продажный двор ¦ den korrupten Hof stürzen ¦ renverser la cour corrompue ¦ 推翻腐败的朝廷
achieve immortality through inner alchemy ¦ достичь бессмертия через внутреннюю алхимию ¦ durch innere Alchemie Unsterblichkeit erlangen ¦ atteindre l'immortalité par l'alchimie intérieure ¦ 以内丹之术求得长生
protect common folk from bandits and officials alike ¦ защищать простой народ и от разбойников, и от чиновников ¦ das einfache Volk vor Banditen wie Beamten schützen ¦ protéger le peuple des bandits comme des fonctionnaires ¦ 保护百姓免受盗匪与贪官之苦
control the salt trade along the river ¦ контролировать соляную торговлю вдоль реки ¦ den Salzhandel entlang des Flusses kontrollieren ¦ contrôler le commerce du sel le long du fleuve ¦ 控制沿河的盐运
destroy the demonic cult forever ¦ навсегда уничтожить демонический культ ¦ den Dämonenkult für immer vernichten ¦ détruire à jamais le culte démoniaque ¦ 彻底剿灭魔教
''',
  'faction_method': '''
martial contests with deadly stakes ¦ боевые состязания со смертельными ставками ¦ Kampfturniere mit tödlichem Einsatz ¦ des tournois martiaux aux enjeux mortels ¦ 以性命为注的比武
poisons that leave no trace ¦ яды, не оставляющие следов ¦ Gifte, die keine Spur hinterlassen ¦ des poisons qui ne laissent aucune trace ¦ 不留痕迹的毒药
spies among the beggars and servants ¦ шпионы среди нищих и слуг ¦ Spione unter Bettlern und Dienern ¦ des espions parmi les mendiants et les serviteurs ¦ 安插在乞丐和仆役中的眼线
marriage alliances between sects ¦ брачные союзы между школами ¦ Heiratsbündnisse zwischen Sekten ¦ des alliances matrimoniales entre sectes ¦ 门派之间的联姻
silver paid to magistrates ¦ серебро, выплаченное судьям ¦ an Präfekten gezahltes Silber ¦ de l'argent versé aux magistrats ¦ 送给官员的银子
disciples planted in rival schools ¦ ученики, внедрённые в соперничающие школы ¦ in rivalisierende Schulen eingeschleuste Schüler ¦ des disciples infiltrés dans les écoles rivales ¦ 安插在对手门派中的弟子
ancient formations that trap intruders ¦ древние построения, ловящие незваных гостей ¦ uralte Formationen, die Eindringlinge fangen ¦ des formations anciennes qui piègent les intrus ¦ 困住入侵者的上古阵法
patience, secrecy and a single perfect strike ¦ терпение, тайна и один идеальный удар ¦ Geduld, Geheimhaltung und ein einziger vollkommener Schlag ¦ patience, secret et un unique coup parfait ¦ 耐心、隐秘和完美的一击
''',
  'faction_symbol': '''
a sword piercing a cloud ¦ меч, пронзающий облако ¦ ein Schwert, das eine Wolke durchbohrt ¦ une épée transperçant un nuage ¦ 刺穿云朵的剑
a red lotus with nine petals ¦ красный лотос с девятью лепестками ¦ ein roter Lotus mit neun Blütenblättern ¦ un lotus rouge à neuf pétales ¦ 九瓣红莲
a crane standing on one leg ¦ журавль, стоящий на одной ноге ¦ ein Kranich, der auf einem Bein steht ¦ une grue debout sur une patte ¦ 单足而立的仙鹤
a cracked bronze bell ¦ бронзовый колокол с трещиной ¦ eine Bronzeglocke mit einem Riss ¦ une cloche de bronze fêlée ¦ 有裂痕的铜钟
a plum branch in the snow ¦ ветвь сливы в снегу ¦ ein Pflaumenzweig im Schnee ¦ une branche de prunier sous la neige ¦ 雪中梅枝
a yin-yang circle split by a blade ¦ круг инь-ян, рассечённый клинком ¦ ein Yin-Yang-Kreis, von einer Klinge gespalten ¦ un cercle du yin et du yang fendu par une lame ¦ 被刀刃劈开的阴阳圆
a tiger's head in black ink ¦ голова тигра, нарисованная чёрной тушью ¦ ein Tigerkopf in schwarzer Tusche ¦ une tête de tigre à l'encre noire ¦ 墨绘虎头
a golden dragon coiled around a pearl ¦ золотой дракон, обвивший жемчужину ¦ ein goldener Drache, um eine Perle gewunden ¦ un dragon d'or enroulé autour d'une perle ¦ 盘绕宝珠的金龙
''',
  'weather_sky': '''
mist hangs between the green peaks ¦ туман висит между зелёными пиками ¦ Nebel hängt zwischen den grünen Gipfeln ¦ la brume flotte entre les pics verdoyants ¦ 青峰之间云雾缭绕
spring rain falls soft as silk ¦ весенний дождь падает мягко, как шёлк ¦ Frühlingsregen fällt weich wie Seide ¦ la pluie de printemps tombe douce comme la soie ¦ 春雨如丝般轻落
a full moon over the bamboo forest ¦ полная луна над бамбуковой рощей ¦ ein Vollmond über dem Bambuswald ¦ une pleine lune sur la forêt de bambous ¦ 竹林上空的一轮满月
heavy snow buries the mountain temple ¦ густой снег заваливает горный храм ¦ schwerer Schnee begräbt den Bergtempel ¦ une neige épaisse ensevelit le temple de montagne ¦ 大雪掩埋了山寺
summer thunder rolls across the river ¦ летний гром катится над рекой ¦ Sommerdonner rollt über den Fluss ¦ le tonnerre d'été roule sur le fleuve ¦ 夏雷滚过江面
autumn geese cross a pale sky ¦ осенние гуси пересекают бледное небо ¦ Herbstgänse ziehen über einen blassen Himmel ¦ des oies d'automne traversent un ciel pâle ¦ 秋雁掠过苍白的天空
a red dusk over the desert fortress ¦ красные сумерки над пустынной крепостью ¦ eine rote Dämmerung über der Wüstenfestung ¦ un crépuscule rouge sur la forteresse du désert ¦ 大漠孤城上的血色黄昏
stars bright enough to read a manual by ¦ звёзды так ярки, что при них можно читать трактат ¦ Sterne, hell genug, um ein Handbuch zu lesen ¦ des étoiles assez vives pour lire un manuel ¦ 星光亮得足以读秘籍
''',
  'weather_air': '''
the wind carries the scent of plum blossoms ¦ ветер несёт аромат сливовых цветов ¦ der Wind trägt den Duft von Pflaumenblüten ¦ le vent porte le parfum des fleurs de prunier ¦ 风中飘着梅花香
a killing chill hangs in the still air ¦ в неподвижном воздухе висит смертельный холодок ¦ eine tödliche Kälte hängt in der stillen Luft ¦ un froid meurtrier plane dans l'air immobile ¦ 静止的空气中弥漫着杀气
the humid heat of the southern marshes ¦ влажная жара южных болот ¦ die schwüle Hitze der südlichen Sümpfe ¦ la chaleur moite des marais du Sud ¦ 南方沼泽的湿热
a mountain wind sharp as a sword ¦ горный ветер, острый, как меч ¦ ein Bergwind, scharf wie ein Schwert ¦ un vent de montagne tranchant comme une épée ¦ 如剑般锋利的山风
incense smoke drifts down from the temple ¦ дым благовоний спускается от храма ¦ Weihrauch weht vom Tempel herab ¦ la fumée d'encens descend du temple ¦ 寺庙的香烟飘下山来
the river breeze smells of wine and lanterns ¦ речной ветерок пахнет вином и фонарями ¦ die Flussbrise riecht nach Wein und Laternen ¦ la brise du fleuve sent le vin et les lanternes ¦ 江风里有酒香和灯笼的味道
a dry desert wind scours the caravan road ¦ сухой ветер пустыни метёт караванный путь ¦ trockener Wüstenwind fegt über die Karawanenstraße ¦ le vent sec du désert balaie la route des caravanes ¦ 干燥的风沙刮过商道
so quiet that falling leaves can be heard ¦ так тихо, что слышно, как падают листья ¦ so still, dass man fallende Blätter hört ¦ si calme qu'on entend tomber les feuilles ¦ 静得能听见落叶的声音
''',
  'weather_omen': '''
a white crane circles the peak three times ¦ белый журавль трижды облетает вершину ¦ ein weißer Kranich umkreist dreimal den Gipfel ¦ une grue blanche tourne trois fois autour du sommet ¦ 一只白鹤绕山巅盘旋三圈
the temple bell cracks at dawn ¦ на рассвете трескается храмовый колокол ¦ die Tempelglocke bekommt im Morgengrauen einen Riss ¦ la cloche du temple se fend à l'aube ¦ 寺钟在黎明时裂开
a red-tailed comet crosses the sky ¦ комета с красным хвостом пересекает небо ¦ ein Komet mit rotem Schweif zieht über den Himmel ¦ une comète à la queue rouge traverse le ciel ¦ 一颗红尾彗星划过天际
every sword in the smithy rings at once ¦ все мечи в кузне разом звенят ¦ alle Schwerter in der Schmiede klingen gleichzeitig ¦ toutes les épées de la forge tintent à la fois ¦ 铁匠铺里所有的剑同时鸣响
the river runs clear for the first time in years ¦ река впервые за много лет становится прозрачной ¦ der Fluss wird zum ersten Mal seit Jahren klar ¦ le fleuve redevient limpide pour la première fois depuis des années ¦ 多年来江水第一次变得清澈
plum trees bloom out of season ¦ сливы цветут не в срок ¦ Pflaumenbäume blühen außerhalb der Zeit ¦ les pruniers fleurissent hors saison ¦ 梅树不合时节地开了花
a nine-tailed fox is seen at the crossroads ¦ на перекрёстке видели девятихвостую лису ¦ an der Kreuzung wurde ein neunschwänziger Fuchs gesehen ¦ on a vu un renard à neuf queues au carrefour ¦ 有人在路口看见了九尾狐
the moon turns the color of blood ¦ луна становится цвета крови ¦ der Mond färbt sich blutrot ¦ la lune prend la couleur du sang ¦ 月亮变成了血色
''',
  'rumor_source': '''
a storyteller in the teahouse ¦ сказитель в чайной ¦ ein Geschichtenerzähler im Teehaus ¦ un conteur à la maison de thé ¦ 茶楼里的说书人
a drunk escort guard ¦ пьяный охранник конвоя ¦ ein betrunkener Eskortwächter ¦ un garde d'escorte ivre ¦ 喝醉的镖师
a letter tied to an arrow ¦ письмо, привязанное к стреле ¦ ein an einen Pfeil gebundener Brief ¦ une lettre attachée à une flèche ¦ 绑在箭上的书信
a monk collecting alms ¦ монах, собирающий подаяние ¦ ein Mönch, der Almosen sammelt ¦ un moine qui recueille des aumônes ¦ 化缘的和尚
whispers of the Beggars' Guild ¦ шёпот Союза нищих ¦ das Flüstern der Bettlerzunft ¦ les murmures de la Guilde des mendiants ¦ 丐帮的耳语
a notice posted by the magistrate ¦ объявление, вывешенное судьёй ¦ ein Aushang des Präfekten ¦ un avis affiché par le magistrat ¦ 知府张贴的告示
a boatman on the river ¦ лодочник на реке ¦ ein Fährmann auf dem Fluss ¦ un batelier sur le fleuve ¦ 江上的船夫
a wounded swordsman at the city gate ¦ раненый мечник у городских ворот ¦ ein verwundeter Schwertkämpfer am Stadttor ¦ un épéiste blessé à la porte de la ville ¦ 城门口受伤的剑客
''',
  'rumor_text': '''
the lost sword manual has been seen in the capital ¦ утраченный трактат о мече видели в столице ¦ das verlorene Schwerthandbuch wurde in der Hauptstadt gesehen ¦ on a vu le traité d'épée perdu dans la capitale ¦ 失传的剑谱在京城出现了
the old master of the Iron Sword Manor is not dead ¦ старый хозяин поместья Железного Меча не умер ¦ der alte Meister des Eisenschwert-Anwesens ist nicht tot ¦ le vieux maître du Manoir de l'Épée de fer n'est pas mort ¦ 铁剑山庄的老庄主并没有死
the demonic cult has a spy in every sect ¦ у демонического культа есть шпион в каждой школе ¦ der Dämonenkult hat in jeder Sekte einen Spion ¦ le culte démoniaque a un espion dans chaque secte ¦ 魔教在每个门派都安插了奸细
a martial contest will choose the new alliance leader ¦ турнир решит, кто станет новым главой союза ¦ ein Kampfturnier wird den neuen Bundesführer bestimmen ¦ un tournoi désignera le nouveau chef de l'alliance ¦ 一场比武将决定新的武林盟主
the emperor is gravely ill and the princes are gathering swords ¦ император тяжело болен, а принцы собирают мечи ¦ der Kaiser ist schwer krank und die Prinzen sammeln Schwerter ¦ l'empereur est gravement malade et les princes rassemblent des épées ¦ 皇帝病重，诸王正在招揽高手
a hermit in the mountains teaches one student a decade ¦ отшельник в горах берёт лишь одного ученика в десятилетие ¦ ein Einsiedler in den Bergen lehrt nur einen Schüler pro Jahrzehnt ¦ un ermite des montagnes n'enseigne qu'à un élève par décennie ¦ 山中隐士十年只收一个徒弟
the escort agency's silver was stolen by ghosts ¦ серебро конвойного бюро украли призраки ¦ das Silber der Eskortagentur wurde von Geistern gestohlen ¦ l'argent de l'agence d'escorte a été volé par des fantômes ¦ 镖局的银子是被鬼偷走的
a poison with no antidote is sold in the market ¦ на рынке продают яд без противоядия ¦ auf dem Markt wird ein Gift ohne Gegengift verkauft ¦ un poison sans antidote se vend au marché ¦ 市集上有人在卖一种无药可解的毒
the abbot of the Silent Bell was once a famous assassin ¦ настоятель монастыря Безмолвного Колокола когда-то был знаменитым убийцей ¦ der Abt der Stummen Glocke war einst ein berühmter Attentäter ¦ l'abbé de la Cloche muette fut jadis un célèbre assassin ¦ 静钟寺方丈曾是一名著名刺客
the waterfall cave holds the tomb of a sword immortal ¦ в пещере за водопадом — гробница бессмертного мечника ¦ in der Wasserfallhöhle liegt das Grab eines Schwertunsterblichen ¦ la grotte de la cascade abrite le tombeau d'un immortel de l'épée ¦ 瀑布后的洞里有剑仙之墓
''',
};

const _pinyinPre = '''
Qingshi
Luoyan
Liuxi
Feilong
Baiyun
Taohua
Duanjian
Qingfeng
Wohu
Cuizhu
''';

const _perLang = <String, Map<String, String>>{
  'en': {
    'est_name': 'The {est_adj} {est_noun} {est_hall}',
    'est_hall': '''
Pavilion
House
Lodge
Tower
Hall
''',
    'settle_name': '{settle_pre} {settle_suf}',
    'settle_pre': '''
Green Stone
Wild Goose
Willow Creek
Flying Dragon
White Cloud
Peach Blossom
Broken Sword
Clear Wind
Sleeping Tiger
Emerald Bamboo
''',
    'settle_suf': '''
Town
Village
City
Ferry
Pass
Stockade
Hollow
Gorge
''',
  },
  'ru': {
    'est_name': '''
«{est_adj_m:cap} {est_noun_m}»
«{est_adj_f:cap} {est_noun_f}»
''',
    'settle_name': '{settle_suf} {settle_pre}',
    'settle_pre': '''
Цинши
Лоянь
Люси
Фэйлун
Байюнь
Таохуа
Дуаньцзянь
Цинфэн
Воху
Цуйчжу
''',
    'settle_suf': '''
Городок
Деревня
Переправа
Застава
Крепость
Долина
''',
  },
  'de': {
    'est_name': '''
Zum {est_adj} {est_noun_m}
Zur {est_adj} {est_noun_f}
''',
    'settle_name': '{settle_suf} {settle_pre}',
    'settle_pre': _pinyinPre,
    'settle_suf': '''
Dorf
Stadt
Fähre
Pass
Festung
Tal
''',
  },
  'fr': {
    'est_name': '''
Au {est_noun_m} {est_adj_m}
À la {est_noun_f} {est_adj_f}
''',
    'settle_name': '{settle_suf} de {settle_pre}',
    'settle_pre': _pinyinPre,
    'settle_suf': '''
Village
Bourg
Cité
Bac
Col
Fort
''',
  },
  'zh': {
    'est_name': '{est_adj}{est_noun}{est_hall}',
    'est_hall': '''
楼
居
阁
轩
馆
''',
    'settle_name': '{settle_pre}{settle_suf}',
    'settle_pre': '''
青石
落雁
柳溪
飞龙
白云
桃花
断剑
清风
卧虎
翠竹
''',
    'settle_suf': '''
镇
村
城
渡
关
寨
坞
峪
''',
  },
};
