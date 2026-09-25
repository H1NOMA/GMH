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
  String get worldStyleLabel => 'World style';

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

  @override
  String get editWorldTitle => 'Edit world';

  @override
  String get worldActions => 'World actions';

  @override
  String deleteWorldTitle(String name) {
    return 'Delete “$name”?';
  }

  @override
  String get deleteWorldBody =>
      'Every entry, document, image and campaign in this world is deleted permanently. Existing backup files are kept.';

  @override
  String get worldSection => 'World';

  @override
  String get navTools => 'Tools';

  @override
  String get sectionTools => 'AT THE TABLE';

  @override
  String get toolDice => 'Dice Roller';

  @override
  String get toolDiceHint =>
      'Any notation — 4d6kh3, 2d20kl1, 3d6!, dF — with presets and a roll log.';

  @override
  String get toolCombat => 'Combat Tracker';

  @override
  String get toolCombatHint =>
      'Initiative order, hit points, conditions and rounds; encounter difficulty.';

  @override
  String get toolTables => 'Random Tables';

  @override
  String get toolTablesHint =>
      'Your own roll tables with weights, dice ranges and nested rolls.';

  @override
  String get toolGenerators => 'Generators';

  @override
  String get toolGeneratorsHint =>
      'Names, NPCs, taverns, loot, weather, rumors — tuned to your setting.';

  @override
  String get toolMaps => 'Maps';

  @override
  String get toolMapsHint =>
      'Interactive maps with pins linked to your entries; nested maps.';

  @override
  String get toolTimeline => 'Timeline';

  @override
  String get toolTimelineHint =>
      'Events and eras of your world in chronological order.';

  @override
  String get toolReference => 'GM Screen';

  @override
  String get toolReferenceHint =>
      'Conditions and quick rules at a glance (SRD 5.2.1).';

  @override
  String importReplaceTitle(String name) {
    return 'Replace “$name”?';
  }

  @override
  String get importReplaceBody =>
      'This archive contains a world that already exists here. Importing replaces the current version of it completely.';

  @override
  String get importReplaceAction => 'Replace';

  @override
  String get searchIndexFailed =>
      'The world was restored, but search could not be rebuilt. Restart the app to retry.';

  @override
  String get fieldNotANumber => 'Enter a number';

  @override
  String get pdfBookSubtitle => 'A World Book';

  @override
  String get pdfIncludeGmOnly => 'Include game-master secrets';

  @override
  String get pdfIncludeGmOnlyHint =>
      'Off: a player-safe book without fields marked for the GM only.';

  @override
  String get exportAction => 'Export';

  @override
  String get tagNameTaken =>
      'A tag with this name already exists — use Merge instead.';

  @override
  String get errorEntryGone => 'This entry no longer exists.';

  @override
  String get errorNotFound =>
      'Couldn’t find what you were looking for — it may have been deleted.';

  @override
  String get errorStorage =>
      'Couldn’t read or write a file. Check free disk space and folder permissions.';

  @override
  String get errorDatabase =>
      'The database couldn’t complete the operation. Your data is unchanged.';

  @override
  String get errorArchiveMissing => 'The archive file wasn’t found.';

  @override
  String get errorArchiveInvalid =>
      'This file isn’t a valid GMH world archive.';

  @override
  String get errorExport =>
      'Export failed. Check free disk space and that the target folder is writable.';

  @override
  String get errorAiNotConfigured => 'No AI provider is configured.';

  @override
  String get diceExpressionLabel => 'Dice expression';

  @override
  String get diceExpressionHint => 'e.g. 2d6+3, 4d6kh3, 1d20!';

  @override
  String get diceRollAction => 'Roll';

  @override
  String get diceLabelHint => 'Label (optional)';

  @override
  String get diceAdvantage => 'Advantage';

  @override
  String get diceDisadvantage => 'Disadvantage';

  @override
  String get diceModifier => 'Modifier';

  @override
  String get diceDecrease => 'Decrease';

  @override
  String get diceIncrease => 'Increase';

  @override
  String get diceQuickHint =>
      'Tap a die to roll it, long-press to add it to the expression.';

  @override
  String get dicePresets => 'System presets';

  @override
  String get diceHistory => 'Roll history';

  @override
  String get diceHistoryEmpty => 'No rolls yet. Every roll is logged here.';

  @override
  String get diceClearHistory => 'Clear history';

  @override
  String get diceClearHistoryTitle => 'Clear roll history?';

  @override
  String get diceClearHistoryBody =>
      'Every logged roll in this world is deleted.';

  @override
  String get diceReroll => 'Roll again';

  @override
  String get diceCopy => 'Copy';

  @override
  String get diceCopied => 'Copied to clipboard';

  @override
  String get diceResultEmpty => 'Pick a die or type an expression';

  @override
  String get diceDropped => 'Dropped';

  @override
  String get diceExploded => 'Exploded';

  @override
  String get diceRerolled => 'Rerolled';

  @override
  String diceMoreDice(int count) {
    return '+$count more';
  }

  @override
  String get diceErrorEmpty => 'Type a dice expression';

  @override
  String get diceErrorTooLong => 'The expression is too long';

  @override
  String get diceErrorUnexpectedChar => 'Unexpected character';

  @override
  String get diceErrorUnexpectedEnd => 'The expression ends too early';

  @override
  String get diceErrorExpectedNumber => 'A number is expected here';

  @override
  String get diceErrorParen => 'Unbalanced parentheses';

  @override
  String get diceErrorTooManyDice => 'At most 1000 dice per term';

  @override
  String get diceErrorBadSides => 'Dice need 1 to 10000 sides';

  @override
  String get diceErrorTooLarge => 'The number is too large';

  @override
  String get diceErrorDivisionByZero => 'Division by zero';

  @override
  String get diceErrorDuplicate => 'This modifier is repeated';

  @override
  String get diceErrorImpossibleReroll => 'That reroll would never stop';

  @override
  String get diceErrorLabel => 'Close the label with ]';

  @override
  String diceErrorAt(String message, int position) {
    return '$message (position $position)';
  }

  @override
  String get dicePresetD20 => 'd20 check';

  @override
  String get dicePresetAbility => 'Ability score';

  @override
  String get dicePresetCoc => 'Call of Cthulhu';

  @override
  String get dicePresetPbta => 'PbtA move';

  @override
  String get dicePresetBlades => 'Blades in the Dark';

  @override
  String get dicePresetFate => 'Fate';

  @override
  String get dicePresetYearZero => 'Year Zero';

  @override
  String get dicePresetSavage => 'Savage Worlds';

  @override
  String get dicePresetCyberpunk => 'Cyberpunk RED';

  @override
  String get diceModeNormal => 'Normal';

  @override
  String get diceDc => 'DC (optional)';

  @override
  String get diceSkill => 'Skill';

  @override
  String get diceBonusDice => 'Bonus (+) / penalty (−) dice';

  @override
  String get diceStat => 'Stat';

  @override
  String get diceDicePool => 'Dice pool';

  @override
  String get diceTraitDie => 'Trait die';

  @override
  String get diceWildDie => 'Wild die';

  @override
  String get diceStatSkill => 'Stat + skill';

  @override
  String get diceOutcomeCriticalSuccess => 'Critical success';

  @override
  String get diceOutcomeCriticalFailure => 'Critical failure';

  @override
  String get diceOutcomeSuccess => 'Success';

  @override
  String get diceOutcomeFailure => 'Failure';

  @override
  String get diceOutcomeRaise => 'Success with a raise';

  @override
  String get diceOutcomeExtreme => 'Extreme success';

  @override
  String get diceOutcomeHard => 'Hard success';

  @override
  String get diceOutcomeRegular => 'Regular success';

  @override
  String get diceOutcomeFumble => 'Fumble';

  @override
  String get diceOutcomeMiss => 'Miss';

  @override
  String get diceOutcomePartial => 'Partial success';

  @override
  String get diceOutcomeFull => 'Full success';

  @override
  String get diceFateTerrible => 'Terrible';

  @override
  String get diceFatePoor => 'Poor';

  @override
  String get diceFateMediocre => 'Mediocre';

  @override
  String get diceFateAverage => 'Average';

  @override
  String get diceFateFair => 'Fair';

  @override
  String get diceFateGood => 'Good';

  @override
  String get diceFateGreat => 'Great';

  @override
  String get diceFateSuperb => 'Superb';

  @override
  String get diceFateFantastic => 'Fantastic';

  @override
  String get diceFateEpic => 'Epic';

  @override
  String get diceFateLegendary => 'Legendary';

  @override
  String diceSuccesses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count successes',
      one: '1 success',
      zero: 'No successes',
    );
    return '$_temp0';
  }

  @override
  String diceRollTooltip(String expression) {
    return 'Roll $expression';
  }

  @override
  String diceRolledSnack(String expression, int total) {
    return '$expression: $total';
  }

  @override
  String get diceQuickRollTitle => 'Quick roll';

  @override
  String get combatNewEncounter => 'New encounter';

  @override
  String combatEncounterDefaultName(int number) {
    return 'Encounter $number';
  }

  @override
  String get combatEncounterNameLabel => 'Encounter name';

  @override
  String get combatEmptyTitle => 'No encounters yet';

  @override
  String get combatEmptyHint =>
      'Plan a fight: add monsters and heroes, check the difficulty, then run it round by round.';

  @override
  String get combatRenameTitle => 'Rename encounter';

  @override
  String get combatDuplicate => 'Duplicate';

  @override
  String combatCopyName(String name) {
    return '$name (copy)';
  }

  @override
  String combatDeleteTitle(String name) {
    return 'Delete “$name”?';
  }

  @override
  String get combatDeleteBody =>
      'The encounter and all its combatants are deleted permanently.';

  @override
  String get combatStatusPlanning => 'Planning';

  @override
  String get combatStatusActive => 'In combat';

  @override
  String get combatStatusFinished => 'Finished';

  @override
  String combatRound(int round) {
    return 'Round $round';
  }

  @override
  String combatCombatantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count combatants',
      one: '1 combatant',
      zero: 'No combatants',
    );
    return '$_temp0';
  }

  @override
  String get combatNotFound => 'This encounter no longer exists.';

  @override
  String get combatAllEncounters => 'All encounters';

  @override
  String get combatStart => 'Start combat';

  @override
  String get combatEnd => 'End combat';

  @override
  String get combatNextTurn => 'Next turn';

  @override
  String get combatPreviousTurn => 'Previous turn';

  @override
  String get combatRollInitiative => 'Roll initiative';

  @override
  String get combatRollInitiativeHint =>
      'Rolls d20 + bonus for every monster; players keep their own values.';

  @override
  String combatTurnOf(String name) {
    return 'Turn: $name';
  }

  @override
  String get combatNotStarted => 'Combat has not started';

  @override
  String get combatAddFromWorld => 'Add from world';

  @override
  String get combatAddManually => 'Add manually';

  @override
  String get combatPickTitle => 'Add a creature or character';

  @override
  String combatQuantityTitle(String name) {
    return 'How many “$name”?';
  }

  @override
  String get combatNoCombatants => 'No combatants yet';

  @override
  String get combatNoCombatantsHint =>
      'Add creatures and characters from your world or enter them by hand.';

  @override
  String get combatInitiative => 'Initiative';

  @override
  String get combatInitiativeBonus => 'Initiative bonus';

  @override
  String get combatArmorClass => 'Armor class';

  @override
  String get combatAcShort => 'AC';

  @override
  String get combatHpMax => 'Max HP';

  @override
  String get combatHpCurrent => 'Current HP';

  @override
  String get combatHpTemp => 'Temp HP';

  @override
  String get combatAmountHint => 'HP';

  @override
  String get combatDamage => 'Damage';

  @override
  String get combatHeal => 'Heal';

  @override
  String get combatTemp => 'Temp';

  @override
  String get combatAddCondition => 'Condition';

  @override
  String combatConditionDurationTitle(String condition) {
    return 'Duration: $condition';
  }

  @override
  String get combatConditionRounds => 'Rounds (empty = until removed)';

  @override
  String get combatRemoveCondition => 'Remove condition';

  @override
  String get combatConcentration => 'Concentration';

  @override
  String get combatDefeated => 'Defeated';

  @override
  String get combatPlayer => 'Player character';

  @override
  String get combatEdit => 'Edit';

  @override
  String get combatRemove => 'Remove';

  @override
  String get combatEditCombatant => 'Edit combatant';

  @override
  String get combatAddCombatant => 'Add combatant';

  @override
  String get combatChallenge => 'Challenge rating';

  @override
  String get combatXp => 'XP';

  @override
  String get combatQuantity => 'Quantity';

  @override
  String get combatNotes => 'Notes';

  @override
  String get combatNotesHint => 'Tactics, terrain, loot…';

  @override
  String get combatDifficulty => 'Difficulty';

  @override
  String get combatRules => 'Rules';

  @override
  String get combatPartyLevels => 'Party levels';

  @override
  String get combatAddLevel => 'Level';

  @override
  String combatLevelChip(int level) {
    return 'Lv $level';
  }

  @override
  String get combatLevelLabel => 'Character level (1–20)';

  @override
  String combatMonsterXp(String xp) {
    return 'Monster XP: $xp';
  }

  @override
  String combatAdjustedXp(String xp, String multiplier) {
    return 'Adjusted XP: $xp (×$multiplier)';
  }

  @override
  String get combatNoParty => 'Add the party’s levels to rate this encounter.';

  @override
  String get combatRatingTrivial => 'Trivial';

  @override
  String get combatRatingLow => 'Low';

  @override
  String get combatRatingModerate => 'Moderate';

  @override
  String get combatRatingHigh => 'High';

  @override
  String get combatRatingBeyondHigh => 'Beyond high';

  @override
  String get combatRatingEasy => 'Easy';

  @override
  String get combatRatingMedium => 'Medium';

  @override
  String get combatRatingHard => 'Hard';

  @override
  String get combatRatingDeadly => 'Deadly';

  @override
  String combatConcentrationCheck(String name, int dc) {
    return '$name: concentration save DC $dc';
  }

  @override
  String combatDefeatedNotice(String name) {
    return '$name is defeated';
  }

  @override
  String get combatOpenEntry => 'Open entry';

  @override
  String get combatActions => 'Combatant actions';

  @override
  String get combatEncounterActions => 'Encounter actions';

  @override
  String get roleCustomLabel => 'Or type your own role';

  @override
  String importFilesFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files couldn’t be imported',
      one: '1 file couldn’t be imported',
    );
    return '$_temp0';
  }

  @override
  String get trashTitle => 'Trash';

  @override
  String get trashEmptyState =>
      'Trash is empty. Deleted entries wait here until you restore them or delete them for good.';

  @override
  String get trashEmptyAction => 'Empty trash';

  @override
  String get trashEmptyConfirmTitle => 'Empty the trash?';

  @override
  String trashEmptyConfirmBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count entries will be deleted for good, with their lore, images and links.',
      one: '1 entry will be deleted for good, with its lore, images and links.',
    );
    return '$_temp0';
  }

  @override
  String get trashDeleteForever => 'Delete forever';

  @override
  String trashDeleteForeverTitle(String name) {
    return 'Delete “$name” forever?';
  }

  @override
  String get trashDeleteForeverBody =>
      'Its lore, images and links are removed too. This can’t be undone.';

  @override
  String trashDeletedOn(String date) {
    return 'Deleted $date';
  }

  @override
  String trashMovedSnack(String name) {
    return '“$name” moved to trash';
  }

  @override
  String trashRestoredSnack(String name) {
    return '“$name” restored';
  }

  @override
  String get undo => 'Undo';

  @override
  String get tabDuplicate => 'Duplicate tab';

  @override
  String get tabClose => 'Close tab';

  @override
  String get tabCloseOthers => 'Close other tabs';

  @override
  String get tabCloseRight => 'Close tabs to the right';

  @override
  String get exportMarkdownTitle => 'Markdown notes (Obsidian)';

  @override
  String get exportMarkdownSubtitle =>
      'A zipped folder of linked notes with images — open it as an Obsidian vault or in any editor.';

  @override
  String get shareMarkdownText => 'GMH world notes (Markdown)';

  @override
  String get relationsTitle => 'Relations';

  @override
  String kindFieldsTitle(String kind) {
    return 'Custom fields: $kind';
  }

  @override
  String get kindFieldsHint =>
      'Fields added here appear on every entry of this kind in this world, after the built-in ones.';

  @override
  String get kindFieldsAction => 'Customize fields';

  @override
  String get tablesSearchHint => 'Search tables';

  @override
  String get tablesNewTable => 'New table';

  @override
  String get tablesImport => 'Import from text';

  @override
  String get tablesLibrary => 'Library';

  @override
  String get tablesOpenLibrary => 'Open the library';

  @override
  String get tablesEmptyTitle => 'No random tables yet';

  @override
  String get tablesEmptyHint =>
      'Start from a ready-made table in the library, write your own, or paste a list from a book.';

  @override
  String get tablesNoMatches => 'No tables match your search.';

  @override
  String get tablesNoFolder => 'Other tables';

  @override
  String tablesRowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows',
      one: '1 row',
    );
    return '$_temp0';
  }

  @override
  String get tablesWeighted => 'By weight';

  @override
  String tablesDefaultName(int number) {
    return 'Table $number';
  }

  @override
  String get tablesDescriptionLabel => 'Description';

  @override
  String get tablesFolderLabel => 'Folder';

  @override
  String get tablesFolderHint => 'e.g. Encounters';

  @override
  String get tablesFormulaLabel => 'Dice formula';

  @override
  String get tablesFormulaHint => 'e.g. 1d20 — empty rolls by weight';

  @override
  String get tablesFormulaInvalid => 'Not a valid dice formula';

  @override
  String get tablesEditTitle => 'Edit table';

  @override
  String get tablesEdit => 'Edit details';

  @override
  String get tablesDuplicate => 'Duplicate';

  @override
  String tablesCopyName(String name) {
    return '$name (copy)';
  }

  @override
  String tablesDeleteTitle(String name) {
    return 'Delete “$name”?';
  }

  @override
  String get tablesDeleteBody =>
      'The table and all its rows will be removed from this world.';

  @override
  String get tablesActions => 'Table actions';

  @override
  String get tablesAllTables => 'All tables';

  @override
  String get tablesMissing => 'This table no longer exists.';

  @override
  String get tablesRoll => 'Roll';

  @override
  String get tablesRollAgain => 'Roll again';

  @override
  String get tablesCopy => 'Copy';

  @override
  String get tablesCopied => 'Copied to clipboard';

  @override
  String get tablesResultEmpty => 'Roll to get a result.';

  @override
  String get tablesClamped => 'Outside every range — nearest row used';

  @override
  String get tablesRollLog => 'Roll log';

  @override
  String get tablesRollLogEmpty => 'Rolls made on this page appear here.';

  @override
  String get tablesClearLog => 'Clear log';

  @override
  String get tablesRows => 'Rows';

  @override
  String get tablesAddRow => 'Add row';

  @override
  String get tablesDeleteRow => 'Delete row';

  @override
  String get tablesAutoRanges => 'Auto ranges';

  @override
  String get tablesAutoRangesHint =>
      'Spread the rows over the formula by weight';

  @override
  String get tablesBulkEdit => 'Edit as text';

  @override
  String get tablesBulkEditTitle => 'Edit rows as text';

  @override
  String get tablesTextFormatHelp =>
      'One row per line: “1-3 | text”, “4: text”, “x3 text” for a weight, or plain text. Lines starting with # are ignored.';

  @override
  String get tablesImportTitle => 'Import a table from text';

  @override
  String get tablesImportRows => 'Rows';

  @override
  String tablesImportFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows found',
      one: '1 row found',
      zero: 'No rows found',
    );
    return '$_temp0';
  }

  @override
  String get tablesImportAction => 'Import';

  @override
  String get tablesApply => 'Apply';

  @override
  String get tablesRowsEmpty =>
      'No rows yet. Add one, or paste a whole list with “Edit as text”.';

  @override
  String tablesRowTextHint(String dice, String choice, String table) {
    return 'Text, $dice dice, $choice choices, $table rolls';
  }

  @override
  String get tablesFrom => 'From';

  @override
  String get tablesTo => 'To';

  @override
  String get tablesWeight => 'Weight';

  @override
  String get tablesDragToReorder => 'Drag to reorder';

  @override
  String get tablesIssueBadFormula => 'The dice formula cannot be rolled.';

  @override
  String get tablesIssueEmpty => 'The table has no rows with text.';

  @override
  String tablesIssueEmptyRow(int row) {
    return 'Row $row has no text.';
  }

  @override
  String tablesIssueMissingRange(int row) {
    return 'Row $row has no range.';
  }

  @override
  String tablesIssueInverted(int row) {
    return 'Row $row: the range runs backwards.';
  }

  @override
  String tablesIssueOutOfBounds(int row, String range) {
    return 'Row $row goes beyond what the formula can roll ($range).';
  }

  @override
  String tablesIssueGap(String range) {
    return 'Nothing covers $range.';
  }

  @override
  String tablesIssueOverlap(int first, int second, String range) {
    return 'Rows $first and $second overlap on $range.';
  }

  @override
  String get tablesFailNotFound => 'No table with this name';

  @override
  String get tablesFailCycle => 'Refers back to itself — stopped';

  @override
  String get tablesFailDepth => 'Nested too deep — stopped';

  @override
  String get tablesFailTooMany => 'Too many nested rolls — stopped';

  @override
  String get tablesFailEmpty => 'The table has no rows';

  @override
  String get tablesFailBadFormula => 'The formula cannot be rolled';

  @override
  String tablesChoice(int count) {
    return 'one of $count';
  }

  @override
  String get tablesFromLibrary => 'From the library';

  @override
  String get tablesLibraryTitle => 'Table library';

  @override
  String get tablesLibraryHint =>
      'Ready-made tables for every setting. Preview them, then add them to this world to edit.';

  @override
  String get tablesYourSetting => 'This world’s setting';

  @override
  String get tablesOtherSettings => 'Other settings';

  @override
  String tablesTableCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tables',
      one: '1 table',
    );
    return '$_temp0';
  }

  @override
  String get tablesPreview => 'Preview';

  @override
  String get tablesAddToWorld => 'Add to world';

  @override
  String get tablesInWorld => 'In this world';

  @override
  String get tablesAddDepsTitle => 'Add the referenced tables too?';

  @override
  String tablesAddDepsBody(String name) {
    return '“$name” rolls on these tables. Without them its results show a warning mark.';
  }

  @override
  String tablesAddedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Added $count tables',
      one: 'Added 1 table',
    );
    return '$_temp0';
  }

  @override
  String get tablesPreviewRoll => 'Try a roll';

  @override
  String get tablesWhy => 'How it was rolled';

  @override
  String get paletteHint =>
      'Jump to an entry, a section or a tool, or run a command…';

  @override
  String get paletteCommands => 'Commands';

  @override
  String get paletteEntries => 'Entries';

  @override
  String get paletteNoMatches => 'Nothing matches';

  @override
  String get paletteToggleTheme => 'Switch light / dark theme';

  @override
  String paletteOpenInTab(String name) {
    return 'Go to $name';
  }

  @override
  String get paletteTitle => 'Command palette';

  @override
  String get homeAtTheTable => 'At the table';

  @override
  String get homeYourSections => 'Your sections';

  @override
  String get menuDuplicateEntry => 'Duplicate';

  @override
  String entryCopyName(String name) {
    return '$name (copy)';
  }

  @override
  String get helpPacksTitle => 'Settings and styles';

  @override
  String get helpPacksBody =>
      'Every world has a setting: fantasy, cyberpunk, space opera, gothic or cosmic horror, post-apocalypse, steampunk, urban fantasy, wild west or wuxia. The setting recolors the whole app (light and dark), renames sections in its own vocabulary — Runners and Sectors in cyberpunk, Crew and Waypoints in space opera — and picks the random tables and generators that fit the genre. Change it any time in Settings → World; your data never changes, only how it is presented.';

  @override
  String get helpToolsTitle => 'At the table: GM tools';

  @override
  String get helpToolsBody =>
      'The tools live in the sidebar, on the dashboard and in the command palette. Dice Roller: type any notation (4d6kh3, 2d20kl1+5, 8d6!, 5d10>=8) or use a system preset — D&D checks, Call of Cthulhu, PbtA, Blades in the Dark, Fate, Year Zero, Savage Worlds, Cyberpunk RED; every roll is logged, and dice written in stat blocks are clickable. Combat Tracker: build encounters from your creatures and characters (HP, AC and CR come from their fields), roll initiative, apply damage and healing, track conditions with durations, and see encounter difficulty. Random Tables: write your own with dice ranges or weights, nest tables with [[Table name]], or add ready-made tables for your setting from the library. Generators: instant NPCs, names, settlements, taverns, hooks, factions, loot and rumors for your setting — keep the good ones and save them into the world with one click.';

  @override
  String get helpNavTitle => 'Fast navigation';

  @override
  String get helpNavBody =>
      'Ctrl+P opens the command palette: type part of a name to jump to an entry, a section or a tool, or run a command (new entry, light/dark theme, switch world). Ctrl+K goes to search. Pages open in browser-style tabs: Ctrl+T opens a new tab, Ctrl+W closes one, Ctrl+Tab cycles; right-click a tab to duplicate or close others, middle-click to close. Alt+← / Alt+→ and the mouse side buttons move through each tab\'s own history. Escape opens the pause menu (save, settings, exit).';

  @override
  String get helpFieldsTitle => 'Your own fields';

  @override
  String get helpFieldsBody =>
      'Built-in sections can carry extra fields for your game: open a section (Characters, Locations…) and click Customize fields in its toolbar. Add text, numbers, dates, lists, checklists or choices; they appear on every entry of that section in this world, after the built-in fields, and are included in search, the PDF book and the Markdown export. Custom sections define all of their fields in the section constructor.';

  @override
  String get helpTrashTitle => 'Trash, copies and exports';

  @override
  String get helpTrashBody =>
      'Deleting an entry moves it to the Trash (sidebar, or Settings → World) — right after deleting you can also press Undo. Restore it later or delete it for good. The entry menu can Duplicate an entry with its fields, tags, pictures and lore. Settings → Export writes a full archive (.gmhw, for backups and moving between devices), JSON, a printable PDF world book, or Markdown notes that open as an Obsidian vault with working [[links]]; GM-only fields are left out unless you include them.';

  @override
  String get newSessionAction => 'New session';

  @override
  String sessionNumberName(int number) {
    return 'Session $number';
  }
}
