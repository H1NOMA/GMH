import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Game Master\'s Hub'**
  String get appTitle;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navGraph.
  ///
  /// In en, this message translates to:
  /// **'Graph View'**
  String get navGraph;

  /// No description provided for @navGraphShort.
  ///
  /// In en, this message translates to:
  /// **'Graph'**
  String get navGraphShort;

  /// No description provided for @navCampaigns.
  ///
  /// In en, this message translates to:
  /// **'Campaigns'**
  String get navCampaigns;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings & Backup'**
  String get navSettings;

  /// No description provided for @navSettingsShort.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettingsShort;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @sectionWorld.
  ///
  /// In en, this message translates to:
  /// **'WORLD'**
  String get sectionWorld;

  /// No description provided for @sectionLibrary.
  ///
  /// In en, this message translates to:
  /// **'LIBRARY'**
  String get sectionLibrary;

  /// No description provided for @switchWorld.
  ///
  /// In en, this message translates to:
  /// **'Switch world'**
  String get switchWorld;

  /// No description provided for @worldsTagline.
  ///
  /// In en, this message translates to:
  /// **'Your worlds, entirely yours — stored on this device.'**
  String get worldsTagline;

  /// No description provided for @worldsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load worlds: {error}'**
  String worldsLoadError(String error);

  /// No description provided for @worldsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No worlds yet. Forge your first one below.'**
  String get worldsEmpty;

  /// No description provided for @worldEdited.
  ///
  /// In en, this message translates to:
  /// **'Edited {when}'**
  String worldEdited(String when);

  /// No description provided for @createNewWorld.
  ///
  /// In en, this message translates to:
  /// **'Create New World'**
  String get createNewWorld;

  /// No description provided for @createWorldTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a New World'**
  String get createWorldTitle;

  /// No description provided for @worldNameLabel.
  ///
  /// In en, this message translates to:
  /// **'World name'**
  String get worldNameLabel;

  /// No description provided for @worldNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. The Aurion Realms'**
  String get worldNameHint;

  /// No description provided for @worldDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get worldDescriptionLabel;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @newButton.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newButton;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorGeneric(String error);

  /// No description provided for @errorNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty.'**
  String get errorNameEmpty;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnexpected;

  /// No description provided for @homeTheWorld.
  ///
  /// In en, this message translates to:
  /// **'The World'**
  String get homeTheWorld;

  /// No description provided for @homeLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get homeLibrary;

  /// No description provided for @homeFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get homeFavorites;

  /// No description provided for @homeRecentlyOpened.
  ///
  /// In en, this message translates to:
  /// **'Recently Opened'**
  String get homeRecentlyOpened;

  /// No description provided for @entriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No entries} one{1 entry} other{{count} entries}}'**
  String entriesCount(int count);

  /// No description provided for @filterHint.
  ///
  /// In en, this message translates to:
  /// **'Filter {plural}…'**
  String filterHint(String plural);

  /// No description provided for @favoritesOnly.
  ///
  /// In en, this message translates to:
  /// **'Favorites only'**
  String get favoritesOnly;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get showAll;

  /// No description provided for @sortTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortTooltip;

  /// No description provided for @sortRecentlyEdited.
  ///
  /// In en, this message translates to:
  /// **'Recently edited'**
  String get sortRecentlyEdited;

  /// No description provided for @sortNameAz.
  ///
  /// In en, this message translates to:
  /// **'Name (A–Z)'**
  String get sortNameAz;

  /// No description provided for @sortNewestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get sortNewestFirst;

  /// No description provided for @noEntriesOfKind.
  ///
  /// In en, this message translates to:
  /// **'No {plural} yet'**
  String noEntriesOfKind(String plural);

  /// No description provided for @newOfKind.
  ///
  /// In en, this message translates to:
  /// **'New {label}'**
  String newOfKind(String label);

  /// No description provided for @newEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'New Entry'**
  String get newEntryTitle;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @editEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Entry'**
  String get editEntryTitle;

  /// No description provided for @summaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryLabel;

  /// No description provided for @summaryHint.
  ///
  /// In en, this message translates to:
  /// **'One line shown in lists and search'**
  String get summaryHint;

  /// No description provided for @deleteEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteEntryTitle(String name);

  /// No description provided for @deleteEntryBody.
  ///
  /// In en, this message translates to:
  /// **'The entry is moved to trash; links to it are kept until it is purged.'**
  String get deleteEntryBody;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @menuEditNameSummary.
  ///
  /// In en, this message translates to:
  /// **'Edit name & summary'**
  String get menuEditNameSummary;

  /// No description provided for @menuShowInGraph.
  ///
  /// In en, this message translates to:
  /// **'Show in graph'**
  String get menuShowInGraph;

  /// No description provided for @entryGone.
  ///
  /// In en, this message translates to:
  /// **'This entry no longer exists.'**
  String get entryGone;

  /// No description provided for @tabDocument.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get tabDocument;

  /// No description provided for @tabDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get tabDetails;

  /// No description provided for @editorPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Write the lore… Use the @ button to link entries.'**
  String get editorPlaceholder;

  /// No description provided for @editorLinkEntity.
  ///
  /// In en, this message translates to:
  /// **'Link an entry (mention)'**
  String get editorLinkEntity;

  /// No description provided for @editorInsertImage.
  ///
  /// In en, this message translates to:
  /// **'Insert image'**
  String get editorInsertImage;

  /// No description provided for @editorAttachFile.
  ///
  /// In en, this message translates to:
  /// **'Attach a file into the text'**
  String get editorAttachFile;

  /// No description provided for @editorVersionHistory.
  ///
  /// In en, this message translates to:
  /// **'Version history'**
  String get editorVersionHistory;

  /// No description provided for @insertLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Insert link to entry'**
  String get insertLinkTitle;

  /// No description provided for @missingLink.
  ///
  /// In en, this message translates to:
  /// **'missing'**
  String get missingLink;

  /// No description provided for @versionHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Version History'**
  String get versionHistoryTitle;

  /// No description provided for @versionHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No snapshots yet. Versions are saved when you leave the editor or restore.'**
  String get versionHistoryEmpty;

  /// No description provided for @versionEmptyPreview.
  ///
  /// In en, this message translates to:
  /// **'(empty)'**
  String get versionEmptyPreview;

  /// No description provided for @versionBeforeRestore.
  ///
  /// In en, this message translates to:
  /// **'Before restore'**
  String get versionBeforeRestore;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search names, lore, tags…'**
  String get searchHint;

  /// No description provided for @searchAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get searchAll;

  /// No description provided for @searchNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get searchNoMatches;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'QUICK ACTIONS'**
  String get quickActions;

  /// No description provided for @quickNewEntry.
  ///
  /// In en, this message translates to:
  /// **'New entry'**
  String get quickNewEntry;

  /// No description provided for @quickOpenGraph.
  ///
  /// In en, this message translates to:
  /// **'Open graph'**
  String get quickOpenGraph;

  /// No description provided for @quickBackupExport.
  ///
  /// In en, this message translates to:
  /// **'Backup & export'**
  String get quickBackupExport;

  /// No description provided for @recentlyOpenedCaps.
  ///
  /// In en, this message translates to:
  /// **'RECENTLY OPENED'**
  String get recentlyOpenedCaps;

  /// No description provided for @graphTitle.
  ///
  /// In en, this message translates to:
  /// **'Graph View'**
  String get graphTitle;

  /// No description provided for @graphLocalTitle.
  ///
  /// In en, this message translates to:
  /// **'Local Graph'**
  String get graphLocalTitle;

  /// No description provided for @graphWholeWorld.
  ///
  /// In en, this message translates to:
  /// **'Whole world'**
  String get graphWholeWorld;

  /// No description provided for @graphFilterKinds.
  ///
  /// In en, this message translates to:
  /// **'Filter kinds'**
  String get graphFilterKinds;

  /// No description provided for @graphEmpty.
  ///
  /// In en, this message translates to:
  /// **'No connections yet.\nLink entries with @ mentions, relations or structured fields, and the web of your world will appear here.'**
  String get graphEmpty;

  /// No description provided for @graphTruncated.
  ///
  /// In en, this message translates to:
  /// **'Showing the {count} most connected entries. Focus an entry for its local graph.'**
  String graphTruncated(int count);

  /// No description provided for @campaignsTitle.
  ///
  /// In en, this message translates to:
  /// **'Campaigns'**
  String get campaignsTitle;

  /// No description provided for @switchCampaign.
  ///
  /// In en, this message translates to:
  /// **'Switch campaign'**
  String get switchCampaign;

  /// No description provided for @noCampaigns.
  ///
  /// In en, this message translates to:
  /// **'No campaigns yet'**
  String get noCampaigns;

  /// No description provided for @startCampaign.
  ///
  /// In en, this message translates to:
  /// **'Start a Campaign'**
  String get startCampaign;

  /// No description provided for @questBoard.
  ///
  /// In en, this message translates to:
  /// **'Quest Board'**
  String get questBoard;

  /// No description provided for @sessionLog.
  ///
  /// In en, this message translates to:
  /// **'Session Log'**
  String get sessionLog;

  /// No description provided for @noQuestsLinked.
  ///
  /// In en, this message translates to:
  /// **'No quests linked to this campaign yet. Create a quest and set its Campaign field.'**
  String get noQuestsLinked;

  /// No description provided for @noSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions recorded yet.'**
  String get noSessions;

  /// No description provided for @chapterLabel.
  ///
  /// In en, this message translates to:
  /// **'Chapter: {chapter}'**
  String chapterLabel(String chapter);

  /// No description provided for @noPlayers.
  ///
  /// In en, this message translates to:
  /// **'No players yet'**
  String get noPlayers;

  /// No description provided for @questsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 quest} other{{count} quests}}'**
  String questsCount(int count);

  /// No description provided for @sessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 session} other{{count} sessions}}'**
  String sessionsCount(int count);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings & Backup'**
  String get settingsTitle;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSection;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @exportSection.
  ///
  /// In en, this message translates to:
  /// **'Export \"{world}\"'**
  String exportSection(String world);

  /// No description provided for @exportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything stays on this device until you share it.'**
  String get exportSubtitle;

  /// No description provided for @exportArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Full project archive (.gmhw)'**
  String get exportArchiveTitle;

  /// No description provided for @exportArchiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Database + all media in one file. Use it to move between devices.'**
  String get exportArchiveSubtitle;

  /// No description provided for @exportJsonTitle.
  ///
  /// In en, this message translates to:
  /// **'JSON data export'**
  String get exportJsonTitle;

  /// No description provided for @exportJsonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All entries, links and metadata as readable JSON.'**
  String get exportJsonSubtitle;

  /// No description provided for @exportPdfTitle.
  ///
  /// In en, this message translates to:
  /// **'PDF world book'**
  String get exportPdfTitle;

  /// No description provided for @exportPdfSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A printable book of your world, chapter per category.'**
  String get exportPdfSubtitle;

  /// No description provided for @importSection.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importSection;

  /// No description provided for @importArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Import project archive'**
  String get importArchiveTitle;

  /// No description provided for @importArchiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restores a .gmhw file, including all media.'**
  String get importArchiveSubtitle;

  /// No description provided for @importPickArchive.
  ///
  /// In en, this message translates to:
  /// **'Choose a .gmhw archive'**
  String get importPickArchive;

  /// No description provided for @importConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Import project archive?'**
  String get importConfirmTitle;

  /// No description provided for @importConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'If a world from this archive already exists on this device, it will be completely replaced by the archive contents. This cannot be undone.'**
  String get importConfirmBody;

  /// No description provided for @backupsSection.
  ///
  /// In en, this message translates to:
  /// **'Backups'**
  String get backupsSection;

  /// No description provided for @backupsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A backup is taken automatically once a day when you open the app. The last {count} are kept.'**
  String backupsSubtitle(int count);

  /// No description provided for @backupNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get backupNow;

  /// No description provided for @noBackups.
  ///
  /// In en, this message translates to:
  /// **'No backups yet.'**
  String get noBackups;

  /// No description provided for @restoreBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get restoreBackupTitle;

  /// No description provided for @restoreBackupBody.
  ///
  /// In en, this message translates to:
  /// **'The world will be replaced with the contents of \"{file}\". A safety backup of the current state is taken first.'**
  String restoreBackupBody(String file);

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @aboutLocalFirst.
  ///
  /// In en, this message translates to:
  /// **'Local-first'**
  String get aboutLocalFirst;

  /// No description provided for @aboutLocalFirstBody.
  ///
  /// In en, this message translates to:
  /// **'All data is stored on this device. No account, no cloud, fully offline.'**
  String get aboutLocalFirstBody;

  /// No description provided for @backupSaved.
  ///
  /// In en, this message translates to:
  /// **'Backup saved.'**
  String get backupSaved;

  /// No description provided for @worldImported.
  ///
  /// In en, this message translates to:
  /// **'World imported.'**
  String get worldImported;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Backup restored.'**
  String get backupRestored;

  /// No description provided for @savedTo.
  ///
  /// In en, this message translates to:
  /// **'Saved to: {path}'**
  String savedTo(String path);

  /// No description provided for @shareArchiveText.
  ///
  /// In en, this message translates to:
  /// **'GMH world archive'**
  String get shareArchiveText;

  /// No description provided for @shareJsonText.
  ///
  /// In en, this message translates to:
  /// **'GMH world data (JSON)'**
  String get shareJsonText;

  /// No description provided for @sharePdfText.
  ///
  /// In en, this message translates to:
  /// **'GMH world book (PDF)'**
  String get sharePdfText;

  /// No description provided for @relationsCaps.
  ///
  /// In en, this message translates to:
  /// **'RELATIONS'**
  String get relationsCaps;

  /// No description provided for @backlinksCaps.
  ///
  /// In en, this message translates to:
  /// **'BACKLINKS'**
  String get backlinksCaps;

  /// No description provided for @addRelation.
  ///
  /// In en, this message translates to:
  /// **'Add relation'**
  String get addRelation;

  /// No description provided for @openInGraph.
  ///
  /// In en, this message translates to:
  /// **'Open in graph'**
  String get openInGraph;

  /// No description provided for @noOutgoingRelations.
  ///
  /// In en, this message translates to:
  /// **'No outgoing relations yet.'**
  String get noOutgoingRelations;

  /// No description provided for @noBacklinks.
  ///
  /// In en, this message translates to:
  /// **'Nothing links here yet.'**
  String get noBacklinks;

  /// No description provided for @relationToTitle.
  ///
  /// In en, this message translates to:
  /// **'Relation to \"{name}\"'**
  String relationToTitle(String name);

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get roleLabel;

  /// No description provided for @roleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. owner, ally, rival'**
  String get roleHint;

  /// No description provided for @fromDocumentMention.
  ///
  /// In en, this message translates to:
  /// **'From a document mention'**
  String get fromDocumentMention;

  /// No description provided for @fromStructuredField.
  ///
  /// In en, this message translates to:
  /// **'From a structured field'**
  String get fromStructuredField;

  /// No description provided for @roleMention.
  ///
  /// In en, this message translates to:
  /// **'Mentioned in'**
  String get roleMention;

  /// No description provided for @roleRelated.
  ///
  /// In en, this message translates to:
  /// **'Related to'**
  String get roleRelated;

  /// No description provided for @roleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwner;

  /// No description provided for @roleLocatedAt.
  ///
  /// In en, this message translates to:
  /// **'Located at'**
  String get roleLocatedAt;

  /// No description provided for @roleMemberOf.
  ///
  /// In en, this message translates to:
  /// **'Member of'**
  String get roleMemberOf;

  /// No description provided for @rolePartOf.
  ///
  /// In en, this message translates to:
  /// **'Part of'**
  String get rolePartOf;

  /// No description provided for @roleParticipatedIn.
  ///
  /// In en, this message translates to:
  /// **'Participated in'**
  String get roleParticipatedIn;

  /// No description provided for @roleCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get roleCreatedAt;

  /// No description provided for @roleQuestGiver.
  ///
  /// In en, this message translates to:
  /// **'Quest giver'**
  String get roleQuestGiver;

  /// No description provided for @roleAlly.
  ///
  /// In en, this message translates to:
  /// **'Ally'**
  String get roleAlly;

  /// No description provided for @roleFriend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get roleFriend;

  /// No description provided for @roleFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get roleFamily;

  /// No description provided for @roleEnemy.
  ///
  /// In en, this message translates to:
  /// **'Enemy'**
  String get roleEnemy;

  /// No description provided for @roleRival.
  ///
  /// In en, this message translates to:
  /// **'Rival'**
  String get roleRival;

  /// No description provided for @tabBiography.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get tabBiography;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @attachmentsCaps.
  ///
  /// In en, this message translates to:
  /// **'ATTACHMENTS'**
  String get attachmentsCaps;

  /// No description provided for @addFiles.
  ///
  /// In en, this message translates to:
  /// **'Add files'**
  String get addFiles;

  /// No description provided for @fromGallery.
  ///
  /// In en, this message translates to:
  /// **'From photo gallery'**
  String get fromGallery;

  /// No description provided for @noAttachments.
  ///
  /// In en, this message translates to:
  /// **'No attachments yet.'**
  String get noAttachments;

  /// No description provided for @dropFilesHere.
  ///
  /// In en, this message translates to:
  /// **'Drop files here to attach them'**
  String get dropFilesHere;

  /// No description provided for @setAsCover.
  ///
  /// In en, this message translates to:
  /// **'Set as cover image'**
  String get setAsCover;

  /// No description provided for @editCaption.
  ///
  /// In en, this message translates to:
  /// **'Edit caption'**
  String get editCaption;

  /// No description provided for @captionLabel.
  ///
  /// In en, this message translates to:
  /// **'Caption'**
  String get captionLabel;

  /// No description provided for @replaceFile.
  ///
  /// In en, this message translates to:
  /// **'Replace file'**
  String get replaceFile;

  /// No description provided for @deleteAttachment.
  ///
  /// In en, this message translates to:
  /// **'Remove attachment'**
  String get deleteAttachment;

  /// No description provided for @deleteAttachmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\"?'**
  String deleteAttachmentTitle(String name);

  /// No description provided for @deleteAttachmentBody.
  ///
  /// In en, this message translates to:
  /// **'The attachment is removed from this entry. The file is deleted from the vault when no other entry uses it.'**
  String get deleteAttachmentBody;

  /// No description provided for @renameAttachmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename attachment'**
  String get renameAttachmentTitle;

  /// No description provided for @previewUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Preview is not available for this file type. Open it with another app.'**
  String get previewUnavailable;

  /// No description provided for @openExternally.
  ///
  /// In en, this message translates to:
  /// **'Open with another app'**
  String get openExternally;

  /// No description provided for @attachmentsAdded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 file attached} other{{count} files attached}}'**
  String attachmentsAdded(int count);

  /// No description provided for @tagChip.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tagChip;

  /// No description provided for @addTagTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Tag'**
  String get addTagTitle;

  /// No description provided for @tagNameHint.
  ///
  /// In en, this message translates to:
  /// **'Tag name'**
  String get tagNameHint;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'Choose…'**
  String get choose;

  /// No description provided for @addToList.
  ///
  /// In en, this message translates to:
  /// **'Add to {label}'**
  String addToList(String label);

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @pickerTitleDefault.
  ///
  /// In en, this message translates to:
  /// **'Link an entry'**
  String get pickerTitleDefault;

  /// No description provided for @pickerSearchAll.
  ///
  /// In en, this message translates to:
  /// **'Search all entries…'**
  String get pickerSearchAll;

  /// No description provided for @pickerSearchKinds.
  ///
  /// In en, this message translates to:
  /// **'Search {kinds}…'**
  String pickerSearchKinds(String kinds);

  /// No description provided for @pickerNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matching entries'**
  String get pickerNoMatches;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(int count);

  /// No description provided for @sectionCategories.
  ///
  /// In en, this message translates to:
  /// **'MY CATEGORIES'**
  String get sectionCategories;

  /// No description provided for @manageCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get manageCategories;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @renameCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get renameCategory;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get deleteCategory;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete category “{name}”?'**
  String deleteCategoryTitle(String name);

  /// No description provided for @deleteCategoryBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Its {count} entry is preserved and moved to the Concept Archive.} other{Its {count} entries are preserved and moved to the Concept Archive.}}'**
  String deleteCategoryBody(int count);

  /// No description provided for @deleteCategoryBodyEmpty.
  ///
  /// In en, this message translates to:
  /// **'The category is empty; nothing else changes.'**
  String get deleteCategoryBodyEmpty;

  /// No description provided for @categoryNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryNameLabel;

  /// No description provided for @categoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Guilds, Kingdoms, Rituals…'**
  String get categoryNameHint;

  /// No description provided for @chooseIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get chooseIcon;

  /// No description provided for @noCategoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No custom categories yet. Create one below — it will behave exactly like the built-in sections.'**
  String get noCategoriesYet;

  /// No description provided for @kindCustomEntry.
  ///
  /// In en, this message translates to:
  /// **'Entry'**
  String get kindCustomEntry;

  /// No description provided for @tagManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Tag Manager'**
  String get tagManagerTitle;

  /// No description provided for @searchTagsHint.
  ///
  /// In en, this message translates to:
  /// **'Search tags…'**
  String get searchTagsHint;

  /// No description provided for @sortByName.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get sortByName;

  /// No description provided for @sortByCreated.
  ///
  /// In en, this message translates to:
  /// **'By creation date'**
  String get sortByCreated;

  /// No description provided for @sortByUsage.
  ///
  /// In en, this message translates to:
  /// **'By usage'**
  String get sortByUsage;

  /// No description provided for @newTag.
  ///
  /// In en, this message translates to:
  /// **'New tag'**
  String get newTag;

  /// No description provided for @mergeTagAction.
  ///
  /// In en, this message translates to:
  /// **'Merge into another tag…'**
  String get mergeTagAction;

  /// No description provided for @mergeTagTitle.
  ///
  /// In en, this message translates to:
  /// **'Merge “{name}”'**
  String mergeTagTitle(String name);

  /// No description provided for @mergeTagBody.
  ///
  /// In en, this message translates to:
  /// **'Every entry tagged “{name}” will receive the tag you choose below, and “{name}” will be deleted.'**
  String mergeTagBody(String name);

  /// No description provided for @changeColor.
  ///
  /// In en, this message translates to:
  /// **'Change color'**
  String get changeColor;

  /// No description provided for @deleteTagTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete tag “{name}”?'**
  String deleteTagTitle(String name);

  /// No description provided for @deleteTagBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No entries use this tag.} one{The tag is removed from {count} entry. The entry itself is kept.} other{The tag is removed from {count} entries. The entries themselves are kept.}}'**
  String deleteTagBody(int count);

  /// No description provided for @noTags.
  ///
  /// In en, this message translates to:
  /// **'No tags yet. Tags you add to entries appear here.'**
  String get noTags;

  /// No description provided for @noTagMatches.
  ///
  /// In en, this message translates to:
  /// **'No tags match your search.'**
  String get noTagMatches;

  /// No description provided for @appearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSection;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Match system'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @navBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get navBack;

  /// No description provided for @navForward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get navForward;

  /// No description provided for @kindCharacter.
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get kindCharacter;

  /// No description provided for @kindCharacterPlural.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get kindCharacterPlural;

  /// No description provided for @kindLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get kindLocation;

  /// No description provided for @kindLocationPlural.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get kindLocationPlural;

  /// No description provided for @kindItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get kindItem;

  /// No description provided for @kindItemPlural.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get kindItemPlural;

  /// No description provided for @kindCreature.
  ///
  /// In en, this message translates to:
  /// **'Creature'**
  String get kindCreature;

  /// No description provided for @kindCreaturePlural.
  ///
  /// In en, this message translates to:
  /// **'Creatures'**
  String get kindCreaturePlural;

  /// No description provided for @kindFaction.
  ///
  /// In en, this message translates to:
  /// **'Faction'**
  String get kindFaction;

  /// No description provided for @kindFactionPlural.
  ///
  /// In en, this message translates to:
  /// **'Factions'**
  String get kindFactionPlural;

  /// No description provided for @kindEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get kindEvent;

  /// No description provided for @kindEventPlural.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get kindEventPlural;

  /// No description provided for @kindEra.
  ///
  /// In en, this message translates to:
  /// **'Era'**
  String get kindEra;

  /// No description provided for @kindEraPlural.
  ///
  /// In en, this message translates to:
  /// **'Eras'**
  String get kindEraPlural;

  /// No description provided for @kindReligion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get kindReligion;

  /// No description provided for @kindReligionPlural.
  ///
  /// In en, this message translates to:
  /// **'Religions'**
  String get kindReligionPlural;

  /// No description provided for @kindMagicSystem.
  ///
  /// In en, this message translates to:
  /// **'Magic System'**
  String get kindMagicSystem;

  /// No description provided for @kindMagicSystemPlural.
  ///
  /// In en, this message translates to:
  /// **'Magic Systems'**
  String get kindMagicSystemPlural;

  /// No description provided for @kindTechnology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get kindTechnology;

  /// No description provided for @kindTechnologyPlural.
  ///
  /// In en, this message translates to:
  /// **'Technologies'**
  String get kindTechnologyPlural;

  /// No description provided for @kindConcept.
  ///
  /// In en, this message translates to:
  /// **'Concept'**
  String get kindConcept;

  /// No description provided for @kindConceptPlural.
  ///
  /// In en, this message translates to:
  /// **'Concept Archive'**
  String get kindConceptPlural;

  /// No description provided for @kindLoreDocument.
  ///
  /// In en, this message translates to:
  /// **'Lore Document'**
  String get kindLoreDocument;

  /// No description provided for @kindLoreDocumentPlural.
  ///
  /// In en, this message translates to:
  /// **'Lore Documents'**
  String get kindLoreDocumentPlural;

  /// No description provided for @kindCampaign.
  ///
  /// In en, this message translates to:
  /// **'Campaign'**
  String get kindCampaign;

  /// No description provided for @kindCampaignPlural.
  ///
  /// In en, this message translates to:
  /// **'Campaigns'**
  String get kindCampaignPlural;

  /// No description provided for @kindQuest.
  ///
  /// In en, this message translates to:
  /// **'Quest'**
  String get kindQuest;

  /// No description provided for @kindQuestPlural.
  ///
  /// In en, this message translates to:
  /// **'Quests'**
  String get kindQuestPlural;

  /// No description provided for @kindSession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get kindSession;

  /// No description provided for @kindSessionPlural.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get kindSessionPlural;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @ttgImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import TTG database'**
  String get ttgImportTitle;

  /// No description provided for @ttgImportIntro.
  ///
  /// In en, this message translates to:
  /// **'Migrate a complete TTG D&D database — campaigns, NPCs, monsters, spells, items, locations, factions, quests, media and every relationship — into a GMH world. Supported sources: SQLite databases (.db, .sqlite, .ttg), JSON exports and ZIP exports with media.'**
  String get ttgImportIntro;

  /// No description provided for @ttgPickFile.
  ///
  /// In en, this message translates to:
  /// **'Select TTG database…'**
  String get ttgPickFile;

  /// No description provided for @ttgPreviewCount.
  ///
  /// In en, this message translates to:
  /// **'{count} records detected'**
  String ttgPreviewCount(int count);

  /// No description provided for @ttgResumeBanner.
  ///
  /// In en, this message translates to:
  /// **'An interrupted import of this file was found. It will resume — records already imported are skipped.'**
  String get ttgResumeBanner;

  /// No description provided for @ttgWorldName.
  ///
  /// In en, this message translates to:
  /// **'World name'**
  String get ttgWorldName;

  /// No description provided for @ttgDuplicatesLabel.
  ///
  /// In en, this message translates to:
  /// **'If a record already exists'**
  String get ttgDuplicatesLabel;

  /// No description provided for @ttgSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get ttgSkip;

  /// No description provided for @ttgMerge.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get ttgMerge;

  /// No description provided for @ttgReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get ttgReplace;

  /// No description provided for @ttgAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask every time'**
  String get ttgAsk;

  /// No description provided for @ttgBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get ttgBack;

  /// No description provided for @ttgStart.
  ///
  /// In en, this message translates to:
  /// **'Start import'**
  String get ttgStart;

  /// No description provided for @ttgResume.
  ///
  /// In en, this message translates to:
  /// **'Resume import'**
  String get ttgResume;

  /// No description provided for @ttgPhaseReading.
  ///
  /// In en, this message translates to:
  /// **'Reading source'**
  String get ttgPhaseReading;

  /// No description provided for @ttgPhaseEntities.
  ///
  /// In en, this message translates to:
  /// **'Importing records'**
  String get ttgPhaseEntities;

  /// No description provided for @ttgPhaseLinks.
  ///
  /// In en, this message translates to:
  /// **'Rebuilding relationships'**
  String get ttgPhaseLinks;

  /// No description provided for @ttgPhaseValidating.
  ///
  /// In en, this message translates to:
  /// **'Validating'**
  String get ttgPhaseValidating;

  /// No description provided for @ttgPhaseIndexing.
  ///
  /// In en, this message translates to:
  /// **'Building search index'**
  String get ttgPhaseIndexing;

  /// No description provided for @ttgEta.
  ///
  /// In en, this message translates to:
  /// **'~{seconds}s left'**
  String ttgEta(int seconds);

  /// No description provided for @ttgErrorLog.
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get ttgErrorLog;

  /// No description provided for @ttgDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Migration complete'**
  String get ttgDoneTitle;

  /// No description provided for @ttgInterruptedTitle.
  ///
  /// In en, this message translates to:
  /// **'Import interrupted — you can resume it later'**
  String get ttgInterruptedTitle;

  /// No description provided for @ttgStatImported.
  ///
  /// In en, this message translates to:
  /// **'Records imported'**
  String get ttgStatImported;

  /// No description provided for @ttgStatLinks.
  ///
  /// In en, this message translates to:
  /// **'Links created'**
  String get ttgStatLinks;

  /// No description provided for @ttgStatMedia.
  ///
  /// In en, this message translates to:
  /// **'Media files imported'**
  String get ttgStatMedia;

  /// No description provided for @ttgStatDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents created'**
  String get ttgStatDocuments;

  /// No description provided for @ttgStatTags.
  ///
  /// In en, this message translates to:
  /// **'Tags created'**
  String get ttgStatTags;

  /// No description provided for @ttgStatRepaired.
  ///
  /// In en, this message translates to:
  /// **'References repaired'**
  String get ttgStatRepaired;

  /// No description provided for @ttgStatSkipped.
  ///
  /// In en, this message translates to:
  /// **'Duplicates skipped'**
  String get ttgStatSkipped;

  /// No description provided for @ttgOpenWorld.
  ///
  /// In en, this message translates to:
  /// **'Open world'**
  String get ttgOpenWorld;

  /// No description provided for @ttgDuplicateTitle.
  ///
  /// In en, this message translates to:
  /// **'Duplicate found'**
  String get ttgDuplicateTitle;

  /// No description provided for @ttgDuplicateBody.
  ///
  /// In en, this message translates to:
  /// **'“{name}” ({collection}) already exists in this world. What should happen?'**
  String ttgDuplicateBody(String name, String collection);

  /// No description provided for @ttgApplyToAll.
  ///
  /// In en, this message translates to:
  /// **'Apply to all remaining duplicates'**
  String get ttgApplyToAll;

  /// No description provided for @ttgSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Import TTG database'**
  String get ttgSettingsTitle;

  /// No description provided for @ttgSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Migrate a complete TTG D&D database into a new world: all records, relationships, formatting and media'**
  String get ttgSettingsSubtitle;

  /// No description provided for @cyberKindCharacter.
  ///
  /// In en, this message translates to:
  /// **'Runner'**
  String get cyberKindCharacter;

  /// No description provided for @cyberKindCharacterPlural.
  ///
  /// In en, this message translates to:
  /// **'Runners'**
  String get cyberKindCharacterPlural;

  /// No description provided for @cyberKindLocation.
  ///
  /// In en, this message translates to:
  /// **'Sector'**
  String get cyberKindLocation;

  /// No description provided for @cyberKindLocationPlural.
  ///
  /// In en, this message translates to:
  /// **'Sectors'**
  String get cyberKindLocationPlural;

  /// No description provided for @cyberKindItem.
  ///
  /// In en, this message translates to:
  /// **'Gear'**
  String get cyberKindItem;

  /// No description provided for @cyberKindItemPlural.
  ///
  /// In en, this message translates to:
  /// **'Gear & Tech'**
  String get cyberKindItemPlural;

  /// No description provided for @cyberKindCreature.
  ///
  /// In en, this message translates to:
  /// **'Cyberform'**
  String get cyberKindCreature;

  /// No description provided for @cyberKindCreaturePlural.
  ///
  /// In en, this message translates to:
  /// **'Cyberforms'**
  String get cyberKindCreaturePlural;

  /// No description provided for @cyberKindFaction.
  ///
  /// In en, this message translates to:
  /// **'Syndicate'**
  String get cyberKindFaction;

  /// No description provided for @cyberKindFactionPlural.
  ///
  /// In en, this message translates to:
  /// **'Corps & Gangs'**
  String get cyberKindFactionPlural;

  /// No description provided for @cyberKindEvent.
  ///
  /// In en, this message translates to:
  /// **'Incident'**
  String get cyberKindEvent;

  /// No description provided for @cyberKindEventPlural.
  ///
  /// In en, this message translates to:
  /// **'Incidents'**
  String get cyberKindEventPlural;

  /// No description provided for @cyberKindEra.
  ///
  /// In en, this message translates to:
  /// **'Epoch'**
  String get cyberKindEra;

  /// No description provided for @cyberKindEraPlural.
  ///
  /// In en, this message translates to:
  /// **'Epochs'**
  String get cyberKindEraPlural;

  /// No description provided for @cyberKindReligion.
  ///
  /// In en, this message translates to:
  /// **'Cult'**
  String get cyberKindReligion;

  /// No description provided for @cyberKindReligionPlural.
  ///
  /// In en, this message translates to:
  /// **'Cults'**
  String get cyberKindReligionPlural;

  /// No description provided for @cyberKindMagicSystem.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get cyberKindMagicSystem;

  /// No description provided for @cyberKindMagicSystemPlural.
  ///
  /// In en, this message translates to:
  /// **'Protocols'**
  String get cyberKindMagicSystemPlural;

  /// No description provided for @cyberKindTechnology.
  ///
  /// In en, this message translates to:
  /// **'Cyberware'**
  String get cyberKindTechnology;

  /// No description provided for @cyberKindTechnologyPlural.
  ///
  /// In en, this message translates to:
  /// **'Cyberware'**
  String get cyberKindTechnologyPlural;

  /// No description provided for @cyberKindConcept.
  ///
  /// In en, this message translates to:
  /// **'Data Fragment'**
  String get cyberKindConcept;

  /// No description provided for @cyberKindConceptPlural.
  ///
  /// In en, this message translates to:
  /// **'Data Vault'**
  String get cyberKindConceptPlural;

  /// No description provided for @cyberKindLoreDocument.
  ///
  /// In en, this message translates to:
  /// **'Data Shard'**
  String get cyberKindLoreDocument;

  /// No description provided for @cyberKindLoreDocumentPlural.
  ///
  /// In en, this message translates to:
  /// **'Data Shards'**
  String get cyberKindLoreDocumentPlural;

  /// No description provided for @cyberKindCampaign.
  ///
  /// In en, this message translates to:
  /// **'Operation'**
  String get cyberKindCampaign;

  /// No description provided for @cyberKindCampaignPlural.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get cyberKindCampaignPlural;

  /// No description provided for @cyberKindQuest.
  ///
  /// In en, this message translates to:
  /// **'Gig'**
  String get cyberKindQuest;

  /// No description provided for @cyberKindQuestPlural.
  ///
  /// In en, this message translates to:
  /// **'Gigs'**
  String get cyberKindQuestPlural;

  /// No description provided for @cyberKindSession.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get cyberKindSession;

  /// No description provided for @cyberKindSessionPlural.
  ///
  /// In en, this message translates to:
  /// **'Runs'**
  String get cyberKindSessionPlural;

  /// No description provided for @worldStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'World style'**
  String get worldStyleLabel;

  /// No description provided for @worldStyleFantasy.
  ///
  /// In en, this message translates to:
  /// **'Fantasy'**
  String get worldStyleFantasy;

  /// No description provided for @worldStyleFantasyHint.
  ///
  /// In en, this message translates to:
  /// **'Candle-lit parchment, classic vocabulary: Characters, Locations, Quests'**
  String get worldStyleFantasyHint;

  /// No description provided for @worldStyleCyberpunk.
  ///
  /// In en, this message translates to:
  /// **'Cyberpunk'**
  String get worldStyleCyberpunk;

  /// No description provided for @worldStyleCyberpunkHint.
  ///
  /// In en, this message translates to:
  /// **'Neon chrome and street slang: Runners, Sectors, Gigs'**
  String get worldStyleCyberpunkHint;

  /// No description provided for @viewAsGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get viewAsGrid;

  /// No description provided for @viewAsList.
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get viewAsList;

  /// No description provided for @blueprintFieldsSection.
  ///
  /// In en, this message translates to:
  /// **'Fields'**
  String get blueprintFieldsSection;

  /// No description provided for @constructorTitleNew.
  ///
  /// In en, this message translates to:
  /// **'Section Constructor'**
  String get constructorTitleNew;

  /// No description provided for @constructorTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Section Settings'**
  String get constructorTitleEdit;

  /// No description provided for @constructorModules.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get constructorModules;

  /// No description provided for @constructorModulesHint.
  ///
  /// In en, this message translates to:
  /// **'Add or remove the building blocks entries of this section will have.'**
  String get constructorModulesHint;

  /// No description provided for @moduleFields.
  ///
  /// In en, this message translates to:
  /// **'Structured fields'**
  String get moduleFields;

  /// No description provided for @moduleFieldsHint.
  ///
  /// In en, this message translates to:
  /// **'A form of fields you define below'**
  String get moduleFieldsHint;

  /// No description provided for @moduleDocument.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get moduleDocument;

  /// No description provided for @moduleDocumentHint.
  ///
  /// In en, this message translates to:
  /// **'Rich-text editor with links and images'**
  String get moduleDocumentHint;

  /// No description provided for @moduleGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get moduleGallery;

  /// No description provided for @moduleGalleryHint.
  ///
  /// In en, this message translates to:
  /// **'Image grid on every entry'**
  String get moduleGalleryHint;

  /// No description provided for @moduleAttachments.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get moduleAttachments;

  /// No description provided for @moduleAttachmentsHint.
  ///
  /// In en, this message translates to:
  /// **'Attached files of any type'**
  String get moduleAttachmentsHint;

  /// No description provided for @moduleTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get moduleTags;

  /// No description provided for @moduleTagsHint.
  ///
  /// In en, this message translates to:
  /// **'Tagging and tag filters'**
  String get moduleTagsHint;

  /// No description provided for @moduleRelations.
  ///
  /// In en, this message translates to:
  /// **'Relations'**
  String get moduleRelations;

  /// No description provided for @moduleRelationsHint.
  ///
  /// In en, this message translates to:
  /// **'Links to other entries and backlinks'**
  String get moduleRelationsHint;

  /// No description provided for @constructorFields.
  ///
  /// In en, this message translates to:
  /// **'Custom fields'**
  String get constructorFields;

  /// No description provided for @constructorFieldsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No fields yet — add the columns this section needs, e.g. “Level”, “School”, “Price”.'**
  String get constructorFieldsEmpty;

  /// No description provided for @addField.
  ///
  /// In en, this message translates to:
  /// **'Add field'**
  String get addField;

  /// No description provided for @editField.
  ///
  /// In en, this message translates to:
  /// **'Edit field'**
  String get editField;

  /// No description provided for @fieldNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Field name'**
  String get fieldNameLabel;

  /// No description provided for @fieldTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Field type'**
  String get fieldTypeLabel;

  /// No description provided for @fieldOptionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Options (comma-separated)'**
  String get fieldOptionsLabel;

  /// No description provided for @fieldOptionsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Common, Rare, Legendary'**
  String get fieldOptionsHint;

  /// No description provided for @fieldTypeText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get fieldTypeText;

  /// No description provided for @fieldTypeLongText.
  ///
  /// In en, this message translates to:
  /// **'Long text'**
  String get fieldTypeLongText;

  /// No description provided for @fieldTypeNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get fieldTypeNumber;

  /// No description provided for @fieldTypeSelect.
  ///
  /// In en, this message translates to:
  /// **'Choice list'**
  String get fieldTypeSelect;

  /// No description provided for @fieldTypeDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldTypeDate;

  /// No description provided for @fieldTypeChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get fieldTypeChecklist;

  /// No description provided for @fieldTypeStringList.
  ///
  /// In en, this message translates to:
  /// **'List of values'**
  String get fieldTypeStringList;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
