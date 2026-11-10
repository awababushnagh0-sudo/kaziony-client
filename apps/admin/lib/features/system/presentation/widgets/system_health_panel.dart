import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/admin_localizations.dart';
import '../../domain/system_overview.dart';
import '../system_format.dart';

/// The System page's side panel: whether all is well, the services the
/// API needs, and when it was checked.
class SystemHealthPanel extends StatelessWidget {
  const SystemHealthPanel({required this.overview, super.key});

  final SystemOverview overview;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return SRecordFacts([
      RecordFact(
        s.systemStatus,
        overview.needsAttention ? s.systemNeedsAttention : s.systemAllGood,
      ),
      _fact(s, s.systemTabDatabase, overview.database),
      _fact(s, s.systemRedis, overview.redis),
      RecordFact(s.systemInstances, '${overview.instances.length}'),
      RecordFact(
        s.systemCheckedAt,
        s.systemCheckedAtValue(
          formatTime(overview.checkedAt.toLocal(), languageCode: language),
        ),
      ),
    ]);
  }

  RecordFact _fact(AdminLocalizations s, String label, ServiceCheck check) =>
      switch (check.health) {
        ServiceHealth.up => RecordFact(
          label,
          formatMs(s, check.latencyMs),
          badge: SBadge(s.healthUp, tone: BadgeTone.success),
        ),
        ServiceHealth.down => RecordFact(
          label,
          check.detail ?? s.healthDown,
          badge: SBadge(s.healthDown, tone: BadgeTone.danger),
        ),
        ServiceHealth.off => RecordFact(
          label,
          check.detail ?? s.healthOff,
          badge: SBadge(s.healthOff),
        ),
      };
}
