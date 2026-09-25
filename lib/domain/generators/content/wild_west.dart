import '../content_format.dart';

/// Dust, noon trains, water rights and wanted posters.
final wildWestContent =
    PackContent.build(rows: _rows, names: _names, perLang: _perLang);

const _names = <String, String>{
  'frontier_given_f': '''
Lorena ¦ Лорена ¦ 洛蕾娜
Maybelle ¦ Мэйбелл ¦ 梅贝尔
Josephine ¦ Жозефина ¦ 约瑟芬
Eliza ¦ Элайза ¦ 伊莱扎
Calla ¦ Калла ¦ 卡拉
Martha ¦ Марта ¦ 玛莎
Ruby ¦ Руби ¦ 鲁比
Temperance ¦ Темперанс ¦ 坦珀伦丝
Delia ¦ Делия ¦ 迪莉娅
Jo ¦ Джо ¦ 乔
Pearl ¦ Перл ¦ 珀尔
Belle ¦ Белль ¦ 贝儿
Cora ¦ Кора ¦ 科拉
''',
  'frontier_given_m': '''
Jebediah ¦ Джебедайя ¦ 杰贝代亚
Cole ¦ Коул ¦ 科尔
Eli ¦ Илай ¦ 伊莱
Hollis ¦ Холлис ¦ 霍利斯
Clayton ¦ Клейтон ¦ 克莱顿
Ezekiel ¦ Иезекиль ¦ 以西结
Boone ¦ Бун ¦ 布恩
Luther ¦ Лютер ¦ 路德
Calvin ¦ Кэлвин ¦ 卡尔文
Walker ¦ Уокер ¦ 沃克
Augustus ¦ Огастес ¦ 奥古斯都
Wade ¦ Уэйд ¦ 韦德
Asa ¦ Эйса ¦ 阿萨
''',
  'frontier_family': '''
Harlan ¦ Харлан ¦ 哈伦
McCready ¦ Маккриди ¦ 麦克里迪
Stroud ¦ Страуд ¦ 斯特劳德
Carver ¦ Карвер ¦ 卡弗
Whitaker ¦ Уитакер ¦ 惠特克
Pruitt ¦ Прюитт ¦ 普鲁伊特
Bancroft ¦ Бэнкрофт ¦ 班克罗夫特
Tolliver ¦ Толливер ¦ 托利弗
Hatch ¦ Хэтч ¦ 哈奇
Colter ¦ Колтер ¦ 科尔特
Ramirez ¦ Рамирес ¦ 拉米雷斯
Blackburn ¦ Блэкберн ¦ 布莱克本
Ellery ¦ Эллери ¦ 埃勒里
Tate ¦ Тейт ¦ 泰特
''',
  'outlaw_family': '{frontier_family}',
};

const _rows = <String, String>{
  'cultures': '''
@frontier Frontier folk ¦ Жители фронтира ¦ Grenzland-Leute ¦ Gens de la frontière ¦ 边疆人
@outlaw Outlaws ¦ Бандиты ¦ Gesetzlose ¦ Hors-la-loi ¦ 亡命徒
''',
  'outlaw_given': '''
“{outlaw_nick}” {frontier_given} ¦ «{outlaw_nick}» {frontier_given} ¦ „{outlaw_nick}“ {frontier_given} ¦ “{outlaw_nick}” {frontier_given} ¦ “{outlaw_nick}”{frontier_given}
''',
  'outlaw_nick': '''
Deadeye ¦ Меткий Глаз ¦ Adlerauge ¦ Œil-de-Lynx ¦ 神枪手
Two-Bit ¦ Два Цента ¦ Zwei-Cent ¦ Deux-Sous ¦ 两毛钱
Whiskey ¦ Виски ¦ Whiskey ¦ Whisky ¦ 威士忌
Sidewinder ¦ Гремучка ¦ Klapperschlange ¦ Crotale ¦ 响尾蛇
Dusty ¦ Суховей ¦ Staubteufel ¦ Poussière ¦ 尘土
Lucky ¦ Везунчик ¦ Glückspilz ¦ Porte-Bonheur ¦ 幸运儿
Kid ¦ Малыш ¦ Kid ¦ Gamin ¦ 小子
Sawbones ¦ Костоправ ¦ Knochenflicker ¦ Rebouteux ¦ 接骨匠
Preacher ¦ Проповедник ¦ Prediger ¦ Prêcheur ¦ 牧师
Ace ¦ Туз ¦ Ass ¦ As ¦ 王牌
Tumbleweed ¦ Перекати-поле ¦ Steppenroller ¦ Virevoltant ¦ 风滚草
Six-Gun ¦ Шестизарядник ¦ Sechsschuss ¦ Six-Coups ¦ 六响枪
Mesquite ¦ Мескит ¦ Mesquite ¦ Mesquite ¦ 牧豆树
Coyote ¦ Койот ¦ Kojote ¦ Coyote ¦ 郊狼
''',
  'epithet': '''
the Fastest Gun in the Territory ¦ Самый Быстрый Стрелок Территории ¦ der schnellste Revolver im Territorium ¦ la Gâchette la plus rapide du Territoire ¦ 领地第一快枪
the Parson ¦ Пастор ¦ der Pfarrer~die Pfarrerin ¦ le Pasteur~la Pasteure ¦ 牧师
Hangman's Luck ¦ Удача Висельника ¦ Henkersglück ¦ Chance-du-Pendu ¦ 绞刑架上的好运
the Silver Spur ¦ Серебряная Шпора ¦ der Silbersporn ¦ l'Éperon d'Argent ¦ 银马刺
One-Shot ¦ Один Выстрел ¦ Einschuss ¦ Coup-Unique ¦ 一枪
the Dust Devil ¦ Пыльный Вихрь ¦ der Staubteufel ¦ le Diable de Poussière ¦ 尘卷风
Railroad ¦ Железка ¦ Schiene ¦ Rail ¦ 铁轨
the Undertaker's Friend ¦ Друг Гробовщика~Подруга Гробовщика ¦ der Freund des Totengräbers~die Freundin des Totengräbers ¦ l'Ami du Croque-Mort~l'Amie du Croque-Mort ¦ 殡葬人之友
Cold Coffee ¦ Холодный Кофе ¦ Kalter Kaffee ¦ Café-Froid ¦ 冷咖啡
the Stranger ¦ Чужак~Чужачка ¦ der Fremde~die Fremde ¦ l'Étranger~l'Étrangère ¦ 陌生人
''',
  'ancestry': '''
@frontier homesteaders' child ¦ сын поселенцев~дочь поселенцев ¦ Siedlerkind ¦ enfant de colons ¦ 拓荒者的孩子
@frontier transplant from an eastern city ¦ приезжий с Востока~приезжая с Востока ¦ Zugezogener aus dem Osten~Zugezogene aus dem Osten ¦ citadin venu de l'Est~citadine venue de l'Est ¦ 从东部城市来的人
@outlaw drifter with no past ¦ бродяга без прошлого ¦ Herumtreiber ohne Vergangenheit~Herumtreiberin ohne Vergangenheit ¦ vagabond sans passé~vagabonde sans passé ¦ 没有过去的流浪者
@frontier immigrant from across the sea ¦ переселенец из-за моря~переселенка из-за моря ¦ Einwanderer von jenseits des Meeres~Einwanderin von jenseits des Meeres ¦ immigrant d'outre-mer~immigrante d'outre-mer ¦ 远渡重洋的移民
@outlaw raised in a mining camp ¦ выросший в шахтёрском лагере~выросшая в шахтёрском лагере ¦ in einem Bergbaulager aufgewachsen ¦ élevé dans un camp de mineurs~élevée dans un camp de mineurs ¦ 在矿营里长大
war veteran ¦ ветеран войны ¦ Kriegsveteran~Kriegsveteranin ¦ vétéran de guerre ¦ 退伍老兵
''',
  'role': '''
sheriff ¦ шериф ¦ Sheriff ¦ shérif ¦ 警长
saloon owner ¦ хозяин салуна~хозяйка салуна ¦ Saloonbesitzer~Saloonbesitzerin ¦ patron de saloon~patronne de saloon ¦ 酒馆老板
blacksmith and farrier ¦ кузнец и коваль ¦ Schmied und Hufschmied~Schmiedin und Hufschmiedin ¦ forgeron-maréchal~forgeronne-maréchale ¦ 铁匠兼蹄铁匠
stagecoach driver ¦ кучер дилижанса ¦ Postkutscher~Postkutscherin ¦ conducteur de diligence~conductrice de diligence ¦ 驿站马车夫
bounty hunter ¦ охотник за головами~охотница за головами ¦ Kopfgeldjäger~Kopfgeldjägerin ¦ chasseur de primes~chasseuse de primes ¦ 赏金猎人
prospector ¦ старатель~старательница ¦ Goldsucher~Goldsucherin ¦ prospecteur~prospectrice ¦ 淘金客
traveling preacher ¦ странствующий проповедник~странствующая проповедница ¦ Wanderprediger~Wanderpredigerin ¦ prédicateur itinérant~prédicatrice itinérante ¦ 巡回传道人
cattle rancher ¦ скотовод ¦ Rinderzüchter~Rinderzüchterin ¦ éleveur de bétail~éleveuse de bétail ¦ 牧场主
card sharp ¦ карточный шулер ¦ Falschspieler~Falschspielerin ¦ tricheur aux cartes~tricheuse aux cartes ¦ 老千
telegraph operator ¦ телеграфист~телеграфистка ¦ Telegrafist~Telegrafistin ¦ télégraphiste ¦ 电报员
railroad surveyor ¦ железнодорожный топограф ¦ Eisenbahnvermesser~Eisenbahnvermesserin ¦ géomètre du chemin de fer ¦ 铁路勘测员
town doctor ¦ городской врач ¦ Stadtarzt~Stadtärztin ¦ médecin de la ville ¦ 镇上的医生
''',
  'appearance': '''
a hat with a bullet hole through the crown ¦ шляпа с пулевым отверстием в тулье ¦ ein Hut mit einem Einschussloch in der Krone ¦ un chapeau troué d'une balle ¦ 帽顶被子弹打穿的帽子
spurs that jingle with every step ¦ шпоры, звенящие на каждом шагу ¦ Sporen, die bei jedem Schritt klirren ¦ des éperons qui tintent à chaque pas ¦ 每走一步都叮当作响的马刺
a duster coat grey with trail dust ¦ плащ, серый от дорожной пыли ¦ ein Staubmantel, grau vom Staub der Wege ¦ un cache-poussière gris de la poussière des pistes ¦ 被路上尘土染灰的长风衣
a sun-cracked face and pale eyes ¦ потрескавшееся от солнца лицо и светлые глаза ¦ ein sonnenrissiges Gesicht und helle Augen ¦ un visage craquelé par le soleil et des yeux pâles ¦ 被太阳晒裂的脸和浅色的眼睛
a gold tooth that flashes with every smile ¦ золотой зуб, блестящий при каждой улыбке ¦ ein Goldzahn, der bei jedem Lächeln aufblitzt ¦ une dent en or qui brille à chaque sourire ¦ 一笑就闪光的金牙
a rattlesnake-skin hatband ¦ лента на шляпе из кожи гремучей змеи ¦ ein Hutband aus Klapperschlangenhaut ¦ un ruban de chapeau en peau de serpent à sonnette ¦ 响尾蛇皮帽带
''',
  'motivation': '''
find the man who burned the homestead ¦ найти человека, спалившего родное хозяйство ¦ den Mann finden, der den Hof niedergebrannt hat ¦ retrouver l'homme qui a brûlé la ferme ¦ 找到烧毁家园的那个人
strike gold before the claim runs out ¦ найти золото, пока не истёк срок заявки ¦ Gold finden, bevor der Claim ausläuft ¦ trouver de l'or avant l'expiration de la concession ¦ 在矿权到期前挖到金子
bring law to a lawless town ¦ принести закон в беззаконный город ¦ Recht in eine gesetzlose Stadt bringen ¦ apporter la loi dans une ville sans loi ¦ 为无法之镇带来法律
buy back the family ranch ¦ выкупить семейное ранчо ¦ die Familienranch zurückkaufen ¦ racheter le ranch familial ¦ 赎回家族牧场
clear their name of a murder charge ¦ снять с себя обвинение в убийстве ¦ den eigenen Namen von einer Mordanklage reinwaschen ¦ se laver d'une accusation de meurtre ¦ 洗清自己的谋杀罪名
reach the coast before winter ¦ добраться до побережья до зимы ¦ vor dem Winter die Küste erreichen ¦ atteindre la côte avant l'hiver ¦ 在冬天前抵达海岸
''',
  'secret': '''
has a price on their head two territories over ¦ за голову назначена награда через две территории отсюда ¦ auf den eigenen Kopf ist zwei Territorien weiter ein Preis ausgesetzt ¦ a sa tête mise à prix deux territoires plus loin ¦ 在隔两个领地的地方被悬赏通缉
rode with the gang that robbed the bank ¦ ездил с бандой, ограбившей банк~ездила с бандой, ограбившей банк ¦ ist mit der Bande geritten, die die Bank ausgeraubt hat ¦ a chevauché avec la bande qui a braqué la banque ¦ 曾和抢银行的那伙人一起骑行
knows where the stagecoach gold is buried ¦ знает, где зарыто золото из дилижанса ¦ weiß, wo das Gold der Postkutsche vergraben ist ¦ sait où est enterré l'or de la diligence ¦ 知道驿站马车的黄金埋在哪里
is married under two names ¦ женат под двумя именами~замужем под двумя именами ¦ ist unter zwei Namen verheiratet ¦ est marié sous deux noms~est mariée sous deux noms ¦ 用两个名字结过婚
shot the last sheriff in the back ¦ выстрелил прежнему шерифу в спину~выстрелила прежнему шерифу в спину ¦ hat dem letzten Sheriff in den Rücken geschossen ¦ a tiré dans le dos du dernier shérif ¦ 从背后射杀了上一任警长
salted the mine with gold to sell it ¦ подбросил в шахту золото, чтобы её продать~подбросила в шахту золото, чтобы её продать ¦ hat die Mine mit Gold präpariert, um sie zu verkaufen ¦ a truqué la mine avec de l'or pour la vendre ¦ 往矿里撒金子好把它卖掉
''',
  'settle_size': '''
@Village a whistle-stop of {#2d6*5} folk ¦ полустанок на {#2d6*5} человек ¦ ein Bahnhaltepunkt mit {#2d6*5} Leuten ¦ une halte ferroviaire de {#2d6*5} âmes ¦ {#2d6*5}人的铁路小站
@Village a mining camp of about {#4d6*10} souls ¦ шахтёрский лагерь, около {#4d6*10} душ ¦ ein Bergbaulager mit etwa {#4d6*10} Seelen ¦ un camp minier d'environ {#4d6*10} âmes ¦ 约{#4d6*10}人的矿营
@Town a cattle town of some {#3d6*100} people ¦ скотоводческий городок, около {#3d6*100} жителей ¦ eine Rinderstadt mit rund {#3d6*100} Einwohnern ¦ une ville d'éleveurs d'environ {#3d6*100} habitants ¦ 约{#3d6*100}人的牛镇
@Town a railroad boomtown of {#2d10*500} people ¦ растущий железнодорожный город на {#2d10*500} жителей ¦ eine Eisenbahn-Boomstadt mit {#2d10*500} Einwohnern ¦ une ville-champignon du rail de {#2d10*500} habitants ¦ {#2d10*500}人的铁路新兴城镇
''',
  'settle_feature': '''
a saloon with a piano nobody can play ¦ салун с пианино, на котором никто не умеет играть ¦ ein Saloon mit einem Klavier, das niemand spielen kann ¦ un saloon avec un piano dont personne ne sait jouer ¦ 有一架没人会弹的钢琴的酒馆
a gallows built before the church ¦ виселица, построенная раньше церкви ¦ ein Galgen, der vor der Kirche gebaut wurde ¦ une potence construite avant l'église ¦ 比教堂建得还早的绞刑架
a water tower riddled with bullet holes ¦ водонапорная башня, изрешечённая пулями ¦ ein von Kugeln durchsiebter Wasserturm ¦ un château d'eau criblé de balles ¦ 布满弹孔的水塔
a railroad that ends in the middle of town ¦ железная дорога, обрывающаяся посреди города ¦ eine Eisenbahn, die mitten in der Stadt endet ¦ un chemin de fer qui s'arrête au milieu de la ville ¦ 在镇中央戛然而止的铁路
a boot hill with more graves than residents ¦ кладбище на холме, где могил больше, чем жителей ¦ ein Stiefelhügel mit mehr Gräbern als Einwohnern ¦ un cimetière de colline avec plus de tombes que d'habitants ¦ 坟墓比居民还多的靴山墓地
a mine entrance boarded up and covered in warnings ¦ вход в шахту, заколоченный и увешанный предупреждениями ¦ ein zugenagelter Mineneingang voller Warnschilder ¦ une entrée de mine condamnée couverte d'avertissements ¦ 钉满警告牌的封闭矿口
a hotel with a real bathtub ¦ отель с настоящей ванной ¦ ein Hotel mit einer echten Badewanne ¦ un hôtel avec une vraie baignoire ¦ 有真正浴缸的旅馆
a telegraph office that receives messages from nowhere ¦ телеграф, принимающий сообщения ниоткуда ¦ ein Telegrafenamt, das Nachrichten von nirgendwo empfängt ¦ un bureau du télégraphe qui reçoit des messages de nulle part ¦ 接收到不明来电的电报局
a dry riverbed where the town holds its fairs ¦ сухое русло, где город устраивает ярмарки ¦ ein ausgetrocknetes Flussbett, in dem die Stadt ihre Märkte abhält ¦ un lit de rivière asséché où la ville tient ses foires ¦ 镇上举办集市的干河床
a church whose bell was stolen from another town ¦ церковь с колоколом, украденным из другого города ¦ eine Kirche mit einer aus einer anderen Stadt gestohlenen Glocke ¦ une église dont la cloche a été volée à une autre ville ¦ 钟是从别的镇偷来的教堂
''',
  'settle_trouble': '''
a gang is coming on the noon train ¦ банда прибывает полуденным поездом ¦ eine Bande kommt mit dem Mittagszug ¦ une bande arrive par le train de midi ¦ 一伙匪徒要坐正午的火车来
the well has gone dry in the drought ¦ колодец пересох от засухи ¦ der Brunnen ist in der Dürre versiegt ¦ le puits s'est tari avec la sécheresse ¦ 大旱让井枯了
the railroad wants everyone's land ¦ железная дорога хочет забрать всю землю ¦ die Eisenbahn will das Land aller ¦ le chemin de fer veut les terres de tout le monde ¦ 铁路公司想要所有人的土地
cattle rustlers hit the ranches every full moon ¦ угонщики скота налетают на ранчо каждое полнолуние ¦ Viehdiebe überfallen die Ranches bei jedem Vollmond ¦ des voleurs de bétail frappent les ranchs à chaque pleine lune ¦ 偷牛贼每逢满月就来袭击牧场
the sheriff was found dead in his own jail ¦ шерифа нашли мёртвым в его собственной тюрьме ¦ der Sheriff wurde tot in seinem eigenen Gefängnis gefunden ¦ le shérif a été retrouvé mort dans sa propre prison ¦ 警长被发现死在自己的牢房里
a claim dispute is about to turn bloody ¦ спор за участок вот-вот станет кровавым ¦ ein Streit um einen Claim wird bald blutig ¦ une querelle de concession est sur le point de tourner au sang ¦ 一场矿权之争眼看就要见血
a fever is spreading through the camp ¦ по лагерю ползёт лихорадка ¦ ein Fieber breitet sich im Lager aus ¦ une fièvre se répand dans le camp ¦ 热病正在营地里蔓延
the bank is out of money and won't say why ¦ в банке кончились деньги, и никто не говорит почему ¦ der Bank ist das Geld ausgegangen, und keiner sagt warum ¦ la banque n'a plus d'argent et refuse de dire pourquoi ¦ 银行没钱了，却不肯说原因
a stranger has bought every bullet in town ¦ незнакомец скупил все патроны в городе ¦ ein Fremder hat jede Patrone der Stadt aufgekauft ¦ un étranger a acheté toutes les balles de la ville ¦ 一个陌生人买光了镇上所有的子弹
the mine makes strange noises at night ¦ по ночам из шахты доносятся странные звуки ¦ aus der Mine dringen nachts seltsame Geräusche ¦ la mine fait des bruits étranges la nuit ¦ 矿井夜里总传出怪声
''',
  'settle_authority': '''
a sheriff who has been paid off by everyone ¦ шериф, которому заплатили все ¦ ein Sheriff, den jeder geschmiert hat ¦ un shérif payé par tout le monde ¦ 被所有人都收买过的警长
the cattle baron who owns the water rights ¦ скотопромышленник, владеющий правами на воду ¦ der Rinderbaron, dem die Wasserrechte gehören ¦ le baron du bétail qui détient les droits sur l'eau ¦ 握有水权的牛业大亨
a mayor who won the office in a card game ¦ мэр, выигравший должность в карты ¦ ein Bürgermeister, der das Amt beim Kartenspiel gewann ¦ un maire qui a gagné son poste aux cartes ¦ 在牌桌上赢来职位的镇长
the railroad company's local agent ¦ местный агент железнодорожной компании ¦ der örtliche Vertreter der Eisenbahngesellschaft ¦ l'agent local de la compagnie ferroviaire ¦ 铁路公司的本地代理人
a widow who runs the saloon and the town ¦ вдова, управляющая салуном и городом ¦ eine Witwe, die den Saloon und die Stadt führt ¦ une veuve qui dirige le saloon et la ville ¦ 经营酒馆也掌管全镇的寡妇
a circuit judge who comes once a season ¦ выездной судья, приезжающий раз в сезон ¦ ein Reiserichter, der einmal pro Saison kommt ¦ un juge itinérant qui passe une fois par saison ¦ 每季来一次的巡回法官
a town council of three shopkeepers ¦ городской совет из трёх лавочников ¦ ein Stadtrat aus drei Ladenbesitzern ¦ un conseil municipal de trois boutiquiers ¦ 由三个店主组成的镇议会
the mining company's foreman ¦ бригадир горнодобывающей компании ¦ der Vorarbeiter der Bergbaugesellschaft ¦ le contremaître de la compagnie minière ¦ 矿业公司的工头
''',
  'est_type': '''
saloon ¦ салун ¦ Saloon ¦ saloon ¦ 酒馆
general store ¦ универсальный магазин ¦ Gemischtwarenladen ¦ magasin général ¦ 杂货店
livery stable ¦ платная конюшня ¦ Mietstall ¦ écurie de louage ¦ 马车行
boarding house ¦ пансион ¦ Pension ¦ pension de famille ¦ 寄宿旅店
assay office ¦ пробирная контора ¦ Goldprüfstelle ¦ bureau d'essai ¦ 金矿化验所
bathhouse and barbershop ¦ баня и цирюльня ¦ Badehaus mit Barbier ¦ bains et barbier ¦ 澡堂兼理发店
''',
  'est_adj': '''
Rusty ¦ ржавый~ржавая ¦ Rostigen ¦ rouillé~rouillée ¦ 锈
Golden ¦ золотой~золотая ¦ Goldenen ¦ doré~dorée ¦ 金
Lucky ¦ счастливый~счастливая ¦ Glücklichen ¦ chanceux~chanceuse ¦ 幸运
Thirsty ¦ жаждущий~жаждущая ¦ Durstigen ¦ assoiffé~assoiffée ¦ 渴
Lonesome ¦ одинокий~одинокая ¦ Einsamen ¦ solitaire ¦ 孤独
Silver ¦ серебряный~серебряная ¦ Silbernen ¦ argenté~argentée ¦ 银
Crooked ¦ кривой~кривая ¦ Krummen ¦ tordu~tordue ¦ 歪
Red ¦ красный~красная ¦ Roten ¦ rouge ¦ 红
Wild ¦ дикий~дикая ¦ Wilden ¦ sauvage ¦ 野
Dusty ¦ пыльный~пыльная ¦ Staubigen ¦ poussiéreux~poussiéreuse ¦ 尘土
''',
  'est_noun': '''
Horseshoe ¦ подкова#f ¦ Hufeisen#m ¦ Fer-à-Cheval#m ¦ 马蹄铁
Mule ¦ мул#m ¦ Maultier#m ¦ Mulet#m ¦ 骡子
Nugget ¦ самородок#m ¦ Goldklumpen#m ¦ Pépite#f ¦ 金块
Buffalo ¦ бизон#m ¦ Büffel#m ¦ Bison#m ¦ 野牛
Rattlesnake ¦ змея#f ¦ Klapperschlange#f ¦ Crotale#m ¦ 响尾蛇
Cactus ¦ кактус#m ¦ Kaktus#m ¦ Cactus#m ¦ 仙人掌
Boot ¦ сапог#m ¦ Stiefel#m ¦ Botte#f ¦ 靴子
Mustang ¦ мустанг#m ¦ Mustang#m ¦ Mustang#m ¦ 野马
Coyote ¦ койот#m ¦ Präriewolf#m ¦ Coyote#m ¦ 郊狼
Bullet ¦ пуля#f ¦ Kugel#f ¦ Balle#f ¦ 子弹
Widow ¦ вдова#f ¦ Witwe#f ¦ Veuve#f ¦ 寡妇
Canyon ¦ каньон#m ¦ Canyon#m ¦ Canyon#m ¦ 峡谷
Rose ¦ роза#f ¦ Rose#f ¦ Rose#f ¦ 玫瑰
''',
  'est_specialty': '''
whiskey that could strip paint ¦ виски, которым можно снимать краску ¦ Whiskey, der Farbe ablösen könnte ¦ un whisky à décaper la peinture ¦ 烈得能剥漆的威士忌
beans, bacon and strong coffee ¦ фасоль, бекон и крепкий кофе ¦ Bohnen, Speck und starker Kaffee ¦ haricots, lard et café fort ¦ 豆子、培根和浓咖啡
a poker game that never ends ¦ партия в покер, которая никогда не заканчивается ¦ ein Pokerspiel, das nie endet ¦ une partie de poker qui ne finit jamais ¦ 永不散场的扑克局
fresh horses, no questions asked ¦ свежие лошади без лишних вопросов ¦ frische Pferde, ohne Fragen ¦ des chevaux frais, sans questions ¦ 不问来路的新马
hot baths for a quarter ¦ горячая ванна за четвертак ¦ heiße Bäder für einen Vierteldollar ¦ un bain chaud pour vingt-cinq cents ¦ 两毛五一次的热水澡
supplies for prospectors on credit ¦ снаряжение для старателей в кредит ¦ Ausrüstung für Goldsucher auf Pump ¦ du matériel pour prospecteurs à crédit ¦ 赊给淘金客的补给
wanted posters papering a whole wall ¦ плакаты «Разыскивается» на всю стену ¦ Steckbriefe, die eine ganze Wand bedecken ¦ des avis de recherche tapissant un mur entier ¦ 贴满一整面墙的通缉令
gold weighed honestly, most days ¦ честное взвешивание золота — в большинстве случаев ¦ Gold, meist ehrlich gewogen ¦ de l'or pesé honnêtement, la plupart du temps ¦ 多数时候公道称量的金子
a piano player who knows every song ¦ пианист, знающий все песни ¦ ein Klavierspieler, der jedes Lied kennt ¦ un pianiste qui connaît toutes les chansons ¦ 什么歌都会弹的钢琴师
rooms upstairs with locks on the doors ¦ комнаты наверху с замками на дверях ¦ Zimmer oben mit Schlössern an den Türen ¦ des chambres à l'étage avec des verrous ¦ 楼上带门锁的房间
''',
  'est_patron': '''
a gunslinger who sits facing the door ¦ стрелок, сидящий лицом к двери ¦ ein Revolverheld, der mit Blick zur Tür sitzt ¦ un pistolero assis face à la porte ¦ 面朝门口坐着的枪手
a prospector celebrating a strike ¦ старатель, празднующий находку ¦ ein Goldsucher, der einen Fund feiert ¦ un prospecteur qui fête un filon ¦ 正在庆祝挖到金矿的淘金客
a railroad man buying everyone drinks ¦ железнодорожник, угощающий всех выпивкой ¦ ein Eisenbahner, der allen einen ausgibt ¦ un homme du rail qui paie une tournée générale ¦ 请全场喝酒的铁路商人
a schoolteacher new to the territory ¦ учительница, впервые оказавшаяся на территории ¦ eine Lehrerin, neu im Territorium ¦ une institutrice fraîchement arrivée dans le territoire ¦ 刚来领地的女教师
a bounty hunter checking faces against posters ¦ охотник за головами, сверяющий лица с плакатами ¦ ein Kopfgeldjäger, der Gesichter mit Steckbriefen vergleicht ¦ un chasseur de primes qui compare les visages aux affiches ¦ 拿着通缉令比对面孔的赏金猎人
an old cowhand with one last drive left in him ¦ старый ковбой, у которого остался последний перегон ¦ ein alter Cowboy mit einem letzten Viehtrieb in den Knochen ¦ un vieux cow-boy qui a encore une dernière transhumance en lui ¦ 还能再赶最后一趟牛的老牛仔
a gambler with a derringer up her sleeve ¦ картёжница с дерринджером в рукаве ¦ eine Spielerin mit einer Derringer im Ärmel ¦ une joueuse avec un derringer dans la manche ¦ 袖子里藏着小手枪的女赌徒
a medicine-show barker selling miracle tonic ¦ зазывала бродячего балагана, продающий чудо-эликсир ¦ ein Wunderdoktor-Ausrufer, der Heiltonikum verkauft ¦ un bonimenteur qui vend un tonique miracle ¦ 兜售神奇补药的江湖郎中
''',
  'hook_title': '''
The Noon Train ¦ Полуденный поезд ¦ Der Mittagszug ¦ Le Train de midi ¦ 正午列车
Dead or Alive ¦ Живым или мёртвым ¦ Tot oder lebendig ¦ Mort ou vif ¦ 死活不论
Gold in the Blood ¦ Золото в крови ¦ Gold im Blut ¦ De l'or dans le sang ¦ 血中之金
The Last Water for Fifty Miles ¦ Последняя вода на пятьдесят миль ¦ Das letzte Wasser für fünfzig Meilen ¦ La Dernière Eau à cinquante milles ¦ 五十英里内最后的水源
A Hanging at Dawn ¦ Казнь на рассвете ¦ Eine Hinrichtung im Morgengrauen ¦ Une pendaison à l'aube ¦ 黎明时分的绞刑
The Stagecoach That Never Arrived ¦ Дилижанс, который так и не прибыл ¦ Die Postkutsche, die nie ankam ¦ La Diligence qui n'est jamais arrivée ¦ 从未抵达的驿站马车
Iron Horse, Iron Will ¦ Железный конь, железная воля ¦ Eisernes Pferd, eiserner Wille ¦ Cheval de fer, volonté de fer ¦ 铁马铁心
Six Bullets, Seven Men ¦ Шесть пуль, семь человек ¦ Sechs Kugeln, sieben Männer ¦ Six balles, sept hommes ¦ 六颗子弹，七个人
The Widow's Claim ¦ Участок вдовы ¦ Der Claim der Witwe ¦ La Concession de la veuve ¦ 寡妇的矿权
Thunder over the Mesa ¦ Гром над месой ¦ Donner über der Mesa ¦ Tonnerre sur la mesa ¦ 平顶山上的雷声
''',
  'hook_who': '''
a widow defending her claim alone ¦ вдова, в одиночку защищающая свой участок ¦ eine Witwe, die ihren Claim allein verteidigt ¦ une veuve qui défend seule sa concession ¦ 独自守护矿权的寡妇
a young sheriff in over his head ¦ молодой шериф, взявшийся за непосильное ¦ ein junger Sheriff, dem alles über den Kopf wächst ¦ un jeune shérif complètement dépassé ¦ 力不从心的年轻警长
a railroad surveyor who found something ¦ железнодорожный топограф, который кое-что нашёл ¦ ein Eisenbahnvermesser, der etwas gefunden hat ¦ un géomètre du chemin de fer qui a trouvé quelque chose ¦ 发现了什么的铁路勘测员
a schoolteacher whose students are vanishing ¦ учительница, у которой пропадают ученики ¦ eine Lehrerin, deren Schüler verschwinden ¦ une institutrice dont les élèves disparaissent ¦ 学生接连失踪的女教师
a reformed outlaw whose past is catching up ¦ бывший бандит, которого догоняет прошлое ¦ ein geläuterter Gesetzloser, den die Vergangenheit einholt ¦ un ancien hors-la-loi rattrapé par son passé ¦ 被过去追上的改过自新的亡命徒
a rancher whose herd was poisoned ¦ скотовод, чьё стадо отравили ¦ ein Rancher, dessen Herde vergiftet wurde ¦ un éleveur dont le troupeau a été empoisonné ¦ 牛群被下毒的牧场主
a traveling preacher who knows a secret ¦ странствующий проповедник, знающий тайну ¦ ein Wanderprediger, der ein Geheimnis kennt ¦ un prédicateur itinérant qui connaît un secret ¦ 知道一个秘密的巡回传道人
a mine owner facing a strike ¦ владелец шахты, столкнувшийся с забастовкой ¦ ein Minenbesitzer, dem ein Streik droht ¦ un propriétaire de mine face à une grève ¦ 面临罢工的矿主
the telegraph operator who read the wrong message ¦ телеграфистка, прочитавшая не то сообщение ¦ die Telegrafistin, die die falsche Nachricht gelesen hat ¦ la télégraphiste qui a lu le mauvais message ¦ 读到不该读的电报的电报员
a saloon singer who witnessed a killing ¦ певица из салуна, ставшая свидетельницей убийства ¦ eine Saloonsängerin, die einen Mord gesehen hat ¦ une chanteuse de saloon témoin d'un meurtre ¦ 目睹了一起凶杀的酒馆女歌手
''',
  'hook_wants': '''
hold the town until the marshal arrives ¦ удержать город до прибытия маршала ¦ die Stadt halten, bis der Marshal eintrifft ¦ tenir la ville jusqu'à l'arrivée du marshal ¦ 守住小镇直到联邦执法官赶到
escort a prisoner to the territorial capital ¦ доставить заключённого в столицу территории ¦ einen Gefangenen in die Hauptstadt des Territoriums bringen ¦ escorter un prisonnier jusqu'à la capitale du territoire ¦ 押送一名囚犯到领地首府
drive a herd across dry country ¦ перегнать стадо через засушливые земли ¦ eine Herde durch trockenes Land treiben ¦ conduire un troupeau à travers une contrée aride ¦ 赶着牛群穿越干旱地带
recover a stolen payroll ¦ вернуть украденное жалованье ¦ eine gestohlene Lohnkasse zurückholen ¦ récupérer une paie volée ¦ 追回被抢的工资
find a missing stagecoach ¦ найти пропавший дилижанс ¦ eine verschwundene Postkutsche finden ¦ retrouver une diligence disparue ¦ 找到一辆失踪的驿站马车
stop the railroad from seizing the valley ¦ помешать железной дороге захватить долину ¦ verhindern, dass die Eisenbahn das Tal an sich reißt ¦ empêcher le chemin de fer de s'emparer de la vallée ¦ 阻止铁路公司强占山谷
bring in an outlaw alive ¦ доставить бандита живым ¦ einen Gesetzlosen lebend einbringen ¦ ramener un hors-la-loi vivant ¦ 把一名亡命徒活捉归案
prove a hanged man was innocent ¦ доказать, что повешенный был невиновен ¦ beweisen, dass ein Gehenkter unschuldig war ¦ prouver qu'un pendu était innocent ¦ 证明被绞死的人是无辜的
find water before the town dies of thirst ¦ найти воду, пока город не умер от жажды ¦ Wasser finden, bevor die Stadt verdurstet ¦ trouver de l'eau avant que la ville ne meure de soif ¦ 在小镇渴死之前找到水源
win back the deed in a poker game ¦ отыграть купчую в покер ¦ die Besitzurkunde beim Poker zurückgewinnen ¦ regagner l'acte de propriété au poker ¦ 在牌局上赢回地契
''',
  'hook_obstacle': '''
the gang outnumbers the town three to one ¦ банда превосходит город числом втрое ¦ die Bande ist der Stadt drei zu eins überlegen ¦ la bande est trois fois plus nombreuse que la ville ¦ 匪帮人数是全镇的三倍
a sandstorm is coming off the desert ¦ из пустыни надвигается песчаная буря ¦ ein Sandsturm zieht aus der Wüste heran ¦ une tempête de sable arrive du désert ¦ 沙漠里刮来一场沙暴
the sheriff is on the gang's payroll ¦ шериф на жалованье у банды ¦ der Sheriff steht auf der Lohnliste der Bande ¦ le shérif est à la solde de la bande ¦ 警长拿着匪帮的钱
the only bridge was dynamited ¦ единственный мост взорвали динамитом ¦ die einzige Brücke wurde gesprengt ¦ le seul pont a été dynamité ¦ 唯一的桥被炸毁了
the witness will only talk for a fortune ¦ свидетель заговорит только за целое состояние ¦ der Zeuge redet nur für ein Vermögen ¦ le témoin ne parlera que contre une fortune ¦ 证人要一大笔钱才肯开口
the horses are lame and water is short ¦ лошади хромают, а воды мало ¦ die Pferde lahmen, und das Wasser ist knapp ¦ les chevaux boitent et l'eau manque ¦ 马匹瘸了，水也不够
the townsfolk would rather pay than fight ¦ горожане скорее заплатят, чем будут драться ¦ die Städter zahlen lieber, als zu kämpfen ¦ les habitants préfèrent payer que se battre ¦ 镇民宁愿给钱也不愿打仗
a rival posse wants the same bounty ¦ конкурирующий отряд охотится за той же наградой ¦ eine rivalisierende Truppe will dieselbe Prämie ¦ une bande rivale convoite la même prime ¦ 另一支追捕队也想要同一笔赏金
the railroad owns the judge ¦ железная дорога купила судью ¦ die Eisenbahn hat den Richter gekauft ¦ le chemin de fer possède le juge ¦ 铁路公司收买了法官
the trail leads through a haunted canyon ¦ тропа ведёт через проклятый каньон ¦ der Weg führt durch einen verfluchten Canyon ¦ la piste traverse un canyon hanté ¦ 小路穿过一座闹鬼的峡谷
''',
  'hook_twist': '''
the outlaw is the patron's son ¦ бандит — сын заказчика ¦ der Gesetzlose ist der Sohn des Auftraggebers ¦ le hors-la-loi est le fils du commanditaire ¦ 亡命徒是委托人的儿子
the gold was fake all along ¦ золото с самого начала было фальшивым ¦ das Gold war von Anfang an falsch ¦ l'or était faux depuis le début ¦ 那些金子从一开始就是假的
the sheriff is the gang leader ¦ шериф и есть главарь банды ¦ der Sheriff ist der Bandenführer ¦ le shérif est le chef de la bande ¦ 警长就是匪帮头目
the prisoner is innocent and knows who is not ¦ заключённый невиновен и знает, кто виноват ¦ der Gefangene ist unschuldig und weiß, wer es nicht ist ¦ le prisonnier est innocent et sait qui ne l'est pas ¦ 囚犯是无辜的，而且知道谁才是真凶
the railroad is bankrupt and bluffing ¦ железная дорога обанкротилась и блефует ¦ die Eisenbahn ist bankrott und blufft ¦ le chemin de fer est en faillite et bluffe ¦ 铁路公司已经破产，只是在虚张声势
the missing stagecoach was hijacked by its own passengers ¦ пропавший дилижанс захватили его же пассажиры ¦ die verschwundene Postkutsche wurde von den eigenen Fahrgästen gekapert ¦ la diligence disparue a été détournée par ses propres passagers ¦ 失踪的驿站马车是被自己的乘客劫走的
the widow hired the gang herself ¦ вдова сама наняла банду ¦ die Witwe hat die Bande selbst angeheuert ¦ la veuve a engagé la bande elle-même ¦ 匪帮是寡妇自己雇来的
the dead man in the grave is not the outlaw ¦ в могиле лежит вовсе не бандит ¦ der Tote im Grab ist nicht der Gesetzlose ¦ le mort dans la tombe n'est pas le hors-la-loi ¦ 墓里躺着的并不是那个亡命徒
the water lies on land the town once swindled away ¦ вода находится на земле, которую город когда-то отнял обманом ¦ das Wasser liegt auf dem Land, das die Stadt einst ergaunert hat ¦ l'eau se trouve sur les terres que la ville a jadis spoliées ¦ 水源就在小镇当年骗来的土地上
the outlaw posted the bounty himself ¦ награду назначил сам бандит ¦ die Prämie hat der Gesetzlose selbst ausgesetzt ¦ la prime a été mise par le hors-la-loi lui-même ¦ 悬赏是亡命徒自己发布的
''',
  'loot_container': '''
Outlaw's saddlebags ¦ Седельные сумки бандита ¦ Satteltaschen eines Gesetzlosen ¦ Sacoches d'un hors-la-loi ¦ 亡命徒的鞍袋
Stagecoach strongbox ¦ Сейф дилижанса ¦ Geldkassette einer Postkutsche ¦ Coffre de diligence ¦ 驿站马车的保险箱
Prospector's buried tin ¦ Зарытая жестянка старателя ¦ Vergrabene Blechdose eines Goldsuchers ¦ Boîte en fer enterrée d'un prospecteur ¦ 淘金客埋下的铁盒
Saloon safe behind the bar ¦ Сейф за стойкой салуна ¦ Tresor hinter dem Tresen eines Saloons ¦ Coffre derrière le comptoir du saloon ¦ 酒馆吧台后面的保险柜
Dead gambler's valise ¦ Саквояж мёртвого игрока ¦ Reisetasche eines toten Spielers ¦ Valise d'un joueur mort ¦ 死去赌徒的手提箱
Railroad payroll crate ¦ Ящик с жалованьем железной дороги ¦ Lohnkiste der Eisenbahn ¦ Caisse de paie du chemin de fer ¦ 铁路公司的工资箱
Bank vault drawer ¦ Ячейка банковского хранилища ¦ Schublade eines Banktresors ¦ Tiroir d'une chambre forte ¦ 银行金库的抽屉
Chest from a medicine-show wagon ¦ Сундук из фургона бродячего балагана ¦ Truhe aus einem Wunderdoktorwagen ¦ Malle d'un chariot de charlatan ¦ 江湖郎中马车里的箱子
''',
  'loot_coin': '''
{#3d6*10} dollars in gold coin ¦ золотые монеты на {#3d6*10} долларов ¦ {#3d6*10} Dollar in Goldmünzen ¦ {#3d6*10} dollars en pièces d'or ¦ {#3d6*10}美元的金币
a poke of gold dust worth about {#2d6*15} ¦ мешочек золотого песка примерно на {#2d6*15} ¦ ein Beutel Goldstaub im Wert von etwa {#2d6*15} ¦ une bourse de poudre d'or valant environ {#2d6*15} ¦ 一袋价值约{#2d6*15}的金沙
{#4d6*5} silver dollars ¦ серебряные доллары: {#4d6*5} ¦ {#4d6*5} Silberdollar ¦ {#4d6*5} dollars d'argent ¦ {#4d6*5}枚银元
an unsigned bank draft for {#2d6*50} dollars ¦ неподписанный банковский чек на {#2d6*50} долларов ¦ ein unsignierter Bankwechsel über {#2d6*50} Dollar ¦ une traite bancaire de {#2d6*50} dollars, non signée ¦ 一张未签字的{#2d6*50}美元银行汇票
''',
  'loot_item': '''
revolver cartridges ×{#2d6} ¦ револьверные патроны ×{#2d6} ¦ Revolverpatronen ×{#2d6} ¦ cartouches de revolver ×{#2d6} ¦ 左轮子弹 ×{#2d6}
a pearl-handled revolver ¦ револьвер с перламутровой рукоятью ¦ ein Revolver mit Perlmuttgriff ¦ un revolver à crosse de nacre ¦ 珍珠母握把的左轮手枪
sticks of dynamite ×{#1d4+1} ¦ динамитные шашки ×{#1d4+1} ¦ Dynamitstangen ×{#1d4+1} ¦ bâtons de dynamite ×{#1d4+1} ¦ 炸药棒 ×{#1d4+1}
a deed to a worthless claim, or so they say ¦ купчая на бесполезный участок — так говорят ¦ eine Urkunde für einen wertlosen Claim, heißt es ¦ l'acte d'une concession sans valeur, à ce qu'on dit ¦ 一张据说一文不值的矿权契据
bottles of miracle tonic ×{#1d4+1} ¦ бутылки чудо-эликсира ×{#1d4+1} ¦ Flaschen Wundertonikum ×{#1d4+1} ¦ bouteilles de tonique miracle ×{#1d4+1} ¦ 神奇补药 ×{#1d4+1}
a silver-inlaid saddle ¦ седло с серебряной инкрустацией ¦ ein silberbeschlagener Sattel ¦ une selle incrustée d'argent ¦ 镶银的马鞍
a spyglass with a cracked lens ¦ подзорная труба с треснувшей линзой ¦ ein Fernrohr mit gesprungener Linse ¦ une longue-vue à la lentille fêlée ¦ 镜片开裂的望远镜
tins of beans ×{#2d4} ¦ банки фасоли ×{#2d4} ¦ Dosen Bohnen ×{#2d4} ¦ boîtes de haricots ×{#2d4} ¦ 豆子罐头 ×{#2d4}
a marshal's badge dented by a bullet ¦ значок маршала с вмятиной от пули ¦ ein Marshalstern mit einer Delle von einer Kugel ¦ une étoile de marshal cabossée par une balle ¦ 被子弹打出凹痕的执法官徽章
a deck of marked cards ¦ колода краплёных карт ¦ ein Stapel gezinkter Karten ¦ un jeu de cartes marquées ¦ 一副做了记号的扑克牌
a rolled map to a dry spring ¦ свёрнутая карта к пересохшему источнику ¦ eine zusammengerollte Karte zu einer versiegten Quelle ¦ une carte roulée menant à une source tarie ¦ 通往一眼干泉的卷起地图
bottles of rye whiskey ×{#1d4+1} ¦ бутылки ржаного виски ×{#1d4+1} ¦ Flaschen Roggenwhiskey ×{#1d4+1} ¦ bouteilles de whisky de seigle ×{#1d4+1} ¦ 黑麦威士忌 ×{#1d4+1}
a freshly oiled lever-action rifle ¦ свежесмазанная рычажная винтовка ¦ ein frisch geöltes Unterhebelgewehr ¦ une carabine à levier fraîchement huilée ¦ 刚上过油的杠杆式步枪
a gold pocket watch engraved “To my son” ¦ золотые карманные часы с гравировкой «Моему сыну» ¦ eine goldene Taschenuhr mit der Gravur „Für meinen Sohn“ ¦ une montre de poche en or gravée « À mon fils » ¦ 刻着“给我的儿子”的金怀表
jars of horse liniment ×{#1d3+1} ¦ банки мази для лошадей ×{#1d3+1} ¦ Tiegel Pferdeliniment ×{#1d3+1} ¦ pots d'onguent pour chevaux ×{#1d3+1} ¦ 马用擦剂 ×{#1d3+1}
a lasso of braided rawhide ¦ лассо из плетёной сыромятной кожи ¦ ein Lasso aus geflochtenem Rohleder ¦ un lasso de cuir brut tressé ¦ 编织生牛皮套索
''',
  'loot_curio': '''
a wanted poster showing a party member's face ¦ плакат «Разыскивается» с лицом одного из героев ¦ ein Steckbrief mit dem Gesicht eines Gruppenmitglieds ¦ un avis de recherche portant le visage d'un des héros ¦ 一张印着队伍中某人面孔的通缉令
a music box that plays a lullaby ¦ музыкальная шкатулка с колыбельной ¦ eine Spieldose, die ein Wiegenlied spielt ¦ une boîte à musique qui joue une berceuse ¦ 放着摇篮曲的八音盒
a love letter never sent ¦ так и не отправленное любовное письмо ¦ ein nie abgeschickter Liebesbrief ¦ une lettre d'amour jamais envoyée ¦ 一封从未寄出的情书
a silver bullet engraved with a name ¦ серебряная пуля с выгравированным именем ¦ eine Silberkugel mit eingraviertem Namen ¦ une balle d'argent gravée d'un nom ¦ 刻着名字的银子弹
a tintype photograph of a family ¦ старая ферротипия семьи ¦ eine Ferrotypie einer Familie ¦ un ferrotype d'une famille ¦ 一张全家福锡版照片
a gold nugget shaped like a heart ¦ золотой самородок в форме сердца ¦ ein herzförmiger Goldklumpen ¦ une pépite d'or en forme de cœur ¦ 心形的金块
a train ticket to a town that burned down ¦ билет на поезд до сгоревшего города ¦ eine Fahrkarte in eine abgebrannte Stadt ¦ un billet de train pour une ville réduite en cendres ¦ 一张开往已烧毁小镇的火车票
a harmonica with initials scratched into it ¦ губная гармошка с нацарапанными инициалами ¦ eine Mundharmonika mit eingeritzten Initialen ¦ un harmonica aux initiales gravées ¦ 刻着姓名缩写的口琴
''',
  'faction_noun': '''
@Tribe Gang ¦ Банда ¦ Bande ¦ Bande ¦ 帮
@Company Company ¦ Компания ¦ Gesellschaft ¦ Compagnie ¦ 公司
@Family Family ¦ Семья ¦ Familie ¦ Famille ¦ 家族
@Order Rangers ¦ Рейнджеры ¦ Ranger ¦ Rangers ¦ 游骑兵
@Guild Cattlemen's Association ¦ Ассоциация скотоводов ¦ Viehzüchterverband ¦ Association des éleveurs ¦ 牧牛人协会
@Cult Congregation ¦ Община ¦ Gemeinde ¦ Congrégation ¦ 教团
@Other Posse ¦ Отряд ¦ Aufgebot ¦ Milice ¦ 追捕队
@Company Railroad ¦ Железная дорога ¦ Eisenbahn ¦ Chemin de fer ¦ 铁路
''',
  'faction_of': '''
of the Red Mesa ¦ Красной Месы ¦ der Roten Mesa ¦ de la Mesa rouge ¦ 红台地
of Dry Gulch ¦ Сухого Оврага ¦ vom Trockenen Graben ¦ du Ravin-Sec ¦ 旱沟
of the Silver Line ¦ Серебряной Линии ¦ der Silberlinie ¦ de la Ligne d'argent ¦ 银线
of the Seven Rivers ¦ Семи Рек ¦ der Sieben Flüsse ¦ des Sept Rivières ¦ 七河
of the Broken Spur ¦ Сломанной Шпоры ¦ des Gebrochenen Sporns ¦ de l'Éperon brisé ¦ 断马刺
of the Iron Trail ¦ Железного Пути ¦ des Eisernen Pfades ¦ de la Piste de fer ¦ 铁道
of the Painted Canyon ¦ Расписного Каньона ¦ des Bemalten Canyons ¦ du Canyon peint ¦ 彩绘峡谷
of the Last Chance ¦ Последнего Шанса ¦ der Letzten Chance ¦ de la Dernière Chance ¦ 最后机会
of the Golden Spike ¦ Золотого Костыля ¦ des Goldenen Nagels ¦ du Crampon d'or ¦ 金道钉
of the High Plains ¦ Высоких Равнин ¦ der Hohen Ebenen ¦ des Hautes Plaines ¦ 高原
''',
  'faction_goal': '''
own every water hole in the territory ¦ владеть всеми водопоями территории ¦ jedes Wasserloch im Territorium besitzen ¦ posséder chaque point d'eau du territoire ¦ 占有领地内的每一处水源
drive the railroad out of the valley ¦ выгнать железную дорогу из долины ¦ die Eisenbahn aus dem Tal vertreiben ¦ chasser le chemin de fer de la vallée ¦ 把铁路赶出山谷
make the territory a state, with themselves in charge ¦ сделать территорию штатом — под своим началом ¦ das Territorium zum Staat machen, mit sich an der Spitze ¦ faire du territoire un État, avec eux aux commandes ¦ 让领地建州，由他们掌权
rob every bank between here and the coast ¦ ограбить все банки отсюда до побережья ¦ jede Bank zwischen hier und der Küste ausrauben ¦ braquer toutes les banques d'ici à la côte ¦ 抢遍从这里到海岸的每一家银行
bring law and order by any means ¦ установить закон и порядок любыми средствами ¦ Recht und Ordnung bringen, mit allen Mitteln ¦ imposer la loi et l'ordre, par tous les moyens ¦ 不择手段地带来法律与秩序
control the gold fields ¦ контролировать золотые прииски ¦ die Goldfelder kontrollieren ¦ contrôler les champs aurifères ¦ 控制金矿区
build a town where anyone can start over ¦ построить город, где каждый может начать сначала ¦ eine Stadt bauen, in der jeder neu anfangen kann ¦ bâtir une ville où chacun peut recommencer ¦ 建一座人人都能重新开始的小镇
avenge a massacre no one talks about ¦ отомстить за резню, о которой никто не говорит ¦ ein Massaker rächen, über das niemand spricht ¦ venger un massacre dont personne ne parle ¦ 为一场无人提及的屠杀复仇
''',
  'faction_method': '''
hired guns and forged deeds ¦ наёмные стрелки и поддельные купчие ¦ angeheuerte Revolverhelden und gefälschte Urkunden ¦ tueurs à gages et actes falsifiés ¦ 雇佣枪手和伪造的地契
bribes to judges and senators ¦ взятки судьям и сенаторам ¦ Bestechungsgelder für Richter und Senatoren ¦ des pots-de-vin aux juges et aux sénateurs ¦ 贿赂法官和参议员
train robberies timed to the minute ¦ ограбления поездов, рассчитанные до минуты ¦ auf die Minute geplante Zugüberfälle ¦ des attaques de train réglées à la minute près ¦ 精确到分钟的火车劫案
fencing off the open range ¦ огораживание вольных пастбищ ¦ das Einzäunen des offenen Weidelands ¦ clôturer les pâturages ouverts ¦ 圈占开放的牧场
revival meetings that end in pledges ¦ молитвенные собрания, заканчивающиеся клятвами ¦ Erweckungsversammlungen, die mit Gelübden enden ¦ des réunions de réveil qui finissent en serments ¦ 以宣誓收场的奋兴布道会
wanted posters for anyone who resists ¦ плакаты «Разыскивается» для каждого, кто сопротивляется ¦ Steckbriefe für jeden, der sich widersetzt ¦ des avis de recherche pour quiconque résiste ¦ 给每个反抗者都贴上通缉令
buying up the town's debts ¦ скупка долгов города ¦ der Aufkauf der Schulden der Stadt ¦ le rachat des dettes de la ville ¦ 收购全镇的债务
posses that ride at midnight ¦ отряды, выезжающие в полночь ¦ Aufgebote, die um Mitternacht ausreiten ¦ des milices qui chevauchent à minuit ¦ 午夜出动的追捕队
''',
  'faction_symbol': '''
a horseshoe pointing down ¦ подкова концами вниз ¦ ein nach unten zeigendes Hufeisen ¦ un fer à cheval pointé vers le bas ¦ 开口朝下的马蹄铁
a star with a bullet hole ¦ звезда с пулевым отверстием ¦ ein Stern mit Einschussloch ¦ une étoile trouée d'une balle ¦ 带弹孔的星星
crossed rifles over a canyon ¦ скрещённые винтовки над каньоном ¦ gekreuzte Gewehre über einem Canyon ¦ des fusils croisés au-dessus d'un canyon ¦ 峡谷上方交叉的步枪
a steer skull with painted horns ¦ бычий череп с раскрашенными рогами ¦ ein Stierschädel mit bemalten Hörnern ¦ un crâne de bœuf aux cornes peintes ¦ 牛角被涂色的牛头骨
a locomotive inside a ring of gold ¦ паровоз в золотом кольце ¦ eine Lokomotive in einem goldenen Ring ¦ une locomotive dans un anneau d'or ¦ 金色圆环中的火车头
a noose tied in a figure eight ¦ петля, завязанная восьмёркой ¦ eine Schlinge in Form einer Acht ¦ un nœud coulant en huit ¦ 打成八字的绞索
a rattlesnake coiled around a cross ¦ гремучая змея, обвившая крест ¦ eine Klapperschlange um ein Kreuz gewunden ¦ un serpent à sonnette enroulé autour d'une croix ¦ 缠绕十字架的响尾蛇
an ace of spades pinned with a knife ¦ туз пик, приколотый ножом ¦ ein mit einem Messer festgestecktes Pik-Ass ¦ un as de pique cloué d'un couteau ¦ 被刀钉住的黑桃A
''',
  'weather_sky': '''
a merciless sun in a cloudless sky ¦ беспощадное солнце в безоблачном небе ¦ eine gnadenlose Sonne am wolkenlosen Himmel ¦ un soleil impitoyable dans un ciel sans nuages ¦ 万里无云，烈日无情
thunderheads build over the mesa ¦ над месой громоздятся грозовые тучи ¦ über der Mesa türmen sich Gewitterwolken ¦ des nuages d'orage s'amoncellent sur la mesa ¦ 平顶山上空雷雨云堆积
a red dust storm blots out the sun ¦ красная пыльная буря закрывает солнце ¦ ein roter Staubsturm verdunkelt die Sonne ¦ une tempête de poussière rouge masque le soleil ¦ 红色沙暴遮住了太阳
a sky full of stars and coyote song ¦ небо, полное звёзд и воя койотов ¦ ein Himmel voller Sterne und Kojotengesang ¦ un ciel plein d'étoiles et de chants de coyotes ¦ 满天繁星，伴着郊狼的歌声
a flash flood roars down the dry wash ¦ внезапный паводок ревёт по сухому руслу ¦ eine Sturzflut donnert durch das trockene Flussbett ¦ une crue subite rugit dans le lit asséché ¦ 山洪咆哮着冲下干河床
a pale dawn with frost on the sagebrush ¦ бледный рассвет с инеем на полыни ¦ eine blasse Dämmerung mit Reif auf dem Beifuß ¦ une aube pâle avec du givre sur l'armoise ¦ 苍白的黎明，山艾上结着霜
heat shimmer makes the horizon dance ¦ жаркое марево заставляет горизонт плясать ¦ Hitzeflimmern lässt den Horizont tanzen ¦ la brume de chaleur fait danser l'horizon ¦ 热浪让地平线舞动起来
a blood-red sunset over the canyon ¦ кроваво-красный закат над каньоном ¦ ein blutroter Sonnenuntergang über dem Canyon ¦ un couchant rouge sang sur le canyon ¦ 峡谷上空血红的落日
''',
  'weather_air': '''
a hot wind carries grit and the smell of cattle ¦ горячий ветер несёт песок и запах скота ¦ heißer Wind trägt Sand und den Geruch von Vieh ¦ un vent chaud charrie du sable et l'odeur du bétail ¦ 热风裹着沙砾和牛群的气味
the air is so dry lips crack by noon ¦ воздух так сух, что к полудню трескаются губы ¦ die Luft ist so trocken, dass die Lippen bis Mittag reißen ¦ l'air est si sec que les lèvres se fendent avant midi ¦ 空气干得中午前嘴唇就会裂开
a cold night wind rattles the shutters ¦ холодный ночной ветер гремит ставнями ¦ ein kalter Nachtwind rüttelt an den Läden ¦ un vent froid de nuit fait claquer les volets ¦ 夜里的冷风把百叶窗摇得哐哐响
the smell of rain arrives long before the rain ¦ запах дождя приходит задолго до дождя ¦ der Geruch von Regen kommt lange vor dem Regen ¦ l'odeur de la pluie arrive bien avant la pluie ¦ 雨还没来，雨的气味先到了
not a breath of wind, and the flies are thick ¦ ни дуновения ветра, и мухи вьются тучей ¦ kein Windhauch, und überall Fliegen ¦ pas un souffle de vent, et les mouches pullulent ¦ 一丝风都没有，苍蝇成群
tumbleweeds race down the main street ¦ перекати-поле мчится по главной улице ¦ Steppenroller jagen die Hauptstraße entlang ¦ des virevoltants filent dans la rue principale ¦ 风滚草在大街上飞奔
the desert night's chill bites through blankets ¦ холод пустынной ночи пробирает сквозь одеяла ¦ die Kälte der Wüstennacht beißt durch die Decken ¦ le froid de la nuit du désert mord à travers les couvertures ¦ 沙漠夜晚的寒气能透过毯子
woodsmoke and coffee drift over from the camp ¦ из лагеря тянет дымом костра и кофе ¦ Holzrauch und Kaffeeduft ziehen vom Lager herüber ¦ la fumée de bois et le café flottent depuis le camp ¦ 营地飘来柴烟和咖啡的香味
''',
  'weather_omen': '''
vultures circle over the edge of town ¦ стервятники кружат над окраиной города ¦ Geier kreisen über dem Stadtrand ¦ des vautours tournoient au bord de la ville ¦ 秃鹫在镇子边缘盘旋
the church bell rings once at midnight ¦ церковный колокол бьёт один раз в полночь ¦ die Kirchenglocke schlägt um Mitternacht einmal ¦ la cloche de l'église sonne une fois à minuit ¦ 教堂的钟在午夜敲了一下
the horses won't drink from the trough ¦ лошади не пьют из корыта ¦ die Pferde saufen nicht aus dem Trog ¦ les chevaux refusent de boire à l'abreuvoir ¦ 马匹不肯喝槽里的水
a riderless white stallion appears on the ridge ¦ на гребне появляется белый жеребец без всадника ¦ auf dem Grat erscheint ein weißer Hengst ohne Reiter ¦ un étalon blanc sans cavalier apparaît sur la crête ¦ 山脊上出现一匹无人骑乘的白马
the telegraph taps out a message no one sent ¦ телеграф отстукивает сообщение, которое никто не отправлял ¦ der Telegraf tickert eine Nachricht, die niemand geschickt hat ¦ le télégraphe tape un message que personne n'a envoyé ¦ 电报机敲出一条没人发过的消息
every dog in town howls at once ¦ все собаки в городе разом воют ¦ jeder Hund der Stadt heult gleichzeitig ¦ tous les chiens de la ville hurlent en même temps ¦ 镇上所有的狗同时嚎叫
a dust devil spins in front of the jail ¦ перед тюрьмой кружится пыльный вихрь ¦ ein Staubteufel wirbelt vor dem Gefängnis ¦ un tourbillon de poussière tourne devant la prison ¦ 一股尘卷风在监狱门前打转
the river runs backward for an hour ¦ река на час течёт вспять ¦ der Fluss fließt eine Stunde lang rückwärts ¦ la rivière coule à l'envers pendant une heure ¦ 河水倒流了一个钟头
''',
  'rumor_source': '''
a drunk cowhand at the bar ¦ пьяный ковбой у стойки ¦ ein betrunkener Cowboy an der Bar ¦ un cow-boy ivre au comptoir ¦ 吧台边喝醉的牛仔
the stagecoach driver ¦ кучер дилижанса ¦ der Postkutscher ¦ le conducteur de la diligence ¦ 驿站马车夫
a card player folding a bad hand ¦ игрок, сбрасывающий плохие карты ¦ ein Kartenspieler, der ein schlechtes Blatt hinwirft ¦ un joueur qui se couche sur une mauvaise main ¦ 扔掉一手烂牌的赌客
the barber, mid-shave ¦ цирюльник прямо во время бритья ¦ der Barbier, mitten beim Rasieren ¦ le barbier, en plein rasage ¦ 正在刮胡子的理发师
a telegram left on the counter ¦ телеграмма, забытая на прилавке ¦ ein auf dem Tresen liegen gelassenes Telegramm ¦ un télégramme laissé sur le comptoir ¦ 落在柜台上的电报
a traveling salesman of patent medicines ¦ торговец патентованными лекарствами ¦ ein Vertreter für Patentmedizin ¦ un représentant en remèdes brevetés ¦ 推销专利药的旅行商人
the undertaker, measuring a new customer ¦ гробовщик, снимающий мерку с нового клиента ¦ der Bestatter, der einen neuen Kunden vermisst ¦ le croque-mort, qui mesure un nouveau client ¦ 正在给新客人量尺寸的殡葬人
a wanted poster with the ink still fresh ¦ плакат «Разыскивается» со свежей краской ¦ ein Steckbrief mit noch frischer Tinte ¦ un avis de recherche à l'encre encore fraîche ¦ 墨迹未干的通缉令
''',
  'rumor_text': '''
the bank's gold was replaced with painted lead ¦ золото в банке подменили крашеным свинцом ¦ das Gold der Bank wurde durch bemaltes Blei ersetzt ¦ l'or de la banque a été remplacé par du plomb peint ¦ 银行的金子被换成了涂色的铅块
the famous outlaw is alive and running a farm ¦ знаменитый бандит жив и держит ферму ¦ der berühmte Gesetzlose lebt und betreibt eine Farm ¦ le célèbre hors-la-loi est vivant et tient une ferme ¦ 那个出名的亡命徒还活着，正在经营农场
the railroad will pass through town after all ¦ железная дорога всё-таки пройдёт через город ¦ die Eisenbahn wird doch durch die Stadt führen ¦ le chemin de fer passera finalement par la ville ¦ 铁路最终还是会经过小镇
there is a silver vein under the church ¦ под церковью проходит серебряная жила ¦ unter der Kirche verläuft eine Silberader ¦ il y a un filon d'argent sous l'église ¦ 教堂底下有一条银矿脉
the new schoolteacher is a federal agent ¦ новая учительница — федеральный агент ¦ die neue Lehrerin ist eine Bundesagentin ¦ la nouvelle institutrice est un agent fédéral ¦ 新来的女教师是联邦探员
the mine is haunted by the men who died in the collapse ¦ в шахте обитают призраки погибших при обвале ¦ in der Mine spuken die Männer, die beim Einsturz starben ¦ la mine est hantée par les hommes morts dans l'effondrement ¦ 矿井里闹着塌方中死去的矿工的鬼
the sheriff's badge was taken from a dead man ¦ значок шерифа сняли с мертвеца ¦ der Sheriffstern wurde einem Toten abgenommen ¦ l'étoile du shérif a été prise sur un mort ¦ 警长的徽章是从一个死人身上摘下来的
a gang is hiding in the old mission ¦ банда прячется в старой миссии ¦ eine Bande versteckt sich in der alten Mission ¦ une bande se cache dans la vieille mission ¦ 一伙匪徒藏在旧传教站里
the water will run out by August ¦ к августу вода закончится ¦ bis August wird das Wasser ausgehen ¦ l'eau sera épuisée d'ici août ¦ 到八月水就要用光了
the widow's late husband is not dead ¦ покойный муж вдовы вовсе не умер ¦ der verstorbene Mann der Witwe ist gar nicht tot ¦ le défunt mari de la veuve n'est pas mort ¦ 寡妇的亡夫其实没死
''',
};

const _latinPre = '''
Red
Cold
Dry
Dead Man's
Bitter
Lone
Silver
Copper
Rattle
Dusty
''';

const _latinSuf = '''
Water
Rock
Gulch
Creek
Springs
Bluff
Flats
Ridge
''';

const _perLang = <String, Map<String, String>>{
  'en': {
    'settle_name': '{settle_pre} {settle_suf}',
    'settle_pre': _latinPre,
    'settle_suf': _latinSuf,
  },
  'de': {
    'settle_name': '{settle_pre} {settle_suf}',
    'settle_pre': _latinPre,
    'settle_suf': _latinSuf,
  },
  'fr': {
    'settle_name': '{settle_pre} {settle_suf}',
    'settle_pre': _latinPre,
    'settle_suf': _latinSuf,
  },
  'ru': {
    'settle_name': '{settle_pre}-{settle_suf}',
    'settle_pre': '''
Ред
Колд
Драй
Дэдменс
Биттер
Лоун
Силвер
Коппер
Раттл
Дасти
''',
    'settle_suf': '''
Уотер
Рок
Галч
Крик
Спрингс
Блафф
Флэтс
Ридж
''',
  },
  'zh': {
    'settle_name': '{settle_pre}{settle_suf}',
    'settle_pre': '''
红
冷
旱
死人
苦
孤
银
铜
响尾
尘
''',
    'settle_suf': '''
水镇
石镇
沟
溪
泉
崖
滩
岭
''',
  },
};
