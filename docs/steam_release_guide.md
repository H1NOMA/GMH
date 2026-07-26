# Гайд: публикация Game Master's Hub в Steam

Пошаговая инструкция от регистрации до релиза + готовые тексты для каждого
раздела страницы магазина на пяти языках (EN / RU / DE / FR / ZH — ровно те,
на которые локализовано приложение).

---

## Часть 1. Регистрация и деньги

### Шаг 1. Аккаунт Steamworks
1. Заведите (или используйте существующий) обычный аккаунт Steam с включённым
   Steam Guard. Аккаунт не должен быть limited (нужна хотя бы одна покупка на $5+).
2. Зайдите на <https://partner.steamgames.com/steamdirect> и начните
   регистрацию Steam Direct.
3. Заполните:
   - юридическое имя (для физлица — ваше полное имя, как в документах);
   - адрес и контактные данные;
   - **налоговое интервью** (W-8BEN для нерезидентов США — заполняется онлайн,
     занимает ~10 минут; для РФ ставка удержания с продаж в США определяется
     актуальным налоговым статусом — проверьте текущие условия в самом интервью);
   - **банковские реквизиты** для выплат. Выплаты Valve делает раз в месяц
     (30 дней после конца месяца) при сумме от $100. Если прямой перевод в ваш
     банк недоступен, потребуется счёт в банке страны, с которой Valve работает —
     уточните доступные варианты на этапе Banking (Payoneer и подобные сервисы
     Valve официально не поддерживает).
4. Оплатите **$100 Steam Direct Fee** (за каждый продукт). Возвращается после
   $1 000 скорректированной валовой выручки продукта.
5. Подождите верификацию — до ~30 дней (обычно быстрее). После неё в
   Steamworks появится кнопка создания приложения.

### Шаг 2. Создание приложения
1. App Admin → Create App. Тип: **Software** (не Game) — GMH попадёт в
   категории Software: Game Development / Utilities / Design & Illustration.
   Это ничего не меняет в процессе, но правильно позиционирует продукт.
2. Steam выдаст **App ID** и автоматически создаст первый **Depot ID**
   (обычно App ID + 1). Запишите оба.

### Шаг 3. Сроки, которые нельзя ускорить
- **30 дней** между оплатой fee и самым ранним возможным релизом.
- Страница **Coming Soon** должна быть публичной **минимум 2 недели** до релиза.
- Ревью Valve: страницы — 3–5 рабочих дней, билда — 1–5 дней.
  Закладывайте месяц-полтора от «оплатил fee» до «кнопка Release».

Итого бюджет запуска: **$100** (+ возможные банковские комиссии). Больше
обязательных платежей нет. Steam берёт **30%** с каждой продажи; НДС по
странам покупателей Valve удерживает и платит сама.

---

## Часть 2. Сборка и загрузка билда (SteamPipe)

Всё уже подготовлено в репозитории:

| Файл | Что делает |
|---|---|
| `steam/app_build.vdf` | описание билда (подставьте свой App ID) |
| `steam/depot_build_windows.vdf` | депо Windows x64 (подставьте Depot ID) |
| `steam/build_steam.ps1` | локально: сборка → staging → загрузка через steamcmd |
| `.github/workflows/steam-release.yml` | то же из GitHub Actions по кнопке |

### Вариант А: локально (первый раз делайте так)
1. Скачайте [Steamworks SDK](https://partner.steamgames.com/downloads/steamworks_sdk.zip),
   распакуйте. steamcmd лежит в `sdk\tools\ContentBuilder\builder\steamcmd.exe`.
2. В `steam/app_build.vdf` и `steam/depot_build_windows.vdf` замените
   `YOUR_APP_ID` / `YOUR_DEPOT_ID` на свои ids.
3. Из корня репозитория:
   ```powershell
   .\steam\build_steam.ps1 -SteamCmd "C:\sdk\tools\ContentBuilder\builder\steamcmd.exe" -Username ваш_логин
   ```
   Первый запуск спросит код Steam Guard; дальше логин кэшируется.
4. В Steamworks: App Admin → SteamPipe → Builds → новый билд → **Set live**
   на ветку `default` (или сначала на приватную `beta` для проверки).

### Вариант Б: GitHub Actions
1. Один раз выполните локальный логин steamcmd и заберите `config/config.vdf`
   из папки steamcmd; закодируйте в base64.
2. В настройках репозитория добавьте секреты `STEAM_USERNAME`,
   `STEAM_CONFIG_VDF` (тот base64), `STEAM_APP_ID`.
3. Actions → «Steam Release» → Run workflow. Билд соберётся, прогонит тесты
   и уедет в Steamworks (неопубликованным — set live руками).

### Настройки приложения в Steamworks (Installation)
- Launch Options → Executable: `gmh.exe` (имя из
  `build/windows/x64/runner/Release`), OS: Windows, Arch: 64-bit.
- Supported OS: Windows 10+ x64.
- Steam Cloud можно не включать (приложение local-first по замыслу; данные
  пользователь переносит архивом .gmhw). Если захотите — Auto-Cloud на папку
  `%APPDATA%/../Local/gmh` обсудим отдельно, там нужна осторожность с БД.

---

## Часть 3. Страница магазина: что потребуется загрузить

Графика (готовьте в этих размерах, без «плашек» с текстом на скриншотах):

| Ассет | Размер | Обязателен |
|---|---|---|
| Header capsule | 920×430 | да |
| Small capsule | 462×174 | да |
| Main capsule | 1232×706 | да |
| Vertical capsule | 748×896 | да |
| Library capsule | 600×900 | да |
| Library header | 920×430 | да |
| Library hero | 3840×1240 | да |
| Logo (прозрачный PNG) | ~1280×720 | да |
| Скриншоты | 1920×1080, **минимум 5** | да |
| Трейлер | 1920×1080, 30/60 fps | нет, но сильно поднимает конверсию |

Скриншоты **уже готовы**: в `steam/screenshots/` лежат восемь кадров
1920×1080 (дашборд, галерея персонажей с обложками, страница записи с
документом, профиль персонажа с характеристиками, доска квестов кампании,
граф связей, киберпанк-мир и светлая тема) — интерфейс английский, снято с
живого приложения. Пересоздать после редизайна:
`GMH_STORE_SHOTS=1 flutter test test/store_screenshots_test.dart`.
Загрузите минимум 5 из них; локализованные варианты для каждого языка
страницы опциональны.

Категории/жанры: Software → Game Development; теги: Utilities, Design &
Illustration, RPG, Tabletop, Dungeons & Dragons, Software. Возрастной
опросник — всё «нет», контента 18+ в приложении нет.

Цена: рекомендуемая база **$9.99 USD** (обоснование и региональная сетка —
в конце файла).

---

## Часть 4. Тексты страницы (готовые, на 5 языках)

Ограничения Steam: короткое описание ≤ 300 символов; полное описание —
без ограничения, поддерживает BBCode (`[h2]`, `[b]`, `[list]`).

### 4.1 Название (одно на все языки)
> **Game Master's Hub — Worldbuilding & Campaign Manager**

---

### 4.2 English

**Short description**
> The offline worldbuilding workspace for game masters. Characters, locations, factions, quests and lore — cross-linked into a living web with a relationship graph, campaign dashboards, a rich-text editor and full-text search. Your worlds stay on your device. No account, no cloud.

**About This Software**
```
[h2]Your entire world in one place — and it stays yours[/h2]
Game Master's Hub is a local-first workspace for tabletop game masters:
every character, location, item, faction, quest and session note lives on
your device, connected into one navigable web. No account, no subscription,
no cloud — back up and move worlds as a single archive file.

[h2]Write lore that links itself[/h2]
[list]
[*]Rich-text editor with images, file attachments and version history
[*]Type @ to mention any entry — links are two-way and feed the graph
[*]Full character profiles: stats grid, biography, relationships, inventory
[*]Interactive relationship graph of your whole world
[/list]

[h2]Run the table, not the paperwork[/h2]
[list]
[*]Campaign dashboards with quest boards and session logs
[*]Instant full-text search across everything
[*]Tags, favorites, filters and a tag manager
[*]Printable PDF world book and JSON export
[/list]

[h2]Make it your system[/h2]
[list]
[*]Custom sections with their own fields via the Section Constructor
[*]Two world styles: classic Fantasy or neon Cyberpunk — per world
[*]Import a complete TTG D&D database with relationships and media
[*]English, Russian, German, French and Chinese interface
[/list]
```

---

### 4.3 Русский

**Короткое описание**
> Офлайн-мастерская мастера игр. Персонажи, локации, фракции, квесты и лор — связанные в живую сеть: граф связей, панели кампаний, редактор текста и мгновенный поиск. Ваши миры остаются на вашем устройстве. Без аккаунта и облака.

**Об этом ПО**
```
[h2]Весь ваш мир в одном месте — и он остаётся вашим[/h2]
Game Master's Hub — локальная рабочая среда мастера настольных игр: каждый
персонаж, локация, предмет, фракция, квест и заметка сессии хранятся на
вашем устройстве и связаны в единую сеть. Без аккаунта, подписки и облака —
мир переносится одним файлом-архивом.

[h2]Лор, который ссылается сам на себя[/h2]
[list]
[*]Редактор с изображениями, вложениями и историей версий
[*]Наберите @ — упоминание становится двусторонней ссылкой и попадает в граф
[*]Полные профили персонажей: характеристики, биография, отношения, инвентарь
[*]Интерактивный граф связей всего мира
[/list]

[h2]Ведите игру, а не бумажную работу[/h2]
[list]
[*]Панели кампаний: доска квестов и журнал сессий
[*]Мгновенный полнотекстовый поиск по всему
[*]Теги, избранное, фильтры и менеджер тегов
[*]Печатная PDF-книга мира и экспорт в JSON
[/list]

[h2]Подстройте под свою систему[/h2]
[list]
[*]Свои разделы с собственными полями через Конструктор
[*]Два стиля мира: классическое Фэнтези или неоновый Киберпанк
[*]Импорт полной базы TTG D&D со связями и медиа
[*]Интерфейс: русский, английский, немецкий, французский, китайский
[/list]
```

---

### 4.4 Deutsch

**Kurzbeschreibung**
> Der Offline-Weltenbau-Arbeitsplatz für Spielleiter. Charaktere, Orte, Fraktionen, Quests und Lore — verknüpft zu einem lebendigen Netz mit Beziehungsgraph, Kampagnen-Dashboards, Rich-Text-Editor und Volltextsuche. Deine Welten bleiben auf deinem Gerät. Kein Konto, keine Cloud.

**Über diese Software**
```
[h2]Deine ganze Welt an einem Ort — und sie gehört dir[/h2]
Game Master's Hub ist ein lokaler Arbeitsplatz für Spielleiter: jeder
Charakter, Ort, Gegenstand, jede Fraktion, Quest und Sitzungsnotiz liegt auf
deinem Gerät, verbunden zu einem navigierbaren Netz. Kein Konto, kein Abo,
keine Cloud — Welten sichern und umziehen als eine einzige Archivdatei.

[h2]Lore, die sich selbst verlinkt[/h2]
[list]
[*]Rich-Text-Editor mit Bildern, Dateianhängen und Versionsverlauf
[*]Mit @ beliebige Einträge erwähnen — Links wirken in beide Richtungen
[*]Vollständige Charakterprofile: Werte, Biografie, Beziehungen, Inventar
[*]Interaktiver Beziehungsgraph der ganzen Welt
[/list]

[h2]Leite den Spieltisch, nicht den Papierkram[/h2]
[list]
[*]Kampagnen-Dashboards mit Questbrett und Sitzungsprotokoll
[*]Sofortige Volltextsuche über alles
[*]Tags, Favoriten, Filter und Tag-Verwaltung
[*]Druckbares PDF-Weltenbuch und JSON-Export
[/list]

[h2]Mach es zu deinem System[/h2]
[list]
[*]Eigene Bereiche mit eigenen Feldern per Bereichs-Konstruktor
[*]Zwei Weltstile: klassische Fantasy oder Neon-Cyberpunk — pro Welt
[*]Import einer kompletten TTG-D&D-Datenbank mit Beziehungen und Medien
[*]Oberfläche auf Deutsch, Englisch, Russisch, Französisch und Chinesisch
[/list]
```

---

### 4.5 Français

**Description courte**
> L'espace de worldbuilding hors ligne pour maîtres de jeu. Personnages, lieux, factions, quêtes et lore — reliés en un réseau vivant : graphe de relations, tableaux de campagne, éditeur de texte riche et recherche instantanée. Vos mondes restent sur votre appareil. Sans compte ni cloud.

**À propos de ce logiciel**
```
[h2]Tout votre monde au même endroit — et il reste le vôtre[/h2]
Game Master's Hub est un espace de travail local pour maîtres de jeu :
chaque personnage, lieu, objet, faction, quête et note de séance vit sur
votre appareil, relié en un réseau navigable. Pas de compte, pas
d'abonnement, pas de cloud — sauvegardez et déplacez vos mondes en un seul
fichier d'archive.

[h2]Un lore qui se relie tout seul[/h2]
[list]
[*]Éditeur de texte riche avec images, pièces jointes et historique de versions
[*]Tapez @ pour mentionner une entrée — les liens sont bidirectionnels
[*]Profils de personnages complets : caractéristiques, biographie, relations, inventaire
[*]Graphe de relations interactif de tout le monde
[/list]

[h2]Menez la table, pas la paperasse[/h2]
[list]
[*]Tableaux de campagne : suivi des quêtes et journal des séances
[*]Recherche plein texte instantanée sur tout
[*]Étiquettes, favoris, filtres et gestionnaire d'étiquettes
[*]Livre-monde PDF imprimable et export JSON
[/list]

[h2]Adaptez-le à votre système[/h2]
[list]
[*]Sections personnalisées avec leurs propres champs via le Constructeur
[*]Deux styles de monde : Fantasy classique ou Cyberpunk néon — par monde
[*]Import d'une base TTG D&D complète avec relations et médias
[*]Interface en français, anglais, russe, allemand et chinois
[/list]
```

---

### 4.6 简体中文

**简短描述**
> 为游戏主持人打造的离线世界构建工作台。角色、地点、阵营、任务与设定相互链接成活的网络：关系图谱、战役面板、富文本编辑器与全文搜索。你的世界只保存在你的设备上，无需账号，无需云端。

**关于此软件**
```
[h2]整个世界尽在一处——而且完全属于你[/h2]
Game Master's Hub 是面向桌面 RPG 主持人的本地优先工作台：每个角色、
地点、物品、阵营、任务和跑团记录都保存在你的设备上，并连接成可导航的
网络。无账号、无订阅、无云端——一个存档文件即可备份和迁移整个世界。

[h2]会自动互相链接的设定[/h2]
[list]
[*]富文本编辑器：图片、文件附件、版本历史
[*]输入 @ 即可提及任意条目——链接是双向的，并汇入图谱
[*]完整的角色档案：属性面板、传记、人际关系、物品栏
[*]整个世界的交互式关系图谱
[/list]

[h2]主持游戏，而不是整理文书[/h2]
[list]
[*]战役面板：任务板与跑团日志
[*]覆盖一切的即时全文搜索
[*]标签、收藏、筛选与标签管理器
[*]可打印的 PDF 世界之书与 JSON 导出
[/list]

[h2]打造你自己的体系[/h2]
[list]
[*]通过分区构建器创建带自定义字段的专属分区
[*]两种世界风格：经典奇幻或霓虹赛博朋克——按世界选择
[*]导入完整的 TTG D&D 数据库，保留关系与媒体
[*]界面支持简体中文、英语、俄语、德语、法语
[/list]
```

---

### 4.7 Системные требования (для всех языков)

- **Минимальные:** Windows 10 64-bit · двухъядерный CPU · 4 GB RAM ·
  видео с поддержкой DirectX 11 · 300 MB на диске
- **Рекомендуемые:** Windows 10/11 64-bit · 8 GB RAM · SSD
  (базы больших миров и медиа открываются быстрее)

---

## Часть 5. Цена и региональная сетка

База: **$9.99**. Разовая покупка — главное преимущество перед
подписочными конкурентами (World Anvil, Campfire ≈ $5–12/мес).

При установке цены Steam предложит автоматические пересчёты — примите их и
поправьте ключевые регионы примерно так (по рекомендациям Valve 2026 года):

| Регион | Цена | Регион | Цена |
|---|---|---|---|
| США | $9.99 | Еврозона | €9.75 |
| Россия | ₽385–450 | Великобритания | £8.50 |
| Украина | ₴240–290 | Китай | ¥42–50 |
| Турция | $3.00–3.60 | Бразилия | R$28–33 |
| Казахстан | ₸2 300–2 700 | Аргентина | $2.50–3.50 |

Скидку на запуск (−10…−15%) Steam разрешает включить с первого дня —
включайте: она даёт заметный буст видимости в «Новинках».

## Часть 6. Чек-лист до нажатия Release

- [ ] Налоговое интервью и банк подтверждены, fee оплачен ≥ 30 дней назад
- [ ] Страница Coming Soon публична ≥ 14 дней
- [ ] Билд загружен, назначен на ветку default, установлен и запущен
      через сам Steam-клиент на чистой машине
- [ ] Все ассеты загружены, 5+ скриншотов, описания на 5 языках вставлены
      в локализованные вкладки страницы (Store Page → все языки)
- [ ] Поддерживаемые языки отмечены: EN, RU, DE, FR, ZH (интерфейс)
- [ ] Цена и региональная сетка расставлены, launch discount настроен
- [ ] Ревью страницы и ревью билда пройдены (обе галочки зелёные)
