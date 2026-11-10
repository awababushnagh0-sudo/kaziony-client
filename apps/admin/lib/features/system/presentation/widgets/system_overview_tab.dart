import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/admin_localizations.dart';
import '../../domain/system_overview.dart';
import '../system_format.dart';

/// The last 5 minutes in a few numbers, then every running instance.
class SystemOverviewTab extends StatelessWidget {
  const SystemOverviewTab({required this.overview, super.key});

  final SystemOverview overview;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final errorRate = overview.errorRate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SFigures([
          Figure(
            value: _number(overview.requestsPerMinute),
            label: s.figureRequestsPerMinute,
            hint: s.figureLast5Minutes,
          ),
          Figure(
            value: errorRate == null ? '–' : formatRatio(s, errorRate),
            label: s.figureServerErrors,
            hint: s.figureServerErrorsHint(overview.serverErrors),
            quiet: overview.serverErrors == 0,
          ),
          Figure(
            value: formatMs(s, overview.p95Ms),
            label: s.figureLatency,
            hint: s.figureLast5Minutes,
          ),
          Figure(
            value: '${overview.errorGroups}',
            label: s.figureErrorKinds,
            hint: s.figureLastDay,
            quiet: overview.errorGroups == 0,
          ),
        ]),
        if (overview.failingJobs > 0) ...[
          const Gap(Space.lg),
          SAlert(title: s.figureFailingJobs(overview.failingJobs)),
        ],
        const Gap(Space.xl),
        SSectionHeader(s.systemInstances, note: '${overview.instances.length}'),
        const Gap(Space.sm),
        for (final instance in overview.instances) ...[
          _InstanceBox(instance: instance),
          const Gap(Space.sm),
        ],
      ],
    );
  }
}

class _InstanceBox extends StatelessWidget {
  const _InstanceBox({required this.instance});

  final SystemInstance instance;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    String when(DateTime date) =>
        formatWhen(date.toLocal(), languageCode: language);
    return SExpandable(
      title: instance.hostname,
      subtitle: s.instanceSubtitle(
        instance.version,
        formatUptime(s, instance.uptime),
      ),
      tag: instance.current ? s.instanceThisOne : null,
      icon: SIcons.device,
      child: Column(
        children: [
          SListTile(
            title: s.instanceRequests,
            value: _number(instance.requestsPerMinute),
          ),
          SListTile(
            title: s.instanceCpu,
            value: s.unitPercent(_number(instance.cpuPercent)),
          ),
          SListTile(
            title: s.instanceMemory,
            subtitle: s.instanceMemoryValue(
              formatBytes(s, instance.memoryBytes),
              formatBytes(s, instance.heapBytes),
            ),
          ),
          SListTile(
            title: s.instanceEventLoop,
            value: formatMs(s, instance.eventLoopDelayMs),
          ),
          SListTile(
            title: s.instanceConnections,
            subtitle: s.instanceConnectionsValue(
              instance.connections,
              instance.idleConnections,
              instance.waitingForConnection,
              instance.maxConnections,
            ),
          ),
          SListTile(
            title: s.instanceStarted,
            subtitle: '${when(instance.startedAt)} · ${instance.nodeVersion}',
          ),
          SListTile(
            title: s.instanceReported,
            value: when(instance.reportedAt),
          ),
        ],
      ),
    );
  }
}

/// One decimal at most: "12.5", "120".
String _number(double value) => value >= 100 || value == value.roundToDouble()
    ? value.round().toString()
    : value.toStringAsFixed(1);
