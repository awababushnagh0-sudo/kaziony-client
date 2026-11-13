import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/offer_card.dart';
import '../../../core/widgets/partner_illustrations.dart';
import '../../../core/widgets/request_change_button.dart';
import '../../../core/widgets/reservation_row.dart';
import '../../counter/domain/claim.dart';
import '../../offers/domain/offer.dart';
import '../../offers/presentation/widgets/start_offer.dart';
import '../../store/domain/current_store.dart';
import '../../store/domain/store.dart';
import '../../store/presentation/store_pause_view_model.dart';
import '../../store/presentation/store_view_model.dart';
import '../../store/presentation/take_break_sheet.dart';
import '../../store/presentation/take_break_view_model.dart';
import 'home_view_model.dart';

/// The day at a glance: today's numbers, the next customers to come and how
/// the live offers sell. Staff see the same day, without the numbers only
/// owners act on (no-shows, offers), and the deliveries out to close.
/// Members of several stores (a brand's places) see which one it is. While
/// customers can't see the store, it says what's left before they can;
/// once they can, owners and staff take it offline for a break from here,
/// or close it suddenly, and bring it back.
class HomeScreen extends AppView {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeViewModel);
    Future<void> refresh() async {
      final (homeFailure, storeFailure, pauseFailure) = await (
        ref.read(homeViewModel.notifier).refresh(),
        // Our team may have turned the store on since.
        ref.read(storeViewModel.notifier).refresh(),
        // Someone else at the store may have taken a break.
        ref.read(storePauseViewModel.notifier).refresh(),
      ).wait;
      if ((homeFailure ?? storeFailure ?? pauseFailure) case final failure?
          when context.mounted) {
        SSnack.error(context, failureMessage(context, failure));
      }
    }

    return SScaffold(
      showAppBar: false,
      underStatusBar: true,
      padded: false,
      // Only the loaded page scrolls: loading and errors stay centered.
      scrollable: home.hasValue,
      onRefresh: home.hasValue ? refresh : null,
      body: SAsyncView(
        value: home,
        onRetry: () => ref.invalidate(homeViewModel),
        loading: const _HomeSkeleton(),
        builder: (context, home) => _HomeBody(home),
      ),
    );
  }
}

/// The band with gray shapes on it, then the lists' rows.
class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SBand(
        child: SSkeleton(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SBone.text(variant: TextVariant.title, length: BoneLength.short),
              SBone.text(
                variant: TextVariant.caption,
                length: BoneLength.medium,
              ),
              Gap(Space.md),
              SBone.text(
                variant: TextVariant.subtitle,
                length: BoneLength.short,
              ),
              SBone.text(variant: TextVariant.figure, length: BoneLength.short),
              SBone.text(
                variant: TextVariant.caption,
                length: BoneLength.medium,
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(Space.lg),
        child: SSkeleton.groups(groups: 1),
      ),
    ],
  );
}

class _HomeBody extends AppView {
  const _HomeBody(this.home);

  final Home home;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final store = ref.watch(currentStoreProvider);
    // Kept loaded here, so what the owner adds on the store's pages shows
    // when they come back.
    final details = ref.watch(storeViewModel).value;
    final pause = ref.watch(storePauseViewModel).value;
    final isOwner = store?.isOwner ?? false;
    final several = ref.watch(myStoresProvider).length > 1;
    final now = ref.watch(minuteClockProvider).value ?? ServerClock.now();
    final onTheWay = home.onTheWayAt(now);
    final offers = home.liveOffers.take(Home.offersShown).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TodayBand(
          home: home,
          soonest: onTheWay.firstOrNull,
          now: now,
          isOwner: isOwner,
          title: store != null && several
              ? s.todayAt(store.label)
              : s.todayTitle,
        ),
        const Gap(Space.lg),
        if (details != null && !details.isActive) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            child: _NotLive(details, isOwner: isOwner),
          ),
          const Gap(Space.lg),
        ] else if (details != null) ...[
          if (pause != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.lg),
              child: _Bookings(pause, now: now),
            ),
            const Gap(Space.lg),
          ],
          // Only owners change the store.
          if (isOwner && details.missingToGoLive.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.lg),
              child: _StillMissing(details.missingToGoLive),
            ),
            const Gap(Space.lg),
          ],
        ],
        if (home.stats.outForDelivery > 0) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            child: _Deliveries(home.stats.outForDelivery),
          ),
          const Gap(Space.lg),
        ],
        // Both lists empty: one picture for the page, not two empty lists.
        if (onTheWay.isEmpty && offers.isEmpty)
          SEmptyView(
            illustration: PartnerIllustrations.noOffers,
            title: s.quietDayTitle,
            message: isOwner ? s.quietDayOwnerMessage : s.quietDayStaffMessage,
            // Not while the store is off: the card above says why.
            actionLabel: isOwner && (details?.isActive ?? true)
                ? s.postOffer
                : null,
            onAction: () => startOffer(context),
          )
        else ...[
          // No one coming: the band says so.
          if (onTheWay.isNotEmpty) ...[
            _Header(
              s.pickupsTitle,
              actionLabel: s.seeAll,
              onAction: () => context.push(Routes.pickups),
            ),
            _OnTheWay(onTheWay, now: now),
            const Gap(Space.lg),
          ],
          _Header(
            isOwner ? s.yourLiveOffers : s.liveOffersTitle,
            actionLabel: s.seeAll,
            onAction: () => context.go(Routes.offers),
          ),
          if (offers.isEmpty) _Nothing(s.noLiveOffers) else _LiveOffers(offers),
        ],
        const Gap(Space.xl),
      ],
    );
  }
}

/// Why customers can't see the store: our team turned it off, with a chat
/// to ask why; or, before its first day, what it still needs, each opening
/// the page the owner adds it on, or with nothing missing, that our team
/// turns it on soon, with a chat to ask. Staff see where it stands without
/// the actions: only owners change the store.
class _NotLive extends StatelessWidget {
  const _NotLive(this.store, {required this.isOwner});

  final Store store;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    if (store.wasLive) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.md,
        children: [
          SAlert.warning(title: s.storeOffTitle, message: s.storeOffMessage),
          if (isOwner)
            RequestChangeButton(
              label: s.messageUsOnWhatsApp,
              message: s.askWhyStoreOffMessage(store.label),
            ),
        ],
      );
    }
    final missing = store.missingToGoLive;
    if (missing.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.md,
        children: [
          SAlert.warning(
            title: s.storeReadyTitle,
            message: s.storeReadyMessage,
          ),
          if (isOwner)
            RequestChangeButton(
              label: s.messageUsOnWhatsApp,
              message: s.turnOnStoreMessage(store.label),
            ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.md,
      children: [
        SAlert.warning(
          title: s.storeNotLiveTitle,
          message: isOwner
              ? s.storeNotLiveOwnerMessage
              : s.storeNotLiveStaffMessage,
        ),
        _MissingRows(missing, canAdd: isOwner),
      ],
    );
  }
}

/// What a live store lacks that customers need (set before the rule
/// changed, like hours for every day): each opens the page the owner adds
/// it on. Customers still see the store meanwhile.
class _StillMissing extends StatelessWidget {
  const _StillMissing(this.missing);

  final List<GoLiveItem> missing;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.md,
      children: [
        SAlert.warning(
          title: s.storeMissingTitle,
          message: s.storeMissingMessage,
        ),
        _MissingRows(missing, canAdd: true),
      ],
    );
  }
}

/// A row for each thing a store lacks, opening the page it's added on
/// when [canAdd].
class _MissingRows extends StatelessWidget {
  const _MissingRows(this.missing, {required this.canAdd});

  final List<GoLiveItem> missing;
  final bool canAdd;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    SListTile row(GoLiveItem item) {
      // The logo is changed with the pictures, at the top of the store's
      // info.
      final (icon, title, route) = switch (item) {
        GoLiveItem.logo => (SIcons.image, s.storeLogo, Routes.storeInfo),
        GoLiveItem.pickupInstructions => (
          SIcons.document,
          s.pickupInstructionsLabel,
          Routes.storeInfo,
        ),
        GoLiveItem.openingHours => (
          SIcons.clock,
          s.openingHoursEveryDay,
          Routes.location,
        ),
      };
      return SListTile(
        icon: icon,
        title: title,
        onTap: canAdd ? () => context.push(route) : null,
      );
    }

    return SListGroup(children: [for (final item in missing) row(item)]);
  }
}

/// Whether customers can book now. Taking them: a row that takes a break
/// (or closes suddenly). Offline: until when, that bookings made stand,
/// and the way back.
class _Bookings extends AppView {
  const _Bookings(this.pause, {required this.now});

  final StorePause pause;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final until = pause.pausedUntil;
    if (until == null || !pause.pausedAt(now)) {
      return SListGroup(
        children: [
          SListTile(
            icon: SIcons.pause,
            title: s.takeBreak,
            subtitle: s.takeBreakHint,
            onTap: () => takeBreak(context, ref, pause),
          ),
        ],
      );
    }
    final resuming =
        ref.watch(takeBreakViewModel).sending == BreakAction.resume;
    Future<void> resume() async {
      final failure = await ref.read(takeBreakViewModel.notifier).resume();
      if (!context.mounted) return;
      if (failure == null) {
        SSnack.success(context, s.backOnlineDone);
      } else {
        SSnack.error(context, failureMessage(context, failure));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.md,
      children: [
        SAlert.warning(
          title: s.offlineUntil(
            formatWhen(
              until,
              languageCode: Localizations.localeOf(context).languageCode,
              now: now,
            ),
          ),
          message: s.offlineMessage,
        ),
        SButton(
          label: s.backOnline,
          icon: SIcons.resume,
          expand: true,
          loading: resuming,
          onPressed: resume,
        ),
      ],
    );
  }
}

/// Bookings out with the store's drivers, for the store to close before a
/// day passes and they're taken as delivered.
class _Deliveries extends StatelessWidget {
  const _Deliveries(this.count);

  final int count;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    return SListGroup(
      children: [
        SListTile(
          icon: SIcons.delivery,
          title: s.deliveriesOut(count),
          subtitle: s.deliveriesOutHint,
          onTap: () => context.push(Routes.deliveries),
        ),
      ],
    );
  }
}

/// The live offers in a row that scrolls sideways. One alone takes the
/// page's width: there's nothing to scroll to.
class _LiveOffers extends StatelessWidget {
  const _LiveOffers(this.offers);

  final List<Offer> offers;

  @override
  Widget build(BuildContext context) {
    Widget card(Offer offer) => OfferCard(
      offer: offer,
      onTap: () => context.push(Routes.offer(offer.id)),
    );
    if (offers.length == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.lg),
        child: card(offers.single),
      );
    }
    return SCarousel.wide(children: [for (final offer in offers) card(offer)]);
  }
}

/// The band at the page's top: how many customers are on their way, the one
/// number that changes by the minute, with the rest of the day on its foot.
class _TodayBand extends StatelessWidget {
  const _TodayBand({
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
    return SBand(
      onTap: () => context.push(Routes.pickups),
      foot: SFigures([
        Figure(
          value: '${today.redeemed}',
          label: s.statPickedUp,
          hint: today.claims == 0 ? null : s.reservedToday(today.claims),
          quiet: today.redeemed == 0,
        ),
        if (isOwner) ...[
          Figure(
            value: '${today.expired}',
            label: s.statNotPickedUp,
            quiet: today.expired == 0,
          ),
          Figure(
            value: '${stats.liveOffers}',
            label: s.statLiveOffers,
            hint: runningOut == 0 ? null : s.almostGone(runningOut),
            quiet: stats.liveOffers == 0,
            onTap: () => context.go(Routes.offers),
          ),
        ],
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SText.title(title),
          SText(
            formatDay(
              now,
              languageCode: Localizations.localeOf(context).languageCode,
            ),
            variant: TextVariant.caption,
            color: SColor.textMuted,
            weight: SFontWeight.medium,
          ),
          const Gap(Space.md),
          Row(
            children: [
              Expanded(
                child: soonest == null
                    ? SText.title(s.nobodyOnTheWay)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SText(
                            s.pickupsTitle,
                            variant: TextVariant.subtitle,
                            weight: SFontWeight.bold,
                          ),
                          SText(
                            '${stats.onTheWay}',
                            variant: TextVariant.figure,
                          ),
                          SText(
                            s.soonestIn(
                              timeLeftLabel(
                                s,
                                soonest.expiresAt.difference(now),
                              ),
                            ),
                            variant: TextVariant.caption,
                            weight: soonest.isDueSoonAt(now)
                                ? SFontWeight.semibold
                                : null,
                            color: soonest.isDueSoonAt(now)
                                ? SColor.accentInk
                                : SColor.textMuted,
                          ),
                        ],
                      ),
              ),
              const SIllustration(PartnerIllustrations.onTheWay),
            ],
          ),
        ],
      ),
    );
  }
}

/// The customers on their way as the day's schedule: when each one's hold
/// ends, who, what to get ready, and how long that leaves.
class _OnTheWay extends StatelessWidget {
  const _OnTheWay(this.claims, {required this.now});

  final List<Claim> claims;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return STimeline([
      for (final claim in claims)
        () {
          final time = formatTimeParts(claim.expiresAt, languageCode: language);
          final soon = claim.isDueSoonAt(now);
          return TimelineEntry(
            time: time.clock,
            period: time.period,
            title: claim.customerName ?? s.someCustomer,
            subtitle: claimItemLabel(claim),
            trailing: STag(
              timeLeftLabel(s, claim.expiresAt.difference(now)),
              hot: soon,
            ),
            hot: soon,
            onTap: () => context.push(Routes.claim(claim.code, fromList: true)),
          );
        }(),
    ]);
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
