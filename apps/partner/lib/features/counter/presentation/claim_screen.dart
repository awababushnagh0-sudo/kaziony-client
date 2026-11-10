import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/widgets/reservation_row.dart';
import '../domain/claim.dart';
import 'claim_view_model.dart';
import 'widgets/claim_labels.dart';

/// A code at the counter: what to collect and how many pieces to hand over,
/// read across the counter, and the button to confirm it; or why it can't
/// be picked up. A green page says when it's done.
class ClaimScreen extends AppView {
  const ClaimScreen({required this.code, this.fromList = false, super.key});

  final String code;

  /// Opened by tapping a name in a list, not by the customer's code: the
  /// wrong name is easy to tap, so confirming asks first.
  final bool fromList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final claim = ref.watch(claimViewModel(code));
    final pickup = ref.watch(pickupViewModel(code));

    if (pickup.done case final done?) {
      return SConfirmationPage(
        title: s.pickedUpTitle,
        label: s.collectFromCustomer,
        amount: formatPrice(done.totalPrice, languageCode: language),
        note: [
          claimItemLabel(done),
          done.customerName ?? s.someCustomer,
        ].join(' · '),
        actionLabel: s.nextCustomer,
        actionIcon: SIcons.scan,
        onAction: context.pop,
      );
    }

    Future<void> confirm() async {
      final shown = claim.value;
      if (fromList && shown != null) {
        final sure = await SDialog.confirm(
          context,
          title: s.checkCustomerTitle,
          message: s.checkCustomerMessage(
            claimItemLabel(shown),
            shown.customerName ?? s.someCustomer,
            formatPrice(shown.totalPrice, languageCode: language),
          ),
          confirmLabel: s.checkCustomerConfirm,
        );
        if (!sure || !context.mounted) return;
      }
      final failure = await ref.read(pickupViewModel(code).notifier).confirm();
      if (failure == null || !context.mounted) return;
      SSnack.error(context, failureMessage(context, failure));
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
              loading: const SSkeleton.page(),
              builder: (context, claim) =>
                  SingleChildScrollView(child: _Details(claim: claim)),
            ),
    );
  }
}

class _Details extends AppView {
  const _Details({required this.claim});

  final Claim claim;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final now = ref.watch(minuteClockProvider).value ?? DateTime.now();
    final offer = claim.offer;
    final problem = claimProblemMessage(context, claim);
    final redeemedAt = claim.redeemedAt;
    String price(String value) => formatPrice(value, languageCode: language);
    String time(DateTime date) => formatWhen(date, languageCode: language);
    final heldUntil = claim.isHeldAt(now)
        ? s.heldUntilLeft(
            time(claim.expiresAt),
            timeLeftLabel(s, claim.expiresAt.difference(now)),
          )
        : time(claim.expiresAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.xl,
      children: [
        if (problem != null)
          SAlert(title: problem, message: claimProblemHint(context, claim)),
        SCodeCard(
          label: s.codeLabel,
          code: formatPickupCode(claim.code),
          copyHint: s.tapToCopy,
          copiedMessage: s.codeCopied,
        ),
        // Only what's to be paid now: a used code shows no total, so no
        // money is taken twice.
        if (problem == null)
          SReceipt(
            // A reservation is one offer; its total comes from the server.
            lines: [
              ReceiptLine(
                quantity: claim.quantity,
                title: offer.title,
                detail: s.perPiece(price(offer.offerPrice)),
                amount: price(claim.totalPrice),
              ),
            ],
            totalLabel: s.toCollect,
            total: price(claim.totalPrice),
            note: s.payInCash,
          )
        else
          SItemSummary(
            imageUrl: offer.thumbUrl,
            title: offer.title,
            badge: ClaimStatusBadge(claim.status),
            note:
                '${s.piecesCount(claim.quantity)} · '
                '${price(claim.totalPrice)}',
            dimmed: true,
          ),
        SListGroup(
          children: [
            SFactTile(
              label: s.customerLabel,
              value: claim.customerName ?? s.someCustomer,
            ),
            if (redeemedAt != null)
              SFactTile(label: s.pickedUpAtLabel, value: time(redeemedAt))
            else
              SFactTile(label: s.heldUntil, value: heldUntil),
          ],
        ),
      ],
    );
  }
}
