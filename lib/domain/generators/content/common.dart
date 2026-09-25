import '../content_format.dart';

/// Fragments shared by every pack; pack lists of the same name are added
/// in front of these. Rows are `en ¦ ru ¦ de ¦ fr ¦ zh`.
final commonContent = PackContent.build(rows: _rows, perLang: _perLang);

const _rows = <String, String>{
  'full_name': '''
{=given} {=family} ¦ {=given} {=family} ¦ {=given} {=family} ¦ {=given} {=family} ¦ {=given}·{=family}
''',
  'with_epithet': '''
{=name}, {=epithet} ¦ {=name} по прозвищу {=epithet} ¦ {=name}, {=epithet} ¦ {=name}, {=epithet} ¦ 「{=epithet}」{=name}
''',
  'owner_line': '''
{=owner} — {trait} ¦ {=owner} — {trait} ¦ {=owner} – {trait} ¦ {=owner} — {trait} ¦ {=owner}——{trait}
''',
  'gender_word': '''
@f female ¦ женский ¦ weiblich ¦ féminin ¦ 女
@m male ¦ мужской ¦ männlich ¦ masculin ¦ 男
''',
  'stat_abbr': '''
STR ¦ СИЛ ¦ STÄ ¦ FOR ¦ 力量
DEX ¦ ЛОВ ¦ GES ¦ DEX ¦ 敏捷
CON ¦ ТЕЛ ¦ KON ¦ CON ¦ 体质
INT ¦ ИНТ ¦ INT ¦ INT ¦ 智力
WIS ¦ МДР ¦ WEI ¦ SAG ¦ 感知
CHA ¦ ХАР ¦ CHA ¦ CHA ¦ 魅力
''',
  'age': '''
young ¦ молодой~молодая ¦ jung ¦ jeune ¦ 年轻
barely an adult ¦ едва совершеннолетний~едва совершеннолетняя ¦ gerade erwachsen ¦ à peine majeur~à peine majeure ¦ 刚成年
in the prime of life ¦ в самом расцвете сил ¦ in den besten Jahren ¦ dans la force de l'âge ¦ 正值壮年
middle-aged ¦ средних лет ¦ mittleren Alters ¦ d'âge mûr ¦ 中年
going grey ¦ седеющий~седеющая ¦ angegraut ¦ grisonnant~grisonnante ¦ 两鬓斑白
old ¦ пожилой~пожилая ¦ betagt ¦ âgé~âgée ¦ 年迈
ancient ¦ глубокий старик~глубокая старуха ¦ uralt ¦ très vieux~très vieille ¦ 老态龙钟
''',
  'trait': '''
never forgets a face ¦ никогда не забывает лиц ¦ vergisst nie ein Gesicht ¦ n'oublie jamais un visage ¦ 过目不忘
laughs a beat too late at every joke ¦ смеётся над шутками с опозданием ¦ lacht immer einen Moment zu spät ¦ rit toujours une seconde trop tard ¦ 听笑话总是慢半拍才笑
distrusts anyone who smiles too much ¦ не доверяет тем, кто много улыбается ¦ misstraut jedem, der zu viel lächelt ¦ se méfie de quiconque sourit trop ¦ 不信任笑得太多的人
keeps exact accounts of every favor owed ¦ ведёт строгий учёт всех услуг и долгов ¦ führt genau Buch über jeden geschuldeten Gefallen ¦ tient le compte exact de chaque faveur due ¦ 每一笔人情都记得清清楚楚
cannot resist a wager ¦ не может устоять перед пари ¦ kann keiner Wette widerstehen ¦ ne résiste jamais à un pari ¦ 见赌必下
speaks bluntly and regrets it later ¦ говорит прямо и потом жалеет ¦ redet unverblümt und bereut es später ¦ parle sans détour et le regrette ensuite ¦ 说话直来直去，事后又后悔
hoards small, useless trinkets ¦ копит мелкие бесполезные безделушки ¦ hortet kleinen, nutzlosen Krimskrams ¦ amasse de petits bibelots inutiles ¦ 囤积没用的小玩意儿
treats every stranger as a friend-to-be ¦ видит в каждом незнакомце будущего друга ¦ sieht in jedem Fremden einen künftigen Freund ¦ voit en chaque inconnu un futur ami ¦ 把每个陌生人都当作未来的朋友
answers questions with questions ¦ отвечает вопросом на вопрос ¦ beantwortet Fragen mit Gegenfragen ¦ répond aux questions par d'autres questions ¦ 总以问题回答问题
counts everything twice ¦ всё пересчитывает дважды ¦ zählt alles zweimal nach ¦ recompte tout deux fois ¦ 什么都要数两遍
hums old tunes when the pressure rises ¦ напевает старые мотивы, когда нервничает ¦ summt bei Nervosität alte Lieder ¦ fredonne de vieux airs quand la pression monte ¦ 一紧张就哼老调子
holds grudges for decades ¦ помнит обиды десятилетиями ¦ trägt jahrzehntelang Groll nach ¦ garde rancune pendant des décennies ¦ 记仇能记几十年
gives away the last coin in the purse ¦ раздаёт последние деньги ¦ verschenkt die letzte Münze ¦ donne jusqu'à son dernier sou ¦ 连最后一文钱也送人
lies about small things, never about big ones ¦ врёт по мелочам, но никогда — о важном ¦ lügt bei Kleinigkeiten, nie bei wichtigen Dingen ¦ ment sur les détails, jamais sur l'essentiel ¦ 小事撒谎，大事从不
tears up at the slightest kindness ¦ плачет от малейшей доброты ¦ weint bei der kleinsten Freundlichkeit ¦ pleure à la moindre gentillesse ¦ 别人稍一示好就会落泪
quotes proverbs nobody has heard of ¦ цитирует пословицы, которых никто не слышал ¦ zitiert Sprichwörter, die niemand kennt ¦ cite des proverbes que personne ne connaît ¦ 爱引用谁都没听过的谚语
never sits with their back to a door ¦ никогда не садится спиной к двери ¦ setzt sich nie mit dem Rücken zur Tür ¦ ne s'assoit jamais dos à la porte ¦ 从不背对门坐
collects gossip like coins ¦ собирает сплетни, как монеты ¦ sammelt Klatsch wie Münzen ¦ collectionne les ragots comme des pièces ¦ 像攒钱一样收集流言
panics near deep water ¦ паникует у глубокой воды ¦ gerät an tiefem Wasser in Panik ¦ panique près de l'eau profonde ¦ 一靠近深水就惊慌
apologizes constantly ¦ постоянно извиняется ¦ entschuldigt sich ständig ¦ s'excuse sans arrêt ¦ 动不动就道歉
takes every insult as a challenge ¦ воспринимает любое оскорбление как вызов ¦ nimmt jede Beleidigung als Herausforderung ¦ prend chaque insulte pour un défi ¦ 把每句冒犯都当成挑战
speaks to animals more kindly than to people ¦ с животными разговаривает ласковее, чем с людьми ¦ spricht mit Tieren freundlicher als mit Menschen ¦ parle aux animaux plus gentiment qu'aux gens ¦ 对动物说话比对人温柔
always has a plan, rarely a good one ¦ всегда держит наготове план, редко удачный ¦ hat immer einen Plan, selten einen guten ¦ a toujours un plan, rarement un bon ¦ 总有计划，但很少是好计划
trusts omens more than advice ¦ верит приметам больше, чем советам ¦ vertraut Omen mehr als Ratschlägen ¦ se fie davantage aux présages qu'aux conseils ¦ 信兆头胜过信忠告
bargains over everything, even gifts ¦ торгуется из-за всего, даже из-за подарков ¦ feilscht um alles, sogar um Geschenke ¦ marchande tout, même les cadeaux ¦ 什么都要讨价还价，连礼物也不例外
feeds anyone who looks hungry ¦ кормит всякого, кто выглядит голодным ¦ gibt jedem zu essen, der hungrig aussieht ¦ nourrit quiconque a l'air affamé ¦ 见人饿着就请吃饭
keeps secrets well but hints at them constantly ¦ хорошо хранит тайны, но постоянно на них намекает ¦ hütet Geheimnisse gut, deutet sie aber ständig an ¦ garde bien les secrets mais y fait sans cesse allusion ¦ 守得住秘密，却总爱暗示
never changes a decision once made ¦ никогда не меняет принятых решений ¦ ändert nie eine einmal gefasste Entscheidung ¦ ne revient jamais sur une décision ¦ 一旦决定就绝不更改
flirts out of sheer habit ¦ флиртует просто по привычке ¦ flirtet aus reiner Gewohnheit ¦ flirte par pure habitude ¦ 纯粹出于习惯地调情
looks for the exit in every room ¦ в каждой комнате первым делом ищет выход ¦ sucht in jedem Raum zuerst den Ausgang ¦ cherche la sortie dans chaque pièce ¦ 进屋先找出口
''',
  'voice': '''
speaks in a hoarse whisper ¦ говорит хриплым шёпотом ¦ spricht in heiserem Flüsterton ¦ parle dans un murmure rauque ¦ 说话声音嘶哑低沉
punctuates sentences with a dry cough ¦ перемежает фразы сухим покашливанием ¦ unterbricht jeden Satz mit trockenem Hüsteln ¦ ponctue ses phrases d'une toux sèche ¦ 说话总夹着干咳
drawls every vowel ¦ растягивает гласные ¦ zieht jeden Vokal in die Länge ¦ traîne sur chaque voyelle ¦ 每个字都拖着长音
talks with both hands ¦ активно жестикулирует ¦ redet mit Händen und Füßen ¦ parle avec les mains ¦ 说话时手舞足蹈
never makes eye contact ¦ никогда не смотрит в глаза ¦ weicht jedem Blick aus ¦ évite toujours le regard ¦ 从不与人对视
laughs like a creaking door ¦ смеётся, будто скрипит дверь ¦ lacht wie eine knarrende Tür ¦ rit comme une porte qui grince ¦ 笑声像吱呀作响的门
finishes other people's sentences ¦ договаривает за других ¦ beendet die Sätze anderer ¦ termine les phrases des autres ¦ 爱抢别人的话头
speaks slowly, as if every word costs money ¦ говорит медленно, будто каждое слово стоит денег ¦ spricht langsam, als koste jedes Wort Geld ¦ parle lentement, comme si chaque mot coûtait cher ¦ 说话极慢，仿佛每个字都要花钱
whistles through a gap in the teeth ¦ присвистывает сквозь щербинку в зубах ¦ pfeift beim Sprechen durch eine Zahnlücke ¦ siffle entre ses dents écartées ¦ 说话时从牙缝里漏风
speaks of themself in the third person ¦ говорит о себе в третьем лице ¦ spricht von sich in der dritten Person ¦ parle de soi à la troisième personne ¦ 用第三人称称呼自己
taps a rhythm on every surface ¦ отстукивает ритм по любой поверхности ¦ trommelt auf jeder Oberfläche einen Takt ¦ tapote un rythme sur toutes les surfaces ¦ 总在手边敲着节拍
has a booming voice that fills any room ¦ обладает гулким голосом, заполняющим любую комнату ¦ hat eine dröhnende Stimme, die jeden Raum füllt ¦ a une voix tonitruante qui emplit la pièce ¦ 嗓门洪亮，满屋回响
mispronounces long words with confidence ¦ уверенно коверкает длинные слова ¦ spricht lange Wörter selbstbewusst falsch aus ¦ écorche les mots longs avec aplomb ¦ 自信满满地念错长词
sighs before every answer ¦ вздыхает перед каждым ответом ¦ seufzt vor jeder Antwort ¦ soupire avant chaque réponse ¦ 回答前总要叹口气
speaks in a lilting, sing-song cadence ¦ говорит певуче, нараспев ¦ spricht in singendem Tonfall ¦ parle d'une voix chantante ¦ 说话抑扬顿挫，像在唱歌
chews on something constantly ¦ постоянно что-то жуёт ¦ kaut ständig auf etwas herum ¦ mâchonne sans cesse quelque chose ¦ 嘴里总嚼着东西
addresses everyone with old-fashioned courtesy ¦ ко всем обращается по-старомодному учтиво ¦ spricht jeden mit altmodischer Höflichkeit an ¦ s'adresse à chacun avec une politesse désuète ¦ 对谁都用老派的尊称
drops to a whisper for no reason ¦ без причины переходит на шёпот ¦ senkt grundlos die Stimme ¦ baisse la voix sans raison ¦ 无缘无故压低声音
cracks knuckles before speaking ¦ хрустит пальцами, прежде чем заговорить ¦ lässt vor dem Sprechen die Knöchel knacken ¦ fait craquer ses doigts avant de parler ¦ 开口前先掰响指节
stammers when lying ¦ заикается, когда врёт ¦ stottert beim Lügen ¦ bégaie en mentant ¦ 一撒谎就结巴
uses far too many words for anything ¦ на всё тратит слишком много слов ¦ macht aus allem einen langen Vortrag ¦ fait des phrases interminables ¦ 说什么都啰里啰嗦
answers in clipped single words ¦ отвечает односложно ¦ antwortet einsilbig ¦ répond par monosyllabes ¦ 回答总是只有一两个字
mimics the accent of whoever is talking ¦ невольно подражает акценту собеседника ¦ ahmt unbewusst den Akzent des Gegenübers nach ¦ imite sans le vouloir l'accent de son interlocuteur ¦ 不自觉地模仿对方口音
smiles only with the mouth ¦ улыбается одними губами ¦ lächelt nur mit dem Mund ¦ ne sourit que des lèvres ¦ 只是嘴角在笑
''',
  'appearance': '''
a scar through one eyebrow ¦ шрам через бровь ¦ eine Narbe quer durch eine Augenbraue ¦ une cicatrice qui barre un sourcil ¦ 一道疤横穿眉毛
ink-stained fingers ¦ пальцы в чернильных пятнах ¦ tintenfleckige Finger ¦ des doigts tachés d'encre ¦ 手指沾满墨迹
a crooked, often-broken nose ¦ кривой, не раз сломанный нос ¦ eine schiefe, oft gebrochene Nase ¦ un nez tordu, cassé plus d'une fois ¦ 断过好几次的歪鼻子
mismatched eyes, one grey and one brown ¦ разные глаза: один серый, другой карий ¦ verschiedenfarbige Augen, eines grau, eines braun ¦ des yeux vairons, l'un gris, l'autre brun ¦ 一灰一褐的异色双眼
hair braided with tiny bells ¦ волосы, заплетённые с крошечными колокольчиками ¦ Haare mit eingeflochtenen Glöckchen ¦ des cheveux tressés de clochettes ¦ 发辫里编着小铃铛
an old burn across the back of one hand ¦ старый ожог на тыльной стороне ладони ¦ eine alte Brandnarbe auf dem Handrücken ¦ une vieille brûlure sur le dos de la main ¦ 手背上一块旧烧伤
two fingers missing from the left hand ¦ нет двух пальцев на левой руке ¦ zwei fehlende Finger an der linken Hand ¦ deux doigts en moins à la main gauche ¦ 左手缺了两根手指
clothes a size too large ¦ одежда на размер больше ¦ Kleidung eine Nummer zu groß ¦ des vêtements trop grands d'une taille ¦ 衣服大了一号
a gap-toothed grin ¦ щербатая улыбка ¦ ein Grinsen mit Zahnlücke ¦ un sourire aux dents écartées ¦ 缺了颗牙的笑容
freckles like spilled paint ¦ веснушки, словно брызги краски ¦ Sommersprossen wie verspritzte Farbe ¦ des taches de rousseur comme de la peinture renversée ¦ 满脸雀斑，像泼上的颜料
immaculately pressed clothes ¦ безупречно отглаженная одежда ¦ makellos gebügelte Kleidung ¦ des vêtements impeccablement repassés ¦ 衣着熨烫得一丝不苟
a nervous twitch in one eyelid ¦ нервный тик века ¦ ein nervös zuckendes Augenlid ¦ une paupière qui tressaute nerveusement ¦ 一侧眼皮神经质地跳动
very tall and slightly stooped ¦ очень высокий рост и лёгкая сутулость ¦ sehr groß und leicht gebeugt ¦ une très grande taille et le dos un peu voûté ¦ 个子很高，微微驼背
short and broad as a barrel ¦ коренастая фигура, словно бочонок ¦ klein und breit wie ein Fass ¦ une silhouette trapue comme un tonneau ¦ 又矮又壮，像只木桶
a faded tattoo peeking from the collar ¦ выцветшая татуировка, выглядывающая из-под воротника ¦ eine verblasste Tätowierung, die unter dem Kragen hervorlugt ¦ un tatouage délavé qui dépasse du col ¦ 领口露出一截褪色的纹身
eyebrows that meet in the middle ¦ сросшиеся брови ¦ zusammengewachsene Augenbrauen ¦ des sourcils qui se rejoignent ¦ 两道眉毛连成一线
a lingering smell of smoke ¦ неистребимый запах дыма ¦ ein ständiger Rauchgeruch ¦ une odeur de fumée tenace ¦ 身上总有股烟味
rings on every finger ¦ кольца на каждом пальце ¦ Ringe an jedem Finger ¦ des bagues à chaque doigt ¦ 每根手指都戴着戒指
calloused hands like old leather ¦ мозолистые руки, как старая кожа ¦ schwielige Hände wie altes Leder ¦ des mains calleuses comme du vieux cuir ¦ 双手粗糙如旧皮革
a limp favoring the right leg ¦ хромота на правую ногу ¦ ein Hinken auf dem rechten Bein ¦ une légère claudication de la jambe droite ¦ 右腿有点跛
unnervingly pale eyes ¦ пугающе светлые глаза ¦ beunruhigend helle Augen ¦ des yeux d'une pâleur troublante ¦ 淡得瘆人的眼睛
''',
  'motivation': '''
pay off a crushing debt ¦ расплатиться с огромным долгом ¦ eine erdrückende Schuld abbezahlen ¦ rembourser une dette écrasante ¦ 还清一笔沉重的债务
find a missing sibling ¦ найти пропавшего брата или сестру ¦ ein vermisstes Geschwisterkind finden ¦ retrouver un frère ou une sœur disparus ¦ 找到失踪的兄弟姐妹
earn the respect of a stern parent ¦ заслужить уважение сурового родителя ¦ die Anerkennung eines strengen Elternteils gewinnen ¦ gagner le respect d'un parent sévère ¦ 赢得严厉父母的认可
buy back the family home ¦ выкупить родовой дом ¦ das Elternhaus zurückkaufen ¦ racheter la maison familiale ¦ 赎回祖宅
see the ocean before dying ¦ увидеть море перед смертью ¦ vor dem Tod noch das Meer sehen ¦ voir la mer avant de mourir ¦ 死前看一眼大海
take revenge for a betrayal ¦ отомстить за предательство ¦ Rache für einen Verrat nehmen ¦ se venger d'une trahison ¦ 为一次背叛复仇
keep a hidden child safe ¦ уберечь тайного ребёнка ¦ ein verborgenes Kind beschützen ¦ protéger un enfant caché ¦ 保护一个不为人知的孩子
leave a name that outlives them ¦ оставить имя, которое переживёт века ¦ einen Namen hinterlassen, der überdauert ¦ laisser un nom qui lui survive ¦ 留下流传后世的名声
win back a lost love ¦ вернуть утраченную любовь ¦ eine verlorene Liebe zurückgewinnen ¦ reconquérir un amour perdu ¦ 挽回逝去的爱情
escape a life chosen by others ¦ сбежать от жизни, выбранной другими ¦ einem von anderen bestimmten Leben entkommen ¦ fuir une vie choisie par d'autres ¦ 逃离别人安排好的人生
prove a rival wrong ¦ доказать сопернику, что он неправ ¦ einem Rivalen das Gegenteil beweisen ¦ prouver à un rival qu'il a tort ¦ 证明对手错了
atone for a death on their conscience ¦ искупить смерть на своей совести ¦ eine Schuld am Tod eines Menschen sühnen ¦ expier une mort sur sa conscience ¦ 为良心上的一条人命赎罪
retire somewhere quiet and comfortable ¦ уйти на покой в тихое и сытое место ¦ sich an einem ruhigen Ort zur Ruhe setzen ¦ se retirer dans un coin tranquille ¦ 找个安静的地方安度晚年
uncover the truth about their parentage ¦ узнать правду о своём происхождении ¦ die Wahrheit über die eigene Herkunft erfahren ¦ découvrir la vérité sur ses origines ¦ 查清自己的身世
keep the peace at any cost ¦ сохранить мир любой ценой ¦ den Frieden um jeden Preis wahren ¦ préserver la paix à tout prix ¦ 不惜代价维持和平
become indispensable to someone powerful ¦ стать незаменимым для кого-то могущественного~стать незаменимой для кого-то могущественного ¦ für einen Mächtigen unentbehrlich werden ¦ devenir indispensable à un puissant ¦ 成为某位权贵不可或缺的人
''',
  'secret': '''
is secretly in love with a sworn enemy ¦ тайно влюблён во врага~тайно влюблена во врага ¦ ist heimlich in einen Todfeind verliebt ¦ est secrètement amoureux d'un ennemi juré~est secrètement amoureuse d'un ennemi juré ¦ 暗中爱上了宿敌
owes a dangerous person a fortune ¦ должен целое состояние опасному человеку~должна целое состояние опасному человеку ¦ schuldet einer gefährlichen Person ein Vermögen ¦ doit une fortune à une personne dangereuse ¦ 欠了危险人物一大笔钱
cannot read, and hides it well ¦ не умеет читать и искусно это скрывает ¦ kann nicht lesen und verbirgt es geschickt ¦ ne sait pas lire et le cache bien ¦ 不识字，却掩饰得很好
lives under a stolen name ¦ живёт под чужим именем ¦ lebt unter falschem Namen ¦ vit sous un nom d'emprunt ¦ 冒用他人姓名生活
informs on the neighbors for a powerful patron ¦ доносит на соседей могущественному покровителю ¦ bespitzelt die Nachbarn für einen mächtigen Gönner ¦ espionne ses voisins pour un puissant protecteur ¦ 替权贵暗中监视邻里
witnessed a murder and has told no one ¦ стал свидетелем убийства и молчит~стала свидетельницей убийства и молчит ¦ hat einen Mord beobachtet und schweigt ¦ a vu un meurtre et se tait ¦ 目睹过一起谋杀，却守口如瓶
is quietly dying of an illness ¦ медленно умирает от болезни и никому не говорит ¦ stirbt heimlich an einer Krankheit ¦ se meurt en secret d'une maladie ¦ 身患绝症，秘而不宣
keeps a stolen heirloom under the floorboards ¦ хранит под половицами украденную семейную реликвию ¦ versteckt ein gestohlenes Erbstück unter den Dielen ¦ cache un héritage volé sous le plancher ¦ 把偷来的传家宝藏在地板下
has a second family in another town ¦ имеет вторую семью в другом городе ¦ hat eine zweite Familie in einer anderen Stadt ¦ a une seconde famille dans une autre ville ¦ 在另一座城里还有一个家
feigns a faith abandoned long ago ¦ изображает веру, которую давно утратил~изображает веру, которую давно утратила ¦ heuchelt einen längst verlorenen Glauben ¦ feint une foi perdue depuis longtemps ¦ 假装虔诚，其实早已失去信仰
set the fire everyone blames on bad luck ¦ устроил пожар, который все считают несчастным случаем~устроила пожар, который все считают несчастным случаем ¦ hat das Feuer gelegt, das alle für ein Unglück halten ¦ a allumé l'incendie que tous croient accidentel ¦ 那场人人都以为是意外的大火，正是其所放
is being blackmailed ¦ стал жертвой шантажа~стала жертвой шантажа ¦ wird erpresst ¦ est victime d'un chantage ¦ 正遭人勒索
knows where a body is buried, quite literally ¦ знает, где зарыто тело, — в прямом смысле ¦ weiß, wo eine Leiche vergraben liegt – wortwörtlich ¦ sait où un corps est enterré, au sens propre ¦ 知道一具尸体埋在哪里——字面意义上的
is the heir of a fallen house ¦ наследник павшего рода~наследница павшего рода ¦ ist Erbe eines gestürzten Hauses~ist Erbin eines gestürzten Hauses ¦ est l'héritier d'une maison déchue~est l'héritière d'une maison déchue ¦ 是没落世家的继承人
''',
  'rumor_truth': '''
true ¦ правда ¦ wahr ¦ vrai ¦ 属实
false ¦ ложь ¦ falsch ¦ faux ¦ 纯属虚构
partly true ¦ отчасти правда ¦ teilweise wahr ¦ en partie vrai ¦ 半真半假
true, but out of date ¦ правда, но устаревшая ¦ wahr, aber veraltet ¦ vrai, mais dépassé ¦ 曾经属实，但已过时
a deliberate lie spread by an interested party ¦ намеренная ложь, которую распускает заинтересованная сторона ¦ eine gezielte Lüge, gestreut von einer interessierten Partei ¦ un mensonge délibéré, répandu par une partie intéressée ¦ 有心人故意散布的谎言
true, but the wrong person is blamed ¦ правда, но обвиняют не того ¦ wahr, aber man beschuldigt den Falschen ¦ vrai, mais on accuse la mauvaise personne ¦ 属实，但怪错了人
''',
};

const _perLang = <String, Map<String, String>>{
  'en': {
    'est_name': '''
The {est_adj} {est_noun}
The {est_noun} and {est_noun}
''',
    'settle_name': '{settle_pre}{settle_suf}',
    'faction_name': 'The {faction_noun} {faction_of}',
  },
  'ru': {
    'est_name': '''
«{est_adj_m:cap} {est_noun_m}»
«{est_adj_f:cap} {est_noun_f}»
«{est_noun:cap} и {est_noun}»
''',
    'settle_name': '{settle_pre}{settle_suf}',
    'faction_name': '{faction_noun} {faction_of}',
  },
  'de': {
    'est_name': '''
Zum {est_adj} {est_noun_m}
Zur {est_adj} {est_noun_f}
{est_noun} & {est_noun}
''',
    'settle_name': '{settle_pre}{settle_suf}',
    'faction_name': '{faction_noun} {faction_of}',
  },
  'fr': {
    'est_name': '''
Au {est_noun_m} {est_adj_m}
À la {est_noun_f} {est_adj_f}
''',
    'settle_name': '{settle_pre}{settle_suf}',
    'faction_name': '{faction_noun} {faction_of}',
  },
  'zh': {
    'est_name': '{est_adj}{est_noun}',
    'settle_name': '{settle_pre}{settle_suf}',
    'faction_name': '{faction_of}{faction_noun}',
  },
};
