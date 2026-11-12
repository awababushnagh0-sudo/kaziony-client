import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/widgets/store_location_box.dart';
import '../../offers/presentation/offer_texts.dart';
import '../domain/booking.dart';
import 'booking_texts.dart';
import 'booking_view_model.dart';

/// A booking. While it can be picked up, a pass to hold up at the
/// counter, on the brand's green: the store and what was booked, the time
/// left, the QR code and the code to read out (tapped, copied), what to pay
/// and where (with the store's hours today and phone), and the way to
/// cancel. At a store that delivers, its number to call to have it
/// brought; once the store's driver has it, the pass says it's on its way,
/// and cancelling is a call to the store. Once it's over, what became of
/// it, and once picked up, the customer's stars for the store, and the way
/// to give them.
class BookingScreen extends AppView {
  const BookingScreen({required this.bookingId, super.key});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final provider = bookingViewModel(bookingId);
    final booking = ref.watch(provider);
    // Scanned at the counter while the pass is up, or handed over by the
    // driver: said, as the page turns to the stars. Taken by the driver:
    // said too.
    ref.listen(provider, (before, after) {
      final message = switch ((before?.value?.status, after.value?.status)) {
        (BookingStatus.reserved, BookingStatus.pickedUp) => s.bookingPickedUp,
        (BookingStatus.outForDelivery, BookingStatus.pickedUp) =>
          s.bookingDelivered,
        (BookingStatus.reserved, BookingStatus.outForDelivery) =>
          s.bookingSentForDelivery,
        _ => null,
      };
      if (message != null) SSnack.success(context, message);
    });
    // Every second: the countdown moves, and the pass gives way to the
    // plain page the moment the time is up.
    final now = ref.watch(secondClockProvider).value ?? DateTime.now();
    if (booking case AsyncData(:final value) when value.isActiveAt(now)) {
      return _Pass(booking: value, now: now);
    }
    return SScaffold(
      title: s.bookingTitle,
      scrollable: true,
      onRefresh: () async => ref.invalidate(provider),
      body: SAsyncView(
        value: booking,
        onRetry: () => ref.invalidate(provider),
        loading: const SSkeleton.page(),
        builder: (context, booking) => _Past(booking: booking, now: now),
      ),
    );
  }
}

/// The pass, while the booking can be picked up.
class _Pass extends AppView {
  const _Pass({required this.booking, required this.now});

  final Booking booking;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    // On its way, it's the store's to cancel: a call away.
    final storePhone = booking.deliveryPhone ?? booking.location.phone;
    final (footerLabel, onFooter) = switch (booking) {
      Booking(canCancel: true) => (
        s.cancelNoPenalty,
        () => _cancel(context, ref, booking),
      ),
      Booking(isOutForDelivery: true) when storePhone != null => (
        s.cancelByCallingStore,
        () => callPhone(context, ref, storePhone),
      ),
      _ => (null, null),
    };
    return SPassPage(
      title: booking.isOutForDelivery
          ? s.bookingOnItsWayTitle
          : s.bookingReadyTitle,
      closeTooltip: s.closeAction,
      onClose: context.pop,
      onRefresh: () async => ref.invalidate(bookingViewModel(booking.id)),
      footerLabel: footerLabel,
      onFooter: onFooter,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.md,
        children: [
          _Ticket(booking: booking, now: now),
          _PayAndPickUp(booking: booking, now: now),
        ],
      ),
    );
  }
}

/// Under the ticket, in one box: what to pay, the number to call when the
/// store delivers, and where: the store's place, the way there in the
/// phone's maps, its hours today and its phone.
class _PayAndPickUp extends AppView {
  const _PayAndPickUp({required this.booking, required this.now});

  final Booking booking;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final deliveryPhone = booking.deliveryPhone;
    return SListGroup(
      children: [
        SListTile(
          icon: SIcons.cash,
          title: booking.isOutForDelivery ? s.payDriverTitle : s.payCashTitle,
          subtitle: booking.quantity > 1
              ? s.priceEach(
                  booking.quantity,
                  s.price(context, booking.offerPrice),
                )
              : null,
          trailing: SText(
            s.price(context, booking.totalPrice),
            variant: TextVariant.subtitle,
            weight: SFontWeight.bold,
            color: SColor.primary,
          ),
        ),
        if (deliveryPhone != null)
          SListTile(
            icon: SIcons.delivery,
            title: booking.isOutForDelivery
                ? s.callAboutDelivery
                : s.storeDelivers,
            subtitle: booking.isOutForDelivery
                ? formatLibyanPhone(deliveryPhone)
                // "091 000 0001" keeps its order in Arabic.
                : s.storeDeliversHint(
                    '\u2066${formatLibyanPhone(deliveryPhone)}\u2069',
                  ),
            trailing: SText(
              s.callAction,
              weight: SFontWeight.bold,
              color: SColor.primary,
            ),
            onTap: () => callPhone(context, ref, deliveryPhone),
          ),
        storeDirectionsTile(context, ref, booking.location),
        ...storeLocationDetails(context, ref, booking.location, now: now),
      ],
    );
  }
}

/// The ticket: the store's logo, what was booked and the store, its
/// state; across a dashed line, the time left, the QR code, and the code
/// to read out with how to use it.
class _Ticket extends StatelessWidget {
  const _Ticket({required this.booking, required this.now});

  final Booking booking;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final (status, tone) = bookingStatus(s, booking, now);
    final many = booking.quantity > 1;
    return SCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.lg,
        children: [
          Row(
            spacing: Space.md,
            children: [
              SImage(booking.storeLogoUrl, size: SImageSize.logoOnPhoto),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Space.xxs,
                  children: [
                    SText(
                      many
                          ? '${booking.offerTitle} '
                                '${s.quantityTimes(booking.quantity)}'
                          : booking.offerTitle,
                      weight: SFontWeight.bold,
                      maxLines: 2,
                    ),
                    SText(
                      [
                        booking.storeName,
                        if (many) s.oneCodeFor(booking.quantity),
                      ].join(' · '),
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
          const SDivider.dashed(),
          if (booking.sentForDeliveryAt case final sent?
              when booking.isOutForDelivery)
            SText(
              s.onItsWaySince(formatTime(sent, languageCode: language)),
              variant: TextVariant.subtitle,
              weight: SFontWeight.bold,
              align: TextAlign.center,
            )
          else if (booking.limited) ...[
            SCountdown(
              label: s.pickupTimeLeftLabel,
              time: countdown(booking.expiresAt.difference(now)),
              left: booking.expiresAt.difference(now),
              total: booking.expiresAt.difference(booking.createdAt),
            ),
            // Held until the store closes, sooner than usual: why.
            if (booking.location.hours.closesAt(booking.expiresAt))
              SText.caption(
                s.pickupUntilClosing(
                  formatWhen(
                    booking.expiresAt,
                    languageCode: language,
                    now: now,
                  ),
                ),
                color: SColor.warning,
                align: TextAlign.center,
              ),
          ] else
            SText(
              s.validUntil(
                formatWhen(booking.expiresAt, languageCode: language),
              ),
              variant: TextVariant.subtitle,
              weight: SFontWeight.bold,
              align: TextAlign.center,
            ),
          Center(child: SQrCode(booking.code, label: s.qrLabel)),
          SCodeCard.copyable(
            code: formatPickupCode(booking.code),
            copyLabel: s.copyCode,
            copiedMessage: s.codeCopied,
          ),
          SText.caption(s.codeHint, align: TextAlign.center),
        ],
      ),
    );
  }
}

/// A booking no longer to pick up: what became of it at which store, how
/// many for how much and when, and the stars.
class _Past extends StatelessWidget {
  const _Past({required this.booking, required this.now});

  final Booking booking;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final (status, tone) = bookingStatus(s, booking, now);
    final pickedUpAt = booking.pickedUpAt;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.lg,
      children: [
        SItemSummary(
          title: booking.offerTitle,
          imageUrl: booking.thumbUrl,
          badge: SBadge(status, tone: tone),
          note: booking.storeName,
          dimmed: booking.status != BookingStatus.pickedUp,
        ),
        if (booking.cancelReason case final reason?
            when booking.cancelledForCustomer)
          _CancelledFor(reason),
        SListGroup(
          children: [
            SFactTile(label: s.factPieces, value: '${booking.quantity}'),
            SFactTile(
              label: s.factTotal,
              value: s.price(context, booking.totalPrice),
            ),
            SFactTile(
              label: s.factBookedAt,
              value: formatDateTime(booking.createdAt, languageCode: language),
            ),
            if (pickedUpAt != null)
              SFactTile(
                label: booking.sentForDeliveryAt != null
                    ? s.factDeliveredAt
                    : s.factPickedUpAt,
                value: formatDateTime(pickedUpAt, languageCode: language),
              ),
          ],
        ),
        if (booking.canRate || booking.myRating != null)
          _Rating(booking: booking),
      ],
    );
  }
}

/// Who cancelled a booking the customer didn't, and that it doesn't count
/// against them.
class _CancelledFor extends StatelessWidget {
  const _CancelledFor(this.reason);

  final CancelReason reason;

  @override
  Widget build(BuildContext context) {
    final (:title, :message) = cancelledFor(
      CustomerLocalizations.of(context),
      reason,
    );
    return SAlert.warning(title: title, message: message);
  }
}

/// After a pickup, the customer's stars for the store: one rating per
/// store, from this pickup or another. While this pickup can rate it (not
/// rated since), five stars to pick and the way to send them, which
/// replace the ones given before.
class _Rating extends AppStatefulView {
  const _Rating({required this.booking});

  final Booking booking;

  @override
  AppViewState<_Rating> createState() => _RatingState();
}

class _RatingState extends AppViewState<_Rating> {
  /// The stars picked, not sent yet: 0 before any.
  int _picked = 0;

  /// While they're on their way: not to be changed or sent again.
  bool _sending = false;

  Future<void> _send() async {
    final s = CustomerLocalizations.of(context);
    final id = widget.booking.id;
    setState(() => _sending = true);
    final failure = await ref.read(bookingViewModel(id).notifier).rate(_picked);
    if (!mounted) return;
    setState(() {
      _sending = false;
      // Sent, the booking has them now.
      if (failure == null) _picked = 0;
    });
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
    final canRate = booking.canRate;
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
          SText.caption(
            given == null
                ? s.ratingPromptMessage
                : canRate
                ? s.ratingAgainMessage
                : s.ratingOnePerStore,
            align: TextAlign.center,
          ),
          SStarInput(
            value: _picked > 0 ? _picked : given ?? 0,
            starLabel: s.ratingStars,
            onChanged: canRate && !_sending
                ? (stars) => setState(() => _picked = stars)
                : null,
          ),
          if (canRate && _picked > 0 && _picked != given) ...[
            const Gap(Space.xs),
            SButton(
              label: given == null ? s.ratingSend : s.ratingUpdate,
              expand: true,
              loading: _sending,
              onPressed: _send,
            ),
          ],
        ],
      ),
    );
  }
}

/// Cancelling gives the pieces back; asked first, since it can't be undone.
Future<void> _cancel(
  BuildContext context,
  WidgetRef ref,
  Booking booking,
) async {
  final s = CustomerLocalizations.of(context);
  final sure = await SDialog.confirm(
    context,
    title: s.cancelBookingTitle,
    // Cancelled once already, it's the last time: said before, not after.
    message: booking.cancelEndsBooking
        ? s.cancelEndsBookingMessage
        : s.cancelBookingMessage,
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
}
