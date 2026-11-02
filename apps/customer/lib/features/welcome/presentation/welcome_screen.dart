import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/customer_illustrations.dart';

const _pageCount = 3;
const _turnDuration = Duration(milliseconds: 300);

/// The first time the app opens: who we are, why, and how it works, as
/// pages to swipe; then where to show offers from, and signing in.
class WelcomeScreen extends AppStatefulView {
  const WelcomeScreen({super.key});

  @override
  AppViewState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends AppViewState<WelcomeScreen> {
  final _pages = PageController();
  var _index = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _next() {
    if (_index == _pageCount - 1) {
      context.go(Routes.welcomeLocation);
      return;
    }
    _pages.nextPage(duration: _turnDuration, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final last = _index == _pageCount - 1;
    return SWelcomePage.swipe(
      controller: _pages,
      onPageChanged: (index) => setState(() => _index = index),
      pages: const [_HelloPage(), _WhyPage(), _HowPage()],
      top: [
        const SLanguageButton(),
        const Spacer(),
        if (!last)
          SButton.text(
            label: s.skip,
            onPressed: () => context.go(Routes.welcomeLocation),
          ),
      ],
      actions: [
        Center(
          child: SPageDots(count: _pageCount, index: _index),
        ),
        const Gap(Space.sm),
        SButton(
          label: last ? s.getStarted : s.next,
          expand: true,
          onPressed: _next,
        ),
      ],
    );
  }
}

/// The logo, the name and the tagline.
class _HelloPage extends StatelessWidget {
  const _HelloPage();

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SIllustration(CustomerIllustrations.logo),
        const Gap(Space.xl),
        SBrandTitle(name: s.appTitle, tagline: s.tagline),
        const Gap(Space.xl),
        SText(s.helloMessage, color: SColor.textMuted, align: TextAlign.center),
      ],
    );
  }
}

/// What a customer gets out of it.
class _WhyPage extends StatelessWidget {
  const _WhyPage();

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    return _PointsPage(
      title: s.whyTitle,
      points: [
        (SIcons.leaf, s.whyLessWaste),
        (SIcons.wallet, s.whySaveMoney),
        (SIcons.store, s.whyLocalStores),
      ],
    );
  }
}

/// Booking, picking up, paying.
class _HowPage extends StatelessWidget {
  const _HowPage();

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    return _PointsPage(
      title: s.howTitle,
      points: [
        (SIcons.bookings, s.howBook),
        (SIcons.store, s.howPickUp),
        (SIcons.cash, s.howPay),
      ],
    );
  }
}

/// A title over three points, each an icon and a line.
class _PointsPage extends StatelessWidget {
  const _PointsPage({required this.title, required this.points});

  final String title;
  final List<(SIcons, String)> points;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SText.display(title, align: TextAlign.center),
      const Gap(Space.xxl),
      for (final (icon, text) in points) ...[
        Row(
          spacing: Space.lg,
          children: [
            SIcon(icon, size: SIconSize.xl, color: SColor.primary),
            Expanded(
              child: SText(
                text,
                variant: TextVariant.subtitle,
                weight: SFontWeight.semibold,
              ),
            ),
          ],
        ),
        const Gap(Space.xl),
      ],
    ],
  );
}
