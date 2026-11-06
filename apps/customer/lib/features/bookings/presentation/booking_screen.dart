import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../offers/presentation/offer_texts.dart';
import '../domain/booking.dart';
import 'booking_texts.dart';
import 'booking_view_model.dart';

/// A booking's pickup code: the QR code and the code to read out, the time
/// left, what to pay and where. Once it's over, what became of it, and
/// once picked up, the way to rate the store.
class BookingScreen extends AppView {
  const BookingScreen({required this.bookingId, super.key});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final provider = bookingViewModel(bookingId);
    return SScaffold(
      title: s.bookingTitle,
      scrollable: true,
      onRefresh: () async => ref.invalidate(provider),
      body: SAsyncView(
        value: ref.watch(provider),
        onRetry: () => ref.invalidate(provider),
        loading: const SSkeleton.page(),
        builder: (context, booking) => _Booking(booking: booking),
      ),
    );
  }
}

class _Booking extends AppView {
  const _Booking({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    // Every second: the countdown moves.
    final now = ref.watch(secondClockProvider).value ?? DateTime.now();
    final active = booking.isActiveAt(now);
    final (status, tone) = bookingStatus(s, booking, now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.lg,
      children: [
        SItemSummary(
          title: booking.offerTitle,
          imageUrl: booking.thumbUrl,
          badge: SBadge(status, tone: tone),
          note: '${s.quantityTimes(booking.quantity)} · ${booking.storeName}',
          dimmed: !active,
        ),
        if (booking.canRate || booking.myRating != null)
          _Rating(booking: booking),
        if (active) ...[
          Center(child: SQrCode(booking.code, label: s.qrLabel)),
          SCodeCard(
            label: s.showAtCounter,
            code: formatPickupCode(booking.code),
          ),
          SText(
            booking.limited
                ? s.timeLeftToPickUp(
                    countdown(booking.expiresAt.difference(now)),
                  )
                : s.validUntil(
                    formatWhen(booking.expiresAt, languageCode: language),
                  ),
            variant: TextVariant.title,
            weight: SFontWeight.bold,
            color: booking.limited ? SColor.accentInk : SColor.text,
            align: TextAlign.center,
          ),
          SListGroup(
            children: [
              SListTile(
                icon: SIcons.cash,
                title: s.payAtCounter(s.price(context, booking.totalPrice)),
              ),
            ],
          ),
          SListGroup(
            title: s.pickUpAt,
            separated: true,
            children: [
              for (final branch in booking.branches)
                SListTile(
                  icon: SIcons.location,
                  title: branch.name,
                  subtitle: [
                    ?branch.address ?? branch.area,
                    if (branch.distanceKm case final km?) s.distance(km),
                  ].join(' · '),
                ),
            ],
          ),
          if (booking.canCancel) _Cancel(booking: booking),
        ],
      ],
    );
  }
}

/// After a pickup, how it went: five stars to rate the store, once; then
/// the stars given.
class _Rating extends AppStatefulView {
  const _Rating({required this.booking});

  final Booking booking;

  @override
  AppViewState<_Rating> createState() => _RatingState();
}

class _RatingState extends AppViewState<_Rating> {
  /// The stars on their way: shown, and not tappable again meanwhile.
  int? _sending;

  Future<void> _rate(int stars) async {
    final s = CustomerLocalizations.of(context);
    final id = widget.booking.id;
    setState(() => _sending = stars);
    final failure = await ref.read(bookingViewModel(id).notifier).rate(stars);
    if (!mounted) return;
    setState(() => _sending = null);
    if (failure == null) {
      SSnack.success(context, s.ratingThanks);
      return;
    }
    SSnack.error(context, ratingFailureMessage(context, failure));
    // Rated already, or not picked up after all: show it as it is.
    if (failure is ConflictFailure) ref.invalidate(bookingViewModel(id));
  }

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final booking = widget.booking;
    final given = booking.myRating;
    return SCard(
      child: Column(
        spacing: Space.sm,
        children: [
          SText(
            given == null
                ? s.ratingPrompt(booking.storeName)
                : s.ratingGiven(booking.storeName),
            weight: SFontWeight.semibold,
            align: TextAlign.center,
          ),
          if (given == null)
            SText.caption(s.ratingPromptMessage, align: TextAlign.center),
          SStarInput(
            value: given ?? _sending ?? 0,
            starLabel: s.ratingStars,
            onChanged: given == null && _sending == null ? _rate : null,
          ),
        ],
      ),
    );
  }
}

/// Cancelling gives the pieces back; asked first, since it can't be undone.
class _Cancel extends AppView {
  const _Cancel({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    return SButton.dangerSecondary(
      label: s.cancelBooking,
      icon: SIcons.close,
      expand: true,
      onPressed: () async {
        final sure = await SDialog.confirm(
          context,
          title: s.cancelBookingTitle,
          message: s.cancelBookingMessage,
          confirmLabel: s.cancelBooking,
          cancelLabel: s.keepBooking,
          destructive: true,
        );
        if (!sure || !context.mounted) return;
        final failure = await ref
            .read(bookingViewModel(booking.id).notifier)
            .cancel();
        if (!context.mounted) return;
        if (failure == null) {
          SSnack.success(context, s.bookingCancelled);
        } else {
          SSnack.error(context, failureMessage(context, failure));
        }
      },
    );
  }
}
