import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../domain/saved_place.dart';
import 'saved_places_view_model.dart';

/// The place being named: a new one at [point] (set on the map), or a
/// saved [place] to change, starting at its point.
typedef PlaceDraft = ({SavedPlace? place, GeoPoint point});

/// Where the place is ([point], moved on the map for a saved one) and
/// whether it's being saved.
typedef PlaceDetailsState = ({GeoPoint point, bool saving});

/// Naming a place ("home", "work", "grandma's"), with an optional
/// description ("second floor, across from the mosque"), then saving it on
/// the customer's account: a new one, or a saved one changed.
class PlaceDetailsViewModel extends ViewModel<PlaceDetailsState> {
  PlaceDetailsViewModel(this.draft);

  static const nameMaxLength = 30;
  static const noteMaxLength = 80;

  final PlaceDraft draft;

  late final FormGroup form;

  @override
  PlaceDetailsState build() {
    form = FormGroup({
      'name': FormControl<String>(
        value: draft.place?.name,
        validators: [Validators.required, Validators.maxLength(nameMaxLength)],
      ),
      'note': FormControl<String>(
        value: draft.place?.note,
        validators: [Validators.maxLength(noteMaxLength)],
      ),
    });
    ref.onDispose(form.dispose);
    return (point: draft.point, saving: false);
  }

  /// Whether the saved place was set somewhere else on the map.
  bool get moved => draft.place != null && state.point != draft.point;

  void moveTo(GeoPoint point) => state = (point: point, saving: state.saving);

  /// The details, trimmed, or null (and the fields marked) when there's no
  /// name.
  PlaceDetails? submit() {
    final name = _trimmed('name');
    if (name == null || form.invalid) {
      form.markAllAsTouched();
      return null;
    }
    return (name: name, note: _trimmed('note'));
  }

  /// Saves the place with [details]. Null once the backend kept it.
  Future<AppFailure?> save(PlaceDetails details) async {
    state = (point: state.point, saving: true);
    final places = ref.read(savedPlacesViewModel.notifier);
    final failure = switch (draft.place) {
      null => await places.add(details, state.point),
      final place => await places.change(
        SavedPlace(
          id: place.id,
          name: details.name,
          note: details.note,
          point: state.point,
        ),
      ),
    };
    if (ref.mounted) state = (point: state.point, saving: false);
    return failure;
  }

  String? _trimmed(String control) {
    final value = (form.control(control).value as String? ?? '').trim();
    return value.isEmpty ? null : value;
  }
}

final placeDetailsViewModel = NotifierProvider.autoDispose
    .family<PlaceDetailsViewModel, PlaceDetailsState, PlaceDraft>(
      PlaceDetailsViewModel.new,
    );
