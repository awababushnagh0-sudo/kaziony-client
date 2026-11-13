import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/reservation_row.dart';
import '../domain/claim.dart';
import 'deliveries_view_model.dart';

/// Bookings out with the store's drivers, the longest out first. Tapping
/// one opens its page, to say it was delivered or that it didn't happen.
class DeliveriesScreen extends AppView {
  const DeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final viewModel = ref.read(deliveriesViewModel.notifier);
    final now = ref.watch(minuteClockProvider).value ?? ServerClock.now();
    return SScaffold(
      title: s.deliveriesTitle,
      padded: false,
      body: SAsyncView(
        value: ref.watch(deliveriesViewModel),
        onRetry: () => ref.invalidate(deliveriesViewModel),
        loading: const SSkeleton.list(),
        builder: (context, page) {
          if (page.items.isEmpty) {
            return SEmptyView(
              icon: SIcons.delivery,
              title: s.noDeliveriesTitle,
              message: s.noDeliveriesMessage,
              actionLabel: s.refresh,
              onAction: () => ref.invalidate(deliveriesViewModel),
            );
          }
          return SPagedList(
            header: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                Space.lg,
                Space.sm,
                Space.lg,
                Space.xs,
              ),
              child: Row(
                children: [
                  Expanded(child: SText.caption(s.longestOutFirst)),
                  SBadge('${page.total}'),
                ],
              ),
            ),
            itemCount: page.items.length,
            itemBuilder: (context, index) =>
                _DeliveryRow(page.items[index], now: now),
            endNote: s.deliveriesEndNote,
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
            placeholder: const SSkeleton.list(rows: 1),
          );
        },
      ),
    );
  }
}

/// Who, what, and how long it's been out, in orange once it's been out
/// long enough to ask the driver.
class _DeliveryRow extends StatelessWidget {
  const _DeliveryRow(this.claim, {required this.now});

  /// Out this long, a delivery has likely happened: time to close it.
  static const _askAfter = Duration(hours: 2);

  final Claim claim;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final out = now.difference(claim.sentForDeliveryAt ?? now);
    return SListTile(
      title: claim.customerName ?? s.someCustomer,
      subtitle: claimItemLabel(claim),
      trailing: STag(timeLeftLabel(s, out), hot: out >= _askAfter),
      onTap: () => context.push(Routes.claim(claim.code, fromList: true)),
    );
  }
}
