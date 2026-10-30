import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/offer_tile.dart';
import '../../store/domain/current_store.dart';
import '../domain/offer.dart';
import 'offers_view_model.dart';
import 'widgets/offer_labels.dart';

/// The Offers tab: everyone in the store sees the offers; owners post them.
class OffersScreen extends AppView {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final filter = ref.watch(offerFilterProvider);
    final filters = ref.read(offerFilterProvider.notifier);
    final isOwner = ref.watch(currentStoreProvider)?.isOwner ?? false;
    final firstEmpty =
        filter == null &&
        (ref.watch(offersViewModel).value?.items.isEmpty ?? false);
    return SScaffold(
      title: s.offersTitle,
      // The rows run edge to edge; the filters keep the usual sides.
      padded: false,
      // The first empty list has its own button to post one.
      floating: isOwner && !firstEmpty
          ? SButton(
              label: s.postOffer,
              icon: SIcons.add,
              onPressed: () => context.push(Routes.chooseOfferProduct),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.lg,
              Space.sm,
              Space.lg,
              Space.sm,
            ),
            child: Wrap(
              spacing: Space.sm,
              runSpacing: Space.sm,
              children: [
                for (final (status, label) in [
                  (null, s.allOffers),
                  (OfferStatus.active, s.activeOffers),
                  (OfferStatus.paused, s.pausedOffers),
                  (OfferStatus.ended, s.endedOffers),
                ])
                  SPill(
                    label: label,
                    selected: filter == status,
                    onTap: () => filters.show(status),
                    activeColor: SColor.text,
                  ),
              ],
            ),
          ),
          Expanded(child: _OfferList(isOwner: isOwner)),
        ],
      ),
    );
  }
}

class _OfferList extends AppView {
  const _OfferList({required this.isOwner});

  final bool isOwner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final viewModel = ref.read(offersViewModel.notifier);
    return SAsyncView(
      value: ref.watch(offersViewModel),
      onRetry: () => ref.invalidate(offersViewModel),
      builder: (context, page) {
        if (page.items.isEmpty) {
          if (ref.watch(offerFilterProvider) != null) {
            return SEmptyView(icon: SIcons.offers, title: s.noOffersHere);
          }
          return SEmptyView(
            icon: SIcons.offers,
            title: s.noOffersTitle,
            message: isOwner ? s.noOffersMessage : null,
            actionLabel: isOwner ? s.postOffer : null,
            actionIcon: SIcons.add,
            onAction: () => context.push(Routes.chooseOfferProduct),
          );
        }
        return SPagedList(
          // The offers are cards, apart from each other.
          divided: false,
          itemCount: page.items.length,
          itemBuilder: (context, index) {
            final offer = page.items[index];
            return OfferTile(
              offer: offer,
              trailing: OfferStateBadge(state: offer.state),
              bordered: true,
              onTap: () => context.push(Routes.offer(offer.id)),
            );
          },
          onRefresh: () async {
            final failure = await viewModel.refresh();
            if (failure != null && context.mounted) {
              SSnack.error(context, failureMessage(context, failure));
            }
          },
          onLoadMore: viewModel.loadMore,
          hasMore: page.hasMore,
          loadingMore: page.loadingMore,
          moreFailure: page.moreFailure,
        );
      },
    );
  }
}
