// Geometry probe for the alignment audit: finds the visible controls on
// screen (input boxes, buttons, chips, toggles, and the single-line labels
// beside them) and reports every pair sharing a row whose edges or centers
// don't line up.
//
// Only the top layer counts: a control is probed when a hit test at its
// center reaches it, so pages under a dialog, offstage tabs and scrolled-
// away content are skipped.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

enum ControlKind {
  /// Outlined/filled input box (text fields, dropdowns).
  field,

  /// Buttons with a visible container: filled, tonal, elevated, outlined.
  boxButton,

  /// Text and icon buttons: no visible container, only content.
  flatButton,
  chip,
  segmented,
  toggle,

  /// A single-line text or icon sitting in a row next to a control.
  label,
}

bool _boxy(ControlKind k) =>
    k == ControlKind.field ||
    k == ControlKind.boxButton ||
    k == ControlKind.chip ||
    k == ControlKind.segmented;

class ProbeControl {
  final ControlKind kind;
  final RenderBox box;

  /// Render object a hit test at the center must reach.
  final RenderBox hitBox;
  final String desc;
  late final Rect rect = box.localToGlobal(Offset.zero) & box.size;

  ProbeControl(this.kind, this.box, this.hitBox, this.desc);

  Map<String, Object?> toJson() => {
        'kind': kind.name,
        'desc': desc,
        'rect': [rect.left, rect.top, rect.width, rect.height]
            .map((v) => double.parse(v.toStringAsFixed(1)))
            .toList(),
      };
}

class AlignIssue {
  /// `hard` — visibly out of line; `soft` — worth a look (height mismatch,
  /// label drift).
  final String severity;
  final String rule;
  final String detail;
  final ProbeControl a;
  final ProbeControl b;
  final String container;

  AlignIssue(this.severity, this.rule, this.detail, this.a, this.b,
      this.container);

  bool get hard => severity == 'hard';

  String get signature =>
      '$rule|${a.kind.name}:${a.desc}|${b.kind.name}:${b.desc}';

  Map<String, Object?> toJson() => {
        'severity': severity,
        'rule': rule,
        'detail': detail,
        'a': a.toJson(),
        'b': b.toJson(),
        'container': container,
      };

  @override
  String toString() => '[$severity $rule] ${a.desc} ↔ ${b.desc}: $detail\n'
      '    in $container';
}

String _typeName(Object o) => o.runtimeType.toString();

String _textOf(Element e) {
  final buffer = <String>[];
  void visit(Element el) {
    if (buffer.isNotEmpty) return;
    final w = el.widget;
    if (w is Text) {
      buffer.add(w.data ?? w.textSpan?.toPlainText() ?? '');
    } else if (w is RichText) {
      buffer.add(w.text.toPlainText());
    } else if (w is Icon && w.icon != null) {
      buffer.add('icon:${w.icon!.codePoint.toRadixString(16)}');
    }
    el.visitChildElements(visit);
  }

  visit(e);
  final text = buffer.isEmpty ? '' : buffer.first.replaceAll('\n', ' ');
  return text.length > 28 ? '${text.substring(0, 28)}…' : text;
}

String _describe(Element e, String type) {
  final key = e.widget.key;
  final keyText = key is ValueKey ? ' #${key.value}' : '';
  final text = _textOf(e);
  return '$type$keyText${text.isEmpty ? '' : ' "$text"'}';
}

RenderBox? _firstBox(Element e) {
  RenderBox? found;
  void visit(Element el) {
    if (found != null) return;
    final r = el.renderObject;
    if (el is RenderObjectElement && r is RenderBox) {
      found = r;
      return;
    }
    el.visitChildElements(visit);
  }

  visit(e);
  return found;
}

/// First descendant [Material] — the visible container of buttons and
/// chips (the outer box may include tap-target padding).
Element? _materialElement(Element e) {
  Element? found;
  void visit(Element el) {
    if (found != null) return;
    if (el.widget is Material) {
      found = el;
      return;
    }
    el.visitChildElements(visit);
  }

  visit(e);
  return found;
}

RenderBox? _materialBox(Element e) {
  final material = _materialElement(e);
  return material == null ? null : _firstBox(material);
}

/// Whether a button's [Material] paints a visible container: a fill or an
/// outline. Text and plain icon buttons paint only their content.
bool _hasContainer(Material m) {
  final color = m.color;
  if (color != null && color.a > 0.02) return true;
  final shape = m.shape;
  if (shape is OutlinedBorder &&
      shape.side.style != BorderStyle.none &&
      shape.side.width > 0 &&
      shape.side.color.a > 0.02) {
    return true;
  }
  return false;
}

bool _isVisible(WidgetTester tester, ProbeControl c) {
  if (!c.box.attached || !c.box.hasSize) return false;
  if (c.rect.width < 2 || c.rect.height < 2) return false;
  final view = tester.view;
  final screen = Offset.zero & (view.physicalSize / view.devicePixelRatio);
  final center = c.rect.center;
  if (!screen.contains(center)) return false;
  final result = HitTestResult();
  WidgetsBinding.instance.hitTestInView(result, center, view.viewId);
  return result.path.any((entry) => identical(entry.target, c.hitBox));
}

/// Every visible control of the current frame.
List<ProbeControl> collectControls(WidgetTester tester) {
  final controls = <ProbeControl>[];
  final seen = <RenderBox>{};

  void add(ControlKind kind, RenderBox? box, RenderBox? hitBox, String desc) {
    if (box == null || hitBox == null || !seen.add(box)) return;
    final c = ProbeControl(kind, box, hitBox, desc);
    if (_isVisible(tester, c)) controls.add(c);
  }

  void visit(Element e, bool insideField, bool insideComposite) {
    final w = e.widget;
    final type = _typeName(w);
    if (w is Offstage && w.offstage) return;
    if (w is Visibility && !w.visible) return;
    var nowInField = insideField;
    var nowInComposite = insideComposite;

    if (type == '_BorderContainer' && !_borderless(e)) {
      final box = _firstBox(e);
      add(ControlKind.field, box, box?.parent as RenderBox?,
          _describe(_fieldOwner(e) ?? e, _fieldTypeName(e)));
    } else if (w is InputDecorator) {
      nowInField = true;
    } else if (w is SegmentedButton) {
      final box = _firstBox(e);
      add(ControlKind.segmented, box, box, _describe(e, 'SegmentedButton'));
      nowInComposite = true;
    } else if ((w is ButtonStyleButton || w is IconButton) &&
        !insideField &&
        !insideComposite) {
      final material = _materialElement(e);
      final visible = material == null ? _firstBox(e) : _firstBox(material);
      final kind = material != null && _hasContainer(material.widget as Material)
          ? ControlKind.boxButton
          : ControlKind.flatButton;
      add(kind, visible, visible, _describe(e, type));
      nowInComposite = true;
    } else if (w is RawChip && !insideField) {
      final visible = _materialBox(e);
      add(ControlKind.chip, visible, visible, _describe(e, 'Chip'));
      nowInComposite = true;
    } else if ((w is Switch || w is Checkbox || w is Radio) &&
        !insideComposite) {
      final box = _firstBox(e);
      add(ControlKind.toggle, box, box, _describe(e, type));
      nowInComposite = true;
    } else if (w is FloatingActionButton || w is NavigationBar ||
        w is NavigationRail || w is TabBar || w is ListTile ||
        w is AppBar || w is PopupMenuButton || w is SnackBar) {
      // Framework composites lay out their own content; probing inside
      // them only reports the framework.
      nowInComposite = true;
    }
    e.visitChildElements((c) => visit(c, nowInField, nowInComposite));
  }

  WidgetsBinding.instance.rootElement?.visitChildElements(
      (e) => visit(e, false, false));
  return controls;
}

/// Unfilled decorators drawn without a border have no visible box to
/// line up.
bool _borderless(Element border) {
  var none = false;
  border.visitAncestorElements((a) {
    final w = a.widget;
    if (w is InputDecorator) {
      final d = w.decoration;
      none = d.isCollapsed == true ||
          (d.filled == false &&
              (d.enabledBorder ?? d.border) == InputBorder.none);
      return false;
    }
    return true;
  });
  return none;
}

Element? _fieldOwner(Element border) {
  Element? owner;
  border.visitAncestorElements((a) {
    final w = a.widget;
    if (w is TextField || w is DropdownButtonFormField || w is DropdownMenu ||
        w is TextFormField || w is DropdownButton) {
      owner = a;
      return false;
    }
    return true;
  });
  return owner;
}

String _fieldTypeName(Element border) {
  final owner = _fieldOwner(border);
  return owner == null ? 'InputDecorator' : _typeName(owner.widget);
}

String _creatorChain(RenderObject r) {
  final creator = r.debugCreator;
  if (creator is DebugCreator) {
    return creator.element.debugGetCreatorChain(12);
  }
  return _typeName(r);
}

List<RenderObject> _ancestry(RenderObject r) {
  final chain = <RenderObject>[r];
  var node = r.parent;
  while (node != null) {
    chain.add(node);
    node = node.parent;
  }
  return chain;
}

/// Row-like containers whose children should share a line.
String? _rowKind(RenderObject r) {
  if (r is RenderFlex) {
    return r.direction == Axis.horizontal ? 'row' : null;
  }
  if (r is RenderWrap) {
    return r.direction == Axis.horizontal ? 'wrap' : null;
  }
  if (r is RenderTable) return 'table';
  final type = _typeName(r);
  if (type.contains('OverflowBar')) return 'bar';
  return null;
}

bool _overlapV(Rect a, Rect b) =>
    math.min(a.bottom, b.bottom) - math.max(a.top, b.top) > 0;

double _gapH(Rect a, Rect b) =>
    math.max(0, math.max(a.left, b.left) - math.min(a.right, b.right));

String _f(double v) => v.toStringAsFixed(1);

/// Checks every pair of controls sharing a row.
List<AlignIssue> probeAlignment(WidgetTester tester) {
  final controls = collectControls(tester);
  final chains = {for (final c in controls) c: _ancestry(c.box)};

  // How many controls live under each render object: a row child holding
  // several controls (a column of fields, a card) is a group, not a
  // single cell to line up.
  final counts = <RenderObject, int>{};
  for (final chain in chains.values) {
    for (final r in chain) {
      counts[r] = (counts[r] ?? 0) + 1;
    }
  }

  final issues = <AlignIssue>[];
  for (var i = 0; i < controls.length; i++) {
    final a = controls[i];
    final aChain = chains[a]!;
    final index = {for (var k = 0; k < aChain.length; k++) aChain[k]: k};
    for (var j = i + 1; j < controls.length; j++) {
      final b = controls[j];
      final bChain = chains[b]!;
      var bi = 0;
      while (bi < bChain.length && !index.containsKey(bChain[bi])) {
        bi++;
      }
      if (bi >= bChain.length) continue;
      final ai = index[bChain[bi]]!;
      if (ai == 0 || bi == 0) continue;
      final container = bChain[bi];
      final kind = _rowKind(container);
      if (kind == null) continue;
      final aCell = aChain[ai - 1];
      final bCell = bChain[bi - 1];
      if (counts[aCell] != 1 || counts[bCell] != 1) continue;
      if (kind != 'row' && !_overlapV(a.rect, b.rect)) continue;
      if (kind == 'row' && !_overlapV(a.rect, b.rect) &&
          (a.rect.center.dy - b.rect.center.dy).abs() > 24) {
        continue;
      }
      if (_gapH(a.rect, b.rect) > 96) continue;
      final issue = _check(a, b, kind, container);
      if (issue != null) issues.add(issue);
    }
  }
  issues.addAll(_labelIssues(controls, chains, counts));
  return issues;
}

AlignIssue? _check(
    ProbeControl a, ProbeControl b, String kind, RenderObject container) {
  final ra = a.rect, rb = b.rect;
  final dTop = (ra.top - rb.top).abs();
  final dBottom = (ra.bottom - rb.bottom).abs();
  final dCenter = (ra.center.dy - rb.center.dy).abs();
  String where() => '$kind: ${_creatorChain(container)}';
  final geometry = 'top ${_f(ra.top)} vs ${_f(rb.top)}, '
      'height ${_f(ra.height)} vs ${_f(rb.height)}';

  final pairKinds = {a.kind, b.kind};
  final fieldAndButton = pairKinds.contains(ControlKind.field) &&
      (pairKinds.contains(ControlKind.boxButton) ||
          pairKinds.contains(ControlKind.segmented));
  if (fieldAndButton) {
    if (dTop > 1 || dBottom > 1) {
      return AlignIssue(dCenter > 1.5 ? 'hard' : 'soft', 'field-action',
          geometry, a, b, where());
    }
    return null;
  }
  if (_boxy(a.kind) && _boxy(b.kind)) {
    if (dCenter > 1.5 && dTop > 1) {
      return AlignIssue('hard', 'box-misaligned', geometry, a, b, where());
    }
    if ((ra.height - rb.height).abs() > 2 &&
        a.kind != ControlKind.chip &&
        b.kind != ControlKind.chip) {
      return AlignIssue('soft', 'box-height', geometry, a, b, where());
    }
    return null;
  }
  if (dCenter > 2) {
    return AlignIssue(
        'hard', 'center-misaligned', 'center ${_f(ra.center.dy)} vs '
            '${_f(rb.center.dy)} ($geometry)', a, b, where());
  }
  return null;
}

/// Single-line texts/icons in a row next to a control whose vertical
/// center drifts from it.
List<AlignIssue> _labelIssues(
    List<ProbeControl> controls,
    Map<ProbeControl, List<RenderObject>> chains,
    Map<RenderObject, int> counts) {
  final issues = <AlignIssue>[];
  final rows = <RenderFlex, List<(RenderBox, ProbeControl)>>{};
  for (final c in controls) {
    final chain = chains[c]!;
    for (var k = 1; k < chain.length; k++) {
      final r = chain[k];
      if (r is RenderFlex && r.direction == Axis.horizontal) {
        final cell = chain[k - 1];
        if (counts[cell] == 1 && cell is RenderBox) {
          rows.putIfAbsent(r, () => []).add((cell, c));
        }
        break;
      }
    }
  }
  for (final MapEntry(key: row, value: cells) in rows.entries) {
    final controlCells = {for (final (cell, _) in cells) cell};
    row.visitChildren((child) {
      if (child is! RenderBox || controlCells.contains(child)) return;
      if ((counts[child] ?? 0) > 0) return;
      final paragraphs = <RenderParagraph>[];
      var editable = false;
      void find(RenderObject r) {
        if (r is RenderParagraph) paragraphs.add(r);
        if (r is RenderEditable) editable = true;
        r.visitChildren(find);
      }

      find(child);
      // Selectable text renders as an editable: a cell holding one counts
      // more lines than its paragraphs show.
      if (editable || paragraphs.length != 1) return;
      final p = paragraphs.single;
      if (!p.hasSize || !p.attached) return;
      final label = ProbeControl(ControlKind.label, p, p,
          'Label "${_short(p.text.toPlainText())}"');
      final lr = label.rect;
      // Nearest control on the row.
      ProbeControl? nearest;
      var best = double.infinity;
      for (final (_, c) in cells) {
        final d = _gapH(c.rect, lr);
        if (d < best) {
          best = d;
          nearest = c;
        }
      }
      if (nearest == null || best > 160) return;
      if (lr.height >= nearest.rect.height) return;
      final dCenter = (lr.center.dy - nearest.rect.center.dy).abs();
      if (dCenter > 3) {
        issues.add(AlignIssue(
            'soft',
            'label-drift',
            'label center ${_f(lr.center.dy)} vs control center '
                '${_f(nearest.rect.center.dy)}',
            label,
            nearest,
            'row: ${_creatorChain(row)}'));
      }
    });
  }
  return issues;
}

String _short(String s) {
  final t = s.replaceAll('\n', ' ');
  if (t.codeUnits.length == 1 && t.codeUnitAt(0) > 0xE000) {
    return 'icon:${t.codeUnitAt(0).toRadixString(16)}';
  }
  return t.length > 28 ? '${t.substring(0, 28)}…' : t;
}
