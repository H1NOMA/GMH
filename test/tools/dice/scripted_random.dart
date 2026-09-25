import 'dart:math';

/// A [Random] that returns a fixed script from [nextInt], so every roll is
/// deterministic. [ScriptedRandom.dice] takes die faces (1-based) and
/// converts them to the 0-based values `nextInt` returns.
class ScriptedRandom implements Random {
  final List<int> _raw;
  int _next = 0;

  /// The `max` argument of every `nextInt` call so far.
  final List<int> requested = [];

  ScriptedRandom(List<int> raw) : _raw = List.of(raw);

  ScriptedRandom.dice(List<int> faces) : this([for (final f in faces) f - 1]);

  int get remaining => _raw.length - _next;

  @override
  int nextInt(int max) {
    if (_next >= _raw.length) {
      throw StateError('ScriptedRandom exhausted after $_next values');
    }
    final v = _raw[_next++];
    requested.add(max);
    if (v < 0 || v >= max) {
      throw StateError('Scripted value $v out of range for nextInt($max)');
    }
    return v;
  }

  @override
  bool nextBool() => nextInt(2) == 1;

  @override
  double nextDouble() => nextInt(1 << 30) / (1 << 30);
}
