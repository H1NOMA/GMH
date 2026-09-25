import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/domain/maps/game_map.dart';
import 'package:gmh/domain/maps/map_geometry.dart';

const _image = Size(2000, 1000);

Matcher _near(Offset expected, [double eps = 1e-9]) => predicate<Offset>(
  (o) =>
      (o.dx - expected.dx).abs() < eps && (o.dy - expected.dy).abs() < eps,
  'close to $expected',
);

void main() {
  group('clampUnit', () {
    test('keeps values inside 0..1', () {
      expect(clampUnit(0.25), 0.25);
      expect(clampUnit(0), 0);
      expect(clampUnit(1), 1);
    });

    test('clamps values outside 0..1', () {
      expect(clampUnit(-0.3), 0);
      expect(clampUnit(4.2), 1);
    });

    test('null, NaN and infinities fall back', () {
      expect(clampUnit(null), 0.5);
      expect(clampUnit(double.nan), 0.5);
      expect(clampUnit(double.infinity), 0.5);
      expect(clampUnit(double.negativeInfinity, 0.1), 0.1);
    });
  });

  group('image <-> normalized', () {
    test('converts an image point to normalized', () {
      expect(
        imageToNormalized(const Offset(500, 250), _image),
        _near(const Offset(0.25, 0.25)),
      );
    });

    test('converts a normalized point to image pixels', () {
      expect(
        normalizedToImage(const Offset(0.5, 0.1), _image),
        _near(const Offset(1000, 100)),
      );
    });

    test('round trip is lossless', () {
      const p = Offset(1234.5, 678.25);
      expect(
        normalizedToImage(imageToNormalized(p, _image), _image),
        _near(p, 1e-6),
      );
    });

    test('points past the edge clamp by default', () {
      expect(
        imageToNormalized(const Offset(-50, 5000), _image),
        _near(const Offset(0, 1)),
      );
    });

    test('clamping can be turned off', () {
      expect(
        imageToNormalized(const Offset(-500, 2000), _image, clamp: false),
        _near(const Offset(-0.25, 2)),
      );
    });

    test('an empty image yields the center instead of dividing by zero', () {
      expect(
        imageToNormalized(const Offset(10, 10), Size.zero),
        const Offset(0.5, 0.5),
      );
    });
  });

  group('distance', () {
    const scale = MapScale(unitsPerCell: 5, unitName: 'ft', cellPx: 100);

    test('pixel distance uses the image aspect', () {
      // 0.3 of 2000 = 600 px across, 0.8 of 1000 = 800 px down.
      expect(
        pixelDistance(const Offset(0.1, 0.1), const Offset(0.4, 0.9), _image),
        closeTo(1000, 1e-9),
      );
    });

    test('straight-line distance in map units', () {
      expect(
        mapDistance(
          const Offset(0.1, 0.1),
          const Offset(0.4, 0.9),
          _image,
          scale,
        ),
        closeTo(50, 1e-9), // 1000 px / 100 px per cell * 5 ft
      );
    });

    test('distance of a point to itself is zero', () {
      expect(
        mapDistance(const Offset(0.3, 0.3), const Offset(0.3, 0.3), _image, scale),
        0,
      );
    });

    test('no scale means no distance in units', () {
      expect(
        mapDistance(const Offset(0, 0), const Offset(1, 1), _image, null),
        isNull,
      );
    });

    test('grid distance counts diagonals as one square', () {
      // 600 px = 6 cells across, 800 px = 8 cells down.
      expect(
        mapDistance(
          const Offset(0.1, 0.1),
          const Offset(0.4, 0.9),
          _image,
          scale,
          rule: MeasureRule.gridSimple,
        ),
        40, // 8 squares * 5 ft
      );
    });

    test('alternating diagonals add every second diagonal', () {
      // 8 long + 6 short / 2 = 11 squares.
      expect(
        mapDistance(
          const Offset(0.1, 0.1),
          const Offset(0.4, 0.9),
          _image,
          scale,
          rule: MeasureRule.gridAlternating,
        ),
        55,
      );
    });

    test('grid steps round partial squares', () {
      // 140 px = 1.4 cells -> 1; 260 px = 2.6 cells -> 3.
      expect(
        gridSteps(
          const Offset(0, 0),
          const Offset(0.07, 0.26),
          _image,
          100,
        ),
        3,
      );
      expect(gridSteps(const Offset(0, 0), const Offset(1, 1), _image, 0), 0);
    });

    test('straight distance scales with units per cell', () {
      const miles = MapScale(unitsPerCell: 24, unitName: 'miles', cellPx: 200);
      expect(
        mapDistance(const Offset(0, 0), const Offset(0.5, 0), _image, miles),
        closeTo(120, 1e-9), // 1000 px = 5 cells
      );
    });
  });

  group('formatDistance', () {
    test('whole numbers have no decimals', () {
      expect(formatDistance(12), '12');
      expect(formatDistance(0), '0');
    });

    test('keeps up to two decimals under 10', () {
      expect(formatDistance(2.345), '2.35');
      expect(formatDistance(0.25), '0.25');
      expect(formatDistance(2.5), '2.5');
    });

    test('one decimal from 10, none from 100', () {
      expect(formatDistance(12.34), '12.3');
      expect(formatDistance(123.4), '123');
    });

    test('garbage values are shown as a dash', () {
      expect(formatDistance(double.nan), '–');
      expect(formatDistance(double.infinity), '–');
    });

    test('negative zero reads as zero', () {
      expect(formatDistance(-0.001), '0');
    });
  });

  group('view transforms', () {
    test('fit centers a wide image in a tall viewport', () {
      final v = fitTransform(
        const Size(400, 800),
        const Size(2000, 1000),
        padding: 0,
      );
      expect(v.scale, closeTo(0.2, 1e-9));
      expect(v.dx, closeTo(0, 1e-9));
      expect(v.dy, closeTo(300, 1e-9)); // (800 - 200) / 2
    });

    test('fit honors the padding', () {
      final v = fitTransform(
        const Size(1000, 1000),
        const Size(1000, 1000),
        padding: 50,
      );
      expect(v.scale, closeTo(0.9, 1e-9));
      expect(v.dx, closeTo(50, 1e-9));
    });

    test('fit of an empty viewport or image is the identity', () {
      expect(fitTransform(Size.zero, _image), (scale: 1.0, dx: 0.0, dy: 0.0));
      expect(
        fitTransform(const Size(100, 100), Size.zero),
        (scale: 1.0, dx: 0.0, dy: 0.0),
      );
    });

    test('center puts the point in the middle of the viewport', () {
      final v = centerTransform(
        const Size(800, 600),
        const Offset(1000, 500),
        2,
      );
      expect(
        normalizedToScreen(const Offset(0.5, 0.5), _image, v),
        _near(const Offset(400, 300)),
      );
    });

    test('screen <-> normalized round trip', () {
      const v = (scale: 0.37, dx: -120.0, dy: 45.5);
      const n = Offset(0.61, 0.28);
      final screen = normalizedToScreen(n, _image, v);
      expect(screenToNormalized(screen, _image, v), _near(n, 1e-9));
    });

    test('screen to normalized with a zero scale is safe', () {
      expect(
        screenToNormalized(const Offset(5, 5), _image, (scale: 0.0, dx: 0.0, dy: 0.0)),
        const Offset(0.5, 0.5),
      );
    });

    test('zoom keeps the focal point fixed', () {
      const v = (scale: 0.5, dx: 10.0, dy: 20.0);
      const focal = Offset(300, 200);
      final before = screenToNormalized(focal, _image, v);
      final zoomed = zoomAround(v, focal, 2);
      expect(zoomed.scale, 1.0);
      expect(normalizedToScreen(before, _image, zoomed), _near(focal, 1e-9));
    });

    test('zoom clamps to the scale limits', () {
      const v = (scale: 1.0, dx: 0.0, dy: 0.0);
      expect(zoomAround(v, Offset.zero, 100, maxScale: 4).scale, 4);
      expect(zoomAround(v, Offset.zero, 0.001, minScale: 0.25).scale, 0.25);
      expect(zoomAround(v, Offset.zero, 0), v);
    });
  });

  group('dragging', () {
    test('a screen drag moves the pin by the zoomed amount', () {
      // At scale 0.5 the 2000 px image is 1000 px wide on screen: 100 px
      // of drag = 0.1 of the width.
      expect(
        dragNormalized(
          const Offset(0.5, 0.5),
          const Offset(100, -50),
          _image,
          0.5,
        ),
        _near(const Offset(0.6, 0.4)),
      );
    });

    test('drags stop at the map edge', () {
      expect(
        dragNormalized(
          const Offset(0.9, 0.1),
          const Offset(5000, -5000),
          _image,
          1,
        ),
        _near(const Offset(1, 0)),
      );
    });

    test('a zero scale does not move the pin', () {
      expect(
        dragNormalized(const Offset(0.2, 0.3), const Offset(50, 50), _image, 0),
        const Offset(0.2, 0.3),
      );
    });
  });

  group('grid stride', () {
    test('every line is drawn when cells are large enough', () {
      expect(gridLineStride(50, 1), 1);
    });

    test('lines thin out when zoomed far out', () {
      // 50 px * 0.02 = 1 px per cell on screen -> every 6th line.
      expect(gridLineStride(50, 0.02), 6);
    });

    test('degenerate input draws every line', () {
      expect(gridLineStride(0, 1), 1);
      expect(gridLineStride(50, double.nan), 1);
    });
  });
}
