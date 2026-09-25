/// Pure geometry of the map viewer: image <-> normalized coordinates,
/// distances in map units, and the viewport transforms (fit, center).
library;

import 'dart:math' as math;
import 'dart:ui' show Offset, Size;

import 'game_map.dart';

/// Clamps [value] to 0..1; null, NaN and infinities read as [fallback].
double clampUnit(double? value, [double fallback = 0.5]) {
  if (value == null || value.isNaN || value.isInfinite) return fallback;
  return value.clamp(0.0, 1.0);
}

/// Image pixel position -> normalized (0..1) position. [clamp] keeps
/// points dropped past the edge on the map.
Offset imageToNormalized(Offset point, Size image, {bool clamp = true}) {
  if (image.width <= 0 || image.height <= 0) return const Offset(0.5, 0.5);
  final x = point.dx / image.width;
  final y = point.dy / image.height;
  return clamp ? Offset(clampUnit(x), clampUnit(y)) : Offset(x, y);
}

/// Normalized position -> image pixel position.
Offset normalizedToImage(Offset point, Size image) =>
    Offset(point.dx * image.width, point.dy * image.height);

/// Distance between two normalized points in image pixels.
double pixelDistance(Offset a, Offset b, Size image) =>
    (normalizedToImage(a, image) - normalizedToImage(b, image)).distance;

/// How diagonal moves are counted when measuring.
enum MeasureRule {
  /// Straight-line (Euclidean) distance.
  straight,

  /// Grid squares, every diagonal step costs one square (5e default).
  gridSimple,

  /// Grid squares, diagonals alternate one and two squares (5-10-5).
  gridAlternating,
}

/// Grid squares moved between [a] and [b] (normalized) with cells of
/// [cellPx] image pixels. Partial squares round to the nearest square.
int gridSteps(
  Offset a,
  Offset b,
  Size image,
  double cellPx, {
  MeasureRule rule = MeasureRule.gridSimple,
}) {
  if (cellPx <= 0) return 0;
  final d = normalizedToImage(b, image) - normalizedToImage(a, image);
  final dx = (d.dx.abs() / cellPx).round();
  final dy = (d.dy.abs() / cellPx).round();
  final long = math.max(dx, dy);
  final short = math.min(dx, dy);
  return switch (rule) {
    MeasureRule.gridAlternating => long + short ~/ 2,
    _ => long,
  };
}

/// Distance between [a] and [b] (normalized) in the map's units, or null
/// without a usable [scale].
double? mapDistance(
  Offset a,
  Offset b,
  Size image,
  MapScale? scale, {
  MeasureRule rule = MeasureRule.straight,
}) {
  if (scale == null || scale.cellPx <= 0 || scale.unitsPerCell <= 0) {
    return null;
  }
  if (rule == MeasureRule.straight) {
    return pixelDistance(a, b, image) * scale.unitsPerPixel;
  }
  return gridSteps(a, b, image, scale.cellPx.toDouble(), rule: rule) *
      scale.unitsPerCell.toDouble();
}

/// Compact number for distance labels: `12`, `12.5`, `0.25`, `1250`.
String formatDistance(double value) {
  if (value.isNaN || value.isInfinite) return '–';
  final abs = value.abs();
  final digits = abs >= 100
      ? 0
      : abs >= 10
      ? 1
      : 2;
  var text = value.toStringAsFixed(digits);
  if (text.contains('.')) {
    text = text.replaceFirst(RegExp(r'0+$'), '');
    if (text.endsWith('.')) text = text.substring(0, text.length - 1);
  }
  return text == '-0' ? '0' : text;
}

/// Scale and translation of a viewport transform (screen = content *
/// scale + offset).
typedef ViewTransform = ({double scale, double dx, double dy});

/// Shows all of [content] centered in [viewport], leaving [padding] screen
/// pixels around it.
ViewTransform fitTransform(Size viewport, Size content, {double padding = 16}) {
  if (content.width <= 0 ||
      content.height <= 0 ||
      viewport.width <= 0 ||
      viewport.height <= 0) {
    return (scale: 1.0, dx: 0.0, dy: 0.0);
  }
  final availW = math.max(1.0, viewport.width - padding * 2);
  final availH = math.max(1.0, viewport.height - padding * 2);
  final scale = math.min(availW / content.width, availH / content.height);
  return (
    scale: scale,
    dx: (viewport.width - content.width * scale) / 2,
    dy: (viewport.height - content.height * scale) / 2,
  );
}

/// Puts [point] (content pixels) in the middle of [viewport] at [scale].
ViewTransform centerTransform(Size viewport, Offset point, double scale) => (
  scale: scale,
  dx: viewport.width / 2 - point.dx * scale,
  dy: viewport.height / 2 - point.dy * scale,
);

/// Screen position of a normalized map point under [view].
Offset normalizedToScreen(Offset point, Size image, ViewTransform view) {
  final p = normalizedToImage(point, image);
  return Offset(p.dx * view.scale + view.dx, p.dy * view.scale + view.dy);
}

/// Normalized map position of a screen point under [view] (unclamped).
Offset screenToNormalized(Offset screen, Size image, ViewTransform view) {
  if (view.scale <= 0) return const Offset(0.5, 0.5);
  final p = Offset(
    (screen.dx - view.dx) / view.scale,
    (screen.dy - view.dy) / view.scale,
  );
  return imageToNormalized(p, image, clamp: false);
}

/// Moves a normalized point by a screen-space [delta] at [scale], clamped
/// to the map.
Offset dragNormalized(Offset start, Offset delta, Size image, double scale) {
  if (scale <= 0 || image.width <= 0 || image.height <= 0) return start;
  return Offset(
    clampUnit(start.dx + delta.dx / (image.width * scale)),
    clampUnit(start.dy + delta.dy / (image.height * scale)),
  );
}

/// Draw every n-th grid line so lines stay at least [minGap] screen pixels
/// apart when [cellPx] image pixels are shown at [scale].
int gridLineStride(double cellPx, double scale, {double minGap = 6}) {
  final onScreen = cellPx * scale;
  if (onScreen <= 0 || onScreen.isNaN) return 1;
  if (onScreen >= minGap) return 1;
  return (minGap / onScreen).ceil();
}

/// Zooms [view] by [factor] keeping the screen point [focal] fixed; the
/// resulting scale is clamped to [minScale]..[maxScale].
ViewTransform zoomAround(
  ViewTransform view,
  Offset focal,
  double factor, {
  double minScale = 0,
  double maxScale = double.infinity,
}) {
  if (view.scale <= 0 || factor <= 0 || factor.isNaN) return view;
  final target = (view.scale * factor).clamp(minScale, maxScale).toDouble();
  final f = target / view.scale;
  return (
    scale: target,
    dx: focal.dx - (focal.dx - view.dx) * f,
    dy: focal.dy - (focal.dy - view.dy) * f,
  );
}
