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
}
