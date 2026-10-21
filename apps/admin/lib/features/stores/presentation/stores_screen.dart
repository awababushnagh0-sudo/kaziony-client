import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../../../core/list/paged_table.dart';
import '../../../core/routes/routes.dart';
import '../domain/store.dart';
import 'add_store_dialog.dart';
import 'store_created_dialog.dart';
import 'stores_view_model.dart';

/// All stores, ERPNext-style: search and filter, a table, a pager, and
/// "Add store".
class StoresScreen extends AppView {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);

    Future<void> addStore() async {
      final created = await SDialog.show<CreatedStore>(
        context,
        (_) => const AddStoreDialog(),
        dismissible: false,
      );
      if (created == null || !context.mounted) return;
      ref.invalidate(storePageProvider);
      await SDialog.show<void>(
        context,
        (_) => StoreCreatedDialog(store: created),
        dismissible: false,
      );
    }

    return SScaffold(
      title: s.storesTitle,
      padded: false,
      actions: [
        SButton(label: s.addStore, icon: SIcons.add, onPressed: addStore),
      ],
      body: PagedTable<StoreSummary, StoreStatus>(
        query: storeQueryProvider,
        page: storePageProvider,
        searchHint: s.storesSearch,
        filters: [
          (StoreStatus.active, s.filterActive),
          (StoreStatus.disabled, s.filterDisabled),
        ],
        totalLabel: s.storesTotal,
        columns: _columns(context),
        onOpen: (store) => context.go(Routes.store(store.id)),
        empty: SEmptyView(
          title: s.storesEmpty,
          message: s.storesEmptyMessage,
          icon: SIcons.store,
          actionLabel: s.addStore,
          onAction: addStore,
        ),
      ),
    );
  }

  List<TableColumn<StoreSummary>> _columns(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return [
      TableColumn(
        label: s.columnName,
        flex: 3,
        cell: (store) => SCellText(store.name, strong: true),
      ),
      TableColumn(
        label: s.columnCategory,
        minWidth: 520,
        cell: (store) => SCellText(store.category.name(locale)),
      ),
      TableColumn(
        label: s.columnBranches,
        flex: 1,
        minWidth: 760,
        cell: (store) => SCellText('${store.branchCount}'),
      ),
      TableColumn(
        label: s.columnStatus,
        cell: (store) => Align(
          alignment: AlignmentDirectional.centerStart,
          child: store.isActive
              ? SBadge(s.storeActive, tone: BadgeTone.success)
              : SBadge(s.storeDisabled),
        ),
      ),
      TableColumn(
        label: s.columnAdded,
        minWidth: 640,
        cell: (store) => SCellText(
          formatDate(store.createdAt, languageCode: locale.languageCode),
        ),
      ),
    ];
  }
}
