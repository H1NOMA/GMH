// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Game Master\'s Hub';

  @override
  String get navDashboard => 'Tableau de bord';

  @override
  String get navSearch => 'Recherche';

  @override
  String get navGraph => 'Graphe des liens';

  @override
  String get navGraphShort => 'Graphe';

  @override
  String get navCampaigns => 'Campagnes';

  @override
  String get navSettings => 'Paramètres et sauvegardes';

  @override
  String get navSettingsShort => 'Paramètres';

  @override
  String get navHome => 'Accueil';

  @override
  String get sectionWorld => 'MONDE';

  @override
  String get sectionLibrary => 'BIBLIOTHÈQUE';

  @override
  String get switchWorld => 'Changer de monde';

  @override
  String get worldsTagline =>
      'Vos mondes n\'appartiennent qu\'à vous — tout est stocké sur cet appareil.';

  @override
  String worldsLoadError(String error) {
    return 'Impossible de charger les mondes : $error';
  }

  @override
  String get worldsEmpty =>
      'Aucun monde pour l\'instant. Forgez le premier ci-dessous.';

  @override
  String worldEdited(String when) {
    return 'Modifié $when';
  }

  @override
  String get createNewWorld => 'Créer un nouveau monde';

  @override
  String get createWorldTitle => 'Création d\'un nouveau monde';

  @override
  String get worldNameLabel => 'Nom du monde';

  @override
  String get worldNameHint => 'ex. Les Royaumes d\'Aurion';

  @override
  String get worldDescriptionLabel => 'Description (facultatif)';

  @override
  String get cancel => 'Annuler';

  @override
  String get create => 'Créer';

  @override
  String get add => 'Ajouter';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get restore => 'Restaurer';

  @override
  String get open => 'Ouvrir';

  @override
  String get rename => 'Renommer';

  @override
  String get newButton => 'Nouveau';

  @override
  String errorGeneric(String error) {
    return 'Erreur : $error';
  }

  @override
  String get errorNameEmpty => 'Le nom ne peut pas être vide.';

  @override
  String get errorUnexpected => 'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get homeTheWorld => 'Le Monde';

  @override
  String get homeLibrary => 'Bibliothèque';

  @override
  String get homeFavorites => 'Favoris';

  @override
  String get homeRecentlyOpened => 'Ouverts récemment';

  @override
  String entriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entrées',
      one: '1 entrée',
      zero: 'Aucune entrée',
    );
    return '$_temp0';
  }

  @override
  String filterHint(String plural) {
    return 'Filtrer : $plural…';
  }

  @override
  String get favoritesOnly => 'Favoris uniquement';

  @override
  String get showAll => 'Tout afficher';

  @override
  String get sortTooltip => 'Trier';

  @override
  String get sortRecentlyEdited => 'Modifiés récemment';

  @override
  String get sortNameAz => 'Nom (A–Z)';

  @override
  String get sortNewestFirst => 'Plus récents d\'abord';

  @override
  String noEntriesOfKind(String plural) {
    return 'La section « $plural » est encore vide';
  }

  @override
  String newOfKind(String label) {
    return 'Créer : $label';
  }

  @override
  String get newEntryTitle => 'Nouvelle entrée';

  @override
  String get typeLabel => 'Type';

  @override
  String get nameLabel => 'Nom';

  @override
  String get editEntryTitle => 'Modifier l\'entrée';

  @override
  String get summaryLabel => 'Résumé';

  @override
  String get summaryHint =>
      'Une ligne affichée dans les listes et la recherche';

  @override
  String deleteEntryTitle(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get deleteEntryBody =>
      'L\'entrée est déplacée vers la corbeille ; ses liens sont conservés jusqu\'à sa suppression définitive.';

  @override
  String get addToFavorites => 'Ajouter aux favoris';

  @override
  String get removeFromFavorites => 'Retirer des favoris';

  @override
  String get menuEditNameSummary => 'Modifier le nom et le résumé';

  @override
  String get menuShowInGraph => 'Afficher dans le graphe';

  @override
  String get entryGone => 'Cette entrée n\'existe plus.';

  @override
  String get tabDocument => 'Document';

  @override
  String get tabDetails => 'Détails';

  @override
  String get editorPlaceholder =>
      'Écrivez votre histoire… Le bouton @ permet de lier des entrées.';

  @override
  String get editorLinkEntity => 'Lier une entrée (mention)';

  @override
  String get editorInsertImage => 'Insérer une image';

  @override
  String get editorAttachFile => 'Joindre un fichier dans le texte';

  @override
  String get editorVersionHistory => 'Historique des versions';

  @override
  String get insertLinkTitle => 'Insérer un lien vers une entrée';

  @override
  String get missingLink => 'introuvable';

  @override
  String get versionHistoryTitle => 'Historique des versions';

  @override
  String get versionHistoryEmpty =>
      'Aucun instantané pour l\'instant. Les versions sont enregistrées quand vous quittez l\'éditeur ou restaurez.';

  @override
  String get versionEmptyPreview => '(vide)';

  @override
  String get versionBeforeRestore => 'Avant restauration';

  @override
  String get searchHint => 'Rechercher noms, textes, tags…';

  @override
  String get searchAll => 'Tout';

  @override
  String get searchNoMatches => 'Aucun résultat';

  @override
  String get quickActions => 'ACTIONS RAPIDES';

  @override
  String get quickNewEntry => 'Nouvelle entrée';

  @override
  String get quickOpenGraph => 'Ouvrir le graphe';

  @override
  String get quickBackupExport => 'Sauvegarde et export';

  @override
  String get recentlyOpenedCaps => 'OUVERTS RÉCEMMENT';

  @override
  String get graphTitle => 'Graphe des liens';

  @override
  String get graphLocalTitle => 'Graphe local';

  @override
  String get graphWholeWorld => 'Monde entier';

  @override
  String get graphFilterKinds => 'Filtrer les types';

  @override
  String get graphEmpty =>
      'Aucun lien pour l\'instant.\nReliez des entrées avec des mentions @, des relations ou des champs structurés, et la toile de votre monde apparaîtra ici.';

  @override
  String graphTruncated(int count) {
    return 'Affichage des $count entrées les plus connectées. Ouvrez une entrée pour voir son graphe local.';
  }

  @override
  String get campaignsTitle => 'Campagnes';

  @override
  String get switchCampaign => 'Changer de campagne';

  @override
  String get noCampaigns => 'Aucune campagne pour l\'instant';

  @override
  String get startCampaign => 'Commencer une campagne';

  @override
  String get questBoard => 'Tableau des quêtes';

  @override
  String get sessionLog => 'Journal des sessions';

  @override
  String get noQuestsLinked =>
      'Aucune quête n\'est encore liée à cette campagne. Créez une quête et renseignez son champ « Campagne ».';

  @override
  String get noSessions => 'Aucune session enregistrée pour l\'instant.';

  @override
  String chapterLabel(String chapter) {
    return 'Chapitre : $chapter';
  }

  @override
  String get noPlayers => 'Aucun joueur pour l\'instant';

  @override
  String questsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count quêtes',
      one: '$count quête',
    );
    return '$_temp0';
  }

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions',
      one: '$count session',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Paramètres et sauvegardes';

  @override
  String get languageSection => 'Langue';

  @override
  String get languageSystem => 'Langue du système';

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
    return 'Exporter « $world »';
  }

  @override
  String get exportSubtitle =>
      'Tout reste sur cet appareil tant que vous ne le partagez pas.';

  @override
  String get exportArchiveTitle => 'Archive complète du projet (.gmhw)';

  @override
  String get exportArchiveSubtitle =>
      'Base de données et tous les médias dans un seul fichier. Idéal pour changer d\'appareil.';

  @override
  String get exportJsonTitle => 'Export des données en JSON';

  @override
  String get exportJsonSubtitle =>
      'Toutes les entrées, liens et métadonnées en JSON lisible.';

  @override
  String get exportPdfTitle => 'Livre du monde en PDF';

  @override
  String get exportPdfSubtitle =>
      'Un livre imprimable de votre monde, un chapitre par catégorie.';

  @override
  String get importSection => 'Importer';

  @override
  String get importArchiveTitle => 'Importer une archive de projet';

  @override
  String get importArchiveSubtitle =>
      'Restaure un fichier .gmhw, y compris tous les médias.';

  @override
  String get importPickArchive => 'Choisir une archive .gmhw';

  @override
  String get backupsSection => 'Sauvegardes';

  @override
  String backupsSubtitle(int count) {
    return 'Une sauvegarde est créée automatiquement une fois par jour à l\'ouverture de l\'application. Les $count dernières sont conservées.';
  }

  @override
  String get backupNow => 'Sauvegarder maintenant';

  @override
  String get noBackups => 'Aucune sauvegarde pour l\'instant.';

  @override
  String get restoreBackupTitle => 'Restaurer cette sauvegarde ?';

  @override
  String restoreBackupBody(String file) {
    return 'Le monde sera remplacé par le contenu de « $file ». Une sauvegarde de sécurité de l\'état actuel est d\'abord créée.';
  }

  @override
  String get aboutSection => 'À propos';

  @override
  String get aboutLocalFirst => 'Local d\'abord';

  @override
  String get aboutLocalFirstBody =>
      'Toutes les données sont stockées sur cet appareil. Sans compte, sans cloud, entièrement hors ligne.';

  @override
  String get backupSaved => 'Sauvegarde enregistrée.';

  @override
  String get worldImported => 'Monde importé.';

  @override
  String get backupRestored => 'Sauvegarde restaurée.';

  @override
  String savedTo(String path) {
    return 'Enregistré dans : $path';
  }

  @override
  String get shareArchiveText => 'Archive de monde GMH';

  @override
  String get shareJsonText => 'Données du monde GMH (JSON)';

  @override
  String get sharePdfText => 'Livre du monde GMH (PDF)';

  @override
  String get relationsCaps => 'RELATIONS';

  @override
  String get backlinksCaps => 'LIENS ENTRANTS';

  @override
  String get addRelation => 'Ajouter une relation';

  @override
  String get openInGraph => 'Ouvrir dans le graphe';

  @override
  String get noOutgoingRelations => 'Aucune relation sortante pour l\'instant.';

  @override
  String get noBacklinks => 'Rien ne pointe encore vers cette entrée.';

  @override
  String relationToTitle(String name) {
    return 'Relation avec « $name »';
  }

  @override
  String get roleLabel => 'Rôle';

  @override
  String get roleHint => 'ex. propriétaire, allié, rival';

  @override
  String get fromDocumentMention => 'Depuis une mention dans le document';

  @override
  String get fromStructuredField => 'Depuis un champ structuré';

  @override
  String get roleMention => 'Mentionné dans';

  @override
  String get roleRelated => 'Lié à';

  @override
  String get roleOwner => 'Propriétaire';

  @override
  String get roleLocatedAt => 'Situé à';

  @override
  String get roleMemberOf => 'Membre de';

  @override
  String get rolePartOf => 'Fait partie de';

  @override
  String get roleParticipatedIn => 'A participé à';

  @override
  String get roleCreatedAt => 'Créé à';

  @override
  String get roleQuestGiver => 'Donneur de quête';

  @override
  String get roleAlly => 'Allié';

  @override
  String get roleFriend => 'Ami';

  @override
  String get roleFamily => 'Famille';

  @override
  String get roleEnemy => 'Ennemi';

  @override
  String get roleRival => 'Rival';

  @override
  String get tabBiography => 'Biographie';

  @override
  String get tabProfile => 'Profil';

  @override
  String get attachmentsCaps => 'PIÈCES JOINTES';

  @override
  String get addFiles => 'Ajouter des fichiers';

  @override
  String get fromGallery => 'Depuis la galerie photo';

  @override
  String get noAttachments => 'Aucune pièce jointe pour l\'instant.';

  @override
  String get dropFilesHere => 'Déposez des fichiers ici pour les joindre';

  @override
  String get setAsCover => 'Définir comme image de couverture';

  @override
  String get changeImage => 'Changer l\'image';

  @override
  String get addImage => 'Ajouter une image';

  @override
  String get editCaption => 'Modifier la légende';

  @override
  String get captionLabel => 'Légende';

  @override
  String get replaceFile => 'Remplacer le fichier';

  @override
  String get deleteAttachment => 'Retirer la pièce jointe';

  @override
  String deleteAttachmentTitle(String name) {
    return 'Retirer « $name » ?';
  }

  @override
  String get deleteAttachmentBody =>
      'La pièce jointe est retirée de cette entrée. Le fichier est supprimé du coffre quand plus aucune entrée ne l\'utilise.';

  @override
  String get renameAttachmentTitle => 'Renommer la pièce jointe';

  @override
  String get previewUnavailable =>
      'L\'aperçu n\'est pas disponible pour ce type de fichier. Ouvrez-le avec une autre application.';

  @override
  String get openExternally => 'Ouvrir avec une autre application';

  @override
  String attachmentsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers joints',
      one: '$count fichier joint',
    );
    return '$_temp0';
  }

  @override
  String get tagChip => 'Tag';

  @override
  String get addTagTitle => 'Ajouter un tag';

  @override
  String get tagNameHint => 'Nom du tag';

  @override
  String get none => 'Aucun';

  @override
  String get choose => 'Choisir…';

  @override
  String addToList(String label) {
    return 'Ajouter à « $label »';
  }

  @override
  String get clear => 'Effacer';

  @override
  String get pickerTitleDefault => 'Lier une entrée';

  @override
  String get pickerSearchAll => 'Rechercher dans toutes les entrées…';

  @override
  String pickerSearchKinds(String kinds) {
    return 'Rechercher : $kinds…';
  }

  @override
  String get pickerNoMatches => 'Aucune entrée correspondante';

  @override
  String get justNow => 'à l\'instant';

  @override
  String minutesAgo(int count) {
    return 'il y a $count min';
  }

  @override
  String hoursAgo(int count) {
    return 'il y a $count h';
  }

  @override
  String daysAgo(int count) {
    return 'il y a $count j';
  }

  @override
  String get sectionCategories => 'MES CATÉGORIES';

  @override
  String get manageCategories => 'Gérer les catégories';

  @override
  String get newCategory => 'Nouvelle catégorie';

  @override
  String get renameCategory => 'Modifier la catégorie';

  @override
  String get deleteCategory => 'Supprimer la catégorie';

  @override
  String deleteCategoryTitle(String name) {
    return 'Supprimer la catégorie « $name » ?';
  }

  @override
  String deleteCategoryBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Elle contient $count entrées : celles-ci sont conservées et déplacées vers les Archives de concepts.',
      one:
          'Elle contient $count entrée : celle-ci est conservée et déplacée vers les Archives de concepts.',
    );
    return '$_temp0';
  }

  @override
  String get deleteCategoryBodyEmpty =>
      'La catégorie est vide ; rien d\'autre ne change.';

  @override
  String get categoryNameLabel => 'Nom de la catégorie';

  @override
  String get categoryNameHint => 'ex. Guildes, Royaumes, Rituels…';

  @override
  String get chooseIcon => 'Icône';

  @override
  String get noCategoriesYet =>
      'Aucune catégorie personnalisée pour l\'instant. Créez-en une ci-dessous — elle se comportera exactement comme les sections intégrées.';

  @override
  String get kindCustomEntry => 'Entrée';

  @override
  String get tagManagerTitle => 'Gestionnaire de tags';

  @override
  String get searchTagsHint => 'Rechercher des tags…';

  @override
  String get sortByName => 'Alphabétique';

  @override
  String get sortByCreated => 'Par date de création';

  @override
  String get sortByUsage => 'Par utilisation';

  @override
  String get newTag => 'Nouveau tag';

  @override
  String get mergeTagAction => 'Fusionner avec un autre tag…';

  @override
  String mergeTagTitle(String name) {
    return 'Fusionner « $name »';
  }

  @override
  String mergeTagBody(String name) {
    return 'Chaque entrée portant le tag « $name » recevra le tag choisi ci-dessous, et « $name » sera supprimé.';
  }

  @override
  String get changeColor => 'Changer la couleur';

  @override
  String deleteTagTitle(String name) {
    return 'Supprimer le tag « $name » ?';
  }

  @override
  String deleteTagBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Le tag est retiré de $count entrées. Les entrées elles-mêmes sont conservées.',
      one:
          'Le tag est retiré de $count entrée. L\'entrée elle-même est conservée.',
      zero: 'Aucune entrée n\'utilise ce tag.',
    );
    return '$_temp0';
  }

  @override
  String get noTags =>
      'Aucun tag pour l\'instant. Les tags que vous ajoutez aux entrées apparaissent ici.';

  @override
  String get noTagMatches => 'Aucun tag ne correspond à votre recherche.';

  @override
  String get appearanceSection => 'Apparence';

  @override
  String get themeSystem => 'Comme le système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get navBack => 'Précédent';

  @override
  String get navForward => 'Suivant';

  @override
  String get kindCharacter => 'Personnage';

  @override
  String get kindCharacterPlural => 'Personnages';

  @override
  String get kindLocation => 'Lieu';

  @override
  String get kindLocationPlural => 'Lieux';

  @override
  String get kindItem => 'Objet';

  @override
  String get kindItemPlural => 'Objets';

  @override
  String get kindCreature => 'Créature';

  @override
  String get kindCreaturePlural => 'Créatures';

  @override
  String get kindFaction => 'Faction';

  @override
  String get kindFactionPlural => 'Factions';

  @override
  String get kindEvent => 'Événement';

  @override
  String get kindEventPlural => 'Événements';

  @override
  String get kindEra => 'Époque';

  @override
  String get kindEraPlural => 'Époques';

  @override
  String get kindReligion => 'Religion';

  @override
  String get kindReligionPlural => 'Religions';

  @override
  String get kindMagicSystem => 'Système de magie';

  @override
  String get kindMagicSystemPlural => 'Systèmes de magie';

  @override
  String get kindTechnology => 'Technologie';

  @override
  String get kindTechnologyPlural => 'Technologies';

  @override
  String get kindConcept => 'Concept';

  @override
  String get kindConceptPlural => 'Archives de concepts';

  @override
  String get kindLoreDocument => 'Document de lore';

  @override
  String get kindLoreDocumentPlural => 'Documents de lore';

  @override
  String get kindCampaign => 'Campagne';

  @override
  String get kindCampaignPlural => 'Campagnes';

  @override
  String get kindQuest => 'Quête';

  @override
  String get kindQuestPlural => 'Quêtes';

  @override
  String get kindSession => 'Session';

  @override
  String get kindSessionPlural => 'Sessions';

  @override
  String get close => 'Fermer';

  @override
  String get cyberKindCharacter => 'Runner';

  @override
  String get cyberKindCharacterPlural => 'Runners';

  @override
  String get cyberKindLocation => 'Secteur';

  @override
  String get cyberKindLocationPlural => 'Secteurs';

  @override
  String get cyberKindItem => 'Équipement';

  @override
  String get cyberKindItemPlural => 'Équipement et tech';

  @override
  String get cyberKindCreature => 'Cyberforme';

  @override
  String get cyberKindCreaturePlural => 'Cyberformes';

  @override
  String get cyberKindFaction => 'Syndicat';

  @override
  String get cyberKindFactionPlural => 'Corpos et gangs';

  @override
  String get cyberKindEvent => 'Incident';

  @override
  String get cyberKindEventPlural => 'Incidents';

  @override
  String get cyberKindEra => 'Époque';

  @override
  String get cyberKindEraPlural => 'Époques';

  @override
  String get cyberKindReligion => 'Culte';

  @override
  String get cyberKindReligionPlural => 'Cultes';

  @override
  String get cyberKindMagicSystem => 'Protocole';

  @override
  String get cyberKindMagicSystemPlural => 'Protocoles';

  @override
  String get cyberKindTechnology => 'Cyberware';

  @override
  String get cyberKindTechnologyPlural => 'Cyberware';

  @override
  String get cyberKindConcept => 'Fragment de données';

  @override
  String get cyberKindConceptPlural => 'Coffre de données';

  @override
  String get cyberKindLoreDocument => 'Éclat de données';

  @override
  String get cyberKindLoreDocumentPlural => 'Éclats de données';

  @override
  String get cyberKindCampaign => 'Opération';

  @override
  String get cyberKindCampaignPlural => 'Opérations';

  @override
  String get cyberKindQuest => 'Contrat';

  @override
  String get cyberKindQuestPlural => 'Contrats';

  @override
  String get cyberKindSession => 'Run';

  @override
  String get cyberKindSessionPlural => 'Runs';

  @override
  String get worldStyleLabel => 'Style du monde';

  @override
  String get worldStyleFantasy => 'Fantasy';

  @override
  String get worldStyleFantasyHint =>
      'Parchemin à la chandelle, vocabulaire classique : Personnages, Lieux, Quêtes';

  @override
  String get worldStyleCyberpunk => 'Cyberpunk';

  @override
  String get worldStyleCyberpunkHint =>
      'Chrome néon et argot des rues : Runners, Secteurs, Contrats';

  @override
  String get viewAsGrid => 'Vue en grille';

  @override
  String get viewAsList => 'Vue en liste';

  @override
  String get blueprintFieldsSection => 'Champs';

  @override
  String get constructorTitleNew => 'Constructeur de section';

  @override
  String get constructorTitleEdit => 'Paramètres de la section';

  @override
  String get constructorModules => 'Modules';

  @override
  String get constructorModulesHint =>
      'Ajoutez ou retirez les blocs qui composeront les entrées de cette section.';

  @override
  String get moduleFields => 'Champs structurés';

  @override
  String get moduleFieldsHint =>
      'Un formulaire de champs que vous définissez ci-dessous';

  @override
  String get moduleDocument => 'Document';

  @override
  String get moduleDocumentHint =>
      'Éditeur de texte enrichi avec liens et images';

  @override
  String get moduleGallery => 'Galerie';

  @override
  String get moduleGalleryHint => 'Grille d\'images sur chaque entrée';

  @override
  String get moduleAttachments => 'Fichiers';

  @override
  String get moduleAttachmentsHint => 'Fichiers joints de tout type';

  @override
  String get moduleTags => 'Tags';

  @override
  String get moduleTagsHint => 'Tags et filtres par tag';

  @override
  String get moduleRelations => 'Relations';

  @override
  String get moduleRelationsHint =>
      'Liens vers d\'autres entrées et liens entrants';

  @override
  String get constructorFields => 'Champs personnalisés';

  @override
  String get constructorFieldsEmpty =>
      'Aucun champ pour l\'instant — ajoutez les colonnes dont cette section a besoin, ex. « Niveau », « École », « Prix ».';

  @override
  String get addField => 'Ajouter un champ';

  @override
  String get editField => 'Modifier le champ';

  @override
  String get fieldNameLabel => 'Nom du champ';

  @override
  String get fieldTypeLabel => 'Type de champ';

  @override
  String get fieldOptionsLabel => 'Options (séparées par des virgules)';

  @override
  String get fieldOptionsHint => 'ex. Commun, Rare, Légendaire';

  @override
  String get fieldTypeText => 'Texte';

  @override
  String get fieldTypeLongText => 'Texte long';

  @override
  String get fieldTypeNumber => 'Nombre';

  @override
  String get fieldTypeSelect => 'Liste de choix';

  @override
  String get fieldTypeDate => 'Date';

  @override
  String get fieldTypeChecklist => 'Liste à cocher';

  @override
  String get fieldTypeStringList => 'Liste de valeurs';

  @override
  String get pauseSaveProject => 'Enregistrer le projet';

  @override
  String get pauseExit => 'Quitter';

  @override
  String get helpTitle => 'Guide de l\'utilisateur';

  @override
  String get helpSettingsSubtitle =>
      'Le manuel intégré : où tout se trouve et comment l\'utiliser';

  @override
  String get helpIntroBody =>
      'Game Master\'s Hub est un espace de travail hors ligne pour maîtres de jeu : mondes, personnages, lieux, campagnes et lore vivent sur cet appareil, reliés en une seule toile navigable. Ce guide passe en revue chaque partie de l\'application — les schémas ci-dessous sont des vues simplifiées des vrais écrans, et les repères numérotés sont expliqués sous chaque image.';

  @override
  String get helpWorldsTitle => 'Mondes et styles de monde';

  @override
  String get helpWorldsBody =>
      'Tout commence par un monde — un projet totalement isolé avec ses propres entrées, tags et campagnes. Le sélecteur de mondes s\'ouvre au lancement ; l\'icône de globe dans la barre latérale vous y ramène à tout moment. À la création d\'un monde, vous choisissez son style : Fantasy (parchemin et termes classiques — Personnages, Lieux, Quêtes) ou Cyberpunk (palette néon et argot des rues — Runners, Secteurs, Contrats). Le style change tout l\'aspect et le vocabulaire du monde et peut différer d\'un monde à l\'autre. Chaque monde se souvient de l\'endroit où vous vous êtes arrêté et rouvre exactement là.';

  @override
  String get helpShellTitle => 'Navigation et barre latérale';

  @override
  String get helpShellBody =>
      'La barre latérale gauche est votre centre de contrôle. Elle liste les pages principales, les sections Monde et Bibliothèque avec des compteurs d\'entrées en direct, et vos catégories personnalisées. Maintenez et faites glisser un onglet pour réordonner un groupe — l\'ordre est enregistré pour chaque monde. Sur tablette, la barre se replie en rail ; sur téléphone, en barre inférieure.';

  @override
  String get helpShellLegend1 =>
      'Sélecteur de monde — touchez l\'en-tête pour revenir au choix du monde.';

  @override
  String get helpShellLegend2 =>
      'Précédent / Suivant — un historique façon navigateur sur tout ce que vous visitez. Alt+← / Alt+→ fonctionnent partout.';

  @override
  String get helpShellLegend3 =>
      'Onglets de sections avec compteurs en direct. Maintenez puis faites glisser pour réordonner ; votre ordre est conservé.';

  @override
  String get helpShellLegend4 =>
      'Contrôles de liste — champ de filtre, bascule grille/liste, menu de tri et filtre des favoris pour la section ouverte.';

  @override
  String get helpShellLegend5 =>
      'Les cartes d\'entrée affichent le résumé et des puces de contexte : statut, race, rareté, dates — selon la section.';

  @override
  String get helpShellLegend6 =>
      'Nouvelle entrée — crée une entrée dans la section affichée.';

  @override
  String get helpEntryTitle => 'Entrées : document, champs et pièces jointes';

  @override
  String get helpEntryBody =>
      'Chaque entrée est une page avec un document en texte enrichi et un panneau latéral structuré. L\'éditeur prend en charge les titres, les listes, les citations, les images collées ou déposées directement dans le texte, les fichiers joints et l\'historique des versions (l\'icône d\'horloge dans la barre d\'outils). Tapez @ ou appuyez sur le bouton de mention pour lier une autre entrée dans le texte — les liens sont bidirectionnels et alimentent le graphe. Le panneau latéral contient les champs du modèle du type de l\'entrée, les tags, les relations avec liens entrants et la galerie.';

  @override
  String get helpEntryLegend1 =>
      'Nom — cliquez dessus pour renommer ; l\'étoile bascule le favori.';

  @override
  String get helpEntryLegend2 =>
      'Barre d\'outils de l\'éditeur : mise en forme, alignement, mention @, insertion d\'image, fichier joint, historique des versions.';

  @override
  String get helpEntryLegend3 =>
      'Une mention d\'une autre entrée dans le texte — cliquez pour y aller ; elle crée aussi un lien entrant.';

  @override
  String get helpEntryLegend4 =>
      'Champs structurés définis par le type de l\'entrée (ou votre constructeur de section).';

  @override
  String get helpEntryLegend5 =>
      'Galerie et pièces jointes — glissez-déposez des fichiers n\'importe où sur la page pour les joindre.';

  @override
  String get helpProfileTitle => 'Profils de personnage';

  @override
  String get helpProfileBody =>
      'Les personnages s\'ouvrent en profil complet à onglets : Informations générales, Biographie, Caractéristiques avec une grille de caractéristiques façon D&D et les modificateurs dérivés, Croyances, Relations (alliés, ennemis, factions — tous de vrais liens), Inventaire, Capacités et magie, Chronologie et Notes. Le portrait provient de l\'image de couverture de l\'entrée — définissez n\'importe quelle image de la galerie comme couverture depuis son menu (appui long). Chaque relation renseignée apparaît dans le graphe et comme lien entrant sur l\'entrée cible.';

  @override
  String get helpCampaignsTitle => 'Campagnes, quêtes et sessions';

  @override
  String get helpCampaignsBody =>
      'La page Campagnes est le tableau de bord de votre table. Choisissez la campagne active dans le menu déroulant en haut à droite — le choix est mémorisé pour chaque monde. Le tableau des quêtes affiche toutes les quêtes dont le champ « Campagne » pointe vers la campagne sélectionnée, groupées par statut ; le journal des sessions rassemble les entrées de session de la même façon. Créez quêtes et sessions directement depuis cette page — le lien vers la campagne est rempli automatiquement.';

  @override
  String get helpSearchTitle => 'Recherche et tags';

  @override
  String get helpSearchBody =>
      'La recherche (la loupe dans la barre latérale) est une recherche plein texte instantanée dans les noms, résumés, documents et tags. Les puces de filtre restreignent les résultats à une section ou une catégorie. Les tags se gèrent dans le Gestionnaire de tags — accessible depuis la barre latérale ou les actions rapides de la recherche — où vous pouvez renommer, recolorer, fusionner les doublons et supprimer des tags, avec des compteurs d\'utilisation en direct. Chaque écran de liste peut aussi filtrer par tag et par favoris.';

  @override
  String get helpGraphTitle => 'Graphe des relations';

  @override
  String get helpGraphBody =>
      'Le graphe montre votre monde comme une toile vivante : chaque mention, relation et référence structurée devient une arête. Les couleurs suivent les types d\'entrées ; la taille des nœuds suit le nombre de connexions. Touchez un nœud pour ouvrir son entrée, ou utilisez « Afficher dans le graphe » sur n\'importe quelle entrée pour voir son voisinage local. Le filtre de types dans la barre d\'outils masque les catégories dont vous n\'avez pas besoin pour l\'instant.';

  @override
  String get helpConstructorTitle => 'Sections personnalisées et constructeur';

  @override
  String get helpConstructorBody =>
      'Au-delà des sections intégrées, vous pouvez créer les vôtres — Guildes, Sorts, Recettes, tout ce que vous voulez. Une section personnalisée se comporte exactement comme une section intégrée : onglet avec compteurs dans la barre latérale, tuile sur le tableau de bord, filtre de recherche, couleurs du graphe et chapitres du PDF. Le constructeur de section décide de l\'apparence de ses entrées : activez ou désactivez les modules et définissez des champs personnalisés de sept types. Supprimer une catégorie ne supprime jamais les entrées — elles rejoignent les Archives de concepts.';

  @override
  String get helpConstructorLegend1 =>
      'Modules — les blocs qui composent la page d\'une entrée. Les modules désactivés disparaissent entièrement.';

  @override
  String get helpConstructorLegend2 =>
      'Champs personnalisés avec types : texte, texte long, nombre, liste de choix, date, liste à cocher, liste de valeurs. Faites glisser pour réordonner.';

  @override
  String get helpConstructorLegend3 =>
      'Ajouter un champ — les premiers champs deviennent aussi les puces sur les cartes de la section.';

  @override
  String get helpBackupTitle => 'Sauvegardes et changement d\'appareil';

  @override
  String get helpBackupBody =>
      'Tout est stocké localement — sans compte ni cloud. L\'application effectue une sauvegarde automatique une fois par jour ; vous pouvez en lancer une à tout moment dans les Paramètres. Pour déplacer ou partager un monde, exportez une archive .gmhw : un seul fichier contenant la base de données et tous les médias. L\'importer sur un autre appareil restaure le monde à l\'identique, y compris les sections et styles personnalisés. L\'export JSON et le livre du monde en PDF imprimable sont aussi disponibles dans les Paramètres.';

  @override
  String get helpTipsTitle => 'Astuces et raccourcis';

  @override
  String get helpTipsBody =>
      'Alt+← / Alt+→ — naviguer en arrière et en avant. Tapez @ dans l\'éditeur pour lier des entrées en écrivant. Un appui long sur les onglets de la barre latérale, les champs du constructeur ou les tuiles de la galerie permet de les réordonner par glisser-déposer. Clic droit (ou appui long) sur une pièce jointe pour la renommer, la remplacer ou la définir comme couverture. La bascule grille/liste est mémorisée pour chaque section. Le tri, les filtres et la campagne sélectionnée le sont aussi — l\'application rouvre toujours là où vous vous êtes arrêté. Ctrl+K ouvre directement la recherche ; les boutons latéraux de la souris parcourent l\'historique et les flèches de navigation se trouvent en haut à gauche de chaque page.';

  @override
  String get helpScreenshotCaption =>
      'Capture d\'écran de l\'application (interface en anglais)';

  @override
  String get helpFigureCaption => 'Vue schématique de l\'écran réel';
}
