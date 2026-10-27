import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import 'pickups_view_model.dart';

/// Customers on their way, soonest to expire first. Tapping one opens the
/// same page as scanning their code, for a customer who gives their name.
class PickupsScreen extends AppView {
  const PickupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final viewModel = ref.read(pickupsViewModel.notifier);
    return SScaffold(
      title: s.pickupsTitle,
      padded: false,
      body: SAsyncView(
        value: ref.watch(pickupsViewModel),
        onRetry: () => ref.invalidate(pickupsViewModel),
        builder: (context, page) {
          if (page.items.isEmpty) {
            return SEmptyView(
              icon: SIcons.pickups,
              title: s.noPickupsTitle,
              message: s.noPickupsMessage,
              actionLabel: s.refresh,
              onAction: () => ref.invalidate(pickupsViewModel),
            );
          }
          return SPagedList(
            itemCount: page.items.length,
            itemBuilder: (context, index) {
              final claim = page.items[index];
              return SListTile(
                leading: SImage(claim.offer.thumbUrl),
                title: claim.customerName ?? s.someCustomer,
                subtitle: claim.offer.title,
                value: s.until(
                  formatWhen(claim.expiresAt, languageCode: language),
                ),
                onTap: () => context.push(Routes.claim(claim.code)),
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
      ),
    );
  }
}
