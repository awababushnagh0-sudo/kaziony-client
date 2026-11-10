import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import 'system_view_models.dart';
import 'widgets/database_tab.dart';
import 'widgets/system_errors_tab.dart';
import 'widgets/system_health_panel.dart';
import 'widgets/system_jobs_tab.dart';
import 'widgets/system_overview_tab.dart';
import 'widgets/system_traffic_tab.dart';

/// How the backend is doing, for admins: its services and instances, its
/// traffic, our errors, the scheduled jobs and the database. Each tab
/// reloads itself while it's open.
class SystemScreen extends AppView {
  const SystemScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final overview = ref.watch(systemOverviewViewModel);

    Future<void> refresh() async {
      // Only the tab on screen is loaded; the others aren't listened to.
      final failures = await Future.wait([
        ref.read(systemOverviewViewModel.notifier).refreshNow(),
        if (ref.exists(systemTrafficViewModel))
          ref.read(systemTrafficViewModel.notifier).refreshNow(),
        if (ref.exists(systemErrorsViewModel))
          ref.read(systemErrorsViewModel.notifier).refreshNow(),
        if (ref.exists(systemJobsViewModel))
          ref.read(systemJobsViewModel.notifier).refreshNow(),
        if (ref.exists(databaseStatsViewModel))
          ref.read(databaseStatsViewModel.notifier).refreshNow(),
      ]);
      final failure = failures.nonNulls.firstOrNull;
      if (failure != null && context.mounted) {
        SSnack.error(context, failureMessage(context, failure));
      }
    }

    return SScaffold(
      title: s.systemTitle,
      actions: [
        SButton.icon(
          icon: SIcons.refresh,
          tooltip: s.refresh,
          onPressed: refresh,
        ),
      ],
      padded: false,
      body: SAsyncView(
        value: overview,
        onRetry: ref.read(systemOverviewViewModel.notifier).reload,
        loading: const SSkeleton.page(),
        builder: (context, overview) => SRecordPage(
          tabs: [
            RecordTab(
              label: s.systemTabOverview,
              child: SystemOverviewTab(overview: overview),
            ),
            RecordTab(
              label: s.systemTabTraffic,
              child: const SystemTrafficTab(),
            ),
            RecordTab(label: s.systemTabErrors, child: const SystemErrorsTab()),
            RecordTab(label: s.systemTabJobs, child: const SystemJobsTab()),
            RecordTab(label: s.systemTabDatabase, child: const DatabaseTab()),
          ],
          sidebar: [SystemHealthPanel(overview: overview)],
        ),
      ),
    );
  }
}
