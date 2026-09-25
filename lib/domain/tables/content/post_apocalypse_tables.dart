import '../../models/world.dart';
import 'table_library.dart';

const _s = WorldStyle.postApocalypse;

const postApocalypseTables = <LibraryTable>[
  LibraryTable(
    localId: 'wasteland_encounters',
    style: _s,
    folder: LibraryFolder.encounters,
    formula: '2d6',
    name: Tx(
      'Wasteland Encounters',
      'Встречи в пустошах',
      'Begegnungen im Ödland',
      'Rencontres des terres désolées',
      '废土遭遇',
    ),
    description: Tx(
      'Who else is out on the cracked highways and in the dead towns.',
      'Кто ещё бродит по растрескавшимся шоссе и мёртвым городам.',
      'Wer sonst noch auf den rissigen Highways und in den toten Städten unterwegs ist.',
      'Qui d\'autre traîne sur les autoroutes fissurées et dans les villes mortes.',
      '还有谁在龟裂的公路和死寂的城镇里游荡。',
    ),
    rows: [
      LibraryRow(
        Tx(
          'A war rig with {1d6+3} raiders, painted in the colors of a tribe you thought was gone.',
          'Боевая фура с {1d6+3} налётчиками в цветах племени, которое вы считали вымершим.',
          'Ein Kampftruck mit {1d6+3} Plünderern in den Farben eines Stammes, den ihr für ausgelöscht hieltet.',
          'Un camion de guerre avec {1d6+3} pillards aux couleurs d\'une tribu qu\'on croyait disparue.',
          '一辆载着{1d6+3}名掠夺者的战车，涂着一个你以为早已消失的部落的颜色。',
        ),
      ),
      LibraryRow(
        Tx(
          'A mutant pack of {2d4} dogs, hairless and patient.',
          'Стая из {2d4} собак-мутантов — безволосых и терпеливых.',
          'Ein Rudel aus {2d4} mutierten Hunden, haarlos und geduldig.',
          'Une meute de {2d4} chiens mutants, glabres et patients.',
          '一群{2d4}只无毛的变异犬，耐心地等待着。',
        ),
      ),
      LibraryRow(
        Tx(
          'A lone trader with a two-headed mule. [[@quirks]]',
          'Одинокий торговец с двухголовым мулом. [[@quirks]]',
          'Ein einsamer Händler mit einem zweiköpfigen Maultier. [[@quirks]]',
          'Un marchand solitaire avec une mule à deux têtes. [[@quirks]]',
          '一个牵着双头骡子的独行商人。[[@quirks]]',
        ),
      ),
      LibraryRow(
        Tx(
          'An overturned truck, still sealed. Inside: [[@salvage]]',
          'Перевёрнутый грузовик, всё ещё запечатанный. Внутри: [[@salvage]]',
          'Ein umgekippter Lastwagen, noch versiegelt. Darin: [[@salvage]]',
          'Un camion renversé, encore scellé. Dedans : [[@salvage]]',
          '一辆翻倒的卡车，仍然密封着。里面有：[[@salvage]]',
        ),
      ),
      LibraryRow(
        Tx(
          'The road ahead turns dangerous: [[@hazards]]',
          'Дорога впереди становится опасной: [[@hazards]]',
          'Die Straße voraus wird gefährlich: [[@hazards]]',
          'La route devient dangereuse : [[@hazards]]',
          '前方的路变得凶险：[[@hazards]]',
        ),
      ),
      LibraryRow(
        Tx(
          'Refugees from a fallen settlement, {2d6} of them, begging for water.',
          'Беженцы из павшего поселения, {2d6} человек, просят воды.',
          'Flüchtlinge aus einer gefallenen Siedlung, {2d6} an der Zahl, betteln um Wasser.',
          'Des réfugiés d\'une colonie tombée, {2d6} en tout, mendient de l\'eau.',
          '来自一个沦陷聚居地的{2d6}名难民，乞求一点水。',
        ),
      ),
      LibraryRow(
        Tx(
          'A pre-war robot still delivering mail, and it has a letter for you.',
          'Довоенный робот всё ещё разносит почту — и у него письмо для вас.',
          'Ein Vorkriegsroboter stellt noch immer Post zu, und er hat einen Brief für euch.',
          'Un robot d\'avant-guerre distribue encore le courrier, et il a une lettre pour vous.',
          '一台战前机器人仍在送信——而且它有一封你的信。',
        ),
      ),
      LibraryRow(
        Tx(
          'A preacher on a burned-out bus promises a {clean city|green valley|working vault} to the east.',
          'Проповедник на сгоревшем автобусе обещает на востоке {чистый город|зелёную долину|работающее убежище}.',
          'Ein Prediger auf einem ausgebrannten Bus verspricht im Osten {eine saubere Stadt|ein grünes Tal|einen funktionierenden Bunker}.',
          'Un prêcheur sur un bus calciné promet, à l\'est, {une ville propre|une vallée verte|un abri qui fonctionne}.',
          '一个站在烧毁巴士上的传道人，许诺东边有{一座干净的城市|一片绿色山谷|一座运转的避难所}。',
        ),
      ),
      LibraryRow(
        Tx(
          'Scavengers fighting over a vending machine. One of them: [[@quirks]]',
          'Мародёры дерутся из-за торгового автомата. Один из них: [[@quirks]]',
          'Plünderer streiten um einen Verkaufsautomaten. Einer davon: [[@quirks]]',
          'Des charognards se battent pour un distributeur. L\'un d\'eux : [[@quirks]]',
          '拾荒者为一台自动售货机大打出手。其中一人：[[@quirks]]',
        ),
      ),
      LibraryRow(
        Tx(
          'A caravan of water haulers with armed outriders, suspicious but willing to trade.',
          'Караван водовозов с вооружённой охраной — подозрительные, но готовы торговать.',
          'Eine Karawane von Wasserhändlern mit bewaffneter Eskorte, misstrauisch, aber handelsbereit.',
          'Une caravane de porteurs d\'eau avec des éclaireurs armés, méfiants mais prêts à commercer.',
          '一支有武装骑手护送的运水商队，满腹戒心，但愿意交易。',
        ),
      ),
      LibraryRow(
        Tx(
          'Something huge moves under the sand, circling the camp.',
          'Что-то огромное движется под песком, кружа вокруг лагеря.',
          'Etwas Riesiges bewegt sich unter dem Sand und umkreist das Lager.',
          'Quelque chose d\'énorme se déplace sous le sable et tourne autour du camp.',
          '有个庞然大物在沙下移动，绕着营地打转。',
        ),
      ),
    ],
  ),
  LibraryTable(
    localId: 'salvage',
    style: _s,
    folder: LibraryFolder.loot,
    formula: '1d100',
    name: Tx('Salvage', 'Хабар', 'Bergegut', 'Récup', '废品'),
    description: Tx(
      'What a careful scavenger pulls from a ruin. Percentile: junk is common, treasure is not.',
      'Что осторожный мародёр вытаскивает из руин. Процентная таблица: хлама много, сокровищ мало.',
      'Was ein vorsichtiger Plünderer aus Ruinen holt. Prozentwurf: Schrott ist häufig, Schätze nicht.',
      'Ce qu\'un récupérateur prudent tire d\'une ruine. Au d100 : la camelote abonde, le trésor non.',
      '谨慎的拾荒者从废墟里翻出的东西。百分骰：破烂常见，宝贝难寻。',
    ),
    rows: [
      LibraryRow(
        Tx(
          'Scrap metal, {2d6} pounds of it. Good for trade, bad for your back.',
          'Металлолом, {2d6} фунтов. Годится для обмена, плох для спины.',
          '{2d6} Pfund Altmetall. Gut zum Tauschen, schlecht für den Rücken.',
          '{2d6} livres de ferraille. Bon pour le troc, mauvais pour le dos.',
          '{2d6}磅废金属。拿来交易不错，就是压得背疼。',
        ),
        weight: 20,
      ),
      LibraryRow(
        Tx(
          'A can of food with no label. It could be peaches. It could be anything.',
          'Консервная банка без этикетки. Может, персики. А может, что угодно.',
          'Eine Dose ohne Etikett. Könnten Pfirsiche sein. Könnte alles sein.',
          'Une conserve sans étiquette. Des pêches, peut-être. Ou n\'importe quoi.',
          '一罐没有标签的罐头。可能是桃子，也可能是任何东西。',
        ),
        weight: 15,
      ),
      LibraryRow(
        Tx(
          '{1d6} rounds of ammunition in a rusted box.',
          '{1d6} патронов в ржавой коробке.',
          '{1d6} Schuss Munition in einer rostigen Schachtel.',
          '{1d6} cartouches dans une boîte rouillée.',
          '生锈盒子里的{1d6}发子弹。',
        ),
        weight: 15,
      ),
      LibraryRow(
        Tx(
          'A clean water filter, barely used.',
          'Чистый водяной фильтр, почти новый.',
          'Ein sauberer Wasserfilter, kaum benutzt.',
          'Un filtre à eau propre, à peine utilisé.',
          '一个几乎没用过的干净滤水器。',
        ),
        weight: 10,
      ),
      LibraryRow(
        Tx(
          'A {bicycle wheel|car battery|solar panel} in working order.',
          '{Велосипедное колесо|Автомобильный аккумулятор|Солнечная панель} в рабочем состоянии.',
          '{Ein Fahrradrad|Eine Autobatterie|Ein Solarmodul} in funktionsfähigem Zustand.',
          '{Une roue de vélo|Une batterie de voiture|Un panneau solaire} en état de marche.',
          '一个能用的{自行车轮|汽车电瓶|太阳能板}。',
        ),
        weight: 10,
      ),
      LibraryRow(
        Tx(
          'A first-aid kit with {1d4} doses of antibiotics, three years expired.',
          'Аптечка с {1d4} дозами антибиотиков, просроченными на три года.',
          'Ein Verbandskasten mit {1d4} Dosen Antibiotika, seit drei Jahren abgelaufen.',
          'Une trousse de secours avec {1d4} doses d\'antibiotiques, périmées depuis trois ans.',
          '一个急救包，有{1d4}剂过期三年的抗生素。',
        ),
        weight: 10,
      ),
      LibraryRow(
        Tx(
          'A working radio. It picks up one station, playing the same song on a loop.',
          'Рабочее радио. Ловит одну станцию, где по кругу играет одна песня.',
          'Ein funktionierendes Radio. Es empfängt einen Sender, der dasselbe Lied in Schleife spielt.',
          'Une radio qui marche. Elle capte une seule station qui passe la même chanson en boucle.',
          '一台能用的收音机，只收到一个电台，循环播放着同一首歌。',
        ),
        weight: 8,
      ),
      LibraryRow(
        Tx(
          'A gas mask with fresh filters.',
          'Противогаз со свежими фильтрами.',
          'Eine Gasmaske mit frischen Filtern.',
          'Un masque à gaz avec des filtres neufs.',
          '一副配着新滤芯的防毒面具。',
        ),
        weight: 6,
      ),
      LibraryRow(
        Tx(
          'A keycard for a pre-war bunker, and a map with the bunker circled.',
          'Ключ-карта от довоенного бункера и карта, где бункер обведён.',
          'Eine Schlüsselkarte für einen Vorkriegsbunker und eine Karte, auf der er eingekreist ist.',
          'Une carte d\'accès à un bunker d\'avant-guerre, et un plan où le bunker est entouré.',
          '一张战前地堡的门禁卡，还有一张圈出地堡位置的地图。',
        ),
        weight: 4,
      ),
      LibraryRow(
        Tx(
          'A crate of seeds in sealed foil: corn, beans, squash. A future.',
          'Ящик семян в запаянной фольге: кукуруза, фасоль, тыква. Будущее.',
          'Eine Kiste Saatgut in versiegelter Folie: Mais, Bohnen, Kürbis. Eine Zukunft.',
          'Une caisse de graines sous aluminium scellé : maïs, haricots, courges. Un avenir.',
          '一箱密封锡纸包装的种子：玉米、豆子、南瓜。那是未来。',
        ),
        weight: 2,
      ),
    ],
  ),
  LibraryTable(
    localId: 'campfire_rumors',
    style: _s,
    folder: LibraryFolder.rumors,
    formula: '1d10',
    name: Tx(
      'Campfire Rumors',
      'Слухи у костра',
      'Gerüchte am Lagerfeuer',
      'Rumeurs de bivouac',
      '篝火传闻',
    ),
    description: Tx(
      'Stories traded for a sip of water and a place by the fire.',
      'Истории, которыми расплачиваются за глоток воды и место у огня.',
      'Geschichten, getauscht gegen einen Schluck Wasser und einen Platz am Feuer.',
      'Des histoires échangées contre une gorgée d\'eau et une place près du feu.',
      '用来换一口水和火堆旁一个位置的故事。',
    ),
    rows: [
      LibraryRow(
        Tx(
          'There is a city to the north where the lights still work and nobody is allowed in.',
          'На севере есть город, где всё ещё горит свет, но туда никого не пускают.',
          'Im Norden gibt es eine Stadt, in der noch Licht brennt und niemand hinein darf.',
          'Au nord, il y a une ville où les lumières marchent encore et où personne n\'entre.',
          '北边有座城市，灯还亮着，但谁也不许进。',
        ),
      ),
      LibraryRow(
        Tx(
          'The Rust Barons are paying {1d6*10} bullets for every working engine.',
          'Ржавые Бароны платят по {1d6*10} патронов за каждый рабочий двигатель.',
          'Die Rostbarone zahlen {1d6*10} Patronen für jeden funktionierenden Motor.',
          'Les Barons de la Rouille paient {1d6*10} balles par moteur en état.',
          '锈铁男爵们每收一台能用的引擎，付{1d6*10}发子弹。',
        ),
      ),
      LibraryRow(
        Tx(
          'Rain fell green at the old dam last week. Everything it touched grew.',
          'На прошлой неделе у старой дамбы шёл зелёный дождь. Всё, чего он касался, росло.',
          'Letzte Woche fiel am alten Damm grüner Regen. Alles, was er berührte, wuchs.',
          'La semaine dernière, une pluie verte est tombée au vieux barrage. Tout ce qu\'elle touchait a poussé.',
          '上周旧水坝那边下了绿色的雨，被淋到的东西全都疯长。',
        ),
      ),
      LibraryRow(
        Tx(
          'A vault door opened on its own. Those who went down met [[@wasteland_encounters]]',
          'Дверь убежища открылась сама. Спустившиеся встретили: [[@wasteland_encounters]]',
          'Eine Bunkertür öffnete sich von selbst. Wer hinabstieg, traf auf: [[@wasteland_encounters]]',
          'Une porte d\'abri s\'est ouverte seule. Ceux qui sont descendus ont croisé : [[@wasteland_encounters]]',
          '一扇避难所大门自己打开了。下去的人遇到了：[[@wasteland_encounters]]',
        ),
      ),
      LibraryRow(
        Tx(
          'A doctor at the crossroads fixes anything, but takes payment in {blood|memories|years}.',
          'Доктор на перекрёстке вылечит что угодно, но берёт плату {кровью|воспоминаниями|годами жизни}.',
          'Eine Ärztin an der Kreuzung heilt alles, nimmt aber {Blut|Erinnerungen|Lebensjahre} als Bezahlung.',
          'Un docteur au carrefour répare tout, mais se fait payer {en sang|en souvenirs|en années}.',
          '十字路口有个医生什么都能治，但收费用的是{血|记忆|寿命}。',
        ),
      ),
      LibraryRow(
        Tx(
          'The old satellite is falling. Everyone wants to be where it lands.',
          'Старый спутник падает. Все хотят оказаться там, где он упадёт.',
          'Der alte Satellit stürzt ab. Alle wollen dort sein, wo er einschlägt.',
          'Le vieux satellite tombe. Tout le monde veut être là où il atterrira.',
          '那颗旧卫星要掉下来了，所有人都想赶到它的坠落点。',
        ),
      ),
      LibraryRow(
        Tx(
          'A settlement by the lake has children born without scars. People are jealous.',
          'В поселении у озера дети рождаются без шрамов. Люди завидуют.',
          'In einer Siedlung am See werden Kinder ohne Narben geboren. Die Leute sind neidisch.',
          'Dans une colonie près du lac, les enfants naissent sans cicatrices. Les gens sont jaloux.',
          '湖边一个聚居地的孩子生下来没有伤疤，引来旁人嫉妒。',
        ),
      ),
      LibraryRow(
        Tx(
          'The raider queen is dying and has no heir. Every gang is gathering.',
          'Королева налётчиков умирает, и у неё нет наследника. Банды собираются.',
          'Die Plündererkönigin liegt im Sterben und hat keinen Erben. Alle Banden sammeln sich.',
          'La reine des pillards se meurt sans héritier. Tous les gangs se rassemblent.',
          '掠夺者女王命不久矣，却没有继承人。各路帮派都在集结。',
        ),
      ),
      LibraryRow(
        Tx(
          'Someone found a library, whole and dry, under the highway.',
          'Кто-то нашёл под шоссе библиотеку — целую и сухую.',
          'Jemand hat unter dem Highway eine Bibliothek gefunden, ganz und trocken.',
          'Quelqu\'un a trouvé une bibliothèque, intacte et sèche, sous l\'autoroute.',
          '有人在高速公路底下发现了一座完好、干燥的图书馆。',
        ),
      ),
      LibraryRow(
        Tx(
          'The machines in the factory town started building something again.',
          'Машины в заводском городке снова начали что-то строить.',
          'Die Maschinen in der Fabrikstadt haben wieder angefangen, etwas zu bauen.',
          'Les machines de la ville-usine se sont remises à construire quelque chose.',
          '工厂镇里的机器又开始制造什么东西了。',
        ),
      ),
    ],
  ),
  LibraryTable(
    localId: 'hazards',
    style: _s,
    folder: LibraryFolder.locale,
    formula: '1d10',
    name: Tx(
      'Wasteland Hazards',
      'Опасности пустошей',
      'Gefahren des Ödlands',
      'Dangers des terres désolées',
      '废土险情',
    ),
    description: Tx(
      'The land itself tries to kill you.',
      'Сама земля пытается вас убить.',
      'Das Land selbst will euch umbringen.',
      'La terre elle-même tente de vous tuer.',
      '这片土地本身就想要你的命。',
    ),
    rows: [
      LibraryRow(
        Tx(
          'A dust storm rolls in: {1d6} hours of blindness and grit.',
          'Надвигается пыльная буря: {1d6} ч. слепоты и песка на зубах.',
          'Ein Staubsturm zieht auf: {1d6} Stunden Blindheit und Sand zwischen den Zähnen.',
          'Une tempête de poussière arrive : {1d6} heures d\'aveuglement et de sable.',
          '沙尘暴来袭：{1d6}小时什么都看不见，满嘴沙子。',
        ),
      ),
      LibraryRow(
        Tx(
          'A radiation hot spot. The counter clicks faster with every step.',
          'Радиоактивное пятно. Счётчик трещит всё чаще с каждым шагом.',
          'Ein Strahlungsherd. Der Zähler tickt mit jedem Schritt schneller.',
          'Un point chaud radioactif. Le compteur crépite plus vite à chaque pas.',
          '一处辐射热点，每走一步计数器就响得更急。',
        ),
      ),
      LibraryRow(
        Tx(
          'The road collapses into an old subway tunnel.',
          'Дорога проваливается в старый тоннель метро.',
          'Die Straße bricht in einen alten U-Bahn-Tunnel ein.',
          'La route s\'effondre dans un vieux tunnel de métro.',
          '路面塌进了一条旧地铁隧道。',
        ),
      ),
      LibraryRow(
        Tx(
          'The only water for miles is {brackish|poisoned|guarded}.',
          'Единственная вода на многие мили {солоноватая|отравлена|под охраной}.',
          'Das einzige Wasser weit und breit ist {brackig|vergiftet|bewacht}.',
          'La seule eau à des lieues est {saumâtre|empoisonnée|gardée}.',
          '方圆数里唯一的水源{又苦又咸|有毒|有人看守}。',
        ),
      ),
      LibraryRow(
        Tx(
          'Acid fog pools in the valley at dawn.',
          'На рассвете в долине скапливается кислотный туман.',
          'Im Morgengrauen sammelt sich Säurenebel im Tal.',
          'Un brouillard acide stagne dans la vallée à l\'aube.',
          '黎明时分，酸雾积聚在山谷里。',
        ),
      ),
      LibraryRow(
        Tx(
          'An old minefield, marked only by a doll on a stick.',
          'Старое минное поле, отмеченное лишь куклой на палке.',
          'Ein altes Minenfeld, nur durch eine Puppe auf einem Stock markiert.',
          'Un vieux champ de mines, signalé seulement par une poupée sur un bâton.',
          '一片旧雷区，唯一的标记是插在木棍上的一个娃娃。',
        ),
      ),
      LibraryRow(
        Tx(
          'A heatwave: water consumption doubles for {1d4} days.',
          'Жара: расход воды удваивается на {1d4} дн.',
          'Eine Hitzewelle: Der Wasserbedarf verdoppelt sich für {1d4} Tage.',
          'Canicule : la consommation d\'eau double pendant {1d4} jours.',
          '热浪来袭：{1d4}天内饮水量翻倍。',
        ),
      ),
      LibraryRow(
        Tx(
          'Fungal spores in a ruined mall. Those who breathe them hear whispers.',
          'Грибковые споры в разрушенном торговом центре. Вдохнувшие слышат шёпот.',
          'Pilzsporen in einem verfallenen Einkaufszentrum. Wer sie einatmet, hört Flüstern.',
          'Des spores fongiques dans un centre commercial en ruine. Ceux qui les respirent entendent des murmures.',
          '废弃商场里飘着真菌孢子，吸入的人会听到低语。',
        ),
      ),
      LibraryRow(
        Tx(
          'The vehicle breaks down in the open. Someone is watching from the ridge. [[@quirks]]',
          'Машина ломается посреди равнины. С гребня за вами наблюдают. [[@quirks]]',
          'Das Fahrzeug bleibt im offenen Gelände liegen. Vom Kamm aus beobachtet euch jemand. [[@quirks]]',
          'Le véhicule tombe en panne à découvert. Quelqu\'un vous observe depuis la crête. [[@quirks]]',
          '车在开阔地抛锚了。山脊上有人正盯着你们。[[@quirks]]',
        ),
      ),
      LibraryRow(
        Tx(
          'An automated defense turret, still powered, still loyal to a dead nation.',
          'Автоматическая турель, всё ещё под питанием и всё ещё верная мёртвой стране.',
          'Ein automatischer Geschützturm, noch unter Strom, noch einer toten Nation treu.',
          'Une tourelle automatique, toujours alimentée, toujours fidèle à une nation morte.',
          '一座自动防御炮塔，仍然通着电，仍然效忠一个已经灭亡的国家。',
        ),
      ),
    ],
  ),
  LibraryTable(
    localId: 'quirks',
    style: _s,
    folder: LibraryFolder.people,
    name: Tx(
      'Survivor Quirks',
      'Причуды выживших',
      'Marotten von Überlebenden',
      'Manies de survivants',
      '幸存者怪癖',
    ),
    description: Tx(
      'How the end of the world left its mark on someone.',
      'Как конец света оставил на ком-то свой след.',
      'Wie das Ende der Welt bei jemandem Spuren hinterlassen hat.',
      'Comment la fin du monde a marqué quelqu\'un.',
      '世界末日在某人身上留下的印记。',
    ),
    rows: [
      LibraryRow(
        Tx(
          'Hoards {bottle caps|keys|batteries} and counts them every night.',
          'Копит {крышки от бутылок|ключи|батарейки} и пересчитывает их каждую ночь.',
          'Hortet {Kronkorken|Schlüssel|Batterien} und zählt sie jede Nacht.',
          'Amasse {des capsules|des clés|des piles} et les compte chaque nuit.',
          '囤积{瓶盖|钥匙|电池}，每晚都要数一遍。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'Wears a pre-war business suit, patched a hundred times.',
          'Носит довоенный деловой костюм, залатанный сто раз.',
          'Trägt einen Vorkriegs-Anzug, hundertfach geflickt.',
          'Porte un costume d\'avant-guerre rapiécé cent fois.',
          '穿着一套补了上百次的战前西装。',
        ),
      ),
      LibraryRow(
        Tx(
          'Names every weapon they own and introduces them.',
          'Даёт имена всему своему оружию и представляет его.',
          'Gibt jeder Waffe einen Namen und stellt sie vor.',
          'Baptise chacune de ses armes et les présente.',
          '给每件武器起名字，还会逐一介绍。',
        ),
      ),
      LibraryRow(
        Tx(
          'Remembers the world before, and describes it wrongly on purpose.',
          'Помнит мир до конца и нарочно описывает его неправильно.',
          'Erinnert sich an die Welt davor und beschreibt sie absichtlich falsch.',
          'Se souvient du monde d\'avant et le décrit mal exprès.',
          '记得末日前的世界，却故意描述得乱七八糟。',
        ),
      ),
      LibraryRow(
        Tx(
          'Never sleeps with their back to a door.',
          'Никогда не спит спиной к двери.',
          'Schläft nie mit dem Rücken zur Tür.',
          'Ne dort jamais dos à une porte.',
          '睡觉时从不背对门口。',
        ),
        weight: 2,
      ),
      LibraryRow(
        Tx(
          'Has a Geiger counter for a pet and talks to it.',
          'Держит счётчик Гейгера как питомца и разговаривает с ним.',
          'Hat einen Geigerzähler als Haustier und redet mit ihm.',
          'A un compteur Geiger comme animal de compagnie et lui parle.',
          '把盖革计数器当宠物养，还会跟它说话。',
        ),
      ),
      LibraryRow(
        Tx(
          'Tattoos a tally mark for every day survived.',
          'Набивает татуировку-чёрточку за каждый прожитый день.',
          'Tätowiert sich für jeden überlebten Tag einen Strich.',
          'Se tatoue un trait pour chaque jour survécu.',
          '每活过一天，就在身上纹一道刻痕。',
        ),
      ),
      LibraryRow(
        Tx(
          'Trades only in stories and refuses bullets.',
          'Торгует только историями и отказывается от патронов.',
          'Handelt nur mit Geschichten und lehnt Patronen ab.',
          'Ne troque que des histoires et refuse les balles.',
          '只拿故事做交易，子弹一概不收。',
        ),
      ),
      LibraryRow(
        Tx(
          'Is convinced the war is still going on somewhere.',
          'Уверен, что где-то война всё ещё идёт.',
          'Ist überzeugt, dass der Krieg irgendwo noch weitergeht.',
          'Est persuadé que la guerre continue quelque part.',
          '坚信战争仍在某个地方继续。',
        ),
      ),
      LibraryRow(
        Tx(
          'Grows a single flower in a helmet and guards it with their life.',
          'Выращивает единственный цветок в каске и бережёт его ценой жизни.',
          'Zieht eine einzige Blume in einem Helm und verteidigt sie mit dem Leben.',
          'Fait pousser une unique fleur dans un casque et la protège au péril de sa vie.',
          '在头盔里养着一朵花，拼了命也要护着它。',
        ),
      ),
    ],
  ),
];
