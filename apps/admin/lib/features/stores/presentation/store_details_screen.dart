import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../../../core/routes/routes.dart';
import '../domain/store.dart';
import 'store_details_view_model.dart';

/// One store, ERPNext-style: "Stores / name" with its status and an
/// actions menu, tabs of fields, and a side panel with its logo and key
/// facts.
class StoreDetailsScreen extends AppStatefulView {
  const StoreDetailsScreen({required this.storeId, super.key});

  final String storeId;

  @override
  AppViewState<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends AppViewState<StoreDetailsScreen> {
  /// An action is on its way; the menu waits for it.
  var _busy = false;

  StoreDetailsViewModel get _viewModel =>
      ref.read(storeDetailsViewModel(widget.storeId).notifier);

  Future<void> _setActive(StoreDetails store, {required bool active}) async {
    final s = AdminLocalizations.of(context);
    if (!active) {
      final confirmed = await SDialog.confirm(
        context,
        title: s.disableStoreTitle(store.name),
        message: s.disableStoreMessage,
        confirmLabel: s.disableStore,
        destructive: true,
      );
      if (!confirmed || !mounted) return;
    }
    setState(() => _busy = true);
    final result = await _viewModel.setActive(active: active);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok():
        SSnack.success(
          context,
          active ? s.storeEnabledDone : s.storeDisabledDone,
        );
      case Err(:final failure):
        SSnack.error(context, failureMessage(context, failure));
    }
  }

  Future<void> _delete(StoreDetails store) async {
    final s = AdminLocalizations.of(context);
    final confirmed = await SDialog.confirm(
      context,
      title: s.deleteStoreTitle(store.name),
      message: s.deleteStoreMessage,
      confirmLabel: s.deleteStore,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    setState(() => _busy = true);
    final result = await _viewModel.delete();
    if (!mounted) return;
    switch (result) {
      case Ok():
        SSnack.success(context, s.storeDeletedDone);
        context.go(Routes.stores);
      case Err(:final failure):
        setState(() => _busy = false);
        SSnack.error(
          context,
          failure is ConflictFailure
              ? s.storeHasOffers
              : failureMessage(context, failure),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final provider = storeDetailsViewModel(widget.storeId);
    final details = ref.watch(provider);
    final store = details.value;

    return SScaffold(
      title: store?.name ?? '',
      parent: ScaffoldParent(
        label: s.storesTitle,
        onTap: () => context.go(Routes.stores),
      ),
      status: store == null ? null : _StatusBadge(active: store.isActive),
      actions: [
        if (store != null)
          _ActionsMenu(
            store: store,
            busy: _busy,
            onSetActive: (active) => _setActive(store, active: active),
            onDelete: () => _delete(store),
          ),
      ],
      padded: false,
      body: SAsyncView(
        value: details,
        onRetry: () => ref.invalidate(provider),
        builder: (context, store) => _StoreRecord(store: store),
      ),
    );
  }
}

/// The "Actions" menu in the header.
class _ActionsMenu extends StatelessWidget {
  const _ActionsMenu({
    required this.store,
    required this.busy,
    required this.onSetActive,
    required this.onDelete,
  });

  final StoreDetails store;
  final bool busy;
  final ValueChanged<bool> onSetActive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    return SMenuButton(
      width: 240,
      entries: [
        if (store.isActive)
          MenuEntry(
            label: s.disableStore,
            description: s.disableStoreHint,
            icon: SIcons.disable,
            onTap: () => onSetActive(false),
          )
        else
          MenuEntry(
            label: s.enableStore,
            icon: SIcons.enable,
            onTap: () => onSetActive(true),
          ),
        null,
        MenuEntry(
          label: s.deleteStore,
          description: s.deleteStoreHint,
          icon: SIcons.delete,
          destructive: true,
          onTap: onDelete,
        ),
      ],
      builder: (context, toggle) =>
          SButton.menu(label: s.storeActions, onPressed: busy ? null : toggle),
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
