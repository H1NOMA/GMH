import '../../../core/exceptions.dart';
import '../../../core/result.dart';
import 'lore_context.dart';

/// AI-READY ARCHITECTURE — contracts only, deliberately unimplemented.
///
/// Feature code may depend on this interface today; wiring a local or remote
/// model later is purely a data-layer plug-in registered in DI. Nothing else
/// in the app changes.
abstract interface class AiAssistant {
  /// Whether a real model is wired up (UI hides AI affordances otherwise).
  bool get isAvailable;

  /// "Create a quest based on this artifact."
  Future<Result<String>> generateQuestIdea(LoreContext context);

  /// "Find contradictions in my lore."
  Future<Result<List<String>>> findContradictions(LoreContext context);

  /// "Show all events connected to this character" style free-form questions,
  /// grounded in the provided context.
  Future<Result<String>> answerLoreQuestion(
      LoreContext context, String question);
}

/// Default no-op implementation shipped in v1.
class NoopAiAssistant implements AiAssistant {
  const NoopAiAssistant();

  static const _err =
      Err<Never>(ValidationException('No AI provider is configured.'));

  @override
  bool get isAvailable => false;

  @override
  Future<Result<String>> generateQuestIdea(LoreContext context) async => _err;

  @override
  Future<Result<List<String>>> findContradictions(LoreContext context) async =>
      _err;

  @override
  Future<Result<String>> answerLoreQuestion(
          LoreContext context, String question) async =>
      _err;
}
