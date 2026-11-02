import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import 's_welcome_renderer.dart';

/// The two shapes in the top corners, as in the design: a big green one
/// on the end side and a smaller orange one on the start side, both
/// running off the screen.
const _greenBlob = Size(260, 230);
const _greenOffset = Offset(-110, -90);
const _orangeBlob = Size(190, 150);
const _orangeOffset = Offset(-80, -60);

const _dotSize = 8.0;
const _activeDotWidth = 24.0;
const _dotsDuration = Duration(milliseconds: 200);

/// What a page says: centered, padded at the sides, and scrolling when
/// it doesn't fit (a small phone, large text).
class _Body extends StatelessWidget {
  const _Body({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Space.xl),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Center(child: child),
      ),
    ),
  );
}

class MaterialWelcomeRenderer implements WelcomeRenderer {
  const MaterialWelcomeRenderer();

  @override
  Widget page(BuildContext context, WelcomePageSpec spec) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.cream,
      body: Stack(
        children: [
          PositionedDirectional(
            top: _greenOffset.dy,
            end: _greenOffset.dx,
            child: _Blob(size: _greenBlob, color: c.primary),
          ),
          PositionedDirectional(
            top: _orangeOffset.dy,
            start: _orangeOffset.dx,
            child: _Blob(size: _orangeBlob, color: c.accent),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (spec.top.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.sm),
                    child: Row(children: spec.top),
                  ),
                Expanded(
                  child: spec.child == null
                      ? PageView(
                          controller: spec.controller,
                          onPageChanged: spec.onPageChanged,
                          children: [
                            for (final page in spec.pages) _Body(child: page),
                          ],
                        )
                      : _Body(child: spec.child!),
                ),
                if (spec.actions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Space.lg,
                      Space.md,
                      Space.lg,
                      Space.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: Space.sm,
                      children: spec.actions,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget dots(BuildContext context, PageDotsSpec spec) {
    final c = context.colors;
    return Semantics(
      label: '${spec.index + 1} / ${spec.count}',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: Space.xs,
        children: [
          for (var i = 0; i < spec.count; i++)
            AnimatedContainer(
              duration: _dotsDuration,
              width: i == spec.index ? _activeDotWidth : _dotSize,
              height: _dotSize,
              decoration: BoxDecoration(
                color: i == spec.index ? c.primary : c.border,
                borderRadius: BorderRadius.circular(Radii.pill),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget brand(BuildContext context, BrandSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          spec.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: text.hero,
            fontWeight: SFontWeight.bold.value,
            color: c.primary,
            height: 1.2,
          ),
        ),
        const Gap(Space.sm),
        DecoratedBox(
          decoration: BoxDecoration(
            color: c.accent,
            borderRadius: BorderRadius.circular(Radii.pill),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Space.lg,
              vertical: Space.xs,
            ),
            child: Text(
              spec.tagline,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: text.subtitle,
                fontWeight: SFontWeight.bold.value,
                color: c.onAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A soft oval in one of the brand's colors.
class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});

  final Size size;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
    size: size,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.elliptical(size.width / 2, size.height / 2),
        ),
      ),
    ),
  );
}
