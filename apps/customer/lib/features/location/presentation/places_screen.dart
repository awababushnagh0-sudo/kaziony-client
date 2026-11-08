import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/sign_in_prompt.dart';
import '../domain/browse_location.dart';
import '../domain/saved_place.dart';
import 'location_screen.dart';
import 'location_view_model.dart';
import 'place_details_sheet.dart';
import 'saved_places_view_model.dart';

/// Where offers are shown from, to switch: where the phone is now, and the
/// places saved on the customer's account, each to change or delete, with
/// a floating button to add one (signing in first). Switching and deleting
/// are confirmed first. Neither the place in use nor the last one can be
/// deleted.
class PlacesScreen extends AppView {
  const PlacesScreen({super.key});

  /// Opens this page, or, with no saved place to switch to (a guest has
  /// none), the page that asks where the phone is or for a spot on the
  /// map. The tabs keep the places loaded, so this knows at once.
  static void open(BuildContext context, WidgetRef ref) {
    final none = ref.read(savedPlacesViewModel).value?.isEmpty ?? false;
    context.push(none ? Routes.location : Routes.places);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final location = ref.watch(browseLocationProvider);
    final places = ref.watch(savedPlacesViewModel);
    final signedIn = ref.watch(sessionProvider) is SignedIn;
    final state = ref.watch(locationViewModel);
    final viewModel = ref.read(locationViewModel.notifier);
    final message = locationStateMessage(context, state);

    /// Asks before offers move to [name]; back home once they have.
    Future<void> switchTo(String name, Future<bool> Function() use) async {
      final sure = await SDialog.confirm(
        context,
        title: s.switchPlaceTitle,
        message: s.switchPlaceMessage(name),
        confirmLabel: s.switchPlace,
      );
      if (sure && await use() && context.mounted) context.pop();
    }

    Future<void> delete(SavedPlace place) async {
      final sure = await SDialog.confirm(
        context,
        title: s.deletePlaceTitle(place.name),
        message: s.deletePlaceMessage,
        confirmLabel: s.deletePlace,
        destructive: true,
      );
      if (!sure || !context.mounted) return;
      final failure = await ref
          .read(savedPlacesViewModel.notifier)
          .remove(place);
      if (!context.mounted) return;
      if (failure == null) {
        SSnack.success(context, s.placeDeleted);
      } else {
        SSnack.error(context, failureMessage(context, failure));
      }
    }

    void add() {
      if (!signedIn) {
        SignInPrompt.show(
          context,
          title: s.placesSignInTitle,
          message: s.addPlaceMessage,
        );
        return;
      }
      context.push(Routes.addPlace);
    }

    final mine = location?.pinned == false;
    final full = (places.value?.length ?? 0) >= SavedPlacesViewModel.max;
    return SScaffold(
      title: s.placesTitle,
      scrollable: true,
      floating: places.isLoading || full
          ? null
          : SButton(label: s.addPlace, icon: SIcons.add, onPressed: add),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.sm,
        children: [
          SRadioTile(
            title: s.myLocation,
            subtitle: state.finding ? s.findingLocation : null,
            selected: mine,
            onTap: () {
              if (!mine) switchTo(s.myLocation, viewModel.useMyLocation);
            },
          ),
          if (message != null) ...[
            SText(message, color: SColor.danger),
            if (state.problem?.needsSettings ?? false)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: SButton.text(
                  label: StellarLocalizations.of(context).openSettings,
                  onPressed: viewModel.openSettings,
                ),
              ),
          ],
          SAsyncView(
            value: places,
            onRetry: () => ref.invalidate(savedPlacesViewModel),
            loading: const SSkeleton.list(rows: 2, leading: false),
            builder: (context, places) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: Space.sm,
              children: [
                for (final place in places)
                  _PlaceTile(
                    place: place,
                    inUse: location?.placeId == place.id,
                    // The last place stays: there's always one to go back
                    // to.
                    canDelete: places.length > 1,
                    onUse: () => switchTo(place.name, () async {
                      await viewModel.useSaved(place);
                      return true;
                    }),
                    onDelete: () => delete(place),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A saved place: chosen when offers are shown from it, with a pencil to
/// change it and, unless it's in use or the last one, a bin.
class _PlaceTile extends StatelessWidget {
  const _PlaceTile({
    required this.place,
    required this.inUse,
    required this.canDelete,
    required this.onUse,
    required this.onDelete,
  });

  final SavedPlace place;
  final bool inUse;
  final bool canDelete;
  final VoidCallback onUse;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => SRadioTile(
    title: place.name,
    subtitle: place.note,
    selected: inUse,
    onTap: () {
      if (!inUse) onUse();
    },
    onEdit: () => PlaceDetailsSheet.edit(context, place),
    onDelete: canDelete && !inUse ? onDelete : null,
  );
}
