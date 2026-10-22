import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../../../core/providers/access.dart';
import '../../../core/record/record_screen.dart';
import '../../../core/routes/routes.dart';
import '../domain/store.dart';
import 'add_store_view_model.dart';
import 'store_details_view_model.dart';
import 'store_form_view_model.dart';

/// One store, ERPNext-style: "Stores / name" with its status and an
/// actions menu, tabs of fields, and a side panel with its logo and key
/// facts. The fields are edited in place (see [RecordScreen]).
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
    return RecordScreen(
      record: storeDetailsViewModel(widget.storeId),
      form: storeFormViewModel(widget.storeId),
      parent: ScaffoldParent(
        label: s.storesTitle,
        onTap: () => context.go(Routes.stores),
      ),
      title: (store) => store.name,
      status: (store) => _StatusBadge(active: store.isActive),
      actions: (store) => [
        _ActionsMenu(
          store: store,
          busy: _busy,
          canDelete: ref.watch(isAdminProvider),
          onSetActive: (active) => _setActive(store, active: active),
          onDelete: () => _delete(store),
        ),
      ],
      builder: (context, store) => _StoreRecord(store: store),
    );
  }
}

/// The "Actions" menu in the header.
class _ActionsMenu extends StatelessWidget {
  const _ActionsMenu({
    required this.store,
    required this.busy,
    required this.canDelete,
    required this.onSetActive,
    required this.onDelete,
  });

  final StoreDetails store;
  final bool busy;

  /// Only admins delete stores.
  final bool canDelete;
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
        if (canDelete) ...[
          null,
          MenuEntry(
            label: s.deleteStore,
            description: s.deleteStoreHint,
            icon: SIcons.delete,
            destructive: true,
            onTap: onDelete,
          ),
        ],
      ],
      builder: (context, toggle) =>
          SButton.menu(label: s.actions, onPressed: busy ? null : toggle),
    );
  }
}

class _StoreRecord extends AppView {
  const _StoreRecord({required this.store});

  final StoreDetails store;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    // The store's own category stays listed even if it was hidden since.
    final categories = [
      store.category,
      for (final category
          in ref.watch(categoriesProvider).value ?? const <Category>[])
        if (category.id != store.category.id) category,
    ];

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
                STextInput(
                  controlName: 'name',
                  label: s.storeName,
                  required: true,
                ),
                SSelectInput<String>(
                  controlName: 'categoryId',
                  label: s.storeCategory,
                  required: true,
                  options: [
                    for (final category in categories)
                      SelectOption(category.id, category.name(locale)),
                  ],
                ),
                STextInput(
                  controlName: 'description',
                  label: s.storeDescription,
                  kind: TextInputKind.multiline,
                ),
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
                STextInput(
                  controlName: 'phone',
                  label: s.storePhone,
                  hint: '0912345678',
                  kind: TextInputKind.phone,
                ),
                STextInput(
                  controlName: 'email',
                  label: s.storeEmail,
                  kind: TextInputKind.email,
                ),
                STextInput(
                  controlName: 'facebookUrl',
                  label: s.storeFacebook,
                  hint: 'https://facebook.com/...',
                  kind: TextInputKind.url,
                ),
                STextInput(
                  controlName: 'instagramUrl',
                  label: s.storeInstagram,
                  hint: 'https://instagram.com/...',
                  kind: TextInputKind.url,
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
