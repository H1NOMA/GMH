import '../content_format.dart';

/// Candlelit villages under the count's castle, wolves in the snow.
final gothicHorrorContent =
    PackContent.build(rows: _rows, names: _names, perLang: _perLang);

const _names = <String, String>{
  'noble_given_f': '''
Ilona ¦ Илона ¦ 伊洛娜
Mirela ¦ Мирела ¦ 米雷拉
Katalin ¦ Каталин ¦ 卡塔林
Viorica ¦ Виорика ¦ 维奥丽卡
Ludmila ¦ Людмила ¦ 柳德米拉
Esztera ¦ Эстера ¦ 埃丝特拉
Anastazja ¦ Анастазия ¦ 阿纳斯塔齐娅
Roxana ¦ Роксана ¦ 罗克珊娜
Zorica ¦ Зорица ¦ 佐丽察
Margit ¦ Маргит ¦ 玛吉特
Elisabeta ¦ Элизабета ¦ 伊丽莎贝塔
Sidonia ¦ Сидония ¦ 西多妮娅
''',
  'noble_given_m': '''
Vasile ¦ Василе ¦ 瓦西里
Lucian ¦ Лучиан ¦ 卢西安
Radu ¦ Раду ¦ 拉杜
Miklos ¦ Миклош ¦ 米克洛斯
Casimir ¦ Казимир ¦ 卡齐米尔
Dorian ¦ Дориан ¦ 多里安
Ferenc ¦ Ференц ¦ 费伦茨
Octavian ¦ Октавиан ¦ 奥克塔维安
Stanislav ¦ Станислав ¦ 斯坦尼斯拉夫
Bogdan ¦ Богдан ¦ 博格丹
Anton ¦ Антон ¦ 安东
Valeriu ¦ Валериу ¦ 瓦莱里乌
''',
  'noble_family': '''
Moroianu ¦ Мороиану ¦ 莫罗亚努
Draskovar ¦ Драсковар ¦ 德拉斯科瓦尔
Valcescu ¦ Вальческу ¦ 瓦尔切斯库
Szentmarai ¦ Сентмараи ¦ 圣特马赖
Harkanyi ¦ Харкани ¦ 哈尔卡尼
Corvinescu ¦ Корвинеску ¦ 科尔维内斯库
Nagyvari ¦ Надьвари ¦ 纳吉瓦里
Rakosfalvy ¦ Ракошфальви ¦ 拉科什法尔维
Grimaldescu ¦ Гримальдеску ¦ 格里马尔代斯库
Lupescu ¦ Лупеску ¦ 卢佩斯库
Albescu ¦ Альбеску ¦ 阿尔贝斯库
Mardaros ¦ Мардарош ¦ 马尔达罗什
''',
  'village_given_f': '''
Anka ¦ Анка ¦ 安卡
Grete ¦ Грете ¦ 格蕾特
Resi ¦ Рези ¦ 蕾西
Milena ¦ Милена ¦ 米莲娜
Dorota ¦ Дорота ¦ 多罗塔
Hanne ¦ Ханне ¦ 汉娜
Marta ¦ Марта ¦ 玛尔塔
Zuzana ¦ Зузана ¦ 苏萨娜
Bettina ¦ Беттина ¦ 贝蒂娜
Irka ¦ Ирка ¦ 伊尔卡
Agata ¦ Агата ¦ 阿加塔
Klara ¦ Клара ¦ 克拉拉
''',
  'village_given_m': '''
Jakob ¦ Якоб ¦ 雅各布
Pavel ¦ Павел ¦ 帕维尔
Hannes ¦ Ханнес ¦ 汉内斯
Tibor ¦ Тибор ¦ 蒂博尔
Janek ¦ Янек ¦ 亚内克
Matthias ¦ Маттиас ¦ 马蒂亚斯
Oskar ¦ Оскар ¦ 奥斯卡
Florin ¦ Флорин ¦ 弗洛林
Emil ¦ Эмиль ¦ 埃米尔
Wenzel ¦ Венцель ¦ 文策尔
Gregor ¦ Грегор ¦ 格雷戈尔
Ondrej ¦ Ондрей ¦ 翁德雷
''',
  'village_family': '''
Kovac ¦ Ковач ¦ 科瓦奇
Müller ¦ Мюллер ¦ 穆勒
Holzer ¦ Хольцер ¦ 霍尔策
Schenk ¦ Шенк ¦ 申克
Barta ¦ Барта ¦ 巴尔塔
Gerber ¦ Гербер ¦ 格贝尔
Hruby ¦ Груби ¦ 赫鲁比
Lindner ¦ Линднер ¦ 林德纳
Sabo ¦ Сабо ¦ 萨博
Wagner ¦ Вагнер ¦ 瓦格纳
Novotny ¦ Новотны ¦ 诺沃特尼
Fleischer ¦ Флейшер ¦ 弗莱舍
''',
};

const _rows = <String, String>{
  'cultures': '''
@noble Aristocratic ¦ Аристократические ¦ Adelig ¦ Aristocratiques ¦ 贵族
@village Village folk ¦ Деревенские ¦ Dorfleute ¦ Villageois ¦ 村民
''',
  'epithet': '''
the Pale ¦ Бледный~Бледная ¦ der Bleiche~die Bleiche ¦ le Pâle~la Pâle ¦ 苍白者
Graveborn ¦ Рождённый в Могиле~Рождённая в Могиле ¦ der Grabgeborene~die Grabgeborene ¦ Né-de-la-Tombe~Née-de-la-Tombe ¦ 墓生
the Widow-Maker ¦ Творец Вдов ¦ der Witwenmacher~die Witwenmacherin ¦ le Faiseur de Veuves~la Faiseuse de Veuves ¦ 寡妇制造者
Candle-Eyes ¦ Свечные Глаза ¦ Kerzenauge ¦ Yeux-de-Chandelle ¦ 烛眼
the Penitent ¦ Кающийся~Кающаяся ¦ der Büßer~die Büßerin ¦ le Pénitent~la Pénitente ¦ 忏悔者
Wolfsbane ¦ Волчья Отрава ¦ Wolfswurz ¦ Tue-Loup ¦ 狼毒
the Sleepless ¦ Бессонный~Бессонная ¦ der Schlaflose~die Schlaflose ¦ l'Insomniaque ¦ 不眠者
Silver-Tongue ¦ Серебряный Язык ¦ Silberzunge ¦ Langue-d'Argent ¦ 银舌
the Mourner ¦ Плакальщик~Плакальщица ¦ der Trauernde~die Trauernde ¦ le Pleureur~la Pleureuse ¦ 哀悼者
Crowfeather ¦ Воронье Перо ¦ Krähenfeder ¦ Plume-de-Corneille ¦ 鸦羽
''',
  'ancestry': '''
@village villager ¦ деревенский житель~деревенская жительница ¦ Dorfbewohner~Dorfbewohnerin ¦ villageois~villageoise ¦ 村民
@noble minor noble ¦ мелкий дворянин~мелкая дворянка ¦ Landadliger~Landadlige ¦ petit noble~petite noble ¦ 小贵族
@village one of the traveling folk ¦ из бродячего народа ¦ vom fahrenden Volk ¦ gens du voyage ¦ 流浪民
dhampir ¦ дампир ¦ Dhampir~Dhampirin ¦ dhampire ¦ 半吸血鬼
@noble of a cursed bloodline ¦ носитель проклятой крови~носительница проклятой крови ¦ aus verfluchtem Geschlecht ¦ de sang maudit ¦ 受诅血脉
@village wolf-touched ¦ отмеченный волком~отмеченная волком ¦ Wolfsgezeichneter~Wolfsgezeichnete ¦ marqué par le loup~marquée par le loup ¦ 被狼咬过的人
''',
  'role': '''
gravedigger ¦ могильщик~могильщица ¦ Totengräber~Totengräberin ¦ fossoyeur~fossoyeuse ¦ 掘墓人
chapel keeper ¦ смотритель часовни~смотрительница часовни ¦ Kapellenhüter~Kapellenhüterin ¦ gardien de la chapelle~gardienne de la chapelle ¦ 礼拜堂看守
coachman ¦ кучер ¦ Kutscher~Kutscherin ¦ cocher~cochère ¦ 马车夫
castle steward ¦ управляющий замком~управляющая замком ¦ Burgverwalter~Burgverwalterin ¦ intendant du château~intendante du château ¦ 城堡管家
witch-hunter ¦ охотник на ведьм~охотница на ведьм ¦ Hexenjäger~Hexenjägerin ¦ chasseur de sorcières~chasseuse de sorcières ¦ 猎巫人
apothecary ¦ аптекарь ¦ Apotheker~Apothekerin ¦ apothicaire ¦ 药剂师
wolf trapper ¦ охотник на волков~охотница на волков ¦ Wolfsfallensteller~Wolfsfallenstellerin ¦ trappeur de loups~trappeuse de loups ¦ 捕狼人
portrait painter ¦ портретист~портретистка ¦ Porträtmaler~Porträtmalerin ¦ portraitiste ¦ 肖像画家
undertaker ¦ гробовщик~гробовщица ¦ Bestatter~Bestatterin ¦ croque-mort ¦ 殡葬师
village schoolteacher ¦ сельский учитель~сельская учительница ¦ Dorflehrer~Dorflehrerin ¦ instituteur du village~institutrice du village ¦ 乡村教师
bell-ringer ¦ звонарь ¦ Glöckner~Glöcknerin ¦ sonneur de cloches~sonneuse de cloches ¦ 敲钟人
disgraced physician ¦ опальный врач ¦ in Ungnade gefallener Arzt~in Ungnade gefallene Ärztin ¦ médecin déchu~médecin déchue ¦ 声名狼藉的医生
''',
  'appearance': '''
a high collar that never comes down ¦ высокий воротник, который никогда не опускается ¦ ein hoher Kragen, der nie heruntergeklappt wird ¦ un col haut qui ne s'abaisse jamais ¦ 从不放下的高领
a garlic braid worn like a necklace ¦ связка чеснока вместо ожерелья ¦ ein Knoblauchzopf, getragen wie eine Halskette ¦ une tresse d'ail portée en collier ¦ 像项链一样挂着的一串大蒜
black mourning clothes, years out of fashion ¦ чёрный траур, давно вышедший из моды ¦ schwarze Trauerkleidung, seit Jahren aus der Mode ¦ des habits de deuil noirs, démodés depuis des années ¦ 过时多年的黑色丧服
two small scars on the neck ¦ два маленьких шрама на шее ¦ zwei kleine Narben am Hals ¦ deux petites cicatrices au cou ¦ 脖子上两个小小的疤痕
a silver amulet blackened with age ¦ почерневший от времени серебряный оберег ¦ ein vom Alter geschwärztes Silberamulett ¦ une amulette d'argent noircie par les ans ¦ 因年久而发黑的银护符
hands that are always cold ¦ руки, которые всегда холодны ¦ Hände, die immer kalt sind ¦ des mains toujours froides ¦ 一双永远冰冷的手
''',
  'motivation': '''
lift the curse on the family estate ¦ снять проклятие с родового поместья ¦ den Fluch vom Familiengut nehmen ¦ lever la malédiction qui pèse sur le domaine familial ¦ 解除家族庄园上的诅咒
see the count's castle burn ¦ увидеть, как горит замок графа ¦ die Burg des Grafen brennen sehen ¦ voir brûler le château du comte ¦ 亲眼看着伯爵的城堡燃烧
bring a dead sister back, whatever the price ¦ вернуть мёртвую сестру любой ценой ¦ die tote Schwester zurückholen, um jeden Preis ¦ ramener une sœur morte, quel qu'en soit le prix ¦ 不惜任何代价让死去的姐妹复活
leave the valley before next winter ¦ уехать из долины до следующей зимы ¦ das Tal vor dem nächsten Winter verlassen ¦ quitter la vallée avant l'hiver prochain ¦ 在下个冬天之前离开山谷
prove that monsters are real ¦ доказать, что чудовища существуют ¦ beweisen, dass Ungeheuer real sind ¦ prouver que les monstres existent ¦ 证明怪物真实存在
be invited into the castle ¦ получить приглашение в замок ¦ ins Schloss eingeladen werden ¦ être invité au château~être invitée au château ¦ 受邀进入城堡
''',
  'secret': '''
has already been bitten ¦ уже укушен~уже укушена ¦ wurde bereits gebissen ¦ a déjà été mordu~a déjà été mordue ¦ 已经被咬过了
turns into a wolf on moonless nights ¦ в безлунные ночи оборачивается волком ¦ verwandelt sich in mondlosen Nächten in einen Wolf ¦ se change en loup les nuits sans lune ¦ 在无月之夜会变成狼
keeps the count's letters in a locked drawer ¦ хранит письма графа в запертом ящике ¦ bewahrt die Briefe des Grafen in einer verschlossenen Schublade auf ¦ garde les lettres du comte dans un tiroir fermé à clé ¦ 把伯爵的信锁在抽屉里
dug up a grave last spring ¦ прошлой весной раскопал могилу~прошлой весной раскопала могилу ¦ hat letzten Frühling ein Grab ausgehoben ¦ a déterré une tombe au printemps dernier ¦ 去年春天挖开过一座坟
is the old baroness's illegitimate child ¦ незаконный сын старой баронессы~незаконная дочь старой баронессы ¦ ist das uneheliche Kind der alten Baronin ¦ est l'enfant illégitime de la vieille baronne ¦ 是老男爵夫人的私生子
has cast no reflection for years ¦ уже много лет не отражается в зеркалах ¦ hat seit Jahren kein Spiegelbild mehr ¦ n'a plus de reflet depuis des années ¦ 多年来在镜中都没有倒影
''',
  'settle_size': '''
@Village a hamlet of {#2d6*5} frightened souls ¦ хутор на {#2d6*5} запуганных душ ¦ ein Weiler mit {#2d6*5} verängstigten Seelen ¦ un hameau de {#2d6*5} âmes apeurées ¦ {#2d6*5}个惊恐村民的小村落
@Village a village of about {#4d6*15} people ¦ деревня, около {#4d6*15} жителей ¦ ein Dorf mit etwa {#4d6*15} Einwohnern ¦ un village d'environ {#4d6*15} habitants ¦ 约{#4d6*15}人的村庄
@Town a market town of some {#3d6*150} people ¦ торговый городок, около {#3d6*150} жителей ¦ ein Marktstädtchen mit rund {#3d6*150} Einwohnern ¦ un bourg d'environ {#3d6*150} habitants ¦ 约{#3d6*150}人的集镇
@Castle a castle and its village, {#2d6*40} souls ¦ замок с деревней, {#2d6*40} душ ¦ eine Burg samt Dorf, {#2d6*40} Seelen ¦ un château et son village, {#2d6*40} âmes ¦ 一座城堡及其村落，共{#2d6*40}人
''',
  'settle_feature': '''
a church whose bells were melted down for bullets ¦ церковь, чьи колокола переплавили на пули ¦ eine Kirche, deren Glocken zu Kugeln eingeschmolzen wurden ¦ une église dont les cloches ont été fondues en balles ¦ 钟被熔成子弹的教堂
a graveyard larger than the village ¦ кладбище больше самой деревни ¦ ein Friedhof, größer als das Dorf ¦ un cimetière plus grand que le village ¦ 比村子还大的墓地
shutters painted with protective eyes ¦ ставни, расписанные оберегающими глазами ¦ Fensterläden mit aufgemalten Schutzaugen ¦ des volets peints d'yeux protecteurs ¦ 画着护身之眼的百叶窗
a gallows no one will take down ¦ виселица, которую никто не решается снести ¦ ein Galgen, den niemand abbauen will ¦ un gibet que personne n'ose démonter ¦ 没人愿意拆除的绞刑架
a castle visible from every window ¦ замок, видный из каждого окна ¦ eine Burg, die man aus jedem Fenster sieht ¦ un château visible de chaque fenêtre ¦ 从每扇窗都能望见的城堡
a mill that grinds only at night ¦ мельница, что мелет только по ночам ¦ eine Mühle, die nur nachts mahlt ¦ un moulin qui ne moud que la nuit ¦ 只在夜里转动的磨坊
a shrine full of wax hands ¦ часовня, полная восковых рук ¦ ein Schrein voller Wachshände ¦ un sanctuaire rempli de mains en cire ¦ 摆满蜡手的神龛
an inn that bars its doors at sunset ¦ трактир, запирающий двери на закате ¦ ein Gasthaus, das bei Sonnenuntergang verriegelt ¦ une auberge qui barricade ses portes au coucher du soleil ¦ 日落即闩门的客栈
a frozen lake where the drowned can be seen ¦ замёрзшее озеро, подо льдом которого видны утопленники ¦ ein zugefrorener See, unter dessen Eis man Ertrunkene sieht ¦ un lac gelé où l'on aperçoit les noyés ¦ 冰面下能看见溺亡者的湖
a forest where the birds do not sing ¦ лес, где не поют птицы ¦ ein Wald, in dem keine Vögel singen ¦ une forêt où les oiseaux ne chantent pas ¦ 鸟儿不唱歌的森林
''',
  'settle_trouble': '''
children are disappearing from their beds ¦ дети пропадают из своих постелей ¦ Kinder verschwinden aus ihren Betten ¦ des enfants disparaissent de leur lit ¦ 孩子们从床上消失
livestock are found drained of blood ¦ скот находят обескровленным ¦ Vieh wird blutleer aufgefunden ¦ on retrouve le bétail vidé de son sang ¦ 牲畜被发现时血已被吸干
the new count has returned from abroad, unchanged in forty years ¦ новый граф вернулся из-за границы — за сорок лет он не изменился ¦ der neue Graf ist aus der Fremde zurück – in vierzig Jahren unverändert ¦ le nouveau comte est revenu de l'étranger, inchangé en quarante ans ¦ 新伯爵从国外归来——四十年来容貌未改
a wolf pack circles the village every night ¦ волчья стая каждую ночь кружит у деревни ¦ ein Wolfsrudel umkreist jede Nacht das Dorf ¦ une meute de loups encercle le village chaque nuit ¦ 狼群每晚都在村子周围打转
the priest has locked himself in the church ¦ священник заперся в церкви ¦ der Priester hat sich in der Kirche eingeschlossen ¦ le prêtre s'est enfermé dans l'église ¦ 神父把自己锁在了教堂里
a plague of sleepwalking has broken out ¦ началось поветрие лунатизма ¦ eine Seuche des Schlafwandelns ist ausgebrochen ¦ une épidémie de somnambulisme s'est déclarée ¦ 爆发了一场梦游瘟疫
witch trials have begun again ¦ снова начались суды над ведьмами ¦ die Hexenprozesse haben wieder begonnen ¦ les procès de sorcières ont repris ¦ 猎巫审判又开始了
the dead are ringing the cemetery bells ¦ мертвецы звонят в кладбищенские колокольчики ¦ die Toten läuten die Friedhofsglocken ¦ les morts font sonner les clochettes du cimetière ¦ 死人在摇响墓地的铃铛
a stranger in black is buying every mirror ¦ незнакомец в чёрном скупает все зеркала ¦ ein Fremder in Schwarz kauft jeden Spiegel auf ¦ un inconnu en noir achète tous les miroirs ¦ 一个黑衣陌生人在收购所有镜子
the river has run red for three days ¦ река уже три дня течёт красной ¦ der Fluss fließt seit drei Tagen rot ¦ la rivière coule rouge depuis trois jours ¦ 河水已经红了三天
''',
  'settle_authority': '''
a count who is seen only at night ¦ граф, которого видят только по ночам ¦ ein Graf, den man nur nachts sieht ¦ un comte qu'on ne voit que la nuit ¦ 只在夜里现身的伯爵
a burgomaster who drinks to forget ¦ бургомистр, пьющий, чтобы забыть ¦ ein Bürgermeister, der trinkt, um zu vergessen ¦ un bourgmestre qui boit pour oublier ¦ 借酒消愁的镇长
the abbess of a convent with barred windows ¦ настоятельница монастыря с решётками на окнах ¦ die Äbtissin eines Klosters mit vergitterten Fenstern ¦ l'abbesse d'un couvent aux fenêtres grillagées ¦ 窗户装着铁栏的修道院院长
a council of elders who fear everything ¦ совет старейшин, который боится всего ¦ ein Ältestenrat, der alles fürchtet ¦ un conseil d'anciens qui a peur de tout ¦ 什么都怕的长老会
a witch-hunter general with a royal warrant ¦ главный охотник на ведьм с королевским указом ¦ ein Hexenjäger-General mit königlichem Erlass ¦ un chasseur de sorcières en chef muni d'un mandat royal ¦ 持有王室令状的猎巫总长
the widow who owns every house ¦ вдова, которой принадлежат все дома ¦ die Witwe, der jedes Haus gehört ¦ la veuve à qui appartiennent toutes les maisons ¦ 拥有每一栋房子的寡妇
a garrison that no longer believes in anything ¦ гарнизон, который больше ни во что не верит ¦ eine Garnison, die an nichts mehr glaubt ¦ une garnison qui ne croit plus en rien ¦ 什么都不再相信的驻军
an old healer everyone obeys out of fear ¦ старая знахарка, которой все подчиняются из страха ¦ eine alte Heilerin, der alle aus Angst gehorchen ¦ une vieille guérisseuse à qui tous obéissent par peur ¦ 众人因畏惧而听从的老巫医
''',
  'est_type': '''
coaching inn ¦ почтовый постоялый двор ¦ Poststation ¦ relais de poste ¦ 驿站客栈
tavern ¦ корчма ¦ Wirtshaus ¦ taverne ¦ 酒馆
undertaker's parlor ¦ похоронное бюро ¦ Bestattungsinstitut ¦ salon funéraire ¦ 殡仪馆
apothecary ¦ аптека ¦ Apotheke ¦ apothicairerie ¦ 药铺
antiques shop ¦ лавка древностей ¦ Antiquitätenladen ¦ boutique d'antiquités ¦ 古董店
candlemaker's shop ¦ свечная лавка ¦ Kerzenzieherei ¦ chandellerie ¦ 蜡烛铺
''',
  'est_adj': '''
Weeping ¦ плачущий~плачущая ¦ Weinenden ¦ en pleurs ¦ 泣
Hanged ¦ повешенный~повешенная ¦ Gehenkten ¦ pendu~pendue ¦ 吊死
Blind ¦ слепой~слепая ¦ Blinden ¦ aveugle ¦ 盲
Pale ¦ бледный~бледная ¦ Bleichen ¦ pâle ¦ 苍白
Howling ¦ воющий~воющая ¦ Heulenden ¦ hurlant~hurlante ¦ 嚎叫
Forgotten ¦ забытый~забытая ¦ Vergessenen ¦ oublié~oubliée ¦ 被遗忘
Grinning ¦ ухмыляющийся~ухмыляющаяся ¦ Grinsenden ¦ ricanant~ricanante ¦ 狞笑
Bleeding ¦ кровоточащий~кровоточащая ¦ Blutenden ¦ sanglant~sanglante ¦ 淌血
Headless ¦ безголовый~безголовая ¦ Kopflosen ¦ sans tête ¦ 无头
Black ¦ чёрный~чёрная ¦ Schwarzen ¦ noir~noire ¦ 黑
''',
  'est_noun': '''
Raven ¦ ворон#m ¦ Krähe#f ¦ Corbeau#m ¦ 鸦
Bride ¦ невеста#f ¦ Braut#f ¦ Mariée#f ¦ 新娘
Wolf ¦ волк#m ¦ Wolf#m ¦ Loup#m ¦ 狼
Candle ¦ свеча#f ¦ Kerze#f ¦ Chandelle#f ¦ 烛
Bell ¦ колокол#m ¦ Glocke#f ¦ Cloche#f ¦ 钟
Coffin ¦ гроб#m ¦ Sarg#m ¦ Cercueil#m ¦ 棺
Moth ¦ мотылёк#m ¦ Motte#f ¦ Phalène#f ¦ 蛾
Monk ¦ монах#m ¦ Mönch#m ¦ Moine#m ¦ 僧
Rose ¦ роза#f ¦ Rose#f ¦ Rose#f ¦ 玫瑰
Lantern ¦ фонарь#m ¦ Laterne#f ¦ Lanterne#f ¦ 灯
Hound ¦ гончая#f ¦ Hund#m ¦ Chien#m ¦ 猎犬
Widow ¦ вдова#f ¦ Witwe#f ¦ Veuve#f ¦ 寡妇
Goat ¦ козёл#m ¦ Bock#m ¦ Bouc#m ¦ 山羊
''',
  'est_specialty': '''
mulled wine with far too much clove ¦ глинтвейн, в котором слишком много гвоздики ¦ Glühwein mit viel zu viel Nelke ¦ un vin chaud bien trop chargé en clou de girofle ¦ 丁香放太多的热红酒
rooms bolted on the inside and the outside ¦ комнаты с засовами и изнутри, и снаружи ¦ Zimmer mit Riegeln innen und außen ¦ des chambres verrouillées dedans comme dehors ¦ 内外都装着门闩的房间
silver-tipped walking canes ¦ трости с серебряными наконечниками ¦ Spazierstöcke mit Silberspitze ¦ des cannes à pointe d'argent ¦ 银头手杖
holy water sold by the bottle ¦ святая вода в розлив ¦ Weihwasser, flaschenweise verkauft ¦ de l'eau bénite vendue à la bouteille ¦ 按瓶出售的圣水
coffins made to measure, with bells ¦ гробы на заказ, с колокольчиками ¦ Maßsärge, mit Glöckchen ¦ des cercueils sur mesure, avec clochette ¦ 按尺寸定做、带铃铛的棺材
a fortune-teller in the back room ¦ гадалка в задней комнате ¦ eine Wahrsagerin im Hinterzimmer ¦ une diseuse de bonne aventure dans l'arrière-salle ¦ 后屋里的算命女人
goulash that never runs out ¦ гуляш, который никогда не кончается ¦ Gulasch, das nie ausgeht ¦ un goulasch qui ne s'épuise jamais ¦ 永远吃不完的炖牛肉
mirrors covered with black cloth ¦ зеркала, завешенные чёрной тканью ¦ mit schwarzem Tuch verhängte Spiegel ¦ des miroirs voilés de tissu noir ¦ 蒙着黑布的镜子
garlic soup for nervous guests ¦ чесночный суп для нервных гостей ¦ Knoblauchsuppe für nervöse Gäste ¦ une soupe à l'ail pour les clients nerveux ¦ 给紧张客人准备的大蒜汤
portraits whose eyes follow the guests ¦ портреты, чьи глаза следят за гостями ¦ Porträts, deren Augen den Gästen folgen ¦ des portraits dont les yeux suivent les clients ¦ 眼睛会跟着客人转的肖像画
''',
  'est_patron': '''
a nervous notary summoned to read a will at the castle ¦ нервный нотариус, вызванный в замок огласить завещание ¦ ein nervöser Notar, der auf die Burg bestellt wurde, um ein Testament zu verlesen ¦ un notaire nerveux convoqué au château pour lire un testament ¦ 被召去城堡宣读遗嘱的紧张公证人
a monster hunter with more scars than teeth ¦ охотник на чудовищ, у которого шрамов больше, чем зубов ¦ ein Monsterjäger mit mehr Narben als Zähnen ¦ un chasseur de monstres qui a plus de cicatrices que de dents ¦ 伤疤比牙齿还多的猎魔人
a widow who orders two glasses every night ¦ вдова, заказывающая каждый вечер два бокала ¦ eine Witwe, die jeden Abend zwei Gläser bestellt ¦ une veuve qui commande deux verres chaque soir ¦ 每晚都点两杯酒的寡妇
a doctor researching diseases of the blood ¦ врач, изучающий болезни крови ¦ ein Arzt, der Blutkrankheiten erforscht ¦ un médecin qui étudie les maladies du sang ¦ 研究血液疾病的医生
a showman with a caged wolf-man ¦ балаганщик с человеком-волком в клетке ¦ ein Schausteller mit einem Wolfsmenschen im Käfig ¦ un forain qui exhibe un homme-loup en cage ¦ 带着笼中狼人的巡回艺人
a pale guest who never eats ¦ бледный гость, который никогда не ест ¦ ein bleicher Gast, der nie isst ¦ un client pâle qui ne mange jamais ¦ 从不吃东西的苍白客人
a novelist collecting local legends ¦ писательница, собирающая местные легенды ¦ eine Romanautorin, die örtliche Legenden sammelt ¦ une romancière qui recueille les légendes locales ¦ 搜集本地传说的小说家
the castle's coachman, drinking in silence ¦ кучер из замка, молча пьющий в углу ¦ der Kutscher der Burg, der schweigend trinkt ¦ le cocher du château, qui boit en silence ¦ 默默喝酒的城堡马车夫
''',
  'hook_title': '''
The Count's Last Guest ¦ Последний гость графа ¦ Der letzte Gast des Grafen ¦ Le Dernier Invité du comte ¦ 伯爵的最后一位客人
Silver for the Wedding ¦ Серебро к свадьбе ¦ Silber für die Hochzeit ¦ De l'argent pour la noce ¦ 婚礼用的银器
The Portrait Weeps at Midnight ¦ Портрет плачет в полночь ¦ Das Porträt weint um Mitternacht ¦ Le Portrait pleure à minuit ¦ 午夜哭泣的肖像
Nine Nights of Wolves ¦ Девять волчьих ночей ¦ Neun Nächte der Wölfe ¦ Neuf Nuits de loups ¦ 群狼九夜
A Grave Dug Too Early ¦ Могила, вырытая слишком рано ¦ Ein zu früh ausgehobenes Grab ¦ Une tombe creusée trop tôt ¦ 挖得太早的坟墓
The Bride in the Well ¦ Невеста в колодце ¦ Die Braut im Brunnen ¦ La Mariée du puits ¦ 井中新娘
Ashes of Saint Veronika ¦ Пепел святой Вероники ¦ Die Asche der heiligen Veronika ¦ Les Cendres de sainte Veronika ¦ 圣维罗妮卡的骨灰
The House with No Mirrors ¦ Дом без зеркал ¦ Das Haus ohne Spiegel ¦ La Maison sans miroirs ¦ 没有镜子的房子
Blood on the Snow ¦ Кровь на снегу ¦ Blut im Schnee ¦ Du sang sur la neige ¦ 雪上之血
The Hunger Beneath the Chapel ¦ Голод под часовней ¦ Der Hunger unter der Kapelle ¦ La Faim sous la chapelle ¦ 礼拜堂下的饥饿
''',
  'hook_who': '''
a mother whose son came home changed ¦ мать, чей сын вернулся домой другим ¦ eine Mutter, deren Sohn verändert heimkehrte ¦ une mère dont le fils est revenu changé ¦ 儿子回家后变了样的母亲
a young noblewoman betrothed to the count ¦ юная дворянка, обручённая с графом ¦ eine junge Adlige, die dem Grafen versprochen ist ¦ une jeune noble promise au comte ¦ 与伯爵订了婚的年轻贵族小姐
the village priest, shaking ¦ дрожащий деревенский священник ¦ der zitternde Dorfpfarrer ¦ le curé du village, tremblant ¦ 浑身发抖的乡村神父
a gravedigger who found an empty coffin ¦ могильщик, нашедший пустой гроб ¦ ein Totengräber, der einen leeren Sarg gefunden hat ¦ un fossoyeur qui a trouvé un cercueil vide ¦ 发现了一口空棺材的掘墓人
a scholar from the university ¦ учёный из университета ¦ ein Gelehrter von der Universität ¦ un érudit de l'université ¦ 大学来的学者
the count's disinherited brother ¦ лишённый наследства брат графа ¦ der enterbte Bruder des Grafen ¦ le frère déshérité du comte ¦ 被剥夺继承权的伯爵之弟
a werewolf who wants to be cured ¦ оборотень, желающий исцелиться ¦ ein Werwolf, der geheilt werden will ¦ un loup-garou qui veut guérir ¦ 想被治愈的狼人
a ghost who does not know she is dead ¦ призрак женщины, не знающей, что она мертва ¦ ein Geist, der nicht weiß, dass sie tot ist ¦ un fantôme qui ignore qu'elle est morte ¦ 不知道自己已死的女鬼
the innkeeper's frightened daughter ¦ испуганная дочь трактирщика ¦ die verängstigte Tochter des Wirts ¦ la fille apeurée de l'aubergiste ¦ 客栈老板受惊的女儿
an old witch-hunter with one last case ¦ старый охотник на ведьм с последним делом ¦ ein alter Hexenjäger mit einem letzten Fall ¦ un vieux chasseur de sorcières avec une dernière affaire ¦ 还剩最后一桩案子的老猎巫人
''',
  'hook_wants': '''
find out what walks the cemetery at night ¦ выяснить, что бродит по кладбищу по ночам ¦ herausfinden, was nachts über den Friedhof geht ¦ découvrir ce qui rôde la nuit au cimetière ¦ 查明夜里在墓地游荡的是什么
deliver a letter to the castle and return alive ¦ доставить письмо в замок и вернуться живыми ¦ einen Brief zur Burg bringen und lebend zurückkehren ¦ porter une lettre au château et en revenir vivant ¦ 把信送进城堡并活着回来
break an engagement before the wedding night ¦ расстроить помолвку до брачной ночи ¦ eine Verlobung vor der Hochzeitsnacht lösen ¦ rompre des fiançailles avant la nuit de noces ¦ 在新婚之夜前解除婚约
lay a restless spirit to rest ¦ упокоить беспокойный дух ¦ einen ruhelosen Geist zur Ruhe betten ¦ apaiser un esprit sans repos ¦ 让一个不安的亡魂安息
recover a relic stolen from the chapel ¦ вернуть реликвию, украденную из часовни ¦ eine aus der Kapelle gestohlene Reliquie zurückholen ¦ récupérer une relique volée dans la chapelle ¦ 找回从礼拜堂被盗的圣物
hunt the beast before the full moon ¦ выследить зверя до полнолуния ¦ die Bestie vor dem Vollmond zur Strecke bringen ¦ traquer la bête avant la pleine lune ¦ 在满月前猎杀那头野兽
save an accused witch from the pyre ¦ спасти обвинённую ведьму от костра ¦ eine angeklagte Hexe vor dem Scheiterhaufen retten ¦ sauver une sorcière accusée du bûcher ¦ 把被指控的女巫从火刑架上救下
learn what happened to the last expedition ¦ узнать, что случилось с прошлой экспедицией ¦ herausfinden, was mit der letzten Expedition geschah ¦ découvrir ce qu'il est advenu de la dernière expédition ¦ 查清上一支探险队的遭遇
survive one night in the abandoned manor ¦ пережить одну ночь в заброшенной усадьбе ¦ eine Nacht im verlassenen Herrenhaus überleben ¦ survivre une nuit dans le manoir abandonné ¦ 在废弃庄园里熬过一夜
destroy a cursed painting ¦ уничтожить проклятую картину ¦ ein verfluchtes Gemälde zerstören ¦ détruire un tableau maudit ¦ 毁掉一幅被诅咒的画
''',
  'hook_obstacle': '''
the villagers will not let the party leave after dark ¦ деревенские не выпускают героев после заката ¦ die Dorfbewohner lassen die Gruppe nach Einbruch der Dunkelheit nicht fort ¦ les villageois empêchent le groupe de sortir après la tombée de la nuit ¦ 村民们天黑后不让队伍离开
the count has invited them to dinner first ¦ граф сперва пригласил их на ужин ¦ der Graf hat sie zuerst zum Abendessen eingeladen ¦ le comte les a d'abord invités à dîner ¦ 伯爵先邀请他们共进晚餐
the snow has closed the pass ¦ снег закрыл перевал ¦ der Schnee hat den Pass geschlossen ¦ la neige a fermé le col ¦ 大雪封住了山口
the church refuses any help ¦ церковь отказывает в любой помощи ¦ die Kirche verweigert jede Hilfe ¦ l'Église refuse toute aide ¦ 教会拒绝提供任何帮助
one of the party starts dreaming the monster's dreams ¦ одному из героев начинают сниться сны чудовища ¦ einer aus der Gruppe beginnt, die Träume des Ungeheuers zu träumen ¦ l'un des héros se met à rêver les rêves du monstre ¦ 队伍中有人开始做怪物的梦
the only silver in town belongs to the count ¦ всё серебро в городе принадлежит графу ¦ das einzige Silber im Ort gehört dem Grafen ¦ le seul argent de la ville appartient au comte ¦ 镇上唯一的银器属于伯爵
a mob with torches is already marching ¦ толпа с факелами уже в пути ¦ ein Mob mit Fackeln ist bereits unterwegs ¦ une foule armée de torches est déjà en marche ¦ 举着火把的暴民已经出发了
every witness has lost their memory ¦ все свидетели потеряли память ¦ alle Zeugen haben ihr Gedächtnis verloren ¦ tous les témoins ont perdu la mémoire ¦ 所有证人都失去了记忆
the house rearranges its rooms at night ¦ по ночам дом переставляет свои комнаты ¦ das Haus ordnet nachts seine Zimmer neu ¦ la maison réarrange ses pièces la nuit ¦ 这座房子夜里会重新排列房间
the victim's family wants no inquiry ¦ семья жертвы не хочет никакого расследования ¦ die Familie des Opfers will keine Untersuchung ¦ la famille de la victime ne veut aucune enquête ¦ 受害者家属不希望调查
''',
  'hook_twist': '''
the monster is the victim's own brother ¦ чудовище — родной брат жертвы ¦ das Ungeheuer ist der eigene Bruder des Opfers ¦ le monstre est le propre frère de la victime ¦ 怪物是受害者的亲兄弟
the count is protecting the village from something worse ¦ граф защищает деревню от чего-то худшего ¦ der Graf beschützt das Dorf vor etwas Schlimmerem ¦ le comte protège le village de quelque chose de pire ¦ 伯爵在保护村子免受更可怕之物的侵害
the priest made the pact ¦ договор заключил священник ¦ der Priester hat den Pakt geschlossen ¦ c'est le prêtre qui a conclu le pacte ¦ 契约是神父立下的
the ghost is trying to warn them ¦ призрак пытается их предупредить ¦ der Geist versucht, sie zu warnen ¦ le fantôme essaie de les prévenir ¦ 鬼魂是想警告他们
the curse ends only when the family line ends ¦ проклятие исчезнет, лишь если прервётся род ¦ der Fluch endet nur, wenn das Geschlecht erlischt ¦ la malédiction ne cessera qu'avec la lignée ¦ 唯有血脉断绝，诅咒才会终结
the village has been dead for a hundred years ¦ деревня мертва уже сто лет ¦ das Dorf ist seit hundert Jahren tot ¦ le village est mort depuis cent ans ¦ 这个村子一百年前就已死去
the hunter they hired is the beast ¦ нанятый ими охотник и есть зверь ¦ der angeheuerte Jäger ist die Bestie ¦ le chasseur engagé est la bête ¦ 他们雇来的猎人就是那头野兽
the bride wants to be turned ¦ невеста хочет, чтобы её обратили ¦ die Braut will verwandelt werden ¦ la mariée veut être transformée ¦ 新娘想要被转化
the painting holds the count's soul ¦ в картине заключена душа графа ¦ das Gemälde birgt die Seele des Grafen ¦ le tableau renferme l'âme du comte ¦ 画中封着伯爵的灵魂
the patron died three days ago ¦ заказчик умер три дня назад ¦ der Auftraggeber ist vor drei Tagen gestorben ¦ le commanditaire est mort il y a trois jours ¦ 委托人三天前就死了
''',
  'loot_container': '''
Offering box from a family crypt ¦ Ящик для подношений из семейного склепа ¦ Opferkasten einer Familiengruft ¦ Tronc d'offrandes d'une crypte familiale ¦ 家族墓穴的供奉箱
Vampire hunter's leather case ¦ Кожаный саквояж охотника на вампиров ¦ Lederkoffer eines Vampirjägers ¦ Malle de cuir d'un chasseur de vampires ¦ 吸血鬼猎人的皮箱
Dead aristocrat's writing desk ¦ Письменный стол покойного аристократа ¦ Schreibtisch eines toten Aristokraten ¦ Secrétaire d'un aristocrate défunt ¦ 已故贵族的写字台
Luggage from an abandoned coach ¦ Багаж из брошенной кареты ¦ Gepäck einer verlassenen Kutsche ¦ Bagages d'une diligence abandonnée ¦ 废弃马车上的行李
Chapel reliquary ¦ Реликварий часовни ¦ Reliquiar der Kapelle ¦ Reliquaire de la chapelle ¦ 礼拜堂圣物匣
Witch's hidden cupboard ¦ Потайной шкаф ведьмы ¦ Geheimschrank einer Hexe ¦ Placard secret d'une sorcière ¦ 女巫的暗柜
Grave robber's sack ¦ Мешок расхитителя могил ¦ Sack eines Grabräubers ¦ Sac d'un pilleur de tombes ¦ 盗墓贼的麻袋
Governess's locked trunk ¦ Запертый сундук гувернантки ¦ Verschlossene Truhe einer Gouvernante ¦ Malle verrouillée d'une gouvernante ¦ 家庭女教师上锁的箱子
''',
  'loot_coin': '''
{#3d6*5} old silver thalers ¦ старинные серебряные талеры: {#3d6*5} ¦ {#3d6*5} alte Silbertaler ¦ {#3d6*5} vieux thalers d'argent ¦ {#3d6*5}枚旧银塔勒
{#2d6*10} copper kreuzers and a mourning ring ¦ медные крейцеры ({#2d6*10}) и траурное кольцо ¦ {#2d6*10} Kupferkreuzer und ein Trauerring ¦ {#2d6*10} kreuzers de cuivre et une bague de deuil ¦ {#2d6*10}枚铜克罗伊策和一枚悼念戒指
a purse of {#1d6+1} gold ducats, cold to the touch ¦ кошель с золотыми дукатами ({#1d6+1}), холодными на ощупь ¦ eine Börse mit {#1d6+1} Golddukaten, kalt anzufassen ¦ une bourse de {#1d6+1} ducats d'or, froids au toucher ¦ 一袋{#1d6+1}枚摸起来冰凉的金杜卡特
a bundle of banknotes worth {#4d6*10} florins ¦ пачка банкнот на {#4d6*10} флоринов ¦ ein Bündel Banknoten im Wert von {#4d6*10} Gulden ¦ une liasse de billets valant {#4d6*10} florins ¦ 一叠价值{#4d6*10}弗罗林的钞票
''',
  'loot_item': '''
silver bullets ×{#1d6+1} ¦ серебряные пули ×{#1d6+1} ¦ Silberkugeln ×{#1d6+1} ¦ balles d'argent ×{#1d6+1} ¦ 银弹 ×{#1d6+1}
an uncorked vial of holy water ¦ откупоренный флакон святой воды ¦ ein entkorktes Fläschchen Weihwasser ¦ une fiole d'eau bénite débouchée ¦ 已开塞的圣水瓶
wooden stakes ×{#1d4+1} ¦ осиновые колья ×{#1d4+1} ¦ Holzpflöcke ×{#1d4+1} ¦ pieux de bois ×{#1d4+1} ¦ 木桩 ×{#1d4+1}
a family prayer book with pages glued together ¦ семейный молитвенник со склеенными страницами ¦ ein Familiengebetbuch mit verklebten Seiten ¦ un livre de prières familial aux pages collées ¦ 书页被粘住的家族祈祷书
a flintlock pistol with a cracked stock ¦ кремнёвый пистолет с треснувшим ложем ¦ eine Steinschlosspistole mit gesprungenem Schaft ¦ un pistolet à silex à la crosse fendue ¦ 枪托开裂的燧发手枪
garlic bulbs ×{#2d6} ¦ головки чеснока ×{#2d6} ¦ Knoblauchknollen ×{#2d6} ¦ têtes d'ail ×{#2d6} ¦ 大蒜 ×{#2d6}
a velvet mask with no eyeholes ¦ бархатная маска без прорезей для глаз ¦ eine Samtmaske ohne Augenlöcher ¦ un masque de velours sans trous pour les yeux ¦ 没有眼孔的天鹅绒面具
bottles of laudanum ×{#1d4+1} ¦ флаконы лауданума ×{#1d4+1} ¦ Laudanumfläschchen ×{#1d4+1} ¦ flacons de laudanum ×{#1d4+1} ¦ 鸦片酊 ×{#1d4+1}
a tarnished silver hand mirror ¦ потускневшее серебряное ручное зеркальце ¦ ein angelaufener silberner Handspiegel ¦ un miroir à main en argent terni ¦ 失去光泽的银手镜
a diary ending mid-sentence ¦ дневник, обрывающийся на полуслове ¦ ein Tagebuch, das mitten im Satz endet ¦ un journal qui s'arrête au milieu d'une phrase ¦ 在半句话处中断的日记
candles of black wax ×{#1d6+1} ¦ свечи из чёрного воска ×{#1d6+1} ¦ Kerzen aus schwarzem Wachs ×{#1d6+1} ¦ chandelles de cire noire ×{#1d6+1} ¦ 黑蜡烛 ×{#1d6+1}
a wolf-pelt cloak ¦ плащ из волчьей шкуры ¦ ein Umhang aus Wolfsfell ¦ une cape en peau de loup ¦ 狼皮斗篷
a doctor's bag with a bone saw ¦ докторский саквояж с костяной пилой ¦ eine Arzttasche mit Knochensäge ¦ une trousse de médecin avec une scie à os ¦ 装着骨锯的医生包
a locket holding a lock of red hair ¦ медальон с прядью рыжих волос ¦ ein Medaillon mit einer roten Haarlocke ¦ un médaillon contenant une mèche de cheveux roux ¦ 装着一绺红发的项链坠
bottles of old red wine ×{#1d4+1} ¦ бутылки старого красного вина ×{#1d4+1} ¦ Flaschen alten Rotweins ×{#1d4+1} ¦ bouteilles de vieux vin rouge ×{#1d4+1} ¦ 陈年红酒 ×{#1d4+1}
a sabre engraved with a noble crest ¦ сабля с гравировкой дворянского герба ¦ ein Säbel mit eingraviertem Adelswappen ¦ un sabre gravé d'armoiries nobles ¦ 刻着贵族纹章的军刀
''',
  'loot_curio': '''
a music box that plays a funeral march ¦ музыкальная шкатулка, играющая похоронный марш ¦ eine Spieldose, die einen Trauermarsch spielt ¦ une boîte à musique qui joue une marche funèbre ¦ 奏着葬礼进行曲的八音盒
a century-old portrait of one of the heroes ¦ портрет одного из героев столетней давности ¦ ein hundert Jahre altes Porträt eines Gruppenmitglieds ¦ un portrait vieux d'un siècle représentant l'un des héros ¦ 一幅百年前的肖像，画的竟是队伍中的某人
a child's doll with real teeth ¦ детская кукла с настоящими зубами ¦ eine Kinderpuppe mit echten Zähnen ¦ une poupée d'enfant aux vraies dents ¦ 长着真牙齿的儿童玩偶
a wedding invitation dated fifty years ago ¦ свадебное приглашение пятидесятилетней давности ¦ eine Hochzeitseinladung, vor fünfzig Jahren datiert ¦ une invitation de mariage datée d'il y a cinquante ans ¦ 一张五十年前的婚礼请柬
a key that is always warm ¦ ключ, который всегда тёплый ¦ ein Schlüssel, der immer warm ist ¦ une clé toujours tiède ¦ 一把总是温热的钥匙
a jar holding a heart that still beats ¦ банка с сердцем, которое всё ещё бьётся ¦ ein Glas mit einem Herzen, das noch schlägt ¦ un bocal contenant un cœur qui bat encore ¦ 罐子里一颗仍在跳动的心脏
a lock of hair tied with a black ribbon ¦ прядь волос, перевязанная чёрной лентой ¦ eine Haarlocke mit schwarzem Band ¦ une mèche de cheveux nouée d'un ruban noir ¦ 用黑丝带系着的一绺头发
a pocket watch stopped at midnight ¦ карманные часы, остановившиеся в полночь ¦ eine Taschenuhr, um Mitternacht stehen geblieben ¦ une montre de poche arrêtée à minuit ¦ 停在午夜的怀表
''',
  'faction_noun': '''
@Order Order ¦ Орден ¦ Orden ¦ Ordre ¦ 修会
@Family House ¦ Дом ¦ Haus ¦ Maison ¦ 家族
@Cult Coven ¦ Ковен ¦ Hexenzirkel ¦ Sabbat ¦ 女巫集会
@Order Brotherhood ¦ Братство ¦ Bruderschaft ¦ Confrérie ¦ 兄弟会
@Cult Cult ¦ Культ ¦ Kult ¦ Culte ¦ 邪教
@Other Society ¦ Общество ¦ Gesellschaft ¦ Société ¦ 学会
@Tribe Pack ¦ Стая ¦ Rudel ¦ Meute ¦ 狼群
@Guild Guild ¦ Гильдия ¦ Gilde ¦ Guilde ¦ 行会
''',
  'faction_of': '''
of the Silver Rose ¦ Серебряной Розы ¦ der Silbernen Rose ¦ de la Rose d'argent ¦ 银玫瑰
of the Black Veil ¦ Чёрной Вуали ¦ des Schwarzen Schleiers ¦ du Voile noir ¦ 黑纱
of the Weeping Saint ¦ Плачущей Святой ¦ der Weinenden Heiligen ¦ de la Sainte en pleurs ¦ 泣圣
of the Crimson Chalice ¦ Багровой Чаши ¦ des Purpurnen Kelches ¦ du Calice pourpre ¦ 绯红圣杯
of the Midnight Bell ¦ Полночного Колокола ¦ der Mitternachtsglocke ¦ de la Cloche de minuit ¦ 午夜钟
of the Hollow Moon ¦ Пустой Луны ¦ des Hohlen Mondes ¦ de la Lune creuse ¦ 空月
of Thorn and Ash ¦ Терна и Пепла ¦ von Dorn und Asche ¦ de l'Épine et de la Cendre ¦ 荆棘与灰烬
of the Last Candle ¦ Последней Свечи ¦ der Letzten Kerze ¦ de la Dernière Chandelle ¦ 残烛
of the Pale Hand ¦ Бледной Руки ¦ der Bleichen Hand ¦ de la Main pâle ¦ 苍白之手
of the Wolf Moon ¦ Волчьей Луны ¦ des Wolfsmondes ¦ de la Lune des loups ¦ 狼月
''',
  'faction_goal': '''
end the count's bloodline forever ¦ навсегда прервать род графа ¦ die Blutlinie des Grafen für immer auslöschen ¦ éteindre à jamais la lignée du comte ¦ 永远断绝伯爵的血脉
grant eternal life to its founders ¦ даровать вечную жизнь своим основателям ¦ den eigenen Gründern ewiges Leben schenken ¦ accorder la vie éternelle à ses fondateurs ¦ 赐予创始人永生
keep the old pact with the forest ¦ соблюдать древний договор с лесом ¦ den alten Pakt mit dem Wald wahren ¦ respecter l'ancien pacte avec la forêt ¦ 恪守与森林的古老契约
burn every witch in the province ¦ сжечь всех ведьм провинции ¦ jede Hexe der Provinz verbrennen ¦ brûler toutes les sorcières de la province ¦ 烧死全省的每一个女巫
awaken the saint sleeping under the cathedral ¦ разбудить святого, спящего под собором ¦ den unter der Kathedrale schlafenden Heiligen erwecken ¦ éveiller le saint qui dort sous la cathédrale ¦ 唤醒长眠于大教堂下的圣人
hide the truth about the plague year ¦ скрыть правду о чумном годе ¦ die Wahrheit über das Pestjahr verbergen ¦ cacher la vérité sur l'année de la peste ¦ 掩盖瘟疫之年的真相
cure lycanthropy, whatever the cost ¦ исцелить ликантропию любой ценой ¦ die Lykanthropie heilen, koste es, was es wolle ¦ guérir la lycanthropie, coûte que coûte ¦ 不惜一切代价治愈狼化症
restore the old nobility to power ¦ вернуть власть старой знати ¦ den alten Adel wieder an die Macht bringen ¦ rendre le pouvoir à l'ancienne noblesse ¦ 让旧贵族重掌大权
''',
  'faction_method': '''
masked balls where deals are sealed in blood ¦ балы-маскарады, где сделки скрепляют кровью ¦ Maskenbälle, auf denen Abmachungen mit Blut besiegelt werden ¦ des bals masqués où les accords se scellent dans le sang ¦ 以血为盟的假面舞会
confessions overheard and remembered ¦ подслушанные и запомненные исповеди ¦ belauschte und gemerkte Beichten ¦ des confessions surprises et retenues ¦ 偷听并记下的告解
poison administered as medicine ¦ яд под видом лекарства ¦ Gift, verabreicht als Medizin ¦ du poison administré comme remède ¦ 以药为名下的毒
debts collected at midnight ¦ долги, взыскиваемые в полночь ¦ Schulden, die um Mitternacht eingetrieben werden ¦ des dettes recouvrées à minuit ¦ 午夜时分上门讨债
witch trials staged for profit ¦ суды над ведьмами ради наживы ¦ Hexenprozesse, inszeniert aus Profitgier ¦ des procès de sorcières montés par intérêt ¦ 为牟利而操纵的猎巫审判
wolves that answer to a whistle ¦ волки, откликающиеся на свист ¦ Wölfe, die auf einen Pfiff hören ¦ des loups qui répondent à un sifflet ¦ 听哨声行事的狼群
marriages arranged across generations ¦ браки, устроенные через поколения ¦ über Generationen arrangierte Ehen ¦ des mariages arrangés au fil des générations ¦ 跨越世代的包办婚姻
patience, darkness and old money ¦ терпение, тьма и старые деньги ¦ Geduld, Dunkelheit und altes Geld ¦ la patience, les ténèbres et le vieil argent ¦ 耐心、黑暗与祖传的财富
''',
  'faction_symbol': '''
a rose growing through a skull ¦ роза, прорастающая сквозь череп ¦ eine Rose, die durch einen Schädel wächst ¦ une rose qui pousse à travers un crâne ¦ 穿颅而生的玫瑰
a bat with a key in its claws ¦ летучая мышь с ключом в когтях ¦ eine Fledermaus mit einem Schlüssel in den Klauen ¦ une chauve-souris tenant une clé ¦ 爪中握着钥匙的蝙蝠
a silver nail through a heart ¦ серебряный гвоздь, пронзающий сердце ¦ ein Silbernagel durch ein Herz ¦ un clou d'argent à travers un cœur ¦ 穿透心脏的银钉
a wolf's head crowned with thorns ¦ волчья голова в терновом венце ¦ ein Wolfskopf mit Dornenkrone ¦ une tête de loup couronnée d'épines ¦ 戴荆棘冠的狼首
a black candle with a white flame ¦ чёрная свеча с белым пламенем ¦ eine schwarze Kerze mit weißer Flamme ¦ une chandelle noire à la flamme blanche ¦ 燃着白焰的黑蜡烛
a closed eye weeping blood ¦ закрытый глаз, плачущий кровью ¦ ein geschlossenes Auge, das Blut weint ¦ un œil fermé qui pleure du sang ¦ 流着血泪的闭眼
a chalice with a serpent handle ¦ чаша с ручкой в виде змеи ¦ ein Kelch mit Schlangengriff ¦ un calice à anse en forme de serpent ¦ 蛇形柄的圣杯
a broken mirror in a gilded frame ¦ разбитое зеркало в золочёной раме ¦ ein zerbrochener Spiegel in vergoldetem Rahmen ¦ un miroir brisé dans un cadre doré ¦ 镀金框里的碎镜
''',
  'weather_sky': '''
a fat yellow moon hangs over the castle ¦ жирная жёлтая луна висит над замком ¦ ein dicker gelber Mond hängt über der Burg ¦ une grosse lune jaune pend au-dessus du château ¦ 一轮肥大的黄月悬在城堡上空
heavy clouds swallow the last of the daylight ¦ тяжёлые тучи поглощают остатки дневного света ¦ schwere Wolken verschlucken das letzte Tageslicht ¦ de lourds nuages avalent les dernières lueurs du jour ¦ 厚重的云吞没了最后的天光
freezing rain turns the road to glass ¦ ледяной дождь превращает дорогу в стекло ¦ Eisregen verwandelt die Straße in Glas ¦ une pluie verglaçante change la route en verre ¦ 冻雨把道路变成了玻璃
a thunderstorm breaks over the graveyard ¦ над кладбищем разражается гроза ¦ ein Gewitter bricht über dem Friedhof los ¦ un orage éclate au-dessus du cimetière ¦ 雷暴在墓地上空炸开
fog rises from the river like breath ¦ туман поднимается от реки, как дыхание ¦ Nebel steigt wie Atem vom Fluss auf ¦ le brouillard monte de la rivière comme un souffle ¦ 雾气像呼吸一样从河面升起
the sky is the color of a bruise ¦ небо цвета синяка ¦ der Himmel hat die Farbe eines Blutergusses ¦ le ciel a la couleur d'une ecchymose ¦ 天空是瘀青的颜色
snow falls without a sound ¦ снег падает без единого звука ¦ Schnee fällt ohne einen Laut ¦ la neige tombe sans un bruit ¦ 雪无声地落下
a blood-red dusk lingers far too long ¦ кроваво-красные сумерки длятся слишком долго ¦ eine blutrote Dämmerung hält viel zu lange an ¦ un crépuscule rouge sang s'attarde bien trop longtemps ¦ 血红的黄昏迟迟不肯退去
''',
  'weather_air': '''
the wind carries the howling of wolves ¦ ветер доносит волчий вой ¦ der Wind trägt Wolfsgeheul heran ¦ le vent porte le hurlement des loups ¦ 风中传来狼嚎
the air smells of wet earth and candle wax ¦ воздух пахнет сырой землёй и свечным воском ¦ die Luft riecht nach nasser Erde und Kerzenwachs ¦ l'air sent la terre mouillée et la cire ¦ 空气中弥漫着湿土与烛蜡的气味
a bone-deep chill no fire can chase away ¦ холод до костей, который не прогнать никаким огнём ¦ eine Kälte bis ins Mark, die kein Feuer vertreibt ¦ un froid qui transperce les os et qu'aucun feu ne chasse ¦ 任何火焰都驱散不了的刺骨寒意
the silence is so deep that heartbeats echo ¦ тишина так глубока, что слышно биение сердец ¦ die Stille ist so tief, dass Herzschläge hallen ¦ le silence est si profond que les cœurs résonnent ¦ 寂静得能听见心跳的回响
a damp wind rattles every shutter ¦ сырой ветер гремит всеми ставнями ¦ ein feuchter Wind rüttelt an jedem Fensterladen ¦ un vent humide fait claquer chaque volet ¦ 潮湿的风把每扇百叶窗都摇得哐哐响
the air tastes of iron ¦ воздух отдаёт железом ¦ die Luft schmeckt nach Eisen ¦ l'air a un goût de fer ¦ 空气里有股铁锈味
church incense drifts from nowhere ¦ неведомо откуда тянет церковным ладаном ¦ Kirchenweihrauch weht von nirgendwoher ¦ un parfum d'encens flotte, venu de nulle part ¦ 不知从何处飘来教堂的香火味
frost creeps up the windows in the shape of hands ¦ иней ползёт по окнам в форме ладоней ¦ der Frost kriecht in Form von Händen die Fenster hinauf ¦ le givre monte sur les vitres en forme de mains ¦ 霜花以手的形状爬上窗户
''',
  'weather_omen': '''
a black dog follows the party at a distance ¦ чёрный пёс держится за героями на расстоянии ¦ ein schwarzer Hund folgt der Gruppe in einigem Abstand ¦ un chien noir suit le groupe à distance ¦ 一条黑狗远远地跟着队伍
the church clock strikes thirteen ¦ церковные часы бьют тринадцать ¦ die Kirchturmuhr schlägt dreizehn ¦ l'horloge de l'église sonne treize coups ¦ 教堂的钟敲了十三下
all the candles gutter at once ¦ все свечи разом начинают трепетать ¦ alle Kerzen flackern gleichzeitig ¦ toutes les chandelles vacillent en même temps ¦ 所有蜡烛同时摇曳欲灭
bats fly in daylight ¦ летучие мыши летают при свете дня ¦ Fledermäuse fliegen bei Tageslicht ¦ des chauves-souris volent en plein jour ¦ 蝙蝠在白天飞舞
a mirror cracks in the inn ¦ в трактире трескается зеркало ¦ im Gasthaus springt ein Spiegel ¦ un miroir se fend à l'auberge ¦ 客栈里一面镜子裂开了
the horses refuse to go any further ¦ лошади отказываются идти дальше ¦ die Pferde weigern sich weiterzugehen ¦ les chevaux refusent d'avancer ¦ 马匹拒绝再往前走
a funeral procession passes with no mourners ¦ проходит похоронная процессия без скорбящих ¦ ein Trauerzug ohne Trauernde zieht vorüber ¦ un cortège funèbre passe sans endeuillés ¦ 一支没有送葬者的出殡队伍经过
someone knocks three times on every door ¦ кто-то трижды стучит в каждую дверь ¦ jemand klopft dreimal an jede Tür ¦ quelqu'un frappe trois coups à chaque porte ¦ 有人在每扇门上都敲了三下
''',
  'rumor_source': '''
the gravedigger, over his fourth drink ¦ могильщик за четвёртой рюмкой ¦ der Totengräber beim vierten Schnaps ¦ le fossoyeur, à son quatrième verre ¦ 喝到第四杯的掘墓人
a fortune-teller's cards ¦ карты гадалки ¦ die Karten einer Wahrsagerin ¦ les cartes d'une diseuse de bonne aventure ¦ 算命女人的纸牌
a scullery maid from the castle ¦ судомойка из замка ¦ eine Küchenmagd aus der Burg ¦ une fille de cuisine du château ¦ 城堡里的洗碗女仆
the priest's sermon, between the lines ¦ проповедь священника, между строк ¦ die Predigt des Priesters, zwischen den Zeilen ¦ le sermon du prêtre, entre les lignes ¦ 神父布道的言外之意
a peddler of charms ¦ торговец оберегами ¦ ein Amuletthändler ¦ un colporteur d'amulettes ¦ 贩卖护身符的货郎
old women at the well ¦ старухи у колодца ¦ alte Frauen am Brunnen ¦ les vieilles au puits ¦ 井边的老妇人们
a coachman who will not stop after dark ¦ кучер, который не останавливается после заката ¦ ein Kutscher, der nach Einbruch der Dunkelheit nicht anhält ¦ un cocher qui refuse de s'arrêter après la nuit tombée ¦ 天黑后拒绝停车的马车夫
a letter slipped under the door at night ¦ письмо, подсунутое ночью под дверь ¦ ein nachts unter der Tür durchgeschobener Brief ¦ une lettre glissée sous la porte pendant la nuit ¦ 夜里被塞进门缝的信
''',
  'rumor_text': '''
the count has been seen in two places at once ¦ графа видели в двух местах одновременно ¦ man hat den Grafen an zwei Orten zugleich gesehen ¦ on a vu le comte en deux endroits à la fois ¦ 有人同时在两个地方看到了伯爵
the miller's wife died last winter and still bakes bread ¦ жена мельника умерла прошлой зимой — и всё ещё печёт хлеб ¦ die Frau des Müllers starb letzten Winter und backt noch immer Brot ¦ la femme du meunier est morte l'hiver dernier et fait toujours le pain ¦ 磨坊主的妻子去年冬天就死了，却还在烤面包
there is a second graveyard under the first ¦ под кладбищем есть второе кладбище ¦ unter dem Friedhof liegt ein zweiter ¦ il y a un second cimetière sous le premier ¦ 墓地下面还有一座墓地
the wolves only kill those who lie ¦ волки убивают лишь тех, кто лжёт ¦ die Wölfe töten nur Lügner ¦ les loups ne tuent que ceux qui mentent ¦ 狼只杀说谎的人
the old abbess is over two hundred years old ¦ старой настоятельнице больше двухсот лет ¦ die alte Äbtissin ist über zweihundert Jahre alt ¦ la vieille abbesse a plus de deux cents ans ¦ 老院长已经两百多岁了
the doctor pays well for fresh corpses ¦ доктор хорошо платит за свежие трупы ¦ der Doktor zahlt gut für frische Leichen ¦ le docteur paie bien les cadavres frais ¦ 医生出高价收购新鲜尸体
the count's portrait was painted after his death ¦ портрет графа написан после его смерти ¦ das Porträt des Grafen wurde nach seinem Tod gemalt ¦ le portrait du comte a été peint après sa mort ¦ 伯爵的肖像是在他死后画的
whoever drinks from the chapel well sees the future ¦ кто выпьет из колодца при часовне, увидит будущее ¦ wer aus dem Kapellenbrunnen trinkt, sieht die Zukunft ¦ quiconque boit au puits de la chapelle voit l'avenir ¦ 喝了礼拜堂井水的人能看见未来
a new witch-hunter arrives next week ¦ на следующей неделе приедет новый охотник на ведьм ¦ nächste Woche kommt ein neuer Hexenjäger ¦ un nouveau chasseur de sorcières arrive la semaine prochaine ¦ 下周会来一位新的猎巫人
the church bells were cast from stolen silver ¦ церковные колокола отлиты из краденого серебра ¦ die Kirchenglocken wurden aus gestohlenem Silber gegossen ¦ les cloches de l'église ont été fondues dans de l'argent volé ¦ 教堂的钟是用偷来的银铸成的
''',
};

const _perLang = <String, Map<String, String>>{
  'en': {
    'settle_pre': '''
Grim
Raven
Mourn
Black
Wolf
Ash
Cold
Hollow
Bleak
Thorn
''',
    'settle_suf': '''
moor
vale
wood
holt
stead
ford
barrow
gate
''',
  },
  'ru': {
    'settle_pre': '''
Черно
Волко
Вороно
Тёмно
Криво
Мрако
Туманно
Горе
''',
    'settle_suf': '''
лесье
дол
горье
мостье
бор
топье
''',
  },
  'de': {
    'settle_pre': '''
Raben
Wolfs
Grau
Schwarz
Nebel
Dunkel
Kalt
Dorn
Schatten
Toten
''',
    'settle_suf': '''
stein
tal
grund
wald
burg
heim
ried
''',
  },
  'fr': {
    'settle_pre': '''
Noir
Sombre
Brume
Froid
Gris
Pâle
Ronce
Cendre
''',
    'settle_suf': '''
val
bois
mont
lande
fosse
combe
''',
  },
  'zh': {
    'settle_pre': '''
黑鸦
狼嚎
雾
枯木
寒
灰
荆棘
苍白
''',
    'settle_suf': '''
镇
村
岭
谷
堡
坡
''',
  },
};
