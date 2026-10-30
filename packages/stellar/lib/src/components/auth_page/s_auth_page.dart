import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../illustration/s_illustration.dart';
import '../illustration/s_illustration_renderer.dart';
import '../scaffold/s_scaffold.dart';
import '../text/s_text.dart';

/// On the dashboard the form is a narrow column in a wide window.
const _dashboardWidth = 400.0;

/// On the dashboard the page starts this share of the window's height
/// down.
const _topShare = 0.22;
const _barHeight = 56.0;

/// On phones the form sits above the middle of the screen, where the eye
/// expects it (the optical center), as in the big apps: this share of the
/// screen's height is left free under it.
const _phoneLift = 0.2;

const _heroCorner = 32.0;

/// The layout of the sign-in pages: a centered title and hint, then the
/// form. Phones use the screen's full width, a little above the middle,
/// with a big title; the dashboard a narrow column, as ERPNext's.
///
/// With a [hero], phones open on the brand instead: a cream band from the
/// top of the screen with the app's mark and [actions], over one of the
/// brand's pictures, then the title and the form, and [footer] at the
/// bottom of the screen.
class SAuthPage extends StatelessWidget {
  const SAuthPage({
    required this.title,
    required this.subtitle,
    required this.child,
    this.actions = const [],
    this.footer = const [],
    this.hero,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;

  /// Small actions at the top of the page (switching the language).
  final List<Widget> actions;

  /// Small actions under the form (log out).
  final List<Widget> footer;

  /// The brand above the form, on phones. The dashboard doesn't show it.
  final SAuthHero? hero;

  @override
  Widget build(BuildContext context) {
    final phone = context.style == StellarStyle.app;
    if (phone && hero != null) return _withHero(context, hero!);
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (phone)
          SText.display(title, align: TextAlign.center)
        else
          SText.title(title, align: TextAlign.center),
        const Gap(Space.sm),
        SText(subtitle, color: SColor.textMuted, align: TextAlign.center),
        Gap(phone ? Space.xxl : Space.xl),
        child,
        if (footer.isNotEmpty) ...[
          const Gap(Space.lg),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: footer),
        ],
      ],
    );
    return SScaffold(
      showAppBar: actions.isNotEmpty,
      actions: actions,
      maxWidth: phone ? null : _dashboardWidth,
      // Phones center the form a little above the middle (it scrolls when
      // the keyboard needs the room). The dashboard keeps it a fixed
      // distance from the top, so an error message showing up doesn't move
      // the fields under the cursor.
      centered: phone,
      body: phone
          ? Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.sizeOf(context).height * _phoneLift,
              ),
              child: content,
            )
          : SingleChildScrollView(
              padding: EdgeInsets.only(
                top: _dashboardTop(context),
                bottom: Space.xl,
              ),
              child: content,
            ),
    );
  }

  Widget _withHero(BuildContext context, SAuthHero hero) => SScaffold(
    showAppBar: false,
    padded: false,
    underStatusBar: true,
    body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _HeroBand(hero: hero, actions: actions),
        ),
        // The form is well clear of the band, so it doesn't look pressed
        // against the picture. Room left over on tall phones goes above and
        // below it, so it sits lower, and [footer] at the bottom of the
        // screen. Small phones and an open keyboard scroll instead.
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(Space.xxl),
                const Spacer(),
                SText.display(title, align: TextAlign.center),
                const Gap(Space.sm),
                SText(
                  subtitle,
                  color: SColor.textMuted,
                  align: TextAlign.center,
                ),
                const Gap(Space.xl),
                child,
                const Gap(Space.lg),
                const Spacer(),
                if (footer.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Space.lg,
                      Space.lg,
                      Space.lg,
                      Space.xl,
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: footer,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  /// Measured from the top of the window, so the actions' bar doesn't push
  /// the page down.
  double _dashboardTop(BuildContext context) {
    final above =
        MediaQuery.paddingOf(context).top + (actions.isEmpty ? 0 : _barHeight);
    final top = MediaQuery.sizeOf(context).height * _topShare - above;
    return math.max(Space.xl, top);
  }
}

/// What a sign-in page's hero shows ([SAuthPage.hero]).
@immutable
class SAuthHero {
  const SAuthHero({required this.mark, required this.illustration});

  /// The app's logo and name, at the top ([SIllustrations.partnerMark]).
  final SIllustrations mark;
  final SIllustrations illustration;
}

class _HeroBand extends StatelessWidget {
  const _HeroBand({required this.hero, required this.actions});

  final SAuthHero hero;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.colors.cream,
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(_heroCorner),
      ),
    ),
    child: Padding(
      // The band starts behind the status bar; its content under it.
      padding: EdgeInsets.fromLTRB(
        Space.lg,
        MediaQuery.paddingOf(context).top + Space.sm,
        Space.lg,
        Space.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [SIllustration(hero.mark), const Spacer(), ...actions],
          ),
          SIllustration(hero.illustration),
        ],
      ),
    ),
  );
}
