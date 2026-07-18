// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Game Master\'s Hub';

  @override
  String get navDashboard => 'Обзор мира';

  @override
  String get navSearch => 'Поиск';

  @override
  String get navGraph => 'Граф связей';

  @override
  String get navGraphShort => 'Граф';

  @override
  String get navCampaigns => 'Кампании';

  @override
  String get navSettings => 'Настройки и резервные копии';

  @override
  String get navSettingsShort => 'Настройки';

  @override
  String get navHome => 'Главная';

  @override
  String get sectionWorld => 'МИР';

  @override
  String get sectionLibrary => 'БИБЛИОТЕКА';

  @override
  String get switchWorld => 'Сменить мир';

  @override
  String get worldsTagline =>
      'Ваши миры принадлежат только вам — всё хранится на этом устройстве.';

  @override
  String worldsLoadError(String error) {
    return 'Не удалось загрузить миры: $error';
  }

  @override
  String get worldsEmpty => 'Миров пока нет. Создайте свой первый мир ниже.';

  @override
  String worldEdited(String when) {
    return 'Изменён $when';
  }

  @override
  String get createNewWorld => 'Создать новый мир';

  @override
  String get createWorldTitle => 'Создание нового мира';

  @override
  String get worldNameLabel => 'Название мира';

  @override
  String get worldNameHint => 'например, Королевства Ауриона';

  @override
  String get worldDescriptionLabel => 'Описание (необязательно)';

  @override
  String get cancel => 'Отмена';

  @override
  String get create => 'Создать';

  @override
  String get add => 'Добавить';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get restore => 'Восстановить';

  @override
  String get open => 'Открыть';

  @override
  String get rename => 'Переименовать';

  @override
  String get newButton => 'Создать';

  @override
  String errorGeneric(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get errorNameEmpty => 'Название не может быть пустым.';

  @override
  String get errorUnexpected => 'Что-то пошло не так. Попробуйте ещё раз.';

  @override
  String get homeTheWorld => 'Мир';

  @override
  String get homeLibrary => 'Библиотека';

  @override
  String get homeFavorites => 'Избранное';

  @override
  String get homeRecentlyOpened => 'Недавно открытые';

  @override
  String entriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записей',
      few: '$count записи',
      one: '$count запись',
      zero: 'Нет записей',
    );
    return '$_temp0';
  }

  @override
  String filterHint(String plural) {
    return 'Фильтр: $plural…';
  }

  @override
  String get favoritesOnly => 'Только избранное';

  @override
  String get showAll => 'Показать все';

  @override
  String get sortTooltip => 'Сортировка';

  @override
  String get sortRecentlyEdited => 'Недавно изменённые';

  @override
  String get sortNameAz => 'По названию (А–Я)';

  @override
  String get sortNewestFirst => 'Сначала новые';

  @override
  String noEntriesOfKind(String plural) {
    return 'Раздел «$plural» пока пуст';
  }

  @override
  String newOfKind(String label) {
    return 'Создать: $label';
  }

  @override
  String get newEntryTitle => 'Новая запись';

  @override
  String get typeLabel => 'Тип';

  @override
  String get nameLabel => 'Название';

  @override
  String get editEntryTitle => 'Изменить запись';

  @override
  String get summaryLabel => 'Краткое описание';

  @override
  String get summaryHint => 'Одна строка для списков и поиска';

  @override
  String deleteEntryTitle(String name) {
    return 'Удалить «$name»?';
  }

  @override
  String get deleteEntryBody =>
      'Запись перемещается в корзину; связи с ней сохраняются до окончательного удаления.';

  @override
  String get addToFavorites => 'Добавить в избранное';

  @override
  String get removeFromFavorites => 'Убрать из избранного';

  @override
  String get menuEditNameSummary => 'Изменить название и описание';

  @override
  String get menuShowInGraph => 'Показать в графе';

  @override
  String get entryGone => 'Эта запись больше не существует.';

  @override
  String get tabDocument => 'Документ';

  @override
  String get tabDetails => 'Свойства';

  @override
  String get editorPlaceholder =>
      'Пишите историю… Кнопка @ вставляет ссылку на запись.';

  @override
  String get editorLinkEntity => 'Ссылка на запись (упоминание)';

  @override
  String get editorInsertImage => 'Вставить изображение';

  @override
  String get editorAttachFile => 'Прикрепить файл в текст';

  @override
  String get editorVersionHistory => 'История версий';

  @override
  String get insertLinkTitle => 'Вставить ссылку на запись';

  @override
  String get missingLink => 'не найдено';

  @override
  String get versionHistoryTitle => 'История версий';

  @override
  String get versionHistoryEmpty =>
      'Снимков пока нет. Версии сохраняются при выходе из редактора и при восстановлении.';

  @override
  String get versionEmptyPreview => '(пусто)';

  @override
  String get versionBeforeRestore => 'Перед восстановлением';

  @override
  String get searchHint => 'Поиск по названиям, текстам, тегам…';

  @override
  String get searchAll => 'Все';

  @override
  String get searchNoMatches => 'Ничего не найдено';

  @override
  String get quickActions => 'БЫСТРЫЕ ДЕЙСТВИЯ';

  @override
  String get quickNewEntry => 'Новая запись';

  @override
  String get quickOpenGraph => 'Открыть граф';

  @override
  String get quickBackupExport => 'Резервные копии и экспорт';

  @override
  String get recentlyOpenedCaps => 'НЕДАВНО ОТКРЫТЫЕ';

  @override
  String get graphTitle => 'Граф связей';

  @override
  String get graphLocalTitle => 'Локальный граф';

  @override
  String get graphWholeWorld => 'Весь мир';

  @override
  String get graphFilterKinds => 'Фильтр по типам';

  @override
  String get graphEmpty =>
      'Связей пока нет.\nСвязывайте записи через @-упоминания, отношения и структурные поля — и здесь появится паутина вашего мира.';

  @override
  String graphTruncated(int count) {
    return 'Показаны $count самых связанных записей. Откройте запись, чтобы увидеть её локальный граф.';
  }

  @override
  String get campaignsTitle => 'Кампании';

  @override
  String get switchCampaign => 'Сменить кампанию';

  @override
  String get noCampaigns => 'Кампаний пока нет';

  @override
  String get startCampaign => 'Начать кампанию';

  @override
  String get questBoard => 'Доска квестов';

  @override
  String get sessionLog => 'Журнал сессий';

  @override
  String get noQuestsLinked =>
      'К этой кампании ещё не привязаны квесты. Создайте квест и укажите его поле «Кампания».';

  @override
  String get noSessions => 'Сессий пока не записано.';

  @override
  String chapterLabel(String chapter) {
    return 'Глава: $chapter';
  }

  @override
  String get noPlayers => 'Игроков пока нет';

  @override
  String questsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count квестов',
      few: '$count квеста',
      one: '$count квест',
    );
    return '$_temp0';
  }

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сессий',
      few: '$count сессии',
      one: '$count сессия',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Настройки и резервные копии';

  @override
  String get languageSection => 'Язык';

  @override
  String get languageSystem => 'Язык системы';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String exportSection(String world) {
    return 'Экспорт «$world»';
  }

  @override
  String get exportSubtitle =>
      'Всё остаётся на этом устройстве, пока вы сами не поделитесь файлом.';

  @override
  String get exportArchiveTitle => 'Полный архив проекта (.gmhw)';

  @override
  String get exportArchiveSubtitle =>
      'База данных и все файлы в одном архиве. Подходит для переноса между устройствами.';

  @override
  String get exportJsonTitle => 'Экспорт данных в JSON';

  @override
  String get exportJsonSubtitle =>
      'Все записи, связи и метаданные в читаемом JSON.';

  @override
  String get exportPdfTitle => 'PDF-книга мира';

  @override
  String get exportPdfSubtitle =>
      'Печатная книга вашего мира, по главе на категорию.';

  @override
  String get importSection => 'Импорт';

  @override
  String get importArchiveTitle => 'Импорт архива проекта';

  @override
  String get importArchiveSubtitle =>
      'Восстанавливает файл .gmhw вместе со всеми медиафайлами.';

  @override
  String get importPickArchive => 'Выберите архив .gmhw';

  @override
  String get backupsSection => 'Резервные копии';

  @override
  String backupsSubtitle(int count) {
    return 'Резервная копия создаётся автоматически раз в день при запуске приложения. Хранятся последние $count.';
  }

  @override
  String get backupNow => 'Создать копию сейчас';

  @override
  String get noBackups => 'Резервных копий пока нет.';

  @override
  String get restoreBackupTitle => 'Восстановить эту копию?';

  @override
  String restoreBackupBody(String file) {
    return 'Мир будет заменён содержимым файла «$file». Перед этим автоматически создаётся страховочная копия текущего состояния.';
  }

  @override
  String get aboutSection => 'О приложении';

  @override
  String get aboutLocalFirst => 'Локальное хранение';

  @override
  String get aboutLocalFirstBody =>
      'Все данные хранятся на этом устройстве. Без аккаунта, без облака, полностью офлайн.';

  @override
  String get backupSaved => 'Резервная копия сохранена.';

  @override
  String get worldImported => 'Мир импортирован.';

  @override
  String get backupRestored => 'Резервная копия восстановлена.';

  @override
  String savedTo(String path) {
    return 'Сохранено в: $path';
  }

  @override
  String get shareArchiveText => 'Архив мира GMH';

  @override
  String get shareJsonText => 'Данные мира GMH (JSON)';

  @override
  String get sharePdfText => 'Книга мира GMH (PDF)';

  @override
  String get relationsCaps => 'СВЯЗИ';

  @override
  String get backlinksCaps => 'ОБРАТНЫЕ ССЫЛКИ';

  @override
  String get addRelation => 'Добавить связь';

  @override
  String get openInGraph => 'Открыть в графе';

  @override
  String get noOutgoingRelations => 'Исходящих связей пока нет.';

  @override
  String get noBacklinks => 'Сюда пока ничто не ссылается.';

  @override
  String relationToTitle(String name) {
    return 'Связь с «$name»';
  }

  @override
  String get roleLabel => 'Роль';

  @override
  String get roleHint => 'например: владелец, союзник, соперник';

  @override
  String get fromDocumentMention => 'Из упоминания в документе';

  @override
  String get fromStructuredField => 'Из структурного поля';

  @override
  String get roleMention => 'Упоминается в';

  @override
  String get roleRelated => 'Связано с';

  @override
  String get roleOwner => 'Владелец';

  @override
  String get roleLocatedAt => 'Находится в';

  @override
  String get roleMemberOf => 'Состоит в';

  @override
  String get rolePartOf => 'Часть';

  @override
  String get roleParticipatedIn => 'Участвует в';

  @override
  String get roleCreatedAt => 'Создано в';

  @override
  String get roleQuestGiver => 'Квестодатель';

  @override
  String get roleAlly => 'Союзник';

  @override
  String get roleFriend => 'Друг';

  @override
  String get roleFamily => 'Семья';

  @override
  String get roleEnemy => 'Враг';

  @override
  String get roleRival => 'Соперник';

  @override
  String get tabBiography => 'Биография';

  @override
  String get tabProfile => 'Профиль';

  @override
  String get attachmentsCaps => 'ВЛОЖЕНИЯ';

  @override
  String get addFiles => 'Добавить файлы';

  @override
  String get fromGallery => 'Из фотогалереи';

  @override
  String get noAttachments => 'Вложений пока нет.';

  @override
  String get dropFilesHere => 'Перетащите файлы сюда, чтобы прикрепить';

  @override
  String get setAsCover => 'Сделать обложкой';

  @override
  String get editCaption => 'Изменить подпись';

  @override
  String get captionLabel => 'Подпись';

  @override
  String get replaceFile => 'Заменить файл';

  @override
  String get deleteAttachment => 'Убрать вложение';

  @override
  String deleteAttachmentTitle(String name) {
    return 'Убрать «$name»?';
  }

  @override
  String get deleteAttachmentBody =>
      'Вложение будет убрано из этой записи. Сам файл удаляется из хранилища, когда его не использует ни одна запись.';

  @override
  String get renameAttachmentTitle => 'Переименовать вложение';

  @override
  String get previewUnavailable =>
      'Предпросмотр для этого типа файлов недоступен. Откройте его в другом приложении.';

  @override
  String get openExternally => 'Открыть в другом приложении';

  @override
  String attachmentsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Прикреплено $count файлов',
      few: 'Прикреплено $count файла',
      one: 'Прикреплён $count файл',
    );
    return '$_temp0';
  }

  @override
  String get tagChip => 'Тег';

  @override
  String get addTagTitle => 'Добавить тег';

  @override
  String get tagNameHint => 'Название тега';

  @override
  String get none => 'Нет';

  @override
  String get choose => 'Выбрать…';

  @override
  String addToList(String label) {
    return 'Добавить в «$label»';
  }

  @override
  String get clear => 'Очистить';

  @override
  String get pickerTitleDefault => 'Ссылка на запись';

  @override
  String get pickerSearchAll => 'Поиск по всем записям…';

  @override
  String pickerSearchKinds(String kinds) {
    return 'Поиск: $kinds…';
  }

  @override
  String get pickerNoMatches => 'Подходящих записей нет';

  @override
  String get justNow => 'только что';

  @override
  String minutesAgo(int count) {
    return '$count мин назад';
  }

  @override
  String hoursAgo(int count) {
    return '$count ч назад';
  }

  @override
  String daysAgo(int count) {
    return '$count дн назад';
  }

  @override
  String get sectionCategories => 'МОИ КАТЕГОРИИ';

  @override
  String get manageCategories => 'Управление категориями';

  @override
  String get newCategory => 'Новая категория';

  @override
  String get renameCategory => 'Изменить категорию';

  @override
  String get deleteCategory => 'Удалить категорию';

  @override
  String deleteCategoryTitle(String name) {
    return 'Удалить категорию «$name»?';
  }

  @override
  String deleteCategoryBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Её $count записей сохранятся и переместятся в Архив концептов.',
      few: 'Её $count записи сохранятся и переместятся в Архив концептов.',
      one: 'Её $count запись сохранится и переместится в Архив концептов.',
    );
    return '$_temp0';
  }

  @override
  String get deleteCategoryBodyEmpty =>
      'Категория пуста; больше ничего не изменится.';

  @override
  String get categoryNameLabel => 'Название категории';

  @override
  String get categoryNameHint => 'например: Гильдии, Королевства, Ритуалы…';

  @override
  String get chooseIcon => 'Иконка';

  @override
  String get noCategoriesYet =>
      'Своих категорий пока нет. Создайте первую — она будет работать так же, как встроенные разделы.';

  @override
  String get kindCustomEntry => 'Запись';

  @override
  String get tagManagerTitle => 'Менеджер тегов';

  @override
  String get searchTagsHint => 'Поиск тегов…';

  @override
  String get sortByName => 'По алфавиту';

  @override
  String get sortByCreated => 'По дате создания';

  @override
  String get sortByUsage => 'По использованию';

  @override
  String get newTag => 'Новый тег';

  @override
  String get mergeTagAction => 'Объединить с другим тегом…';

  @override
  String mergeTagTitle(String name) {
    return 'Объединение «$name»';
  }

  @override
  String mergeTagBody(String name) {
    return 'Все записи с тегом «$name» получат выбранный ниже тег, а «$name» будет удалён.';
  }

  @override
  String get changeColor => 'Изменить цвет';

  @override
  String deleteTagTitle(String name) {
    return 'Удалить тег «$name»?';
  }

  @override
  String deleteTagBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Тег будет снят с $count записей. Сами записи останутся.',
      few: 'Тег будет снят с $count записей. Сами записи останутся.',
      one: 'Тег будет снят с $count записи. Сама запись останется.',
      zero: 'Этот тег не используется ни одной записью.',
    );
    return '$_temp0';
  }

  @override
  String get noTags =>
      'Тегов пока нет. Здесь появятся теги, которые вы добавляете к записям.';

  @override
  String get noTagMatches => 'По запросу ничего не найдено.';

  @override
  String get appearanceSection => 'Оформление';

  @override
  String get themeSystem => 'Как в системе';

  @override
  String get themeLight => 'Светлая тема';

  @override
  String get themeDark => 'Тёмная тема';

  @override
  String get navBack => 'Назад';

  @override
  String get navForward => 'Вперёд';

  @override
  String get kindCharacter => 'Персонаж';

  @override
  String get kindCharacterPlural => 'Персонажи';

  @override
  String get kindLocation => 'Локация';

  @override
  String get kindLocationPlural => 'Локации';

  @override
  String get kindItem => 'Предмет';

  @override
  String get kindItemPlural => 'Предметы';

  @override
  String get kindCreature => 'Существо';

  @override
  String get kindCreaturePlural => 'Существа';

  @override
  String get kindFaction => 'Фракция';

  @override
  String get kindFactionPlural => 'Фракции';

  @override
  String get kindEvent => 'Событие';

  @override
  String get kindEventPlural => 'События';

  @override
  String get kindEra => 'Эпоха';

  @override
  String get kindEraPlural => 'Эпохи';

  @override
  String get kindReligion => 'Религия';

  @override
  String get kindReligionPlural => 'Религии';

  @override
  String get kindMagicSystem => 'Система магии';

  @override
  String get kindMagicSystemPlural => 'Системы магии';

  @override
  String get kindTechnology => 'Технология';

  @override
  String get kindTechnologyPlural => 'Технологии';

  @override
  String get kindConcept => 'Концепт';

  @override
  String get kindConceptPlural => 'Архив концептов';

  @override
  String get kindLoreDocument => 'Документ лора';

  @override
  String get kindLoreDocumentPlural => 'Документы лора';

  @override
  String get kindCampaign => 'Кампания';

  @override
  String get kindCampaignPlural => 'Кампании';

  @override
  String get kindQuest => 'Квест';

  @override
  String get kindQuestPlural => 'Квесты';

  @override
  String get kindSession => 'Сессия';

  @override
  String get kindSessionPlural => 'Сессии';

  @override
  String get close => 'Закрыть';

  @override
  String get ttgImportTitle => 'Импорт базы TTG';

  @override
  String get ttgImportIntro =>
      'Перенесите полную базу данных TTG D&D — кампании, NPC, монстров, заклинания, предметы, локации, фракции, квесты, медиа и все связи — в мир GMH. Поддерживаются: базы SQLite (.db, .sqlite, .ttg), экспорт в JSON и ZIP-экспорт с медиафайлами.';

  @override
  String get ttgPickFile => 'Выбрать базу TTG…';

  @override
  String ttgPreviewCount(int count) {
    return 'Обнаружено записей: $count';
  }

  @override
  String get ttgResumeBanner =>
      'Найден прерванный импорт этого файла. Он будет продолжен — уже импортированные записи пропускаются.';

  @override
  String get ttgWorldName => 'Название мира';

  @override
  String get ttgDuplicatesLabel => 'Если запись уже существует';

  @override
  String get ttgSkip => 'Пропустить';

  @override
  String get ttgMerge => 'Объединить';

  @override
  String get ttgReplace => 'Заменить';

  @override
  String get ttgAsk => 'Спрашивать каждый раз';

  @override
  String get ttgBack => 'Назад';

  @override
  String get ttgStart => 'Начать импорт';

  @override
  String get ttgResume => 'Продолжить импорт';

  @override
  String get ttgPhaseReading => 'Чтение источника';

  @override
  String get ttgPhaseEntities => 'Импорт записей';

  @override
  String get ttgPhaseLinks => 'Восстановление связей';

  @override
  String get ttgPhaseValidating => 'Проверка';

  @override
  String get ttgPhaseIndexing => 'Построение поискового индекса';

  @override
  String ttgEta(int seconds) {
    return 'осталось ~$seconds с';
  }

  @override
  String get ttgErrorLog => 'Проблемы';

  @override
  String get ttgDoneTitle => 'Миграция завершена';

  @override
  String get ttgInterruptedTitle =>
      'Импорт прерван — его можно продолжить позже';

  @override
  String get ttgStatImported => 'Импортировано записей';

  @override
  String get ttgStatLinks => 'Создано связей';

  @override
  String get ttgStatMedia => 'Импортировано медиафайлов';

  @override
  String get ttgStatDocuments => 'Создано документов';

  @override
  String get ttgStatTags => 'Создано тегов';

  @override
  String get ttgStatRepaired => 'Исправлено ссылок';

  @override
  String get ttgStatSkipped => 'Пропущено дубликатов';

  @override
  String get ttgOpenWorld => 'Открыть мир';

  @override
  String get ttgDuplicateTitle => 'Найден дубликат';

  @override
  String ttgDuplicateBody(String name, String collection) {
    return '«$name» ($collection) уже существует в этом мире. Что сделать?';
  }

  @override
  String get ttgApplyToAll => 'Применить ко всем оставшимся дубликатам';

  @override
  String get ttgSettingsTitle => 'Импорт базы TTG';

  @override
  String get ttgSettingsSubtitle =>
      'Перенос полной базы TTG D&D в новый мир: все записи, связи, форматирование и медиа';
}
