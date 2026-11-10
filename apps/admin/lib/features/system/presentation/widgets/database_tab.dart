import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/admin_localizations.dart';
import '../../domain/database_stats.dart';
import '../system_format.dart';
import '../system_view_models.dart';

/// What Postgres says about itself: its size and connections, the queries
/// running long right now, those taking the most time, and its tables.
class DatabaseTab extends AppView {
  const DatabaseTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SAsyncView(
    value: ref.watch(databaseStatsViewModel),
    onRetry: ref.read(databaseStatsViewModel.notifier).reload,
    loading: const SSkeleton.groups(),
    builder: (context, stats) => _Database(stats: stats),
  );
}

class _Database extends StatelessWidget {
  const _Database({required this.stats});

  final DatabaseStats stats;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final cacheHit = stats.cacheHitRatio;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SFigures([
          Figure(
            value: formatBytes(s, stats.sizeBytes),
            label: s.dbSize,
            hint: s.dbVersion(stats.version),
          ),
          Figure(
            value: '${stats.connections}',
            label: s.dbConnections,
            hint: s.dbConnectionsHint(
              stats.activeConnections,
              stats.maxConnections,
            ),
          ),
          Figure(
            value: cacheHit == null ? '–' : formatRatio(s, cacheHit),
            label: s.dbCacheHit,
            hint: s.dbCacheHitHint,
          ),
          Figure(
            value: '${stats.waitingOnLocks + stats.idleInTransaction}',
            label: s.dbWaiting,
            hint: s.dbWaitingHint(
              stats.waitingOnLocks,
              stats.idleInTransaction,
            ),
            quiet: stats.waitingOnLocks + stats.idleInTransaction == 0,
          ),
        ]),
        if (stats.running.isNotEmpty) ...[
          const Gap(Space.xl),
          SSectionHeader(s.dbRunning, note: '${stats.running.length}'),
          const Gap(Space.sm),
          for (final query in stats.running) ...[
            _QueryBox(
              text: query.text,
              subtitle: switch (query.waitingFor) {
                final what? => s.dbRunningWaiting(
                  formatMs(s, query.duration.inMilliseconds),
                  what,
                ),
                null => formatMs(s, query.duration.inMilliseconds),
              },
            ),
            const Gap(Space.sm),
          ],
        ],
        const Gap(Space.xl),
        if (!stats.statementsAvailable)
          SAlert.warning(
            title: s.dbStatementsOff,
            message: s.dbStatementsOffMessage,
          )
        else ...[
          SSectionHeader(s.dbSlowest),
          const Gap(Space.sm),
          for (final query in stats.slowestQueries) ...[
            _QueryBox(
              text: query.text,
              subtitle: s.dbQueryStats(
                query.calls,
                formatMs(s, query.meanMs),
                formatMs(s, query.totalMs),
              ),
            ),
            const Gap(Space.sm),
          ],
        ],
        const Gap(Space.xl),
        SListGroup(
          title: s.dbTables,
          children: [
            for (final table in stats.tables)
              SListTile(
                title: table.name,
                subtitle: s.dbTableRows(table.rows, table.deadRows),
                value: formatBytes(s, table.bytes),
              ),
          ],
        ),
      ],
    );
  }
}

/// A query on one line, opening to all of it.
class _QueryBox extends StatelessWidget {
  const _QueryBox({required this.text, required this.subtitle});

  final String text;
  final String subtitle;

  @override
  Widget build(BuildContext context) => SExpandable(
    title: text.replaceAll(RegExp(r'\s+'), ' ').trim(),
    subtitle: subtitle,
    icon: SIcons.document,
    child: Padding(
      padding: const EdgeInsets.all(Space.lg),
      // SQL reads left to right, in Arabic too.
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SText(text, variant: TextVariant.caption),
      ),
    ),
  );
}
