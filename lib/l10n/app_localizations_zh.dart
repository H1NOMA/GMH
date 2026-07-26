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
  String get ttgImportTitle => '导入TTG数据库';

  @override
  String get ttgImportIntro =>
      '将完整的TTG龙与地下城数据库——战役、NPC、怪物、法术、物品、地点、势力、任务、媒体及全部关联——迁移到GMH世界中。支持的来源：SQLite数据库（.db、.sqlite、.ttg）、JSON导出以及包含媒体的ZIP导出。';

  @override
  String get ttgPickFile => '选择TTG数据库…';

  @override
  String ttgPreviewCount(int count) {
    return '检测到$count条记录';
  }

  @override
  String get ttgResumeBanner => '发现此文件有一次被中断的导入。导入将继续进行——已导入的记录会被跳过。';

  @override
  String get ttgWorldName => '世界名称';

  @override
  String get ttgDuplicatesLabel => '当记录已存在时';

  @override
  String get ttgSkip => '跳过';

  @override
  String get ttgMerge => '合并';

  @override
  String get ttgReplace => '替换';

  @override
  String get ttgAsk => '每次询问';

  @override
  String get ttgBack => '返回';

  @override
  String get ttgStart => '开始导入';

  @override
  String get ttgResume => '继续导入';

  @override
  String get ttgPhaseReading => '正在读取来源';

  @override
  String get ttgPhaseEntities => '正在导入记录';

  @override
  String get ttgPhaseLinks => '正在重建关联';

  @override
  String get ttgPhaseValidating => '正在校验';

  @override
  String get ttgPhaseIndexing => '正在构建搜索索引';

  @override
  String ttgEta(int seconds) {
    return '约剩$seconds秒';
  }

  @override
  String get ttgErrorLog => '问题';

  @override
  String get ttgDoneTitle => '迁移完成';

  @override
  String get ttgInterruptedTitle => '导入已中断——稍后可以继续';

  @override
  String get ttgStatImported => '已导入记录';

  @override
  String get ttgStatLinks => '已创建链接';

  @override
  String get ttgStatMedia => '已导入媒体文件';

  @override
  String get ttgStatDocuments => '已创建文档';

  @override
  String get ttgStatTags => '已创建标签';

  @override
  String get ttgStatRepaired => '已修复引用';

  @override
  String get ttgStatSkipped => '已跳过重复项';

  @override
  String get ttgOpenWorld => '打开世界';

  @override
  String get ttgDuplicateTitle => '发现重复项';

  @override
  String ttgDuplicateBody(String name, String collection) {
    return '“$name”（$collection）已存在于此世界。要如何处理？';
  }

  @override
  String get ttgApplyToAll => '应用到其余所有重复项';

  @override
  String get ttgSettingsTitle => '导入TTG数据库';

  @override
  String get ttgSettingsSubtitle => '将完整的TTG龙与地下城数据库迁移到新世界：全部记录、关联、格式与媒体';

  @override
  String get cyberKindCharacter => '狂奔者';

  @override
  String get cyberKindCharacterPlural => '狂奔者';

  @override
  String get cyberKindLocation => '区块';

  @override
  String get cyberKindLocationPlural => '区块';

  @override
  String get cyberKindItem => '装备';

  @override
  String get cyberKindItemPlural => '装备与科技';

  @override
  String get cyberKindCreature => '赛博生物';

  @override
  String get cyberKindCreaturePlural => '赛博生物';

  @override
  String get cyberKindFaction => '辛迪加';

  @override
  String get cyberKindFactionPlural => '公司与帮派';

  @override
  String get cyberKindEvent => '突发事件';

  @override
  String get cyberKindEventPlural => '突发事件';

  @override
  String get cyberKindEra => '时代';

  @override
  String get cyberKindEraPlural => '时代';

  @override
  String get cyberKindReligion => '教派';

  @override
  String get cyberKindReligionPlural => '教派';

  @override
  String get cyberKindMagicSystem => '协议';

  @override
  String get cyberKindMagicSystemPlural => '协议';

  @override
  String get cyberKindTechnology => '义体';

  @override
  String get cyberKindTechnologyPlural => '义体';

  @override
  String get cyberKindConcept => '数据碎片';

  @override
  String get cyberKindConceptPlural => '数据保险库';

  @override
  String get cyberKindLoreDocument => '数据芯片';

  @override
  String get cyberKindLoreDocumentPlural => '数据芯片';

  @override
  String get cyberKindCampaign => '行动';

  @override
  String get cyberKindCampaignPlural => '行动';

  @override
  String get cyberKindQuest => '委托';

  @override
  String get cyberKindQuestPlural => '委托';

  @override
  String get cyberKindSession => '狂奔';

  @override
  String get cyberKindSessionPlural => '狂奔';

  @override
  String get worldStyleLabel => '世界风格';

  @override
  String get worldStyleFantasy => '奇幻';

  @override
  String get worldStyleFantasyHint => '烛光羊皮纸与经典术语：角色、地点、任务';

  @override
  String get worldStyleCyberpunk => '赛博朋克';

  @override
  String get worldStyleCyberpunkHint => '霓虹铬光与街头黑话：狂奔者、区块、委托';

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
  String get helpImportTitle => '从TTG导入';

  @override
  String get helpImportBody =>
      '设置→导入可以把完整的TTG龙与地下城数据库迁移到新世界：战役、NPC、怪物、法术、物品、地点、势力、任务、跑团笔记、媒体及全部关联。支持SQLite（.db、.sqlite、.ttg）、JSON和ZIP导出。格式会被保留，引用会被校验并修复，重复项可以跳过、合并或逐条决定，中断的导入会从停下的地方继续。完整的迁移报告会作为传说文档保存在新世界中。';

  @override
  String get helpBackupTitle => '备份与设备间迁移';

  @override
  String get helpBackupBody =>
      '一切都存储在本地——无需账号，也没有云端。应用每天自动备份一次；你也可以随时在设置中手动备份。要迁移或分享世界，请导出.gmhw存档：一个包含数据库和全部媒体的文件。在另一台设备上导入即可原样恢复世界，包括自定义版块和风格。设置中还提供JSON导出和可打印的PDF世界之书。';

  @override
  String get helpTipsTitle => '技巧与快捷键';

  @override
  String get helpTipsBody =>
      'Alt+← / Alt+→——前后导航。在编辑器中输入@即可边写边链接条目。长按侧边栏标签、构建器字段或图库磁贴即可拖动排序。右键（或长按）附件可进行重命名、替换和设为封面等操作。每个版块的网格／列表切换都会分别记住。排序、筛选和所选战役同样会被记住——应用总会回到你上次离开的地方。';

  @override
  String get helpScreenshotCaption => '应用截图（英文界面）';

  @override
  String get helpFigureCaption => '真实界面的示意图';
}
