import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';

/// A cover photo with a round logo over its bottom edge, at the start: a
/// store's page header. Both are usually `SPhotoField`s.
///
/// At the top of a page that scrolls, pulling the page down past its top
/// grows the cover upward into the gap, as iOS apps do, instead of leaving
/// the page's color above it.
class SCoverWithLogo extends StatelessWidget {
  const SCoverWithLogo({required this.cover, required this.logo, super.key});

  final Widget cover;
  final Widget logo;

  @override
  Widget build(BuildContext context) {
    final position = Scrollable.maybeOf(context)?.position;
    return Stack(
      children: [
        // Room under the cover for the logo's lower half, so all of it can
        // be tapped.
        Padding(
          padding: EdgeInsets.only(bottom: SImageSize.logo.pixels / 2),
          child: position == null
              ? cover
              : ListenableBuilder(
                  listenable: position,
                  builder: (context, cover) => _Stretched(
                    pull: position.hasContentDimensions && position.hasPixels
                        ? math.max(
                            0.0,
                            position.minScrollExtent - position.pixels,
                          )
                        : 0.0,
                    child: cover,
                  ),
                  child: cover,
                ),
        ),
        PositionedDirectional(start: Space.lg, bottom: 0, child: logo),
      ],
    );
  }
}

/// Lays its child out [pull] taller and as far up, while keeping only its
/// usual room in the page: a photo that fills its box grows into the gap.
class _Stretched extends SingleChildRenderObjectWidget {
  const _Stretched({required this.pull, required super.child});

  final double pull;

  @override
  _RenderStretched createRenderObject(BuildContext context) =>
      _RenderStretched(pull);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderStretched renderObject,
  ) => renderObject.pull = pull;
}

class _RenderStretched extends RenderProxyBox {
  _RenderStretched(this._pull);

  double _pull;
  set pull(double value) {
    if (value == _pull) return;
    _pull = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(constraints, parentUsesSize: true);
    final usual = child.size;
    if (_pull > 0) {
      child.layout(
        BoxConstraints.tightFor(
          width: usual.width,
          height: usual.height + _pull,
        ),
        parentUsesSize: true,
      );
    }
    size = usual;
  }

  Offset get _childOffset => Offset(0, -_pull);

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    if (child != null) context.paintChild(child, offset + _childOffset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final child = this.child;
    if (child == null) return false;
    return result.addWithPaintOffset(
      offset: _childOffset,
      position: position,
      hitTest: (result, transformed) =>
          child.hitTest(result, position: transformed),
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) =>
      transform.translateByDouble(_childOffset.dx, _childOffset.dy, 0, 1);
}
