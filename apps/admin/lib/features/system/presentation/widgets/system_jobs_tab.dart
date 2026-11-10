import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/admin_localizations.dart';
import '../../domain/system_job.dart';
import '../system_format.dart';
import '../system_view_models.dart';

/// The scheduled jobs: what each does, when it runs, how its last run went
/// and what's waiting for the next. Any can be run now.
class SystemJobsTab extends AppStatefulView {
  const SystemJobsTab({super.key});

  @override
  AppViewState<SystemJobsTab> createState() => _SystemJobsTabState();
}

class _SystemJobsTabState extends AppViewState<SystemJobsTab> {
  /// The job being run from here, for its button's spinner.
  String? _running;

  Future<void> _run(SystemJob job) async {
    final s = AdminLocalizations.of(context);
    setState(() => _running = job.name);
    final failure = await ref.read(systemJobsViewModel.notifier).run(job.name);
    if (!mounted) return;
    setState(() => _running = null);
    if (failure != null) {
      SSnack.error(
        context,
        failure is ConflictFailure && failure.code == 'JobRunning'
            ? s.jobAlreadyRunning
            : failureMessage(context, failure),
      );
      return;
    }
    final ran = ref
        .read(systemJobsViewModel)
        .value
        ?.firstWhere((each) => each.name == job.name);
    if (ran?.lastOutcome == JobOutcome.failed) {
      SSnack.error(context, s.jobRanFailed);
    } else {
      SSnack.success(
        context,
        s.jobRan(formatMs(s, ran?.lastDuration?.inMilliseconds)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    return SAsyncView(
      value: ref.watch(systemJobsViewModel),
      onRetry: ref.read(systemJobsViewModel.notifier).reload,
      loading: const SSkeleton.groups(),
      builder: (context, jobs) => jobs.isEmpty
          ? SEmptyView(title: s.jobsEmpty, icon: SIcons.clock)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final job in jobs) ...[
                  _JobCard(
                    job: job,
                    running: _running == job.name,
                    onRun: _running == null && !job.running
                        ? () => _run(job)
                        : null,
                  ),
                  const Gap(Space.md),
                ],
              ],
            ),
    );
  }
}

class _JobCard extends StatelessWidget {
  const _JobCard({
    required this.job,
    required this.running,
    required this.onRun,
  });

  final SystemJob job;
  final bool running;
  final VoidCallback? onRun;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    String when(DateTime date) =>
        formatWhen(date.toLocal(), languageCode: language);
    final (description, backlogLabel) = _words(s, job);
    final next = job.nextRunAt;
    final started = job.lastStartedAt;
    final backlog = job.backlog;
    final error = job.lastError;
    return SCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: SText(
                  job.name,
                  variant: TextVariant.subtitle,
                  weight: SFontWeight.semibold,
                ),
              ),
              _StatusBadge(job: job),
              const Gap(Space.md),
              SButton.secondary(
                label: s.jobRunNow,
                loading: running,
                onPressed: onRun,
              ),
            ],
          ),
          const Gap(Space.xs),
          SText.caption(description),
          const Gap(Space.md),
          SRecordFacts([
            RecordFact(s.jobSchedule, job.schedule ?? s.jobByHand),
            if (next != null) RecordFact(s.jobNextRun, when(next)),
            if (started != null)
              RecordFact(
                s.jobLastRun,
                s.jobLastRunValue(
                  when(started),
                  formatMs(s, job.lastDuration?.inMilliseconds),
                ),
              ),
            if (job.lastResult.isNotEmpty)
              RecordFact(
                s.jobLastResult,
                [
                  for (final MapEntry(:key, :value) in job.lastResult.entries)
                    '$key: $value',
                ].join(' · '),
              ),
            if (backlog != null && backlogLabel != null)
              RecordFact(backlogLabel, '$backlog'),
            RecordFact(s.jobRuns, s.jobRunsValue(job.runs, job.failures)),
          ]),
          if (error != null && job.lastOutcome == JobOutcome.failed) ...[
            const Gap(Space.md),
            SAlert(title: s.jobLastError, message: error),
          ],
        ],
      ),
    );
  }
}

/// Our words for the jobs we know; the server's (English) for the others.
(String, String?) _words(AdminLocalizations s, SystemJob job) =>
    switch (job.name) {
      'expire-claims' => (s.jobExpireClaims, s.jobExpireClaimsBacklog),
      'clean-refresh-tokens' => (s.jobCleanTokens, s.jobCleanTokensBacklog),
      'clean-search-terms' => (
        s.jobCleanSearchTerms,
        s.jobCleanSearchTermsBacklog,
      ),
      _ => (job.description, job.backlogLabel),
    };

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.job});

  final SystemJob job;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    if (job.running) return SBadge(s.jobRunning, tone: BadgeTone.warning);
    return switch (job.lastOutcome) {
      JobOutcome.succeeded => SBadge(s.jobSucceeded, tone: BadgeTone.success),
      JobOutcome.failed => SBadge(s.jobFailed, tone: BadgeTone.danger),
      null => SBadge(s.jobNeverRun),
    };
  }
}
