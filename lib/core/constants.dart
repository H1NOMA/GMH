/// Application-wide constants.
abstract final class GmhConstants {
  static const appName = "Game Master's Hub";
  static const appNameShort = 'GMH';

  /// Version stamp embedded in exports so future importers can migrate.
  static const exportFormatVersion = 1;

  /// File extension for full project archives.
  static const projectArchiveExtension = 'gmhw';

  /// How many document versions to retain per document.
  static const maxDocumentVersions = 25;

  /// How many recent items to retain per world.
  static const maxRecentItems = 50;

  /// How many rotating automatic backups to keep.
  static const maxAutoBackups = 7;

  /// Minimum interval between automatic backups.
  static const autoBackupInterval = Duration(hours: 20);

  /// Debounce for as-you-type search.
  static const searchDebounce = Duration(milliseconds: 150);

  /// Debounce for editor autosave.
  static const autosaveDebounce = Duration(seconds: 2);

  /// Layout breakpoints (logical pixels).
  static const phoneMaxWidth = 640.0;
  static const desktopMinWidth = 1024.0;
}
