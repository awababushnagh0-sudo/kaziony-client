import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/widgets/branch_directions.dart';
import '../../../core/widgets/customer_illustrations.dart';
import '../../offers/domain/offer.dart';
import '../../offers/presentation/offer_texts.dart';
import '../domain/booking.dart';
import 'booking_texts.dart';
import 'booking_view_model.dart';

/// A booking. While it can be picked up, a pass to hold up at the
/// counter, on the brand's green: the store and what was booked, the time
/// left, the QR code and the code to read out (tapped, copied), what to pay
/// and where, and the way to cancel. Once it's over, what became of it, and once picked
/// up, the way to rate the store.
class BookingScreen extends AppView {
  const BookingScreen({required this.bookingId, super.key});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final provider = bookingViewModel(bookingId);
    final booking = ref.watch(provider);
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
    return SPassPage(
      title: s.bookingReadyTitle,
      closeTooltip: s.closeAction,
      onClose: context.pop,
      onRefresh: () async => ref.invalidate(bookingViewModel(booking.id)),
      footerLabel: booking.canCancel ? s.cancelNoPenalty : null,
      onFooter: booking.canCancel ? () => _cancel(context, ref, booking) : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.md,
        children: [
          _Ticket(booking: booking, now: now),
          _PayAndPickUp(booking: booking),
        ],
      ),
    );
  }
}

/// Under the ticket, in one box: what to pay, and where: the closest
/// branch, the way there in the phone's maps, or with several, a sheet of
/// them all.
class _PayAndPickUp extends AppView {
  const _PayAndPickUp({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    String named(Branch branch) => [
      branch.name,
      if (branch.distanceKm case final km?) s.distance(km),
    ].join(' · ');
    return SListGroup(
      children: [
        SListTile(
          icon: SIcons.cash,
          title: s.payCashTitle,
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
        if (booking.branches case [final closest, ...final others])
          SListTile(
            icon: SIcons.navigate,
            title: named(closest),
            subtitle: switch (others) {
              [] => closest.address ?? closest.area,
              [final other] => s.orBranch(named(other)),
              _ => s.orOtherBranches(others.length),
            },
            trailing: SText(
              s.directionsAction,
              weight: SFontWeight.bold,
              color: SColor.primary,
            ),
            onTap: others.isEmpty
                ? () => openDirections(context, ref, closest)
                : () => SSheet.show<void>(
                    context,
                    title: s.pickupWhereTitle,
                    subtitle: booking.storeName,
                    illustration: CustomerIllustrations.map,
                    builder: (_) => BranchRows(branches: booking.branches),
                  ),
          ),
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
          if (booking.limited)
            SCountdown(
              label: s.pickupTimeLeftLabel,
              time: countdown(booking.expiresAt.difference(now)),
              left: booking.expiresAt.difference(now),
              total: booking.expiresAt.difference(booking.createdAt),
            )
          else
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
                label: s.factPickedUpAt,
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

/// After a pickup, how it went: five stars to rate the store, once, and
/// the way to send them once picked; then the stars given.
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
    setState(() => _sending = false);
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
            value: given ?? _picked,
            starLabel: s.ratingStars,
            onChanged: given == null && !_sending
                ? (stars) => setState(() => _picked = stars)
                : null,
          ),
          if (given == null && _picked > 0) ...[
            const Gap(Space.xs),
            SButton(
              label: s.ratingSend,
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
}
