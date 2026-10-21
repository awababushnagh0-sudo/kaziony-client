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

    return AppScaffold(
      title: s.navHome,
      actions: [
        AppIconButton(
          icon: AppIcon.refresh,
          tooltip: s.refresh,
          onPressed: viewModel.reload,
        ),
      ],
      padded: false,
      body: AppAsyncView(
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
        icon: AppIcon.store,
      ),
      _StatCard(
        label: s.statsLiveOffers,
        value: stats.liveOffers,
        detail: s.statsLiveOffersDetail(stats.totalOffers),
        icon: AppIcon.offers,
      ),
      _StatCard(
        label: s.statsCustomers,
        value: stats.customers,
        detail: s.statsCustomersDetail(stats.newCustomersLast7Days),
        icon: AppIcon.users,
      ),
      _StatCard(
        label: s.statsClaims,
        value: stats.claimsLast7Days,
        detail: rate == null
            ? s.statsClaimsNoneFinished
            : s.statsClaimsDetail((rate * 100).round()),
        icon: AppIcon.check,
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
  final AppIcon icon;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: AppText(label, tone: TextTone.muted)),
            AppIconView(icon, tone: TextTone.muted),
          ],
        ),
        const Gap(Space.sm),
        AppText.display('$value'),
        const Gap(Space.xs),
        AppText.caption(detail, maxLines: 1),
      ],
    ),
  );
}
