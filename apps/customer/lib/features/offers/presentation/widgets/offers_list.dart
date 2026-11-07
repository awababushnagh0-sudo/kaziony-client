import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/customer_localizations.dart';
import '../../../../core/widgets/customer_illustrations.dart';
import '../../../../core/widgets/no_offers_view.dart';
import '../../domain/offer.dart';
import '../offers_layout.dart';
import '../offers_view_model.dart';
import 'offer_card.dart';
import 'offer_card_skeleton.dart';

/// Offers in a list that scrolls down, a page at a time, as cards or tiles
/// as the customer picked (`OffersLayoutSwitch`): a home row's "See all".
class OffersList extends AppView {
  const OffersList({required this.initial, super.key});

  /// What the list was opened with; its filter is
  /// `offersFilterProvider(initial)`.
  final OffersFilter initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final provider = offersViewModel(initial);
    return SAsyncView(
      value: ref.watch(provider),
      onRetry: () => ref.invalidate(provider),
      loading: OfferListSkeleton(
        tiles:
            ref.watch(offersLayoutProvider(OffersPlace.lists)) ==
            OffersLayout.list,
      ),
      builder: (context, page) {
        if (page.items.isEmpty) {
          // Nothing for the words typed, or nothing around at all.
          return ref.watch(offersFilterProvider(initial)).search.isEmpty
              ? const NoOffersView()
              : SEmptyView(
                  illustration: CustomerIllustrations.noResults,
                  title: s.noResultsTitle,
                  message: s.noResultsMessage,
                );
        }
        return OffersPagedList(offers: provider, page: page);
      },
    );
  }
}

/// The offers [offers] has loaded ([page]), as cards or tiles, loading
/// more near the end and again when pulled down; [header] scrolls above
/// them (the Search tab's stores and filters).
class OffersPagedList extends AppView {
  const OffersPagedList({
    required this.offers,
    required this.page,
    this.header,
    this.onOpen,
    super.key,
  });

  final AsyncNotifierProvider<OffersViewModel, PagedItems<Offer>> offers;
  final PagedItems<Offer> page;
  final Widget? header;

  /// Told when an offer is opened, before its page shows.
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(offers.notifier);
    final tiles =
        ref.watch(offersLayoutProvider(OffersPlace.lists)) == OffersLayout.list;
    return SPagedList(
      // The offers are cards, apart from each other.
      divided: false,
      header: header,
      itemCount: page.items.length,
      itemBuilder: (context, index) => Padding(
        // Cards and tiles alike are raised: room apart for their shadows.
        padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.md),
        child: OfferCard(
          page.items[index],
          shape: tiles ? OfferCardShape.tile : OfferCardShape.card,
          onOpen: onOpen,
        ),
      ),
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
      placeholder: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.lg),
        child: OfferCardSkeleton(
          shape: tiles ? OfferCardShape.tile : OfferCardShape.card,
        ),
      ),
    );
  }
}
