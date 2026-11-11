import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/widgets/request_change_button.dart';
import '../domain/current_store.dart';
import '../domain/store.dart';
import 'edit_opening_hours_view_model.dart';
import 'opening_day_sheet.dart';
import 'store_view_model.dart';
import 'widgets/opening_hours_labels.dart';

/// Where the store is, the way there in the phone's maps, and when it's
/// open. Each of a brand's places is a store of its own, with this page.
/// Owners change the opening hours right here: a day's row opens its
/// times, "Save changes" shows once one changed, and leaving with changes
/// asks first. The place, and new places, are our team's: owners ask for
/// them from here, over WhatsApp. Staff only read it.
class LocationScreen extends AppView {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final isOwner = ref.watch(currentStoreProvider)?.isOwner ?? false;
    final edit = isOwner ? ref.watch(editOpeningHoursViewModel) : null;

    Future<void> save() async {
      final saved = await ref.read(editOpeningHoursViewModel.notifier).save();
      if (saved && context.mounted) SSnack.success(context, s.saved);
    }

    return LeaveGuard(
      active: edit?.changed ?? false,
      confirm: (context) => SDialog.confirm(
        context,
        title: s.discardChangesTitle,
        message: s.discardChangesMessage,
        confirmLabel: s.discardChanges,
        destructive: true,
      ),
      child: SScaffold(
        title: s.locationTitle,
        bottom: edit != null && edit.changed
            ? SButton(
                label: s.saveChanges,
                onPressed: save,
                loading: edit.saving,
                expand: true,
              )
            : null,
        body: SAsyncView(
          value: ref.watch(storeViewModel),
          onRetry: ref.read(storeViewModel.notifier).reload,
          loading: const SSkeleton.groups(groups: 2),
          builder: (context, store) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Place(store),
                const Gap(Space.xl),
                if (edit == null)
                  _Hours(store.openingHours)
                else ...[
                  _EditableHours(edit),
                  const Gap(Space.xl),
                  SText.caption(s.locationTeamHint),
                  const Gap(Space.md),
                  RequestChangeButton(
                    message: s.requestPlaceMessage(store.label),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The city, area and address our team set, and the way there.
class _Place extends AppView {
  const _Place(this.store);

  final Store store;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    String shown(String? value) =>
        value == null || value.isEmpty ? s.notSet : value;
    Future<void> openMaps() async {
      final opened = await ref
          .read(linkOpenerProvider)
          .open(directionsLink(store.location));
      if (!opened && context.mounted) SSnack.error(context, s.linkNotOpened);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.md,
      children: [
        SListGroup(
          children: [
            SFactTile(
              label: s.cityLabel,
              value: switch (store.city) {
                City.tripoli => s.cityTripoli,
                null => s.notSet,
              },
            ),
            SFactTile(label: s.areaLabel, value: shown(store.area)),
            SFactTile(label: s.addressLabel, value: shown(store.address)),
          ],
        ),
        SListGroup(
          children: [
            SListTile(
              icon: SIcons.navigate,
              title: s.openInMaps,
              onTap: openMaps,
            ),
          ],
        ),
      ],
    );
  }
}

/// Staff's hours: each day and its times, nothing to change.
class _Hours extends StatelessWidget {
  const _Hours(this.hours);

  final OpeningHours hours;

  @override
  Widget build(BuildContext context) => SListGroup(
    title: PartnerLocalizations.of(context).openingHoursTitle,
    children: [
      for (final day in Weekday.values)
        SFactTile(
          label: weekdayName(context, day),
          value: dayHoursLabel(context, hours.days[day]),
        ),
    ],
  );
}

/// The owner's hours: each day a row that opens its times.
class _EditableHours extends AppView {
  const _EditableHours(this.edit);

  final EditOpeningHoursState edit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final failure = edit.failure;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.sm,
      children: [
        SListGroup(
          title: s.openingHoursTitle,
          children: [
            for (final day in Weekday.values)
              SListTile(
                title: weekdayName(context, day),
                subtitle: dayHoursLabel(context, edit.hours.days[day]),
                onTap: () => editOpeningDay(context, ref, day),
              ),
          ],
        ),
        SText.caption(s.openingHoursHint),
        if (failure != null)
          SText(switch (failure) {
            ConflictFailure(code: 'StoreNotReady') =>
              s.liveStoreNeedsOpeningHours,
            _ => failureMessage(context, failure),
          }, color: SColor.danger),
      ],
    );
  }
}
