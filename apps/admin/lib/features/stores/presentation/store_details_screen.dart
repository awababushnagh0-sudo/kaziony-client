import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../../../core/routes/routes.dart';
import '../domain/store.dart';
import 'store_details_view_model.dart';

/// One store, ERPNext-style: "Stores / name" with its status, tabs of
/// fields, and a side panel with its logo and key facts.
class StoreDetailsScreen extends AppView {
  const StoreDetailsScreen({required this.storeId, super.key});

  final String storeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final details = ref.watch(storeDetailsProvider(storeId));
    final store = details.value;

    return SScaffold(
      title: store?.name ?? '',
      parent: ScaffoldParent(
        label: s.storesTitle,
        onTap: () => context.go(Routes.stores),
      ),
      status: store == null ? null : _StatusBadge(active: store.isActive),
      padded: false,
      body: SAsyncView(
        value: details,
        onRetry: () => ref.invalidate(storeDetailsProvider(storeId)),
        builder: (context, store) => _StoreRecord(store: store),
      ),
    );
  }
}

class _StoreRecord extends StatelessWidget {
  const _StoreRecord({required this.store});

  final StoreDetails store;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final phone = store.phone;

    return SRecordPage(
      tabs: [
        RecordTab(
          label: s.tabDetails,
          child: SFormSection(
            title: s.tabDetails,
            divider: false,
            child: SFieldGrid(
              columns: 3,
              children: [
                SReadField(label: s.storeName, value: store.name),
                SReadField(
                  label: s.storeCategory,
                  value: store.category.name(locale),
                ),
                SReadField(label: s.storeDescription, value: store.description),
              ],
            ),
          ),
        ),
        RecordTab(
          label: s.tabContact,
          child: SFormSection(
            title: s.tabContact,
            divider: false,
            child: SFieldGrid(
              columns: 3,
              children: [
                SReadField(
                  label: s.storePhone,
                  value: phone == null ? null : formatLibyanPhone(phone),
                  ltr: true,
                ),
                SReadField(
                  label: s.storeFacebook,
                  value: store.facebookUrl,
                  ltr: true,
                ),
                SReadField(
                  label: s.storeInstagram,
                  value: store.instagramUrl,
                  ltr: true,
                ),
              ],
            ),
          ),
        ),
      ],
      sidebar: [
        SRecordProfile(
          title: store.name,
          subtitle: store.category.name(locale),
          imageUrl: store.logoUrl,
        ),
        SRecordFacts([
          RecordFact(s.columnBranches, '${store.branchCount}'),
          RecordFact(s.storeTeam, '${store.teamCount}'),
        ]),
        SRecordFacts([
          RecordFact(
            s.columnAdded,
            formatDate(store.createdAt, languageCode: locale.languageCode),
          ),
        ]),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    return active
        ? SBadge(s.storeActive, tone: BadgeTone.success)
        : SBadge(s.storeDisabled);
  }
}
