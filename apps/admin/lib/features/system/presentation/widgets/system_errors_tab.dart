import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/admin_localizations.dart';
import '../../domain/system_error.dart';
import '../system_view_models.dart';

/// Our server errors of the last 24 hours, most recent first: each one
/// opens to where it happened and the request id that finds its logs.
class SystemErrorsTab extends AppView {
  const SystemErrorsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    return SAsyncView(
      value: ref.watch(systemErrorsViewModel),
      onRetry: ref.read(systemErrorsViewModel.notifier).reload,
      loading: const SSkeleton.list(),
      builder: (context, errors) => errors.isEmpty
          ? SEmptyView(
              title: s.errorsEmpty,
              message: s.errorsEmptyMessage,
              icon: SIcons.success,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final error in errors) ...[
                  _ErrorBox(error: error),
                  const Gap(Space.sm),
                ],
              ],
            ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.error});

  final SystemError error;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    String when(DateTime date) =>
        formatWhen(date.toLocal(), languageCode: language);
    final requestId = error.lastRequestId;
    final stack = error.stack;
    return SExpandable(
      title: '${error.name}: ${error.message}',
      subtitle: s.errorSubtitle(
        '${error.method} ${error.route}',
        s.errorTimes(error.count),
        when(error.lastSeenAt),
      ),
      tag: '${error.statusCode}',
      icon: SIcons.error,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SListTile(title: s.errorFirstSeen, value: when(error.firstSeenAt)),
          SListTile(title: s.errorLastSeen, value: when(error.lastSeenAt)),
          SListTile(title: s.systemInstances, value: '${error.instances}'),
          if (requestId != null)
            Padding(
              padding: const EdgeInsets.all(Space.lg),
              child: SCopyField(label: s.errorRequestId, value: requestId),
            ),
          if (stack != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: Space.lg,
                end: Space.lg,
                bottom: Space.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SText.caption(s.errorStack),
                  const Gap(Space.xs),
                  // Code reads left to right, in Arabic too.
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: SText(stack, variant: TextVariant.caption),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
