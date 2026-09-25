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
  String get newTab => 'Nouvel onglet';

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
  String get worldStyleLabel => 'Style du monde';

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

  @override
  String get editWorldTitle => 'Modifier le monde';

  @override
  String get worldActions => 'Actions du monde';

  @override
  String deleteWorldTitle(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get deleteWorldBody =>
      'Toutes les entrées, documents, images et campagnes de ce monde seront supprimés définitivement. Les fichiers de sauvegarde existants sont conservés.';

  @override
  String get worldSection => 'Monde';

  @override
  String get navTools => 'Outils';

  @override
  String get sectionTools => 'À LA TABLE';

  @override
  String get toolDice => 'Dés';

  @override
  String get toolDiceHint =>
      'Toute notation — 4d6kh3, 2d20kl1, 3d6!, dF — avec préréglages et historique.';

  @override
  String get toolCombat => 'Suivi de combat';

  @override
  String get toolCombatHint =>
      'Initiative, points de vie, états et rounds ; difficulté de la rencontre.';

  @override
  String get toolTables => 'Tables aléatoires';

  @override
  String get toolTablesHint =>
      'Vos propres tables avec poids, plages de dés et jets imbriqués.';

  @override
  String get toolGenerators => 'Générateurs';

  @override
  String get toolGeneratorsHint =>
      'Noms, PNJ, tavernes, butin, météo, rumeurs — adaptés à votre univers.';

  @override
  String get toolMaps => 'Cartes';

  @override
  String get toolMapsHint =>
      'Cartes interactives avec repères liés à vos entrées ; cartes imbriquées.';

  @override
  String get toolTimeline => 'Chronologie';

  @override
  String get toolTimelineHint =>
      'Événements et ères de votre monde dans l\'ordre chronologique.';

  @override
  String get toolReference => 'Écran du MJ';

  @override
  String get toolReferenceHint =>
      'États et règles rapides en un coup d\'œil (SRD 5.2.1).';

  @override
  String importReplaceTitle(String name) {
    return 'Remplacer « $name » ?';
  }

  @override
  String get importReplaceBody =>
      'Cette archive contient un monde qui existe déjà ici. L\'import remplace entièrement sa version actuelle.';

  @override
  String get importReplaceAction => 'Remplacer';

  @override
  String get searchIndexFailed =>
      'Le monde a été restauré, mais la recherche n\'a pas pu être reconstruite. Relancez l\'application pour réessayer.';

  @override
  String get fieldNotANumber => 'Saisissez un nombre';

  @override
  String get pdfBookSubtitle => 'Un livre du monde';

  @override
  String get pdfIncludeGmOnly => 'Inclure les secrets du MJ';

  @override
  String get pdfIncludeGmOnlyHint =>
      'Désactivé : un livre pour les joueurs, sans les champs réservés au MJ.';

  @override
  String get exportAction => 'Exporter';

  @override
  String get tagNameTaken =>
      'Un tag porte déjà ce nom — utilisez plutôt Fusionner.';

  @override
  String get errorEntryGone => 'Cette entrée n’existe plus.';

  @override
  String get errorNotFound =>
      'Introuvable — l’élément a peut-être été supprimé.';

  @override
  String get errorStorage =>
      'Impossible de lire ou d’écrire un fichier. Vérifiez l’espace disque et les droits du dossier.';

  @override
  String get errorDatabase =>
      'La base de données n’a pas pu terminer l’opération. Vos données sont inchangées.';

  @override
  String get errorArchiveMissing => 'Le fichier d’archive est introuvable.';

  @override
  String get errorArchiveInvalid =>
      'Ce fichier n’est pas une archive de monde GMH valide.';

  @override
  String get errorExport =>
      'L’export a échoué. Vérifiez l’espace disque et les droits d’écriture du dossier.';

  @override
  String get errorAiNotConfigured => 'Aucun fournisseur d’IA n’est configuré.';

  @override
  String get diceExpressionLabel => 'Expression de dés';

  @override
  String get diceExpressionHint => 'ex. 2d6+3, 4d6kh3, 1d20!';

  @override
  String get diceRollAction => 'Lancer';

  @override
  String get diceLabelHint => 'Libellé (facultatif)';

  @override
  String get diceAdvantage => 'Avantage';

  @override
  String get diceDisadvantage => 'Désavantage';

  @override
  String get diceModifier => 'Modificateur';

  @override
  String get diceDecrease => 'Diminuer';

  @override
  String get diceIncrease => 'Augmenter';

  @override
  String get diceQuickHint =>
      'Touchez un dé pour le lancer, appui long pour l’ajouter à l’expression.';

  @override
  String get dicePresets => 'Systèmes';

  @override
  String get diceHistory => 'Historique';

  @override
  String get diceHistoryEmpty =>
      'Aucun lancer pour l’instant. Chaque lancer est noté ici.';

  @override
  String get diceClearHistory => 'Effacer l’historique';

  @override
  String get diceClearHistoryTitle => 'Effacer l’historique des lancers ?';

  @override
  String get diceClearHistoryBody =>
      'Tous les lancers enregistrés de ce monde seront supprimés.';

  @override
  String get diceReroll => 'Relancer';

  @override
  String get diceCopy => 'Copier';

  @override
  String get diceCopied => 'Copié dans le presse-papiers';

  @override
  String get diceResultEmpty => 'Choisissez un dé ou saisissez une expression';

  @override
  String get diceDropped => 'Écarté';

  @override
  String get diceExploded => 'Explosé';

  @override
  String get diceRerolled => 'Relancé';

  @override
  String diceMoreDice(int count) {
    return '+$count de plus';
  }

  @override
  String get diceErrorEmpty => 'Saisissez une expression de dés';

  @override
  String get diceErrorTooLong => 'L’expression est trop longue';

  @override
  String get diceErrorUnexpectedChar => 'Caractère inattendu';

  @override
  String get diceErrorUnexpectedEnd => 'L’expression s’arrête trop tôt';

  @override
  String get diceErrorExpectedNumber => 'Un nombre est attendu ici';

  @override
  String get diceErrorParen => 'Parenthèses non équilibrées';

  @override
  String get diceErrorTooManyDice => '1000 dés maximum par terme';

  @override
  String get diceErrorBadSides => 'Un dé doit avoir de 1 à 10000 faces';

  @override
  String get diceErrorTooLarge => 'Le nombre est trop grand';

  @override
  String get diceErrorDivisionByZero => 'Division par zéro';

  @override
  String get diceErrorDuplicate => 'Ce modificateur est répété';

  @override
  String get diceErrorImpossibleReroll =>
      'Cette relance ne s’arrêterait jamais';

  @override
  String get diceErrorLabel => 'Fermez le libellé avec ]';

  @override
  String diceErrorAt(String message, int position) {
    return '$message (position $position)';
  }

  @override
  String get dicePresetD20 => 'Test d20';

  @override
  String get dicePresetAbility => 'Caractéristique';

  @override
  String get dicePresetCoc => 'L’Appel de Cthulhu';

  @override
  String get dicePresetPbta => 'Action PbtA';

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
  String get diceDc => 'DD (facultatif)';

  @override
  String get diceSkill => 'Compétence';

  @override
  String get diceBonusDice => 'Dés bonus (+) / malus (−)';

  @override
  String get diceStat => 'Carac.';

  @override
  String get diceDicePool => 'Réserve de dés';

  @override
  String get diceTraitDie => 'Dé de trait';

  @override
  String get diceWildDie => 'Dé joker';

  @override
  String get diceStatSkill => 'Carac. + compétence';

  @override
  String get diceOutcomeCriticalSuccess => 'Réussite critique';

  @override
  String get diceOutcomeCriticalFailure => 'Échec critique';

  @override
  String get diceOutcomeSuccess => 'Réussite';

  @override
  String get diceOutcomeFailure => 'Échec';

  @override
  String get diceOutcomeRaise => 'Réussite avec prouesse';

  @override
  String get diceOutcomeExtreme => 'Réussite extrême';

  @override
  String get diceOutcomeHard => 'Réussite majeure';

  @override
  String get diceOutcomeRegular => 'Réussite ordinaire';

  @override
  String get diceOutcomeFumble => 'Maladresse';

  @override
  String get diceOutcomeMiss => 'Échec';

  @override
  String get diceOutcomePartial => 'Réussite partielle';

  @override
  String get diceOutcomeFull => 'Réussite totale';

  @override
  String get diceFateTerrible => 'Terrible';

  @override
  String get diceFatePoor => 'Médiocre';

  @override
  String get diceFateMediocre => 'Moyen';

  @override
  String get diceFateAverage => 'Correct';

  @override
  String get diceFateFair => 'Honnête';

  @override
  String get diceFateGood => 'Bon';

  @override
  String get diceFateGreat => 'Excellent';

  @override
  String get diceFateSuperb => 'Superbe';

  @override
  String get diceFateFantastic => 'Fantastique';

  @override
  String get diceFateEpic => 'Épique';

  @override
  String get diceFateLegendary => 'Légendaire';

  @override
  String diceSuccesses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count succès',
      one: '1 succès',
      zero: 'Aucun succès',
    );
    return '$_temp0';
  }

  @override
  String diceRollTooltip(String expression) {
    return 'Lancer $expression';
  }

  @override
  String diceRolledSnack(String expression, int total) {
    return '$expression : $total';
  }

  @override
  String get diceQuickRollTitle => 'Lancer rapide';

  @override
  String get combatNewEncounter => 'Nouvelle rencontre';

  @override
  String combatEncounterDefaultName(int number) {
    return 'Rencontre $number';
  }

  @override
  String get combatEncounterNameLabel => 'Nom de la rencontre';

  @override
  String get combatEmptyTitle => 'Aucune rencontre';

  @override
  String get combatEmptyHint =>
      'Préparez un combat : ajoutez monstres et héros, vérifiez la difficulté, puis jouez-le round par round.';

  @override
  String get combatRenameTitle => 'Renommer la rencontre';

  @override
  String get combatDuplicate => 'Dupliquer';

  @override
  String combatCopyName(String name) {
    return '$name (copie)';
  }

  @override
  String combatDeleteTitle(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get combatDeleteBody =>
      'La rencontre et tous ses combattants seront définitivement supprimés.';

  @override
  String get combatStatusPlanning => 'Préparation';

  @override
  String get combatStatusActive => 'En combat';

  @override
  String get combatStatusFinished => 'Terminé';

  @override
  String combatRound(int round) {
    return 'Round $round';
  }

  @override
  String combatCombatantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count combattants',
      one: '1 combattant',
      zero: 'Aucun combattant',
    );
    return '$_temp0';
  }

  @override
  String get combatNotFound => 'Cette rencontre n’existe plus.';

  @override
  String get combatAllEncounters => 'Toutes les rencontres';

  @override
  String get combatStart => 'Lancer le combat';

  @override
  String get combatEnd => 'Finir le combat';

  @override
  String get combatNextTurn => 'Tour suivant';

  @override
  String get combatPreviousTurn => 'Tour précédent';

  @override
  String get combatRollInitiative => 'Jet d’initiative';

  @override
  String get combatRollInitiativeHint =>
      'Lance d20 + bonus pour chaque monstre ; les joueurs gardent leurs valeurs.';

  @override
  String combatTurnOf(String name) {
    return 'Tour : $name';
  }

  @override
  String get combatNotStarted => 'Le combat n’a pas commencé';

  @override
  String get combatAddFromWorld => 'Depuis le monde';

  @override
  String get combatAddManually => 'Manuellement';

  @override
  String get combatPickTitle => 'Ajouter une créature ou un personnage';

  @override
  String combatQuantityTitle(String name) {
    return 'Combien de « $name » ?';
  }

  @override
  String get combatNoCombatants => 'Aucun combattant';

  @override
  String get combatNoCombatantsHint =>
      'Ajoutez des créatures et personnages de votre monde ou saisissez-les à la main.';

  @override
  String get combatInitiative => 'Initiative';

  @override
  String get combatInitiativeBonus => 'Bonus d’initiative';

  @override
  String get combatArmorClass => 'Classe d’armure';

  @override
  String get combatAcShort => 'CA';

  @override
  String get combatHpMax => 'PV max';

  @override
  String get combatHpCurrent => 'PV actuels';

  @override
  String get combatHpTemp => 'PV temp.';

  @override
  String get combatAmountHint => 'PV';

  @override
  String get combatDamage => 'Dégâts';

  @override
  String get combatHeal => 'Soin';

  @override
  String get combatTemp => 'Temp.';

  @override
  String get combatAddCondition => 'État';

  @override
  String combatConditionDurationTitle(String condition) {
    return 'Durée : $condition';
  }

  @override
  String get combatConditionRounds => 'Rounds (vide = jusqu’au retrait)';

  @override
  String get combatRemoveCondition => 'Retirer l’état';

  @override
  String get combatConcentration => 'Concentration';

  @override
  String get combatDefeated => 'Vaincu';

  @override
  String get combatPlayer => 'Personnage joueur';

  @override
  String get combatEdit => 'Modifier';

  @override
  String get combatRemove => 'Retirer';

  @override
  String get combatEditCombatant => 'Modifier le combattant';

  @override
  String get combatAddCombatant => 'Ajouter un combattant';

  @override
  String get combatChallenge => 'Facteur de puissance';

  @override
  String get combatXp => 'PX';

  @override
  String get combatQuantity => 'Quantité';

  @override
  String get combatNotes => 'Notes';

  @override
  String get combatNotesHint => 'Tactique, terrain, butin…';

  @override
  String get combatDifficulty => 'Difficulté';

  @override
  String get combatRules => 'Règles';

  @override
  String get combatPartyLevels => 'Niveaux du groupe';

  @override
  String get combatAddLevel => 'Niveau';

  @override
  String combatLevelChip(int level) {
    return 'Niv. $level';
  }

  @override
  String get combatLevelLabel => 'Niveau du personnage (1–20)';

  @override
  String combatMonsterXp(String xp) {
    return 'PX des monstres : $xp';
  }

  @override
  String combatAdjustedXp(String xp, String multiplier) {
    return 'PX ajustés : $xp (×$multiplier)';
  }

  @override
  String get combatNoParty =>
      'Ajoutez les niveaux du groupe pour évaluer la rencontre.';

  @override
  String get combatRatingTrivial => 'Triviale';

  @override
  String get combatRatingLow => 'Faible';

  @override
  String get combatRatingModerate => 'Modérée';

  @override
  String get combatRatingHigh => 'Élevée';

  @override
  String get combatRatingBeyondHigh => 'Au-delà';

  @override
  String get combatRatingEasy => 'Facile';

  @override
  String get combatRatingMedium => 'Moyenne';

  @override
  String get combatRatingHard => 'Difficile';

  @override
  String get combatRatingDeadly => 'Mortelle';

  @override
  String combatConcentrationCheck(String name, int dc) {
    return '$name : sauvegarde de concentration DD $dc';
  }

  @override
  String combatDefeatedNotice(String name) {
    return '$name est vaincu';
  }

  @override
  String get combatOpenEntry => 'Ouvrir la fiche';

  @override
  String get combatActions => 'Actions du combattant';

  @override
  String get combatEncounterActions => 'Actions de la rencontre';

  @override
  String get roleCustomLabel => 'Ou saisissez votre rôle';

  @override
  String importFilesFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers n’ont pas pu être importés',
      one: '1 fichier n’a pas pu être importé',
    );
    return '$_temp0';
  }

  @override
  String get trashTitle => 'Corbeille';

  @override
  String get trashEmptyState =>
      'La corbeille est vide. Les entrées supprimées restent ici jusqu’à ce que vous les restauriez ou les supprimiez définitivement.';

  @override
  String get trashEmptyAction => 'Vider la corbeille';

  @override
  String get trashEmptyConfirmTitle => 'Vider la corbeille ?';

  @override
  String trashEmptyConfirmBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count entrées seront supprimées définitivement, avec leur texte, leurs images et leurs liens.',
      one:
          '1 entrée sera supprimée définitivement, avec son texte, ses images et ses liens.',
    );
    return '$_temp0';
  }

  @override
  String get trashDeleteForever => 'Supprimer définitivement';

  @override
  String trashDeleteForeverTitle(String name) {
    return 'Supprimer « $name » définitivement ?';
  }

  @override
  String get trashDeleteForeverBody =>
      'Son texte, ses images et ses liens sont aussi supprimés. Action irréversible.';

  @override
  String trashDeletedOn(String date) {
    return 'Supprimé le $date';
  }

  @override
  String trashMovedSnack(String name) {
    return '« $name » placé dans la corbeille';
  }

  @override
  String trashRestoredSnack(String name) {
    return '« $name » restauré';
  }

  @override
  String get undo => 'Annuler';

  @override
  String get tabDuplicate => 'Dupliquer l’onglet';

  @override
  String get tabClose => 'Fermer l’onglet';

  @override
  String get tabCloseOthers => 'Fermer les autres onglets';

  @override
  String get tabCloseRight => 'Fermer les onglets à droite';

  @override
  String get exportMarkdownTitle => 'Notes Markdown (Obsidian)';

  @override
  String get exportMarkdownSubtitle =>
      'Un dossier zippé de notes liées avec images — à ouvrir comme coffre Obsidian ou dans tout éditeur.';

  @override
  String get shareMarkdownText => 'Notes du monde GMH (Markdown)';

  @override
  String get relationsTitle => 'Relations';

  @override
  String kindFieldsTitle(String kind) {
    return 'Champs personnalisés : $kind';
  }

  @override
  String get kindFieldsHint =>
      'Les champs ajoutés ici apparaissent sur chaque entrée de ce type dans ce monde, après les champs intégrés.';

  @override
  String get kindFieldsAction => 'Personnaliser les champs';

  @override
  String get tablesSearchHint => 'Rechercher des tables';

  @override
  String get tablesNewTable => 'Nouvelle table';

  @override
  String get tablesImport => 'Importer du texte';

  @override
  String get tablesLibrary => 'Bibliothèque';

  @override
  String get tablesOpenLibrary => 'Ouvrir la bibliothèque';

  @override
  String get tablesEmptyTitle => 'Aucune table aléatoire';

  @override
  String get tablesEmptyHint =>
      'Partez d’une table toute prête de la bibliothèque, écrivez la vôtre ou collez une liste tirée d’un livre.';

  @override
  String get tablesNoMatches => 'Aucune table ne correspond.';

  @override
  String get tablesNoFolder => 'Autres tables';

  @override
  String tablesRowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lignes',
      one: '1 ligne',
    );
    return '$_temp0';
  }

  @override
  String get tablesWeighted => 'Par poids';

  @override
  String tablesDefaultName(int number) {
    return 'Table $number';
  }

  @override
  String get tablesDescriptionLabel => 'Description';

  @override
  String get tablesFolderLabel => 'Dossier';

  @override
  String get tablesFolderHint => 'ex. Rencontres';

  @override
  String get tablesFormulaLabel => 'Formule de dés';

  @override
  String get tablesFormulaHint => 'ex. 1d20 — vide : par poids';

  @override
  String get tablesFormulaInvalid => 'Formule de dés invalide';

  @override
  String get tablesEditTitle => 'Modifier la table';

  @override
  String get tablesEdit => 'Modifier les détails';

  @override
  String get tablesDuplicate => 'Dupliquer';

  @override
  String tablesCopyName(String name) {
    return '$name (copie)';
  }

  @override
  String tablesDeleteTitle(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get tablesDeleteBody =>
      'La table et toutes ses lignes seront retirées de ce monde.';

  @override
  String get tablesActions => 'Actions de la table';

  @override
  String get tablesAllTables => 'Toutes les tables';

  @override
  String get tablesMissing => 'Cette table n’existe plus.';

  @override
  String get tablesRoll => 'Lancer';

  @override
  String get tablesRollAgain => 'Relancer';

  @override
  String get tablesCopy => 'Copier';

  @override
  String get tablesCopied => 'Copié dans le presse-papiers';

  @override
  String get tablesResultEmpty => 'Lancez pour obtenir un résultat.';

  @override
  String get tablesClamped => 'Hors de toute plage — ligne la plus proche';

  @override
  String get tablesRollLog => 'Journal des lancers';

  @override
  String get tablesRollLogEmpty => 'Les lancers de cette page s’affichent ici.';

  @override
  String get tablesClearLog => 'Vider le journal';

  @override
  String get tablesRows => 'Lignes';

  @override
  String get tablesAddRow => 'Ajouter une ligne';

  @override
  String get tablesDeleteRow => 'Supprimer la ligne';

  @override
  String get tablesAutoRanges => 'Plages auto';

  @override
  String get tablesAutoRangesHint =>
      'Répartir les lignes sur la formule selon leur poids';

  @override
  String get tablesBulkEdit => 'Éditer en texte';

  @override
  String get tablesBulkEditTitle => 'Lignes en mode texte';

  @override
  String get tablesTextFormatHelp =>
      'Une entrée par ligne : « 1-3 | texte », « 4: texte », « x3 texte » pour un poids, ou du texte simple. Les lignes commençant par # sont ignorées.';

  @override
  String get tablesImportTitle => 'Importer une table depuis du texte';

  @override
  String get tablesImportRows => 'Lignes';

  @override
  String tablesImportFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lignes trouvées',
      one: '1 ligne trouvée',
      zero: 'Aucune ligne trouvée',
    );
    return '$_temp0';
  }

  @override
  String get tablesImportAction => 'Importer';

  @override
  String get tablesApply => 'Appliquer';

  @override
  String get tablesRowsEmpty =>
      'Aucune ligne. Ajoutez-en une, ou collez toute une liste avec « Éditer en texte ».';

  @override
  String tablesRowTextHint(String dice, String choice, String table) {
    return 'Texte, dés $dice, choix $choice, jets $table';
  }

  @override
  String get tablesFrom => 'De';

  @override
  String get tablesTo => 'À';

  @override
  String get tablesWeight => 'Poids';

  @override
  String get tablesDragToReorder => 'Glisser pour réordonner';

  @override
  String get tablesIssueBadFormula => 'La formule de dés est invalide.';

  @override
  String get tablesIssueEmpty => 'La table n’a aucune ligne avec du texte.';

  @override
  String tablesIssueEmptyRow(int row) {
    return 'La ligne $row est vide.';
  }

  @override
  String tablesIssueMissingRange(int row) {
    return 'La ligne $row n’a pas de plage.';
  }

  @override
  String tablesIssueInverted(int row) {
    return 'Ligne $row : la plage est inversée.';
  }

  @override
  String tablesIssueOutOfBounds(int row, String range) {
    return 'La ligne $row dépasse ce que la formule peut donner ($range).';
  }

  @override
  String tablesIssueGap(String range) {
    return 'Rien ne couvre $range.';
  }

  @override
  String tablesIssueOverlap(int first, int second, String range) {
    return 'Les lignes $first et $second se chevauchent sur $range.';
  }

  @override
  String get tablesFailNotFound => 'Aucune table de ce nom';

  @override
  String get tablesFailCycle => 'Renvoie à elle-même — arrêté';

  @override
  String get tablesFailDepth => 'Imbrication trop profonde — arrêté';

  @override
  String get tablesFailTooMany => 'Trop de jets imbriqués — arrêté';

  @override
  String get tablesFailEmpty => 'La table n’a pas de lignes';

  @override
  String get tablesFailBadFormula => 'La formule est invalide';

  @override
  String tablesChoice(int count) {
    return 'un parmi $count';
  }

  @override
  String get tablesFromLibrary => 'De la bibliothèque';

  @override
  String get tablesLibraryTitle => 'Bibliothèque de tables';

  @override
  String get tablesLibraryHint =>
      'Des tables prêtes pour chaque univers. Prévisualisez-les, puis ajoutez-les à ce monde pour les modifier.';

  @override
  String get tablesYourSetting => 'Univers de ce monde';

  @override
  String get tablesOtherSettings => 'Autres univers';

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
  String get tablesPreview => 'Aperçu';

  @override
  String get tablesAddToWorld => 'Ajouter au monde';

  @override
  String get tablesInWorld => 'Dans ce monde';

  @override
  String get tablesAddDepsTitle => 'Ajouter aussi les tables liées ?';

  @override
  String tablesAddDepsBody(String name) {
    return '« $name » lance sur ces tables. Sans elles, ses résultats afficheront un avertissement.';
  }

  @override
  String tablesAddedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tables ajoutées',
      one: '1 table ajoutée',
    );
    return '$_temp0';
  }

  @override
  String get tablesPreviewRoll => 'Essayer un lancer';

  @override
  String get tablesWhy => 'Détail du tirage';

  @override
  String get paletteHint =>
      'Aller à une entrée, une section ou un outil, ou lancer une commande…';

  @override
  String get paletteCommands => 'Commandes';

  @override
  String get paletteEntries => 'Entrées';

  @override
  String get paletteNoMatches => 'Aucun résultat';

  @override
  String get paletteToggleTheme => 'Basculer thème clair / sombre';

  @override
  String paletteOpenInTab(String name) {
    return 'Aller à $name';
  }

  @override
  String get paletteTitle => 'Palette de commandes';

  @override
  String get homeAtTheTable => 'À la table';

  @override
  String get homeYourSections => 'Vos sections';

  @override
  String get menuDuplicateEntry => 'Dupliquer';

  @override
  String entryCopyName(String name) {
    return '$name (copie)';
  }

  @override
  String get helpPacksTitle => 'Univers et styles';

  @override
  String get helpPacksBody =>
      'Chaque monde a un univers : fantasy, cyberpunk, space opera, horreur gothique ou cosmique, post-apocalypse, steampunk, fantasy urbaine, western ou wuxia. L’univers recolore toute l’application (clair et sombre), renomme les sections dans son propre vocabulaire — Runners et Secteurs en cyberpunk, Équipage et Escales en space opera — et choisit les tables aléatoires et générateurs adaptés au genre. Changez-le quand vous voulez dans Paramètres → Monde : vos données restent, seule la présentation change.';

  @override
  String get helpToolsTitle => 'À la table : outils du MJ';

  @override
  String get helpToolsBody =>
      'Les outils sont dans la barre latérale, sur le tableau de bord et dans la palette de commandes. Dés : n’importe quelle notation (4d6kh3, 2d20kl1+5, 8d6!, 5d10>=8) ou des préréglages — tests D&D, L’Appel de Cthulhu, PbtA, Blades in the Dark, Fate, Year Zero, Savage Worlds, Cyberpunk RED ; chaque jet est journalisé et les dés écrits dans les fiches sont cliquables. Suivi de combat : composez des rencontres à partir de vos créatures et personnages (PV, CA et FP viennent de leurs champs), lancez l’initiative, appliquez dégâts et soins, suivez les états et leur durée, et voyez la difficulté. Tables aléatoires : vos propres tables par plages de dés ou poids, imbriquées avec [[Nom de table]], ou des tables prêtes pour votre univers depuis la bibliothèque. Générateurs : PNJ, noms, lieux, tavernes, accroches, factions, butin et rumeurs pour votre univers — gardez les meilleurs et enregistrez-les dans le monde en un clic. Cartes : importez une image de carte, placez des repères liés à vos entrées, mesurez les distances à l’échelle et passez en vue joueurs pour masquer les repères du MJ. Chronologie : vos ères et événements dans l’ordre, d’après leurs dates dans le monde, avec votre propre calendrier. Écran du MJ : le combat en cours, les entrées épinglées, les notes de séance, des dés et tables rapides et un aide-mémoire des règles sur une seule page.';

  @override
  String get helpNavTitle => 'Navigation rapide';

  @override
  String get helpNavBody =>
      'Ctrl+P ouvre la palette de commandes : tapez une partie d’un nom pour aller à une entrée, une section ou un outil, ou lancez une commande (nouvelle entrée, thème clair/sombre, changer de monde). Ctrl+K ouvre la recherche. Les pages s’ouvrent dans des onglets comme dans un navigateur : Ctrl+T nouvel onglet, Ctrl+W fermer, Ctrl+Tab pour passer de l’un à l’autre ; clic droit sur un onglet pour le dupliquer ou fermer les autres, clic molette pour fermer. Alt+← / Alt+→ et les boutons latéraux de la souris parcourent l’historique de chaque onglet. Échap ouvre le menu pause (enregistrer, paramètres, quitter).';

  @override
  String get helpFieldsTitle => 'Vos propres champs';

  @override
  String get helpFieldsBody =>
      'Les sections intégrées peuvent recevoir des champs supplémentaires pour votre jeu : ouvrez une section (Personnages, Lieux…) et cliquez sur « Personnaliser les champs » dans sa barre. Ajoutez du texte, des nombres, des dates, des listes, des cases à cocher ou des choix ; ils apparaissent sur chaque entrée de cette section dans ce monde, après les champs intégrés, et sont inclus dans la recherche, le livre PDF et l’export Markdown. Les sections personnalisées définissent tous leurs champs dans le constructeur.';

  @override
  String get helpTrashTitle => 'Corbeille, copies et exports';

  @override
  String get helpTrashBody =>
      'Une entrée supprimée va dans la corbeille (barre latérale ou Paramètres → Monde) — juste après, vous pouvez aussi toucher « Annuler ». Restaurez-la plus tard ou supprimez-la définitivement. Le menu d’une entrée permet de la dupliquer avec ses champs, tags, images et texte. Paramètres → Export produit une archive complète (.gmhw, pour les sauvegardes et le changement d’appareil), du JSON, un livre PDF imprimable ou des notes Markdown qui s’ouvrent comme un coffre Obsidian avec des [[liens]] fonctionnels ; les champs réservés au MJ sont exclus sauf si vous les incluez.';

  @override
  String get newSessionAction => 'Nouvelle séance';

  @override
  String sessionNumberName(int number) {
    return 'Séance $number';
  }

  @override
  String get timelineEmptyTitle => 'Pas encore d’histoire';

  @override
  String get timelineEmptyHint =>
      'Les ères et événements datés dans le monde apparaissent ici dans l’ordre. Ajoutez un événement ou datez ceux qui existent.';

  @override
  String get timelineNewEvent => 'Nouvel événement';

  @override
  String get timelineEventName => 'Nom de l’événement';

  @override
  String get timelineDateLabel => 'Date dans le monde';

  @override
  String get timelineDateHint =>
      'ex. 1492, 12 mars 1492, an 412, 300 av. J.-C.';

  @override
  String get timelineDateUnreadable =>
      'Aucune année trouvée — l’événement sera classé « sans date ».';

  @override
  String get timelineUndated => 'Sans date';

  @override
  String get timelineUndatedHint => 'Datez-les pour les placer sur la frise.';

  @override
  String get timelineSetDate => 'Dater';

  @override
  String get timelineOutsideEras => 'Hors des ères';

  @override
  String timelineEraSpan(String start, String end) {
    return '$start – $end';
  }

  @override
  String get timelineOngoing => 'en cours';

  @override
  String get timelineCalendar => 'Calendrier';

  @override
  String get timelineCalendarHint =>
      'Un mois par ligne, avec sa durée si besoin : « Givrelune : 30 ». Laissez vide pour le calendrier usuel.';

  @override
  String get timelineMonths => 'Mois';

  @override
  String get timelineYearSuffix => 'Suffixe d’année (ex. DR)';

  @override
  String timelineEventsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count événements',
      one: '1 événement',
      zero: 'Aucun événement',
    );
    return '$_temp0';
  }

  @override
  String get gmScreenPinned => 'Entrées épinglées';

  @override
  String get gmScreenPinHint =>
      'Gardez à portée de clic les PNJ, lieux et objets de la séance.';

  @override
  String get gmScreenAddPin => 'Épingler une entrée';

  @override
  String get gmScreenUnpin => 'Désépingler';

  @override
  String get gmScreenNotes => 'Notes de séance';

  @override
  String get gmScreenNotesHint =>
      'Noms improvisés, fils à reprendre, qui doit quoi à qui…';

  @override
  String get gmScreenDice => 'Dés rapides';

  @override
  String get gmScreenRoll => 'Lancer';

  @override
  String get gmScreenTables => 'Tables rapides';

  @override
  String get gmScreenAddTable => 'Épingler une table';

  @override
  String get gmScreenNoTables =>
      'Aucune table aléatoire dans ce monde — créez-en ou ajoutez-en depuis la bibliothèque des Tables aléatoires.';

  @override
  String get gmScreenEncounter => 'Combat en cours';

  @override
  String get gmScreenNoFight => 'Aucun combat en cours.';

  @override
  String get gmScreenOpenTracker => 'Ouvrir le suivi';

  @override
  String gmScreenRound(int round) {
    return 'Round $round';
  }

  @override
  String get gmScreenConditions => 'États';

  @override
  String get gmScreenRules => 'Difficulté et abris';

  @override
  String get gmScreenDifficulty => 'Degré de difficulté';

  @override
  String get gmScreenCover => 'Abri';

  @override
  String get gmScreenPanels => 'Panneaux';

  @override
  String get gmScreenAttribution =>
      'Résumés de règles d’après le SRD 5.2.1 (CC BY 4.0)';

  @override
  String get mapsEmptyTitle => 'Aucune carte';

  @override
  String get mapsEmptyHint =>
      'Importez une image de carte ou partez d’une feuille vierge, puis placez des repères liés à vos fiches.';

  @override
  String get mapsNewFromImage => 'Carte depuis une image';

  @override
  String get mapsNewBlank => 'Carte vierge';

  @override
  String mapsDefaultName(int number) {
    return 'Carte $number';
  }

  @override
  String mapsPinCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count repères',
      one: '1 repère',
      zero: 'Aucun repère',
    );
    return '$_temp0';
  }

  @override
  String get mapsRenameTitle => 'Renommer la carte';

  @override
  String get mapsDuplicate => 'Dupliquer';

  @override
  String mapsCopyName(String name) {
    return '$name (copie)';
  }

  @override
  String mapsDeleteTitle(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get mapsDeleteBody =>
      'La carte et tous ses repères seront supprimés. Les fiches liées sont conservées.';

  @override
  String get mapsActions => 'Actions de la carte';

  @override
  String get mapsAllMaps => 'Toutes les cartes';

  @override
  String get mapsMissing => 'Cette carte n’existe plus.';

  @override
  String get mapsImportFailed => 'Impossible d’ouvrir ce fichier comme image.';

  @override
  String get mapsChangeImage => 'Changer l’image';

  @override
  String get mapsImageMissing => 'L’image de la carte est introuvable';

  @override
  String get mapsImageMissingHint =>
      'Les repères fonctionnent toujours. Choisissez une nouvelle image pour le fond.';

  @override
  String get mapsModeSelect => 'Sélection';

  @override
  String get mapsModeAdd => 'Ajouter un repère';

  @override
  String get mapsModeMeasure => 'Mesurer';

  @override
  String get mapsAddHint => 'Touchez la carte pour placer un repère.';

  @override
  String get mapsMeasureHint => 'Touchez deux points pour mesurer.';

  @override
  String get mapsMeasureNoScale => 'Pas d’échelle : distance en pixels.';

  @override
  String mapsDistance(String distance) {
    return 'Distance : $distance';
  }

  @override
  String mapsPixels(String value) {
    return '$value px';
  }

  @override
  String get mapsMeasureRule => 'Règle des diagonales';

  @override
  String get mapsRuleStraight => 'Ligne droite';

  @override
  String get mapsRuleGrid => 'Grille : diagonale = 1 case';

  @override
  String get mapsRuleAlternating => 'Grille : diagonales 1-2-1';

  @override
  String get mapsFit => 'Ajuster à l’écran';

  @override
  String get mapsZoomIn => 'Zoom avant';

  @override
  String get mapsZoomOut => 'Zoom arrière';

  @override
  String get mapsPlayerView => 'Vue joueurs';

  @override
  String get mapsExitPlayerView => 'Quitter la vue joueurs';

  @override
  String get mapsPanel => 'Repères et détails';

  @override
  String get mapsPinsTab => 'Repères';

  @override
  String get mapsDetailsTab => 'Détails';

  @override
  String get mapsSearchPins => 'Chercher un repère';

  @override
  String get mapsNoPins =>
      'Aucun repère. Choisissez « Ajouter un repère » et touchez la carte.';

  @override
  String get mapsNoPinMatches => 'Aucun repère ne correspond.';

  @override
  String get mapsNewPin => 'Nouveau repère';

  @override
  String get mapsEditPin => 'Modifier le repère';

  @override
  String get mapsPinLabel => 'Libellé';

  @override
  String get mapsPinIcon => 'Symbole';

  @override
  String get mapsPinColor => 'Couleur';

  @override
  String get mapsPinNotes => 'Notes';

  @override
  String get mapsPinGmOnly => 'MJ seulement';

  @override
  String get mapsPinGmOnlyHint => 'Masqué dans la vue joueurs';

  @override
  String get mapsLinkedEntry => 'Fiche liée';

  @override
  String get mapsLinkEntry => 'Lier une fiche';

  @override
  String get mapsChangeEntry => 'Changer';

  @override
  String get mapsUnlink => 'Délier';

  @override
  String get mapsOpenEntry => 'Ouvrir la fiche';

  @override
  String get mapsEntryMissing => 'La fiche liée a été supprimée';

  @override
  String get mapsDeletePin => 'Supprimer';

  @override
  String get mapsPinDeleted => 'Repère supprimé';

  @override
  String get mapsUntitledPin => 'Repère sans nom';

  @override
  String get mapsDescription => 'Description';

  @override
  String get mapsNoDescription => 'Aucune description.';

  @override
  String get mapsScale => 'Échelle';

  @override
  String get mapsNoScale => 'Aucune échelle';

  @override
  String mapsScaleValue(String units, String unit, String px) {
    return '1 case = $units $unit ($px px)';
  }

  @override
  String get mapsScaleHelp =>
      'Une case de la grille couvre cette distance. Laissez les nombres vides pour une carte sans échelle.';

  @override
  String get mapsScaleInvalid =>
      'Saisissez des nombres positifs pour la distance et la taille de case.';

  @override
  String get mapsUnitsPerCell => 'Distance par case';

  @override
  String get mapsUnitName => 'Unité';

  @override
  String get mapsUnitHint => 'lieues, km, pieds…';

  @override
  String get mapsCellPx => 'Case (px)';

  @override
  String get mapsShowGrid => 'Afficher la grille';

  @override
  String get mapsGridNeedsScale =>
      'Définissez une échelle pour afficher la grille.';

  @override
  String get mapsPinsVisibleDefault => 'Nouveaux repères visibles des joueurs';

  @override
  String get mapsEditDetails => 'Modifier les détails';

  @override
  String get mapsDetailsTitle => 'Détails de la carte';

  @override
  String mapsImageSize(int width, int height) {
    return '$width × $height px';
  }

  @override
  String get mapsBlankCanvas => 'Feuille vierge';

  @override
  String get mapsOnMaps => 'Sur les cartes';

  @override
  String get mapsIconPin => 'Repère';

  @override
  String get mapsIconCastle => 'Château';

  @override
  String get mapsIconTown => 'Ville';

  @override
  String get mapsIconDungeon => 'Donjon';

  @override
  String get mapsIconCave => 'Grotte';

  @override
  String get mapsIconForest => 'Forêt';

  @override
  String get mapsIconMountain => 'Montagne';

  @override
  String get mapsIconPort => 'Port';

  @override
  String get mapsIconDanger => 'Danger';

  @override
  String get mapsIconTreasure => 'Trésor';

  @override
  String get mapsIconQuest => 'Quête';

  @override
  String get mapsIconCamp => 'Camp';

  @override
  String get mapsIconNpc => 'Personnage';

  @override
  String get mapsIconPortal => 'Portail';

  @override
  String get mapsIconNote => 'Note';

  @override
  String get mapsColorAuto => 'Automatique (couleur de la fiche)';

  @override
  String get mapsColorAccent => 'Accent';

  @override
  String get mapsColorRed => 'Rouge';

  @override
  String get mapsColorOrange => 'Orange';

  @override
  String get mapsColorYellow => 'Jaune';

  @override
  String get mapsColorGreen => 'Vert';

  @override
  String get mapsColorTeal => 'Sarcelle';

  @override
  String get mapsColorBlue => 'Bleu';

  @override
  String get mapsColorPurple => 'Violet';

  @override
  String get mapsColorPink => 'Rose';

  @override
  String get mapsColorGray => 'Gris';

  @override
  String get generatorsKindNames => 'Noms';

  @override
  String get generatorsKindNpc => 'PNJ';

  @override
  String get generatorsKindSettlement => 'Localité';

  @override
  String get generatorsKindEstablishment => 'Taverne et boutique';

  @override
  String get generatorsKindHook => 'Accroche d\'aventure';

  @override
  String get generatorsKindLoot => 'Butin';

  @override
  String get generatorsKindFaction => 'Faction';

  @override
  String get generatorsKindWeather => 'Météo';

  @override
  String get generatorsKindRumor => 'Rumeur';

  @override
  String get generatorsPicker => 'Générateur';

  @override
  String get generatorsPack => 'Pack de genre';

  @override
  String generatorsPackWorld(String pack) {
    return '$pack (ce monde)';
  }

  @override
  String get generatorsGender => 'Sexe';

  @override
  String get generatorsGenderAny => 'Indifférent';

  @override
  String get generatorsGenderFeminine => 'Féminin';

  @override
  String get generatorsGenderMasculine => 'Masculin';

  @override
  String get generatorsCulture => 'Style de noms';

  @override
  String get generatorsCultureAny => 'Mélangé';

  @override
  String get generatorsCount => 'Combien';

  @override
  String get generatorsEpithets => 'Avec surnoms';

  @override
  String get generatorsGenerate => 'Générer';

  @override
  String get generatorsRerollAll => 'Tout relancer';

  @override
  String generatorsRerollField(String field) {
    return 'Relancer : $field';
  }

  @override
  String get generatorsCopy => 'Copier en texte';

  @override
  String get generatorsCopyAll => 'Tout copier';

  @override
  String get generatorsCopyName => 'Copier le nom';

  @override
  String get generatorsCopied => 'Copié dans le presse-papiers';

  @override
  String get generatorsKeep => 'Garder';

  @override
  String get generatorsUnkeep => 'Ne plus garder';

  @override
  String get generatorsDismiss => 'Écarter';

  @override
  String get generatorsSave => 'Enregistrer dans le monde';

  @override
  String get generatorsSaveAsCharacter => 'Enregistrer comme personnage';

  @override
  String generatorsSaved(String name) {
    return '« $name » enregistré dans le monde';
  }

  @override
  String get generatorsSavedBadge => 'Enregistré';

  @override
  String get generatorsKept => 'Gardés';

  @override
  String get generatorsHistory => 'Récents, non enregistrés';

  @override
  String get generatorsHistoryEmpty =>
      'Les résultats remplacés sans être enregistrés arrivent ici pour cette session.';

  @override
  String get generatorsRestore => 'Rappeler';

  @override
  String get generatorsEmptyTitle => 'Rien de généré pour l\'instant';

  @override
  String get generatorsEmptyHint =>
      'Choisissez un générateur et appuyez sur « Générer ». Relancez n\'importe quelle ligne, gardez les bons résultats et enregistrez-les dans le monde.';

  @override
  String get generatorsFieldName => 'Nom';

  @override
  String get generatorsFieldPlaceName => 'Nom';

  @override
  String get generatorsFieldEpithet => 'Surnom';

  @override
  String get generatorsFieldAncestry => 'Origine';

  @override
  String get generatorsFieldRole => 'Rôle';

  @override
  String get generatorsFieldAge => 'Âge';

  @override
  String get generatorsFieldAppearance => 'Apparence';

  @override
  String get generatorsFieldTrait => 'Trait';

  @override
  String get generatorsFieldMotivation => 'Motivation';

  @override
  String get generatorsFieldSecret => 'Secret';

  @override
  String get generatorsFieldVoice => 'Voix';

  @override
  String get generatorsFieldAttributes => 'Caractéristiques';

  @override
  String get generatorsFieldSize => 'Taille';

  @override
  String get generatorsFieldFeature => 'Particularité';

  @override
  String get generatorsFieldTrouble => 'Problème';

  @override
  String get generatorsFieldAuthority => 'Autorité';

  @override
  String get generatorsFieldType => 'Type';

  @override
  String get generatorsFieldOwner => 'Propriétaire';

  @override
  String get generatorsFieldSpecialty => 'Spécialité';

  @override
  String get generatorsFieldPatron => 'Habitué';

  @override
  String get generatorsFieldTitle => 'Titre';

  @override
  String get generatorsFieldWho => 'Qui';

  @override
  String get generatorsFieldWants => 'Veut';

  @override
  String get generatorsFieldObstacle => 'Obstacle';

  @override
  String get generatorsFieldTwist => 'Rebondissement';

  @override
  String get generatorsFieldContainer => 'Trouvé dans';

  @override
  String get generatorsFieldCoins => 'Pièces';

  @override
  String get generatorsFieldItem => 'Objet';

  @override
  String get generatorsFieldCurio => 'Curiosité';

  @override
  String get generatorsFieldGoal => 'Objectif';

  @override
  String get generatorsFieldMethod => 'Méthodes';

  @override
  String get generatorsFieldSymbol => 'Symbole';

  @override
  String get generatorsFieldSky => 'Ciel';

  @override
  String get generatorsFieldAir => 'Air';

  @override
  String get generatorsFieldOmen => 'Présage';

  @override
  String get generatorsFieldSource => 'Source';

  @override
  String get generatorsFieldTruth => 'Vérité';

  @override
  String get starterContentTitle => 'Commencer avec des exemples';

  @override
  String get starterContentHint =>
      'Un lieu et ses habitants, une faction, deux accroches d’aventure dans une première campagne et des tables aléatoires prêtes — générés pour l’univers choisi. Tout se modifie ou se supprime.';

  @override
  String get starterCampaignName => 'La première aventure';
}
