import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../../../core/list/paged_table.dart';
import '../domain/activity_entry.dart';
import 'activity_entry_dialog.dart';
import 'activity_texts.dart';
import 'activity_view_model.dart';

/// Every change made in the dashboard, the latest first: who made it, what
/// it was and what it was done to. Each opens to what was sent. Only
/// admins see it.
class ActivityScreen extends AppView {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return SScaffold(
      title: s.activityTitle,
      padded: false,
      body: PagedTable<ActivityEntry, ActivityArea>(
        query: activityQueryProvider,
        page: activityPageProvider,
        searchHint: s.activitySearch,
        filters: [
          (ActivityArea.stores, s.navStores),
          (ActivityArea.users, s.navUsers),
          (ActivityArea.categories, s.navCategories),
          (ActivityArea.serviceAreas, s.activityAreaServiceAreas),
          (ActivityArea.settings, s.activityAreaSettings),
          (ActivityArea.offers, s.navOffers),
          (ActivityArea.jobs, s.activityAreaJobs),
        ],
        totalLabel: s.activityTotal,
        onOpen: (entry) => SDialog.show<void>(
          context,
          (_) => ActivityEntryDialog(entry: entry),
        ),
        columns: [
          TableColumn(
            label: s.columnWhen,
            cell: (entry) => SCellText(
              formatWhen(entry.createdAt.toLocal(), languageCode: language),
            ),
          ),
          TableColumn(
            label: s.columnWho,
            cell: (entry) =>
                SCellText(entry.actorName ?? s.activityRemovedAccount),
          ),
          TableColumn(
            label: s.columnWhat,
            flex: 2,
            cell: (entry) =>
                SCellText(activityActionText(s, entry), strong: true),
          ),
          TableColumn(
            label: s.columnItem,
            flex: 2,
            cell: (entry) => SCellText(entry.targetLabel ?? ''),
          ),
          TableColumn(
            label: s.columnFields,
            flex: 2,
            minWidth: 720,
            cell: (entry) => SCellText(activityFieldsText(entry)),
          ),
        ],
        empty: SEmptyView(
          title: s.activityEmpty,
          message: s.activityEmptyMessage,
          icon: SIcons.clock,
        ),
      ),
    );
  }
}
