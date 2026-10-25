import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
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

/// The layout of the sign-in pages: a centered title and hint, then the
/// form. Phones use the screen's full width, a little above the middle,
/// with a big title; the dashboard a narrow column, as ERPNext's.
class SAuthPage extends StatelessWidget {
  const SAuthPage({
    required this.title,
    required this.subtitle,
    required this.child,
    this.actions = const [],
    this.footer = const [],
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;

  /// Small actions at the top of the page (switching the language).
  final List<Widget> actions;

  /// Small actions under the form (log out).
  final List<Widget> footer;

  @override
  Widget build(BuildContext context) {
    final phone = context.style == StellarStyle.app;
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

  /// Measured from the top of the window, so the actions' bar doesn't push
  /// the page down.
  double _dashboardTop(BuildContext context) {
    final above =
        MediaQuery.paddingOf(context).top + (actions.isEmpty ? 0 : _barHeight);
    final top = MediaQuery.sizeOf(context).height * _topShare - above;
    return math.max(Space.xl, top);
  }
}
