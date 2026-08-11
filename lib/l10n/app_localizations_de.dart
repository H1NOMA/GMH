// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Game Master\'s Hub';

  @override
  String get navDashboard => 'Weltübersicht';

  @override
  String get navSearch => 'Suche';

  @override
  String get navGraph => 'Graphansicht';

  @override
  String get navGraphShort => 'Graph';

  @override
  String get navCampaigns => 'Kampagnen';

  @override
  String get navSettings => 'Einstellungen & Backup';

  @override
  String get navSettingsShort => 'Einstellungen';

  @override
  String get navHome => 'Start';

  @override
  String get sectionWorld => 'WELT';

  @override
  String get sectionLibrary => 'BIBLIOTHEK';

  @override
  String get switchWorld => 'Welt wechseln';

  @override
  String get worldsTagline =>
      'Ihre Welten gehören nur Ihnen – alles bleibt auf diesem Gerät.';

  @override
  String worldsLoadError(String error) {
    return 'Welten konnten nicht geladen werden: $error';
  }

  @override
  String get worldsEmpty =>
      'Noch keine Welten. Erschaffen Sie unten Ihre erste.';

  @override
  String worldEdited(String when) {
    return 'Bearbeitet $when';
  }

  @override
  String get createNewWorld => 'Neue Welt erstellen';

  @override
  String get createWorldTitle => 'Neue Welt erstellen';

  @override
  String get worldNameLabel => 'Name der Welt';

  @override
  String get worldNameHint => 'z. B. Die Reiche von Aurion';

  @override
  String get worldDescriptionLabel => 'Beschreibung (optional)';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get create => 'Erstellen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get open => 'Öffnen';

  @override
  String get rename => 'Umbenennen';

  @override
  String get newButton => 'Neu';

  @override
  String errorGeneric(String error) {
    return 'Fehler: $error';
  }

  @override
  String get errorNameEmpty => 'Der Name darf nicht leer sein.';

  @override
  String get errorUnexpected =>
      'Etwas ist schiefgelaufen. Bitte erneut versuchen.';

  @override
  String get homeTheWorld => 'Die Welt';

  @override
  String get homeLibrary => 'Bibliothek';

  @override
  String get homeFavorites => 'Favoriten';

  @override
  String get homeRecentlyOpened => 'Zuletzt geöffnet';

  @override
  String entriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
      zero: 'Keine Einträge',
    );
    return '$_temp0';
  }

  @override
  String filterHint(String plural) {
    return '$plural filtern…';
  }

  @override
  String get favoritesOnly => 'Nur Favoriten';

  @override
  String get showAll => 'Alle anzeigen';

  @override
  String get sortTooltip => 'Sortieren';

  @override
  String get sortRecentlyEdited => 'Zuletzt bearbeitet';

  @override
  String get sortNameAz => 'Name (A–Z)';

  @override
  String get sortNewestFirst => 'Neueste zuerst';

  @override
  String noEntriesOfKind(String plural) {
    return 'Noch keine $plural';
  }

  @override
  String newOfKind(String label) {
    return 'Neu: $label';
  }

  @override
  String get newEntryTitle => 'Neuer Eintrag';

  @override
  String get typeLabel => 'Typ';

  @override
  String get nameLabel => 'Name';

  @override
  String get editEntryTitle => 'Eintrag bearbeiten';

  @override
  String get summaryLabel => 'Kurzbeschreibung';

  @override
  String get summaryHint => 'Eine Zeile für Listen und Suche';

  @override
  String deleteEntryTitle(String name) {
    return '„$name“ löschen?';
  }

  @override
  String get deleteEntryBody =>
      'Der Eintrag wandert in den Papierkorb; Verknüpfungen zu ihm bleiben bis zum endgültigen Löschen erhalten.';

  @override
  String get addToFavorites => 'Zu Favoriten hinzufügen';

  @override
  String get removeFromFavorites => 'Aus Favoriten entfernen';

  @override
  String get menuEditNameSummary => 'Name & Beschreibung bearbeiten';

  @override
  String get menuShowInGraph => 'Im Graphen anzeigen';

  @override
  String get entryGone => 'Dieser Eintrag existiert nicht mehr.';

  @override
  String get tabDocument => 'Dokument';

  @override
  String get tabDetails => 'Details';

  @override
  String get editorPlaceholder =>
      'Hier die Lore schreiben… Die @-Schaltfläche verknüpft Einträge.';

  @override
  String get editorLinkEntity => 'Eintrag verknüpfen (Erwähnung)';

  @override
  String get editorInsertImage => 'Bild einfügen';

  @override
  String get editorAttachFile => 'Datei in den Text anhängen';

  @override
  String get editorVersionHistory => 'Versionsverlauf';

  @override
  String get insertLinkTitle => 'Link zu einem Eintrag einfügen';

  @override
  String get missingLink => 'fehlt';

  @override
  String get versionHistoryTitle => 'Versionsverlauf';

  @override
  String get versionHistoryEmpty =>
      'Noch keine Schnappschüsse. Versionen werden beim Verlassen des Editors und beim Wiederherstellen gespeichert.';

  @override
  String get versionEmptyPreview => '(leer)';

  @override
  String get versionBeforeRestore => 'Vor der Wiederherstellung';

  @override
  String get searchHint => 'Namen, Lore, Tags durchsuchen…';

  @override
  String get searchAll => 'Alle';

  @override
  String get searchNoMatches => 'Keine Treffer';

  @override
  String get quickActions => 'SCHNELLAKTIONEN';

  @override
  String get quickNewEntry => 'Neuer Eintrag';

  @override
  String get quickOpenGraph => 'Graph öffnen';

  @override
  String get quickBackupExport => 'Backup & Export';

  @override
  String get recentlyOpenedCaps => 'ZULETZT GEÖFFNET';

  @override
  String get graphTitle => 'Graphansicht';

  @override
  String get graphLocalTitle => 'Lokaler Graph';

  @override
  String get graphWholeWorld => 'Ganze Welt';

  @override
  String get graphFilterKinds => 'Nach Typ filtern';

  @override
  String get graphEmpty =>
      'Noch keine Verbindungen.\nEinträge über @-Erwähnungen, Beziehungen oder strukturierte Felder verknüpfen – dann erscheint hier das Netz Ihrer Welt.';

  @override
  String graphTruncated(int count) {
    return 'Angezeigt werden die $count am stärksten vernetzten Einträge. Einen Eintrag fokussieren, um seinen lokalen Graphen zu sehen.';
  }

  @override
  String get campaignsTitle => 'Kampagnen';

  @override
  String get switchCampaign => 'Kampagne wechseln';

  @override
  String get noCampaigns => 'Noch keine Kampagnen';

  @override
  String get startCampaign => 'Kampagne starten';

  @override
  String get questBoard => 'Questtafel';

  @override
  String get sessionLog => 'Sitzungsprotokoll';

  @override
  String get noQuestsLinked =>
      'Mit dieser Kampagne sind noch keine Quests verknüpft. Eine Quest erstellen und ihr Kampagnen-Feld setzen.';

  @override
  String get noSessions => 'Noch keine Sitzungen aufgezeichnet.';

  @override
  String chapterLabel(String chapter) {
    return 'Kapitel: $chapter';
  }

  @override
  String get noPlayers => 'Noch keine Spieler';

  @override
  String questsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quests',
      one: '1 Quest',
    );
    return '$_temp0';
  }

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sitzungen',
      one: '1 Sitzung',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Einstellungen & Backup';

  @override
  String get languageSection => 'Sprache';

  @override
  String get languageSystem => 'Systemsprache';

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
    return '„$world“ exportieren';
  }

  @override
  String get exportSubtitle =>
      'Alles bleibt auf diesem Gerät, bis Sie es selbst teilen.';

  @override
  String get exportArchiveTitle => 'Vollständiges Projektarchiv (.gmhw)';

  @override
  String get exportArchiveSubtitle =>
      'Datenbank + alle Medien in einer Datei. Ideal für den Umzug zwischen Geräten.';

  @override
  String get exportJsonTitle => 'JSON-Datenexport';

  @override
  String get exportJsonSubtitle =>
      'Alle Einträge, Verknüpfungen und Metadaten als lesbares JSON.';

  @override
  String get exportPdfTitle => 'PDF-Weltenbuch';

  @override
  String get exportPdfSubtitle =>
      'Ein druckbares Buch Ihrer Welt, ein Kapitel pro Kategorie.';

  @override
  String get importSection => 'Import';

  @override
  String get importArchiveTitle => 'Projektarchiv importieren';

  @override
  String get importArchiveSubtitle =>
      'Stellt eine .gmhw-Datei samt aller Medien wieder her.';

  @override
  String get importPickArchive => '.gmhw-Archiv auswählen';

  @override
  String get backupsSection => 'Backups';

  @override
  String backupsSubtitle(int count) {
    return 'Beim Öffnen der App wird einmal täglich automatisch ein Backup erstellt. Die letzten $count werden aufbewahrt.';
  }

  @override
  String get backupNow => 'Jetzt sichern';

  @override
  String get noBackups => 'Noch keine Backups.';

  @override
  String get restoreBackupTitle => 'Dieses Backup wiederherstellen?';

  @override
  String restoreBackupBody(String file) {
    return 'Die Welt wird durch den Inhalt von „$file“ ersetzt. Zuvor wird automatisch ein Sicherheitsbackup des aktuellen Stands erstellt.';
  }

  @override
  String get aboutSection => 'Über die App';

  @override
  String get aboutLocalFirst => 'Local-first';

  @override
  String get aboutLocalFirstBody =>
      'Alle Daten liegen auf diesem Gerät. Kein Konto, keine Cloud, komplett offline.';

  @override
  String get backupSaved => 'Backup gespeichert.';

  @override
  String get worldImported => 'Welt importiert.';

  @override
  String get backupRestored => 'Backup wiederhergestellt.';

  @override
  String savedTo(String path) {
    return 'Gespeichert unter: $path';
  }

  @override
  String get shareArchiveText => 'GMH-Weltarchiv';

  @override
  String get shareJsonText => 'GMH-Weltdaten (JSON)';

  @override
  String get sharePdfText => 'GMH-Weltenbuch (PDF)';

  @override
  String get relationsCaps => 'BEZIEHUNGEN';

  @override
  String get backlinksCaps => 'RÜCKVERWEISE';

  @override
  String get addRelation => 'Beziehung hinzufügen';

  @override
  String get openInGraph => 'Im Graphen öffnen';

  @override
  String get noOutgoingRelations => 'Noch keine ausgehenden Beziehungen.';

  @override
  String get noBacklinks => 'Noch nichts verweist hierher.';

  @override
  String relationToTitle(String name) {
    return 'Beziehung zu „$name“';
  }

  @override
  String get roleLabel => 'Rolle';

  @override
  String get roleHint => 'z. B. Besitzer, Verbündeter, Rivale';

  @override
  String get fromDocumentMention => 'Aus einer Erwähnung im Dokument';

  @override
  String get fromStructuredField => 'Aus einem strukturierten Feld';

  @override
  String get roleMention => 'Erwähnt in';

  @override
  String get roleRelated => 'Verbunden mit';

  @override
  String get roleOwner => 'Besitzer';

  @override
  String get roleLocatedAt => 'Befindet sich in';

  @override
  String get roleMemberOf => 'Mitglied von';

  @override
  String get rolePartOf => 'Teil von';

  @override
  String get roleParticipatedIn => 'Beteiligt an';

  @override
  String get roleCreatedAt => 'Erschaffen in';

  @override
  String get roleQuestGiver => 'Auftraggeber';

  @override
  String get roleAlly => 'Verbündeter';

  @override
  String get roleFriend => 'Freund';

  @override
  String get roleFamily => 'Familie';

  @override
  String get roleEnemy => 'Feind';

  @override
  String get roleRival => 'Rivale';

  @override
  String get tabBiography => 'Biografie';

  @override
  String get tabProfile => 'Profil';

  @override
  String get attachmentsCaps => 'ANHÄNGE';

  @override
  String get addFiles => 'Dateien hinzufügen';

  @override
  String get fromGallery => 'Aus der Fotogalerie';

  @override
  String get noAttachments => 'Noch keine Anhänge.';

  @override
  String get dropFilesHere => 'Dateien hier ablegen, um sie anzuhängen';

  @override
  String get setAsCover => 'Als Titelbild festlegen';

  @override
  String get newTab => 'Neuer Tab';

  @override
  String get changeImage => 'Bild ändern';

  @override
  String get addImage => 'Bild hinzufügen';

  @override
  String get editCaption => 'Beschriftung bearbeiten';

  @override
  String get captionLabel => 'Beschriftung';

  @override
  String get replaceFile => 'Datei ersetzen';

  @override
  String get deleteAttachment => 'Anhang entfernen';

  @override
  String deleteAttachmentTitle(String name) {
    return '„$name“ entfernen?';
  }

  @override
  String get deleteAttachmentBody =>
      'Der Anhang wird aus diesem Eintrag entfernt. Die Datei wird aus dem Speicher gelöscht, sobald kein anderer Eintrag sie verwendet.';

  @override
  String get renameAttachmentTitle => 'Anhang umbenennen';

  @override
  String get previewUnavailable =>
      'Für diesen Dateityp ist keine Vorschau verfügbar. Mit einer anderen App öffnen.';

  @override
  String get openExternally => 'Mit anderer App öffnen';

  @override
  String attachmentsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien angehängt',
      one: '1 Datei angehängt',
    );
    return '$_temp0';
  }

  @override
  String get tagChip => 'Tag';

  @override
  String get addTagTitle => 'Tag hinzufügen';

  @override
  String get tagNameHint => 'Tag-Name';

  @override
  String get none => 'Keine';

  @override
  String get choose => 'Auswählen…';

  @override
  String addToList(String label) {
    return 'Zu „$label“ hinzufügen';
  }

  @override
  String get clear => 'Leeren';

  @override
  String get pickerTitleDefault => 'Eintrag verknüpfen';

  @override
  String get pickerSearchAll => 'Alle Einträge durchsuchen…';

  @override
  String pickerSearchKinds(String kinds) {
    return '$kinds durchsuchen…';
  }

  @override
  String get pickerNoMatches => 'Keine passenden Einträge';

  @override
  String get justNow => 'gerade eben';

  @override
  String minutesAgo(int count) {
    return 'vor $count Min.';
  }

  @override
  String hoursAgo(int count) {
    return 'vor $count Std.';
  }

  @override
  String daysAgo(int count) {
    return 'vor $count Tg.';
  }

  @override
  String get sectionCategories => 'MEINE KATEGORIEN';

  @override
  String get manageCategories => 'Kategorien verwalten';

  @override
  String get newCategory => 'Neue Kategorie';

  @override
  String get renameCategory => 'Kategorie bearbeiten';

  @override
  String get deleteCategory => 'Kategorie löschen';

  @override
  String deleteCategoryTitle(String name) {
    return 'Kategorie „$name“ löschen?';
  }

  @override
  String deleteCategoryBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Ihre $count Einträge bleiben erhalten und wandern ins Konzeptarchiv.',
      one: 'Ihr $count Eintrag bleibt erhalten und wandert ins Konzeptarchiv.',
    );
    return '$_temp0';
  }

  @override
  String get deleteCategoryBodyEmpty =>
      'Die Kategorie ist leer; sonst ändert sich nichts.';

  @override
  String get categoryNameLabel => 'Name der Kategorie';

  @override
  String get categoryNameHint => 'z. B. Gilden, Königreiche, Rituale…';

  @override
  String get chooseIcon => 'Symbol';

  @override
  String get noCategoriesYet =>
      'Noch keine eigenen Kategorien. Unten eine erstellen – sie verhält sich genau wie die eingebauten Bereiche.';

  @override
  String get kindCustomEntry => 'Eintrag';

  @override
  String get tagManagerTitle => 'Tag-Verwaltung';

  @override
  String get searchTagsHint => 'Tags durchsuchen…';

  @override
  String get sortByName => 'Alphabetisch';

  @override
  String get sortByCreated => 'Nach Erstellungsdatum';

  @override
  String get sortByUsage => 'Nach Verwendung';

  @override
  String get newTag => 'Neuer Tag';

  @override
  String get mergeTagAction => 'In anderen Tag zusammenführen…';

  @override
  String mergeTagTitle(String name) {
    return '„$name“ zusammenführen';
  }

  @override
  String mergeTagBody(String name) {
    return 'Jeder Eintrag mit dem Tag „$name“ erhält den unten gewählten Tag, und „$name“ wird gelöscht.';
  }

  @override
  String get changeColor => 'Farbe ändern';

  @override
  String deleteTagTitle(String name) {
    return 'Tag „$name“ löschen?';
  }

  @override
  String deleteTagBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Der Tag wird von $count Einträgen entfernt. Die Einträge selbst bleiben erhalten.',
      one:
          'Der Tag wird von $count Eintrag entfernt. Der Eintrag selbst bleibt erhalten.',
      zero: 'Kein Eintrag verwendet diesen Tag.',
    );
    return '$_temp0';
  }

  @override
  String get noTags =>
      'Noch keine Tags. Tags, die Einträgen hinzugefügt werden, erscheinen hier.';

  @override
  String get noTagMatches => 'Keine Tags passen zur Suche.';

  @override
  String get appearanceSection => 'Darstellung';

  @override
  String get themeSystem => 'Wie System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get navBack => 'Zurück';

  @override
  String get navForward => 'Vorwärts';

  @override
  String get kindCharacter => 'Charakter';

  @override
  String get kindCharacterPlural => 'Charaktere';

  @override
  String get kindLocation => 'Ort';

  @override
  String get kindLocationPlural => 'Orte';

  @override
  String get kindItem => 'Gegenstand';

  @override
  String get kindItemPlural => 'Gegenstände';

  @override
  String get kindCreature => 'Kreatur';

  @override
  String get kindCreaturePlural => 'Kreaturen';

  @override
  String get kindFaction => 'Fraktion';

  @override
  String get kindFactionPlural => 'Fraktionen';

  @override
  String get kindEvent => 'Ereignis';

  @override
  String get kindEventPlural => 'Ereignisse';

  @override
  String get kindEra => 'Ära';

  @override
  String get kindEraPlural => 'Ären';

  @override
  String get kindReligion => 'Religion';

  @override
  String get kindReligionPlural => 'Religionen';

  @override
  String get kindMagicSystem => 'Magiesystem';

  @override
  String get kindMagicSystemPlural => 'Magiesysteme';

  @override
  String get kindTechnology => 'Technologie';

  @override
  String get kindTechnologyPlural => 'Technologien';

  @override
  String get kindConcept => 'Konzept';

  @override
  String get kindConceptPlural => 'Konzeptarchiv';

  @override
  String get kindLoreDocument => 'Lore-Dokument';

  @override
  String get kindLoreDocumentPlural => 'Lore-Dokumente';

  @override
  String get kindCampaign => 'Kampagne';

  @override
  String get kindCampaignPlural => 'Kampagnen';

  @override
  String get kindQuest => 'Quest';

  @override
  String get kindQuestPlural => 'Quests';

  @override
  String get kindSession => 'Sitzung';

  @override
  String get kindSessionPlural => 'Sitzungen';

  @override
  String get close => 'Schließen';

  @override
  String get cyberKindCharacter => 'Runner';

  @override
  String get cyberKindCharacterPlural => 'Runner';

  @override
  String get cyberKindLocation => 'Sektor';

  @override
  String get cyberKindLocationPlural => 'Sektoren';

  @override
  String get cyberKindItem => 'Ausrüstung';

  @override
  String get cyberKindItemPlural => 'Ausrüstung & Tech';

  @override
  String get cyberKindCreature => 'Cyberform';

  @override
  String get cyberKindCreaturePlural => 'Cyberformen';

  @override
  String get cyberKindFaction => 'Syndikat';

  @override
  String get cyberKindFactionPlural => 'Konzerne & Gangs';

  @override
  String get cyberKindEvent => 'Zwischenfall';

  @override
  String get cyberKindEventPlural => 'Zwischenfälle';

  @override
  String get cyberKindEra => 'Epoche';

  @override
  String get cyberKindEraPlural => 'Epochen';

  @override
  String get cyberKindReligion => 'Kult';

  @override
  String get cyberKindReligionPlural => 'Kulte';

  @override
  String get cyberKindMagicSystem => 'Protokoll';

  @override
  String get cyberKindMagicSystemPlural => 'Protokolle';

  @override
  String get cyberKindTechnology => 'Cyberware';

  @override
  String get cyberKindTechnologyPlural => 'Cyberware';

  @override
  String get cyberKindConcept => 'Datenfragment';

  @override
  String get cyberKindConceptPlural => 'Datentresor';

  @override
  String get cyberKindLoreDocument => 'Daten-Splitter';

  @override
  String get cyberKindLoreDocumentPlural => 'Daten-Splitter';

  @override
  String get cyberKindCampaign => 'Operation';

  @override
  String get cyberKindCampaignPlural => 'Operationen';

  @override
  String get cyberKindQuest => 'Gig';

  @override
  String get cyberKindQuestPlural => 'Gigs';

  @override
  String get cyberKindSession => 'Run';

  @override
  String get cyberKindSessionPlural => 'Runs';

  @override
  String get worldStyleLabel => 'Weltstil';

  @override
  String get worldStyleFantasy => 'Fantasy';

  @override
  String get worldStyleFantasyHint =>
      'Pergament im Kerzenschein, klassisches Vokabular: Charaktere, Orte, Quests';

  @override
  String get worldStyleCyberpunk => 'Cyberpunk';

  @override
  String get worldStyleCyberpunkHint =>
      'Neon, Chrom und Straßenslang: Runner, Sektoren, Gigs';

  @override
  String get viewAsGrid => 'Rasteransicht';

  @override
  String get viewAsList => 'Listenansicht';

  @override
  String get blueprintFieldsSection => 'Felder';

  @override
  String get constructorTitleNew => 'Bereichs-Baukasten';

  @override
  String get constructorTitleEdit => 'Bereichseinstellungen';

  @override
  String get constructorModules => 'Module';

  @override
  String get constructorModulesHint =>
      'Bausteine hinzufügen oder entfernen, aus denen die Einträge dieses Bereichs bestehen.';

  @override
  String get moduleFields => 'Strukturierte Felder';

  @override
  String get moduleFieldsHint =>
      'Ein Formular aus den unten definierten Feldern';

  @override
  String get moduleDocument => 'Dokument';

  @override
  String get moduleDocumentHint => 'Rich-Text-Editor mit Links und Bildern';

  @override
  String get moduleGallery => 'Galerie';

  @override
  String get moduleGalleryHint => 'Bildraster bei jedem Eintrag';

  @override
  String get moduleAttachments => 'Dateien';

  @override
  String get moduleAttachmentsHint => 'Angehängte Dateien beliebigen Typs';

  @override
  String get moduleTags => 'Tags';

  @override
  String get moduleTagsHint => 'Tags und Tag-Filter';

  @override
  String get moduleRelations => 'Beziehungen';

  @override
  String get moduleRelationsHint =>
      'Links zu anderen Einträgen und Rückverweise';

  @override
  String get constructorFields => 'Eigene Felder';

  @override
  String get constructorFieldsEmpty =>
      'Noch keine Felder – die Spalten hinzufügen, die dieser Bereich braucht, z. B. „Stufe“, „Schule“, „Preis“.';

  @override
  String get addField => 'Feld hinzufügen';

  @override
  String get editField => 'Feld bearbeiten';

  @override
  String get fieldNameLabel => 'Feldname';

  @override
  String get fieldTypeLabel => 'Feldtyp';

  @override
  String get fieldOptionsLabel => 'Optionen (durch Komma getrennt)';

  @override
  String get fieldOptionsHint => 'z. B. Gewöhnlich, Selten, Legendär';

  @override
  String get fieldTypeText => 'Text';

  @override
  String get fieldTypeLongText => 'Langer Text';

  @override
  String get fieldTypeNumber => 'Zahl';

  @override
  String get fieldTypeSelect => 'Auswahlliste';

  @override
  String get fieldTypeDate => 'Datum';

  @override
  String get fieldTypeChecklist => 'Checkliste';

  @override
  String get fieldTypeStringList => 'Werteliste';

  @override
  String get pauseSaveProject => 'Projekt speichern';

  @override
  String get pauseExit => 'Beenden';

  @override
  String get helpTitle => 'Benutzerhandbuch';

  @override
  String get helpSettingsSubtitle =>
      'Das eingebaute Handbuch: wo alles ist und wie es funktioniert';

  @override
  String get helpIntroBody =>
      'Game Master\'s Hub ist ein Offline-Arbeitsplatz für Spielleiter: Welten, Charaktere, Orte, Kampagnen und Lore liegen auf diesem Gerät und sind zu einem begehbaren Netz verknüpft. Dieses Handbuch führt durch jeden Teil der App – die Abbildungen unten sind schematische Ansichten der echten Bildschirme, und die nummerierten Markierungen werden unter jedem Bild erklärt.';

  @override
  String get helpWorldsTitle => 'Welten & Weltstile';

  @override
  String get helpWorldsBody =>
      'Alles beginnt mit einer Welt – einem vollständig eigenständigen Projekt mit eigenen Einträgen, Tags und Kampagnen. Die Weltauswahl öffnet sich beim Start; das Globus-Symbol in der Seitenleiste führt jederzeit dorthin zurück. Beim Erstellen einer Welt wird ihr Stil gewählt: Fantasy (Pergament und klassische Begriffe – Charaktere, Orte, Quests) oder Cyberpunk (Neonpalette und Straßenslang – Runner, Sektoren, Gigs). Der Stil verändert das gesamte Erscheinungsbild und Vokabular der jeweiligen Welt und kann pro Welt unterschiedlich sein. Jede Welt merkt sich, wo Sie aufgehört haben, und öffnet sich genau dort wieder.';

  @override
  String get helpShellTitle => 'Navigation & Seitenleiste';

  @override
  String get helpShellBody =>
      'Die linke Seitenleiste ist die Kommandozentrale. Sie zeigt die Hauptseiten, die Bereiche „Welt“ und „Bibliothek“ mit Live-Zählern und die eigenen Kategorien. Eine Registerkarte gedrückt halten und ziehen, um eine Gruppe neu zu ordnen – die Reihenfolge wird pro Welt gespeichert. Auf Tablets schrumpft die Seitenleiste zu einer schmalen Leiste, auf Telefonen zur unteren Navigationsleiste.';

  @override
  String get helpShellLegend1 =>
      'Weltwechsler – auf die Kopfzeile tippen, um zur Weltauswahl zurückzukehren.';

  @override
  String get helpShellLegend2 =>
      'Zurück / Vorwärts – ein Verlauf wie im Browser über alles Besuchte. Alt+← / Alt+→ funktionieren überall.';

  @override
  String get helpShellLegend3 =>
      'Bereichs-Tabs mit Live-Zählern. Gedrückt halten und ziehen, um die Reihenfolge zu ändern; sie bleibt gespeichert.';

  @override
  String get helpShellLegend4 =>
      'Listensteuerung – Filterfeld, Raster/Liste-Umschalter, Sortiermenü und Favoritenfilter für den offenen Bereich.';

  @override
  String get helpShellLegend5 =>
      'Eintragskarten zeigen die Kurzbeschreibung und Kontext-Chips: Status, Volk, Seltenheit, Daten – was zum Bereich passt.';

  @override
  String get helpShellLegend6 =>
      'Neuer Eintrag – erstellt einen Eintrag im gerade geöffneten Bereich.';

  @override
  String get helpEntryTitle => 'Einträge: Dokument, Felder & Anhänge';

  @override
  String get helpEntryBody =>
      'Jeder Eintrag ist eine Seite mit einem Rich-Text-Dokument und einer strukturierten Seitenleiste. Der Editor unterstützt Überschriften, Listen, Zitate, Bilder (direkt in den Text eingefügt oder gezogen), Dateianhänge und einen Versionsverlauf (das Uhr-Symbol in der Werkzeugleiste). @ tippen oder die Erwähnen-Schaltfläche drücken, um einen anderen Eintrag direkt im Text zu verknüpfen – Links wirken in beide Richtungen und speisen den Graphen. Die Seitenleiste enthält die Vorlagenfelder des Eintragstyps, Tags, Beziehungen mit Rückverweisen und die Galerie.';

  @override
  String get helpEntryLegend1 =>
      'Name – anklicken zum Umbenennen; der Stern markiert Favoriten.';

  @override
  String get helpEntryLegend2 =>
      'Editor-Werkzeugleiste: Formatierung, Ausrichtung, @-Erwähnung, Bild einfügen, Datei anhängen, Versionsverlauf.';

  @override
  String get helpEntryLegend3 =>
      'Eine Erwähnung eines anderen Eintrags im Text – anklicken, um dorthin zu springen; sie erzeugt zugleich einen Rückverweis.';

  @override
  String get helpEntryLegend4 =>
      'Strukturierte Felder des Eintragstyps (oder des eigenen Bereichs-Baukastens).';

  @override
  String get helpEntryLegend5 =>
      'Galerie und Dateianhänge – Dateien irgendwo auf der Seite ablegen, um sie anzuhängen.';

  @override
  String get helpProfileTitle => 'Charakterprofile';

  @override
  String get helpProfileBody =>
      'Charaktere öffnen sich als vollständiges Profil mit Registerkarten: Allgemeines, Biografie, Werte mit einem Attributsraster im D&D-Stil und abgeleiteten Modifikatoren, Überzeugungen, Beziehungen (Verbündete, Feinde, Fraktionen – alles echte Verknüpfungen), Inventar, Fähigkeiten & Magie, Zeitleiste und Notizen. Das Porträt stammt vom Titelbild des Eintrags – jedes Galeriebild lässt sich über sein Menü (langes Drücken) als Titelbild festlegen. Jede ausgefüllte Beziehung erscheint im Graphen und als Rückverweis beim Zieleintrag.';

  @override
  String get helpCampaignsTitle => 'Kampagnen, Quests & Sitzungen';

  @override
  String get helpCampaignsBody =>
      'Die Seite „Kampagnen“ ist das Dashboard für den Spieltisch. Die aktive Kampagne wird oben rechts im Auswahlmenü gewählt – die Wahl wird pro Welt gespeichert. Die Questtafel zeigt alle Quests, deren Kampagnen-Feld auf die gewählte Kampagne zeigt, gruppiert nach Status; das Sitzungsprotokoll sammelt Sitzungseinträge auf dieselbe Weise. Quests und Sitzungen lassen sich direkt von dieser Seite aus erstellen – die Verknüpfung zur Kampagne wird automatisch gesetzt.';

  @override
  String get helpSearchTitle => 'Suche & Tags';

  @override
  String get helpSearchBody =>
      'Die Suche (die Lupe in der Seitenleiste) ist eine sofortige Volltextsuche über Namen, Kurzbeschreibungen, Dokumente und Tags. Filter-Chips grenzen die Ergebnisse auf einen Bereich oder eine Kategorie ein. Tags werden in der Tag-Verwaltung gepflegt – erreichbar über die Seitenleiste oder die Schnellaktionen der Suche: umbenennen, umfärben, Duplikate zusammenführen und löschen, jeweils mit Live-Zählern der Verwendung. Jede Liste lässt sich außerdem nach Tag und Favoriten filtern.';

  @override
  String get helpGraphTitle => 'Beziehungsgraph';

  @override
  String get helpGraphBody =>
      'Der Graph zeigt die Welt als lebendiges Netz: Jede Erwähnung, Beziehung und jeder strukturierte Verweis wird zu einer Kante. Die Farben folgen den Eintragstypen, die Knotengröße der Zahl der Verbindungen. Einen Knoten antippen, um seinen Eintrag zu öffnen, oder bei einem Eintrag „Im Graphen anzeigen“ wählen, um seine lokale Umgebung zu sehen. Der Typfilter in der Werkzeugleiste blendet gerade nicht benötigte Kategorien aus.';

  @override
  String get helpConstructorTitle => 'Eigene Bereiche & der Baukasten';

  @override
  String get helpConstructorBody =>
      'Neben den eingebauten Bereichen lassen sich eigene erstellen – Gilden, Zauber, Rezepte, was immer nötig ist. Ein eigener Bereich verhält sich genau wie ein eingebauter: Seitenleisten-Tab mit Zähler, Dashboard-Kachel, Suchfilter, Graphfarben und PDF-Kapitel. Der Bereichs-Baukasten bestimmt, wie seine Einträge aussehen: Module ein- oder ausschalten und eigene Felder in sieben Typen definieren. Beim Löschen einer Kategorie gehen niemals Einträge verloren – sie wandern ins Konzeptarchiv.';

  @override
  String get helpConstructorLegend1 =>
      'Module – die Bausteine, aus denen eine Eintragsseite besteht. Deaktivierte Module verschwinden vollständig.';

  @override
  String get helpConstructorLegend2 =>
      'Eigene Felder mit Typen: Text, langer Text, Zahl, Auswahlliste, Datum, Checkliste, Werteliste. Zum Umordnen ziehen.';

  @override
  String get helpConstructorLegend3 =>
      'Feld hinzufügen – die ersten Felder werden zugleich zu den Chips auf den Karten des Bereichs.';

  @override
  String get helpBackupTitle => 'Backups & Gerätewechsel';

  @override
  String get helpBackupBody =>
      'Alles wird lokal gespeichert – kein Konto, keine Cloud. Die App erstellt einmal täglich ein automatisches Backup; in den Einstellungen geht das jederzeit auch manuell. Zum Umziehen oder Teilen einer Welt ein .gmhw-Archiv exportieren: eine Datei mit der Datenbank und allen Medien. Der Import auf einem anderen Gerät stellt die Welt exakt wieder her, samt eigener Bereiche und Stile. JSON-Export und das druckbare PDF-Weltenbuch finden sich ebenfalls in den Einstellungen.';

  @override
  String get helpTipsTitle => 'Tipps & Tastenkürzel';

  @override
  String get helpTipsBody =>
      'Alt+← / Alt+→ – zurück und vorwärts navigieren. Im Editor @ tippen, um beim Schreiben Einträge zu verknüpfen. Seitenleisten-Tabs, Baukasten-Felder oder Galeriekacheln lange drücken und ziehen, um sie umzuordnen. Rechtsklick (oder langes Drücken) auf einen Anhang öffnet Umbenennen, Ersetzen und Titelbild. Der Raster/Liste-Umschalter wird pro Bereich gespeichert. Auch Sortierung, Filter und die gewählte Kampagne werden gemerkt – die App öffnet sich immer dort, wo Sie aufgehört haben. Strg+K springt direkt zur Suche; die Seitentasten der Maus blättern durch den Verlauf, und die Navigationspfeile sitzen oben links auf jeder Seite.';

  @override
  String get helpScreenshotCaption =>
      'Bildschirmfoto der App (englische Oberfläche)';

  @override
  String get helpFigureCaption => 'Schematische Ansicht des echten Bildschirms';
}
