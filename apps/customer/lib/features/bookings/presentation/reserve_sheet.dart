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

/// Asks how many pieces of [offer] to reserve, reserves them, and opens
/// the pickup code.
Future<void> reserve(BuildContext context, WidgetRef ref, Offer offer) async {
  final s = CustomerLocalizations.of(context);
  final booking = await SSheet.show<String>(
    context,
    title: s.reserveTitle,
    subtitle: s.pricePerPiece(s.price(context, offer.offerPrice)),
    builder: (_) => _ReserveForm(offer: offer),
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

class _ReserveForm extends AppView {
  const _ReserveForm({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final state = ref.watch(reserveViewModel(offer));
    final viewModel = ref.read(reserveViewModel(offer).notifier);
    final failure = state.failure;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.lg,
      children: [
        if (offer.maxReservable > 1)
          SQuantityInput(
            value: state.quantity,
            max: offer.maxReservable,
            onChanged: viewModel.setQuantity,
          ),
        SText(
          offer.limited
              ? s.reserveHoldNote(offer.claimWindowMinutes)
              : s.reserveUntilEndNote,
          color: SColor.textMuted,
          align: TextAlign.center,
        ),
        if (failure != null)
          SAlert(title: reserveFailureMessage(context, failure)),
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
