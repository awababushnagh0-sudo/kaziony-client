import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../store/domain/current_store.dart';
import '../domain/offer.dart';
import 'offer_view_model.dart';
import 'widgets/offer_labels.dart';

/// One offer: how it's doing, its details, and the owner's actions.
class OfferScreen extends AppView {
  const OfferScreen({required this.offerId, super.key});

  final String offerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final offer = ref.watch(offerViewModel(offerId));
    final isOwner = ref.watch(currentStoreProvider)?.isOwner ?? false;
    return SScaffold(
      title: s.offersTitle,
      actions: [
        if (isOwner && (offer.value?.canChange ?? false))
          SButton.icon(
            icon: SIcons.edit,
            tooltip: s.editOfferTitle,
            onPressed: () => context.push(Routes.editOffer(offerId)),
          ),
      ],
      body: SAsyncView(
        value: offer,
        onRetry: () => ref.invalidate(offerViewModel(offerId)),
        builder: (context, offer) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: Space.xl,
            children: [
              SListGroup(children: [OfferTile(offer: offer)]),
              _Claims(offer: offer),
              _Details(offer: offer),
              if (isOwner) _Actions(offer: offer),
            ],
          ),
        ),
      ),
    );
  }
}

class _Claims extends StatelessWidget {
  const _Claims({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final claims = offer.claims;
    return SListGroup(
      title: s.claimsSection,
      children: [
        SListTile(title: s.claimsReserved, value: '${claims.reserved}'),
        SListTile(title: s.claimsRedeemed, value: '${claims.redeemed}'),
        SListTile(title: s.claimsExpired, value: '${claims.expired}'),
        SListTile(title: s.claimsCancelled, value: '${claims.cancelled}'),
        SListTile(title: s.viewsLabel, value: '${offer.viewCount}'),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final total = offer.totalQuantity;
    String when(DateTime date) => formatDateTime(date, languageCode: language);
    return SListGroup(
      title: s.detailsSection,
      children: [
        SListTile(
          title: s.offerTypeLabel,
          value: total == null
              ? s.noLimit
              : s.piecesLeft(offer.remainingQuantity ?? 0, total),
        ),
        if (offer.type == OfferType.limited)
          SListTile(
            title: s.holdTitle,
            value: s.holdValue(offer.claimWindowMinutes),
          ),
        SListTile(title: s.perCustomerLabel, value: '${offer.maxPerUser}'),
        SListTile(title: s.startsLabel, value: when(offer.startsAt)),
        SListTile(title: s.endsLabel, value: when(offer.endsAt)),
        SListTile(
          title: s.branchesTitle,
          value: s.branchCount(offer.branchIds.length),
        ),
      ],
    );
  }
}

/// Pause, resume, end, or post again once it's over.
class _Actions extends AppView {
  const _Actions({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final viewModel = ref.read(offerViewModel(offer.id).notifier);

    Future<void> run(Future<AppFailure?> action, String done) async {
      final failure = await action;
      if (!context.mounted) return;
      if (failure == null) {
        SSnack.success(context, done);
      } else {
        SSnack.error(context, failureMessage(context, failure));
      }
    }

    Future<void> end() async {
      final confirmed = await SDialog.confirm(
        context,
        title: s.endOfferTitle,
        message: s.endOfferMessage,
        confirmLabel: s.endOffer,
        destructive: true,
      );
      if (confirmed && context.mounted) {
        await run(viewModel.end(), s.offerEndedDone);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.md,
      children: [
        if (offer.canResume)
          SButton(
            label: s.resumeOffer,
            icon: SIcons.resume,
            onPressed: () => run(viewModel.resume(), s.offerResumed),
          ),
        if (offer.canPause)
          SButton.secondary(
            label: s.pauseOffer,
            icon: SIcons.pause,
            onPressed: () => run(viewModel.pause(), s.offerPausedDone),
          ),
        if (offer.canChange)
          SButton.secondary(
            label: s.endOffer,
            icon: SIcons.stop,
            onPressed: end,
          )
        else
          SButton(
            label: s.repostOffer,
            icon: SIcons.repost,
            onPressed: () =>
                context.push(Routes.newOffer(offer.productId, from: offer.id)),
          ),
      ],
    );
  }
}
