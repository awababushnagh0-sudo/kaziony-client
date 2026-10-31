import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/providers/clock.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/offer_tile.dart';
import '../../../core/widgets/partner_illustrations.dart';
import '../../../core/widgets/reservation_row.dart';
import '../../counter/domain/claim.dart';
import '../../store/domain/current_store.dart';
import 'home_view_model.dart';

/// The day at a glance: today's numbers, the next customers to come and how
/// the live offers sell. Staff see their branch's day, without the numbers
/// only owners act on (no-shows, offers).
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
          child: _TodayStats(
            home: home,
            soonest: onTheWay.firstOrNull,
            now: now,
            isOwner: isOwner,
            title: store?.branchId == null ? s.todayTitle : s.todayAtBranch,
          ),
        ),
        // Both lists empty: one picture for the page, not two empty lists.
        if (onTheWay.isEmpty && offers.isEmpty)
          SEmptyView(
            illustration: PartnerIllustrations.noOffers,
            title: s.quietDayTitle,
            message: isOwner ? s.quietDayOwnerMessage : s.quietDayStaffMessage,
            actionLabel: isOwner ? s.postOffer : null,
            actionIcon: SIcons.add,
            onAction: () => context.push(Routes.chooseOfferProduct),
          )
        else ...[
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
        ],
        const Gap(Space.xl),
      ],
    );
  }
}

class _TodayStats extends StatelessWidget {
  const _TodayStats({
    required this.home,
    required this.soonest,
    required this.now,
    required this.isOwner,
    required this.title,
  });

  final Home home;
  final String title;

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
      color: SColor.primaryTint,
      title: title,
      note: formatDay(
        now,
        languageCode: Localizations.localeOf(context).languageCode,
      ),
      children: [
        SStatTile(
          label: s.pickupsTitle,
          value: '${stats.onTheWay}',
          illustration: PartnerIllustrations.onTheWay,
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
          illustration: PartnerIllustrations.pickedUp,
          hint: today.claims == 0 ? null : s.ofClaimsToday(today.claims),
        ),
        if (isOwner) ...[
          SStatTile(
            label: s.statNotPickedUp,
            value: '${today.expired}',
            illustration: PartnerIllustrations.notPickedUp,
            hint: today.expired == 0 ? null : s.notPickedUpHint,
          ),
          SStatTile(
            label: s.statLiveOffers,
            value: '${stats.liveOffers}',
            illustration: PartnerIllustrations.liveOffers,
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
