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
}
