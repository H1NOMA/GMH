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
  String get languageGerman => 'Deutsch';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageChinese => '中文';

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
  String get newTab => 'Новая вкладка';

  @override
  String get changeImage => 'Изменить изображение';

  @override
  String get addImage => 'Добавить изображение';

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
  String get cyberKindCharacter => 'Раннер';

  @override
  String get cyberKindCharacterPlural => 'Раннеры';

  @override
  String get cyberKindLocation => 'Сектор';

  @override
  String get cyberKindLocationPlural => 'Сектора';

  @override
  String get cyberKindItem => 'Снаряжение';

  @override
  String get cyberKindItemPlural => 'Снаряжение и тех';

  @override
  String get cyberKindCreature => 'Киберформа';

  @override
  String get cyberKindCreaturePlural => 'Киберформы';

  @override
  String get cyberKindFaction => 'Синдикат';

  @override
  String get cyberKindFactionPlural => 'Корпорации и банды';

  @override
  String get cyberKindEvent => 'Инцидент';

  @override
  String get cyberKindEventPlural => 'Инциденты';

  @override
  String get cyberKindEra => 'Эпоха';

  @override
  String get cyberKindEraPlural => 'Эпохи';

  @override
  String get cyberKindReligion => 'Культ';

  @override
  String get cyberKindReligionPlural => 'Культы';

  @override
  String get cyberKindMagicSystem => 'Протокол';

  @override
  String get cyberKindMagicSystemPlural => 'Протоколы';

  @override
  String get cyberKindTechnology => 'Кибервэр';

  @override
  String get cyberKindTechnologyPlural => 'Кибервэр';

  @override
  String get cyberKindConcept => 'Фрагмент данных';

  @override
  String get cyberKindConceptPlural => 'Хранилище данных';

  @override
  String get cyberKindLoreDocument => 'Дата-шард';

  @override
  String get cyberKindLoreDocumentPlural => 'Дата-шарды';

  @override
  String get cyberKindCampaign => 'Операция';

  @override
  String get cyberKindCampaignPlural => 'Операции';

  @override
  String get cyberKindQuest => 'Заказ';

  @override
  String get cyberKindQuestPlural => 'Заказы';

  @override
  String get cyberKindSession => 'Забег';

  @override
  String get cyberKindSessionPlural => 'Забеги';

  @override
  String get worldStyleLabel => 'Стиль мира';

  @override
  String get worldStyleFantasy => 'Фэнтези';

  @override
  String get worldStyleFantasyHint =>
      'Пергамент при свечах, классические термины: Персонажи, Локации, Квесты';

  @override
  String get worldStyleCyberpunk => 'Киберпанк';

  @override
  String get worldStyleCyberpunkHint =>
      'Неон, хром и уличный сленг: Раннеры, Сектора, Заказы';

  @override
  String get viewAsGrid => 'Вид сеткой';

  @override
  String get viewAsList => 'Вид списком';

  @override
  String get blueprintFieldsSection => 'Поля';

  @override
  String get constructorTitleNew => 'Конструктор раздела';

  @override
  String get constructorTitleEdit => 'Настройка раздела';

  @override
  String get constructorModules => 'Модули';

  @override
  String get constructorModulesHint =>
      'Добавляйте и убирайте блоки, из которых будут состоять записи этого раздела.';

  @override
  String get moduleFields => 'Структурные поля';

  @override
  String get moduleFieldsHint => 'Форма из полей, которые вы зададите ниже';

  @override
  String get moduleDocument => 'Документ';

  @override
  String get moduleDocumentHint =>
      'Редактор текста со ссылками и изображениями';

  @override
  String get moduleGallery => 'Галерея';

  @override
  String get moduleGalleryHint => 'Сетка изображений у каждой записи';

  @override
  String get moduleAttachments => 'Файлы';

  @override
  String get moduleAttachmentsHint => 'Прикреплённые файлы любого типа';

  @override
  String get moduleTags => 'Теги';

  @override
  String get moduleTagsHint => 'Теги и фильтры по ним';

  @override
  String get moduleRelations => 'Связи';

  @override
  String get moduleRelationsHint => 'Ссылки на другие записи и обратные ссылки';

  @override
  String get constructorFields => 'Свои поля';

  @override
  String get constructorFieldsEmpty =>
      'Полей пока нет — добавьте нужные разделу, например «Уровень», «Школа», «Цена».';

  @override
  String get addField => 'Добавить поле';

  @override
  String get editField => 'Изменить поле';

  @override
  String get fieldNameLabel => 'Название поля';

  @override
  String get fieldTypeLabel => 'Тип поля';

  @override
  String get fieldOptionsLabel => 'Варианты (через запятую)';

  @override
  String get fieldOptionsHint => 'напр. Обычный, Редкий, Легендарный';

  @override
  String get fieldTypeText => 'Текст';

  @override
  String get fieldTypeLongText => 'Длинный текст';

  @override
  String get fieldTypeNumber => 'Число';

  @override
  String get fieldTypeSelect => 'Список вариантов';

  @override
  String get fieldTypeDate => 'Дата';

  @override
  String get fieldTypeChecklist => 'Чек-лист';

  @override
  String get fieldTypeStringList => 'Список значений';

  @override
  String get pauseSaveProject => 'Сохранить проект';

  @override
  String get pauseExit => 'Выйти';

  @override
  String get helpTitle => 'Руководство';

  @override
  String get helpSettingsSubtitle =>
      'Встроенная инструкция: где что находится и как этим пользоваться';

  @override
  String get helpIntroBody =>
      'Game Master\'s Hub — офлайн-рабочее место мастера: миры, персонажи, локации, кампании и лор хранятся на этом устройстве и связаны в единую сеть. Это руководство проходит по всем частям приложения. Схемы ниже — упрощённые изображения настоящих экранов, а пронумерованные метки объясняются под каждой картинкой.';

  @override
  String get helpWorldsTitle => 'Миры и стили миров';

  @override
  String get helpWorldsBody =>
      'Всё начинается с мира — полностью изолированного проекта со своими записями, тегами и кампаниями. Выбор мира открывается при запуске; иконка глобуса в боковой панели вернёт вас туда в любой момент. При создании мира выбирается стиль: Фэнтези (пергамент и классические термины — Персонажи, Локации, Квесты) или Киберпанк (неоновая палитра и уличный сленг — Раннеры, Секторы, Гиги). Стиль меняет весь облик и словарь конкретного мира. Каждый мир помнит, где вы остановились, и открывается ровно там же.';

  @override
  String get helpShellTitle => 'Навигация и боковая панель';

  @override
  String get helpShellBody =>
      'Левая панель — ваш пульт управления. В ней основные страницы, разделы «Мир» и «Библиотека» с живыми счётчиками записей и ваши собственные категории. Зажмите и перетащите любую вкладку, чтобы изменить порядок группы — порядок сохраняется для каждого мира. На планшетах панель сворачивается в рейку, на телефонах — в нижнюю панель.';

  @override
  String get helpShellLegend1 =>
      'Переключатель миров — нажмите на шапку, чтобы вернуться к выбору мира.';

  @override
  String get helpShellLegend2 =>
      'Назад / Вперёд — история как в браузере по всему, что вы открывали. Alt+← / Alt+→ работают везде.';

  @override
  String get helpShellLegend3 =>
      'Вкладки разделов со счётчиками. Зажмите и перетащите, чтобы изменить порядок; он сохранится.';

  @override
  String get helpShellLegend4 =>
      'Управление списком — фильтр, переключатель сетка/список, сортировка и фильтр избранного.';

  @override
  String get helpShellLegend5 =>
      'Карточки записей показывают описание и контекстные чипы: статус, расу, редкость, даты — по смыслу раздела.';

  @override
  String get helpShellLegend6 =>
      'Новая запись — создаёт запись в открытом разделе.';

  @override
  String get helpEntryTitle => 'Записи: документ, поля и вложения';

  @override
  String get helpEntryBody =>
      'Каждая запись — страница с текстовым документом и структурной боковой панелью. Редактор поддерживает заголовки, списки, цитаты, изображения (вставкой или перетаскиванием прямо в текст), вложенные файлы и историю версий (иконка часов на панели инструментов). Наберите @ или нажмите кнопку упоминания, чтобы сослаться на другую запись прямо в тексте — ссылки двусторонние и питают граф. В боковой панели — поля шаблона, теги, связи с обратными ссылками и галерея.';

  @override
  String get helpEntryLegend1 =>
      'Имя — нажмите, чтобы переименовать; звёздочка добавляет в избранное.';

  @override
  String get helpEntryLegend2 =>
      'Панель редактора: форматирование, выравнивание, упоминание @, вставка изображения, файл, история версий.';

  @override
  String get helpEntryLegend3 =>
      'Упоминание другой записи в тексте — клик открывает её; заодно создаётся обратная ссылка.';

  @override
  String get helpEntryLegend4 =>
      'Структурные поля типа записи (или вашего конструктора раздела).';

  @override
  String get helpEntryLegend5 =>
      'Галерея и вложения — перетащите файлы в любое место страницы, чтобы прикрепить.';

  @override
  String get helpProfileTitle => 'Профили персонажей';

  @override
  String get helpProfileBody =>
      'Персонажи открываются как полный профиль с вкладками: Общее, Биография, Характеристики с D&D-сеткой и модификаторами, Убеждения, Отношения (союзники, враги, фракции — всё это настоящие связи), Инвентарь, Способности и магия, Хронология и Заметки. Портрет берётся из обложки записи — назначьте любую картинку галереи обложкой через её меню. Каждое заполненное отношение появляется в графе и обратной ссылкой у цели.';

  @override
  String get helpCampaignsTitle => 'Кампании, квесты и сессии';

  @override
  String get helpCampaignsBody =>
      'Страница «Кампании» — панель вашего игрового стола. Активная кампания выбирается в выпадающем списке в правом верхнем углу — выбор запоминается для каждого мира. Доска квестов показывает все квесты, у которых поле «Кампания» указывает на выбранную, сгруппированные по статусу; журнал сессий собирает записи сессий так же. Квесты и сессии создаются прямо отсюда — связь с кампанией заполняется автоматически.';

  @override
  String get helpSearchTitle => 'Поиск и теги';

  @override
  String get helpSearchBody =>
      'Поиск (лупа в боковой панели) — мгновенный полнотекстовый поиск по именам, описаниям, документам и тегам. Чипы-фильтры сужают выдачу до раздела или категории. Теги управляются в Менеджере тегов — из боковой панели или быстрых действий поиска: переименование, цвет, слияние дубликатов и удаление с живыми счётчиками использования. Любой список фильтруется по тегу и избранному.';

  @override
  String get helpGraphTitle => 'Граф связей';

  @override
  String get helpGraphBody =>
      'Граф показывает мир как живую сеть: каждое упоминание, связь и структурное поле становятся ребром. Цвета соответствуют типам записей, размер узла — числу связей. Нажмите узел, чтобы открыть запись, или используйте «Показать в графе» у любой записи для её локального окружения. Фильтр типов в панели скрывает лишние категории.';

  @override
  String get helpConstructorTitle => 'Свои разделы и конструктор';

  @override
  String get helpConstructorBody =>
      'Помимо встроенных разделов можно создавать собственные — Гильдии, Заклинания, Рецепты, что угодно. Свой раздел ведёт себя как встроенный: вкладка с счётчиком, плитка на дашборде, фильтр поиска, цвета графа и главы PDF. Конструктор раздела определяет, как выглядят его записи: включайте и выключайте модули и задавайте свои поля семи типов. Удаление категории никогда не удаляет записи — они переезжают в Архив концептов.';

  @override
  String get helpConstructorLegend1 =>
      'Модули — блоки, из которых состоит страница записи. Выключенные исчезают целиком.';

  @override
  String get helpConstructorLegend2 =>
      'Свои поля с типами: текст, длинный текст, число, список вариантов, дата, чек-лист, список значений. Перетаскивайте для сортировки.';

  @override
  String get helpConstructorLegend3 =>
      'Добавить поле — первые поля также становятся чипами на карточках раздела.';

  @override
  String get helpBackupTitle => 'Бэкапы и перенос между устройствами';

  @override
  String get helpBackupBody =>
      'Всё хранится локально — без аккаунта и облака. Раз в день приложение делает автоматический бэкап; в Настройках его можно сделать в любой момент. Чтобы перенести или поделиться миром, экспортируйте архив .gmhw — один файл с базой и всеми медиа. Импорт на другом устройстве восстанавливает мир в точности, включая свои разделы и стили. Там же в Настройках — экспорт JSON и печатная PDF-книга мира.';

  @override
  String get helpTipsTitle => 'Советы и горячие клавиши';

  @override
  String get helpTipsBody =>
      'Alt+← / Alt+→ — навигация назад и вперёд. Наберите @ в редакторе, чтобы ссылаться на записи прямо при письме. Зажмите вкладки панели, поля конструктора или плитки галереи, чтобы перетащить их. Правый клик (или долгое нажатие) по вложению — переименование, замена, обложка. Переключатель сетка/список запоминается для каждого раздела. Сортировка, фильтры и выбранная кампания тоже запоминаются — приложение всегда открывается там, где вы остановились. Ctrl+K мгновенно открывает поиск; боковые кнопки мыши листают историю, а стрелки навигации — слева вверху каждой страницы.';

  @override
  String get helpScreenshotCaption =>
      'Скриншот приложения (английский интерфейс)';

  @override
  String get helpFigureCaption => 'Схема реального экрана';
}
