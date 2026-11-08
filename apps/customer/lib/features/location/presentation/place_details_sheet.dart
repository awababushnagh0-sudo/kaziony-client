import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../domain/saved_place.dart';
import 'place_details_view_model.dart';

/// A place's name and how to find it, saved on the customer's account
/// before the sheet closes: asked once the pin of a new place is where it
/// should be ([add]), or changed on a saved one ([edit]), with the way to
/// move it on the map. A failure is said in a snack and the sheet stays.
class PlaceDetailsSheet extends AppView {
  const PlaceDetailsSheet({required this.draft, super.key});

  final PlaceDraft draft;

  /// Names and saves a new place at [point]. True once it's saved.
  static Future<bool> add(BuildContext context, GeoPoint point) async =>
      await SSheet.show<bool>(
        context,
        title: CustomerLocalizations.of(context).placeDetailsTitle,
        builder: (_) => PlaceDetailsSheet(draft: (place: null, point: point)),
      ) ??
      false;

  /// Changes [place].
  static Future<void> edit(BuildContext context, SavedPlace place) =>
      SSheet.show<void>(
        context,
        title: CustomerLocalizations.of(context).editPlaceTitle,
        builder: (_) =>
            PlaceDetailsSheet(draft: (place: place, point: place.point)),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final provider = placeDetailsViewModel(draft);
    // Watched so the form lives as long as the sheet.
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final editing = draft.place != null;

    Future<void> save() async {
      final details = viewModel.submit();
      if (details == null) return;
      final failure = await viewModel.save(details);
      if (!context.mounted) return;
      if (failure != null) {
        SSnack.error(context, failureMessage(context, failure));
        return;
      }
      SSnack.success(context, editing ? s.placeUpdated : s.placeSaved);
      Navigator.pop(context, true);
    }

    Future<void> move() async {
      final moved = await context.push<GeoPoint>(
        Routes.placeMap,
        extra: state.point,
      );
      if (moved != null) viewModel.moveTo(moved);
    }

    return SForm(
      form: viewModel.form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.lg,
        children: [
          STextInput(
            controlName: 'name',
            label: s.placeNameLabel,
            hint: s.placeNameHint,
            maxLength: PlaceDetailsViewModel.nameMaxLength,
            required: true,
            // A new place has no name yet; a saved one is opened to look.
            autofocus: !editing,
          ),
          STextInput(
            controlName: 'note',
            label: s.placeNoteLabel,
            hint: s.placeNoteHint,
            kind: TextInputKind.multiline,
            maxLength: PlaceDetailsViewModel.noteMaxLength,
          ),
          if (editing)
            SListGroup(
              children: [
                SListTile(
                  icon: SIcons.location,
                  title: s.placeOnMap,
                  value: viewModel.moved ? s.placeMoved : null,
                  onTap: move,
                ),
              ],
            ),
          SButton(
            label: s.savePlace,
            expand: true,
            loading: state.saving,
            onPressed: save,
          ),
        ],
      ),
    );
  }
}
