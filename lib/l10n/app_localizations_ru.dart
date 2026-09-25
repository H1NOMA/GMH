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
  String get worldStyleLabel => 'Стиль мира';

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

  @override
  String get editWorldTitle => 'Изменить мир';

  @override
  String get worldActions => 'Действия с миром';

  @override
  String deleteWorldTitle(String name) {
    return 'Удалить «$name»?';
  }

  @override
  String get deleteWorldBody =>
      'Все записи, документы, изображения и кампании этого мира будут удалены безвозвратно. Файлы резервных копий сохранятся.';

  @override
  String get worldSection => 'Мир';

  @override
  String get navTools => 'Инструменты';

  @override
  String get sectionTools => 'ЗА СТОЛОМ';

  @override
  String get toolDice => 'Кубы';

  @override
  String get toolDiceHint =>
      'Любая нотация — 4d6kh3, 2d20kl1, 3d6!, dF — с пресетами и журналом бросков.';

  @override
  String get toolCombat => 'Трекер боя';

  @override
  String get toolCombatHint =>
      'Инициатива, хиты, состояния и раунды; сложность столкновения.';

  @override
  String get toolTables => 'Таблицы случайностей';

  @override
  String get toolTablesHint =>
      'Свои таблицы бросков с весами, диапазонами и вложенными бросками.';

  @override
  String get toolGenerators => 'Генераторы';

  @override
  String get toolGeneratorsHint =>
      'Имена, NPC, таверны, добыча, погода, слухи — под ваш сеттинг.';

  @override
  String get toolMaps => 'Карты';

  @override
  String get toolMapsHint =>
      'Интерактивные карты с метками, связанными с записями; вложенные карты.';

  @override
  String get toolTimeline => 'Хронология';

  @override
  String get toolTimelineHint =>
      'События и эпохи вашего мира в хронологическом порядке.';

  @override
  String get toolReference => 'Ширма мастера';

  @override
  String get toolReferenceHint =>
      'Состояния и быстрые правила под рукой (SRD 5.2.1).';

  @override
  String importReplaceTitle(String name) {
    return 'Заменить «$name»?';
  }

  @override
  String get importReplaceBody =>
      'В архиве мир, который уже есть здесь. Импорт полностью заменит его текущую версию.';

  @override
  String get importReplaceAction => 'Заменить';

  @override
  String get searchIndexFailed =>
      'Мир восстановлен, но поиск перестроить не удалось. Перезапустите приложение, чтобы повторить.';

  @override
  String get fieldNotANumber => 'Введите число';

  @override
  String get pdfBookSubtitle => 'Книга мира';

  @override
  String get pdfIncludeGmOnly => 'Включить секреты мастера';

  @override
  String get pdfIncludeGmOnlyHint =>
      'Выключено: книга для игроков без полей «только для мастера».';

  @override
  String get exportAction => 'Экспортировать';

  @override
  String get tagNameTaken =>
      'Тег с таким именем уже есть — воспользуйтесь слиянием.';

  @override
  String get errorEntryGone => 'Эта запись больше не существует.';

  @override
  String get errorNotFound =>
      'Не удалось найти объект — возможно, он был удалён.';

  @override
  String get errorStorage =>
      'Не удалось прочитать или записать файл. Проверьте свободное место и права доступа к папке.';

  @override
  String get errorDatabase =>
      'База данных не смогла выполнить операцию. Данные не изменены.';

  @override
  String get errorArchiveMissing => 'Файл архива не найден.';

  @override
  String get errorArchiveInvalid =>
      'Этот файл не является корректным архивом мира GMH.';

  @override
  String get errorExport =>
      'Экспорт не удался. Проверьте свободное место и доступ на запись в папку.';

  @override
  String get errorAiNotConfigured => 'ИИ-провайдер не настроен.';

  @override
  String get diceExpressionLabel => 'Формула броска';

  @override
  String get diceExpressionHint => 'напр. 2d6+3, 4d6kh3, 1d20!';

  @override
  String get diceRollAction => 'Бросить';

  @override
  String get diceLabelHint => 'Подпись (необязательно)';

  @override
  String get diceAdvantage => 'Преимущество';

  @override
  String get diceDisadvantage => 'Помеха';

  @override
  String get diceModifier => 'Модификатор';

  @override
  String get diceDecrease => 'Уменьшить';

  @override
  String get diceIncrease => 'Увеличить';

  @override
  String get diceQuickHint =>
      'Нажмите на кубик, чтобы бросить его, или удерживайте, чтобы добавить в формулу.';

  @override
  String get dicePresets => 'Системы';

  @override
  String get diceHistory => 'История бросков';

  @override
  String get diceHistoryEmpty =>
      'Бросков пока нет. Здесь сохраняется каждый бросок.';

  @override
  String get diceClearHistory => 'Очистить историю';

  @override
  String get diceClearHistoryTitle => 'Очистить историю бросков?';

  @override
  String get diceClearHistoryBody =>
      'Все сохранённые броски этого мира будут удалены.';

  @override
  String get diceReroll => 'Бросить снова';

  @override
  String get diceCopy => 'Копировать';

  @override
  String get diceCopied => 'Скопировано в буфер обмена';

  @override
  String get diceResultEmpty => 'Выберите кубик или введите формулу';

  @override
  String get diceDropped => 'Отброшен';

  @override
  String get diceExploded => 'Взорвался';

  @override
  String get diceRerolled => 'Переброшен';

  @override
  String diceMoreDice(int count) {
    return 'ещё $count';
  }

  @override
  String get diceErrorEmpty => 'Введите формулу броска';

  @override
  String get diceErrorTooLong => 'Формула слишком длинная';

  @override
  String get diceErrorUnexpectedChar => 'Неожиданный символ';

  @override
  String get diceErrorUnexpectedEnd => 'Формула обрывается';

  @override
  String get diceErrorExpectedNumber => 'Здесь нужно число';

  @override
  String get diceErrorParen => 'Непарные скобки';

  @override
  String get diceErrorTooManyDice => 'Не больше 1000 кубиков в группе';

  @override
  String get diceErrorBadSides => 'У кубика должно быть от 1 до 10000 граней';

  @override
  String get diceErrorTooLarge => 'Слишком большое число';

  @override
  String get diceErrorDivisionByZero => 'Деление на ноль';

  @override
  String get diceErrorDuplicate => 'Модификатор повторяется';

  @override
  String get diceErrorImpossibleReroll =>
      'Такой переброс никогда не закончится';

  @override
  String get diceErrorLabel => 'Закройте подпись скобкой ]';

  @override
  String diceErrorAt(String message, int position) {
    return '$message (позиция $position)';
  }

  @override
  String get dicePresetD20 => 'Проверка d20';

  @override
  String get dicePresetAbility => 'Характеристика';

  @override
  String get dicePresetCoc => 'Зов Ктулху';

  @override
  String get dicePresetPbta => 'Ход PbtA';

  @override
  String get dicePresetBlades => 'Клинки во тьме';

  @override
  String get dicePresetFate => 'Fate';

  @override
  String get dicePresetYearZero => 'Year Zero';

  @override
  String get dicePresetSavage => 'Savage Worlds';

  @override
  String get dicePresetCyberpunk => 'Cyberpunk RED';

  @override
  String get diceModeNormal => 'Обычный';

  @override
  String get diceDc => 'СЛ (необязательно)';

  @override
  String get diceSkill => 'Навык';

  @override
  String get diceBonusDice => 'Бонусные (+) / штрафные (−) кубики';

  @override
  String get diceStat => 'Характеристика';

  @override
  String get diceDicePool => 'Пул кубиков';

  @override
  String get diceTraitDie => 'Кубик черты';

  @override
  String get diceWildDie => 'Дикий кубик';

  @override
  String get diceStatSkill => 'Характеристика + навык';

  @override
  String get diceOutcomeCriticalSuccess => 'Критический успех';

  @override
  String get diceOutcomeCriticalFailure => 'Критический провал';

  @override
  String get diceOutcomeSuccess => 'Успех';

  @override
  String get diceOutcomeFailure => 'Провал';

  @override
  String get diceOutcomeRaise => 'Успех с подъёмом';

  @override
  String get diceOutcomeExtreme => 'Экстремальный успех';

  @override
  String get diceOutcomeHard => 'Трудный успех';

  @override
  String get diceOutcomeRegular => 'Обычный успех';

  @override
  String get diceOutcomeFumble => 'Катастрофа';

  @override
  String get diceOutcomeMiss => 'Провал';

  @override
  String get diceOutcomePartial => 'Частичный успех';

  @override
  String get diceOutcomeFull => 'Полный успех';

  @override
  String get diceFateTerrible => 'Ужасно';

  @override
  String get diceFatePoor => 'Плохо';

  @override
  String get diceFateMediocre => 'Посредственно';

  @override
  String get diceFateAverage => 'Средне';

  @override
  String get diceFateFair => 'Неплохо';

  @override
  String get diceFateGood => 'Хорошо';

  @override
  String get diceFateGreat => 'Отлично';

  @override
  String get diceFateSuperb => 'Превосходно';

  @override
  String get diceFateFantastic => 'Фантастически';

  @override
  String get diceFateEpic => 'Эпически';

  @override
  String get diceFateLegendary => 'Легендарно';

  @override
  String diceSuccesses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count успеха',
      many: '$count успехов',
      few: '$count успеха',
      one: '$count успех',
      zero: 'Нет успехов',
    );
    return '$_temp0';
  }

  @override
  String diceRollTooltip(String expression) {
    return 'Бросить $expression';
  }

  @override
  String diceRolledSnack(String expression, int total) {
    return '$expression: $total';
  }

  @override
  String get diceQuickRollTitle => 'Быстрый бросок';

  @override
  String get combatNewEncounter => 'Новая стычка';

  @override
  String combatEncounterDefaultName(int number) {
    return 'Стычка $number';
  }

  @override
  String get combatEncounterNameLabel => 'Название стычки';

  @override
  String get combatEmptyTitle => 'Стычек пока нет';

  @override
  String get combatEmptyHint =>
      'Спланируйте бой: добавьте чудовищ и героев, оцените сложность и ведите бой по раундам.';

  @override
  String get combatRenameTitle => 'Переименовать стычку';

  @override
  String get combatDuplicate => 'Дублировать';

  @override
  String combatCopyName(String name) {
    return '$name (копия)';
  }

  @override
  String combatDeleteTitle(String name) {
    return 'Удалить «$name»?';
  }

  @override
  String get combatDeleteBody =>
      'Стычка и все её участники будут удалены безвозвратно.';

  @override
  String get combatStatusPlanning => 'Подготовка';

  @override
  String get combatStatusActive => 'Идёт бой';

  @override
  String get combatStatusFinished => 'Завершён';

  @override
  String combatRound(int round) {
    return 'Раунд $round';
  }

  @override
  String combatCombatantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участника',
      many: '$count участников',
      few: '$count участника',
      one: '$count участник',
      zero: 'Нет участников',
    );
    return '$_temp0';
  }

  @override
  String get combatNotFound => 'Этой стычки больше нет.';

  @override
  String get combatAllEncounters => 'Все стычки';

  @override
  String get combatStart => 'Начать бой';

  @override
  String get combatEnd => 'Завершить бой';

  @override
  String get combatNextTurn => 'Следующий ход';

  @override
  String get combatPreviousTurn => 'Предыдущий ход';

  @override
  String get combatRollInitiative => 'Бросить инициативу';

  @override
  String get combatRollInitiativeHint =>
      'Бросает d20 + бонус за каждое чудовище; игроки сохраняют свои значения.';

  @override
  String combatTurnOf(String name) {
    return 'Ход: $name';
  }

  @override
  String get combatNotStarted => 'Бой ещё не начался';

  @override
  String get combatAddFromWorld => 'Добавить из мира';

  @override
  String get combatAddManually => 'Добавить вручную';

  @override
  String get combatPickTitle => 'Добавить существо или персонажа';

  @override
  String combatQuantityTitle(String name) {
    return 'Сколько «$name»?';
  }

  @override
  String get combatNoCombatants => 'Участников пока нет';

  @override
  String get combatNoCombatantsHint =>
      'Добавьте существ и персонажей из своего мира или введите их вручную.';

  @override
  String get combatInitiative => 'Инициатива';

  @override
  String get combatInitiativeBonus => 'Бонус инициативы';

  @override
  String get combatArmorClass => 'Класс доспеха';

  @override
  String get combatAcShort => 'КД';

  @override
  String get combatHpMax => 'Макс. хиты';

  @override
  String get combatHpCurrent => 'Текущие хиты';

  @override
  String get combatHpTemp => 'Врем. хиты';

  @override
  String get combatAmountHint => 'Хиты';

  @override
  String get combatDamage => 'Урон';

  @override
  String get combatHeal => 'Лечение';

  @override
  String get combatTemp => 'Врем.';

  @override
  String get combatAddCondition => 'Состояние';

  @override
  String combatConditionDurationTitle(String condition) {
    return 'Длительность: $condition';
  }

  @override
  String get combatConditionRounds => 'Раунды (пусто = до снятия)';

  @override
  String get combatRemoveCondition => 'Снять состояние';

  @override
  String get combatConcentration => 'Концентрация';

  @override
  String get combatDefeated => 'Повержен';

  @override
  String get combatPlayer => 'Персонаж игрока';

  @override
  String get combatEdit => 'Изменить';

  @override
  String get combatRemove => 'Убрать';

  @override
  String get combatEditCombatant => 'Изменить участника';

  @override
  String get combatAddCombatant => 'Добавить участника';

  @override
  String get combatChallenge => 'Уровень опасности';

  @override
  String get combatXp => 'Опыт';

  @override
  String get combatQuantity => 'Количество';

  @override
  String get combatNotes => 'Заметки';

  @override
  String get combatNotesHint => 'Тактика, местность, добыча…';

  @override
  String get combatDifficulty => 'Сложность';

  @override
  String get combatRules => 'Правила';

  @override
  String get combatPartyLevels => 'Уровни отряда';

  @override
  String get combatAddLevel => 'Уровень';

  @override
  String combatLevelChip(int level) {
    return 'Ур. $level';
  }

  @override
  String get combatLevelLabel => 'Уровень персонажа (1–20)';

  @override
  String combatMonsterXp(String xp) {
    return 'Опыт чудовищ: $xp';
  }

  @override
  String combatAdjustedXp(String xp, String multiplier) {
    return 'С поправкой: $xp (×$multiplier)';
  }

  @override
  String get combatNoParty => 'Добавьте уровни отряда, чтобы оценить стычку.';

  @override
  String get combatRatingTrivial => 'Пустяк';

  @override
  String get combatRatingLow => 'Низкая';

  @override
  String get combatRatingModerate => 'Средняя';

  @override
  String get combatRatingHigh => 'Высокая';

  @override
  String get combatRatingBeyondHigh => 'Запредельная';

  @override
  String get combatRatingEasy => 'Лёгкая';

  @override
  String get combatRatingMedium => 'Средняя';

  @override
  String get combatRatingHard => 'Трудная';

  @override
  String get combatRatingDeadly => 'Смертельная';

  @override
  String combatConcentrationCheck(String name, int dc) {
    return '$name: спасбросок концентрации, СЛ $dc';
  }

  @override
  String combatDefeatedNotice(String name) {
    return '$name повержен';
  }

  @override
  String get combatOpenEntry => 'Открыть запись';

  @override
  String get combatActions => 'Действия участника';

  @override
  String get combatEncounterActions => 'Действия со стычкой';

  @override
  String get roleCustomLabel => 'Или введите свою роль';

  @override
  String importFilesFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не удалось импортировать $count файлов',
      few: 'Не удалось импортировать $count файла',
      one: 'Не удалось импортировать $count файл',
    );
    return '$_temp0';
  }

  @override
  String get trashTitle => 'Корзина';

  @override
  String get trashEmptyState =>
      'Корзина пуста. Удалённые записи хранятся здесь, пока вы их не восстановите или не удалите навсегда.';

  @override
  String get trashEmptyAction => 'Очистить корзину';

  @override
  String get trashEmptyConfirmTitle => 'Очистить корзину?';

  @override
  String trashEmptyConfirmBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count записей будут удалены навсегда вместе с текстом, изображениями и связями.',
      few:
          '$count записи будут удалены навсегда вместе с текстом, изображениями и связями.',
      one:
          '$count запись будет удалена навсегда вместе с текстом, изображениями и связями.',
    );
    return '$_temp0';
  }

  @override
  String get trashDeleteForever => 'Удалить навсегда';

  @override
  String trashDeleteForeverTitle(String name) {
    return 'Удалить «$name» навсегда?';
  }

  @override
  String get trashDeleteForeverBody =>
      'Текст, изображения и связи тоже будут удалены. Это нельзя отменить.';

  @override
  String trashDeletedOn(String date) {
    return 'Удалено $date';
  }

  @override
  String trashMovedSnack(String name) {
    return '«$name» перемещено в корзину';
  }

  @override
  String trashRestoredSnack(String name) {
    return '«$name» восстановлено';
  }

  @override
  String get undo => 'Отменить';

  @override
  String get tabDuplicate => 'Дублировать вкладку';

  @override
  String get tabClose => 'Закрыть вкладку';

  @override
  String get tabCloseOthers => 'Закрыть другие вкладки';

  @override
  String get tabCloseRight => 'Закрыть вкладки справа';

  @override
  String get exportMarkdownTitle => 'Заметки Markdown (Obsidian)';

  @override
  String get exportMarkdownSubtitle =>
      'Архив папки со связанными заметками и изображениями — откройте как хранилище Obsidian или в любом редакторе.';

  @override
  String get shareMarkdownText => 'Заметки мира GMH (Markdown)';

  @override
  String get relationsTitle => 'Связи';

  @override
  String kindFieldsTitle(String kind) {
    return 'Свои поля: $kind';
  }

  @override
  String get kindFieldsHint =>
      'Добавленные здесь поля появятся у каждой записи этого типа в этом мире — после встроенных.';

  @override
  String get kindFieldsAction => 'Настроить поля';

  @override
  String get tablesSearchHint => 'Поиск таблиц';

  @override
  String get tablesNewTable => 'Новая таблица';

  @override
  String get tablesImport => 'Импорт из текста';

  @override
  String get tablesLibrary => 'Библиотека';

  @override
  String get tablesOpenLibrary => 'Открыть библиотеку';

  @override
  String get tablesEmptyTitle => 'Пока нет случайных таблиц';

  @override
  String get tablesEmptyHint =>
      'Начните с готовой таблицы из библиотеки, составьте свою или вставьте список из книги.';

  @override
  String get tablesNoMatches => 'Ничего не найдено.';

  @override
  String get tablesNoFolder => 'Прочие таблицы';

  @override
  String tablesRowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count строки',
      many: '$count строк',
      few: '$count строки',
      one: '1 строка',
    );
    return '$_temp0';
  }

  @override
  String get tablesWeighted => 'По весу';

  @override
  String tablesDefaultName(int number) {
    return 'Таблица $number';
  }

  @override
  String get tablesDescriptionLabel => 'Описание';

  @override
  String get tablesFolderLabel => 'Папка';

  @override
  String get tablesFolderHint => 'например, Встречи';

  @override
  String get tablesFormulaLabel => 'Формула броска';

  @override
  String get tablesFormulaHint => 'например, 1d20; пусто — по весу';

  @override
  String get tablesFormulaInvalid => 'Некорректная формула';

  @override
  String get tablesEditTitle => 'Изменить таблицу';

  @override
  String get tablesEdit => 'Изменить описание';

  @override
  String get tablesDuplicate => 'Дублировать';

  @override
  String tablesCopyName(String name) {
    return '$name (копия)';
  }

  @override
  String tablesDeleteTitle(String name) {
    return 'Удалить «$name»?';
  }

  @override
  String get tablesDeleteBody =>
      'Таблица и все её строки будут удалены из этого мира.';

  @override
  String get tablesActions => 'Действия с таблицей';

  @override
  String get tablesAllTables => 'Все таблицы';

  @override
  String get tablesMissing => 'Этой таблицы больше нет.';

  @override
  String get tablesRoll => 'Бросить';

  @override
  String get tablesRollAgain => 'Ещё раз';

  @override
  String get tablesCopy => 'Копировать';

  @override
  String get tablesCopied => 'Скопировано';

  @override
  String get tablesResultEmpty => 'Бросьте, чтобы получить результат.';

  @override
  String get tablesClamped => 'Вне всех диапазонов — взята ближайшая строка';

  @override
  String get tablesRollLog => 'Журнал бросков';

  @override
  String get tablesRollLogEmpty => 'Здесь появятся броски на этой странице.';

  @override
  String get tablesClearLog => 'Очистить журнал';

  @override
  String get tablesRows => 'Строки';

  @override
  String get tablesAddRow => 'Добавить строку';

  @override
  String get tablesDeleteRow => 'Удалить строку';

  @override
  String get tablesAutoRanges => 'Авто-диапазоны';

  @override
  String get tablesAutoRangesHint =>
      'Распределить строки по формуле согласно весам';

  @override
  String get tablesBulkEdit => 'Правка текстом';

  @override
  String get tablesBulkEditTitle => 'Строки в виде текста';

  @override
  String get tablesTextFormatHelp =>
      'По одной записи на строку: «1-3 | текст», «4: текст», «x3 текст» для веса или просто текст. Строки с # пропускаются.';

  @override
  String get tablesImportTitle => 'Импорт таблицы из текста';

  @override
  String get tablesImportRows => 'Строки';

  @override
  String tablesImportFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Найдено $count строки',
      many: 'Найдено $count строк',
      few: 'Найдено $count строки',
      one: 'Найдена 1 строка',
      zero: 'Строк не найдено',
    );
    return '$_temp0';
  }

  @override
  String get tablesImportAction => 'Импортировать';

  @override
  String get tablesApply => 'Применить';

  @override
  String get tablesRowsEmpty =>
      'Строк пока нет. Добавьте строку или вставьте целый список через «Правка текстом».';

  @override
  String tablesRowTextHint(String dice, String choice, String table) {
    return 'Текст, кубы $dice, выбор $choice, броски $table';
  }

  @override
  String get tablesFrom => 'От';

  @override
  String get tablesTo => 'До';

  @override
  String get tablesWeight => 'Вес';

  @override
  String get tablesDragToReorder => 'Перетащите, чтобы изменить порядок';

  @override
  String get tablesIssueBadFormula => 'Формулу невозможно бросить.';

  @override
  String get tablesIssueEmpty => 'В таблице нет строк с текстом.';

  @override
  String tablesIssueEmptyRow(int row) {
    return 'В строке $row нет текста.';
  }

  @override
  String tablesIssueMissingRange(int row) {
    return 'У строки $row нет диапазона.';
  }

  @override
  String tablesIssueInverted(int row) {
    return 'Строка $row: диапазон задан наоборот.';
  }

  @override
  String tablesIssueOutOfBounds(int row, String range) {
    return 'Строка $row выходит за пределы формулы ($range).';
  }

  @override
  String tablesIssueGap(String range) {
    return 'Значения $range ничем не покрыты.';
  }

  @override
  String tablesIssueOverlap(int first, int second, String range) {
    return 'Строки $first и $second пересекаются на $range.';
  }

  @override
  String get tablesFailNotFound => 'Нет таблицы с таким именем';

  @override
  String get tablesFailCycle => 'Ссылается сама на себя — остановлено';

  @override
  String get tablesFailDepth => 'Слишком глубокая вложенность — остановлено';

  @override
  String get tablesFailTooMany =>
      'Слишком много вложенных бросков — остановлено';

  @override
  String get tablesFailEmpty => 'В таблице нет строк';

  @override
  String get tablesFailBadFormula => 'Формулу невозможно бросить';

  @override
  String tablesChoice(int count) {
    return 'одно из $count';
  }

  @override
  String get tablesFromLibrary => 'Из библиотеки';

  @override
  String get tablesLibraryTitle => 'Библиотека таблиц';

  @override
  String get tablesLibraryHint =>
      'Готовые таблицы для любого сеттинга. Посмотрите их и добавьте в мир, чтобы редактировать.';

  @override
  String get tablesYourSetting => 'Сеттинг этого мира';

  @override
  String get tablesOtherSettings => 'Другие сеттинги';

  @override
  String tablesTableCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count таблицы',
      many: '$count таблиц',
      few: '$count таблицы',
      one: '1 таблица',
    );
    return '$_temp0';
  }

  @override
  String get tablesPreview => 'Просмотр';

  @override
  String get tablesAddToWorld => 'Добавить в мир';

  @override
  String get tablesInWorld => 'Уже в мире';

  @override
  String get tablesAddDepsTitle => 'Добавить и связанные таблицы?';

  @override
  String tablesAddDepsBody(String name) {
    return '«$name» бросает по этим таблицам. Без них в результатах появятся предупреждения.';
  }

  @override
  String tablesAddedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Добавлено $count таблицы',
      many: 'Добавлено $count таблиц',
      few: 'Добавлено $count таблицы',
      one: 'Добавлена 1 таблица',
    );
    return '$_temp0';
  }

  @override
  String get tablesPreviewRoll => 'Пробный бросок';

  @override
  String get tablesWhy => 'Как получен результат';

  @override
  String get paletteHint =>
      'Перейти к записи, разделу или инструменту, или выполнить команду…';

  @override
  String get paletteCommands => 'Команды';

  @override
  String get paletteEntries => 'Записи';

  @override
  String get paletteNoMatches => 'Ничего не найдено';

  @override
  String get paletteToggleTheme => 'Переключить светлую / тёмную тему';

  @override
  String paletteOpenInTab(String name) {
    return 'Перейти: $name';
  }

  @override
  String get paletteTitle => 'Палитра команд';

  @override
  String get homeAtTheTable => 'За столом';

  @override
  String get homeYourSections => 'Ваши разделы';

  @override
  String get menuDuplicateEntry => 'Дублировать';

  @override
  String entryCopyName(String name) {
    return '$name (копия)';
  }

  @override
  String get helpPacksTitle => 'Сеттинги и стили';

  @override
  String get helpPacksBody =>
      'У каждого мира есть сеттинг: фэнтези, киберпанк, космоопера, готический или космический хоррор, постапокалипсис, стимпанк, городское фэнтези, дикий запад или уся. Сеттинг перекрашивает всё приложение (в светлой и тёмной теме), переименовывает разделы на своём языке — «Раннеры» и «Секторы» в киберпанке, «Экипаж» и «Точки маршрута» в космоопере — и подбирает случайные таблицы и генераторы под жанр. Его можно сменить в любой момент в «Настройки → Мир»: данные не меняются, меняется только их подача.';

  @override
  String get helpToolsTitle => 'За столом: инструменты ведущего';

  @override
  String get helpToolsBody =>
      'Инструменты — в боковой панели, на главной и в палитре команд. «Броски кубов»: любая нотация (4d6kh3, 2d20kl1+5, 8d6!, 5d10>=8) или пресеты систем — проверки D&D, «Зов Ктулху», PbtA, Blades in the Dark, Fate, Year Zero, Savage Worlds, Cyberpunk RED; все броски сохраняются в журнал, а кубы в блоках характеристик кликабельны. «Трекер боя»: собирайте столкновения из существ и персонажей (хиты, КД и ПО берутся из их полей), бросайте инициативу, наносите урон и лечите, отслеживайте состояния с длительностью и сложность столкновения. «Случайные таблицы»: свои таблицы с диапазонами или весами, вложенные таблицы через [[Название]], либо готовые таблицы вашего сеттинга из библиотеки. «Генераторы»: мгновенные NPC, имена, поселения, таверны, завязки, фракции, добыча и слухи для вашего сеттинга — оставляйте удачные и сохраняйте в мир одним нажатием. «Карты»: загрузите изображение карты, ставьте метки, связанные с записями, измеряйте расстояния по масштабу и включайте вид для игроков, чтобы скрыть метки ведущего. «Хронология»: эпохи и события по порядку — по их датам в мире, с вашим собственным календарём. «Ширма ведущего»: текущий бой, закреплённые записи, заметки сессии, быстрые кубы и таблицы и справка по правилам на одной странице.';

  @override
  String get helpNavTitle => 'Быстрая навигация';

  @override
  String get helpNavBody =>
      'Ctrl+P открывает палитру команд: введите часть названия, чтобы перейти к записи, разделу или инструменту, или выполните команду (новая запись, светлая/тёмная тема, смена мира). Ctrl+K — переход к поиску. Страницы открываются во вкладках, как в браузере: Ctrl+T — новая вкладка, Ctrl+W — закрыть, Ctrl+Tab — переключение; правый клик по вкладке — дублировать или закрыть остальные, клик колёсиком — закрыть. Alt+← / Alt+→ и боковые кнопки мыши листают историю каждой вкладки. Escape открывает меню паузы (сохранение, настройки, выход).';

  @override
  String get helpFieldsTitle => 'Свои поля';

  @override
  String get helpFieldsBody =>
      'Встроенным разделам можно добавить свои поля под вашу игру: откройте раздел (Персонажи, Локации…) и нажмите «Настроить поля» на панели. Добавляйте текст, числа, даты, списки, чек-листы или варианты выбора — они появятся у каждой записи раздела в этом мире после встроенных полей и попадут в поиск, PDF-книгу и экспорт в Markdown. Свои разделы задают все поля в конструкторе раздела.';

  @override
  String get helpTrashTitle => 'Корзина, копии и экспорт';

  @override
  String get helpTrashBody =>
      'Удалённая запись попадает в корзину (боковая панель или «Настройки → Мир»), а сразу после удаления можно нажать «Отменить». Позже запись можно восстановить или удалить навсегда. В меню записи есть «Дублировать» — копия с полями, тегами, изображениями и текстом. «Настройки → Экспорт» создаёт полный архив (.gmhw — для резервных копий и переноса между устройствами), JSON, печатную PDF-книгу мира или заметки Markdown, которые открываются как хранилище Obsidian с рабочими [[ссылками]]; поля «только для ведущего» не попадают туда, если вы их не включите.';

  @override
  String get newSessionAction => 'Новая сессия';

  @override
  String sessionNumberName(int number) {
    return 'Сессия $number';
  }

  @override
  String get timelineEmptyTitle => 'Истории пока нет';

  @override
  String get timelineEmptyHint =>
      'Здесь по порядку появятся эпохи и события с датой мира. Добавьте событие или укажите дату у существующих.';

  @override
  String get timelineNewEvent => 'Новое событие';

  @override
  String get timelineEventName => 'Название события';

  @override
  String get timelineDateLabel => 'Дата в мире';

  @override
  String get timelineDateHint =>
      'например: 1492, 12 марта 1492, год 412, 300 до н. э.';

  @override
  String get timelineDateUnreadable =>
      'В дате не найден год — событие попадёт в «Без даты».';

  @override
  String get timelineUndated => 'Без даты';

  @override
  String get timelineUndatedHint =>
      'Укажите дату, чтобы поместить их на шкалу.';

  @override
  String get timelineSetDate => 'Указать дату';

  @override
  String get timelineOutsideEras => 'Вне эпох';

  @override
  String timelineEraSpan(String start, String end) {
    return '$start – $end';
  }

  @override
  String get timelineOngoing => 'по сей день';

  @override
  String get timelineCalendar => 'Календарь';

  @override
  String get timelineCalendarHint =>
      'По месяцу на строку, можно с длиной: «Морозник: 30». Оставьте пустым для обычного календаря.';

  @override
  String get timelineMonths => 'Месяцы';

  @override
  String get timelineYearSuffix => 'Суффикс года (например, DR)';

  @override
  String timelineEventsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count событий',
      few: '$count события',
      one: '$count событие',
      zero: 'Нет событий',
    );
    return '$_temp0';
  }

  @override
  String get gmScreenPinned => 'Закреплённые записи';

  @override
  String get gmScreenPinHint =>
      'Держите NPC, места и предметы сегодняшней сессии под рукой.';

  @override
  String get gmScreenAddPin => 'Закрепить запись';

  @override
  String get gmScreenUnpin => 'Открепить';

  @override
  String get gmScreenNotes => 'Заметки сессии';

  @override
  String get gmScreenNotesHint =>
      'Придуманные на ходу имена, незакрытые нити, кто кому должен…';

  @override
  String get gmScreenDice => 'Быстрые кубы';

  @override
  String get gmScreenRoll => 'Бросить';

  @override
  String get gmScreenTables => 'Быстрые таблицы';

  @override
  String get gmScreenAddTable => 'Закрепить таблицу';

  @override
  String get gmScreenNoTables =>
      'В этом мире пока нет случайных таблиц — создайте их или добавьте из библиотеки в «Случайных таблицах».';

  @override
  String get gmScreenEncounter => 'Текущий бой';

  @override
  String get gmScreenNoFight => 'Сейчас боя нет.';

  @override
  String get gmScreenOpenTracker => 'Открыть трекер';

  @override
  String gmScreenRound(int round) {
    return 'Раунд $round';
  }

  @override
  String get gmScreenConditions => 'Состояния';

  @override
  String get gmScreenRules => 'Сложность и укрытия';

  @override
  String get gmScreenDifficulty => 'Класс сложности';

  @override
  String get gmScreenCover => 'Укрытие';

  @override
  String get gmScreenPanels => 'Панели';

  @override
  String get gmScreenAttribution =>
      'Краткие правила на основе SRD 5.2.1 (CC BY 4.0)';

  @override
  String get mapsEmptyTitle => 'Карт пока нет';

  @override
  String get mapsEmptyHint =>
      'Загрузите изображение карты или начните с чистого листа, затем расставьте метки, связанные с записями.';

  @override
  String get mapsNewFromImage => 'Карта из изображения';

  @override
  String get mapsNewBlank => 'Пустая карта';

  @override
  String mapsDefaultName(int number) {
    return 'Карта $number';
  }

  @override
  String mapsPinCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count метки',
      many: '$count меток',
      few: '$count метки',
      one: '$count метка',
      zero: 'Нет меток',
    );
    return '$_temp0';
  }

  @override
  String get mapsRenameTitle => 'Переименовать карту';

  @override
  String get mapsDuplicate => 'Дублировать';

  @override
  String mapsCopyName(String name) {
    return '$name (копия)';
  }

  @override
  String mapsDeleteTitle(String name) {
    return 'Удалить «$name»?';
  }

  @override
  String get mapsDeleteBody =>
      'Карта и все её метки будут удалены. Связанные записи не пострадают.';

  @override
  String get mapsActions => 'Действия с картой';

  @override
  String get mapsAllMaps => 'Все карты';

  @override
  String get mapsMissing => 'Этой карты больше нет.';

  @override
  String get mapsImportFailed => 'Не удалось открыть файл как изображение.';

  @override
  String get mapsChangeImage => 'Сменить изображение';

  @override
  String get mapsImageMissing => 'Изображение карты пропало';

  @override
  String get mapsImageMissingHint =>
      'Метки по-прежнему работают. Выберите новое изображение, чтобы вернуть фон.';

  @override
  String get mapsModeSelect => 'Выбор';

  @override
  String get mapsModeAdd => 'Добавить метку';

  @override
  String get mapsModeMeasure => 'Измерить';

  @override
  String get mapsAddHint => 'Нажмите на карту, чтобы поставить метку.';

  @override
  String get mapsMeasureHint => 'Нажмите на две точки, чтобы измерить.';

  @override
  String get mapsMeasureNoScale => 'Масштаб не задан: расстояние в пикселях.';

  @override
  String mapsDistance(String distance) {
    return 'Расстояние: $distance';
  }

  @override
  String mapsPixels(String value) {
    return '$value пкс';
  }

  @override
  String get mapsMeasureRule => 'Правило диагоналей';

  @override
  String get mapsRuleStraight => 'По прямой';

  @override
  String get mapsRuleGrid => 'Сетка: диагональ = 1 клетка';

  @override
  String get mapsRuleAlternating => 'Сетка: диагонали 1-2-1';

  @override
  String get mapsFit => 'Вписать в экран';

  @override
  String get mapsZoomIn => 'Приблизить';

  @override
  String get mapsZoomOut => 'Отдалить';

  @override
  String get mapsPlayerView => 'Вид для игроков';

  @override
  String get mapsExitPlayerView => 'Выйти из вида для игроков';

  @override
  String get mapsPanel => 'Метки и сведения';

  @override
  String get mapsPinsTab => 'Метки';

  @override
  String get mapsDetailsTab => 'Сведения';

  @override
  String get mapsSearchPins => 'Поиск меток';

  @override
  String get mapsNoPins =>
      'Меток пока нет. Выберите «Добавить метку» и нажмите на карту.';

  @override
  String get mapsNoPinMatches => 'Метки не найдены.';

  @override
  String get mapsNewPin => 'Новая метка';

  @override
  String get mapsEditPin => 'Изменить метку';

  @override
  String get mapsPinLabel => 'Подпись';

  @override
  String get mapsPinIcon => 'Значок';

  @override
  String get mapsPinColor => 'Цвет';

  @override
  String get mapsPinNotes => 'Заметки';

  @override
  String get mapsPinGmOnly => 'Только для мастера';

  @override
  String get mapsPinGmOnlyHint => 'Скрыта в виде для игроков';

  @override
  String get mapsLinkedEntry => 'Связанная запись';

  @override
  String get mapsLinkEntry => 'Связать с записью';

  @override
  String get mapsChangeEntry => 'Сменить';

  @override
  String get mapsUnlink => 'Отвязать';

  @override
  String get mapsOpenEntry => 'Открыть запись';

  @override
  String get mapsEntryMissing => 'Связанная запись удалена';

  @override
  String get mapsDeletePin => 'Удалить метку';

  @override
  String get mapsPinDeleted => 'Метка удалена';

  @override
  String get mapsUntitledPin => 'Метка без названия';

  @override
  String get mapsDescription => 'Описание';

  @override
  String get mapsNoDescription => 'Описания нет.';

  @override
  String get mapsScale => 'Масштаб';

  @override
  String get mapsNoScale => 'Масштаб не задан';

  @override
  String mapsScaleValue(String units, String unit, String px) {
    return '1 клетка = $units $unit ($px пкс)';
  }

  @override
  String get mapsScaleHelp =>
      'Одна клетка сетки на изображении соответствует этому расстоянию. Оставьте поля пустыми, если масштаб не нужен.';

  @override
  String get mapsScaleInvalid =>
      'Укажите положительные числа для расстояния и размера клетки.';

  @override
  String get mapsUnitsPerCell => 'Расстояние на клетку';

  @override
  String get mapsUnitName => 'Единица';

  @override
  String get mapsUnitHint => 'мили, км, фт…';

  @override
  String get mapsCellPx => 'Клетка (пкс)';

  @override
  String get mapsShowGrid => 'Показывать сетку';

  @override
  String get mapsGridNeedsScale => 'Задайте масштаб, чтобы показать сетку.';

  @override
  String get mapsPinsVisibleDefault => 'Новые метки видны игрокам';

  @override
  String get mapsEditDetails => 'Изменить сведения';

  @override
  String get mapsDetailsTitle => 'Сведения о карте';

  @override
  String mapsImageSize(int width, int height) {
    return '$width × $height пкс';
  }

  @override
  String get mapsBlankCanvas => 'Чистый лист';

  @override
  String get mapsOnMaps => 'На картах';

  @override
  String get mapsIconPin => 'Метка';

  @override
  String get mapsIconCastle => 'Замок';

  @override
  String get mapsIconTown => 'Город';

  @override
  String get mapsIconDungeon => 'Подземелье';

  @override
  String get mapsIconCave => 'Пещера';

  @override
  String get mapsIconForest => 'Лес';

  @override
  String get mapsIconMountain => 'Гора';

  @override
  String get mapsIconPort => 'Порт';

  @override
  String get mapsIconDanger => 'Опасность';

  @override
  String get mapsIconTreasure => 'Сокровище';

  @override
  String get mapsIconQuest => 'Задание';

  @override
  String get mapsIconCamp => 'Лагерь';

  @override
  String get mapsIconNpc => 'Персонаж';

  @override
  String get mapsIconPortal => 'Портал';

  @override
  String get mapsIconNote => 'Заметка';

  @override
  String get mapsColorAuto => 'Автоматически (цвет записи)';

  @override
  String get mapsColorAccent => 'Акцент';

  @override
  String get mapsColorRed => 'Красный';

  @override
  String get mapsColorOrange => 'Оранжевый';

  @override
  String get mapsColorYellow => 'Жёлтый';

  @override
  String get mapsColorGreen => 'Зелёный';

  @override
  String get mapsColorTeal => 'Бирюзовый';

  @override
  String get mapsColorBlue => 'Синий';

  @override
  String get mapsColorPurple => 'Фиолетовый';

  @override
  String get mapsColorPink => 'Розовый';

  @override
  String get mapsColorGray => 'Серый';

  @override
  String get generatorsKindNames => 'Имена';

  @override
  String get generatorsKindNpc => 'НПС';

  @override
  String get generatorsKindSettlement => 'Поселение';

  @override
  String get generatorsKindEstablishment => 'Таверна и лавка';

  @override
  String get generatorsKindHook => 'Завязка приключения';

  @override
  String get generatorsKindLoot => 'Добыча';

  @override
  String get generatorsKindFaction => 'Фракция';

  @override
  String get generatorsKindWeather => 'Погода';

  @override
  String get generatorsKindRumor => 'Слух';

  @override
  String get generatorsPicker => 'Генератор';

  @override
  String get generatorsPack => 'Жанровый набор';

  @override
  String generatorsPackWorld(String pack) {
    return '$pack (этот мир)';
  }

  @override
  String get generatorsGender => 'Пол';

  @override
  String get generatorsGenderAny => 'Любой';

  @override
  String get generatorsGenderFeminine => 'Женские';

  @override
  String get generatorsGenderMasculine => 'Мужские';

  @override
  String get generatorsCulture => 'Традиция имён';

  @override
  String get generatorsCultureAny => 'Вперемешку';

  @override
  String get generatorsCount => 'Сколько';

  @override
  String get generatorsEpithets => 'С прозвищами';

  @override
  String get generatorsGenerate => 'Создать';

  @override
  String get generatorsRerollAll => 'Перебросить всё';

  @override
  String generatorsRerollField(String field) {
    return 'Перебросить: $field';
  }

  @override
  String get generatorsCopy => 'Копировать текстом';

  @override
  String get generatorsCopyAll => 'Копировать все';

  @override
  String get generatorsCopyName => 'Копировать имя';

  @override
  String get generatorsCopied => 'Скопировано в буфер обмена';

  @override
  String get generatorsKeep => 'Оставить';

  @override
  String get generatorsUnkeep => 'Не оставлять';

  @override
  String get generatorsDismiss => 'Убрать';

  @override
  String get generatorsSave => 'Сохранить в мир';

  @override
  String get generatorsSaveAsCharacter => 'Сохранить как персонажа';

  @override
  String generatorsSaved(String name) {
    return '«$name» сохранено в мир';
  }

  @override
  String get generatorsSavedBadge => 'Сохранено';

  @override
  String get generatorsKept => 'Оставленные';

  @override
  String get generatorsHistory => 'Недавние, без сохранения';

  @override
  String get generatorsHistoryEmpty =>
      'Сюда попадают результаты, заменённые без сохранения, — до конца сеанса.';

  @override
  String get generatorsRestore => 'Вернуть';

  @override
  String get generatorsEmptyTitle => 'Пока ничего не создано';

  @override
  String get generatorsEmptyHint =>
      'Выберите генератор и нажмите «Создать». Перебрасывайте любую строку, оставляйте удачное и сохраняйте в мир.';

  @override
  String get generatorsFieldName => 'Имя';

  @override
  String get generatorsFieldPlaceName => 'Название';

  @override
  String get generatorsFieldEpithet => 'Прозвище';

  @override
  String get generatorsFieldAncestry => 'Происхождение';

  @override
  String get generatorsFieldRole => 'Роль';

  @override
  String get generatorsFieldAge => 'Возраст';

  @override
  String get generatorsFieldAppearance => 'Внешность';

  @override
  String get generatorsFieldTrait => 'Черта';

  @override
  String get generatorsFieldMotivation => 'Мотивация';

  @override
  String get generatorsFieldSecret => 'Тайна';

  @override
  String get generatorsFieldVoice => 'Голос и манеры';

  @override
  String get generatorsFieldAttributes => 'Характеристики';

  @override
  String get generatorsFieldSize => 'Размер';

  @override
  String get generatorsFieldFeature => 'Особенность';

  @override
  String get generatorsFieldTrouble => 'Беда';

  @override
  String get generatorsFieldAuthority => 'Власть';

  @override
  String get generatorsFieldType => 'Тип';

  @override
  String get generatorsFieldOwner => 'Хозяин';

  @override
  String get generatorsFieldSpecialty => 'Фирменное';

  @override
  String get generatorsFieldPatron => 'Завсегдатай';

  @override
  String get generatorsFieldTitle => 'Название';

  @override
  String get generatorsFieldWho => 'Кто';

  @override
  String get generatorsFieldWants => 'Чего хочет';

  @override
  String get generatorsFieldObstacle => 'Препятствие';

  @override
  String get generatorsFieldTwist => 'Поворот';

  @override
  String get generatorsFieldContainer => 'Где найдено';

  @override
  String get generatorsFieldCoins => 'Монеты';

  @override
  String get generatorsFieldItem => 'Предмет';

  @override
  String get generatorsFieldCurio => 'Диковина';

  @override
  String get generatorsFieldGoal => 'Цель';

  @override
  String get generatorsFieldMethod => 'Методы';

  @override
  String get generatorsFieldSymbol => 'Символ';

  @override
  String get generatorsFieldSky => 'Небо';

  @override
  String get generatorsFieldAir => 'Воздух';

  @override
  String get generatorsFieldOmen => 'Знамение';

  @override
  String get generatorsFieldSource => 'Источник';

  @override
  String get generatorsFieldTruth => 'Правда ли';

  @override
  String get starterContentTitle => 'Начать с примеров';

  @override
  String get starterContentHint =>
      'Поселение и его жители, фракция, две завязки приключений в первой кампании и готовые случайные таблицы — всё под выбранный сеттинг. Любое можно изменить или удалить.';

  @override
  String get starterCampaignName => 'Первое приключение';
}
