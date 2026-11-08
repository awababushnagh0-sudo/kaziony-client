import 'package:kernel/kernel.dart';

/// What the customer calls a place, and a word on finding it.
typedef PlaceDetails = ({String name, String? note});

/// A place the customer keeps to browse from again (home, work, their
/// grandparents' house), named by them, with a [note] on finding it. Kept
/// on their account, so it needs one.
class SavedPlace {
  const SavedPlace({
    required this.id,
    required this.name,
    required this.point,
    this.note,
  });

  final String id;
  final String name;
  final GeoPoint point;
  final String? note;
}

/// The signed-in customer's saved places.
abstract interface class PlacesRepository {
  /// Oldest first.
  Future<Result<List<SavedPlace>>> list();

  Future<Result<SavedPlace>> add(PlaceDetails details, GeoPoint point);

  /// Keeps [place]'s name, note and point as they are now.
  Future<Result<SavedPlace>> update(SavedPlace place);

  Future<Result<void>> remove(String id);
}

/// Wired to the real implementation in `core/providers/dependencies.dart`.
final placesRepositoryProvider = Provider<PlacesRepository>(
  (ref) => throw UnimplementedError('Provided by core/providers'),
);
