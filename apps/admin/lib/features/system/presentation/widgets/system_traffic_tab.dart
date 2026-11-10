import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/admin_localizations.dart';
import '../../domain/system_traffic.dart';
import '../system_format.dart';
import '../system_view_models.dart';

/// Requests minute by minute (errors in red), then each route: how often
/// it's called, how fast it answers, how often it fails.
class SystemTrafficTab extends AppView {
  const SystemTrafficTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final minutes = ref.watch(trafficWindowViewModel);
    final traffic = ref.watch(systemTrafficViewModel);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (final choice in TrafficWindowViewModel.choices) ...[
              SPill(
                label: s.trafficWindow(choice),
                selected: choice == minutes,
                onTap: () =>
                    ref.read(trafficWindowViewModel.notifier).choose(choice),
              ),
              const Gap(Space.sm),
            ],
          ],
        ),
        const Gap(Space.lg),
        SAsyncView(
          value: traffic,
          onRetry: ref.read(systemTrafficViewModel.notifier).reload,
          loading: const SSkeleton.groups(groups: 2),
          builder: (context, traffic) => _Traffic(traffic: traffic),
        ),
      ],
    );
  }
}

class _Traffic extends StatelessWidget {
  const _Traffic({required this.traffic});

  final SystemTraffic traffic;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SCard(
          child: SBarChart(
            summary: s.trafficSummary(
              traffic.requests,
              traffic.serverErrors,
              traffic.minutes.length,
            ),
            startLabel: s.trafficMinutesAgo(traffic.minutes.length),
            endLabel: s.trafficNow,
            bars: [
              for (final minute in traffic.minutes)
                ChartBar(
                  value: minute.requests.toDouble(),
                  alert: minute.serverErrors.toDouble(),
                  label: s.trafficBar(
                    formatTime(minute.at.toLocal(), languageCode: language),
                    minute.requests,
                    minute.serverErrors,
                  ),
                ),
            ],
          ),
        ),
        const Gap(Space.xl),
        if (traffic.routes.isEmpty)
          SEmptyView(
            title: s.trafficEmpty,
            message: s.trafficEmptyMessage,
            icon: SIcons.chart,
          )
        else
          SListGroup(
            title: s.trafficRoutes,
            children: [
              for (final route in traffic.routes) _RouteRow(route: route),
            ],
          ),
      ],
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({required this.route});

  final RouteTraffic route;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final latency = s.trafficRouteLatency(
      formatMs(s, route.p50Ms),
      formatMs(s, route.p95Ms),
      formatMs(s, route.p99Ms),
    );
    final failed = route.serverErrors > 0 || route.clientErrors > 0;
    return SListTile(
      title: '${route.method} ${route.route}',
      subtitle: failed
          ? s.trafficRouteErrors(
              latency,
              route.serverErrors,
              route.clientErrors,
            )
          : latency,
      value: '${route.requests}',
    );
  }
}
