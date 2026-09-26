import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A text input with trailing action buttons on one line.
///
/// The actions get exactly the field's height and top edge — whatever the
/// platform density, tap-target padding or text scale — and the error
/// message goes under the whole row instead of inside the field, so it
/// never pushes the field out of line with its buttons.
///
/// While [error] is shown, give the field's decoration
/// `error: FieldActionRow.errorMarker`: it paints the error border without
/// reserving room for a message inside the field.
class FieldActionRow extends StatelessWidget {
  final Widget field;
  final List<Widget> actions;
  final String? error;
  final double gap;

  const FieldActionRow({
    super.key,
    required this.field,
    required this.actions,
    this.error,
    this.gap = 8,
  });

  static const Widget errorMarker = SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inset = theme.inputDecorationTheme.contentPadding
            ?.resolve(Directionality.of(context)) ??
        const EdgeInsets.symmetric(horizontal: 12);
    // Always a Column, error or not: switching the tree shape would
    // rebuild the field and drop its focus mid-typing.
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldActionLayout(gap: gap, children: [field, ...actions]),
        if (error != null)
          Padding(
            padding: EdgeInsetsDirectional.only(
                start: inset.left, end: inset.right, top: 4),
            child: Text(
              error!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.error)
                  .merge(theme.inputDecorationTheme.errorStyle),
            ),
          ),
      ],
    );
  }
}

class _FieldActionLayout extends MultiChildRenderObjectWidget {
  final double gap;

  const _FieldActionLayout({required this.gap, required super.children});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderFieldActionLayout(gap, Directionality.of(context));

  @override
  void updateRenderObject(
      BuildContext context, _RenderFieldActionLayout renderObject) {
    renderObject
      ..gap = gap
      ..textDirection = Directionality.of(context);
  }
}

class _FieldActionParentData extends ContainerBoxParentData<RenderBox> {}

/// First child: the field, taking the width the actions leave. Every other
/// child: an action at its natural width and the field's height.
class _RenderFieldActionLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _FieldActionParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _FieldActionParentData> {
  _RenderFieldActionLayout(this._gap, this._textDirection);

  double _gap;
  set gap(double value) {
    if (value == _gap) return;
    _gap = value;
    markNeedsLayout();
  }

  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (value == _textDirection) return;
    _textDirection = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _FieldActionParentData) {
      child.parentData = _FieldActionParentData();
    }
  }

  Iterable<RenderBox> get _actions sync* {
    var child = firstChild == null ? null : childAfter(firstChild!);
    while (child != null) {
      yield child;
      child = childAfter(child);
    }
  }

  double get _actionsWidth => _actions.fold(
      0, (sum, a) => sum + _gap + a.getMaxIntrinsicWidth(double.infinity));

  double _fieldWidth(double maxWidth) =>
      math.max(0, maxWidth - _actionsWidth);

  @override
  double computeMinIntrinsicWidth(double height) =>
      (firstChild?.getMinIntrinsicWidth(height) ?? 0) + _actionsWidth;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      (firstChild?.getMaxIntrinsicWidth(height) ?? 0) + _actionsWidth;

  @override
  double computeMinIntrinsicHeight(double width) =>
      firstChild?.getMinIntrinsicHeight(_fieldWidth(width)) ?? 0;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      firstChild?.getMaxIntrinsicHeight(_fieldWidth(width)) ?? 0;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final field = firstChild;
    if (field == null) return constraints.smallest;
    final width = _fieldWidth(constraints.maxWidth);
    final height = field
        .getDryLayout(BoxConstraints(
            minWidth: width, maxWidth: width, maxHeight: constraints.maxHeight))
        .height;
    return constraints.constrain(Size(constraints.maxWidth, height));
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    final field = firstChild;
    if (field == null) return null;
    final offset = (field.parentData! as _FieldActionParentData).offset;
    final distance = field.getDistanceToActualBaseline(baseline);
    return distance == null ? null : distance + offset.dy;
  }

  @override
  void performLayout() {
    final field = firstChild;
    if (field == null) {
      size = constraints.smallest;
      return;
    }
    assert(constraints.hasBoundedWidth,
        'FieldActionRow needs a bounded width, like any text field.');
    final width = _fieldWidth(constraints.maxWidth);
    field.layout(
        BoxConstraints(
            minWidth: width, maxWidth: width, maxHeight: constraints.maxHeight),
        parentUsesSize: true);
    final height = field.size.height;
    final rtl = _textDirection == TextDirection.rtl;
    final total = constraints.maxWidth;
    (field.parentData! as _FieldActionParentData).offset =
        Offset(rtl ? total - width : 0, 0);
    var x = width;
    for (final action in _actions) {
      x += _gap;
      final actionWidth = action.getMaxIntrinsicWidth(double.infinity);
      action.layout(BoxConstraints.tight(Size(actionWidth, height)),
          parentUsesSize: true);
      (action.parentData! as _FieldActionParentData).offset =
          Offset(rtl ? total - x - actionWidth : x, 0);
      x += actionWidth;
    }
    size = constraints.constrain(Size(total, height));
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
