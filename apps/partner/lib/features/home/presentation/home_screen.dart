import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/providers/clock.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/offer_tile.dart';
import '../../../core/widgets/reservation_row.dart';
import '../../counter/domain/claim.dart';
import '../../store/domain/current_store.dart';
import '../domain/store_stats.dart';
import 'home_view_model.dart';

/// The day at a glance: today's numbers, the next customers to come and how
/// the live offers sell. Staff see their branch's day, without the numbers
/// only owners act on (no-shows, offers, the month).
class HomeScreen extends AppView {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeViewModel);
    Future<void> refresh() async {
      final failure = await ref.read(homeViewModel.notifier).refresh();
      if (failure != null && context.mounted) {
        SSnack.error(context, failureMessage(context, failure));
      }
    }

    return SScaffold(
      title: PartnerLocalizations.of(context).homeTitle,
      padded: false,
      // Only the loaded page scrolls: loading and errors stay centered.
      scrollable: home.hasValue,
      onRefresh: home.hasValue ? refresh : null,
      body: SAsyncView(
        value: home,
        onRetry: () => ref.invalidate(homeViewModel),
        builder: (context, home) => _HomeBody(home),
      ),
    );
  }
}

class _HomeBody extends AppView {
  const _HomeBody(this.home);

  final Home home;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final store = ref.watch(currentStoreProvider);
    final isOwner = store?.isOwner ?? false;
    final now = ref.watch(minuteClockProvider).value ?? DateTime.now();
    final onTheWay = home.onTheWayAt(now);
    final offers = home.liveOffers.take(Home.shown);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: Space.md,
            children: [
              SSectionHeader(
                store?.branchId == null ? s.todayTitle : s.todayAtBranch,
                note: formatDay(
                  now,
                  languageCode: Localizations.localeOf(context).languageCode,
                ),
              ),
              _TodayStats(
                home: home,
                soonest: onTheWay.firstOrNull,
                now: now,
                isOwner: isOwner,
              ),
            ],
          ),
        ),
        _Header(
          s.pickupsTitle,
          actionLabel: s.seeAll,
          onAction: () => context.push(Routes.pickups),
        ),
        if (onTheWay.isEmpty)
          _Nothing(s.nobodyOnTheWay)
        else
          for (final claim in onTheWay) ReservationRow(claim, now: now),
        const Gap(Space.lg),
        _Header(
          isOwner ? s.yourLiveOffers : s.liveOffersTitle,
          actionLabel: s.seeAllOffers,
          onAction: () => context.go(Routes.offers),
        ),
        if (offers.isEmpty)
          _Nothing(s.noLiveOffers)
        else
          for (final offer in offers)
            OfferTile(
              offer: offer,
              onTap: () => context.push(Routes.offer(offer.id)),
            ),
        if (isOwner) ...[
          const Gap(Space.lg),
          SListTile(
            icon: SIcons.chart,
            title: s.last30Days,
            subtitle: _month(s, home.stats.last30Days),
          ),
        ],
        const Gap(Space.xl),
      ],
    );
  }

  static String _month(PartnerLocalizations s, PeriodStats month) {
    final rate = month.redemptionRate;
    return [
      s.pickupsCount(month.redeemed),
      if (rate != null) s.pickupRate((rate * 100).round()),
    ].join(' · ');
  }
}

class _TodayStats extends StatelessWidget {
  const _TodayStats({
    required this.home,
    required this.soonest,
    required this.now,
    required this.isOwner,
  });

  final Home home;

  /// The next customer due, if any.
  final Claim? soonest;
  final DateTime now;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final stats = home.stats;
    final today = stats.today;
    final soonest = this.soonest;
    final runningOut = home.runningOut;
    return SStatGrid(
      children: [
        SStatTile(
          label: s.pickupsTitle,
          value: '${stats.onTheWay}',
          illustration: SIllustrations.onTheWay,
          hint: soonest == null
              ? null
              : s.soonestIn(
                  timeLeftLabel(s, soonest.expiresAt.difference(now)),
                ),
          urgent: soonest?.isDueSoonAt(now) ?? false,
          onTap: () => context.push(Routes.pickups),
        ),
        SStatTile(
          label: s.statPickedUp,
          value: '${today.redeemed}',
          illustration: SIllustrations.pickedUp,
          hint: today.claims == 0 ? null : s.ofClaimsToday(today.claims),
        ),
        if (isOwner) ...[
          SStatTile(
            label: s.statNotPickedUp,
            value: '${today.expired}',
            illustration: SIllustrations.notPickedUp,
            hint: today.expired == 0 ? null : s.notPickedUpHint,
          ),
          SStatTile(
            label: s.statLiveOffers,
            value: '${stats.liveOffers}',
            illustration: SIllustrations.liveOffers,
            hint: runningOut == 0 ? null : s.almostGone(runningOut),
            onTap: () => context.go(Routes.offers),
          ),
        ],
      ],
    );
  }
}

/// A section's title, at the page's sides.
class _Header extends StatelessWidget {
  const _Header(
    this.title, {
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: Space.lg),
    child: SSectionHeader(title, actionLabel: actionLabel, onAction: onAction),
  );
}

/// What an empty section says instead of rows.
class _Nothing extends StatelessWidget {
  const _Nothing(this.message);

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: Space.lg,
      vertical: Space.md,
    ),
    child: SText.caption(message),
  );
}
