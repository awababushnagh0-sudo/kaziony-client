import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/providers/clock.dart';
import '../../../core/widgets/partner_illustrations.dart';
import '../../../core/widgets/reservation_row.dart';
import 'pickups_view_model.dart';

/// Customers on their way, soonest to expire first, with their codes.
/// Tapping one opens the same page as scanning their code, for a customer
/// who gives their name.
class PickupsScreen extends AppView {
  const PickupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final viewModel = ref.read(pickupsViewModel.notifier);
    final now = ref.watch(minuteClockProvider).value ?? DateTime.now();
    return SScaffold(
      title: s.pickupsTitle,
      padded: false,
      body: SAsyncView(
        value: ref.watch(pickupsViewModel),
        onRetry: () => ref.invalidate(pickupsViewModel),
        builder: (context, page) {
          // The server ends reservations that ran out every few minutes;
          // until then they're hidden here.
          final held = [
            for (final claim in page.items)
              if (claim.isHeldAt(now)) claim,
          ];
          if (held.isEmpty && !page.hasMore) {
            return SEmptyView(
              illustration: PartnerIllustrations.noPickups,
              title: s.noPickupsTitle,
              message: s.noPickupsMessage,
              actionLabel: s.refresh,
              onAction: () => ref.invalidate(pickupsViewModel),
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
                  Expanded(child: SText.caption(s.soonestFirst)),
                  SBadge('${page.hasMore ? page.total : held.length}'),
                ],
              ),
            ),
            itemCount: held.length,
            itemBuilder: (context, index) =>
                ReservationRow(held[index], now: now, showCode: true),
            endNote: s.pickupsEndNote,
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
