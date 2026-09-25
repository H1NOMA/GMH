import '../../../app/l10n_ext.dart';
import '../../../domain/tables/table_ranges.dart';
import '../../../domain/tables/table_roller.dart';

/// `5` or `5–8`.
String tableRangeText(int? from, int? to) {
  if (from == null || to == null) return '';
  return from == to ? '$from' : '$from–$to';
}

/// One readable sentence per validation issue (row numbers are 1-based).
String tableIssueText(
  AppLocalizations l,
  TableIssue issue, {
  FormulaBounds? bounds,
}) {
  int row(int i) => issue.rows.length > i ? issue.rows[i] + 1 : 0;
  final range = tableRangeText(issue.from, issue.to);
  return switch (issue.kind) {
    TableIssueKind.badFormula => l.tablesIssueBadFormula,
    TableIssueKind.empty => l.tablesIssueEmpty,
    TableIssueKind.emptyRow => l.tablesIssueEmptyRow(row(0)),
    TableIssueKind.missingRange => l.tablesIssueMissingRange(row(0)),
    TableIssueKind.invertedRange => l.tablesIssueInverted(row(0)),
    TableIssueKind.outOfBounds => l.tablesIssueOutOfBounds(
      row(0),
      bounds == null ? range : tableRangeText(bounds.min, bounds.max),
    ),
    TableIssueKind.gap => l.tablesIssueGap(range),
    TableIssueKind.overlap => l.tablesIssueOverlap(row(0), row(1), range),
  };
}

String tableFailureText(AppLocalizations l, TableRollFailure failure) =>
    switch (failure) {
      TableRollFailure.notFound => l.tablesFailNotFound,
      TableRollFailure.cycle => l.tablesFailCycle,
      TableRollFailure.depthLimit => l.tablesFailDepth,
      TableRollFailure.tooMany => l.tablesFailTooMany,
      TableRollFailure.empty => l.tablesFailEmpty,
      TableRollFailure.badFormula => l.tablesFailBadFormula,
    };
