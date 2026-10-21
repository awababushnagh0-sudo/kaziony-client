import 'dart:math' as math;

import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

/// The narrow, centered layout of the sign-in pages.
class AuthPage extends StatelessWidget {
  const AuthPage({
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer = const [],
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;

  /// Small actions under the form (log out).
  final List<Widget> footer;

  @override
  Widget build(BuildContext context) => AppScaffold(
    showAppBar: false,
    maxWidth: 400,
    // A fixed distance from the top rather than centered, so an error
    // message showing up doesn't move the fields under the cursor.
    body: SingleChildScrollView(
      padding: EdgeInsets.only(
        top: math.max(Space.xl, MediaQuery.sizeOf(context).height * 0.22),
        bottom: Space.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.title(title, align: TextAlign.center),
          const Gap(Space.xs),
          AppText(subtitle, tone: TextTone.muted, align: TextAlign.center),
          const Gap(Space.xl),
          child,
          if (footer.isNotEmpty) ...[
            const Gap(Space.lg),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: footer),
          ],
        ],
      ),
    ),
  );
}
