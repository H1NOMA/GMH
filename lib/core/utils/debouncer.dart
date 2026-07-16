import 'dart:async';

/// Trailing-edge debouncer used by search-as-you-type and editor autosave.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer(this.delay);

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Runs any pending action immediately (used on dispose/navigation so no
  /// pending autosave is lost).
  void flush(void Function() action) {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
      action();
    }
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
