import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/partner_localizations.dart';
import '../../domain/offer.dart';
import '../offer_draft_view_model.dart';
import '../offer_form_checks.dart';

/// The offer's part of a posting form: its price, large; its pieces; when
/// it ends; and how many one customer can take, folded away, since it
/// rarely changes.
class OfferFields extends StatelessWidget {
  const OfferFields({required this.viewModel, required this.state, super.key});

  final OfferDraftViewModel viewModel;
  final NewOfferState state;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final regularPrice = viewModel.regularPrice;
    final regular = regularPrice == null
        ? null
        : formatPrice(regularPrice, languageCode: language);
    final discount = state.discount;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.xl,
      children: [
        SAmountInput(
          controlName: 'price',
          label: s.offerPriceLabel,
          was: regular,
          // At the regular price or over, it's no discount.
          limit: regularPrice,
          limitMessage: regular == null ? null : s.offerPriceTooHigh(regular),
          badge: discount != null && discount > 0
              ? s.discountBadge(discount)
              : null,
          // Still checked: the regular price can be lowered after it.
          validationMessages: {
            OfferChecks.belowRegularKey: (_) =>
                s.offerPriceTooHigh(regular ?? ''),
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.md,
          children: [
            SChoiceInput<OfferType>.segmented(
              controlName: 'type',
              label: s.offerTypeLabel,
              options: [
                SelectOption(OfferType.limited, s.limitedType),
                SelectOption(OfferType.unlimited, s.unlimitedType),
              ],
              onChanged: viewModel.setType,
            ),
            if (state.type == OfferType.limited)
              SCountInput(
                controlName: 'quantity',
                label: s.quantityLabel,
                min: 1,
                max: 10000,
                size: CountSize.large,
              )
            else
              SText.caption(s.unlimitedHint),
          ],
        ),
        SDateTimeInput(
          controlName: 'endsAt',
          label: s.endsLabel,
          firstDate: today,
          lastDate: today.add(OfferChecks.maxDuration),
          presets: endPresets(s),
          validationMessages: endMessages(s),
        ),
        _Reservations(viewModel: viewModel, state: state),
      ],
    );
  }
}

/// How many pieces one customer can take, folded under a line that says
/// what it's set to.
class _Reservations extends StatelessWidget {
  const _Reservations({required this.viewModel, required this.state});

  final OfferDraftViewModel viewModel;
  final NewOfferState state;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final perCustomer = state.perCustomer;
    final per = !state.perLimited
        ? s.noLimitPerCustomer
        : perCustomer == null
        ? s.perCustomerLabel
        : s.piecesPerCustomer(perCustomer);
    return SExpandable(
      title: s.reservationsTitle,
      subtitle: per,
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.lg,
          children: [
            SChoiceInput<bool>.segmented(
              controlName: 'perLimited',
              label: s.perCustomerLabel,
              options: [
                SelectOption(false, s.noLimit),
                SelectOption(true, s.atMost),
              ],
              onChanged: viewModel.setPerLimited,
            ),
            if (state.perLimited)
              SCountInput(
                controlName: 'perCustomer',
                label: s.perCustomerLabel,
                min: 1,
                max: 10,
              )
            else
              SText.caption(s.anyCustomerAll),
          ],
        ),
      ),
    );
  }
}

/// One-tap end times: tonight (while it's still to come), tomorrow night,
/// in 3 days, in a week, all at 23:00.
List<DateTimePreset> endPresets(PartnerLocalizations s) {
  final now = DateTime.now();
  DateTime night(int days) => DateTime(now.year, now.month, now.day + days, 23);
  return [
    if (night(0).isAfter(now)) DateTimePreset(s.endsTonight, night(0)),
    DateTimePreset(s.endsTomorrow, night(1)),
    DateTimePreset(s.endsIn3Days, night(3)),
    DateTimePreset(s.endsInAWeek, night(7)),
  ];
}

Map<String, String Function(Object)> endMessages(PartnerLocalizations s) => {
  OfferChecks.endsInPastKey: (_) => s.endsInPast,
  OfferChecks.endsTooLateKey: (_) => s.endsTooLate,
};
