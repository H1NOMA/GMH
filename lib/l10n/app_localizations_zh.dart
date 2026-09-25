// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Game Master\'s Hub';

  @override
  String get navDashboard => '世界总览';

  @override
  String get navSearch => '搜索';

  @override
  String get navGraph => '关系图谱';

  @override
  String get navGraphShort => '图谱';

  @override
  String get navCampaigns => '战役';

  @override
  String get navSettings => '设置与备份';

  @override
  String get navSettingsShort => '设置';

  @override
  String get navHome => '主页';

  @override
  String get sectionWorld => '世界';

  @override
  String get sectionLibrary => '资料库';

  @override
  String get switchWorld => '切换世界';

  @override
  String get worldsTagline => '你的世界完全属于你——全部存储在本设备上。';

  @override
  String worldsLoadError(String error) {
    return '无法加载世界：$error';
  }

  @override
  String get worldsEmpty => '还没有世界。在下方创建你的第一个世界吧。';

  @override
  String worldEdited(String when) {
    return '编辑于$when';
  }

  @override
  String get createNewWorld => '创建新世界';

  @override
  String get createWorldTitle => '创建一个新世界';

  @override
  String get worldNameLabel => '世界名称';

  @override
  String get worldNameHint => '例如：奥里安诸界';

  @override
  String get worldDescriptionLabel => '描述（可选）';

  @override
  String get cancel => '取消';

  @override
  String get create => '创建';

  @override
  String get add => '添加';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get restore => '恢复';

  @override
  String get open => '打开';

  @override
  String get rename => '重命名';

  @override
  String get newButton => '新建';

  @override
  String errorGeneric(String error) {
    return '错误：$error';
  }

  @override
  String get errorNameEmpty => '名称不能为空。';

  @override
  String get errorUnexpected => '出了点问题，请重试。';

  @override
  String get homeTheWorld => '世界';

  @override
  String get homeLibrary => '资料库';

  @override
  String get homeFavorites => '收藏';

  @override
  String get homeRecentlyOpened => '最近打开';

  @override
  String entriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count个条目',
      one: '$count个条目',
      zero: '暂无条目',
    );
    return '$_temp0';
  }

  @override
  String filterHint(String plural) {
    return '筛选$plural…';
  }

  @override
  String get favoritesOnly => '仅显示收藏';

  @override
  String get showAll => '显示全部';

  @override
  String get sortTooltip => '排序';

  @override
  String get sortRecentlyEdited => '最近编辑';

  @override
  String get sortNameAz => '名称（A–Z）';

  @override
  String get sortNewestFirst => '最新优先';

  @override
  String noEntriesOfKind(String plural) {
    return '暂无$plural';
  }

  @override
  String newOfKind(String label) {
    return '新建$label';
  }

  @override
  String get newEntryTitle => '新建条目';

  @override
  String get typeLabel => '类型';

  @override
  String get nameLabel => '名称';

  @override
  String get editEntryTitle => '编辑条目';

  @override
  String get summaryLabel => '摘要';

  @override
  String get summaryHint => '显示在列表和搜索结果中的一句话';

  @override
  String deleteEntryTitle(String name) {
    return '要删除“$name”吗？';
  }

  @override
  String get deleteEntryBody => '该条目将移入回收站；在彻底清除之前，指向它的链接会保留。';

  @override
  String get addToFavorites => '添加到收藏';

  @override
  String get removeFromFavorites => '从收藏中移除';

  @override
  String get menuEditNameSummary => '编辑名称与摘要';

  @override
  String get menuShowInGraph => '在图谱中显示';

  @override
  String get entryGone => '该条目已不存在。';

  @override
  String get tabDocument => '文档';

  @override
  String get tabDetails => '详情';

  @override
  String get editorPlaceholder => '书写你的传说…点击@按钮链接其他条目。';

  @override
  String get editorLinkEntity => '链接条目（提及）';

  @override
  String get editorInsertImage => '插入图片';

  @override
  String get editorAttachFile => '在文本中附加文件';

  @override
  String get editorVersionHistory => '版本历史';

  @override
  String get insertLinkTitle => '插入条目链接';

  @override
  String get missingLink => '已丢失';

  @override
  String get versionHistoryTitle => '版本历史';

  @override
  String get versionHistoryEmpty => '还没有快照。离开编辑器或恢复版本时会自动保存快照。';

  @override
  String get versionEmptyPreview => '（空）';

  @override
  String get versionBeforeRestore => '恢复前';

  @override
  String get searchHint => '搜索名称、传说、标签…';

  @override
  String get searchAll => '全部';

  @override
  String get searchNoMatches => '没有匹配结果';

  @override
  String get quickActions => '快捷操作';

  @override
  String get quickNewEntry => '新建条目';

  @override
  String get quickOpenGraph => '打开图谱';

  @override
  String get quickBackupExport => '备份与导出';

  @override
  String get recentlyOpenedCaps => '最近打开';

  @override
  String get graphTitle => '关系图谱';

  @override
  String get graphLocalTitle => '局部图谱';

  @override
  String get graphWholeWorld => '整个世界';

  @override
  String get graphFilterKinds => '按类型筛选';

  @override
  String get graphEmpty => '还没有任何连接。\n用@提及、关系或结构化字段把条目链接起来，你的世界之网就会在这里浮现。';

  @override
  String graphTruncated(int count) {
    return '仅显示连接最多的$count个条目。聚焦某个条目可查看它的局部图谱。';
  }

  @override
  String get campaignsTitle => '战役';

  @override
  String get switchCampaign => '切换战役';

  @override
  String get noCampaigns => '还没有战役';

  @override
  String get startCampaign => '开始一场战役';

  @override
  String get questBoard => '任务板';

  @override
  String get sessionLog => '跑团日志';

  @override
  String get noQuestsLinked => '这场战役还没有关联任务。创建一个任务并设置它的“战役”字段。';

  @override
  String get noSessions => '还没有跑团记录。';

  @override
  String chapterLabel(String chapter) {
    return '章节：$chapter';
  }

  @override
  String get noPlayers => '还没有玩家';

  @override
  String questsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count个任务',
      one: '$count个任务',
    );
    return '$_temp0';
  }

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count次跑团',
      one: '$count次跑团',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => '设置与备份';

  @override
  String get languageSection => '语言';

  @override
  String get languageSystem => '跟随系统语言';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageChinese => '中文';

  @override
  String exportSection(String world) {
    return '导出“$world”';
  }

  @override
  String get exportSubtitle => '在你主动分享之前，一切都只保存在本设备上。';

  @override
  String get exportArchiveTitle => '完整项目存档（.gmhw）';

  @override
  String get exportArchiveSubtitle => '数据库与所有媒体打包为一个文件，适合在设备间迁移。';

  @override
  String get exportJsonTitle => 'JSON数据导出';

  @override
  String get exportJsonSubtitle => '所有条目、链接和元数据，以可读的JSON格式导出。';

  @override
  String get exportPdfTitle => 'PDF世界之书';

  @override
  String get exportPdfSubtitle => '可打印的世界之书，每个类别一章。';

  @override
  String get importSection => '导入';

  @override
  String get importArchiveTitle => '导入项目存档';

  @override
  String get importArchiveSubtitle => '恢复.gmhw文件，包括所有媒体。';

  @override
  String get importPickArchive => '选择.gmhw存档';

  @override
  String get backupsSection => '备份';

  @override
  String backupsSubtitle(int count) {
    return '每天打开应用时会自动创建一次备份，保留最近$count份。';
  }

  @override
  String get backupNow => '立即备份';

  @override
  String get noBackups => '还没有备份。';

  @override
  String get restoreBackupTitle => '要恢复此备份吗？';

  @override
  String restoreBackupBody(String file) {
    return '世界将被替换为“$file”的内容。恢复前会先自动保存当前状态的安全备份。';
  }

  @override
  String get aboutSection => '关于';

  @override
  String get aboutLocalFirst => '本地优先';

  @override
  String get aboutLocalFirstBody => '所有数据都存储在本设备上。无需账号、无需云端、完全离线。';

  @override
  String get backupSaved => '备份已保存。';

  @override
  String get worldImported => '世界已导入。';

  @override
  String get backupRestored => '备份已恢复。';

  @override
  String savedTo(String path) {
    return '已保存到：$path';
  }

  @override
  String get shareArchiveText => 'GMH世界存档';

  @override
  String get shareJsonText => 'GMH世界数据（JSON）';

  @override
  String get sharePdfText => 'GMH世界之书（PDF）';

  @override
  String get relationsCaps => '关系';

  @override
  String get backlinksCaps => '反向链接';

  @override
  String get addRelation => '添加关系';

  @override
  String get openInGraph => '在图谱中打开';

  @override
  String get noOutgoingRelations => '还没有指向其他条目的关系。';

  @override
  String get noBacklinks => '还没有任何条目链接到这里。';

  @override
  String relationToTitle(String name) {
    return '与“$name”的关系';
  }

  @override
  String get roleLabel => '角色';

  @override
  String get roleHint => '例如：所有者、盟友、宿敌';

  @override
  String get fromDocumentMention => '来自文档中的提及';

  @override
  String get fromStructuredField => '来自结构化字段';

  @override
  String get roleMention => '提及于';

  @override
  String get roleRelated => '相关';

  @override
  String get roleOwner => '所有者';

  @override
  String get roleLocatedAt => '位于';

  @override
  String get roleMemberOf => '隶属于';

  @override
  String get rolePartOf => '组成部分';

  @override
  String get roleParticipatedIn => '参与了';

  @override
  String get roleCreatedAt => '创建于';

  @override
  String get roleQuestGiver => '任务发布者';

  @override
  String get roleAlly => '盟友';

  @override
  String get roleFriend => '朋友';

  @override
  String get roleFamily => '家人';

  @override
  String get roleEnemy => '敌人';

  @override
  String get roleRival => '宿敌';

  @override
  String get tabBiography => '生平';

  @override
  String get tabProfile => '档案';

  @override
  String get attachmentsCaps => '附件';

  @override
  String get addFiles => '添加文件';

  @override
  String get fromGallery => '从相册选择';

  @override
  String get noAttachments => '还没有附件。';

  @override
  String get dropFilesHere => '将文件拖放到此处即可附加';

  @override
  String get setAsCover => '设为封面图';

  @override
  String get newTab => '新建标签页';

  @override
  String get changeImage => '更换图片';

  @override
  String get addImage => '添加图片';

  @override
  String get editCaption => '编辑说明文字';

  @override
  String get captionLabel => '说明文字';

  @override
  String get replaceFile => '替换文件';

  @override
  String get deleteAttachment => '移除附件';

  @override
  String deleteAttachmentTitle(String name) {
    return '要移除“$name”吗？';
  }

  @override
  String get deleteAttachmentBody => '附件将从此条目中移除。当没有其他条目使用该文件时，它才会从库中删除。';

  @override
  String get renameAttachmentTitle => '重命名附件';

  @override
  String get previewUnavailable => '此文件类型无法预览，请用其他应用打开。';

  @override
  String get openExternally => '用其他应用打开';

  @override
  String attachmentsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已附加$count个文件',
      one: '已附加$count个文件',
    );
    return '$_temp0';
  }

  @override
  String get tagChip => '标签';

  @override
  String get addTagTitle => '添加标签';

  @override
  String get tagNameHint => '标签名称';

  @override
  String get none => '无';

  @override
  String get choose => '选择…';

  @override
  String addToList(String label) {
    return '添加到“$label”';
  }

  @override
  String get clear => '清除';

  @override
  String get pickerTitleDefault => '链接条目';

  @override
  String get pickerSearchAll => '搜索所有条目…';

  @override
  String pickerSearchKinds(String kinds) {
    return '搜索$kinds…';
  }

  @override
  String get pickerNoMatches => '没有匹配的条目';

  @override
  String get justNow => '刚刚';

  @override
  String minutesAgo(int count) {
    return '$count分钟前';
  }

  @override
  String hoursAgo(int count) {
    return '$count小时前';
  }

  @override
  String daysAgo(int count) {
    return '$count天前';
  }

  @override
  String get sectionCategories => '我的类别';

  @override
  String get manageCategories => '管理类别';

  @override
  String get newCategory => '新建类别';

  @override
  String get renameCategory => '编辑类别';

  @override
  String get deleteCategory => '删除类别';

  @override
  String deleteCategoryTitle(String name) {
    return '要删除类别“$name”吗？';
  }

  @override
  String deleteCategoryBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '其中的$count个条目将被保留并移入概念档案。',
      one: '其中的$count个条目将被保留并移入概念档案。',
    );
    return '$_temp0';
  }

  @override
  String get deleteCategoryBodyEmpty => '该类别为空；不会有其他改动。';

  @override
  String get categoryNameLabel => '类别名称';

  @override
  String get categoryNameHint => '例如：公会、王国、仪式…';

  @override
  String get chooseIcon => '图标';

  @override
  String get noCategoriesYet => '还没有自定义类别。在下方创建一个——它会像内置版块一样工作。';

  @override
  String get kindCustomEntry => '条目';

  @override
  String get tagManagerTitle => '标签管理器';

  @override
  String get searchTagsHint => '搜索标签…';

  @override
  String get sortByName => '按字母顺序';

  @override
  String get sortByCreated => '按创建时间';

  @override
  String get sortByUsage => '按使用次数';

  @override
  String get newTag => '新建标签';

  @override
  String get mergeTagAction => '合并到其他标签…';

  @override
  String mergeTagTitle(String name) {
    return '合并“$name”';
  }

  @override
  String mergeTagBody(String name) {
    return '所有带“$name”标签的条目将改用下方选择的标签，“$name”随后会被删除。';
  }

  @override
  String get changeColor => '更改颜色';

  @override
  String deleteTagTitle(String name) {
    return '要删除标签“$name”吗？';
  }

  @override
  String deleteTagBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '此标签将从$count个条目上移除，条目本身会保留。',
      one: '此标签将从$count个条目上移除，条目本身会保留。',
      zero: '没有条目使用此标签。',
    );
    return '$_temp0';
  }

  @override
  String get noTags => '还没有标签。你为条目添加的标签会显示在这里。';

  @override
  String get noTagMatches => '没有符合搜索条件的标签。';

  @override
  String get appearanceSection => '外观';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get navBack => '后退';

  @override
  String get navForward => '前进';

  @override
  String get kindCharacter => '角色';

  @override
  String get kindCharacterPlural => '角色';

  @override
  String get kindLocation => '地点';

  @override
  String get kindLocationPlural => '地点';

  @override
  String get kindItem => '物品';

  @override
  String get kindItemPlural => '物品';

  @override
  String get kindCreature => '生物';

  @override
  String get kindCreaturePlural => '生物';

  @override
  String get kindFaction => '势力';

  @override
  String get kindFactionPlural => '势力';

  @override
  String get kindEvent => '事件';

  @override
  String get kindEventPlural => '事件';

  @override
  String get kindEra => '纪元';

  @override
  String get kindEraPlural => '纪元';

  @override
  String get kindReligion => '宗教';

  @override
  String get kindReligionPlural => '宗教';

  @override
  String get kindMagicSystem => '魔法体系';

  @override
  String get kindMagicSystemPlural => '魔法体系';

  @override
  String get kindTechnology => '科技';

  @override
  String get kindTechnologyPlural => '科技';

  @override
  String get kindConcept => '概念';

  @override
  String get kindConceptPlural => '概念档案';

  @override
  String get kindLoreDocument => '传说文档';

  @override
  String get kindLoreDocumentPlural => '传说文档';

  @override
  String get kindCampaign => '战役';

  @override
  String get kindCampaignPlural => '战役';

  @override
  String get kindQuest => '任务';

  @override
  String get kindQuestPlural => '任务';

  @override
  String get kindSession => '跑团';

  @override
  String get kindSessionPlural => '跑团';

  @override
  String get close => '关闭';

  @override
  String get worldStyleLabel => '世界风格';

  @override
  String get viewAsGrid => '网格视图';

  @override
  String get viewAsList => '列表视图';

  @override
  String get blueprintFieldsSection => '字段';

  @override
  String get constructorTitleNew => '版块构建器';

  @override
  String get constructorTitleEdit => '版块设置';

  @override
  String get constructorModules => '模块';

  @override
  String get constructorModulesHint => '添加或移除此版块条目将拥有的构成模块。';

  @override
  String get moduleFields => '结构化字段';

  @override
  String get moduleFieldsHint => '由你在下方定义的字段组成的表单';

  @override
  String get moduleDocument => '文档';

  @override
  String get moduleDocumentHint => '支持链接和图片的富文本编辑器';

  @override
  String get moduleGallery => '图库';

  @override
  String get moduleGalleryHint => '每个条目上的图片网格';

  @override
  String get moduleAttachments => '文件';

  @override
  String get moduleAttachmentsHint => '任意类型的附件文件';

  @override
  String get moduleTags => '标签';

  @override
  String get moduleTagsHint => '标签与标签筛选';

  @override
  String get moduleRelations => '关系';

  @override
  String get moduleRelationsHint => '指向其他条目的链接与反向链接';

  @override
  String get constructorFields => '自定义字段';

  @override
  String get constructorFieldsEmpty => '还没有字段——添加此版块需要的字段，例如“等级”“学派”“价格”。';

  @override
  String get addField => '添加字段';

  @override
  String get editField => '编辑字段';

  @override
  String get fieldNameLabel => '字段名称';

  @override
  String get fieldTypeLabel => '字段类型';

  @override
  String get fieldOptionsLabel => '选项（以逗号分隔）';

  @override
  String get fieldOptionsHint => '例如：普通、稀有、传说';

  @override
  String get fieldTypeText => '文本';

  @override
  String get fieldTypeLongText => '长文本';

  @override
  String get fieldTypeNumber => '数字';

  @override
  String get fieldTypeSelect => '选项列表';

  @override
  String get fieldTypeDate => '日期';

  @override
  String get fieldTypeChecklist => '清单';

  @override
  String get fieldTypeStringList => '值列表';

  @override
  String get pauseSaveProject => '保存项目';

  @override
  String get pauseExit => '退出';

  @override
  String get helpTitle => '使用指南';

  @override
  String get helpSettingsSubtitle => '内置手册：功能都在哪里、该怎么用';

  @override
  String get helpIntroBody =>
      'Game Master\'s Hub是为游戏主持人打造的离线工作台：世界、角色、地点、战役和传说全部保存在本设备上，并连接成一张可以自由漫游的网络。本指南将带你走遍应用的每个部分——下方的示意图是真实界面的简化呈现，图中带编号的标记会在每张图下方逐一说明。';

  @override
  String get helpWorldsTitle => '世界与世界风格';

  @override
  String get helpWorldsBody =>
      '一切从世界开始——它是完全独立的项目，拥有自己的条目、标签和战役。世界选择器在启动时打开；侧边栏的地球图标随时能带你回到那里。创建世界时可以选择风格：奇幻（羊皮纸与经典术语——角色、地点、任务）或赛博朋克（霓虹配色与街头黑话——狂奔者、区块、委托）。风格会改变该世界的整体外观和用语，每个世界可以各不相同。每个世界都会记住你上次停留的位置，并在下次打开时精确回到那里。';

  @override
  String get helpShellTitle => '导航与侧边栏';

  @override
  String get helpShellBody =>
      '左侧边栏是你的控制中心。它列出了主要页面、带实时条目计数的“世界”和“资料库”版块，以及你的自定义类别。长按并拖动任意标签即可调整分组内的顺序——顺序会按世界分别保存。在平板上侧边栏会收起为窄栏，在手机上则变为底部导航栏。';

  @override
  String get helpShellLegend1 => '世界切换器——点击顶部标题即可返回世界选择页。';

  @override
  String get helpShellLegend2 =>
      '后退／前进——像浏览器一样记录你访问过的一切。Alt+← / Alt+→在任何地方都有效。';

  @override
  String get helpShellLegend3 => '带实时计数的版块标签。长按后拖动即可调整顺序；顺序会被保存。';

  @override
  String get helpShellLegend4 => '列表控制——当前版块的筛选框、网格／列表切换、排序菜单和收藏筛选。';

  @override
  String get helpShellLegend5 => '条目卡片显示摘要和上下文信息标签：状态、种族、稀有度、日期——因版块而异。';

  @override
  String get helpShellLegend6 => '新建条目——在当前查看的版块中创建条目。';

  @override
  String get helpEntryTitle => '条目：文档、字段与附件';

  @override
  String get helpEntryBody =>
      '每个条目都是一个页面，包含富文本文档和结构化侧栏。文档编辑器支持标题、列表、引用、直接粘贴或拖入正文的图片、文件附件以及版本历史（工具栏上的时钟图标）。输入@或点击提及按钮即可在文中链接另一个条目——链接是双向的，并会汇入图谱。侧栏则包含该条目类型的模板字段、标签、带反向链接的关系以及图库。';

  @override
  String get helpEntryLegend1 => '名称——点击即可重命名；星标用于切换收藏。';

  @override
  String get helpEntryLegend2 => '编辑器工具栏：格式、对齐、@提及、插入图片、附加文件、版本历史。';

  @override
  String get helpEntryLegend3 => '文中对另一条目的提及——点击即可跳转，同时会创建反向链接。';

  @override
  String get helpEntryLegend4 => '由条目类型（或你的版块构建器）定义的结构化字段。';

  @override
  String get helpEntryLegend5 => '图库与文件附件——把文件拖放到页面任意位置即可附加。';

  @override
  String get helpProfileTitle => '角色档案';

  @override
  String get helpProfileBody =>
      '角色会以完整的分页档案打开：基本信息、生平、带D&D风格属性表格与衍生调整值的属性页、信念、人际关系（盟友、敌人、势力——全都是真实链接）、物品栏、能力与魔法、时间线和笔记。头像取自条目的封面图——在图库图片的长按菜单中可将任意图片设为封面。你填写的每一条关系都会出现在图谱中，并在目标条目上显示为反向链接。';

  @override
  String get helpCampaignsTitle => '战役、任务与跑团';

  @override
  String get helpCampaignsBody =>
      '“战役”页面是你的游戏桌仪表盘。在右上角的下拉菜单中选择当前战役——选择会按世界分别记住。任务板按状态分组显示所有“战役”字段指向所选战役的任务；跑团日志以同样的方式汇集跑团条目。任务和跑团可以直接在此页面创建——战役关联会自动填好。';

  @override
  String get helpSearchTitle => '搜索与标签';

  @override
  String get helpSearchBody =>
      '搜索（侧边栏中的放大镜）是覆盖名称、摘要、文档和标签的即时全文搜索。筛选标签可以把结果收窄到某个版块或类别。标签在标签管理器中管理——可从侧边栏或搜索页快捷操作进入——那里可以重命名、改色、合并重复标签并删除标签，同时显示实时使用次数。每个列表页面也都能按标签和收藏筛选。';

  @override
  String get helpGraphTitle => '关系图谱';

  @override
  String get helpGraphBody =>
      '图谱把你的世界呈现为一张活的网络：每一次提及、每一条关系和每个结构化引用都会成为一条边。颜色对应条目类型，节点大小对应连接数量。点击节点即可打开对应条目，也可以在任意条目上使用“在图谱中显示”查看它的局部邻域。工具栏中的类型筛选可以隐藏当前不需要的类别。';

  @override
  String get helpConstructorTitle => '自定义版块与构建器';

  @override
  String get helpConstructorBody =>
      '除了内置版块，你还可以创建自己的版块——公会、法术、配方，什么都行。自定义版块的行为与内置版块完全一致：带计数的侧边栏标签、总览磁贴、搜索筛选、图谱配色和PDF章节。版块构建器决定其条目的样子：开关各个模块，并定义七种类型的自定义字段。删除类别绝不会删除条目——它们会移入概念档案。';

  @override
  String get helpConstructorLegend1 => '模块——条目页面的构成模块。停用的模块会完全消失。';

  @override
  String get helpConstructorLegend2 =>
      '自定义字段类型：文本、长文本、数字、选项列表、日期、清单、值列表。拖动即可排序。';

  @override
  String get helpConstructorLegend3 => '添加字段——最前面的几个字段还会成为版块卡片上的信息标签。';

  @override
  String get helpBackupTitle => '备份与设备间迁移';

  @override
  String get helpBackupBody =>
      '一切都存储在本地——无需账号，也没有云端。应用每天自动备份一次；你也可以随时在设置中手动备份。要迁移或分享世界，请导出.gmhw存档：一个包含数据库和全部媒体的文件。在另一台设备上导入即可原样恢复世界，包括自定义版块和风格。设置中还提供JSON导出和可打印的PDF世界之书。';

  @override
  String get helpTipsTitle => '技巧与快捷键';

  @override
  String get helpTipsBody =>
      'Alt+← / Alt+→——前后导航。在编辑器中输入@即可边写边链接条目。长按侧边栏标签、构建器字段或图库磁贴即可拖动排序。右键（或长按）附件可进行重命名、替换和设为封面等操作。每个版块的网格／列表切换都会分别记住。排序、筛选和所选战役同样会被记住——应用总会回到你上次离开的地方。Ctrl+K 可直接打开搜索；鼠标侧键可前进后退，导航箭头位于每页左上角。';

  @override
  String get helpScreenshotCaption => '应用截图（英文界面）';

  @override
  String get helpFigureCaption => '真实界面的示意图';

  @override
  String get editWorldTitle => '编辑世界';

  @override
  String get worldActions => '世界操作';

  @override
  String deleteWorldTitle(String name) {
    return '删除“$name”？';
  }

  @override
  String get deleteWorldBody => '此世界中的所有条目、文档、图片和战役都将被永久删除。已有的备份文件会保留。';

  @override
  String get worldSection => '世界';

  @override
  String get navTools => '工具';

  @override
  String get sectionTools => '跑团工具';

  @override
  String get toolDice => '掷骰';

  @override
  String get toolDiceHint => '支持任意记法——4d6kh3、2d20kl1、3d6!、dF——含预设与掷骰记录。';

  @override
  String get toolCombat => '战斗追踪';

  @override
  String get toolCombatHint => '先攻顺序、生命值、状态与回合；遭遇难度计算。';

  @override
  String get toolTables => '随机表';

  @override
  String get toolTablesHint => '自定义掷骰表，支持权重、骰值区间与嵌套掷骰。';

  @override
  String get toolGenerators => '生成器';

  @override
  String get toolGeneratorsHint => '姓名、NPC、酒馆、战利品、天气、传闻——贴合你的设定。';

  @override
  String get toolMaps => '地图';

  @override
  String get toolMapsHint => '带有条目标记的交互式地图，支持嵌套地图。';

  @override
  String get toolTimeline => '时间线';

  @override
  String get toolTimelineHint => '按时间顺序排列的世界事件与纪元。';

  @override
  String get toolReference => '主持人屏风';

  @override
  String get toolReferenceHint => '状态与速查规则一目了然（SRD 5.2.1）。';

  @override
  String importReplaceTitle(String name) {
    return '替换“$name”？';
  }

  @override
  String get importReplaceBody => '此存档中的世界在这里已经存在。导入将完全替换它的当前版本。';

  @override
  String get importReplaceAction => '替换';

  @override
  String get searchIndexFailed => '世界已恢复，但搜索索引重建失败。请重启应用重试。';

  @override
  String get fieldNotANumber => '请输入数字';

  @override
  String get pdfBookSubtitle => '世界之书';

  @override
  String get pdfIncludeGmOnly => '包含主持人机密';

  @override
  String get pdfIncludeGmOnlyHint => '关闭：不含仅限主持人字段的玩家安全版本。';

  @override
  String get exportAction => '导出';

  @override
  String get tagNameTaken => '已存在同名标签——请改用合并。';

  @override
  String get errorEntryGone => '该条目已不存在。';

  @override
  String get errorNotFound => '未找到——可能已被删除。';

  @override
  String get errorStorage => '无法读取或写入文件。请检查磁盘空间和文件夹权限。';

  @override
  String get errorDatabase => '数据库无法完成此操作。你的数据未被更改。';

  @override
  String get errorArchiveMissing => '未找到归档文件。';

  @override
  String get errorArchiveInvalid => '该文件不是有效的 GMH 世界归档。';

  @override
  String get errorExport => '导出失败。请检查磁盘空间以及目标文件夹是否可写。';

  @override
  String get errorAiNotConfigured => '尚未配置 AI 服务。';

  @override
  String get diceExpressionLabel => '骰子表达式';

  @override
  String get diceExpressionHint => '例如 2d6+3、4d6kh3、1d20!';

  @override
  String get diceRollAction => '掷骰';

  @override
  String get diceLabelHint => '标签（可选）';

  @override
  String get diceAdvantage => '优势';

  @override
  String get diceDisadvantage => '劣势';

  @override
  String get diceModifier => '修正值';

  @override
  String get diceDecrease => '减少';

  @override
  String get diceIncrease => '增加';

  @override
  String get diceQuickHint => '点按骰子即可掷出，长按可将其加入表达式。';

  @override
  String get dicePresets => '系统预设';

  @override
  String get diceHistory => '掷骰记录';

  @override
  String get diceHistoryEmpty => '还没有掷骰。每次掷骰都会记录在这里。';

  @override
  String get diceClearHistory => '清空记录';

  @override
  String get diceClearHistoryTitle => '清空掷骰记录？';

  @override
  String get diceClearHistoryBody => '此世界中记录的所有掷骰都将被删除。';

  @override
  String get diceReroll => '再掷一次';

  @override
  String get diceCopy => '复制';

  @override
  String get diceCopied => '已复制到剪贴板';

  @override
  String get diceResultEmpty => '选择一个骰子或输入表达式';

  @override
  String get diceDropped => '已舍弃';

  @override
  String get diceExploded => '爆骰';

  @override
  String get diceRerolled => '已重掷';

  @override
  String diceMoreDice(int count) {
    return '还有 $count 个';
  }

  @override
  String get diceErrorEmpty => '请输入骰子表达式';

  @override
  String get diceErrorTooLong => '表达式过长';

  @override
  String get diceErrorUnexpectedChar => '意外的字符';

  @override
  String get diceErrorUnexpectedEnd => '表达式不完整';

  @override
  String get diceErrorExpectedNumber => '此处需要数字';

  @override
  String get diceErrorParen => '括号不匹配';

  @override
  String get diceErrorTooManyDice => '每项最多 1000 个骰子';

  @override
  String get diceErrorBadSides => '骰子面数须在 1 到 10000 之间';

  @override
  String get diceErrorTooLarge => '数字过大';

  @override
  String get diceErrorDivisionByZero => '除数为零';

  @override
  String get diceErrorDuplicate => '修饰符重复';

  @override
  String get diceErrorImpossibleReroll => '这种重掷永远不会停止';

  @override
  String get diceErrorLabel => '请用 ] 结束标签';

  @override
  String diceErrorAt(String message, int position) {
    return '$message（位置 $position）';
  }

  @override
  String get dicePresetD20 => 'd20 检定';

  @override
  String get dicePresetAbility => '属性值';

  @override
  String get dicePresetCoc => '克苏鲁的呼唤';

  @override
  String get dicePresetPbta => 'PbtA 行动';

  @override
  String get dicePresetBlades => '暗夜刀锋';

  @override
  String get dicePresetFate => 'Fate';

  @override
  String get dicePresetYearZero => 'Year Zero';

  @override
  String get dicePresetSavage => '野蛮世界';

  @override
  String get dicePresetCyberpunk => 'Cyberpunk RED';

  @override
  String get diceModeNormal => '普通';

  @override
  String get diceDc => 'DC（可选）';

  @override
  String get diceSkill => '技能';

  @override
  String get diceBonusDice => '奖励骰（+）/ 惩罚骰（−）';

  @override
  String get diceStat => '属性';

  @override
  String get diceDicePool => '骰池';

  @override
  String get diceTraitDie => '特质骰';

  @override
  String get diceWildDie => '狂野骰';

  @override
  String get diceStatSkill => '属性 + 技能';

  @override
  String get diceOutcomeCriticalSuccess => '大成功';

  @override
  String get diceOutcomeCriticalFailure => '严重失败';

  @override
  String get diceOutcomeSuccess => '成功';

  @override
  String get diceOutcomeFailure => '失败';

  @override
  String get diceOutcomeRaise => '成功并获得加码';

  @override
  String get diceOutcomeExtreme => '极难成功';

  @override
  String get diceOutcomeHard => '困难成功';

  @override
  String get diceOutcomeRegular => '常规成功';

  @override
  String get diceOutcomeFumble => '大失败';

  @override
  String get diceOutcomeMiss => '失手';

  @override
  String get diceOutcomePartial => '部分成功';

  @override
  String get diceOutcomeFull => '完全成功';

  @override
  String get diceFateTerrible => '糟糕';

  @override
  String get diceFatePoor => '差劲';

  @override
  String get diceFateMediocre => '平庸';

  @override
  String get diceFateAverage => '一般';

  @override
  String get diceFateFair => '尚可';

  @override
  String get diceFateGood => '良好';

  @override
  String get diceFateGreat => '优秀';

  @override
  String get diceFateSuperb => '极佳';

  @override
  String get diceFateFantastic => '惊人';

  @override
  String get diceFateEpic => '史诗';

  @override
  String get diceFateLegendary => '传奇';

  @override
  String diceSuccesses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 次成功',
      zero: '没有成功',
    );
    return '$_temp0';
  }

  @override
  String diceRollTooltip(String expression) {
    return '掷 $expression';
  }

  @override
  String diceRolledSnack(String expression, int total) {
    return '$expression：$total';
  }

  @override
  String get diceQuickRollTitle => '快速掷骰';

  @override
  String get combatNewEncounter => '新遭遇';

  @override
  String combatEncounterDefaultName(int number) {
    return '遭遇 $number';
  }

  @override
  String get combatEncounterNameLabel => '遭遇名称';

  @override
  String get combatEmptyTitle => '还没有遭遇';

  @override
  String get combatEmptyHint => '规划一场战斗：加入怪物和英雄，检查难度，然后逐轮进行。';

  @override
  String get combatRenameTitle => '重命名遭遇';

  @override
  String get combatDuplicate => '复制';

  @override
  String combatCopyName(String name) {
    return '$name（副本）';
  }

  @override
  String combatDeleteTitle(String name) {
    return '删除“$name”？';
  }

  @override
  String get combatDeleteBody => '该遭遇及其所有参战者将被永久删除。';

  @override
  String get combatStatusPlanning => '筹备中';

  @override
  String get combatStatusActive => '战斗中';

  @override
  String get combatStatusFinished => '已结束';

  @override
  String combatRound(int round) {
    return '第 $round 轮';
  }

  @override
  String combatCombatantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 名参战者',
      zero: '没有参战者',
    );
    return '$_temp0';
  }

  @override
  String get combatNotFound => '该遭遇已不存在。';

  @override
  String get combatAllEncounters => '全部遭遇';

  @override
  String get combatStart => '开始战斗';

  @override
  String get combatEnd => '结束战斗';

  @override
  String get combatNextTurn => '下一回合';

  @override
  String get combatPreviousTurn => '上一回合';

  @override
  String get combatRollInitiative => '投先攻';

  @override
  String get combatRollInitiativeHint => '为每个怪物投 d20 + 加值；玩家保留自己的数值。';

  @override
  String combatTurnOf(String name) {
    return '当前：$name';
  }

  @override
  String get combatNotStarted => '战斗尚未开始';

  @override
  String get combatAddFromWorld => '从世界添加';

  @override
  String get combatAddManually => '手动添加';

  @override
  String get combatPickTitle => '添加生物或角色';

  @override
  String combatQuantityTitle(String name) {
    return '添加多少个“$name”？';
  }

  @override
  String get combatNoCombatants => '还没有参战者';

  @override
  String get combatNoCombatantsHint => '从你的世界添加生物和角色，或手动输入。';

  @override
  String get combatInitiative => '先攻';

  @override
  String get combatInitiativeBonus => '先攻加值';

  @override
  String get combatArmorClass => '护甲等级';

  @override
  String get combatAcShort => 'AC';

  @override
  String get combatHpMax => '最大生命';

  @override
  String get combatHpCurrent => '当前生命';

  @override
  String get combatHpTemp => '临时生命';

  @override
  String get combatAmountHint => '生命';

  @override
  String get combatDamage => '伤害';

  @override
  String get combatHeal => '治疗';

  @override
  String get combatTemp => '临时';

  @override
  String get combatAddCondition => '状态';

  @override
  String combatConditionDurationTitle(String condition) {
    return '持续时间：$condition';
  }

  @override
  String get combatConditionRounds => '轮数（留空 = 直到移除）';

  @override
  String get combatRemoveCondition => '移除状态';

  @override
  String get combatConcentration => '专注';

  @override
  String get combatDefeated => '已击败';

  @override
  String get combatPlayer => '玩家角色';

  @override
  String get combatEdit => '编辑';

  @override
  String get combatRemove => '移除';

  @override
  String get combatEditCombatant => '编辑参战者';

  @override
  String get combatAddCombatant => '添加参战者';

  @override
  String get combatChallenge => '挑战等级';

  @override
  String get combatXp => '经验值';

  @override
  String get combatQuantity => '数量';

  @override
  String get combatNotes => '笔记';

  @override
  String get combatNotesHint => '战术、地形、战利品……';

  @override
  String get combatDifficulty => '难度';

  @override
  String get combatRules => '规则';

  @override
  String get combatPartyLevels => '队伍等级';

  @override
  String get combatAddLevel => '等级';

  @override
  String combatLevelChip(int level) {
    return '$level 级';
  }

  @override
  String get combatLevelLabel => '角色等级（1–20）';

  @override
  String combatMonsterXp(String xp) {
    return '怪物经验值：$xp';
  }

  @override
  String combatAdjustedXp(String xp, String multiplier) {
    return '调整后经验值：$xp（×$multiplier）';
  }

  @override
  String get combatNoParty => '添加队伍等级以评估此遭遇。';

  @override
  String get combatRatingTrivial => '微不足道';

  @override
  String get combatRatingLow => '低';

  @override
  String get combatRatingModerate => '中等';

  @override
  String get combatRatingHigh => '高';

  @override
  String get combatRatingBeyondHigh => '超高';

  @override
  String get combatRatingEasy => '简单';

  @override
  String get combatRatingMedium => '中等';

  @override
  String get combatRatingHard => '困难';

  @override
  String get combatRatingDeadly => '致命';

  @override
  String combatConcentrationCheck(String name, int dc) {
    return '$name：专注豁免 DC $dc';
  }

  @override
  String combatDefeatedNotice(String name) {
    return '$name 已被击败';
  }

  @override
  String get combatOpenEntry => '打开条目';

  @override
  String get combatActions => '参战者操作';

  @override
  String get combatEncounterActions => '遭遇操作';

  @override
  String get roleCustomLabel => '或输入自定义关系';

  @override
  String importFilesFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个文件无法导入',
    );
    return '$_temp0';
  }

  @override
  String get trashTitle => '回收站';

  @override
  String get trashEmptyState => '回收站为空。删除的条目会保留在这里，直到你恢复或永久删除它们。';

  @override
  String get trashEmptyAction => '清空回收站';

  @override
  String get trashEmptyConfirmTitle => '清空回收站？';

  @override
  String trashEmptyConfirmBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个条目将被永久删除，包括其正文、图片和关联。',
    );
    return '$_temp0';
  }

  @override
  String get trashDeleteForever => '永久删除';

  @override
  String trashDeleteForeverTitle(String name) {
    return '永久删除“$name”？';
  }

  @override
  String get trashDeleteForeverBody => '其正文、图片和关联也将被删除。此操作无法撤销。';

  @override
  String trashDeletedOn(String date) {
    return '删除于 $date';
  }

  @override
  String trashMovedSnack(String name) {
    return '“$name”已移至回收站';
  }

  @override
  String trashRestoredSnack(String name) {
    return '“$name”已恢复';
  }

  @override
  String get undo => '撤销';

  @override
  String get tabDuplicate => '复制标签页';

  @override
  String get tabClose => '关闭标签页';

  @override
  String get tabCloseOthers => '关闭其他标签页';

  @override
  String get tabCloseRight => '关闭右侧标签页';

  @override
  String get exportMarkdownTitle => 'Markdown 笔记（Obsidian）';

  @override
  String get exportMarkdownSubtitle =>
      '包含图片的互链笔记文件夹压缩包——可作为 Obsidian 库或在任意编辑器中打开。';

  @override
  String get shareMarkdownText => 'GMH 世界笔记（Markdown）';

  @override
  String get relationsTitle => '关联';

  @override
  String kindFieldsTitle(String kind) {
    return '自定义字段：$kind';
  }

  @override
  String get kindFieldsHint => '此处添加的字段会显示在本世界中该类型的每个条目上，位于内置字段之后。';

  @override
  String get kindFieldsAction => '自定义字段';

  @override
  String get tablesSearchHint => '搜索随机表';

  @override
  String get tablesNewTable => '新建表';

  @override
  String get tablesImport => '从文本导入';

  @override
  String get tablesLibrary => '表库';

  @override
  String get tablesOpenLibrary => '打开表库';

  @override
  String get tablesEmptyTitle => '还没有随机表';

  @override
  String get tablesEmptyHint => '可以从表库里的现成表开始，也可以自己编写，或粘贴书中的列表。';

  @override
  String get tablesNoMatches => '没有匹配的表。';

  @override
  String get tablesNoFolder => '其他表';

  @override
  String tablesRowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 行',
    );
    return '$_temp0';
  }

  @override
  String get tablesWeighted => '按权重';

  @override
  String tablesDefaultName(int number) {
    return '表 $number';
  }

  @override
  String get tablesDescriptionLabel => '描述';

  @override
  String get tablesFolderLabel => '分组';

  @override
  String get tablesFolderHint => '例如：遭遇';

  @override
  String get tablesFormulaLabel => '骰子公式';

  @override
  String get tablesFormulaHint => '例如 1d20；留空则按权重';

  @override
  String get tablesFormulaInvalid => '不是有效的骰子公式';

  @override
  String get tablesEditTitle => '编辑表';

  @override
  String get tablesEdit => '编辑信息';

  @override
  String get tablesDuplicate => '复制表';

  @override
  String tablesCopyName(String name) {
    return '$name（副本）';
  }

  @override
  String tablesDeleteTitle(String name) {
    return '删除“$name”？';
  }

  @override
  String get tablesDeleteBody => '该表及其所有行将从这个世界中移除。';

  @override
  String get tablesActions => '表操作';

  @override
  String get tablesAllTables => '全部表';

  @override
  String get tablesMissing => '这个表已不存在。';

  @override
  String get tablesRoll => '掷骰';

  @override
  String get tablesRollAgain => '再掷一次';

  @override
  String get tablesCopy => '复制';

  @override
  String get tablesCopied => '已复制到剪贴板';

  @override
  String get tablesResultEmpty => '掷骰即可得到结果。';

  @override
  String get tablesClamped => '超出所有区间——已取最近一行';

  @override
  String get tablesRollLog => '掷骰记录';

  @override
  String get tablesRollLogEmpty => '本页的掷骰结果会显示在这里。';

  @override
  String get tablesClearLog => '清空记录';

  @override
  String get tablesRows => '行';

  @override
  String get tablesAddRow => '添加行';

  @override
  String get tablesDeleteRow => '删除行';

  @override
  String get tablesAutoRanges => '自动区间';

  @override
  String get tablesAutoRangesHint => '按权重把各行分配到公式的点数上';

  @override
  String get tablesBulkEdit => '以文本编辑';

  @override
  String get tablesBulkEditTitle => '以文本编辑各行';

  @override
  String get tablesTextFormatHelp =>
      '每行一条：“1-3 | 文本”、“4: 文本”、“x3 文本”（权重）或纯文本。以 # 开头的行会被忽略。';

  @override
  String get tablesImportTitle => '从文本导入表';

  @override
  String get tablesImportRows => '行';

  @override
  String tablesImportFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '找到 $count 行',
    );
    return '$_temp0';
  }

  @override
  String get tablesImportAction => '导入';

  @override
  String get tablesApply => '应用';

  @override
  String get tablesRowsEmpty => '还没有行。添加一行，或用“以文本编辑”粘贴整份列表。';

  @override
  String tablesRowTextHint(String dice, String choice, String table) {
    return '文本、骰子 $dice、选项 $choice、嵌套 $table';
  }

  @override
  String get tablesFrom => '起';

  @override
  String get tablesTo => '止';

  @override
  String get tablesWeight => '权重';

  @override
  String get tablesDragToReorder => '拖动以排序';

  @override
  String get tablesIssueBadFormula => '骰子公式无法掷出。';

  @override
  String get tablesIssueEmpty => '表中没有带文本的行。';

  @override
  String tablesIssueEmptyRow(int row) {
    return '第 $row 行没有文本。';
  }

  @override
  String tablesIssueMissingRange(int row) {
    return '第 $row 行没有区间。';
  }

  @override
  String tablesIssueInverted(int row) {
    return '第 $row 行：区间首尾颠倒。';
  }

  @override
  String tablesIssueOutOfBounds(int row, String range) {
    return '第 $row 行超出了公式能掷出的范围（$range）。';
  }

  @override
  String tablesIssueGap(String range) {
    return '$range 没有对应的行。';
  }

  @override
  String tablesIssueOverlap(int first, int second, String range) {
    return '第 $first 行和第 $second 行在 $range 上重叠。';
  }

  @override
  String get tablesFailNotFound => '没有这个名字的表';

  @override
  String get tablesFailCycle => '循环引用——已停止';

  @override
  String get tablesFailDepth => '嵌套过深——已停止';

  @override
  String get tablesFailTooMany => '嵌套掷骰过多——已停止';

  @override
  String get tablesFailEmpty => '该表没有行';

  @override
  String get tablesFailBadFormula => '公式无法掷出';

  @override
  String tablesChoice(int count) {
    return '$count 选 1';
  }

  @override
  String get tablesFromLibrary => '来自表库';

  @override
  String get tablesLibraryTitle => '随机表库';

  @override
  String get tablesLibraryHint => '适用于各种设定的现成随机表。先预览，再添加到这个世界中编辑。';

  @override
  String get tablesYourSetting => '本世界的设定';

  @override
  String get tablesOtherSettings => '其他设定';

  @override
  String tablesTableCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个表',
    );
    return '$_temp0';
  }

  @override
  String get tablesPreview => '预览';

  @override
  String get tablesAddToWorld => '添加到世界';

  @override
  String get tablesInWorld => '已在世界中';

  @override
  String get tablesAddDepsTitle => '同时添加被引用的表吗？';

  @override
  String tablesAddDepsBody(String name) {
    return '“$name”会在这些表上掷骰。缺少它们时，结果中会出现警告标记。';
  }

  @override
  String tablesAddedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已添加 $count 个表',
    );
    return '$_temp0';
  }

  @override
  String get tablesPreviewRoll => '试掷一次';

  @override
  String get tablesWhy => '掷骰过程';

  @override
  String get paletteHint => '跳转到条目、分区或工具，或执行命令……';

  @override
  String get paletteCommands => '命令';

  @override
  String get paletteEntries => '条目';

  @override
  String get paletteNoMatches => '无匹配结果';

  @override
  String get paletteToggleTheme => '切换浅色 / 深色主题';

  @override
  String paletteOpenInTab(String name) {
    return '前往 $name';
  }

  @override
  String get paletteTitle => '命令面板';

  @override
  String get homeAtTheTable => '游戏桌边';

  @override
  String get homeYourSections => '自定义分区';

  @override
  String get menuDuplicateEntry => '复制';

  @override
  String entryCopyName(String name) {
    return '$name（副本）';
  }

  @override
  String get helpPacksTitle => '设定与风格';

  @override
  String get helpPacksBody =>
      '每个世界都有一个设定：奇幻、赛博朋克、太空歌剧、哥特或宇宙恐怖、后启示录、蒸汽朋克、都市奇幻、西部或武侠。设定会为整个应用重新配色（浅色和深色），用自己的词汇重新命名分区——赛博朋克里是“行者”和“街区”，太空歌剧里是“船员”和“航点”——并选择契合该类型的随机表和生成器。可随时在“设置 → 世界”中更改；数据不会变，只会改变呈现方式。';

  @override
  String get helpToolsTitle => '游戏桌边：主持人工具';

  @override
  String get helpToolsBody =>
      '工具位于侧边栏、仪表盘和命令面板中。掷骰器：输入任意记法（4d6kh3、2d20kl1+5、8d6!、5d10>=8），或使用系统预设——D&D 检定、克苏鲁的呼唤、PbtA、暗夜刀锋、Fate、Year Zero、野蛮世界、赛博朋克 RED；每次掷骰都会记录，属性块里写的骰子可以直接点击。战斗追踪：用你的生物和角色组建遭遇（生命值、护甲等级和挑战等级取自字段），掷先攻、结算伤害与治疗、追踪带持续时间的状态，并查看遭遇难度。随机表：用骰子区间或权重编写自己的表，用 [[表名]] 嵌套表，或从资料库添加适合你设定的现成表。生成器：为你的设定即时生成 NPC、名字、聚居地、酒馆、剧情钩子、势力、战利品和传闻——留下满意的，一键存入世界。地图：上传地图图片，放置与条目关联的图钉，按比例尺测量距离，并可切换到玩家视图以隐藏仅主持人可见的图钉。时间线：按世界内日期排列你的纪元与事件，支持自定义历法。主持人屏：当前战斗、固定条目、场次笔记、快速掷骰与随机表以及规则速查，集中在一页。';

  @override
  String get helpNavTitle => '快速导航';

  @override
  String get helpNavBody =>
      'Ctrl+P 打开命令面板：输入名称的一部分即可跳转到条目、分区或工具，或执行命令（新建条目、浅色/深色主题、切换世界）。Ctrl+K 打开搜索。页面在类似浏览器的标签页中打开：Ctrl+T 新建标签页，Ctrl+W 关闭，Ctrl+Tab 切换；右键点击标签页可复制或关闭其他标签页，中键点击可关闭。Alt+← / Alt+→ 和鼠标侧键可浏览每个标签页各自的历史。Esc 打开暂停菜单（保存、设置、退出）。';

  @override
  String get helpFieldsTitle => '自定义字段';

  @override
  String get helpFieldsBody =>
      '内置分区可以添加适合你游戏的额外字段：打开一个分区（角色、地点……），点击工具栏中的“自定义字段”。可添加文本、数字、日期、列表、清单或选项；它们会出现在本世界该分区每个条目的内置字段之后，并包含在搜索、PDF 书和 Markdown 导出中。自定义分区在分区构建器中定义全部字段。';

  @override
  String get helpTrashTitle => '回收站、副本与导出';

  @override
  String get helpTrashBody =>
      '删除的条目会移入回收站（侧边栏或“设置 → 世界”）——删除后也可以立即点击“撤销”。之后可以恢复，或永久删除。条目菜单中的“复制”会连同字段、标签、图片和正文一起复制。“设置 → 导出”可生成完整归档（.gmhw，用于备份和跨设备迁移）、JSON、可打印的 PDF 世界书，或可作为 Obsidian 库打开且 [[链接]] 可用的 Markdown 笔记；仅主持人可见的字段默认不导出，除非你选择包含。';

  @override
  String get newSessionAction => '新场次';

  @override
  String sessionNumberName(int number) {
    return '第 $number 场';
  }

  @override
  String get timelineEmptyTitle => '还没有历史';

  @override
  String get timelineEmptyHint => '带有世界内日期的纪元和事件会按顺序显示在这里。添加一个事件，或为已有条目设置日期。';

  @override
  String get timelineNewEvent => '新事件';

  @override
  String get timelineEventName => '事件名称';

  @override
  String get timelineDateLabel => '世界内日期';

  @override
  String get timelineDateHint => '例如：1492、1492-03-12、年412、公元前300';

  @override
  String get timelineDateUnreadable => '未识别到年份——该事件将列为“无日期”。';

  @override
  String get timelineUndated => '无日期';

  @override
  String get timelineUndatedHint => '为它们设置日期即可放入时间线。';

  @override
  String get timelineSetDate => '设置日期';

  @override
  String get timelineOutsideEras => '不属于任何纪元';

  @override
  String timelineEraSpan(String start, String end) {
    return '$start – $end';
  }

  @override
  String get timelineOngoing => '至今';

  @override
  String get timelineCalendar => '历法';

  @override
  String get timelineCalendarHint => '每行一个月份，可附天数：“霜月：30”。留空则使用常规历法。';

  @override
  String get timelineMonths => '月份';

  @override
  String get timelineYearSuffix => '年份后缀（例如 DR）';

  @override
  String timelineEventsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个事件',
    );
    return '$_temp0';
  }

  @override
  String get gmScreenPinned => '固定的条目';

  @override
  String get gmScreenPinHint => '把今晚场次的 NPC、地点和物品放在触手可及之处。';

  @override
  String get gmScreenAddPin => '固定条目';

  @override
  String get gmScreenUnpin => '取消固定';

  @override
  String get gmScreenNotes => '场次笔记';

  @override
  String get gmScreenNotesHint => '即兴起的名字、未了的线索、谁欠谁……';

  @override
  String get gmScreenDice => '快速掷骰';

  @override
  String get gmScreenRoll => '掷骰';

  @override
  String get gmScreenTables => '快速随机表';

  @override
  String get gmScreenAddTable => '固定随机表';

  @override
  String get gmScreenNoTables => '本世界还没有随机表——在“随机表”中新建，或从资料库添加。';

  @override
  String get gmScreenEncounter => '当前战斗';

  @override
  String get gmScreenNoFight => '当前没有进行中的战斗。';

  @override
  String get gmScreenOpenTracker => '打开追踪器';

  @override
  String gmScreenRound(int round) {
    return '第 $round 轮';
  }

  @override
  String get gmScreenConditions => '状态';

  @override
  String get gmScreenRules => '难度与掩护';

  @override
  String get gmScreenDifficulty => '难度等级';

  @override
  String get gmScreenCover => '掩护';

  @override
  String get gmScreenPanels => '面板';

  @override
  String get gmScreenAttribution => '规则摘要基于 SRD 5.2.1（CC BY 4.0）';

  @override
  String get mapsEmptyTitle => '还没有地图';

  @override
  String get mapsEmptyHint => '导入地图图片或从空白画布开始，然后放置与条目关联的标记。';

  @override
  String get mapsNewFromImage => '从图片创建地图';

  @override
  String get mapsNewBlank => '空白地图';

  @override
  String mapsDefaultName(int number) {
    return '地图 $number';
  }

  @override
  String mapsPinCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个标记',
      zero: '没有标记',
    );
    return '$_temp0';
  }

  @override
  String get mapsRenameTitle => '重命名地图';

  @override
  String get mapsDuplicate => '复制';

  @override
  String mapsCopyName(String name) {
    return '$name（副本）';
  }

  @override
  String mapsDeleteTitle(String name) {
    return '删除“$name”？';
  }

  @override
  String get mapsDeleteBody => '地图及其所有标记将被删除。关联的条目不受影响。';

  @override
  String get mapsActions => '地图操作';

  @override
  String get mapsAllMaps => '全部地图';

  @override
  String get mapsMissing => '此地图已不存在。';

  @override
  String get mapsImportFailed => '无法将此文件作为图片打开。';

  @override
  String get mapsChangeImage => '更换图片';

  @override
  String get mapsImageMissing => '地图图片缺失';

  @override
  String get mapsImageMissingHint => '标记仍可使用。选择新图片以恢复背景。';

  @override
  String get mapsModeSelect => '选择';

  @override
  String get mapsModeAdd => '添加标记';

  @override
  String get mapsModeMeasure => '测量';

  @override
  String get mapsAddHint => '点击地图放置标记。';

  @override
  String get mapsMeasureHint => '点击两个点进行测量。';

  @override
  String get mapsMeasureNoScale => '未设置比例尺：以像素计。';

  @override
  String mapsDistance(String distance) {
    return '距离：$distance';
  }

  @override
  String mapsPixels(String value) {
    return '$value 像素';
  }

  @override
  String get mapsMeasureRule => '对角线规则';

  @override
  String get mapsRuleStraight => '直线';

  @override
  String get mapsRuleGrid => '网格：对角 = 1 格';

  @override
  String get mapsRuleAlternating => '网格：对角 1-2-1';

  @override
  String get mapsFit => '适应屏幕';

  @override
  String get mapsZoomIn => '放大';

  @override
  String get mapsZoomOut => '缩小';

  @override
  String get mapsPlayerView => '玩家视图';

  @override
  String get mapsExitPlayerView => '退出玩家视图';

  @override
  String get mapsPanel => '标记与详情';

  @override
  String get mapsPinsTab => '标记';

  @override
  String get mapsDetailsTab => '详情';

  @override
  String get mapsSearchPins => '搜索标记';

  @override
  String get mapsNoPins => '还没有标记。选择“添加标记”并点击地图。';

  @override
  String get mapsNoPinMatches => '没有匹配的标记。';

  @override
  String get mapsNewPin => '新标记';

  @override
  String get mapsEditPin => '编辑标记';

  @override
  String get mapsPinLabel => '名称';

  @override
  String get mapsPinIcon => '图标';

  @override
  String get mapsPinColor => '颜色';

  @override
  String get mapsPinNotes => '备注';

  @override
  String get mapsPinGmOnly => '仅主持人';

  @override
  String get mapsPinGmOnlyHint => '在玩家视图中隐藏';

  @override
  String get mapsLinkedEntry => '关联条目';

  @override
  String get mapsLinkEntry => '关联条目';

  @override
  String get mapsChangeEntry => '更换';

  @override
  String get mapsUnlink => '取消关联';

  @override
  String get mapsOpenEntry => '打开条目';

  @override
  String get mapsEntryMissing => '关联的条目已被删除';

  @override
  String get mapsDeletePin => '删除标记';

  @override
  String get mapsPinDeleted => '标记已删除';

  @override
  String get mapsUntitledPin => '未命名标记';

  @override
  String get mapsDescription => '描述';

  @override
  String get mapsNoDescription => '暂无描述。';

  @override
  String get mapsScale => '比例尺';

  @override
  String get mapsNoScale => '未设置比例尺';

  @override
  String mapsScaleValue(String units, String unit, String px) {
    return '1 格 = $units $unit（$px 像素）';
  }

  @override
  String get mapsScaleHelp => '图片中的一个网格对应此距离。不需要比例尺时请留空数字。';

  @override
  String get mapsScaleInvalid => '请为距离和格子大小输入正数。';

  @override
  String get mapsUnitsPerCell => '每格距离';

  @override
  String get mapsUnitName => '单位';

  @override
  String get mapsUnitHint => '英里、公里、尺…';

  @override
  String get mapsCellPx => '格子大小（像素）';

  @override
  String get mapsShowGrid => '显示网格';

  @override
  String get mapsGridNeedsScale => '设置比例尺后才能显示网格。';

  @override
  String get mapsPinsVisibleDefault => '新标记对玩家可见';

  @override
  String get mapsEditDetails => '编辑详情';

  @override
  String get mapsDetailsTitle => '地图详情';

  @override
  String mapsImageSize(int width, int height) {
    return '$width × $height 像素';
  }

  @override
  String get mapsBlankCanvas => '空白画布';

  @override
  String get mapsOnMaps => '在地图上';

  @override
  String get mapsIconPin => '标记';

  @override
  String get mapsIconCastle => '城堡';

  @override
  String get mapsIconTown => '城镇';

  @override
  String get mapsIconDungeon => '地下城';

  @override
  String get mapsIconCave => '洞穴';

  @override
  String get mapsIconForest => '森林';

  @override
  String get mapsIconMountain => '山脉';

  @override
  String get mapsIconPort => '港口';

  @override
  String get mapsIconDanger => '危险';

  @override
  String get mapsIconTreasure => '宝藏';

  @override
  String get mapsIconQuest => '任务';

  @override
  String get mapsIconCamp => '营地';

  @override
  String get mapsIconNpc => '人物';

  @override
  String get mapsIconPortal => '传送门';

  @override
  String get mapsIconNote => '笔记';

  @override
  String get mapsColorAuto => '自动（条目颜色）';

  @override
  String get mapsColorAccent => '强调色';

  @override
  String get mapsColorRed => '红';

  @override
  String get mapsColorOrange => '橙';

  @override
  String get mapsColorYellow => '黄';

  @override
  String get mapsColorGreen => '绿';

  @override
  String get mapsColorTeal => '青';

  @override
  String get mapsColorBlue => '蓝';

  @override
  String get mapsColorPurple => '紫';

  @override
  String get mapsColorPink => '粉';

  @override
  String get mapsColorGray => '灰';

  @override
  String get generatorsKindNames => '名字';

  @override
  String get generatorsKindNpc => 'NPC';

  @override
  String get generatorsKindSettlement => '聚落';

  @override
  String get generatorsKindEstablishment => '店铺';

  @override
  String get generatorsKindHook => '冒险引子';

  @override
  String get generatorsKindLoot => '战利品';

  @override
  String get generatorsKindFaction => '势力';

  @override
  String get generatorsKindWeather => '天气';

  @override
  String get generatorsKindRumor => '传闻';

  @override
  String get generatorsPicker => '生成器';

  @override
  String get generatorsPack => '题材包';

  @override
  String generatorsPackWorld(String pack) {
    return '$pack（本世界）';
  }

  @override
  String get generatorsGender => '性别';

  @override
  String get generatorsGenderAny => '不限';

  @override
  String get generatorsGenderFeminine => '女性';

  @override
  String get generatorsGenderMasculine => '男性';

  @override
  String get generatorsCulture => '命名风格';

  @override
  String get generatorsCultureAny => '混合';

  @override
  String get generatorsCount => '数量';

  @override
  String get generatorsEpithets => '附带绰号';

  @override
  String get generatorsGenerate => '生成';

  @override
  String get generatorsRerollAll => '全部重掷';

  @override
  String generatorsRerollField(String field) {
    return '重掷$field';
  }

  @override
  String get generatorsCopy => '复制为文本';

  @override
  String get generatorsCopyAll => '全部复制';

  @override
  String get generatorsCopyName => '复制名字';

  @override
  String get generatorsCopied => '已复制到剪贴板';

  @override
  String get generatorsKeep => '保留';

  @override
  String get generatorsUnkeep => '取消保留';

  @override
  String get generatorsDismiss => '移除';

  @override
  String get generatorsSave => '保存到世界';

  @override
  String get generatorsSaveAsCharacter => '保存为角色';

  @override
  String generatorsSaved(String name) {
    return '已将“$name”保存到世界';
  }

  @override
  String get generatorsSavedBadge => '已保存';

  @override
  String get generatorsKept => '已保留';

  @override
  String get generatorsHistory => '最近未保存';

  @override
  String get generatorsHistoryEmpty => '本次会话中未保存就被替换的结果会出现在这里。';

  @override
  String get generatorsRestore => '恢复';

  @override
  String get generatorsEmptyTitle => '尚未生成内容';

  @override
  String get generatorsEmptyHint => '选择一个生成器并点击“生成”。任意一行都可以重掷，留下满意的结果并保存到世界中。';

  @override
  String get generatorsFieldName => '名字';

  @override
  String get generatorsFieldPlaceName => '名称';

  @override
  String get generatorsFieldEpithet => '绰号';

  @override
  String get generatorsFieldAncestry => '出身';

  @override
  String get generatorsFieldRole => '身份';

  @override
  String get generatorsFieldAge => '年龄';

  @override
  String get generatorsFieldAppearance => '外貌';

  @override
  String get generatorsFieldTrait => '性格';

  @override
  String get generatorsFieldMotivation => '动机';

  @override
  String get generatorsFieldSecret => '秘密';

  @override
  String get generatorsFieldVoice => '言谈';

  @override
  String get generatorsFieldAttributes => '属性';

  @override
  String get generatorsFieldSize => '规模';

  @override
  String get generatorsFieldFeature => '特色';

  @override
  String get generatorsFieldTrouble => '麻烦';

  @override
  String get generatorsFieldAuthority => '掌权者';

  @override
  String get generatorsFieldType => '类型';

  @override
  String get generatorsFieldOwner => '店主';

  @override
  String get generatorsFieldSpecialty => '招牌';

  @override
  String get generatorsFieldPatron => '常客';

  @override
  String get generatorsFieldTitle => '标题';

  @override
  String get generatorsFieldWho => '委托人';

  @override
  String get generatorsFieldWants => '诉求';

  @override
  String get generatorsFieldObstacle => '阻碍';

  @override
  String get generatorsFieldTwist => '转折';

  @override
  String get generatorsFieldContainer => '出处';

  @override
  String get generatorsFieldCoins => '钱财';

  @override
  String get generatorsFieldItem => '物品';

  @override
  String get generatorsFieldCurio => '奇物';

  @override
  String get generatorsFieldGoal => '目标';

  @override
  String get generatorsFieldMethod => '手段';

  @override
  String get generatorsFieldSymbol => '标志';

  @override
  String get generatorsFieldSky => '天色';

  @override
  String get generatorsFieldAir => '空气';

  @override
  String get generatorsFieldOmen => '征兆';

  @override
  String get generatorsFieldSource => '消息来源';

  @override
  String get generatorsFieldTruth => '真相';

  @override
  String get starterContentTitle => '以示例内容开始';

  @override
  String get starterContentHint =>
      '为所选设定生成：一个聚居地及其居民、一个势力、首个战役中的两个冒险钩子，以及现成的随机表。一切都可以编辑或删除。';

  @override
  String get starterCampaignName => '第一次冒险';
}
