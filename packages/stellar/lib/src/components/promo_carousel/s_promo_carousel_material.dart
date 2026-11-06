import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../illustration/s_illustration_material.dart';
import 's_promo_carousel.dart';

/// [SPromoCarousel], drawn as a [PageView] with dots under it.
class SPromoCarouselMaterial extends StatefulWidget implements SPromoCarousel {
  const SPromoCarouselMaterial({required this.banners, super.key});

  final List<PromoBanner> banners;

  @override
  State<SPromoCarouselMaterial> createState() => _SPromoCarouselState();
}

class _SPromoCarouselState extends State<SPromoCarouselMaterial> {
  /// A banner's height at the normal text size: two lines of title and two
  /// of message.
  static const _height = 128.0;

  /// Long enough to read a banner.
  static const _interval = Duration(seconds: 6);
  static const _slide = Duration(milliseconds: 450);

  /// Far from the first page, so it swipes back as well as forward.
  static const _laps = 1000;

  late final PageController _controller;
  Timer? _timer;
  int _shown = 0;

  int get _count => widget.banners.length;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _count * _laps);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _restart();
  }

  @override
  void didUpdateWidget(SPromoCarouselMaterial old) {
    super.didUpdateWidget(old);
    if (old.banners.length != _count) _restart();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Waits a whole interval after any move, the person's or its own.
  void _restart() {
    _timer?.cancel();
    if (_count < 2 || MediaQuery.disableAnimationsOf(context)) return;
    _timer = Timer(_interval, _next);
  }

  void _next() {
    // Not while another tab or page covers it.
    if (!mounted ||
        !_controller.hasClients ||
        !TickerMode.valuesOf(context).enabled) {
      _restart();
      return;
    }
    _controller.nextPage(duration: _slide, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    if (banners.isEmpty) return const SizedBox.shrink();
    final pages = SizedBox(
      height: MediaQuery.textScalerOf(context).scale(_height),
      child: PageView.builder(
        controller: _controller,
        itemCount: _count < 2 ? 1 : null,
        onPageChanged: (page) {
          setState(() => _shown = page % _count);
          _restart();
        },
        itemBuilder: (context, page) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.lg),
          child: _Banner(banners[page % _count]),
        ),
      ),
    );
    if (_count < 2) return pages;
    return Column(
      spacing: Space.sm,
      children: [
        pages,
        _Dots(count: _count, shown: _shown),
      ],
    );
  }
}

/// One banner: the words at the start, the picture at the end.
class _Banner extends StatelessWidget {
  const _Banner(this.banner);

  final PromoBanner banner;

  /// The picture's room at the end.
  static const _pictureSize = 104.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: switch (banner.tone) {
          PromoTone.cream => c.cream,
          PromoTone.green => c.primaryTint,
          PromoTone.orange => c.accentSoft,
        },
        borderRadius: BorderRadius.circular(Radii.xxl),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: Space.lg,
          end: Space.sm,
        ),
        child: Row(
          spacing: Space.sm,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Space.xs,
                children: [
                  Text(
                    banner.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: text.subtitle,
                      fontWeight: SFontWeight.bold.value,
                      height: 1.3,
                      color: c.text,
                    ),
                  ),
                  Text(
                    banner.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: text.tiny,
                      height: 1.5,
                      color: c.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox.square(
              dimension: _pictureSize,
              child: SIllustrationMaterial(banner.illustration),
            ),
          ],
        ),
      ),
    );
  }
}

/// A dot for each banner, the one showing drawn long in the brand's green.
class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.shown});

  final int count;
  final int shown;

  static const _dot = 6.0;
  static const _long = 18.0;
  static const _move = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ExcludeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: Space.xs,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: _move,
              width: i == shown ? _long : _dot,
              height: _dot,
              decoration: BoxDecoration(
                color: i == shown ? c.primary : c.border,
                borderRadius: BorderRadius.circular(Radii.pill),
              ),
            ),
        ],
      ),
    );
  }
}
