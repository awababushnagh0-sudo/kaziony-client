import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../offers/domain/offer.dart';
import '../../offers/presentation/home_view_model.dart';
import '../../offers/presentation/offer_texts.dart';
import '../../offers/presentation/offer_view_model.dart';
import 'booking_texts.dart';
import 'bookings_view_model.dart';
import 'reserve_view_model.dart';

/// Asks to confirm the pieces of [offer] picked on its page
/// ([reserveViewModel]), reserves them, and opens the pickup code. The
/// sheet says how long they're held and, when refused, why.
Future<void> reserve(BuildContext context, WidgetRef ref, Offer offer) async {
  final s = CustomerLocalizations.of(context);
  final provider = reserveViewModel(offer);
  ref.read(provider.notifier).clearFailure();
  final booking = await SSheet.show<String>(
    context,
    title: s.offerPageConfirmTitle(ref.read(provider).quantity),
    subtitle: s.pricePerPiece(s.price(context, offer.offerPrice)),
    builder: (_) => _Confirm(offer: offer),
  );
  if (booking == null || !context.mounted) return;
  // What's left changed, and the offer now has the customer's booking.
  ref
    ..invalidate(offerViewModel(offer.id))
    ..invalidate(homeFeedProvider)
    ..invalidate(bookingsViewModel);
  SSnack.success(context, s.reserved);
  await context.push(Routes.booking(booking));
}

class _Confirm extends AppView {
  const _Confirm({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final state = ref.watch(reserveViewModel(offer));
    final viewModel = ref.read(reserveViewModel(offer).notifier);
    final failure = state.failure;
    // A refusal for a pause says until when, once the standing has caught
    // up with it.
    final pausedUntil = ref.watch(bookingStandingProvider).value?.pausedUntil;
    final now = ref.watch(minuteClockProvider).value ?? DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.lg,
      children: [
        SText(
          offer.limited
              ? s.reserveHoldNote(s.holdTime(offer.claimWindowMinutes))
              : s.reserveUntilEndNote,
          color: SColor.textMuted,
          align: TextAlign.center,
        ),
        if (failure != null)
          SAlert(
            title: reserveFailureMessage(
              context,
              failure,
              pausedUntil: pausedUntil,
              now: now,
            ),
          ),
        SButton(
          label: s.reserveConfirm,
          expand: true,
          loading: state.sending,
          onPressed: () async {
            final booking = await viewModel.reserve();
            if (booking != null && context.mounted) {
              Navigator.of(context).pop(booking.id);
            }
          },
        ),
      ],
    );
  }
}
