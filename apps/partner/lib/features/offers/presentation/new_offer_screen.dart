import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../products/presentation/product_form_view_model.dart';
import '../../store/domain/store.dart';
import '../../store/presentation/store_view_model.dart';
import '../domain/offer.dart';
import 'new_offer_view_model.dart';
import 'offer_form_checks.dart';
import 'offer_view_model.dart';

/// Posts an offer from [productId], or posts [fromOfferId] again.
class NewOfferScreen extends AppView {
  const NewOfferScreen({required this.productId, this.fromOfferId, super.key});

  final String productId;
  final String? fromOfferId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productViewModel(productId));
    final fromId = fromOfferId;
    final from = fromId == null ? null : ref.watch(offerViewModel(fromId));
    if (product.hasValue && (from == null || from.hasValue)) {
      return _NewOfferForm(args: (productId: productId, fromOfferId: fromId));
    }
    // Whichever is still loading or failed.
    final waiting = product.hasValue ? from! : product;
    return SScaffold(
      title: PartnerLocalizations.of(context).newOfferTitle,
      body: SAsyncView(
        value: waiting,
        onRetry: () {
          ref.invalidate(productViewModel(productId));
          if (fromId != null) ref.invalidate(offerViewModel(fromId));
        },
        builder: (_, _) => const SizedBox.shrink(),
      ),
    );
  }
}

class _NewOfferForm extends AppView {
  const _NewOfferForm({required this.args});

  final NewOfferArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final provider = newOfferViewModel(args);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final product = viewModel.product;
    final regular = formatPrice(product.regularPrice, languageCode: language);
    final discount = state.discount;
    // The store's branches, to choose from when there are several.
    final branches = [
      for (final branch
          in ref.watch(storeViewModel).value?.branches ?? const <Branch>[])
        if (branch.isActive) branch,
    ];
    final branchIds = [for (final branch in branches) branch.id];

    Future<void> post() async {
      final offer = await viewModel.post();
      if (offer == null || !context.mounted) return;
      SSnack.success(context, s.offerPosted);
      context.pushReplacement(Routes.offer(offer.id));
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return SScaffold(
      title: s.newOfferTitle,
      scrollable: true,
      bottom: SButton(
        label: s.postOffer,
        onPressed: post,
        loading: state.posting,
        expand: true,
      ),
      body: SForm(
        form: viewModel.form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.lg,
          children: [
            SListGroup(
              children: [
                SListTile(
                  leading: SImage(product.thumbUrl),
                  title: product.title,
                  subtitle: s.regularPriceIs(regular),
                ),
              ],
            ),
            STextInput(
              controlName: 'price',
              label: s.offerPriceLabel,
              kind: TextInputKind.price,
              helper: discount != null && discount > 0
                  ? s.discountHelper(discount)
                  : null,
              validationMessages: {
                OfferChecks.belowRegularKey: (_) =>
                    s.offerPriceTooHigh(regular),
              },
            ),
            SChoiceInput<OfferType>(
              controlName: 'type',
              label: s.offerTypeLabel,
              options: [
                SelectOption(OfferType.limited, s.limitedType),
                SelectOption(OfferType.unlimited, s.unlimitedType),
              ],
              onChanged: viewModel.setType,
            ),
            if (state.type == OfferType.limited) ...[
              STextInput(
                controlName: 'quantity',
                label: s.quantityLabel,
                kind: TextInputKind.number,
              ),
              STextInput(
                controlName: 'hold',
                label: s.holdLabel,
                kind: TextInputKind.number,
                helper: s.holdHelper,
              ),
            ],
            STextInput(
              controlName: 'perCustomer',
              label: s.perCustomerLabel,
              kind: TextInputKind.number,
              helper: s.perCustomerHelper,
            ),
            SDateTimeInput(
              controlName: 'endsAt',
              label: s.endsLabel,
              firstDate: today,
              lastDate: today.add(OfferChecks.maxDuration),
              presets: endPresets(s),
              validationMessages: endMessages(s),
            ),
            if (branches.length > 1) ...[
              SListGroup(
                title: s.branchesTitle,
                children: [
                  for (final branch in branches)
                    SListTile(
                      title: branch.name,
                      trailing: SIcon(
                        state.branchIds?.contains(branch.id) ?? true
                            ? SIcons.selected
                            : SIcons.unselected,
                        color: SColor.primary,
                      ),
                      onTap: () => viewModel.toggleBranch(branch.id, branchIds),
                    ),
                ],
              ),
              if (state.noBranch) SText(s.chooseABranch, color: SColor.danger),
            ],
            if (state.failure case final failure?)
              SText(failureMessage(context, failure), color: SColor.danger),
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
