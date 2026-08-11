// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Game Master\'s Hub';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navSearch => 'Search';

  @override
  String get navGraph => 'Graph View';

  @override
  String get navGraphShort => 'Graph';

  @override
  String get navCampaigns => 'Campaigns';

  @override
  String get navSettings => 'Settings & Backup';

  @override
  String get navSettingsShort => 'Settings';

  @override
  String get navHome => 'Home';

  @override
  String get sectionWorld => 'WORLD';

  @override
  String get sectionLibrary => 'LIBRARY';

  @override
  String get switchWorld => 'Switch world';

  @override
  String get worldsTagline =>
      'Your worlds, entirely yours — stored on this device.';

  @override
  String worldsLoadError(String error) {
    return 'Could not load worlds: $error';
  }

  @override
  String get worldsEmpty => 'No worlds yet. Forge your first one below.';

  @override
  String worldEdited(String when) {
    return 'Edited $when';
  }

  @override
  String get createNewWorld => 'Create New World';

  @override
  String get createWorldTitle => 'Create a New World';

  @override
  String get worldNameLabel => 'World name';

  @override
  String get worldNameHint => 'e.g. The Aurion Realms';

  @override
  String get worldDescriptionLabel => 'Description (optional)';

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get restore => 'Restore';

  @override
  String get open => 'Open';

  @override
  String get rename => 'Rename';

  @override
  String get newButton => 'New';

  @override
  String errorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get errorNameEmpty => 'Name cannot be empty.';

  @override
  String get errorUnexpected => 'Something went wrong. Please try again.';

  @override
  String get homeTheWorld => 'The World';

  @override
  String get homeLibrary => 'Library';

  @override
  String get homeFavorites => 'Favorites';

  @override
  String get homeRecentlyOpened => 'Recently Opened';

  @override
  String entriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries',
      one: '1 entry',
      zero: 'No entries',
    );
    return '$_temp0';
  }

  @override
  String filterHint(String plural) {
    return 'Filter $plural…';
  }

  @override
  String get favoritesOnly => 'Favorites only';

  @override
  String get showAll => 'Show all';

  @override
  String get sortTooltip => 'Sort';

  @override
  String get sortRecentlyEdited => 'Recently edited';

  @override
  String get sortNameAz => 'Name (A–Z)';

  @override
  String get sortNewestFirst => 'Newest first';

  @override
  String noEntriesOfKind(String plural) {
    return 'No $plural yet';
  }

  @override
  String newOfKind(String label) {
    return 'New $label';
  }

  @override
  String get newEntryTitle => 'New Entry';

  @override
  String get typeLabel => 'Type';

  @override
  String get nameLabel => 'Name';

  @override
  String get editEntryTitle => 'Edit Entry';

  @override
  String get summaryLabel => 'Summary';

  @override
  String get summaryHint => 'One line shown in lists and search';

  @override
  String deleteEntryTitle(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get deleteEntryBody =>
      'The entry is moved to trash; links to it are kept until it is purged.';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get menuEditNameSummary => 'Edit name & summary';

  @override
  String get menuShowInGraph => 'Show in graph';

  @override
  String get entryGone => 'This entry no longer exists.';

  @override
  String get tabDocument => 'Document';

  @override
  String get tabDetails => 'Details';

  @override
  String get editorPlaceholder =>
      'Write the lore… Use the @ button to link entries.';

  @override
  String get editorLinkEntity => 'Link an entry (mention)';

  @override
  String get editorInsertImage => 'Insert image';

  @override
  String get editorAttachFile => 'Attach a file into the text';

  @override
  String get editorVersionHistory => 'Version history';

  @override
  String get insertLinkTitle => 'Insert link to entry';

  @override
  String get missingLink => 'missing';

  @override
  String get versionHistoryTitle => 'Version History';

  @override
  String get versionHistoryEmpty =>
      'No snapshots yet. Versions are saved when you leave the editor or restore.';

  @override
  String get versionEmptyPreview => '(empty)';

  @override
  String get versionBeforeRestore => 'Before restore';

  @override
  String get searchHint => 'Search names, lore, tags…';

  @override
  String get searchAll => 'All';

  @override
  String get searchNoMatches => 'No matches';

  @override
  String get quickActions => 'QUICK ACTIONS';

  @override
  String get quickNewEntry => 'New entry';

  @override
  String get quickOpenGraph => 'Open graph';

  @override
  String get quickBackupExport => 'Backup & export';

  @override
  String get recentlyOpenedCaps => 'RECENTLY OPENED';

  @override
  String get graphTitle => 'Graph View';

  @override
  String get graphLocalTitle => 'Local Graph';

  @override
  String get graphWholeWorld => 'Whole world';

  @override
  String get graphFilterKinds => 'Filter kinds';

  @override
  String get graphEmpty =>
      'No connections yet.\nLink entries with @ mentions, relations or structured fields, and the web of your world will appear here.';

  @override
  String graphTruncated(int count) {
    return 'Showing the $count most connected entries. Focus an entry for its local graph.';
  }

  @override
  String get campaignsTitle => 'Campaigns';

  @override
  String get switchCampaign => 'Switch campaign';

  @override
  String get noCampaigns => 'No campaigns yet';

  @override
  String get startCampaign => 'Start a Campaign';

  @override
  String get questBoard => 'Quest Board';

  @override
  String get sessionLog => 'Session Log';

  @override
  String get noQuestsLinked =>
      'No quests linked to this campaign yet. Create a quest and set its Campaign field.';

  @override
  String get noSessions => 'No sessions recorded yet.';

  @override
  String chapterLabel(String chapter) {
    return 'Chapter: $chapter';
  }

  @override
  String get noPlayers => 'No players yet';

  @override
  String questsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count quests',
      one: '1 quest',
    );
    return '$_temp0';
  }

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions',
      one: '1 session',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Settings & Backup';

  @override
  String get languageSection => 'Language';

  @override
  String get languageSystem => 'System language';

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
    return 'Export \"$world\"';
  }

  @override
  String get exportSubtitle =>
      'Everything stays on this device until you share it.';

  @override
  String get exportArchiveTitle => 'Full project archive (.gmhw)';

  @override
  String get exportArchiveSubtitle =>
      'Database + all media in one file. Use it to move between devices.';

  @override
  String get exportJsonTitle => 'JSON data export';

  @override
  String get exportJsonSubtitle =>
      'All entries, links and metadata as readable JSON.';

  @override
  String get exportPdfTitle => 'PDF world book';

  @override
  String get exportPdfSubtitle =>
      'A printable book of your world, chapter per category.';

  @override
  String get importSection => 'Import';

  @override
  String get importArchiveTitle => 'Import project archive';

  @override
  String get importArchiveSubtitle =>
      'Restores a .gmhw file, including all media.';

  @override
  String get importPickArchive => 'Choose a .gmhw archive';

  @override
  String get backupsSection => 'Backups';

  @override
  String backupsSubtitle(int count) {
    return 'A backup is taken automatically once a day when you open the app. The last $count are kept.';
  }

  @override
  String get backupNow => 'Back up now';

  @override
  String get noBackups => 'No backups yet.';

  @override
  String get restoreBackupTitle => 'Restore this backup?';

  @override
  String restoreBackupBody(String file) {
    return 'The world will be replaced with the contents of \"$file\". A safety backup of the current state is taken first.';
  }

  @override
  String get aboutSection => 'About';

  @override
  String get aboutLocalFirst => 'Local-first';

  @override
  String get aboutLocalFirstBody =>
      'All data is stored on this device. No account, no cloud, fully offline.';

  @override
  String get backupSaved => 'Backup saved.';

  @override
  String get worldImported => 'World imported.';

  @override
  String get backupRestored => 'Backup restored.';

  @override
  String savedTo(String path) {
    return 'Saved to: $path';
  }

  @override
  String get shareArchiveText => 'GMH world archive';

  @override
  String get shareJsonText => 'GMH world data (JSON)';

  @override
  String get sharePdfText => 'GMH world book (PDF)';

  @override
  String get relationsCaps => 'RELATIONS';

  @override
  String get backlinksCaps => 'BACKLINKS';

  @override
  String get addRelation => 'Add relation';

  @override
  String get openInGraph => 'Open in graph';

  @override
  String get noOutgoingRelations => 'No outgoing relations yet.';

  @override
  String get noBacklinks => 'Nothing links here yet.';

  @override
  String relationToTitle(String name) {
    return 'Relation to \"$name\"';
  }

  @override
  String get roleLabel => 'Role';

  @override
  String get roleHint => 'e.g. owner, ally, rival';

  @override
  String get fromDocumentMention => 'From a document mention';

  @override
  String get fromStructuredField => 'From a structured field';

  @override
  String get roleMention => 'Mentioned in';

  @override
  String get roleRelated => 'Related to';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleLocatedAt => 'Located at';

  @override
  String get roleMemberOf => 'Member of';

  @override
  String get rolePartOf => 'Part of';

  @override
  String get roleParticipatedIn => 'Participated in';

  @override
  String get roleCreatedAt => 'Created at';

  @override
  String get roleQuestGiver => 'Quest giver';

  @override
  String get roleAlly => 'Ally';

  @override
  String get roleFriend => 'Friend';

  @override
  String get roleFamily => 'Family';

  @override
  String get roleEnemy => 'Enemy';

  @override
  String get roleRival => 'Rival';

  @override
  String get tabBiography => 'Biography';

  @override
  String get tabProfile => 'Profile';

  @override
  String get attachmentsCaps => 'ATTACHMENTS';

  @override
  String get addFiles => 'Add files';

  @override
  String get fromGallery => 'From photo gallery';

  @override
  String get noAttachments => 'No attachments yet.';

  @override
  String get dropFilesHere => 'Drop files here to attach them';

  @override
  String get setAsCover => 'Set as cover image';

  @override
  String get newTab => 'New tab';

  @override
  String get changeImage => 'Change image';

  @override
  String get addImage => 'Add image';

  @override
  String get editCaption => 'Edit caption';

  @override
  String get captionLabel => 'Caption';

  @override
  String get replaceFile => 'Replace file';

  @override
  String get deleteAttachment => 'Remove attachment';

  @override
  String deleteAttachmentTitle(String name) {
    return 'Remove \"$name\"?';
  }

  @override
  String get deleteAttachmentBody =>
      'The attachment is removed from this entry. The file is deleted from the vault when no other entry uses it.';

  @override
  String get renameAttachmentTitle => 'Rename attachment';

  @override
  String get previewUnavailable =>
      'Preview is not available for this file type. Open it with another app.';

  @override
  String get openExternally => 'Open with another app';

  @override
  String attachmentsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files attached',
      one: '1 file attached',
    );
    return '$_temp0';
  }

  @override
  String get tagChip => 'Tag';

  @override
  String get addTagTitle => 'Add Tag';

  @override
  String get tagNameHint => 'Tag name';

  @override
  String get none => 'None';

  @override
  String get choose => 'Choose…';

  @override
  String addToList(String label) {
    return 'Add to $label';
  }

  @override
  String get clear => 'Clear';

  @override
  String get pickerTitleDefault => 'Link an entry';

  @override
  String get pickerSearchAll => 'Search all entries…';

  @override
  String pickerSearchKinds(String kinds) {
    return 'Search $kinds…';
  }

  @override
  String get pickerNoMatches => 'No matching entries';

  @override
  String get justNow => 'just now';

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get sectionCategories => 'MY CATEGORIES';

  @override
  String get manageCategories => 'Manage Categories';

  @override
  String get newCategory => 'New category';

  @override
  String get renameCategory => 'Edit category';

  @override
  String get deleteCategory => 'Delete category';

  @override
  String deleteCategoryTitle(String name) {
    return 'Delete category “$name”?';
  }

  @override
  String deleteCategoryBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Its $count entries are preserved and moved to the Concept Archive.',
      one: 'Its $count entry is preserved and moved to the Concept Archive.',
    );
    return '$_temp0';
  }

  @override
  String get deleteCategoryBodyEmpty =>
      'The category is empty; nothing else changes.';

  @override
  String get categoryNameLabel => 'Category name';

  @override
  String get categoryNameHint => 'e.g. Guilds, Kingdoms, Rituals…';

  @override
  String get chooseIcon => 'Icon';

  @override
  String get noCategoriesYet =>
      'No custom categories yet. Create one below — it will behave exactly like the built-in sections.';

  @override
  String get kindCustomEntry => 'Entry';

  @override
  String get tagManagerTitle => 'Tag Manager';

  @override
  String get searchTagsHint => 'Search tags…';

  @override
  String get sortByName => 'Alphabetical';

  @override
  String get sortByCreated => 'By creation date';

  @override
  String get sortByUsage => 'By usage';

  @override
  String get newTag => 'New tag';

  @override
  String get mergeTagAction => 'Merge into another tag…';

  @override
  String mergeTagTitle(String name) {
    return 'Merge “$name”';
  }

  @override
  String mergeTagBody(String name) {
    return 'Every entry tagged “$name” will receive the tag you choose below, and “$name” will be deleted.';
  }

  @override
  String get changeColor => 'Change color';

  @override
  String deleteTagTitle(String name) {
    return 'Delete tag “$name”?';
  }

  @override
  String deleteTagBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'The tag is removed from $count entries. The entries themselves are kept.',
      one: 'The tag is removed from $count entry. The entry itself is kept.',
      zero: 'No entries use this tag.',
    );
    return '$_temp0';
  }

  @override
  String get noTags => 'No tags yet. Tags you add to entries appear here.';

  @override
  String get noTagMatches => 'No tags match your search.';

  @override
  String get appearanceSection => 'Appearance';

  @override
  String get themeSystem => 'Match system';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get navBack => 'Back';

  @override
  String get navForward => 'Forward';

  @override
  String get kindCharacter => 'Character';

  @override
  String get kindCharacterPlural => 'Characters';

  @override
  String get kindLocation => 'Location';

  @override
  String get kindLocationPlural => 'Locations';

  @override
  String get kindItem => 'Item';

  @override
  String get kindItemPlural => 'Items';

  @override
  String get kindCreature => 'Creature';

  @override
  String get kindCreaturePlural => 'Creatures';

  @override
  String get kindFaction => 'Faction';

  @override
  String get kindFactionPlural => 'Factions';

  @override
  String get kindEvent => 'Event';

  @override
  String get kindEventPlural => 'Events';

  @override
  String get kindEra => 'Era';

  @override
  String get kindEraPlural => 'Eras';

  @override
  String get kindReligion => 'Religion';

  @override
  String get kindReligionPlural => 'Religions';

  @override
  String get kindMagicSystem => 'Magic System';

  @override
  String get kindMagicSystemPlural => 'Magic Systems';

  @override
  String get kindTechnology => 'Technology';

  @override
  String get kindTechnologyPlural => 'Technologies';

  @override
  String get kindConcept => 'Concept';

  @override
  String get kindConceptPlural => 'Concept Archive';

  @override
  String get kindLoreDocument => 'Lore Document';

  @override
  String get kindLoreDocumentPlural => 'Lore Documents';

  @override
  String get kindCampaign => 'Campaign';

  @override
  String get kindCampaignPlural => 'Campaigns';

  @override
  String get kindQuest => 'Quest';

  @override
  String get kindQuestPlural => 'Quests';

  @override
  String get kindSession => 'Session';

  @override
  String get kindSessionPlural => 'Sessions';

  @override
  String get close => 'Close';

  @override
  String get cyberKindCharacter => 'Runner';

  @override
  String get cyberKindCharacterPlural => 'Runners';

  @override
  String get cyberKindLocation => 'Sector';

  @override
  String get cyberKindLocationPlural => 'Sectors';

  @override
  String get cyberKindItem => 'Gear';

  @override
  String get cyberKindItemPlural => 'Gear & Tech';

  @override
  String get cyberKindCreature => 'Cyberform';

  @override
  String get cyberKindCreaturePlural => 'Cyberforms';

  @override
  String get cyberKindFaction => 'Syndicate';

  @override
  String get cyberKindFactionPlural => 'Corps & Gangs';

  @override
  String get cyberKindEvent => 'Incident';

  @override
  String get cyberKindEventPlural => 'Incidents';

  @override
  String get cyberKindEra => 'Epoch';

  @override
  String get cyberKindEraPlural => 'Epochs';

  @override
  String get cyberKindReligion => 'Cult';

  @override
  String get cyberKindReligionPlural => 'Cults';

  @override
  String get cyberKindMagicSystem => 'Protocol';

  @override
  String get cyberKindMagicSystemPlural => 'Protocols';

  @override
  String get cyberKindTechnology => 'Cyberware';

  @override
  String get cyberKindTechnologyPlural => 'Cyberware';

  @override
  String get cyberKindConcept => 'Data Fragment';

  @override
  String get cyberKindConceptPlural => 'Data Vault';

  @override
  String get cyberKindLoreDocument => 'Data Shard';

  @override
  String get cyberKindLoreDocumentPlural => 'Data Shards';

  @override
  String get cyberKindCampaign => 'Operation';

  @override
  String get cyberKindCampaignPlural => 'Operations';

  @override
  String get cyberKindQuest => 'Gig';

  @override
  String get cyberKindQuestPlural => 'Gigs';

  @override
  String get cyberKindSession => 'Run';

  @override
  String get cyberKindSessionPlural => 'Runs';

  @override
  String get worldStyleLabel => 'World style';

  @override
  String get worldStyleFantasy => 'Fantasy';

  @override
  String get worldStyleFantasyHint =>
      'Candle-lit parchment, classic vocabulary: Characters, Locations, Quests';

  @override
  String get worldStyleCyberpunk => 'Cyberpunk';

  @override
  String get worldStyleCyberpunkHint =>
      'Neon chrome and street slang: Runners, Sectors, Gigs';

  @override
  String get viewAsGrid => 'Grid view';

  @override
  String get viewAsList => 'List view';

  @override
  String get blueprintFieldsSection => 'Fields';

  @override
  String get constructorTitleNew => 'Section Constructor';

  @override
  String get constructorTitleEdit => 'Section Settings';

  @override
  String get constructorModules => 'Modules';

  @override
  String get constructorModulesHint =>
      'Add or remove the building blocks entries of this section will have.';

  @override
  String get moduleFields => 'Structured fields';

  @override
  String get moduleFieldsHint => 'A form of fields you define below';

  @override
  String get moduleDocument => 'Document';

  @override
  String get moduleDocumentHint => 'Rich-text editor with links and images';

  @override
  String get moduleGallery => 'Gallery';

  @override
  String get moduleGalleryHint => 'Image grid on every entry';

  @override
  String get moduleAttachments => 'Files';

  @override
  String get moduleAttachmentsHint => 'Attached files of any type';

  @override
  String get moduleTags => 'Tags';

  @override
  String get moduleTagsHint => 'Tagging and tag filters';

  @override
  String get moduleRelations => 'Relations';

  @override
  String get moduleRelationsHint => 'Links to other entries and backlinks';

  @override
  String get constructorFields => 'Custom fields';

  @override
  String get constructorFieldsEmpty =>
      'No fields yet — add the columns this section needs, e.g. “Level”, “School”, “Price”.';

  @override
  String get addField => 'Add field';

  @override
  String get editField => 'Edit field';

  @override
  String get fieldNameLabel => 'Field name';

  @override
  String get fieldTypeLabel => 'Field type';

  @override
  String get fieldOptionsLabel => 'Options (comma-separated)';

  @override
  String get fieldOptionsHint => 'e.g. Common, Rare, Legendary';

  @override
  String get fieldTypeText => 'Text';

  @override
  String get fieldTypeLongText => 'Long text';

  @override
  String get fieldTypeNumber => 'Number';

  @override
  String get fieldTypeSelect => 'Choice list';

  @override
  String get fieldTypeDate => 'Date';

  @override
  String get fieldTypeChecklist => 'Checklist';

  @override
  String get fieldTypeStringList => 'List of values';

  @override
  String get pauseSaveProject => 'Save project';

  @override
  String get pauseExit => 'Exit';

  @override
  String get helpTitle => 'User Guide';

  @override
  String get helpSettingsSubtitle =>
      'The built-in manual: where everything is and how to use it';

  @override
  String get helpIntroBody =>
      'Game Master\'s Hub is an offline workspace for game masters: worlds, characters, locations, campaigns and lore all live on this device, connected into one navigable web. This guide walks through every part of the app — the diagrams below are schematic views of the real screens, and the numbered markers are explained under each picture.';

  @override
  String get helpWorldsTitle => 'Worlds & world styles';

  @override
  String get helpWorldsBody =>
      'Everything starts with a world — a fully isolated project with its own entries, tags and campaigns. The world picker opens on launch; the globe icon in the sidebar returns you there at any time. When creating a world you choose its style: Fantasy (parchment and classic terms — Characters, Locations, Quests) or Cyberpunk (neon palette and street slang — Runners, Sectors, Gigs). The style changes the entire look and vocabulary of that world and can differ per world. Each world remembers where you left off and reopens exactly there.';

  @override
  String get helpShellTitle => 'Navigation & sidebar';

  @override
  String get helpShellBody =>
      'The left sidebar is your control center. It lists the main pages, the World and Library sections with live entry counts, and your custom categories. Hold and drag any tab to reorder a group — the order is saved per world. On tablets the sidebar collapses into a rail, on phones into the bottom bar.';

  @override
  String get helpShellLegend1 =>
      'World switcher — tap the header to return to the world picker.';

  @override
  String get helpShellLegend2 =>
      'Back / Forward — browser-style history over everything you visit. Alt+← / Alt+→ work anywhere.';

  @override
  String get helpShellLegend3 =>
      'Section tabs with live counts. Press-and-hold, then drag to reorder; your order persists.';

  @override
  String get helpShellLegend4 =>
      'List controls — filter box, grid/list toggle, sort menu and favorites filter for the open section.';

  @override
  String get helpShellLegend5 =>
      'Entry cards show the summary and context chips: status, race, rarity, dates — whatever fits the section.';

  @override
  String get helpShellLegend6 =>
      'New entry — creates an entry in the section you are viewing.';

  @override
  String get helpEntryTitle => 'Entries: document, fields & attachments';

  @override
  String get helpEntryBody =>
      'Every entry is a page with a rich-text document and a structured side panel. The document editor supports headers, lists, quotes, images pasted or dropped straight into the text, file attachments and version history (the clock icon on the toolbar). Type @ or press the mention button to link another entry inline — links are two-way and feed the graph. The side panel holds the template fields of the entry\'s kind, tags, relations with backlinks, and the gallery.';

  @override
  String get helpEntryLegend1 =>
      'Name — click it to rename; the star toggles favorite.';

  @override
  String get helpEntryLegend2 =>
      'Editor toolbar: formatting, alignment, @ mention, insert image, attach file, version history.';

  @override
  String get helpEntryLegend3 =>
      'An inline mention of another entry — click to jump there; it also creates a backlink.';

  @override
  String get helpEntryLegend4 =>
      'Structured fields defined by the entry\'s kind (or your section constructor).';

  @override
  String get helpEntryLegend5 =>
      'Gallery and file attachments — drag & drop files anywhere on the page to attach.';

  @override
  String get helpProfileTitle => 'Character profiles';

  @override
  String get helpProfileBody =>
      'Characters open as a full tabbed profile: General Information, Biography, Statistics with a D&D-style ability grid and derived modifiers, Beliefs, Relationships (allies, enemies, factions — all real links), Inventory, Abilities & Magic, Timeline and Notes. The portrait comes from the entry\'s cover image — set any gallery image as cover from its long-press menu. Every relationship you fill in appears in the graph and as a backlink on the target entry.';

  @override
  String get helpCampaignsTitle => 'Campaigns, quests & sessions';

  @override
  String get helpCampaignsBody =>
      'The Campaigns page is your table dashboard. Pick the active campaign from the dropdown in the top-right corner — the choice is remembered per world. The Quest Board shows every quest whose Campaign field points at the selected campaign, grouped by status; the Session Log collects session entries the same way. Create quests and sessions right from this page — the campaign link is filled in automatically.';

  @override
  String get helpSearchTitle => 'Search & tags';

  @override
  String get helpSearchBody =>
      'Search (the magnifier in the sidebar) is instant full-text search across names, summaries, documents and tags. Filter chips narrow results to one section or category. Tags are managed in the Tag Manager — reachable from the sidebar or search quick actions — where you can rename, recolor, merge duplicates and delete tags with live usage counts. Every list screen can also filter by a tag and by favorites.';

  @override
  String get helpGraphTitle => 'Relationship graph';

  @override
  String get helpGraphBody =>
      'The graph shows your world as a living web: every mention, relation and structured reference becomes an edge. Colors follow entry kinds; node size follows the number of connections. Tap a node to open its entry, or use \"Show in graph\" on any entry to see its local neighborhood. The kind filter in the toolbar hides categories you don\'t need right now.';

  @override
  String get helpConstructorTitle => 'Custom sections & the constructor';

  @override
  String get helpConstructorBody =>
      'Beyond the built-in sections you can create your own — Guilds, Spells, Recipes, anything. A custom section behaves exactly like a built-in one: sidebar tab with counts, dashboard tile, search filter, graph colors and PDF chapters. The Section Constructor decides what its entries look like: toggle modules on or off and define custom fields of seven types. Deleting a category never deletes entries — they move to the Concept Archive.';

  @override
  String get helpConstructorLegend1 =>
      'Modules — the building blocks an entry page will have. Disabled modules disappear entirely.';

  @override
  String get helpConstructorLegend2 =>
      'Custom fields with types: text, long text, number, choice list, date, checklist, list of values. Drag to reorder.';

  @override
  String get helpConstructorLegend3 =>
      'Add field — the first fields also become the chips on the section\'s cards.';

  @override
  String get helpBackupTitle => 'Backups & moving between devices';

  @override
  String get helpBackupBody =>
      'Everything is stored locally — no account, no cloud. The app takes an automatic backup once a day; you can trigger one anytime in Settings. To move or share a world, export a .gmhw archive: one file containing the database and all media. Importing it on another device restores the world exactly, including custom sections and styles. JSON export and the printable PDF world book are also available in Settings.';

  @override
  String get helpTipsTitle => 'Tips & shortcuts';

  @override
  String get helpTipsBody =>
      'Alt+← / Alt+→ — navigate back and forward. Type @ in the editor to link entries as you write. Long-press sidebar tabs, constructor fields or gallery tiles to drag-reorder them. Right-click (or long-press) attachments for rename, replace and cover actions. The grid/list toggle on any section is remembered per section. Sort, filters and the selected campaign are remembered too — the app always reopens where you left it. Ctrl+K (Cmd+K on Mac) jumps straight to search; the mouse back/forward side buttons walk the history, and the navigation arrows sit at the top-left of every page.';

  @override
  String get helpScreenshotCaption =>
      'Screenshot of the app (English interface)';

  @override
  String get helpFigureCaption => 'Schematic view of the actual screen';
}
