import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../text/s_text.dart';
import 's_skeleton.dart';

/// How long the light takes to sweep across once.
const _sweep = Duration(milliseconds: 1400);

/// [SSkeleton]: each [SBone] paints the light itself, placed by where it
/// sits in the skeleton, so the light sweeps across them all as one and
/// what isn't a bone (a card's outline) keeps its own colors.
class SSkeletonMaterial extends StatefulWidget implements SSkeleton {
  const SSkeletonMaterial({required this.child, super.key});

  final Widget child;

  @override
  State<SSkeletonMaterial> createState() => _SSkeletonMaterialState();
}

class _SSkeletonMaterialState extends State<SSkeletonMaterial>
    with SingleTickerProviderStateMixin {
  late final _sweeping = AnimationController(vsync: this, duration: _sweep);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Still, for people who turned motion off; and inside another
    // skeleton, whose light covers this one.
    if (_moving) {
      if (!_sweeping.isAnimating) _sweeping.repeat();
    } else {
      _sweeping.stop();
    }
  }

  bool get _moving =>
      !MediaQuery.disableAnimationsOf(context) && _Light.of(context) == null;

  @override
  void dispose() {
    _sweeping.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_Light.of(context) != null) return widget.child;
    final c = context.colors;
    return Semantics(
      container: true,
      label: StellarLocalizations.of(context).loading,
      child: ExcludeSemantics(
        child: _CutToFit(
          child: RepaintBoundary(
            child: _Light(
              sweep: _sweeping,
              moving: _moving,
              bone: c.bone,
              shine: c.boneShine,
              rtl: Directionality.of(context) == TextDirection.rtl,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

/// The light over a skeleton, for its bones to paint.
class _Light extends InheritedWidget {
  const _Light({
    required this.sweep,
    required this.moving,
    required this.bone,
    required this.shine,
    required this.rtl,
    required super.child,
  });

  final Animation<double> sweep;
  final bool moving;
  final Color bone;
  final Color shine;
  final bool rtl;

  static _Light? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Light>();

  /// The light where the sweep is now, across [region] (the skeleton, in
  /// the canvas's coordinates).
  Shader shader(Rect region) {
    final across = (sweep.value * 2 - 1) * region.width;
    return LinearGradient(
      colors: [bone, shine, bone],
      stops: const [0.35, 0.5, 0.65],
    ).createShader(region.shift(Offset(rtl ? -across : across, 0)));
  }

  @override
  bool updateShouldNotify(_Light old) =>
      old.sweep != sweep ||
      old.moving != moving ||
      old.bone != bone ||
      old.shine != shine ||
      old.rtl != rtl;
}

/// Lets its child be as tall as it likes, and cuts it at the bottom of
/// the room when the room is shorter. A render box rather than a
/// `LayoutBuilder`, so it can be measured (in a `SliverFillRemaining`).
/// Its box is the skeleton's: what the bones place the light by.
class _CutToFit extends SingleChildRenderObjectWidget {
  const _CutToFit({required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderCutToFit();
}

class _RenderCutToFit extends RenderProxyBox {
  final _clip = LayerHandle<ClipRectLayer>();
  var _cut = false;

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(
      constraints.copyWith(minHeight: 0, maxHeight: double.infinity),
      parentUsesSize: true,
    );
    size = constraints.constrain(child.size);
    _cut = child.size.height > size.height;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final child = this.child;
    if (child == null) return constraints.smallest;
    return constraints.constrain(
      child.getDryLayout(
        constraints.copyWith(minHeight: 0, maxHeight: double.infinity),
      ),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_cut) {
      _clip.layer = null;
      super.paint(context, offset);
      return;
    }
    _clip.layer = context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      super.paint,
      oldLayer: _clip.layer,
    );
  }

  @override
  void dispose() {
    _clip.layer = null;
    super.dispose();
  }
}

/// A bone's gray shape, filling the room it's given, with the light of
/// the skeleton it's in on it.
class _BoneFill extends LeafRenderObjectWidget {
  const _BoneFill({required this.radius, required this.color, this.light});

  final double radius;
  final Color color;
  final _Light? light;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderBoneFill(radius: radius, color: color, light: light);

  @override
  void updateRenderObject(BuildContext context, _RenderBoneFill bone) => bone
    ..radius = radius
    ..color = color
    ..light = light;
}

class _RenderBoneFill extends RenderBox {
  _RenderBoneFill({
    required this._radius,
    required this._color,
    required this._light,
  });

  double _radius;
  set radius(double value) {
    if (value == _radius) return;
    _radius = value;
    markNeedsPaint();
  }

  Color _color;
  set color(Color value) {
    if (value == _color) return;
    _color = value;
    markNeedsPaint();
  }

  _Light? _light;
  set light(_Light? value) {
    if (value?.sweep != _light?.sweep && attached) {
      _light?.sweep.removeListener(markNeedsPaint);
      value?.sweep.addListener(markNeedsPaint);
    }
    _light = value;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _light?.sweep.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _light?.sweep.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) => Size(
    constraints.hasBoundedWidth ? constraints.maxWidth : constraints.minWidth,
    constraints.hasBoundedHeight
        ? constraints.maxHeight
        : constraints.minHeight,
  );

  @override
  void paint(PaintingContext context, Offset offset) {
    final paint = Paint()..color = _color;
    final light = _light;
    final region = _region();
    if (light != null && light.moving && region != null && region.hasSize) {
      final at = localToGlobal(Offset.zero, ancestor: region);
      paint.shader = light.shader((offset - at) & region.size);
    }
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(offset & size, Radius.circular(_radius)),
      paint,
    );
  }

  /// The skeleton this bone is in.
  RenderBox? _region() {
    for (var node = parent; node != null; node = node.parent) {
      if (node is _RenderCutToFit) return node;
    }
    return null;
  }
}

enum _BoneShape { text, image, wide, button, badge }

/// [SBone]: its size from the usual boxes, its paint a [_BoneFill].
class SBoneMaterial extends StatelessWidget implements SBone {
  const SBoneMaterial.text({
    this.variant = TextVariant.body,
    this.length = BoneLength.full,
    super.key,
  }) : _shape = _BoneShape.text,
       size = SImageSize.thumb,
       ratio = SImageRatio.banner;

  const SBoneMaterial.image({this.size = SImageSize.thumb, super.key})
    : _shape = _BoneShape.image,
      variant = TextVariant.body,
      length = BoneLength.full,
      ratio = SImageRatio.banner;

  const SBoneMaterial.wide({this.ratio = SImageRatio.banner, super.key})
    : _shape = _BoneShape.wide,
      variant = TextVariant.body,
      length = BoneLength.full,
      size = SImageSize.thumb;

  const SBoneMaterial.button({super.key})
    : _shape = _BoneShape.button,
      variant = TextVariant.body,
      length = BoneLength.full,
      size = SImageSize.thumb,
      ratio = SImageRatio.banner;

  const SBoneMaterial.badge({super.key})
    : _shape = _BoneShape.badge,
      variant = TextVariant.body,
      length = BoneLength.full,
      size = SImageSize.thumb,
      ratio = SImageRatio.banner;

  /// The share of a line's height its bone fills, like the letters do.
  static const _textFill = 0.6;

  /// A badge's size: a short word in a pill.
  static const _badgeWidth = 56.0;
  static const _badgeHeight = 22.0;

  final _BoneShape _shape;
  final TextVariant variant;
  final BoneLength length;
  final SImageSize size;
  final SImageRatio ratio;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.bone;
    final light = _Light.of(context);
    Widget bone(double radius) =>
        _BoneFill(radius: radius, color: color, light: light);
    return switch (_shape) {
      _BoneShape.text => _line(context, bone(Radii.sm)),
      _BoneShape.image => SizedBox.square(
        dimension: size.pixels,
        child: bone(size.radius),
      ),
      _BoneShape.wide => AspectRatio(
        aspectRatio: ratio.value,
        child: bone(Radii.lg),
      ),
      _BoneShape.button => SizedBox(
        height: context.style.controlHeight,
        width: double.infinity,
        child: bone(Radii.pill),
      ),
      _BoneShape.badge => SizedBox(
        width: _badgeWidth,
        height: _badgeHeight,
        child: bone(Radii.pill),
      ),
    };
  }

  /// A line as tall as [variant]'s text, the bone in its middle.
  Widget _line(BuildContext context, Widget bone) {
    final theme = Theme.of(context).textTheme;
    final style = switch (variant) {
      TextVariant.display => theme.headlineMedium,
      TextVariant.title => theme.titleLarge,
      TextVariant.subtitle => theme.titleMedium,
      TextVariant.body => theme.bodyLarge,
      TextVariant.caption => theme.bodySmall,
      TextVariant.label => theme.labelLarge,
    };
    return FractionallySizedBox(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: length.share,
      child: Stack(
        children: [
          // Gives the line its height; never seen.
          Text('\u00A0', style: style?.copyWith(color: Colors.transparent)),
          Positioned.fill(
            child: Center(
              child: FractionallySizedBox(heightFactor: _textFill, child: bone),
            ),
          ),
        ],
      ),
    );
  }
}

/// [SSkeleton.list]: rows laid out like [ListTile]s, lines between them.
class SSkeletonListMaterial extends StatelessWidget implements SSkeleton {
  const SSkeletonListMaterial({this.rows = 8, this.leading = true, super.key});

  final int rows;
  final bool leading;

  /// The words' lengths, row by row, so the rows don't look stamped out.
  static const _lengths = [
    (BoneLength.long, BoneLength.medium),
    (BoneLength.medium, BoneLength.short),
    (BoneLength.long, BoneLength.short),
    (BoneLength.medium, BoneLength.medium),
  ];

  @override
  Widget build(BuildContext context) => SSkeletonMaterial(
    child: Column(
      children: [
        for (var i = 0; i < rows; i++) ...[
          if (i > 0) const Divider(indent: Space.lg, endIndent: Space.lg),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Space.lg,
              vertical: Space.md,
            ),
            child: Row(
              spacing: Space.lg,
              children: [
                if (leading) const SBoneMaterial.image(size: SImageSize.thumb),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: Space.xxs,
                    children: [
                      SBoneMaterial.text(
                        length: _lengths[i % _lengths.length].$1,
                      ),
                      SBoneMaterial.text(
                        variant: TextVariant.caption,
                        length: _lengths[i % _lengths.length].$2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    ),
  );
}

/// [SSkeleton.page]: a photo, a title, lines about it and a button,
/// within the page's sides (the scaffold's padding).
class SSkeletonPageMaterial extends StatelessWidget implements SSkeleton {
  const SSkeletonPageMaterial({super.key});

  @override
  Widget build(BuildContext context) => const SSkeletonMaterial(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.sm,
      children: [
        SBoneMaterial.image(size: SImageSize.large),
        Gap(Space.sm),
        SBoneMaterial.text(variant: TextVariant.title, length: BoneLength.long),
        SBoneMaterial.text(),
        SBoneMaterial.text(length: BoneLength.long),
        Gap(Space.lg),
        SBoneMaterial.text(
          variant: TextVariant.subtitle,
          length: BoneLength.medium,
        ),
        SBoneMaterial.text(),
        SBoneMaterial.text(length: BoneLength.long),
        SBoneMaterial.text(length: BoneLength.medium),
        Gap(Space.lg),
        SBoneMaterial.button(),
      ],
    ),
  );
}

/// [SSkeleton.groups]: each group a [Card] like an `SListGroup`'s, its
/// rows a name and a value, divided by thin lines.
class SSkeletonGroupsMaterial extends StatelessWidget implements SSkeleton {
  const SSkeletonGroupsMaterial({this.groups = 2, this.rows = 3, super.key});

  final int groups;
  final int rows;

  @override
  Widget build(BuildContext context) => SSkeletonMaterial(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.xl,
      children: [
        for (var g = 0; g < groups; g++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: Space.sm,
            children: [
              const Padding(
                padding: EdgeInsetsDirectional.only(start: Space.xs),
                child: SBoneMaterial.text(
                  variant: TextVariant.caption,
                  length: BoneLength.short,
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    for (var r = 0; r < rows; r++) ...[
                      if (r > 0) const Divider(indent: Space.lg),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Space.lg,
                          vertical: Space.md,
                        ),
                        child: Row(
                          spacing: Space.lg,
                          children: [
                            Expanded(
                              flex: 3,
                              child: SBoneMaterial.text(
                                length: r.isEven
                                    ? BoneLength.long
                                    : BoneLength.medium,
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: SBoneMaterial.text(
                                length: BoneLength.medium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
