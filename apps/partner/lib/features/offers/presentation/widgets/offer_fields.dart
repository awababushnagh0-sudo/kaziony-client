import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/partner_localizations.dart';
import '../../../store/domain/store.dart';
import '../../../store/presentation/store_view_model.dart';
import '../../domain/offer.dart';
import '../offer_draft_view_model.dart';
import '../offer_form_checks.dart';

/// The offer's part of a posting form: its price, large; its pieces; when
/// it ends; where it shows, with several branches; and how reservations
/// work, folded away, since it rarely changes.
class OfferFields extends AppView {
  const OfferFields({required this.viewModel, required this.state, super.key});

  final OfferDraftViewModel viewModel;
  final NewOfferState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final regularPrice = viewModel.regularPrice;
    final regular = regularPrice == null
        ? null
        : formatPrice(regularPrice, languageCode: language);
    final discount = state.discount;
    final branches = activeBranches(ref);
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
        if (branches.length > 1)
          _Branches(viewModel: viewModel, state: state, branches: branches),
        _Reservations(viewModel: viewModel, state: state),
      ],
    );
  }
}

/// The store's open branches, the ones an offer can show in.
List<Branch> activeBranches(WidgetRef ref) => [
  for (final branch
      in ref.watch(storeViewModel).value?.branches ?? const <Branch>[])
    if (branch.isActive) branch,
];

/// Where the offer shows, folded under a line that says it, as a store
/// can have many branches: all of them at once, then each ticked or not.
/// It starts open when some are left out, and under it, who won't see the
/// offer, since leaving a branch out is easy to miss.
class _Branches extends StatelessWidget {
  const _Branches({
    required this.viewModel,
    required this.state,
    required this.branches,
  });

  final OfferDraftViewModel viewModel;
  final NewOfferState state;
  final List<Branch> branches;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final ids = [for (final branch in branches) branch.id];
    bool shows(Branch branch) => state.branchIds?.contains(branch.id) ?? true;
    final hidden = [
      for (final branch in branches)
        if (!shows(branch)) branch.name,
    ];
    final shown = [
      for (final branch in branches)
        if (shows(branch)) branch.name,
    ];
    final all = state.branchIds == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.md,
      children: [
        SExpandable(
          title: s.whereTitle,
          subtitle: all
              ? s.allBranches
              : shown.isEmpty
              ? s.noBranchChosen
              : shown.length <= 2
              ? shown.join(s.listSeparator)
              : s.branchCount(shown.length),
          initiallyOpen: !all,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SCheckTile(
                title: s.allBranches,
                checked: all,
                onChanged: (_) => viewModel.setAllBranches(all: !all),
              ),
              for (final branch in branches) ...[
                const SDivider(inset: true),
                SCheckTile(
                  title: branch.name,
                  checked: shows(branch),
                  subtitle: shows(branch) ? s.showsHere : s.hiddenHere,
                  onChanged: (_) => viewModel.toggleBranch(branch.id, ids),
                ),
              ],
            ],
          ),
        ),
        if (shown.isEmpty)
          SAlert(title: s.chooseABranch)
        else if (hidden.isNotEmpty)
          SAlert.warning(
            title: s.hiddenFromBranches(hidden.join(s.listSeparator)),
          ),
      ],
    );
  }
}

/// How long a reservation waits and how many one customer can take,
/// folded under a line that says what they're set to.
class _Reservations extends StatelessWidget {
  const _Reservations({required this.viewModel, required this.state});

  final OfferDraftViewModel viewModel;
  final NewOfferState state;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final limited = state.type == OfferType.limited;
    final perCustomer = state.perCustomer;
    final per = !state.perLimited
        ? s.noLimitPerCustomer
        : perCustomer == null
        ? s.perCustomerLabel
        : s.piecesPerCustomer(perCustomer);
    return SExpandable(
      title: s.reservationsTitle,
      subtitle: limited ? s.holdAndPer(holdLabel(s, state.hold), per) : per,
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.lg,
          children: [
            if (limited)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: Space.sm,
                children: [
                  SChoiceInput<int>(
                    controlName: 'hold',
                    label: s.holdTitle,
                    options: [
                      for (final minutes in viewModel.holdChoices)
                        SelectOption(minutes, holdLabel(s, minutes)),
                    ],
                  ),
                  SText.caption(s.holdHelper),
                ],
              ),
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

/// A hold time as people say it: "30 min", "1 hour", "2 hours".
String holdLabel(PartnerLocalizations s, int minutes) =>
    minutes % 60 == 0 ? s.holdHours(minutes ~/ 60) : s.holdValue(minutes);

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
