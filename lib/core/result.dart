import 'exceptions.dart';

/// A lightweight functional result type used across all domain services and
/// repositories so failures are values, never uncaught exceptions in the UI.
sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok<T>;
  const factory Result.err(GmhException error) = Err<T>;

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  T get value => switch (this) {
        Ok<T>(value: final v) => v,
        Err<T>() => throw StateError('Tried to read value of an Err result'),
      };

  GmhException get error => switch (this) {
        Ok<T>() => throw StateError('Tried to read error of an Ok result'),
        Err<T>(error: final e) => e,
      };

  R fold<R>(R Function(T value) onOk, R Function(GmhException error) onErr) =>
      switch (this) {
        Ok<T>(value: final v) => onOk(v),
        Err<T>(error: final e) => onErr(e),
      };

  Result<R> map<R>(R Function(T value) transform) => switch (this) {
        Ok<T>(value: final v) => Result.ok(transform(v)),
        Err<T>(error: final e) => Result.err(e),
      };

  T getOrElse(T Function() fallback) => isOk ? value : fallback();
}

final class Ok<T> extends Result<T> {
  @override
  final T value;
  const Ok(this.value);
}

final class Err<T> extends Result<T> {
  @override
  final GmhException error;
  const Err(this.error);
}

/// Runs [body] and converts thrown exceptions into an [Err] with a
/// [GmhException], preserving typed exceptions when already ours.
Future<Result<T>> guard<T>(Future<T> Function() body) async {
  try {
    return Result.ok(await body());
  } on GmhException catch (e) {
    return Result.err(e);
  } catch (e, st) {
    return Result.err(UnexpectedException(e.toString(), stackTrace: st));
  }
}
