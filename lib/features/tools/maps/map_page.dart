import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/router.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../app/tools.dart';
import '../../../domain/maps/game_map.dart';
import '../../../domain/maps/map_geometry.dart';
import '../../../domain/maps/map_pin.dart';
import '../../../domain/maps/map_search.dart';
import '../../../domain/models/custom_category.dart';
import '../../../domain/models/entity.dart';
import '../../categories/category_ui.dart';
import '../../shell/ui_providers.dart';
import '../tool_scaffold.dart';
import 'map_side_panel.dart';
import 'maps_actions.dart';
import 'maps_canvas.dart';
import 'maps_dialogs.dart';
import 'maps_list.dart';
import 'maps_style.dart';

enum MapMode { select, add, measure }

/// Width from which the side panel sits next to the map.
const _wideLayout = 960.0;
const _panelWidth = 320.0;
const _pinSize = 32.0;
const _labelWidth = 160.0;

/// One map: pan/zoom viewer with pins, modes (select, add, measure), the
/// player view and the pins/details panel.
class MapPage extends ConsumerStatefulWidget {
  final String worldId;
  final String mapId;

  /// Pin to center on when the page opens (from `?pin=`).
  final String? focusPinId;

  const MapPage({
    super.key,
    required this.worldId,
    required this.mapId,
    this.focusPinId,
  });

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  late final MapsActions _actions;
  final _transform = TransformationController();
  final _focusNode = FocusNode(debugLabel: 'map-page');

  MapMode _mode = MapMode.select;
  bool _playerView = false;
  bool _panelOpen = true;
  String? _selectedPinId;
  Offset? _measureA;
  Offset? _measureB;
  MeasureRule _rule = MeasureRule.straight;

  Size? _viewport;
  Size? _content;
  bool _userMoved = false;
  String? _handledFocus;

  String? _dragPinId;
  Offset _dragStart = Offset.zero;
  Offset _dragDelta = Offset.zero;

  /// Positions dropped but not yet echoed back by the database stream.
  final _pendingPositions = <String, Offset>{};

  @override
  void initState() {
    super.initState();
    _actions = ref.read(mapsActionsProvider);
  }

  @override
  void didUpdateWidget(covariant MapPage old) {
    super.didUpdateWidget(old);
    if (old.focusPinId != widget.focusPinId) _handledFocus = null;
  }

  @override
  void dispose() {
    _transform.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  MapPinsQuery get _query => (worldId: widget.worldId, mapId: widget.mapId);

  ViewTransform get _view => viewOf(_transform.value);

  ViewTransform _fit() => fitTransform(_viewport!, _content!);

  double get _minScale =>
      _viewport == null || _content == null ? 0.05 : _fit().scale * 0.5;

  double get _maxScale => _viewport == null || _content == null
      ? 8
      : math.max(8.0, _fit().scale * 12);

  void _setView(ViewTransform view) => _transform.value = matrixOf(view);

  void _fitView() {
    if (_viewport == null || _content == null) return;
    _userMoved = false;
    _setView(_fit());
  }

  void _zoom(double factor) {
    final viewport = _viewport;
    if (viewport == null) return;
    _userMoved = true;
    _setView(
      zoomAround(
        _view,
        viewport.center(Offset.zero),
        factor,
        minScale: _minScale,
        maxScale: _maxScale,
      ),
    );
  }

  void _centerOn(MapPin pin, {bool zoomIn = true}) {
    final viewport = _viewport;
    final content = _content;
    if (viewport == null || content == null) return;
    _userMoved = true;
    final scale = zoomIn
        ? math.max(_view.scale, math.min(_fit().scale * 2.5, _maxScale))
        : _view.scale;
    _setView(
      centerTransform(
        viewport,
        normalizedToImage(Offset(pin.x, pin.y), content),
        scale,
      ),
    );
    setState(() => _selectedPinId = pin.id);
  }

  /// Keeps the map fitted to the viewport until the user moves it, and
  /// honors a pending `?pin=` focus once the pins are known.
  void _onLayout(Size viewport, Size content, List<MapPin> pins) {
    final changed = viewport != _viewport || content != _content;
    _viewport = viewport;
    _content = content;
    final focus = widget.focusPinId;
    final focusPin = focus == null || focus == _handledFocus
        ? null
        : pins.where((p) => p.id == focus).firstOrNull;
    if (!changed && focusPin == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (focusPin != null) {
        _handledFocus = focusPin.id;
        _centerOn(focusPin);
      } else if (!_userMoved) {
        _setView(_fit());
      }
    });
  }

  Offset _positionOf(MapPin pin) {
    if (pin.id == _dragPinId) {
      final content = _content;
      if (content != null) {
        return dragNormalized(_dragStart, _dragDelta, content, _view.scale);
      }
    }
    final pending = _pendingPositions[pin.id];
    if (pending != null) {
      if (pending == Offset(pin.x, pin.y)) {
        _pendingPositions.remove(pin.id);
      } else {
        return pending;
      }
    }
    return Offset(pin.x, pin.y);
  }

  // ------------------------------------------------------------ actions

  void _onMapTap(Offset contentPoint, GameMap map) {
    final content = _content;
    if (content == null || _playerView) {
      setState(() => _selectedPinId = null);
      return;
    }
    final point = imageToNormalized(contentPoint, content);
    switch (_mode) {
      case MapMode.select:
        setState(() => _selectedPinId = null);
      case MapMode.add:
        unawaited(_addPinAt(point, map));
      case MapMode.measure:
        _addMeasurePoint(point);
    }
  }

  void _addMeasurePoint(Offset point) {
    setState(() {
      if (_measureA == null || _measureB != null) {
        _measureA = point;
        _measureB = null;
      } else {
        _measureB = point;
      }
    });
  }

  void _clearMeasure() => setState(() {
    _measureA = null;
    _measureB = null;
  });

  void _setMode(MapMode mode) => setState(() {
    _mode = mode;
    // The pin card would cover the map the new mode needs.
    if (mode != MapMode.select) _selectedPinId = null;
    if (mode != MapMode.measure) {
      _measureA = null;
      _measureB = null;
    }
  });

  void _onPinTap(MapPin pin, GameMap map, Map<String, Entity> entities) {
    if (!_playerView && _mode == MapMode.measure) {
      _addMeasurePoint(_positionOf(pin));
      return;
    }
    if (_selectedPinId == pin.id && !_playerView) {
      unawaited(_editPin(pin, map, entities));
      return;
    }
    setState(() => _selectedPinId = pin.id);
  }

  Future<void> _addPinAt(Offset point, GameMap map) async {
    final result = await showPinEditor(
      context,
      worldId: widget.worldId,
      initial: MapPin(
        worldId: widget.worldId,
        mapId: map.id,
        x: point.dx,
        y: point.dy,
        gmOnly: !map.pinsVisibleToPlayers,
      ),
      isNew: true,
    );
    if (result == null || !mounted) return;
    final pin = await _actions.addPin(map, result.pin);
    if (!mounted) return;
    setState(() {
      _selectedPinId = pin.id;
      _mode = MapMode.select;
    });
    if (result.action == PinEditorAction.openEntry) _openEntry(pin.entityId);
  }

  Future<void> _editPin(
    MapPin pin,
    GameMap map,
    Map<String, Entity> entities,
  ) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final result = await showPinEditor(
      context,
      worldId: widget.worldId,
      initial: pin,
      isNew: false,
      entity: entities[pin.entityId],
    );
    if (result == null || !mounted) return;
    switch (result.action) {
      case PinEditorAction.save:
        await _actions.savePin(result.pin);
      case PinEditorAction.openEntry:
        await _actions.savePin(result.pin);
        if (mounted) _openEntry(result.pin.entityId);
      case PinEditorAction.delete:
        if (_selectedPinId == pin.id) setState(() => _selectedPinId = null);
        await _actions.deletePin(pin.id);
        final actions = _actions;
        messenger.showSnackBar(
          SnackBar(
            content: Text(l.mapsPinDeleted),
            action: SnackBarAction(
              label: l.undo,
              onPressed: () => unawaited(actions.addPin(map, pin)),
            ),
          ),
        );
    }
  }

  void _openEntry(String? entityId) {
    if (entityId == null || !mounted) return;
    context.go(Routes.entity(widget.worldId, entityId));
  }

  void _onDragStart(MapPin pin) {
    final start = _positionOf(pin);
    setState(() {
      _dragPinId = pin.id;
      _dragStart = start;
      _dragDelta = Offset.zero;
      _selectedPinId = pin.id;
    });
  }

  void _onDragUpdate(Offset delta) => setState(() => _dragDelta += delta);

  Future<void> _onDragEnd(MapPin pin) async {
    final content = _content;
    if (_dragPinId != pin.id || content == null) return;
    final pos = dragNormalized(_dragStart, _dragDelta, content, _view.scale);
    setState(() {
      _dragPinId = null;
      _pendingPositions[pin.id] = pos;
    });
    await _actions.savePin(pin.copyWith(x: pos.dx, y: pos.dy));
  }

  Future<void> _changeImage(GameMap map) async {
    final l = context.l10n;
    final pick = ref.read(mapImagePickerProvider);
    final messenger = ScaffoldMessenger.of(context);
    final files = await pick();
    if (files.isEmpty || !mounted) return;
    final image = await _actions.importImage(widget.worldId, files.first);
    if (image == null) {
      messenger.showSnackBar(SnackBar(content: Text(l.mapsImportFailed)));
      return;
    }
    await _actions.replaceImage(map, image);
    if (mounted) setState(() => _userMoved = false);
  }

  void _toList() => context.go(Routes.tool(widget.worldId, 'maps'));

  void _setPlayerView(bool on) {
    setState(() {
      _playerView = on;
      _selectedPinId = null;
      _measureA = null;
      _measureB = null;
      _mode = MapMode.select;
    });
    _focusNode.requestFocus();
  }

  void _openPanelSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SizedBox(
        height: MediaQuery.sizeOf(sheetContext).height * 0.7,
        child: MapSidePanel(
          worldId: widget.worldId,
          mapId: widget.mapId,
          selectedPinId: _selectedPinId,
          onPinTap: (pin) {
            Navigator.pop(sheetContext);
            _centerOn(pin);
          },
        ),
      ),
    );
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    if (_playerView) {
      _setPlayerView(false);
    } else if (_measureA != null) {
      _clearMeasure();
    } else if (_selectedPinId != null) {
      setState(() => _selectedPinId = null);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  // ------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final mapAsync = ref.watch(gameMapProvider(widget.mapId));
    final map = mapAsync.valueOrNull;
    if (map == null) {
      if (!mapAsync.hasValue && !mapAsync.hasError) {
        return const ToolScaffold(
          toolId: 'maps',
          body: Center(child: CircularProgressIndicator()),
        );
      }
      return ToolScaffold(
        toolId: 'maps',
        body: ToolEmptyState(
          icon: toolById('maps')!.icon,
          title: l.mapsMissing,
          hint: '',
          action: FilledButton(onPressed: _toList, child: Text(l.mapsAllMaps)),
        ),
      );
    }

    final allPins = ref.watch(mapPinsProvider(_query)).valueOrNull ?? const [];
    final entities = ref.watch(mapPinEntitiesProvider(_query));
    final categories = ref.watch(categoryMapProvider(widget.worldId));
    final pins = visiblePins(allPins, playerView: _playerView);
    final mediaId = map.mediaId;
    final imagePath = mediaId == null
        ? null
        : ref.watch(mediaPathProvider(mediaId));
    final imageMissing =
        imagePath != null && imagePath.hasValue && imagePath.value == null;

    final viewer = _viewer(map, pins, entities, categories, imageMissing);

    final Widget page;
    if (_playerView) {
      page = Scaffold(body: viewer);
    } else {
      page = LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= _wideLayout;
          final panel = MapSidePanel(
            worldId: widget.worldId,
            mapId: widget.mapId,
            selectedPinId: _selectedPinId,
            onPinTap: _centerOn,
          );
          return ToolScaffold(
            toolId: 'maps',
            title: map.name,
            actions: [
              IconButton(
                key: const ValueKey('maps-player-view'),
                tooltip: l.mapsPlayerView,
                icon: const Icon(Icons.connected_tv_outlined),
                onPressed: () => _setPlayerView(true),
              ),
              IconButton(
                key: const ValueKey('maps-panel-toggle'),
                tooltip: l.mapsPanel,
                isSelected: wide && _panelOpen,
                icon: const Icon(Icons.view_sidebar_outlined),
                onPressed: wide
                    ? () => setState(() => _panelOpen = !_panelOpen)
                    : _openPanelSheet,
              ),
              IconButton(
                key: const ValueKey('maps-back'),
                tooltip: l.mapsAllMaps,
                icon: const Icon(Icons.grid_view_outlined),
                onPressed: _toList,
              ),
              MapMenu(
                map: map,
                onDeleted: _toList,
                extra: [
                  PopupMenuItem(
                    key: const ValueKey('maps-menu-details'),
                    value: 'details',
                    child: Text(l.mapsEditDetails),
                  ),
                  PopupMenuItem(
                    key: const ValueKey('maps-menu-image'),
                    value: 'image',
                    child: Text(l.mapsChangeImage),
                  ),
                ],
                onExtra: (action) async {
                  if (action == 'image') {
                    await _changeImage(map);
                  } else if (action == 'details') {
                    final edited = await showMapDetailsDialog(
                      context,
                      initial: map,
                    );
                    if (edited != null) await _actions.save(edited);
                  }
                },
              ),
            ],
            body: wide && _panelOpen
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: viewer),
                      const VerticalDivider(width: 1),
                      SizedBox(width: _panelWidth, child: panel),
                    ],
                  )
                : viewer,
          );
        },
      );
    }
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: page,
    );
  }

  Widget _viewer(
    GameMap map,
    List<MapPin> pins,
    Map<String, Entity> entities,
    Map<String, CustomCategory> categories,
    bool imageMissing,
  ) {
    final l = context.l10n;
    final content = Size(map.width.toDouble(), map.height.toDouble());
    Color colorOf(MapPin pin) {
      final entity = entities[pin.entityId];
      return pinColor(
        pin.color,
        entityColor: entity == null ? null : entityColor(entity, categories),
      );
    }

    String labelOf(MapPin pin) =>
        pin.displayLabel(entities[pin.entityId]?.name);

    final selected = pins.where((p) => p.id == _selectedPinId).firstOrNull;

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = constraints.biggest;
        _onLayout(viewport, content, pins);
        final grid = map.gridVisible;
        return ClipRect(
          child: Stack(
            children: [
              Positioned.fill(
                child: ColoredBox(
                  color: GmhColors.background,
                  child: InteractiveViewer(
                    key: const ValueKey('maps-viewer'),
                    transformationController: _transform,
                    constrained: false,
                    boundaryMargin: const EdgeInsets.all(double.infinity),
                    minScale: _minScale,
                    maxScale: _maxScale,
                    onInteractionStart: (_) => _userMoved = true,
                    child: GestureDetector(
                      key: const ValueKey('maps-canvas'),
                      behavior: HitTestBehavior.opaque,
                      onTapUp: (d) => _onMapTap(d.localPosition, map),
                      child: SizedBox(
                        width: content.width,
                        height: content.height,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            MapBackground(map: map),
                            if (grid)
                              CustomPaint(
                                painter: MapGridPainter(
                                  cellPx: map.scale!.cellPx.toDouble(),
                                  color: GmhColors.parchment.withValues(
                                    alpha: 0.35,
                                  ),
                                  transform: _transform,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Pins and the measuring line live above the viewer in screen
              // space, so they keep their size at any zoom.
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _transform,
                  builder: (context, _) {
                    final view = _view;
                    Offset screen(Offset n) =>
                        normalizedToScreen(n, content, view);
                    final a = _measureA;
                    final b = _measureB;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (a != null && !_playerView)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: MeasurePainter(
                                  a: screen(a),
                                  b: b == null ? null : screen(b),
                                  color: GmhColors.ember,
                                  halo: GmhColors.surface,
                                ),
                              ),
                            ),
                          ),
                        for (final pin in pins)
                          _marker(
                            pin,
                            screen(_positionOf(pin)),
                            colorOf(pin),
                            labelOf(pin),
                            map,
                            entities,
                          ),
                      ],
                    );
                  },
                ),
              ),
              if (!_playerView)
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: _Toolbar(
                    mode: _mode,
                    onMode: _setMode,
                    onZoomIn: () => _zoom(1.5),
                    onZoomOut: () => _zoom(1 / 1.5),
                    onFit: _fitView,
                    hint: _hint(map, content),
                  ),
                ),
              if (_playerView)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Wrap(
                    spacing: 8,
                    children: [
                      IconButton.filledTonal(
                        // Same height as the exit button beside it; icon
                        // buttons ignore the theme density by default.
                        style: IconButton.styleFrom(
                          minimumSize: const Size.square(48),
                          visualDensity: Theme.of(context).visualDensity,
                        ),
                        tooltip: l.mapsFit,
                        onPressed: _fitView,
                        icon: const Icon(Icons.fit_screen_outlined),
                      ),
                      FilledButton.icon(
                        key: const ValueKey('maps-exit-player-view'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 48),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: () => _setPlayerView(false),
                        icon: const Icon(Icons.close),
                        label: Text(l.mapsExitPlayerView),
                      ),
                    ],
                  ),
                ),
              if (imageMissing && !_playerView)
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: selected == null ? 12 : null,
                  top: selected == null ? null : 72,
                  child: _MissingImageBanner(
                    onChange: () => _changeImage(map),
                  ),
                ),
              if (selected != null)
                Positioned(
                  left: 12,
                  bottom: 12,
                  right: viewport.width < 420 ? 12 : null,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 380,
                      maxHeight: math.max(120, viewport.height * 0.45),
                    ),
                    child: _PinCard(
                      pin: selected,
                      label: labelOf(selected),
                      color: colorOf(selected),
                      entity: entities[selected.entityId],
                      playerView: _playerView,
                      onEdit: () => _editPin(selected, map, entities),
                      onOpenEntry: () => _openEntry(selected.entityId),
                      onClose: () => setState(() => _selectedPinId = null),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget? _hint(GameMap map, Size content) {
    final l = context.l10n;
    switch (_mode) {
      case MapMode.select:
        return null;
      case MapMode.add:
        return Text(l.mapsAddHint, key: const ValueKey('maps-add-hint'));
      case MapMode.measure:
        final a = _measureA;
        final b = _measureB;
        if (a == null || b == null) {
          return Text(l.mapsMeasureHint, key: const ValueKey('maps-measure-hint'));
        }
        final scale = map.scale;
        final units = mapDistance(a, b, content, scale, rule: _rule);
        final text = units == null
            ? l.mapsPixels(formatDistance(pixelDistance(a, b, content)))
            : [formatDistance(units), scale!.unitName]
                  .where((s) => s.isNotEmpty)
                  .join(' ');
        // Clear stays at the end of the line and only the texts wrap, so
        // it never drops under the distance, out of line with it.
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    l.mapsDistance(text),
                    key: const ValueKey('maps-measure-result'),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if (scale == null)
                    Text(
                      l.mapsMeasureNoScale,
                      style: TextStyle(fontSize: 12, color: GmhColors.parchmentDim),
                    )
                  else
                    PopupMenuButton<MeasureRule>(
                      key: const ValueKey('maps-measure-rule'),
                      tooltip: l.mapsMeasureRule,
                      initialValue: _rule,
                      onSelected: (r) => setState(() => _rule = r),
                      itemBuilder: (context) => [
                        for (final r in MeasureRule.values)
                          PopupMenuItem(value: r, child: Text(measureRuleLabel(l, r))),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                measureRuleLabel(l, _rule),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12.5, color: GmhColors.ember),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, size: 18, color: GmhColors.ember),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              key: const ValueKey('maps-measure-clear'),
              onPressed: _clearMeasure,
              child: Text(l.clear),
            ),
          ],
        );
    }
  }

  Widget _marker(
    MapPin pin,
    Offset at,
    Color color,
    String label,
    GameMap map,
    Map<String, Entity> entities,
  ) {
    final selected = pin.id == _selectedPinId;
    final canDrag = !_playerView && _mode != MapMode.measure;
    return Positioned(
      left: at.dx - _labelWidth / 2,
      top: at.dy - _pinSize / 2,
      width: _labelWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MouseRegion(
            cursor: canDrag ? SystemMouseCursors.grab : SystemMouseCursors.click,
            child: GestureDetector(
              key: ValueKey('maps-pin-${pin.id}'),
              // Count the slop too, so the pin stays under the pointer.
              dragStartBehavior: DragStartBehavior.down,
              onTap: () => _onPinTap(pin, map, entities),
              onPanStart: canDrag ? (_) => _onDragStart(pin) : null,
              onPanUpdate: canDrag ? (d) => _onDragUpdate(d.delta) : null,
              onPanEnd: canDrag ? (_) => _onDragEnd(pin) : null,
              onPanCancel: canDrag
                  ? () => setState(() => _dragPinId = null)
                  : null,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  PinBadge(
                    icon: pin.icon,
                    color: color,
                    size: _pinSize,
                    selected: selected,
                    faded: pin.gmOnly,
                  ),
                  if (pin.gmOnly)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: GmhColors.surface,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.visibility_off,
                          size: 11,
                          color: GmhColors.parchmentDim,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 3),
            IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: GmhColors.surface.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: selected ? color : GmhColors.border,
                  ),
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: GmhColors.parchment,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Mode switch, zoom buttons and the current mode's hint.
class _Toolbar extends StatelessWidget {
  final MapMode mode;
  final ValueChanged<MapMode> onMode;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onFit;
  final Widget? hint;

  const _Toolbar({
    required this.mode,
    required this.onMode,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onFit,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget card(Widget child) => Material(
      color: GmhColors.surface.withValues(alpha: 0.94),
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: Padding(padding: const EdgeInsets.all(4), child: child),
    );
    Widget modeButton(MapMode m, IconData icon, String label) {
      final on = m == mode;
      return Tooltip(
        message: label,
        child: IconButton(
          key: ValueKey('maps-mode-${m.name}'),
          isSelected: on,
          style: IconButton.styleFrom(
            backgroundColor: on ? GmhColors.ember.withValues(alpha: 0.18) : null,
            foregroundColor: on ? GmhColors.ember : GmhColors.parchmentDim,
          ),
          onPressed: () => onMode(m),
          icon: Icon(icon, size: 20),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            card(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  modeButton(MapMode.select, Icons.near_me_outlined, l.mapsModeSelect),
                  modeButton(MapMode.add, Icons.add_location_alt_outlined, l.mapsModeAdd),
                  modeButton(MapMode.measure, Icons.straighten, l.mapsModeMeasure),
                ],
              ),
            ),
            card(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    key: const ValueKey('maps-zoom-out'),
                    tooltip: l.mapsZoomOut,
                    onPressed: onZoomOut,
                    icon: const Icon(Icons.remove, size: 20),
                  ),
                  IconButton(
                    key: const ValueKey('maps-zoom-in'),
                    tooltip: l.mapsZoomIn,
                    onPressed: onZoomIn,
                    icon: const Icon(Icons.add, size: 20),
                  ),
                  IconButton(
                    key: const ValueKey('maps-fit'),
                    tooltip: l.mapsFit,
                    onPressed: onFit,
                    icon: const Icon(Icons.fit_screen_outlined, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (hint != null) ...[
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: card(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: DefaultTextStyle.merge(
                  style: const TextStyle(fontSize: 13),
                  child: hint!,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _MissingImageBanner extends StatelessWidget {
  final VoidCallback onChange;
  const _MissingImageBanner({required this.onChange});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final icon = Icon(Icons.broken_image_outlined, color: GmhColors.danger);
    final title = Text(
      l.mapsImageMissing,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
    final hint = Text(
      l.mapsImageMissingHint,
      style: TextStyle(fontSize: 12.5, color: GmhColors.parchmentDim),
    );
    final button = TextButton(onPressed: onChange, child: Text(l.mapsChangeImage));
    final inset = textButtonInset(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Material(
          key: const ValueKey('maps-image-missing'),
          color: GmhColors.surface.withValues(alpha: 0.95),
          elevation: 2,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(math.max(12, inset), 8, 8, 8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 440) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      icon,
                      const SizedBox(width: 8),
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 380),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [title, hint],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      button,
                    ],
                  );
                }
                // Too narrow for one line: the button goes under the text,
                // pulled back by its padding so its label shares the
                // text's left edge.
                final rtl = Directionality.of(context) == TextDirection.rtl;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        icon,
                        const SizedBox(width: 8),
                        Expanded(child: title),
                      ],
                    ),
                    const SizedBox(height: 4),
                    hint,
                    Transform.translate(
                      offset: Offset(rtl ? inset : -inset, 0),
                      child: button,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Details of the selected pin. Player view shows only what players may
/// see: the label and the linked entry's name.
class _PinCard extends StatelessWidget {
  final MapPin pin;
  final String label;
  final Color color;
  final Entity? entity;
  final bool playerView;
  final VoidCallback onEdit;
  final VoidCallback onOpenEntry;
  final VoidCallback onClose;

  const _PinCard({
    required this.pin,
    required this.label,
    required this.color,
    required this.entity,
    required this.playerView,
    required this.onEdit,
    required this.onOpenEntry,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final e = entity;
    return Material(
      key: const ValueKey('maps-pin-card'),
      color: GmhColors.surface.withValues(alpha: 0.97),
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PinBadge(icon: pin.icon, color: color, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label.isEmpty ? l.mapsUntitledPin : label,
                    key: const ValueKey('maps-pin-card-label'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  tooltip: l.close,
                  visualDensity: VisualDensity.compact,
                  onPressed: onClose,
                  icon: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
            if (!playerView && pin.gmOnly)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility_off_outlined,
                      size: 14,
                      color: GmhColors.parchmentDim,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        l.mapsPinGmOnlyHint,
                        style: TextStyle(
                          fontSize: 12,
                          color: GmhColors.parchmentDim,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (!playerView && pin.notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6, right: 8),
                child: Text(
                  pin.notes,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
              ),
            if (!playerView)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    if (e != null)
                      TextButton.icon(
                        key: const ValueKey('maps-pin-card-open'),
                        onPressed: onOpenEntry,
                        icon: const Icon(Icons.open_in_new, size: 16),
                        label: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Text(
                            e.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    TextButton.icon(
                      key: const ValueKey('maps-pin-card-edit'),
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: Text(l.mapsEditPin),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
