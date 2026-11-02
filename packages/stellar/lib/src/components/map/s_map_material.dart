import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_map_engine.dart';
import 's_map_google.dart';
import 's_map_libre.dart';
import 's_map_provider.dart';
import 's_map_renderer.dart';

const _pinSize = Size(48, 60);

/// How far the pin rises while the map moves, as if picked up.
const _lift = 10.0;
const _liftDuration = Duration(milliseconds: 150);
const _shadowSize = Size(10, 4);

/// The floating controls' shadow, as the page's floating buttons have.
const _shadowBlur = 18.0;
const _shadowDrop = 6.0;

class MaterialMapRenderer implements MapRenderer {
  const MaterialMapRenderer();

  @override
  Widget picker(BuildContext context, MapPickerSpec spec) => _MapPicker(spec);

  @override
  Widget page(BuildContext context, MapPageSpec spec) {
    final c = context.colors;
    final onBack = spec.onBack;
    final action = spec.action;
    return Scaffold(
      backgroundColor: c.surface,
      body: Stack(
        children: [
          Positioned.fill(child: spec.map),
          // Only the controls take touches; the rest goes to the map.
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Space.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (onBack != null)
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: _Floating(
                        radius: Radii.pill,
                        child: IconButton(
                          tooltip: MaterialLocalizations.of(context)
                              .backButtonTooltip,
                          onPressed: onBack,
                          icon: Icon(
                            materialIcon(SIcons.chevronBack),
                            size: SIconSize.md.pixels,
                            color: c.text,
                          ),
                        ),
                      ),
                    ),
                  const Spacer(),
                  if (action != null) ...[
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: _Floating(radius: Radii.pill, child: action),
                    ),
                    const Gap(Space.md),
                  ],
                  _Floating(
                    radius: Radii.xl,
                    child: Padding(
                      padding: const EdgeInsets.all(Space.lg),
                      child: spec.panel,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A control lifted off the map: the page's surface with a thin outline
/// and a soft shadow, so it reads on any part of the map.
class _Floating extends StatelessWidget {
  const _Floating({required this.radius, required this.child});

  final double radius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: c.border),
        boxShadow: [
          BoxShadow(
            color: c.shadow,
            blurRadius: _shadowBlur,
            offset: const Offset(0, _shadowDrop),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MapPicker extends StatefulWidget {
  const _MapPicker(this.spec);

  final MapPickerSpec spec;

  @override
  State<_MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<_MapPicker> {
  var _moving = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final engine = MapEngineSpec(
      target: widget.spec.target,
      areas: widget.spec.areas,
      areaColor: c.primary,
      onMoveStarted: () => setState(() => _moving = true),
      onMoved: (point) {
        setState(() => _moving = false);
        widget.spec.onMoved(point);
      },
    );
    return Stack(
      children: [
        switch (MapProvider.configured) {
          MapProvider.openFreeMap => LibreMapEngine(engine),
          MapProvider.google => GoogleMapEngine(engine),
        },
        IgnorePointer(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Where the tip lands, seen while the pin is lifted.
                Container(
                  width: _shadowSize.width,
                  height: _shadowSize.height,
                  decoration: ShapeDecoration(
                    shape: const OvalBorder(),
                    color: c.text.withValues(alpha: 0.3),
                  ),
                ),
                // Centering a box with the pin on top and as much space
                // under it puts the tip on the middle of the map.
                AnimatedPadding(
                  duration: _liftDuration,
                  curve: Curves.easeOut,
                  padding: EdgeInsets.only(
                    bottom: _pinSize.height + (_moving ? 2 * _lift : 0),
                  ),
                  child: Image.asset(
                    'assets/map/pin.png',
                    package: 'stellar',
                    width: _pinSize.width,
                    height: _pinSize.height,
                    excludeFromSemantics: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
