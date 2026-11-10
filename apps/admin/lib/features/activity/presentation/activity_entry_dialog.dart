import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../domain/activity_entry.dart';
import 'activity_texts.dart';

/// One change in full: who, when, what it was done to, everything that was
/// sent, and the request id that finds it in the logs.
class ActivityEntryDialog extends StatelessWidget {
  const ActivityEntryDialog({required this.entry, super.key});

  final ActivityEntry entry;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final target = entry.targetLabel;
    final requestId = entry.requestId;
    return SDialog(
      title: activityActionText(s, entry),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SListGroup(
            children: [
              SFactTile(
                label: s.columnWho,
                value: entry.actorName ?? s.activityRemovedAccount,
              ),
              SFactTile(
                label: s.columnWhen,
                value: formatDateTime(
                  entry.createdAt.toLocal(),
                  languageCode: language,
                ),
              ),
              if (target != null) SFactTile(label: s.columnItem, value: target),
            ],
          ),
          const Gap(Space.lg),
          if (entry.changes.isEmpty)
            SText.caption(s.activityNothingSent)
          else
            SListGroup(
              title: s.activitySent,
              children: [
                for (final change in entry.changes)
                  SFactTile(label: change.field, value: change.value ?? '—'),
              ],
            ),
          if (requestId != null) ...[
            const Gap(Space.lg),
            SCopyField(label: s.activityRequestId, value: requestId),
          ],
        ],
      ),
    );
  }
}
