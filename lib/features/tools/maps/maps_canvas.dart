import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/gmh_theme.dart';
import '../../../domain/maps/game_map.dart';
import '../../../domain/maps/map_geometry.dart';
import '../../shell/ui_providers.dart';

/// Largest width a map image is decoded at: an 8K map would otherwise cost
/// hundreds of MB of texture memory for detail nobody zooms into.
const _maxDecodeWidth = 4096;

/// The current transform of an InteractiveViewer as a [ViewTransform].
ViewTransform viewOf(Matrix4 m) =>
    (scale: m.getMaxScaleOnAxis(), dx: m.storage[12], dy: m.storage[13]);

Matrix4 matrixOf(ViewTransform v) => Matrix4.identity()
  ..setEntry(0, 0, v.scale)
  ..setEntry(1, 1, v.scale)
  ..setEntry(0, 3, v.dx)
  ..setEntry(1, 3, v.dy);

/// A blank map sheet drawn in theme colors: warm paper in the middle,
/// darker edges and a double frame line.
class MapParchmentPainter extends CustomPainter {
  final Color paper;
  final Color edge;
  final Color ink;

  MapParchmentPainter({
    required this.paper,
    required this.edge,
    required this.ink,
  });

  factory MapParchmentPainter.themed() => MapParchmentPainter(
    paper: GmhColors.surfaceRaised,
    edge: GmhColors.surfaceHigh,
    ink: GmhColors.border,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          colors: [paper, edge],
          radius: 0.9,
        ).createShader(rect),
    );
    final side = math.min(size.width, size.height);
    final inset = side * 0.02;
    final frame = Paint()
      ..style = PaintingStyle.stroke
      ..color = ink
      ..strokeWidth = math.max(1, side * 0.003);
    canvas.drawRect(rect.deflate(inset), frame);
    canvas.drawRect(rect.deflate(inset * 1.6), frame..strokeWidth *= 0.5);
  }

  @override
  bool shouldRepaint(MapParchmentPainter old) =>
      old.paper != paper || old.edge != edge || old.ink != ink;
}

/// Square grid of [cellPx] image pixels; lines keep a hairline width on
/// screen and thin out when zoomed far out.
class MapGridPainter extends CustomPainter {
  final double cellPx;
  final Color color;
  final TransformationController transform;

  MapGridPainter({
    required this.cellPx,
    required this.color,
    required this.transform,
  }) : super(repaint: transform);

  @override
  void paint(Canvas canvas, Size size) {
    if (cellPx <= 0) return;
    final scale = viewOf(transform.value).scale;
    final stride = gridLineStride(cellPx, scale);
    final step = cellPx * stride;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1 / math.max(scale, 0.0001);
    for (var x = 0.0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(MapGridPainter old) =>
      old.cellPx != cellPx || old.color != color || old.transform != transform;
}

/// Measuring line between screen points [a] and [b] ([b] may be absent).
class MeasurePainter extends CustomPainter {
  final Offset a;
  final Offset? b;
  final Color color;
  final Color halo;

  MeasurePainter({
    required this.a,
    required this.b,
    required this.color,
    required this.halo,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final end = b;
    if (end != null) {
      canvas.drawLine(
        a,
        end,
        Paint()
          ..color = halo
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawLine(
        a,
        end,
        Paint()
          ..color = color
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    }
    for (final p in [a, if (end != null) end]) {
      canvas.drawCircle(p, 7, Paint()..color = halo);
      canvas.drawCircle(p, 5, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(MeasurePainter old) =>
      old.a != a || old.b != b || old.color != color || old.halo != halo;
}

/// The map's background at image size: its image, or the blank sheet when
/// it has none, while it loads, or when the file is gone.
class MapBackground extends ConsumerWidget {
  final GameMap map;

  const MapBackground({super.key, required this.map});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blank = CustomPaint(painter: MapParchmentPainter.themed());
    final mediaId = map.mediaId;
    if (mediaId == null) return blank;
    final path = ref.watch(mediaPathProvider(mediaId)).valueOrNull;
    if (path == null) return blank;
    return Image.file(
      File(path),
      key: const ValueKey('maps-image'),
      fit: BoxFit.fill,
      filterQuality: FilterQuality.medium,
      cacheWidth: math.min(map.width, _maxDecodeWidth),
      gaplessPlayback: true,
      errorBuilder: (_, _, _) => blank,
    );
  }
}

/// Card thumbnail of a map.
class MapThumbnail extends ConsumerWidget {
  final GameMap map;

  const MapThumbnail({super.key, required this.map});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaId = map.mediaId;
    final path = mediaId == null
        ? null
        : ref.watch(mediaPathProvider(mediaId)).valueOrNull;
    final blank = Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(painter: MapParchmentPainter.themed()),
        Center(
          child: Icon(
            mediaId == null ? Icons.explore_outlined : Icons.broken_image_outlined,
            size: 36,
            color: GmhColors.parchmentFaint,
          ),
        ),
      ],
    );
    if (path == null) return blank;
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      cacheWidth: 640,
      errorBuilder: (_, _, _) => blank,
    );
  }
}
