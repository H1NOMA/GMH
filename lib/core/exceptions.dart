/// Typed exception hierarchy for GMH. Every failure surfaced to the UI is one
/// of these, so error handling stays exhaustive and user-presentable.
sealed class GmhException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  const GmhException(this.message, {this.stackTrace});

  /// Short, user-facing description.
  String get userMessage => message;

  @override
  String toString() => '$runtimeType: $message';
}

class NotFoundException extends GmhException {
  const NotFoundException(super.message);
}

class ValidationException extends GmhException {
  const ValidationException(super.message);
}

class StorageException extends GmhException {
  const StorageException(super.message, {super.stackTrace});
}

class DatabaseException extends GmhException {
  const DatabaseException(super.message, {super.stackTrace});
}

class ImportException extends GmhException {
  const ImportException(super.message, {super.stackTrace});
}

class ExportException extends GmhException {
  const ExportException(super.message, {super.stackTrace});
}

class UnexpectedException extends GmhException {
  const UnexpectedException(super.message, {super.stackTrace});

  @override
  String get userMessage => 'Something went wrong. Please try again.';
}
