import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/sign_in_prompt.dart';
import '../../offers/presentation/offer_texts.dart';
import '../domain/booking.dart';
import 'booking_texts.dart';
import 'bookings_view_model.dart';

/// The Bookings tab: a calm word first when booking is paused or pickups
/// were missed; the bookings to pick up now, each a card with its time
/// left and the way to its code; then the past ones, newest first under
/// the day they happened (today, yesterday, a date), as cards with the
/// store, what became of them and what was booked. Signed out, the way to
/// sign in.
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
    final language = Localizations.localeOf(context).languageCode;
    final viewModel = ref.read(bookingsViewModel.notifier);
    // To the minute is enough to know which are still on; the cards count
    // the seconds themselves.
    final now = ref.watch(minuteClockProvider).value ?? ServerClock.now();
    final standing = ref.watch(bookingStandingProvider).value;
    final warning = standing == null
        ? null
        : standingWarning(s, standing, now, languageCode: language);
    return SAsyncView(
      value: ref.watch(bookingsViewModel),
      onRetry: () => ref.invalidate(bookingsViewModel),
      loading: const Padding(
        padding: EdgeInsets.all(Space.lg),
        child: _PastTilesSkeleton(count: 4),
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
        final header = warning != null || current.isNotEmpty;
        return SPagedList(
          divided: false,
          header: !header
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
                      if (warning != null) ...[
                        SAlert.warning(
                          title: warning.title,
                          message: warning.message,
                        ),
                        if (current.isNotEmpty) const Gap(Space.sm),
                      ],
                      if (current.isNotEmpty) ...[
                        SSectionHeader(s.bookingsNow),
                        for (final booking in current)
                          _CurrentCard(booking: booking),
                      ],
                    ],
                  ),
                ),
          itemCount: past.length,
          itemBuilder: (context, index) {
            final when = bookingTime(past[index]);
            // A day's name over its first booking: newest first, so the
            // day changes going down.
            final newDay =
                index == 0 || !isSameDay(when, bookingTime(past[index - 1]));
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (newDay)
                    Padding(
                      padding: EdgeInsets.only(
                        top: index == 0 && !header ? Space.md : Space.lg,
                        bottom: Space.sm,
                      ),
                      child: SSectionHeader(
                        bookingDay(s, when, now, languageCode: language),
                      ),
                    ),
                  _PastTile(booking: past[index], now: now),
                ],
              ),
            );
          },
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
            child: _PastTilesSkeleton(count: 1),
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
    final now = ref.watch(secondClockProvider).value ?? ServerClock.now();
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
                            storeNamed(booking),
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
          if (booking.isOutForDelivery)
            SCountdown.strip(
              label: s.statusOutForDelivery,
              detail: s.withTheStoresDriver,
            )
          else if (booking.limited)
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

/// A past booking, on a card: the store's logo by its name, what became
/// of it in its color with what was paid, and at what time; under them, the
/// offer's photo with how many were booked on it, and its name. Opens its
/// page, with the stars once picked up.
class _PastTile extends StatelessWidget {
  const _PastTile({required this.booking, required this.now});

  final Booking booking;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final (status, _) = bookingStatus(s, booking, now);
    // The day is over the card.
    final when = formatTime(bookingTime(booking), languageCode: language);
    return SCard(
      onTap: () => context.push(Routes.booking(booking.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.md,
        children: [
          Row(
            spacing: Space.md,
            children: [
              SImage(booking.storeLogoUrl, size: SImageSize.logoInCard),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Space.xxs,
                  children: [
                    SText(
                      storeNamed(booking),
                      variant: TextVariant.caption,
                      weight: SFontWeight.bold,
                      color: SColor.text,
                      maxLines: 1,
                    ),
                    Row(
                      spacing: Space.xs,
                      children: [
                        SText(
                          status,
                          variant: TextVariant.caption,
                          weight: SFontWeight.semibold,
                          color: _statusColor(booking.status),
                        ),
                        Flexible(
                          child: SText(
                            '· ${s.price(context, booking.totalPrice)}',
                            variant: TextVariant.caption,
                            color: SColor.textMuted,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    SText(
                      when,
                      variant: TextVariant.caption,
                      color: SColor.textMuted,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // One offer per booking: its photo, how many, and its name.
          Row(
            spacing: Space.md,
            children: [
              Stack(
                children: [
                  SImage(booking.thumbUrl, size: SImageSize.tile),
                  PositionedDirectional(
                    bottom: Space.xs,
                    start: Space.xs,
                    child: SBadge(
                      s.quantityTimes(booking.quantity),
                      tone: BadgeTone.onPhoto,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SText(
                  booking.offerTitle,
                  weight: SFontWeight.semibold,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Picked up in green, missed in red, cancelled in gray. A reserved one
  /// is here only once its time ran out: missed. One on its way never is.
  static SColor _statusColor(BookingStatus status) => switch (status) {
    BookingStatus.pickedUp => SColor.success,
    BookingStatus.expired => SColor.danger,
    BookingStatus.cancelled => SColor.textMuted,
    BookingStatus.reserved => SColor.danger,
    BookingStatus.outForDelivery => SColor.accentInk,
  };
}

/// Past bookings while they load: a logo and its lines, then a photo and
/// a name, on cards down the page.
class _PastTilesSkeleton extends StatelessWidget {
  const _PastTilesSkeleton({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) => SSkeleton(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.sm,
      children: [
        for (var i = 0; i < count; i++)
          const SCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: Space.md,
              children: [
                Row(
                  spacing: Space.md,
                  children: [
                    SBone.image(size: SImageSize.logoInCard),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: Space.xxs,
                        children: [
                          SBone.text(length: BoneLength.medium),
                          SBone.text(
                            variant: TextVariant.caption,
                            length: BoneLength.short,
                          ),
                          SBone.text(
                            variant: TextVariant.caption,
                            length: BoneLength.medium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: Space.md,
                  children: [
                    SBone.image(size: SImageSize.tile),
                    Expanded(child: SBone.text(length: BoneLength.long)),
                  ],
                ),
              ],
            ),
          ),
      ],
    ),
  );
}
