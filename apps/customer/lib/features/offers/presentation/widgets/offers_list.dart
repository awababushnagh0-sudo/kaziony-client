import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/customer_localizations.dart';
import '../../../../core/widgets/no_offers_view.dart';
import '../offers_view_model.dart';
import 'offer_poster.dart';

/// Offers as cards in a list that scrolls down, a page at a time: the
/// Search tab's results and a home row's "See all".
class OffersList extends AppView {
  const OffersList({required this.initial, super.key});

  /// What the list was opened with; the Search tab changes it through
  /// `offersFilterProvider(initial)`.
  final OffersFilter initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final provider = offersViewModel(initial);
    final viewModel = ref.read(provider.notifier);
    return SAsyncView(
      value: ref.watch(provider),
      onRetry: () => ref.invalidate(provider),
      builder: (context, page) {
        if (page.items.isEmpty) {
          // Nothing for the words typed, or nothing around at all.
          return ref.watch(offersFilterProvider(initial)).search.isEmpty
              ? const NoOffersView()
              : SEmptyView(
                  icon: SIcons.noResults,
                  title: s.noResultsTitle,
                  message: s.noResultsMessage,
                );
        }
        return SPagedList(
          // The offers are cards, apart from each other.
          divided: false,
          itemCount: page.items.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            child: OfferPoster(page.items[index]),
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
        );
      },
    );
  }
}
