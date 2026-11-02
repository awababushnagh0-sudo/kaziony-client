import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_welcome.dart';

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

/// [SWelcomePage], on a Material [Scaffold] in the brand's cream.
class SWelcomePageMaterial extends StatelessWidget implements SWelcomePage {
  const SWelcomePageMaterial({
    required Widget this.child,
    this.actions = const [],
    this.top = const [],
    super.key,
  }) : pages = const [],
       controller = null,
       onPageChanged = null;

  const SWelcomePageMaterial.swipe({
    required this.pages,
    this.controller,
    this.onPageChanged,
    this.actions = const [],
    this.top = const [],
    super.key,
  }) : child = null;

  /// Null on a page that swipes through [pages].
  final Widget? child;
  final List<Widget> pages;
  final PageController? controller;
  final ValueChanged<int>? onPageChanged;
  final List<Widget> actions;
  final List<Widget> top;

  @override
  Widget build(BuildContext context) {
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
                if (top.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.sm),
                    child: Row(children: top),
                  ),
                Expanded(
                  child: child == null
                      ? PageView(
                          controller: controller,
                          onPageChanged: onPageChanged,
                          children: [
                            for (final page in pages) _Body(child: page),
                          ],
                        )
                      : _Body(child: child!),
                ),
                if (actions.isNotEmpty)
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
                      children: actions,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// [SPageDots]: the showing page's dot is a short bar, the others dots.
class SPageDotsMaterial extends StatelessWidget implements SPageDots {
  const SPageDotsMaterial({
    required this.count,
    required this.index,
    super.key,
  });

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: '${index + 1} / $count',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: Space.xs,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: _dotsDuration,
              width: i == index ? _activeDotWidth : _dotSize,
              height: _dotSize,
              decoration: BoxDecoration(
                color: i == index ? c.primary : c.border,
                borderRadius: BorderRadius.circular(Radii.pill),
              ),
            ),
        ],
      ),
    );
  }
}

/// [SBrandTitle]: the name as text, the tagline on a pill.
class SBrandTitleMaterial extends StatelessWidget implements SBrandTitle {
  const SBrandTitleMaterial({
    required this.name,
    required this.tagline,
    super.key,
  });

  final String name;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
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
              tagline,
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
