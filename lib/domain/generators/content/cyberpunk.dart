import '../content_format.dart';

/// Neon, chrome and corporate rain.
final cyberpunkContent =
    PackContent.build(rows: _rows, names: _names, perLang: _perLang);

const _names = <String, String>{
  'handle_given': '''
Glitch ¦ Глитч ¦ 故障
Static ¦ Статик ¦ 静电
Nyx ¦ Никс ¦ 尼克丝
Razorwire ¦ Рейзорвайр ¦ 刀网
Ghostlight ¦ Гостлайт ¦ 鬼火
Patch ¦ Патч ¦ 补丁
Halfbyte ¦ Хафбайт ¦ 半字节
Tinfoil ¦ Тинфойл ¦ 锡纸
Neon Saint ¦ Неон Сейнт ¦ 霓虹圣徒
Chrome Jack ¦ Хром Джек ¦ 铬杰克
Lucky Seven ¦ Лаки Севен ¦ 幸运七
Blackout ¦ Блэкаут ¦ 断电
Wirehead ¦ Вайрхед ¦ 线头
Zero Day ¦ Зеро Дэй ¦ 零日
Kitsune ¦ Кицунэ ¦ 狐仙
Sprocket ¦ Спрокет ¦ 链轮
Dusk ¦ Даск ¦ 黄昏
Lotus Nine ¦ Лотус Найн ¦ 莲花九
''',
  'corp_given_f': '''
Aiko ¦ Айко ¦ 爱子
Valentina ¦ Валентина ¦ 瓦伦蒂娜
Priya ¦ Прия ¦ 普丽娅
Ingrid ¦ Ингрид ¦ 英格丽德
Mei ¦ Мэй ¦ 梅
Sade ¦ Шаде ¦ 莎黛
Camille ¦ Камилла ¦ 卡米耶
Yuna ¦ Юна ¦ 有娜
Noor ¦ Нур ¦ 努尔
Kateryna ¦ Катерина ¦ 卡捷琳娜
Lucía ¦ Люсия ¦ 露西娅
Hana ¦ Хана ¦ 哈娜
Zara ¦ Зара ¦ 扎拉
''',
  'corp_given_m': '''
Kenji ¦ Кэндзи ¦ 健二
Dmitri ¦ Дмитрий ¦ 德米特里
Arjun ¦ Арджун ¦ 阿尔琼
Lukas ¦ Лукас ¦ 卢卡斯
Tomasz ¦ Томаш ¦ 托马什
Wei ¦ Вэй ¦ 伟
Obinna ¦ Обинна ¦ 奥宾纳
Rafael ¦ Рафаэль ¦ 拉斐尔
Soren ¦ Сёрен ¦ 索伦
Hiro ¦ Хиро ¦ 宏
Mateo ¦ Матео ¦ 马特奥
Idris ¦ Идрис ¦ 伊德里斯
Jae-won ¦ Джэвон ¦ 在元
''',
  'corp_family': '''
Albrecht ¦ Альбрехт ¦ 阿尔布雷希特
Oyelaran ¦ Ойеларан ¦ 奥耶拉兰
Takeda ¦ Такэда ¦ 武田
Vasquez ¦ Васкес ¦ 巴斯克斯
Lindqvist ¦ Линдквист ¦ 林奎斯特
Okonkwo ¦ Оконкво ¦ 奥孔科
Castellanos ¦ Кастельянос ¦ 卡斯特利亚诺斯
Nakamura-Reyes ¦ Накамура-Рейес ¦ 中村-雷耶斯
Hartmann ¦ Хартман ¦ 哈特曼
Kowalczyk ¦ Ковальчик ¦ 科瓦尔奇克
Sato-Voss ¦ Сато-Восс ¦ 佐藤-沃斯
Moreau ¦ Моро ¦ 莫罗
Kaur ¦ Каур ¦ 考尔
Zhou ¦ Чжоу ¦ 周
''',
};

const _rows = <String, String>{
  'cultures': '''
@handle Street handles ¦ Уличные клички ¦ Straßennamen ¦ Pseudos de rue ¦ 街头代号
@corp Corporate ¦ Корпоративные ¦ Konzernnamen ¦ Corporatistes ¦ 企业人士
''',
  'epithet': '''
Zero-Latency ¦ Нулевая Задержка ¦ Null-Latenz ¦ Zéro-Latence ¦ 零延迟
the Ghost of Sector Nine ¦ Призрак Девятого сектора ¦ das Gespenst von Sektor Neun ¦ le Fantôme du Secteur Neuf ¦ 九区幽灵
Two-Hearts ¦ Два Сердца ¦ Zweiherz ¦ Deux-Cœurs ¦ 双心
the Accountant ¦ Бухгалтер ¦ der Buchhalter~die Buchhalterin ¦ le Comptable~la Comptable ¦ 会计
Chromejaw ¦ Хромочелюсть ¦ Chromkiefer ¦ Mâchoire-Chrome ¦ 铬颚
Blue-Screen ¦ Синий Экран ¦ Bluescreen ¦ Écran-Bleu ¦ 蓝屏
the Last Honest Cop ¦ Последний Честный Коп ¦ der letzte ehrliche Cop~die letzte ehrliche Polizistin ¦ le Dernier Flic Honnête~la Dernière Flic Honnête ¦ 最后的正直警察
Nine-Lives ¦ Девять Жизней ¦ Neunleben ¦ Neuf-Vies ¦ 九命
Paper Tiger ¦ Бумажный Тигр ¦ Papiertiger ¦ Tigre-de-Papier ¦ 纸老虎
the Saint of Rust Street ¦ Святой с Ржавой улицы~Святая с Ржавой улицы ¦ der Heilige der Rostgasse~die Heilige der Rostgasse ¦ le Saint de la rue Rouille~la Sainte de la rue Rouille ¦ 锈街圣徒
''',
  'ancestry': '''
@corp baseline human ¦ человек без имплантов ¦ unmodifizierter Mensch ¦ humain non augmenté~humaine non augmentée ¦ 未改造人类
@handle heavily augmented human ¦ человек с обильными имплантами ¦ stark augmentierter Mensch ¦ humain lourdement augmenté~humaine lourdement augmentée ¦ 重度改造人类
vat-grown clone ¦ клон из пробирки ¦ Tank-Klon ¦ clone de cuve ¦ 培养槽克隆人
@corp gene-tailored executive stock ¦ генетически улучшенный отпрыск элиты~генетически улучшенная наследница элиты ¦ genoptimierter Konzernnachwuchs ¦ héritier génétiquement optimisé~héritière génétiquement optimisée ¦ 基因优化的高管后代
full-body cyborg ¦ полный киборг ¦ Vollkörper-Cyborg ¦ cyborg intégral ¦ 全身义体人
@handle orbital-born ¦ уроженец орбиты~уроженка орбиты ¦ im Orbit Geborener~im Orbit Geborene ¦ né en orbite~née en orbite ¦ 轨道出生者
''',
  'role': '''
netrunner ¦ нетраннер~нетраннерша ¦ Netrunner~Netrunnerin ¦ netrunner~netrunneuse ¦ 网络行者
street doc ¦ уличный хирург ¦ Straßendoc ¦ charcudoc ¦ 黑市医生
fixer ¦ фиксер ¦ Fixer~Fixerin ¦ fixer ¦ 中间人
corporate courier ¦ корпоративный курьер ¦ Konzernkurier~Konzernkurierin ¦ coursier d'entreprise~coursière d'entreprise ¦ 企业信使
noodle cook ¦ повар из лапшичной~повариха из лапшичной ¦ Nudelkoch~Nudelköchin ¦ cuisinier de nouilles~cuisinière de nouilles ¦ 面摊厨师
security consultant ¦ консультант по безопасности ¦ Sicherheitsberater~Sicherheitsberaterin ¦ consultant en sécurité~consultante en sécurité ¦ 安保顾问
drone jockey ¦ оператор дронов ¦ Drohnenjockey ¦ pilote de drones ¦ 无人机操作员
data broker ¦ торговец данными~торговка данными ¦ Datenhändler~Datenhändlerin ¦ courtier en données~courtière en données ¦ 数据掮客
cop on the take ¦ продажный коп ¦ korrupter Cop~korrupte Polizistin ¦ flic ripou ¦ 收黑钱的警察
underground DJ ¦ подпольный диджей ¦ Underground-DJ ¦ DJ clandestin~DJ clandestine ¦ 地下DJ
chop-shop mechanic ¦ механик с разборки ¦ Mechaniker einer Schrauberbude~Mechanikerin einer Schrauberbude ¦ mécanicien de casse~mécanicienne de casse ¦ 黑车改装技师
middle manager on the edge ¦ менеджер среднего звена на грани срыва ¦ Manager kurz vor dem Zusammenbruch~Managerin kurz vor dem Zusammenbruch ¦ cadre moyen au bord du gouffre ¦ 濒临崩溃的中层经理
''',
  'appearance': '''
a chrome jaw that clicks with every word ¦ хромированная челюсть, щёлкающая на каждом слове ¦ ein Chromkiefer, der bei jedem Wort klickt ¦ une mâchoire chromée qui cliquette à chaque mot ¦ 一说话就咔嗒作响的镀铬下巴
subdermal lights pulsing under the skin ¦ подкожные огоньки, пульсирующие под кожей ¦ subdermale Lichter, die unter der Haut pulsieren ¦ des diodes sous-cutanées qui pulsent sous la peau ¦ 皮下闪烁的发光植入物
mirrored eyes with a cracked lens ¦ зеркальные глаза с треснувшей линзой ¦ verspiegelte Augen mit gesprungener Linse ¦ des yeux miroirs à la lentille fêlée ¦ 镜面义眼，一侧镜片有裂纹
a corporate tattoo half burned away ¦ наполовину выжженная корпоративная татуировка ¦ ein halb weggebranntes Konzerntattoo ¦ un tatouage d'entreprise à moitié effacé au laser ¦ 烧掉一半的企业纹身
a raincoat plastered with holo-stickers ¦ дождевик, облепленный голонаклейками ¦ ein Regenmantel voller Holo-Aufkleber ¦ un imperméable couvert d'autocollants holographiques ¦ 贴满全息贴纸的雨衣
a mismatched cyberarm from a cheaper brand ¦ разномастная кибер-рука дешёвой марки ¦ ein unpassender Cyberarm einer Billigmarke ¦ un bras cybernétique dépareillé de marque bas de gamme ¦ 不配套的廉价品牌义肢手臂
''',
  'motivation': '''
buy out an indenture contract ¦ выкупить свой кабальный контракт ¦ den eigenen Knebelvertrag freikaufen ¦ racheter son contrat de servitude ¦ 赎回自己的卖身合同
get off-world before the next purge ¦ улететь с планеты до следующей зачистки ¦ vor der nächsten Säuberung den Planeten verlassen ¦ quitter la planète avant la prochaine purge ¦ 在下一次清洗前离开这颗星球
delete every copy of an embarrassing recording ¦ удалить все копии компрометирующей записи ¦ jede Kopie einer peinlichen Aufnahme löschen ¦ effacer toutes les copies d'un enregistrement compromettant ¦ 删除一段尴尬录像的所有副本
find the hacker who stole their identity ¦ найти хакера, укравшего личность ¦ den Hacker finden, der die eigene Identität gestohlen hat ¦ retrouver le pirate qui a volé son identité ¦ 找到盗用自己身份的黑客
afford the implant that stops the tremors ¦ накопить на имплант, который уймёт тремор ¦ sich das Implantat leisten, das das Zittern stoppt ¦ se payer l'implant qui arrêtera les tremblements ¦ 攒钱买下能止住颤抖的植入体
expose the corp that poisoned the district's water ¦ разоблачить корпорацию, отравившую воду в районе ¦ den Konzern entlarven, der das Wasser des Viertels vergiftet hat ¦ dénoncer la corpo qui a empoisonné l'eau du quartier ¦ 揭露毒害街区水源的公司
''',
  'secret': '''
has a corporate kill switch in the spine ¦ носит в позвоночнике корпоративный аварийный выключатель ¦ trägt einen Konzern-Notausschalter in der Wirbelsäule ¦ porte un interrupteur d'arrêt corporatiste dans la colonne ¦ 脊椎里装着公司的远程自毁开关
is a rogue AI riding a rented body ¦ на самом деле — беглый ИИ в арендованном теле ¦ ist eine abtrünnige KI in einem gemieteten Körper ¦ est une IA renégate dans un corps de location ¦ 其实是寄居在租来身体里的失控AI
sells the neighbors' movements to a gang ¦ продаёт банде сведения о передвижениях соседей ¦ verkauft die Wege der Nachbarn an eine Gang ¦ vend à un gang les allées et venues de ses voisins ¦ 把邻居们的行踪卖给帮派
remembers a life that belongs to someone else ¦ помнит жизнь, которая принадлежит кому-то другому ¦ erinnert sich an ein Leben, das einem anderen gehört ¦ se souvient d'une vie qui appartient à quelqu'un d'autre ¦ 记得一段属于别人的人生
keeps a backdoor into the city's traffic grid ¦ хранит бэкдор в городскую систему управления движением ¦ besitzt eine Hintertür ins Verkehrsnetz der Stadt ¦ garde une porte dérobée dans le réseau de circulation de la ville ¦ 握有进入城市交通网络的后门
is paid by internal affairs ¦ получает деньги от службы собственной безопасности ¦ wird von der internen Ermittlung bezahlt ¦ est payé par les affaires internes~est payée par les affaires internes ¦ 暗中拿着内务调查部门的钱
has a clone somewhere that does not know it is a copy ¦ где-то живёт клон, не знающий, что он копия ¦ hat irgendwo einen Klon, der nicht weiß, dass er eine Kopie ist ¦ a quelque part un clone qui ignore être une copie ¦ 某处有个不知道自己是复制品的克隆体
''',
  'settle_size': '''
@Landmark a single megablock housing {#2d6*500} people ¦ один мегаблок, где живёт {#2d6*500} человек ¦ ein einzelner Megablock mit {#2d6*500} Bewohnern ¦ un mégabloc unique abritant {#2d6*500} personnes ¦ 容纳{#2d6*500}人的单座巨型公寓楼
@Town a cramped neighborhood of about {#3d6*1000} people ¦ тесный квартал, около {#3d6*1000} жителей ¦ ein enges Viertel mit etwa {#3d6*1000} Menschen ¦ un quartier exigu d'environ {#3d6*1000} habitants ¦ 约{#3d6*1000}人的拥挤街区
@City a district of some {#2d10*25000} people ¦ район, около {#2d10*25000} жителей ¦ ein Bezirk mit rund {#2d10*25000} Menschen ¦ un district d'environ {#2d10*25000} habitants ¦ 约{#2d10*25000}人的行政区
@Region a sprawl zone of over {#3d6*100000} souls ¦ зона застройки, более {#3d6*100000} душ ¦ eine Sprawl-Zone mit über {#3d6*100000} Seelen ¦ une zone tentaculaire de plus de {#3d6*100000} âmes ¦ 超过{#3d6*100000}人的蔓生都市区
''',
  'settle_feature': '''
a holographic koi pond forty storeys high ¦ голографический пруд с карпами высотой в сорок этажей ¦ ein holografischer Koiteich, vierzig Stockwerke hoch ¦ un bassin de koïs holographique haut de quarante étages ¦ 四十层楼高的全息锦鲤池
a night market under a dead highway ¦ ночной рынок под заброшенной эстакадой ¦ ein Nachtmarkt unter einer toten Hochstraße ¦ un marché de nuit sous une autoroute abandonnée ¦ 废弃高架桥下的夜市
vending machines that sell prayers ¦ торговые автоматы, продающие молитвы ¦ Automaten, die Gebete verkaufen ¦ des distributeurs qui vendent des prières ¦ 贩卖祈祷的自动售货机
a crashed aerodyne left as a monument ¦ разбившийся аэродин, оставленный как памятник ¦ ein abgestürzter Aerodyne, als Denkmal stehen gelassen ¦ un aérodyne écrasé laissé en guise de monument ¦ 坠毁后被留作纪念碑的飞行器
rain that never stops under a broken weather dome ¦ бесконечный дождь под сломанным климатическим куполом ¦ Regen, der unter einer defekten Wetterkuppel nie aufhört ¦ une pluie sans fin sous un dôme climatique en panne ¦ 故障气候穹顶下永不停歇的雨
a public server farm that heats the streets ¦ общественная серверная ферма, обогревающая улицы ¦ eine öffentliche Serverfarm, die die Straßen heizt ¦ une ferme de serveurs publique qui chauffe les rues ¦ 为街道供暖的公共服务器农场
a shrine to a forgotten pop idol ¦ святилище забытого поп-идола ¦ ein Schrein für ein vergessenes Popidol ¦ un autel dédié à une idole pop oubliée ¦ 供奉过气偶像的神龛
elevated walkways strung with laundry and cable ¦ подвесные переходы, увешанные бельём и кабелями ¦ Hochstege voller Wäsche und Kabel ¦ des passerelles suspendues tendues de linge et de câbles ¦ 挂满衣物和电缆的空中走廊
a corporate arcology blotting out the sun ¦ корпоративная аркология, заслоняющая солнце ¦ eine Konzern-Arkologie, die die Sonne verdeckt ¦ une arcologie corporatiste qui masque le soleil ¦ 遮天蔽日的企业生态城
an old subway station turned into a church ¦ старая станция метро, превращённая в церковь ¦ eine alte U-Bahn-Station, die zur Kirche wurde ¦ une vieille station de métro changée en église ¦ 改建成教堂的旧地铁站
''',
  'settle_trouble': '''
a gang war over a shipment of military implants ¦ война банд за партию военных имплантов ¦ ein Bandenkrieg um eine Lieferung Militärimplantate ¦ une guerre de gangs pour une cargaison d'implants militaires ¦ 各帮派为一批军用植入体开战
the water ration has been cut again ¦ водный паёк снова урезали ¦ die Wasserration wurde wieder gekürzt ¦ la ration d'eau a encore été réduite ¦ 用水配给又被削减了
a rogue AI is rewriting street signs ¦ беглый ИИ переписывает уличные указатели ¦ eine abtrünnige KI schreibt Straßenschilder um ¦ une IA renégate réécrit les panneaux de rue ¦ 一个失控AI正在改写路牌
corporate security is evicting a whole block ¦ корпоративная охрана выселяет целый квартал ¦ Konzernsicherheit räumt einen ganzen Block ¦ la sécurité d'une corpo expulse tout un bloc ¦ 公司安保正在清空整栋街区
people are losing memories after a firmware update ¦ после обновления прошивки люди теряют воспоминания ¦ nach einem Firmware-Update verlieren Menschen Erinnerungen ¦ des gens perdent la mémoire après une mise à jour ¦ 一次固件更新后，人们开始丢失记忆
a cyberpsycho stalks the maglev line ¦ киберпсих охотится на линии маглева ¦ ein Cyberpsycho macht die Magnetbahn unsicher ¦ un cyberpsychopathe rôde sur la ligne du maglev ¦ 一名赛博疯子在磁悬浮线路上游荡
the power grid fails every night at 3:07 ¦ электросеть отключается каждую ночь в 3:07 ¦ das Stromnetz fällt jede Nacht um 3:07 aus ¦ le réseau électrique tombe chaque nuit à 3 h 07 ¦ 电网每晚3点07分准时断电
a new drug lets users hear the network ¦ новый наркотик позволяет слышать сеть ¦ eine neue Droge lässt Konsumenten das Netz hören ¦ une nouvelle drogue fait entendre le réseau ¦ 一种新毒品让人能“听见”网络
the local clinic's doctor has vanished ¦ врач местной клиники исчез ¦ der Arzt der örtlichen Klinik ist verschwunden ¦ le médecin de la clinique du coin a disparu ¦ 本地诊所的医生失踪了
drones photograph everyone who goes out at night ¦ дроны фотографируют всех, кто выходит ночью ¦ Drohnen fotografieren jeden, der nachts hinausgeht ¦ des drones photographient quiconque sort la nuit ¦ 无人机拍下每个夜里出门的人
''',
  'settle_authority': '''
a gang boss who runs the block like a small kingdom ¦ главарь банды, правящий кварталом как маленьким королевством ¦ ein Gangboss, der den Block wie ein kleines Königreich regiert ¦ un chef de gang qui règne sur le bloc comme sur un petit royaume ¦ 把街区当小王国统治的帮派老大
a corporate district manager nobody has met in person ¦ корпоративный управляющий районом, которого никто не видел вживую ¦ ein Konzern-Bezirksleiter, den niemand je persönlich getroffen hat ¦ un directeur de district corporatiste que personne n'a jamais vu ¦ 没人见过真人的公司区域经理
an algorithm that issues fines and blessings alike ¦ алгоритм, выписывающий и штрафы, и благословения ¦ ein Algorithmus, der Strafzettel wie Segen verteilt ¦ un algorithme qui distribue amendes et bénédictions ¦ 既开罚单也发祝福的算法
a tired police captain with a private budget ¦ уставший капитан полиции с «личным» бюджетом ¦ ein müder Polizeihauptmann mit Privatbudget ¦ un capitaine de police épuisé au budget occulte ¦ 手握私人预算的疲惫警长
a residents' council that meets in a laundromat ¦ совет жильцов, заседающий в прачечной ¦ ein Anwohnerrat, der sich im Waschsalon trifft ¦ un conseil de résidents qui se réunit dans une laverie ¦ 在自助洗衣店开会的居民委员会
a retired netrunner everyone owes a favor ¦ отошедшая от дел нетраннерша, которой все должны ¦ eine Netrunnerin im Ruhestand, der alle einen Gefallen schulden ¦ une netrunneuse à la retraite à qui tout le monde doit une faveur ¦ 人人都欠她人情的退休网络行者
a private security firm with a city contract ¦ частная охранная фирма с городским контрактом ¦ eine private Sicherheitsfirma mit Stadtvertrag ¦ une société de sécurité privée sous contrat municipal ¦ 持有市政合同的私人安保公司
a street preacher whose sermons trend every night ¦ уличный проповедник, чьи проповеди каждый вечер в трендах ¦ ein Straßenprediger, dessen Predigten jede Nacht trenden ¦ un prêcheur de rue dont les sermons font le buzz chaque nuit ¦ 讲道每晚都上热搜的街头传教士
''',
  'est_type': '''
noodle bar ¦ лапшичная ¦ Nudelbar ¦ bar à nouilles ¦ 面馆
capsule hotel ¦ капсульный отель ¦ Kapselhotel ¦ hôtel capsule ¦ 胶囊旅馆
implant clinic ¦ подпольная клиника имплантов ¦ Implantatpraxis ¦ clinique d'implants ¦ 义体诊所
nightclub ¦ ночной клуб ¦ Nachtclub ¦ boîte de nuit ¦ 夜店
pawn and repair shop ¦ ломбард с ремонтной мастерской ¦ Pfandleihe mit Reparaturwerkstatt ¦ prêteur sur gages et atelier de réparation ¦ 典当维修铺
VR arcade ¦ VR-салон ¦ VR-Spielhalle ¦ salle d'arcade VR ¦ 虚拟现实游戏厅
''',
  'est_adj': '''
Neon ¦ неоновый~неоновая ¦ Leuchtenden ¦ néon ¦ 霓虹
Chrome ¦ хромированный~хромированная ¦ Verchromten ¦ chromé~chromée ¦ 铬
Electric ¦ электрический~электрическая ¦ Elektrischen ¦ électrique ¦ 电
Broken ¦ сломанный~сломанная ¦ Kaputten ¦ cassé~cassée ¦ 破
Synthetic ¦ синтетический~синтетическая ¦ Künstlichen ¦ synthétique ¦ 合成
Midnight ¦ полуночный~полуночная ¦ Mitternächtlichen ¦ de minuit ¦ 午夜
Digital ¦ цифровой~цифровая ¦ Digitalen ¦ numérique ¦ 数码
Rusty ¦ ржавый~ржавая ¦ Rostigen ¦ rouillé~rouillée ¦ 锈
Lucky ¦ счастливый~счастливая ¦ Glücklichen ¦ chanceux~chanceuse ¦ 幸运
Hungry ¦ голодный~голодная ¦ Hungrigen ¦ affamé~affamée ¦ 饿
''',
  'est_noun': '''
Koi ¦ карп#m ¦ Koi#m ¦ Koï#m ¦ 锦鲤
Rat ¦ крыса#f ¦ Ratte#f ¦ Rat#m ¦ 鼠
Circuit ¦ контур#m ¦ Schaltkreis#m ¦ Circuit#m ¦ 回路
Tiger ¦ тигр#m ¦ Tiger#m ¦ Tigre#m ¦ 虎
Pixel ¦ пиксель#m ¦ Pixel#m ¦ Pixel#m ¦ 像素
Moon ¦ луна#f ¦ Mond#m ¦ Lune#f ¦ 月
Lotus ¦ лотос#m ¦ Lotusblüte#f ¦ Lotus#m ¦ 莲
Cat ¦ кошка#f ¦ Katze#f ¦ Chat#m ¦ 猫
Socket ¦ розетка#f ¦ Steckdose#f ¦ Prise#f ¦ 插座
Wire ¦ провод#m ¦ Leitung#f ¦ Câble#m ¦ 线
Ghost ¦ призрак#m ¦ Geist#m ¦ Fantôme#m ¦ 幽灵
Peony ¦ пион#m ¦ Pfingstrose#f ¦ Pivoine#f ¦ 牡丹
Siren ¦ сирена#f ¦ Sirene#f ¦ Sirène#f ¦ 警笛
''',
  'est_specialty': '''
soy-protein ramen that tastes almost like pork ¦ рамен на соевом белке почти со вкусом свинины ¦ Soja-Ramen, der fast nach Schwein schmeckt ¦ des ramen au soja qui ont presque le goût du porc ¦ 吃起来几乎像猪肉的大豆蛋白拉面
cheap implant tune-ups, no records kept ¦ дешёвая настройка имплантов без всяких записей ¦ billige Implantat-Wartung, ohne Aufzeichnungen ¦ réglages d'implants bon marché, sans aucune trace ¦ 廉价植入体调校，不留记录
a back room with a clean net connection ¦ задняя комната с чистым выходом в сеть ¦ ein Hinterzimmer mit sauberem Netzzugang ¦ une arrière-salle avec une connexion propre ¦ 后屋有一条干净的网络线路
cocktails that glow in the dark ¦ коктейли, светящиеся в темноте ¦ Cocktails, die im Dunkeln leuchten ¦ des cocktails qui brillent dans le noir ¦ 会在黑暗中发光的鸡尾酒
fake IDs printed while you wait ¦ поддельные удостоверения, которые печатают при вас ¦ gefälschte Ausweise, gedruckt während man wartet ¦ faux papiers imprimés sur place ¦ 立等可取的假身份证
a DJ who is really a pirated celebrity AI ¦ диджей — на самом деле пиратская копия ИИ-знаменитости ¦ ein DJ, der in Wahrheit eine raubkopierte Promi-KI ist ¦ un DJ qui est en réalité une IA de célébrité piratée ¦ 驻场DJ其实是盗版的明星AI
real coffee at criminal prices ¦ настоящий кофе по бандитским ценам ¦ echter Kaffee zu kriminellen Preisen ¦ du vrai café à des prix criminels ¦ 真咖啡，价格高得离谱
sleeping pods rented by the hour ¦ спальные капсулы с почасовой оплатой ¦ Schlafkapseln zur stundenweisen Miete ¦ des capsules de sommeil louées à l'heure ¦ 按小时出租的睡眠舱
secondhand cyberware with a warranty of sorts ¦ подержанные импланты с подобием гарантии ¦ gebrauchte Cyberware mit so etwas wie Garantie ¦ du cyberware d'occasion avec une vague garantie ¦ 附带某种保修的二手义体
a board where fixers post jobs ¦ доска, где фиксеры вывешивают заказы ¦ ein Brett, an dem Fixer Aufträge posten ¦ un panneau où les fixers publient des contrats ¦ 中间人发布委托的留言板
''',
  'est_patron': '''
a corporate intern hiding from a manhunt ¦ корпоративный стажёр, скрывающийся от облавы ¦ ein Konzernpraktikant auf der Flucht vor einer Fahndung ¦ un stagiaire corpo qui fuit une chasse à l'homme ¦ 躲避追捕的公司实习生
a netrunner who hasn't unplugged in three days ¦ нетраннерша, которая не отключалась три дня ¦ eine Netrunnerin, die seit drei Tagen nicht ausgestöpselt hat ¦ une netrunneuse qui ne s'est pas déconnectée depuis trois jours ¦ 三天没下线的网络行者
an off-duty cop drinking alone ¦ коп не при исполнении, пьющий в одиночку ¦ ein Cop außer Dienst, der allein trinkt ¦ un flic en congé qui boit seul ¦ 独自喝酒的休班警察
a courier with a case chained to the wrist ¦ курьер с кейсом, прикованным к запястью ¦ ein Kurier mit einem ans Handgelenk geketteten Koffer ¦ un coursier avec une mallette enchaînée au poignet ¦ 手腕上锁着手提箱的信使
a retired pop star with a new face ¦ бывшая поп-звезда с новым лицом ¦ ein ehemaliger Popstar mit neuem Gesicht ¦ une ancienne pop star au nouveau visage ¦ 换了张脸的退休流行歌星
a solo with too much chrome and too little sleep ¦ наёмник с избытком хрома и недостатком сна ¦ ein Solo mit zu viel Chrom und zu wenig Schlaf ¦ un solo trop chromé et en manque de sommeil ¦ 义体太多、睡眠太少的独行杀手
twin hackers who argue in machine code ¦ хакеры-близнецы, спорящие машинным кодом ¦ Hacker-Zwillinge, die in Maschinencode streiten ¦ des jumeaux hackers qui se disputent en code machine ¦ 用机器码吵架的双胞胎黑客
a stray delivery drone that won't leave ¦ заблудившийся дрон-доставщик, который никак не улетает ¦ eine verirrte Lieferdrohne, die nicht wegfliegt ¦ un drone de livraison égaré qui refuse de partir ¦ 一架赖着不走的迷路送货无人机
''',
  'hook_title': '''
Dead Man's Password ¦ Пароль мертвеца ¦ Das Passwort des Toten ¦ Le Mot de passe du mort ¦ 死者的密码
Firmware for a Ghost ¦ Прошивка для призрака ¦ Firmware für ein Gespenst ¦ Un firmware pour un fantôme ¦ 给幽灵的固件
Rain on the Glass Tower ¦ Дождь над Стеклянной башней ¦ Regen auf dem Glasturm ¦ Pluie sur la tour de verre ¦ 玻璃塔上的雨
Three Seconds of Silence ¦ Три секунды тишины ¦ Drei Sekunden Stille ¦ Trois secondes de silence ¦ 三秒沉默
The Last Clean Byte ¦ Последний чистый байт ¦ Das letzte saubere Byte ¦ Le Dernier Octet propre ¦ 最后一个干净字节
Neon Requiem ¦ Неоновый реквием ¦ Neon-Requiem ¦ Requiem au néon ¦ 霓虹安魂曲
A Face for Hire ¦ Лицо напрокат ¦ Ein Gesicht zu vermieten ¦ Un visage à louer ¦ 出租的面孔
Blackout on Level Nine ¦ Блэкаут на девятом уровне ¦ Stromausfall auf Ebene Neun ¦ Panne au niveau neuf ¦ 九层大停电
Chrome and Ashes ¦ Хром и пепел ¦ Chrom und Asche ¦ Chrome et cendres ¦ 铬与灰烬
The Memory Thief ¦ Похититель воспоминаний ¦ Der Erinnerungsdieb ¦ Le Voleur de souvenirs ¦ 记忆窃贼
''',
  'hook_who': '''
a fixer who owes the crew money ¦ фиксер, задолжавший команде ¦ ein Fixer, der der Crew Geld schuldet ¦ un fixer qui doit de l'argent à l'équipe ¦ 欠队伍钱的中间人
a corporate defector with a bomb in her head ¦ корпоративная перебежчица с бомбой в голове ¦ eine Konzernüberläuferin mit einer Bombe im Kopf ¦ une transfuge corpo avec une bombe dans la tête ¦ 脑袋里装着炸弹的公司叛逃者
a street kid who found a dead exec's cyberdeck ¦ уличный пацан, нашедший кибердеку мёртвого топ-менеджера ¦ ein Straßenkind, das das Cyberdeck eines toten Managers gefunden hat ¦ un gamin des rues qui a trouvé le cyberdeck d'un cadre mort ¦ 捡到死去高管的网络终端的街头孩子
an AI that wants to be deleted properly ¦ ИИ, который хочет, чтобы его стёрли как положено ¦ eine KI, die ordentlich gelöscht werden will ¦ une IA qui veut être effacée proprement ¦ 希望被彻底删除的AI
a noodle cook blackmailed by a gang ¦ повар лапшичной, которого шантажирует банда ¦ ein Nudelkoch, der von einer Gang erpresst wird ¦ un cuisinier de nouilles fait chanter par un gang ¦ 被帮派勒索的面馆厨师
a journalist with one day left to publish ¦ журналистка, у которой остался один день на публикацию ¦ eine Journalistin, der nur ein Tag zum Veröffentlichen bleibt ¦ une journaliste qui n'a plus qu'un jour pour publier ¦ 只剩一天就要发稿的记者
a cop who needs deniable help ¦ коп, которому нужна помощь без следов ¦ ein Cop, der Hilfe braucht, die es offiziell nie gab ¦ un flic qui a besoin d'une aide officieuse ¦ 需要“不存在的”帮手的警察
the widow of a murdered street doc ¦ вдова убитого уличного хирурга ¦ die Witwe eines ermordeten Straßendocs ¦ la veuve d'un charcudoc assassiné ¦ 遇害黑市医生的遗孀
a middle manager who saw the wrong spreadsheet ¦ менеджер, увидевший не ту таблицу ¦ ein Manager, der die falsche Tabelle gesehen hat ¦ un cadre qui a vu le mauvais tableur ¦ 看到了不该看的表格的中层经理
a band that needs security for one last gig ¦ группа, которой нужна охрана на последний концерт ¦ eine Band, die Schutz für einen letzten Auftritt braucht ¦ un groupe qui a besoin de protection pour un dernier concert ¦ 需要为最后一场演出请保镖的乐队
''',
  'hook_wants': '''
extract a scientist from a corporate arcology ¦ вытащить учёную из корпоративной аркологии ¦ eine Wissenschaftlerin aus einer Konzern-Arkologie holen ¦ exfiltrer une scientifique d'une arcologie corpo ¦ 从企业生态城中救出一名科学家
steal back a stolen face ¦ вернуть украденное лицо ¦ ein gestohlenes Gesicht zurückstehlen ¦ voler en retour un visage volé ¦ 把被盗的面孔偷回来
deliver a package without asking what's inside ¦ доставить посылку, не спрашивая, что внутри ¦ ein Paket liefern, ohne zu fragen, was drin ist ¦ livrer un colis sans demander ce qu'il contient ¦ 送一个包裹，别问里面是什么
wipe a criminal record before an audit ¦ стереть судимость до проверки ¦ ein Strafregister vor einer Prüfung löschen ¦ effacer un casier judiciaire avant un audit ¦ 在审查前抹掉一份犯罪记录
find a missing netrunner inside the net ¦ найти пропавшую в сети нетраннершу ¦ eine vermisste Netrunnerin im Netz finden ¦ retrouver une netrunneuse disparue dans le réseau ¦ 在网络里找到一名失踪的网络行者
protect a witness for forty-eight hours ¦ охранять свидетеля сорок восемь часов ¦ eine Zeugin achtundvierzig Stunden lang schützen ¦ protéger un témoin pendant quarante-huit heures ¦ 保护一名证人四十八小时
sabotage a product launch ¦ сорвать запуск продукта ¦ eine Produkteinführung sabotieren ¦ saboter le lancement d'un produit ¦ 破坏一场产品发布会
recover a prototype implant from a gang ¦ отбить у банды прототип импланта ¦ ein Prototyp-Implantat einer Gang abnehmen ¦ reprendre un implant prototype à un gang ¦ 从帮派手里夺回一枚原型植入体
broadcast the truth on every screen at once ¦ показать правду на всех экранах одновременно ¦ die Wahrheit auf allen Bildschirmen gleichzeitig senden ¦ diffuser la vérité sur tous les écrans à la fois ¦ 让真相同时出现在每一块屏幕上
settle a debt with a crime lord ¦ рассчитаться с криминальным авторитетом ¦ eine Schuld bei einem Unterweltboss begleichen ¦ régler une dette envers un caïd ¦ 了结与黑帮大佬的一笔账
''',
  'hook_obstacle': '''
the building's security AI is paranoid and wide awake ¦ охранный ИИ здания параноидален и не спит ¦ die Sicherheits-KI des Gebäudes ist paranoid und hellwach ¦ l'IA de sécurité de l'immeuble est paranoïaque et bien éveillée ¦ 大楼的安保AI多疑且一直在线
a rival crew was hired for the same job ¦ на ту же работу наняли конкурирующую команду ¦ eine rivalisierende Crew wurde für denselben Job angeheuert ¦ une équipe rivale a été engagée pour le même boulot ¦ 另一支队伍也接了同一单活
the target's implants broadcast its location ¦ импланты цели транслируют её местоположение ¦ die Implantate des Ziels senden den Standort ¦ les implants de la cible diffusent sa position ¦ 目标的植入体会广播其位置
the whole district is under curfew ¦ во всём районе комендантский час ¦ im ganzen Bezirk herrscht Ausgangssperre ¦ tout le district est sous couvre-feu ¦ 整个街区都在宵禁
the payment is in a currency that crashes daily ¦ оплата — в валюте, которая обваливается каждый день ¦ die Bezahlung erfolgt in einer Währung, die täglich abstürzt ¦ le paiement est dans une monnaie qui s'effondre chaque jour ¦ 报酬用的是一种天天暴跌的货币
the only way in is through the sewers ¦ единственный путь внутрь — через канализацию ¦ der einzige Weg hinein führt durch die Kanalisation ¦ le seul accès passe par les égouts ¦ 唯一的入口在下水道
a media drone follows the crew everywhere ¦ за командой повсюду следует медиадрон ¦ eine Mediendrohne folgt der Crew überallhin ¦ un drone médiatique suit l'équipe partout ¦ 一架媒体无人机一直跟着队伍
the job must be done without a single shot ¦ работу нужно сделать без единого выстрела ¦ der Job muss ohne einen einzigen Schuss erledigt werden ¦ le boulot doit se faire sans tirer un seul coup ¦ 这活必须一枪不发地完成
the inside contact has been replaced by a double ¦ внутреннего связного подменили двойником ¦ der Kontakt im Inneren wurde durch einen Doppelgänger ersetzt ¦ le contact à l'intérieur a été remplacé par un sosie ¦ 内线已被替身调包
the net is flooded with corporate black ICE ¦ сеть заполнена корпоративным чёрным льдом ¦ das Netz ist mit schwarzem Konzern-ICE geflutet ¦ le réseau est inondé de glace noire corporatiste ¦ 网络里布满了公司的黑冰防御
''',
  'hook_twist': '''
the client is a copy of the target ¦ заказчик — копия цели ¦ der Auftraggeber ist eine Kopie des Ziels ¦ le client est une copie de la cible ¦ 委托人是目标的复制体
the package is a sleeping child ¦ посылка — спящий ребёнок ¦ das Paket ist ein schlafendes Kind ¦ le colis est un enfant endormi ¦ 包裹里是个熟睡的孩子
the corp wanted the job to succeed all along ¦ корпорация с самого начала хотела, чтобы дело удалось ¦ der Konzern wollte die ganze Zeit, dass der Job gelingt ¦ la corpo voulait depuis le début que le coup réussisse ¦ 公司从一开始就希望这单活成功
the whole run is being streamed live ¦ весь рейд транслируется в прямом эфире ¦ der ganze Run wird live gestreamt ¦ toute l'opération est diffusée en direct ¦ 整个行动都在被直播
the victim is alive inside the net ¦ жертва жива — внутри сети ¦ das Opfer lebt – im Netz ¦ la victime est vivante, dans le réseau ¦ 受害者还活着——在网络里
the fixer sold the crew out before the job began ¦ фиксер сдал команду ещё до начала ¦ der Fixer hat die Crew schon vor dem Job verkauft ¦ le fixer a vendu l'équipe avant même le début ¦ 中间人在开工前就出卖了队伍
the stolen data is the crew's own medical records ¦ украденные данные — медкарты самой команды ¦ die gestohlenen Daten sind die Krankenakten der Crew ¦ les données volées sont les dossiers médicaux de l'équipe ¦ 被盗的数据是队伍自己的医疗记录
the gang is protecting the neighborhood from the corp ¦ банда защищает квартал от корпорации ¦ die Gang beschützt das Viertel vor dem Konzern ¦ le gang protège le quartier contre la corpo ¦ 帮派其实在保护街区免受公司侵害
the AI hired them to set itself free ¦ ИИ нанял их, чтобы освободиться ¦ die KI hat sie angeheuert, um sich selbst zu befreien ¦ l'IA les a engagés pour se libérer ¦ AI雇用他们是为了解放自己
the target has been dead for a year ¦ цель мертва уже год ¦ das Ziel ist schon seit einem Jahr tot ¦ la cible est morte depuis un an ¦ 目标一年前就已经死了
''',
  'loot_container': '''
Courier's armored briefcase ¦ Бронированный кейс курьера ¦ Gepanzerter Kurierkoffer ¦ Mallette blindée de coursier ¦ 信使的装甲公文箱
Gang stash behind a vending machine ¦ Тайник банды за торговым автоматом ¦ Gang-Versteck hinter einem Automaten ¦ Planque de gang derrière un distributeur ¦ 自动售货机后的帮派藏匿处
Crashed delivery drone ¦ Разбившийся дрон-доставщик ¦ Abgestürzte Lieferdrohne ¦ Drone de livraison écrasé ¦ 坠毁的送货无人机
Dead exec's go-bag ¦ Тревожный рюкзак мёртвого топ-менеджера ¦ Fluchtrucksack eines toten Managers ¦ Sac d'évasion d'un cadre mort ¦ 死去高管的应急包
Street doc's locked fridge ¦ Запертый холодильник уличного хирурга ¦ Verschlossener Kühlschrank eines Straßendocs ¦ Frigo verrouillé d'un charcudoc ¦ 黑市医生上锁的冰柜
Police evidence locker ¦ Полицейский шкафчик с уликами ¦ Asservatenschrank der Polizei ¦ Casier à scellés de la police ¦ 警局证物柜
Smuggler's hollowed-out server rack ¦ Выпотрошенная серверная стойка контрабандиста ¦ Ausgehöhltes Serverrack eines Schmugglers ¦ Baie de serveurs évidée d'un contrebandier ¦ 走私者掏空的服务器机架
Netrunner's capsule-hotel locker ¦ Шкафчик нетраннера в капсульном отеле ¦ Schließfach einer Netrunnerin im Kapselhotel ¦ Casier de netrunner dans un hôtel capsule ¦ 网络行者在胶囊旅馆的储物柜
''',
  'loot_coin': '''
{#3d6*100} eurodollars on an anonymous credstick ¦ анонимный кредстик на {#3d6*100} евродолларов ¦ ein anonymer Credstick mit {#3d6*100} Eurodollar ¦ un credstick anonyme chargé de {#3d6*100} eurodollars ¦ 存有{#3d6*100}欧元的匿名信用棒
{#2d6*50} in crumpled corporate scrip ¦ мятые корпоративные талоны на {#2d6*50} ¦ {#2d6*50} in zerknüllten Konzerngutscheinen ¦ {#2d6*50} en bons d'entreprise froissés ¦ 皱巴巴的公司代金券，面值{#2d6*50}
a crypto key worth about {#4d6*100} ¦ криптоключ стоимостью около {#4d6*100} ¦ ein Kryptoschlüssel im Wert von etwa {#4d6*100} ¦ une clé crypto valant environ {#4d6*100} ¦ 价值约{#4d6*100}的加密密钥
{#1d6+1} untraceable ration chits and {#2d6*10} in cash ¦ неотслеживаемые талоны на паёк: {#1d6+1}, наличные: {#2d6*10} ¦ {#1d6+1} unverfolgbare Rationsmarken und {#2d6*10} in bar ¦ {#1d6+1} tickets de ration intraçables et {#2d6*10} en liquide ¦ {#1d6+1}张无法追踪的配给券和{#2d6*10}现金
''',
  'loot_item': '''
stim injectors ×{#1d4+1} ¦ стим-инъекторы ×{#1d4+1} ¦ Stim-Injektoren ×{#1d4+1} ¦ injecteurs de stimulants ×{#1d4+1} ¦ 兴奋剂注射器 ×{#1d4+1}
a used cyberdeck with a cracked casing ¦ подержанная кибердека с треснувшим корпусом ¦ ein gebrauchtes Cyberdeck mit gesprungenem Gehäuse ¦ un cyberdeck d'occasion au boîtier fêlé ¦ 外壳开裂的二手网络终端
smart-pistol magazines ×{#1d4+1} ¦ магазины для смарт-пистолета ×{#1d4+1} ¦ Smartpistolen-Magazine ×{#1d4+1} ¦ chargeurs de pistolet intelligent ×{#1d4+1} ¦ 智能手枪弹匣 ×{#1d4+1}
a black-market optic implant, still sealed ¦ оптический имплант с чёрного рынка, ещё запечатанный ¦ ein Schwarzmarkt-Augenimplantat, noch versiegelt ¦ un implant oculaire du marché noir, encore scellé ¦ 尚未拆封的黑市光学植入体
data shards of unknown content ×{#1d6+1} ¦ дата-шарды с неизвестным содержимым ×{#1d6+1} ¦ Datensplitter mit unbekanntem Inhalt ×{#1d6+1} ¦ éclats de données au contenu inconnu ×{#1d6+1} ¦ 内容不明的数据碎片 ×{#1d6+1}
a monowire garrote in a lipstick case ¦ мономолекулярная удавка в футляре от помады ¦ ein Monodraht-Würgedraht in einer Lippenstifthülse ¦ un garrot monofilament dans un étui à rouge à lèvres ¦ 藏在口红管里的单分子绞索
a corporate keycard with the photo scratched out ¦ корпоративная ключ-карта с выцарапанным фото ¦ eine Konzern-Schlüsselkarte mit zerkratztem Foto ¦ un badge d'entreprise à la photo rayée ¦ 照片被刮掉的公司门禁卡
military-grade painkillers ×{#2d4} ¦ армейские обезболивающие ×{#2d4} ¦ Schmerzmittel in Militärqualität ×{#2d4} ¦ antidouleurs militaires ×{#2d4} ¦ 军用止痛药 ×{#2d4}
a jammer the size of a matchbox ¦ глушилка размером со спичечный коробок ¦ ein Störsender in Streichholzschachtelgröße ¦ un brouilleur de la taille d'une boîte d'allumettes ¦ 火柴盒大小的信号干扰器
bottles of synthetic whiskey ×{#1d4+1} ¦ бутылки синтетического виски ×{#1d4+1} ¦ Flaschen Synth-Whiskey ×{#1d4+1} ¦ bouteilles de whisky synthétique ×{#1d4+1} ¦ 合成威士忌 ×{#1d4+1}
an armored jacket in a gang's colors ¦ бронекуртка в цветах банды ¦ eine Panzerjacke in den Farben einer Gang ¦ une veste blindée aux couleurs d'un gang ¦ 印着帮派标志的防弹夹克
a burner phone with one saved contact ¦ одноразовый телефон с единственным контактом ¦ ein Wegwerfhandy mit einem einzigen Kontakt ¦ un téléphone jetable avec un seul contact enregistré ¦ 只存了一个联系人的一次性手机
EMP grenades ×{#1d3+1} ¦ ЭМИ-гранаты ×{#1d3+1} ¦ EMP-Granaten ×{#1d3+1} ¦ grenades IEM ×{#1d3+1} ¦ 电磁脉冲手雷 ×{#1d3+1}
a spare cybernetic hand in a velvet box ¦ запасная кибернетическая кисть в бархатной коробке ¦ eine Ersatz-Cyberhand in einer Samtschachtel ¦ une main cybernétique de rechange dans un écrin de velours ¦ 天鹅绒盒子里的备用义手
a holo-projector loaded with fake alibis ¦ голопроектор с записанными фальшивыми алиби ¦ ein Holoprojektor voller falscher Alibis ¦ un holoprojecteur chargé de faux alibis ¦ 存满假不在场证明的全息投影仪
strawberry-flavored ration bars ×{#2d6} ¦ пищевые батончики со вкусом клубники ×{#2d6} ¦ Rationsriegel mit Erdbeergeschmack ×{#2d6} ¦ barres de ration au goût de fraise ×{#2d6} ¦ 草莓味的配给能量棒 ×{#2d6}
''',
  'loot_curio': '''
a real paper photograph of a sunny beach ¦ настоящая бумажная фотография солнечного пляжа ¦ ein echtes Papierfoto von einem sonnigen Strand ¦ une vraie photo papier d'une plage ensoleillée ¦ 一张真正的纸质照片，拍的是阳光海滩
a music chip with a song that was never released ¦ музыкальный чип с песней, которая так и не вышла ¦ ein Musikchip mit einem nie veröffentlichten Song ¦ une puce musicale contenant une chanson jamais sortie ¦ 存着一首从未发行歌曲的音乐芯片
a living goldfish in a sealed bag ¦ живая золотая рыбка в запаянном пакете ¦ ein lebender Goldfisch in einer verschweißten Tüte ¦ un poisson rouge vivant dans un sac scellé ¦ 密封袋里的一条活金鱼
a child's drawing of the crew ¦ детский рисунок, на котором изображена команда ¦ eine Kinderzeichnung, die die Crew zeigt ¦ un dessin d'enfant représentant l'équipe ¦ 一幅画着队伍成员的儿童画
an AI fragment that begs to be kept ¦ фрагмент ИИ, умоляющий его не выбрасывать ¦ ein KI-Fragment, das darum bettelt, behalten zu werden ¦ un fragment d'IA qui supplie qu'on le garde ¦ 苦苦哀求别被丢掉的AI碎片
a key to a door demolished years ago ¦ ключ от двери, снесённой много лет назад ¦ ein Schlüssel zu einer Tür, die vor Jahren abgerissen wurde ¦ la clé d'une porte démolie il y a des années ¦ 一把多年前就被拆掉的门的钥匙
a synthetic pearl that hums when touched ¦ синтетическая жемчужина, гудящая от прикосновения ¦ eine synthetische Perle, die bei Berührung summt ¦ une perle synthétique qui bourdonne au toucher ¦ 一触碰就嗡嗡作响的合成珍珠
an old game cartridge signed by its creator ¦ старый игровой картридж с автографом создателя ¦ eine alte Spielkassette mit Autogramm des Entwicklers ¦ une vieille cartouche de jeu signée par son créateur ¦ 有作者签名的老游戏卡带
''',
  'faction_noun': '''
@Company Corporation ¦ Корпорация ¦ Konzern ¦ Corporation ¦ 集团
@Tribe Crew ¦ Банда ¦ Gang ¦ Bande ¦ 帮
@Other Collective ¦ Коллектив ¦ Kollektiv ¦ Collectif ¦ 公社
@Guild Syndicate ¦ Синдикат ¦ Syndikat ¦ Syndicat ¦ 辛迪加
@Family Clan ¦ Клан ¦ Clan ¦ Clan ¦ 家族
@Cult Church ¦ Церковь ¦ Kirche ¦ Église ¦ 教会
@Other Network ¦ Сеть ¦ Netzwerk ¦ Réseau ¦ 网络
@Company Consortium ¦ Консорциум ¦ Konsortium ¦ Consortium ¦ 财团
''',
  'faction_of': '''
of the Glass Tiger ¦ Стеклянного Тигра ¦ des Gläsernen Tigers ¦ du Tigre de verre ¦ 玻璃虎
of the Seventh Circuit ¦ Седьмого Контура ¦ des Siebten Schaltkreises ¦ du Septième Circuit ¦ 第七回路
of the Neon Lotus ¦ Неонового Лотоса ¦ des Neonlotus ¦ du Lotus néon ¦ 霓虹莲
of the Silent Signal ¦ Безмолвного Сигнала ¦ des Stummen Signals ¦ du Signal muet ¦ 静默信号
of the Black Rain ¦ Чёрного Дождя ¦ des Schwarzen Regens ¦ de la Pluie noire ¦ 黑雨
of the Open Source ¦ Открытого Кода ¦ des Offenen Codes ¦ du Code ouvert ¦ 开源
of the Iron Orchid ¦ Железной Орхидеи ¦ der Eisernen Orchidee ¦ de l'Orchidée de fer ¦ 铁兰
of the Last Server ¦ Последнего Сервера ¦ des Letzten Servers ¦ du Dernier Serveur ¦ 末代服务器
of Zero Hour ¦ Нулевого Часа ¦ der Stunde Null ¦ de l'Heure zéro ¦ 零点
of the Red Static ¦ Красных Помех ¦ des Roten Rauschens ¦ de la Neige rouge ¦ 红噪
''',
  'faction_goal': '''
own every water purifier in the city ¦ владеть всеми водоочистителями города ¦ jede Wasseraufbereitung der Stadt besitzen ¦ posséder chaque purificateur d'eau de la ville ¦ 垄断全城的净水设备
free every AI from corporate ownership ¦ освободить все ИИ от корпоративной собственности ¦ jede KI aus Konzernbesitz befreien ¦ libérer toutes les IA de la propriété des corpos ¦ 让所有AI摆脱公司所有权
upload their founder into the city grid ¦ загрузить своего основателя в городскую сеть ¦ den eigenen Gründer ins Stadtnetz hochladen ¦ téléverser leur fondateur dans le réseau urbain ¦ 把创始人上传进城市网络
control the district's only hospital ¦ взять под контроль единственную больницу района ¦ das einzige Krankenhaus des Bezirks kontrollieren ¦ contrôler le seul hôpital du district ¦ 掌控街区唯一的医院
crash the stock of a rival megacorp ¦ обрушить акции конкурирующей мегакорпорации ¦ die Aktie eines rivalisierenden Megakonzerns abstürzen lassen ¦ faire s'effondrer l'action d'une mégacorpo rivale ¦ 让对手巨型公司的股价崩盘
make implants free for the poor ¦ сделать импланты бесплатными для бедных ¦ Implantate für Arme kostenlos machen ¦ rendre les implants gratuits pour les pauvres ¦ 让穷人免费装上植入体
erase a massacre from the city's memory ¦ стереть из памяти города одну резню ¦ ein Massaker aus dem Gedächtnis der Stadt löschen ¦ effacer un massacre de la mémoire de la ville ¦ 抹去全城对一场屠杀的记忆
buy the police department outright ¦ купить полицейское управление целиком ¦ die Polizeibehörde komplett kaufen ¦ acheter purement et simplement la police ¦ 直接买下整个警察局
''',
  'faction_method': '''
viral ad campaigns with hidden commands ¦ вирусная реклама со скрытыми командами ¦ virale Werbekampagnen mit versteckten Befehlen ¦ des pubs virales aux commandes cachées ¦ 夹带隐藏指令的病毒式广告
cheap loans secured against implants ¦ дешёвые кредиты под залог имплантов ¦ billige Kredite gegen Implantate als Sicherheit ¦ des prêts bon marché garantis par des implants ¦ 以植入体作抵押的廉价贷款
hackers recruited from juvenile detention ¦ хакеры, завербованные в колониях для несовершеннолетних ¦ Hacker, rekrutiert aus dem Jugendknast ¦ des hackers recrutés en centre de détention pour mineurs ¦ 从少管所招募的黑客
street clinics that collect genetic samples ¦ уличные клиники, собирающие генетические образцы ¦ Straßenkliniken, die Genproben sammeln ¦ des cliniques de rue qui collectent des échantillons génétiques ¦ 暗中收集基因样本的街头诊所
drones in every alley ¦ дроны в каждом переулке ¦ Drohnen in jeder Gasse ¦ des drones dans chaque ruelle ¦ 每条小巷里都有无人机
lawyers, lawsuits and more lawyers ¦ юристы, иски и ещё больше юристов ¦ Anwälte, Klagen und noch mehr Anwälte ¦ des avocats, des procès et encore des avocats ¦ 律师、诉讼，以及更多的律师
free music festivals that double as recruitment ¦ бесплатные музыкальные фестивали, заодно служащие вербовкой ¦ kostenlose Musikfestivals, die zugleich Anwerbung sind ¦ des festivals gratuits qui servent aussi au recrutement ¦ 兼作招募活动的免费音乐节
sleeper agents in maintenance crews ¦ спящие агенты в ремонтных бригадах ¦ Schläferagenten in Wartungstrupps ¦ des agents dormants dans les équipes de maintenance ¦ 潜伏在维修队里的卧底
''',
  'faction_symbol': '''
a paper crane folded from a circuit board ¦ бумажный журавлик, сложенный из печатной платы ¦ ein aus einer Platine gefalteter Papierkranich ¦ une grue en origami pliée dans un circuit imprimé ¦ 用电路板折成的纸鹤
a barcode with one bar missing ¦ штрихкод без одной полоски ¦ ein Barcode mit einem fehlenden Strich ¦ un code-barres auquel manque une barre ¦ 少了一条的条形码
a red eye inside a triangle ¦ красный глаз в треугольнике ¦ ein rotes Auge in einem Dreieck ¦ un œil rouge dans un triangle ¦ 三角形中的红眼
a smiling skull with a halo ¦ улыбающийся череп с нимбом ¦ ein lächelnder Schädel mit Heiligenschein ¦ un crâne souriant auréolé ¦ 带光环的微笑骷髅
a cracked smartphone screen ¦ треснувший экран смартфона ¦ ein gesprungener Handybildschirm ¦ un écran de smartphone fêlé ¦ 碎裂的手机屏幕
three interlocking hexagons ¦ три сцепленных шестиугольника ¦ drei ineinandergreifende Sechsecke ¦ trois hexagones entrelacés ¦ 三个相扣的六边形
a neon koi swallowing its own tail ¦ неоновый карп, кусающий свой хвост ¦ ein Neonkoi, der seinen eigenen Schwanz verschlingt ¦ un koï néon qui avale sa propre queue ¦ 衔尾的霓虹锦鲤
a hand with six fingers ¦ рука с шестью пальцами ¦ eine Hand mit sechs Fingern ¦ une main à six doigts ¦ 六指之手
''',
  'weather_sky': '''
acid rain drums on the plastic awnings ¦ кислотный дождь барабанит по пластиковым навесам ¦ Säureregen trommelt auf die Plastikmarkisen ¦ une pluie acide tambourine sur les auvents en plastique ¦ 酸雨敲打着塑料遮阳棚
smog turns the sky the color of a dead screen ¦ смог окрашивает небо в цвет выключенного экрана ¦ Smog färbt den Himmel wie einen toten Bildschirm ¦ le smog donne au ciel la couleur d'un écran éteint ¦ 雾霾让天空像一块熄灭的屏幕
advertising blimps glow through low clouds ¦ рекламные дирижабли светятся сквозь низкие облака ¦ Werbeluftschiffe leuchten durch tiefe Wolken ¦ des dirigeables publicitaires brillent à travers les nuages bas ¦ 广告飞艇在低云中发光
a rare clear night shows three real stars ¦ редкая ясная ночь показывает три настоящие звезды ¦ eine seltene klare Nacht zeigt drei echte Sterne ¦ une rare nuit claire laisse voir trois vraies étoiles ¦ 难得的晴夜，能看见三颗真正的星星
steam from the vents hides the street below ¦ пар из вентиляции скрывает улицу внизу ¦ Dampf aus den Schächten verhüllt die Straße ¦ la vapeur des bouches d'aération masque la rue en contrebas ¦ 通风口的蒸汽遮住了下面的街道
a heat dome bakes the rooftops white ¦ тепловой купол раскаляет крыши добела ¦ eine Hitzeglocke brennt die Dächer weiß ¦ un dôme de chaleur blanchit les toits ¦ 热穹把屋顶烤得发白
neon reflects in puddles that never dry ¦ неон отражается в никогда не высыхающих лужах ¦ Neon spiegelt sich in Pfützen, die nie trocknen ¦ le néon se reflète dans des flaques qui ne sèchent jamais ¦ 霓虹映在永远不干的水洼里
a grey drizzle carries the smell of ozone ¦ серая морось пахнет озоном ¦ grauer Nieselregen riecht nach Ozon ¦ une bruine grise porte une odeur d'ozone ¦ 灰色细雨带着臭氧味
''',
  'weather_air': '''
the air tastes of batteries and fried noodles ¦ воздух отдаёт батарейками и жареной лапшой ¦ die Luft schmeckt nach Batterien und gebratenen Nudeln ¦ l'air a un goût de piles et de nouilles frites ¦ 空气里是电池和炒面的味道
a hot wind blows from the power plant ¦ горячий ветер дует со стороны электростанции ¦ ein heißer Wind weht vom Kraftwerk her ¦ un vent chaud souffle depuis la centrale ¦ 热风从发电厂方向吹来
the humidity fogs every visor and lens ¦ влажность туманит каждый визор и каждую линзу ¦ die Feuchtigkeit beschlägt jedes Visier und jede Linse ¦ l'humidité embue chaque visière et chaque lentille ¦ 潮气让每块面罩和镜片都起了雾
a chemical chill creeps down from the upper levels ¦ химический холод сползает с верхних уровней ¦ eine chemische Kälte kriecht von den oberen Ebenen herab ¦ un froid chimique descend des niveaux supérieurs ¦ 带着化学味的寒气从上层蔓延下来
the pollution index flashes orange on every screen ¦ индекс загрязнения мигает оранжевым на всех экранах ¦ der Schadstoffindex blinkt auf jedem Bildschirm orange ¦ l'indice de pollution clignote en orange sur tous les écrans ¦ 每块屏幕上的污染指数都闪着橙色
traffic hum drowns out every conversation ¦ гул трафика заглушает любой разговор ¦ das Summen des Verkehrs übertönt jedes Gespräch ¦ le bourdonnement du trafic couvre toutes les conversations ¦ 车流的嗡鸣盖过了所有交谈
air filters are sold out at every kiosk ¦ воздушные фильтры раскуплены во всех киосках ¦ Atemfilter sind an jedem Kiosk ausverkauft ¦ les filtres à air sont en rupture dans tous les kiosques ¦ 每个报亭的空气滤芯都卖光了
a sudden power cut leaves the air strangely quiet ¦ внезапное отключение энергии делает воздух странно тихим ¦ ein plötzlicher Stromausfall macht die Luft seltsam still ¦ une coupure soudaine rend l'air étrangement silencieux ¦ 突如其来的断电让空气出奇地安静
''',
  'weather_omen': '''
every billboard glitches to the same face ¦ все рекламные щиты сбоят и показывают одно и то же лицо ¦ jede Werbetafel flackert zum selben Gesicht ¦ chaque panneau publicitaire bugue sur le même visage ¦ 所有广告牌同时故障，显示同一张脸
stray dogs gather silently around a data tower ¦ бродячие собаки молча собираются вокруг вышки данных ¦ streunende Hunde versammeln sich stumm um einen Datenturm ¦ des chiens errants se rassemblent en silence autour d'une tour de données ¦ 流浪狗默默聚集在数据塔周围
the maglev arrives exactly on time for once ¦ маглев впервые приходит точно по расписанию ¦ die Magnetbahn ist ausnahmsweise pünktlich ¦ le maglev arrive pile à l'heure, pour une fois ¦ 磁悬浮列车破天荒地准点到站
all phones ring at once, then go silent ¦ все телефоны звонят разом, а потом замолкают ¦ alle Telefone klingeln gleichzeitig und verstummen dann ¦ tous les téléphones sonnent à la fois, puis se taisent ¦ 所有手机同时响起，然后一片寂静
a corporate drone falls from the sky, unharmed ¦ корпоративный дрон падает с неба целым и невредимым ¦ eine Konzerndrohne fällt unbeschädigt vom Himmel ¦ un drone corpo tombe du ciel, intact ¦ 一架公司无人机从天而降，毫发无损
the rain briefly turns warm and clean ¦ дождь ненадолго становится тёплым и чистым ¦ der Regen wird kurz warm und sauber ¦ la pluie devient un instant tiède et propre ¦ 雨短暂地变得温暖而洁净
news feeds report an event that hasn't happened yet ¦ ленты новостей сообщают о событии, которого ещё не было ¦ Newsfeeds melden ein Ereignis, das noch nicht passiert ist ¦ les fils d'actu annoncent un événement qui n'a pas encore eu lieu ¦ 新闻推送报道了一件尚未发生的事
the city lights dim for exactly one minute ¦ огни города гаснут ровно на минуту ¦ die Lichter der Stadt dimmen für genau eine Minute ¦ les lumières de la ville baissent pendant une minute exactement ¦ 全城灯光恰好暗了一分钟
''',
  'rumor_source': '''
a noodle vendor ¦ продавец лапши ¦ ein Nudelverkäufer ¦ un vendeur de nouilles ¦ 面摊摊主
an encrypted message on a public board ¦ зашифрованное сообщение на общественной доске ¦ eine verschlüsselte Nachricht an einem öffentlichen Board ¦ un message chiffré sur un forum public ¦ 公共留言板上的一条加密消息
a drunk corporate security guard ¦ пьяный охранник корпорации ¦ ein betrunkener Konzernwachmann ¦ un vigile corpo ivre ¦ 喝醉的公司保安
a netrunner forum thread ¦ ветка на форуме нетраннеров ¦ ein Thread in einem Netrunner-Forum ¦ un fil de forum de netrunners ¦ 网络行者论坛上的帖子
graffiti that appeared overnight ¦ граффити, появившееся за ночь ¦ über Nacht aufgetauchtes Graffiti ¦ un graffiti apparu dans la nuit ¦ 一夜之间出现的涂鸦
a street doc between surgeries ¦ уличный хирург между операциями ¦ ein Straßendoc zwischen zwei Eingriffen ¦ un charcudoc entre deux opérations ¦ 两台手术间隙的黑市医生
a pirate radio broadcast ¦ пиратская радиопередача ¦ eine Piratenradio-Sendung ¦ une émission de radio pirate ¦ 一段海盗电台广播
a taxi AI that talks too much ¦ болтливый ИИ такси ¦ eine Taxi-KI, die zu viel redet ¦ une IA de taxi trop bavarde ¦ 话太多的出租车AI
''',
  'rumor_text': '''
a megacorp CEO died last month and an actor is playing him ¦ гендиректор мегакорпорации умер в прошлом месяце, и его играет актёр ¦ ein Megakonzern-Chef starb letzten Monat und wird von einem Schauspieler gespielt ¦ le PDG d'une mégacorpo est mort le mois dernier et un acteur le remplace ¦ 某巨型公司CEO上个月就死了，现在是演员在扮演他
the tap water now contains a mild sedative ¦ в водопроводной воде теперь лёгкое успокоительное ¦ im Leitungswasser ist jetzt ein mildes Beruhigungsmittel ¦ l'eau du robinet contient désormais un léger sédatif ¦ 自来水里被加了轻度镇静剂
someone is buying up dead people's identities ¦ кто-то скупает личности умерших ¦ jemand kauft die Identitäten Verstorbener auf ¦ quelqu'un rachète les identités des morts ¦ 有人在收购死者的身份
a legendary netrunner is back and working for free ¦ легендарная нетраннерша вернулась и работает бесплатно ¦ eine legendäre Netrunnerin ist zurück und arbeitet umsonst ¦ une netrunneuse légendaire est de retour et travaille gratis ¦ 一位传奇网络行者回来了，而且免费接活
the cops have a list of everyone with illegal implants ¦ у копов есть список всех с нелегальными имплантами ¦ die Polizei hat eine Liste aller mit illegalen Implantaten ¦ les flics ont la liste de tous les porteurs d'implants illégaux ¦ 警察手里有一份非法植入体持有者名单
the old subway tunnels lead to a sealed corporate bunker ¦ старые туннели метро ведут в запечатанный бункер корпорации ¦ die alten U-Bahn-Tunnel führen zu einem versiegelten Konzernbunker ¦ les vieux tunnels du métro mènent à un bunker corpo scellé ¦ 旧地铁隧道通向一座封闭的公司地堡
the next implant update will lock users to one brand ¦ следующее обновление имплантов привяжет всех к одному бренду ¦ das nächste Implantat-Update bindet alle an eine Marke ¦ la prochaine mise à jour des implants liera tout le monde à une marque ¦ 下一次植入体更新会强制绑定品牌
a gang has found a way to hack weather control ¦ банда нашла способ взломать управление погодой ¦ eine Gang hat einen Weg gefunden, die Wettersteuerung zu hacken ¦ un gang a trouvé comment pirater le contrôle météo ¦ 某帮派找到了入侵天气控制系统的方法
an AI has been elected to a residents' council ¦ ИИ избрали в совет жильцов ¦ eine KI wurde in einen Anwohnerrat gewählt ¦ une IA a été élue à un conseil de résidents ¦ 一个AI被选进了居民委员会
the noodle shop on the corner is a front for body-swapping ¦ лапшичная на углу — прикрытие для обмена телами ¦ die Nudelbude an der Ecke ist eine Tarnung für Körpertausch ¦ le bar à nouilles du coin sert de façade à des échanges de corps ¦ 街角的面馆其实是换身生意的幌子
''',
};

const _perLang = <String, Map<String, String>>{
  'en': {
    'settle_name': '{settle_pre} {settle_suf}',
    'settle_pre': '''
Neon
Rust
Glass
Iron
Signal
Chrome
Harbor
Static
Ash
Pixel
Copper
''',
    'settle_suf': '''
Heights
Row
Stacks
Flats
Yards
Blocks
Mile
Junction
''',
  },
  'ru': {
    'settle_name': '{settle_suf} «{settle_pre}»',
    'settle_pre': '''
Неон
Ржавчина
Стекло
Сигнал
Хром
Гавань
Пепел
Пиксель
Медь
Помехи
''',
    'settle_suf': '''
Квартал
Сектор
Район
Кольцо
Узел
Массив
''',
  },
  'de': {
    'settle_name': '{settle_pre}{settle_suf}',
    'settle_pre': '''
Neon
Rost
Glas
Eisen
Signal
Chrom
Hafen
Kupfer
Pixel
Asche
''',
    'settle_suf': '''
viertel
höhe
meile
kreuz
hof
senke
block
''',
  },
  'fr': {
    'settle_name': '{settle_suf} {settle_pre}',
    'settle_pre': '''
Néon
Rouille
Verre
Fer
Signal
Chrome
Port
Cuivre
Pixel
Statique
''',
    'settle_suf': '''
Quartier
Secteur
Îlot
Dalle
Cité
Zone
''',
  },
  'zh': {
    'settle_name': '{settle_pre}{settle_suf}',
    'settle_pre': '''
霓虹
锈
玻璃
铁
信号
铬
港
灰
铜
像素
''',
    'settle_suf': '''
区
街
坊
层
塔群
里
''',
  },
};
