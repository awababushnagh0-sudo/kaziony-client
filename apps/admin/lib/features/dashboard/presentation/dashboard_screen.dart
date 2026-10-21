import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../domain/dashboard_stats.dart';
import 'dashboard_view_model.dart';

/// Home page: the key numbers at a glance.
class DashboardScreen extends AppView {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final stats = ref.watch(dashboardViewModel);
    final viewModel = ref.read(dashboardViewModel.notifier);

    return SScaffold(
      title: s.navHome,
      actions: [
        SButton.icon(
          icon: SIcons.refresh,
          tooltip: s.refresh,
          onPressed: viewModel.reload,
        ),
      ],
      padded: false,
      body: SAsyncView(
        value: stats,
        onRetry: viewModel.reload,
        builder: (context, stats) => _StatsGrid(stats: stats),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final rate = stats.redemptionRate;
    final cards = [
      _StatCard(
        label: s.statsStores,
        value: stats.stores,
        detail: s.statsStoresDetail(stats.activeStores),
        icon: SIcons.store,
      ),
      _StatCard(
        label: s.statsLiveOffers,
        value: stats.liveOffers,
        detail: s.statsLiveOffersDetail(stats.totalOffers),
        icon: SIcons.offers,
      ),
      _StatCard(
        label: s.statsCustomers,
        value: stats.customers,
        detail: s.statsCustomersDetail(stats.newCustomersLast7Days),
        icon: SIcons.users,
      ),
      _StatCard(
        label: s.statsClaims,
        value: stats.claimsLast7Days,
        detail: rate == null
            ? s.statsClaimsNoneFinished
            : s.statsClaimsDetail((rate * 100).round()),
        icon: SIcons.check,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = Space.lg;
        final width = constraints.maxWidth - Space.xl * 2;
        final columns = width >= 1000
            ? 4
            : width >= 520
            ? 2
            : 1;
        final cardWidth = (width - gap * (columns - 1)) / columns;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(Space.xl),
          child: Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final card in cards) SizedBox(width: cardWidth, child: card),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.detail,
    required this.icon,
  });

  final String label;
  final int value;
  final String detail;
  final SIcons icon;

  @override
  Widget build(BuildContext context) => SCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: SText(label, color: SColor.textMuted)),
            SIcon(icon, color: SColor.textMuted),
          ],
        ),
        const Gap(Space.sm),
        SText.display('$value'),
        const Gap(Space.xs),
        SText.caption(detail, maxLines: 1),
      ],
    ),
  );
}
