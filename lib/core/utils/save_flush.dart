/// Hooks that flush debounced, not-yet-persisted edits (currently the lore
/// editor's autosave). The pause menu awaits them before "Save project"
/// zips the database and before "Exit" terminates the process — exit(0)
/// never runs widget dispose, so without this the last ~2 seconds of
/// typing would be lost.
final saveFlushHooks = <Future<void> Function()>{};

Future<void> flushPendingSaves() async {
  // Copy: a hook may complete synchronously and unregister itself.
  for (final hook in List.of(saveFlushHooks)) {
    await hook();
  }
}
