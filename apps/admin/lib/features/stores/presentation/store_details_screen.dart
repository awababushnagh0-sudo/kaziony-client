import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../../../core/providers/access.dart';
import '../../../core/record/record_screen.dart';
import '../../../core/routes/routes.dart';
import '../domain/store.dart';
import 'add_location_dialog.dart';
import 'add_store_view_model.dart';
import 'store_details_view_model.dart';
import 'store_form_view_model.dart';
import 'store_photos.dart';
import 'widgets/place_fields.dart';

/// One store, ERPNext-style: "Stores / name · area" with its status and an
/// actions menu, tabs of fields (its place among them), and a side panel
/// with its logo and key facts. The fields are edited in place (see
/// [RecordScreen]).
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
      setState(() => _busy = true);
      // Said without them if they can't be read: turning off can't wait.
      final ongoing = (await _viewModel.ongoing()).valueOrNull;
      if (!mounted) return;
      setState(() => _busy = false);
      final confirmed = await SDialog.confirm(
        context,
        title: s.disableStoreTitle(store.label),
        message: [
          s.disableStoreMessage,
          if (ongoing case StoreOngoing(:final liveOffers) when liveOffers > 0)
            s.disableStoreOffers(liveOffers),
          if (ongoing case StoreOngoing(:final openBookings)
              when openBookings > 0)
            s.disableStoreBookings(openBookings),
        ].join('\n\n'),
        confirmLabel: s.disableStore,
        destructive: true,
      );
      if (!confirmed || !mounted) return;
      if (!await _apply(store, active: false)) return;
      // Then whether its customers hear it from us, or keep their bookings.
      final waiting = ongoing?.openBookings ?? 0;
      if (waiting > 0 && ref.read(isAdminProvider) && mounted) {
        await _cancelBookings(store, waiting: waiting);
      }
      return;
    }
    await _apply(store, active: true);
  }

  /// Whether it went through.
  Future<bool> _apply(StoreDetails store, {required bool active}) async {
    final s = AdminLocalizations.of(context);
    setState(() => _busy = true);
    final result = await _viewModel.setActive(active: active);
    if (!mounted) return false;
    setState(() => _busy = false);
    switch (result) {
      case Ok():
        SSnack.success(
          context,
          active ? s.storeEnabledDone : s.storeDisabledDone,
        );
        return true;
      case Err(:final failure):
        SSnack.error(
          context,
          _notReady(context, failure) ?? failureMessage(context, failure),
        );
        return false;
    }
  }

  /// Asks before cancelling the bookings waiting at a store that's off;
  /// [waiting] is how many, read again when not given.
  Future<void> _cancelBookings(StoreDetails store, {int? waiting}) async {
    final s = AdminLocalizations.of(context);
    if (waiting == null) {
      setState(() => _busy = true);
      final ongoing = await _viewModel.ongoing();
      if (!mounted) return;
      setState(() => _busy = false);
      switch (ongoing) {
        case Ok(:final value):
          waiting = value.openBookings;
        case Err(:final failure):
          SSnack.error(context, failureMessage(context, failure));
          return;
      }
      if (waiting == 0) {
        SSnack.success(context, s.noBookingsWaiting);
        return;
      }
    }
    final confirmed = await SDialog.confirm(
      context,
      title: s.cancelStoreBookingsTitle(waiting, store.label),
      message: s.cancelStoreBookingsMessage,
      confirmLabel: s.cancelBookingsConfirm,
      cancelLabel: s.keepBookings,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    setState(() => _busy = true);
    final result = await _viewModel.cancelBookings();
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok(:final value):
        SSnack.success(context, s.bookingsCancelledDone(value));
      case Err(:final failure):
        SSnack.error(context, failureMessage(context, failure));
    }
  }

  Future<void> _delete(StoreDetails store) async {
    final s = AdminLocalizations.of(context);
    final confirmed = await SDialog.confirm(
      context,
      title: s.deleteStoreTitle(store.label),
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

  /// Opens the new store's page once it's added.
  Future<void> _addLocation(StoreDetails store) async {
    final s = AdminLocalizations.of(context);
    final added = await SDialog.show<StoreDetails>(
      context,
      (_) => AddLocationDialog(store: store),
      dismissible: false,
    );
    if (added == null || !mounted) return;
    SSnack.success(context, s.locationAddedDone);
    context.go(Routes.store(added.id));
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
      title: (store) => store.label,
      status: (store) => _StatusBadge(store: store),
      explain: _notReady,
      actions: (store) => [
        _ActionsMenu(
          store: store,
          busy: _busy,
          isAdmin: ref.watch(isAdminProvider),
          onAddLocation: () => _addLocation(store),
          onSetActive: (active) => _setActive(store, active: active),
          onCancelBookings: () => _cancelBookings(store),
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
    required this.isAdmin,
    required this.onAddLocation,
    required this.onSetActive,
    required this.onCancelBookings,
    required this.onDelete,
  });

  final StoreDetails store;
  final bool busy;

  /// Only admins cancel a store's bookings and delete stores.
  final bool isAdmin;
  final VoidCallback onAddLocation;
  final ValueChanged<bool> onSetActive;
  final VoidCallback onCancelBookings;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    return SMenuButton(
      width: 260,
      entries: [
        MenuEntry(
          label: s.addLocation,
          description: s.addLocationHint,
          icon: SIcons.location,
          onTap: onAddLocation,
        ),
        null,
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
            description: store.missingToGoLive.isEmpty
                ? null
                : s.enableStoreNeeds(
                    [
                      for (final item in store.missingToGoLive)
                        goLiveItemName(s, item),
                    ].join(' · '),
                  ),
            icon: SIcons.enable,
            onTap: () => onSetActive(true),
          ),
        if (!store.isActive && isAdmin)
          MenuEntry(
            label: s.cancelStoreBookings,
            description: s.cancelStoreBookingsHint,
            icon: SIcons.bookings,
            onTap: onCancelBookings,
          ),
        if (isAdmin) ...[
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
    final form = ref.read(storeFormViewModel(store.id).notifier).form;
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
                  controlName: 'pickupInstructions',
                  label: s.storePickupInstructions,
                  hint: s.storePickupInstructionsHint,
                  kind: TextInputKind.multiline,
                ),
              ],
            ),
          ),
        ),
        RecordTab(
          label: s.sectionPlace,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SFormSection(
                title: s.sectionPlace,
                child: PlaceFields(form: form, columns: 3),
              ),
              SFormSection(
                title: s.sectionHours,
                note: s.hoursNote,
                divider: false,
                child: const OpeningHoursFields(columns: 4),
              ),
            ],
          ),
        ),
        RecordTab(
          label: s.tabPhotos,
          child: StorePhotos(store: store),
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
                  required: true,
                  hint: '0912345678',
                  helper: s.storePhoneHelp,
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
        if (!store.isActive || store.missingToGoLive.isNotEmpty)
          _GoLiveFacts(missing: store.missingToGoLive),
        SRecordFacts([
          RecordFact(s.storeTeam, '${store.teamCount}'),
          RecordFact(s.storeRating, switch (store.ratingAverage) {
            final average? when store.ratingCount > 0 => s.ratingSummary(
              average,
              store.ratingCount,
            ),
            _ => s.noRatingsYet,
          }),
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

/// Says a store that can't be live yet in our words.
String? _notReady(BuildContext context, AppFailure failure) =>
    failure is ConflictFailure && failure.code == StoreCodes.notReady
    ? AdminLocalizations.of(context).storeNotReady
    : null;

/// What a store needs before customers see it, each added or missing, and
/// where it's set.
class _GoLiveFacts extends StatelessWidget {
  const _GoLiveFacts({required this.missing});

  final List<GoLiveItem> missing;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    RecordFact fact(GoLiveItem item, String where) => RecordFact(
      goLiveItemName(s, item),
      where,
      badge: missing.contains(item)
          ? SBadge(s.goLiveMissing, tone: BadgeTone.warning)
          : SBadge(s.goLiveDone, tone: BadgeTone.success),
    );
    return SRecordFacts([
      RecordFact(s.goLiveTitle, s.goLiveNote),
      fact(GoLiveItem.logo, s.goLiveLogoWhere),
      fact(GoLiveItem.pickupInstructions, s.goLivePickupWhere),
      fact(GoLiveItem.openingHours, s.goLiveHoursWhere),
    ]);
  }
}

/// What a missing item is called, as the side panel lists it.
String goLiveItemName(AdminLocalizations s, GoLiveItem item) => switch (item) {
  GoLiveItem.logo => s.goLiveLogo,
  GoLiveItem.pickupInstructions => s.storePickupInstructions,
  GoLiveItem.openingHours => s.sectionHours,
};

/// Live, off but ready, or off with something missing.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.store});

  final StoreDetails store;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    return switch (store) {
      StoreDetails(isActive: true) => SBadge(
        s.storeActive,
        tone: BadgeTone.success,
      ),
      StoreDetails(missingToGoLive: []) => SBadge(s.storeReadyToGoLive),
      _ => SBadge(s.storeNotReadyBadge, tone: BadgeTone.warning),
    };
  }
}
