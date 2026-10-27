import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../domain/claim.dart';
import 'claim_view_model.dart';
import 'counter_branch_view_model.dart';
import 'widgets/claim_labels.dart';
import 'widgets/counter_branch_sheet.dart';

/// A code at the counter: who it is, what they pay, and the button to hand
/// it over, or why it can't be.
class ClaimScreen extends AppView {
  const ClaimScreen({required this.code, super.key});

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final claim = ref.watch(claimViewModel(code));
    final pickup = ref.watch(pickupViewModel(code));
    // Watched so the store's branches load while the cashier looks.
    final branches = ref.watch(counterBranchesProvider);
    final next = SButton(
      label: s.nextCustomer,
      icon: SIcons.scan,
      expand: true,
      onPressed: context.pop,
    );

    if (pickup.done case final done?) {
      return SScaffold(
        title: s.claimTitle,
        bottom: next,
        body: SSuccessView(
          title: s.pickedUpTitle,
          message: s.pickedUpMessage(
            formatPrice(done.offer.offerPrice, languageCode: language),
          ),
        ),
      );
    }

    Future<void> confirm() async {
      var branchId = branches.branchId;
      if (branches.mustChoose) {
        branchId = await chooseCounterBranch(context, ref, branches);
        if (branchId == null || !context.mounted) return;
      }
      final failure = await ref
          .read(pickupViewModel(code).notifier)
          .confirm(branchId: branchId);
      if (failure == null || !context.mounted) return;
      SSnack.error(
        context,
        // The only request errors left are about the branch.
        failure is ValidationFailure
            ? s.redeemWrongBranch
            : failureMessage(context, failure),
      );
    }

    final value = claim.value;
    return SScaffold(
      title: s.claimTitle,
      bottom: value == null || !value.canRedeem
          ? SButton.secondary(
              label: s.nextCustomer,
              icon: SIcons.scan,
              expand: true,
              onPressed: context.pop,
            )
          : SButton(
              label: s.confirmPickup,
              icon: SIcons.check,
              expand: true,
              loading: pickup.sending,
              onPressed: confirm,
            ),
      body: claim.error is NotFoundFailure
          ? SEmptyView(
              icon: SIcons.noResults,
              title: s.claimNotFound,
              message: code,
            )
          : SAsyncView(
              value: claim,
              onRetry: () => ref.invalidate(claimViewModel(code)),
              builder: (context, claim) =>
                  SingleChildScrollView(child: _Details(claim: claim)),
            ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.claim});

  final Claim claim;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final offer = claim.offer;
    final problem = claimProblemMessage(context, claim);
    final redeemedAt = claim.redeemedAt;
    String price(String value) => formatPrice(value, languageCode: language);
    String when(DateTime date) => formatWhen(date, languageCode: language);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.xl,
      children: [
        if (problem != null)
          SCard(
            child: Row(
              spacing: Space.md,
              children: [
                const SIcon(SIcons.error, color: SColor.danger),
                Expanded(
                  child: SText(
                    problem,
                    color: SColor.danger,
                    weight: SFontWeight.medium,
                  ),
                ),
              ],
            ),
          ),
        // Only what's to be paid now: a used code shows no amount, so no
        // money is taken twice.
        if (problem == null)
          SCard(
            child: Column(
              spacing: Space.xs,
              children: [
                SText.caption(s.toCollect, align: TextAlign.center),
                SText.display(price(offer.offerPrice), align: TextAlign.center),
                if (offer.originalPrice != offer.offerPrice)
                  SText.caption(
                    s.regularPriceIs(price(offer.originalPrice)),
                    align: TextAlign.center,
                  ),
              ],
            ),
          ),
        SListGroup(
          children: [
            SListTile(leading: SImage(offer.thumbUrl), title: offer.title),
            SListTile(
              title: s.customerLabel,
              value: claim.customerName ?? s.someCustomer,
            ),
            SListTile(title: s.codeLabel, value: claim.code),
            if (redeemedAt != null)
              SListTile(title: s.pickedUpAtLabel, value: when(redeemedAt))
            else
              SListTile(title: s.heldUntil, value: when(claim.expiresAt)),
          ],
        ),
      ],
    );
  }
}
