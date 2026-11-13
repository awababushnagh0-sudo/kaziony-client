import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/widgets/reservation_row.dart';
import '../domain/claim.dart';
import 'claim_view_model.dart';
import 'widgets/claim_labels.dart';

/// A code at the counter: what to collect and how many pieces to hand over,
/// read across the counter, and the button to confirm it; or why it can't
/// be picked up. A green page says when it's done. At a store that
/// delivers, the customer may call instead: the driver takes it ("Send for
/// delivery"), and the same page then closes it, delivered or not.
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
    final viewModel = ref.read(pickupViewModel(code).notifier);
    String price(String value) => formatPrice(value, languageCode: language);

    // Cancelled: nothing left to show here.
    ref.listen(pickupViewModel(code), (_, next) {
      if (next.doneWith == ClaimAction.notDelivered) {
        SSnack.success(context, s.notDeliveredDone);
        context.pop();
      }
    });

    if (pickup.done case final done?
        when pickup.doneWith != ClaimAction.notDelivered) {
      final note = [
        claimItemLabel(done),
        done.customerName ?? s.someCustomer,
      ].join(' · ');
      return switch (pickup.doneWith) {
        ClaimAction.send => SConfirmationPage(
          title: s.sentForDeliveryTitle,
          label: s.driverCollects,
          amount: price(done.totalPrice),
          note: note,
          actionLabel: s.nextCustomer,
          actionIcon: SIcons.scan,
          onAction: context.pop,
        ),
        ClaimAction.delivered => SConfirmationPage(
          title: s.deliveredTitle,
          label: s.paidOnDelivery,
          amount: price(done.totalPrice),
          note: note,
          actionLabel: s.done,
          onAction: context.pop,
        ),
        _ => SConfirmationPage(
          title: s.pickedUpTitle,
          label: s.collectFromCustomer,
          amount: price(done.totalPrice),
          note: note,
          actionLabel: s.nextCustomer,
          actionIcon: SIcons.scan,
          onAction: context.pop,
        ),
      };
    }

    /// From a list, the wrong name is easy to tap: asks first.
    Future<bool> sure(
      String Function(String item, String name, String amount) message,
      String confirmLabel,
    ) async {
      final shown = claim.value;
      if (!fromList || shown == null) return true;
      return SDialog.confirm(
        context,
        title: s.checkCustomerTitle,
        message: message(
          claimItemLabel(shown),
          shown.customerName ?? s.someCustomer,
          price(shown.totalPrice),
        ),
        confirmLabel: confirmLabel,
      );
    }

    Future<void> run(Future<AppFailure?> Function() action) async {
      final failure = await action();
      if (failure == null || !context.mounted) return;
      SSnack.error(context, failureMessage(context, failure));
    }

    Future<void> confirm() async {
      if (!await sure(s.checkCustomerMessage, s.checkCustomerConfirm) ||
          !context.mounted) {
        return;
      }
      await run(viewModel.confirm);
    }

    Future<void> send() async {
      if (!await sure(s.checkSendMessage, s.sendForDelivery) ||
          !context.mounted) {
        return;
      }
      await run(viewModel.send);
    }

    Future<void> delivered(Claim shown) async {
      if (!await sure(s.checkDeliveredMessage, s.markDelivered) ||
          !context.mounted) {
        return;
      }
      await run(() => viewModel.delivered(shown.id));
    }

    Future<void> notDelivered(Claim shown) async {
      final yes = await SDialog.confirm(
        context,
        title: s.notDeliveredTitle,
        message: s.notDeliveredMessage(shown.customerName ?? s.someCustomer),
        confirmLabel: s.cancelBooking,
        cancelLabel: s.keepIt,
        destructive: true,
      );
      if (!yes || !context.mounted) return;
      await run(() => viewModel.notDelivered(shown.id));
    }

    final value = claim.value;
    final pickupButton = SButton(
      label: s.confirmPickup,
      icon: SIcons.check,
      expand: true,
      loading: pickup.running == ClaimAction.pickup,
      onPressed: confirm,
    );
    return SScaffold(
      title: s.claimTitle,
      bottom: switch (value) {
        null || Claim(canRedeem: false) => SButton.secondary(
          label: s.nextCustomer,
          icon: SIcons.scan,
          expand: true,
          onPressed: context.pop,
        ),
        // The driver is back, or called: it's the store's to close.
        Claim(isOutForDelivery: true) && final shown => Row(
          spacing: Space.md,
          children: [
            Expanded(
              child: SButton.soft(
                label: s.notDelivered,
                icon: SIcons.close,
                expand: true,
                loading: pickup.running == ClaimAction.notDelivered,
                onPressed: () => notDelivered(shown),
              ),
            ),
            Expanded(
              child: SButton(
                label: s.markDelivered,
                icon: SIcons.check,
                expand: true,
                loading: pickup.running == ClaimAction.delivered,
                onPressed: () => delivered(shown),
              ),
            ),
          ],
        ),
        Claim(canSendForDelivery: true) => Row(
          spacing: Space.md,
          children: [
            Expanded(
              child: SButton.soft(
                label: s.sendForDelivery,
                icon: SIcons.delivery,
                expand: true,
                loading: pickup.running == ClaimAction.send,
                onPressed: send,
              ),
            ),
            Expanded(child: pickupButton),
          ],
        ),
        _ => pickupButton,
      },
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
    final now = ref.watch(minuteClockProvider).value ?? ServerClock.now();
    final offer = claim.offer;
    final problem = claimProblemMessage(context, claim);
    final redeemedAt = claim.redeemedAt;
    final sentAt = claim.sentForDeliveryAt;
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
          SAlert(title: problem, message: claimProblemHint(context, claim))
        else if (claim.isOutForDelivery && sentAt != null)
          SAlert.warning(
            title: s.outForDeliverySince(time(sentAt)),
            message: s.outForDeliveryHint,
          ),
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
              SFactTile(
                label: sentAt != null ? s.deliveredAtLabel : s.pickedUpAtLabel,
                value: time(redeemedAt),
              )
            else if (sentAt != null)
              SFactTile(label: s.sentForDeliveryAtLabel, value: time(sentAt))
            else
              SFactTile(label: s.heldUntil, value: heldUntil),
          ],
        ),
      ],
    );
  }
}
