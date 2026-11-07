import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/sign_in_prompt.dart';
import '../../offers/presentation/offer_texts.dart';
import '../domain/booking.dart';
import 'booking_texts.dart';
import 'bookings_view_model.dart';
import 'widgets/booking_tiles_skeleton.dart';

/// The Bookings tab: the bookings to pick up now first, each a card with
/// its time left and the way to its code; then the past ones, newest
/// first, as tiles with what became of them. Signed out, the way to sign
/// in.
class BookingsScreen extends AppView {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    if (ref.watch(sessionProvider) is! SignedIn) {
      return SScaffold(
        title: s.bookingsTitle,
        body: SignInPrompt(
          title: s.bookingsSignedOutTitle,
          message: s.bookingsSignedOutMessage,
        ),
      );
    }
    return SScaffold(
      title: s.bookingsTitle,
      padded: false,
      body: const _List(),
    );
  }
}

class _List extends AppView {
  const _List();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final viewModel = ref.read(bookingsViewModel.notifier);
    // To the minute is enough to know which are still on; the cards count
    // the seconds themselves.
    final now = ref.watch(minuteClockProvider).value ?? DateTime.now();
    return SAsyncView(
      value: ref.watch(bookingsViewModel),
      onRetry: () => ref.invalidate(bookingsViewModel),
      loading: const Padding(
        padding: EdgeInsets.all(Space.lg),
        child: BookingTilesSkeleton(count: 5),
      ),
      builder: (context, page) {
        if (page.items.isEmpty) {
          return SEmptyView(
            icon: SIcons.bookings,
            title: s.bookingsEmptyTitle,
            message: s.bookingsEmptyMessage,
            actionLabel: s.browseOffers,
            actionIcon: SIcons.offers,
            onAction: () => context.go(Routes.home),
          );
        }
        final current = toPickUpAt(page.items, now);
        final past = [
          for (final booking in page.items)
            if (!booking.isActiveAt(now)) booking,
        ];
        return SPagedList(
          divided: false,
          header: current.isEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Space.lg,
                    Space.md,
                    Space.lg,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: Space.sm,
                    children: [
                      SSectionHeader(s.bookingsNow),
                      for (final booking in current)
                        _CurrentCard(booking: booking),
                      if (past.isNotEmpty) ...[
                        const Gap(Space.md),
                        SSectionHeader(s.bookingsPast),
                      ],
                    ],
                  ),
                ),
          itemCount: past.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            child: _PastTile(booking: past[index], now: now),
          ),
          onRefresh: () async {
            final failure = await viewModel.refresh();
            if (failure != null && context.mounted) {
              SSnack.error(context, failureMessage(context, failure));
            }
          },
          onLoadMore: viewModel.loadMore,
          hasMore: page.hasMore,
          loadingMore: page.loadingMore,
          moreFailure: page.moreFailure,
          placeholder: const Padding(
            padding: EdgeInsets.symmetric(horizontal: Space.lg),
            child: BookingTilesSkeleton(count: 1),
          ),
        );
      },
    );
  }
}

/// A booking to pick up now, on an outlined card: its picture, the store,
/// what and how many, and what to pay; under it, how long is left,
/// counting down (red once little is), and the way to the code across
/// the card. Opens its pass.
class _CurrentCard extends AppView {
  const _CurrentCard({required this.booking});

  final Booking booking;

  /// The share of the time left under which it reads as running out, as
  /// on the pass.
  static const _urgent = 0.2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final now = ref.watch(secondClockProvider).value ?? DateTime.now();
    void open() => context.push(Routes.booking(booking.id));
    final left = booking.expiresAt.difference(now);
    final total = booking.expiresAt.difference(booking.createdAt);
    final until = formatWhen(booking.expiresAt, languageCode: language);
    return SCard(
      onTap: open,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.md,
        children: [
          Row(
            spacing: Space.md,
            children: [
              SImage(booking.thumbUrl, size: SImageSize.tile),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Space.xxs,
                  children: [
                    Row(
                      spacing: Space.xs,
                      children: [
                        const SIcon(
                          SIcons.store,
                          size: SIconSize.xs,
                          color: SColor.textMuted,
                        ),
                        Expanded(
                          child: SText(
                            booking.storeName,
                            variant: TextVariant.caption,
                            color: SColor.textMuted,
                            maxLines: 1,
                          ),
                        ),
                        if (booking.quantity > 1)
                          SBadge(
                            s.quantityTimes(booking.quantity),
                            tone: BadgeTone.neutral,
                          ),
                      ],
                    ),
                    SText(
                      booking.offerTitle,
                      weight: SFontWeight.bold,
                      maxLines: 2,
                    ),
                    Row(
                      spacing: Space.sm,
                      children: [
                        SText(
                          s.price(context, booking.totalPrice),
                          variant: TextVariant.subtitle,
                          weight: SFontWeight.bold,
                          color: SColor.primary,
                        ),
                        Expanded(
                          child: SText(
                            s.payInCash,
                            variant: TextVariant.caption,
                            color: SColor.textMuted,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (booking.limited)
            SCountdown.strip(
              label: s.pickupTimeLeftLabel,
              detail: s.pickUpBefore(until),
              time: countdown(left),
              urgent:
                  total > Duration.zero &&
                  left.inMilliseconds < total.inMilliseconds * _urgent,
            )
          else
            SCountdown.strip(label: s.offerEndsLabel, detail: until),
          SButton(
            label: s.showCode,
            icon: SIcons.qrCode,
            expand: true,
            onPressed: open,
          ),
        ],
      ),
    );
  }
}

/// A past booking: its picture, what it was, the store and the day, and
/// what became of it. Opens its page, with the stars once picked up.
class _PastTile extends StatelessWidget {
  const _PastTile({required this.booking, required this.now});

  final Booking booking;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final (status, tone) = bookingStatus(s, booking, now);
    final day = formatDayMonth(
      booking.pickedUpAt ?? booking.createdAt,
      languageCode: language,
    );
    return SCard(
      onTap: () => context.push(Routes.booking(booking.id)),
      child: Row(
        spacing: Space.md,
        children: [
          SImage(booking.thumbUrl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Space.xxs,
              children: [
                SText(
                  booking.offerTitle,
                  weight: SFontWeight.semibold,
                  maxLines: 1,
                ),
                SText(
                  '${booking.storeName} · $day',
                  variant: TextVariant.caption,
                  color: SColor.textMuted,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          SBadge(status, tone: tone),
        ],
      ),
    );
  }
}
