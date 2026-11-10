import 'dart:async';
import 'dart:convert';

import 'package:kernel/kernel.dart';

import 'saved_place.dart';

/// Where Kaziony works: a circle around a city. Customers browse from a
/// place inside one.
class ServiceArea {
  const ServiceArea({
    required this.nameAr,
    required this.nameEn,
    required this.center,
    required this.radiusKm,
  });

  final String nameAr;
  final String nameEn;
  final GeoPoint center;
  final num radiusKm;

  String name(String languageCode) => languageCode == 'ar' ? nameAr : nameEn;

  bool covers(GeoPoint point) => center.distanceKmTo(point) <= radiusKm;
}

/// Whether [point] is inside one of [areas].
bool coveredBy(List<ServiceArea> areas, GeoPoint point) =>
    areas.any((area) => area.covers(point));

/// The areas Kaziony works in, and how far around a place offers come
/// from, from the backend's settings.
abstract interface class ServiceAreaRepository {
  Future<Result<List<ServiceArea>>> areas();

  /// How far from where the customer browses offers are shown, in km.
  Future<Result<num>> browseRadiusKm();
}

/// Wired to the real implementation in `core/providers/dependencies.dart`.
final serviceAreaRepositoryProvider = Provider<ServiceAreaRepository>(
  (ref) => throw UnimplementedError('Provided by core/providers'),
);

/// Where the customer browses from: where the phone was, or a place they
/// [pinned] on the map. Offers are shown within our radius of [point].
/// [placeId] and [name] are the [SavedPlace] it is, when it's one of
/// theirs; the name is kept here so the home page says it at once.
class BrowseLocation {
  const BrowseLocation(
    this.point, {
    required this.pinned,
    this.placeId,
    this.name,
  });

  BrowseLocation.of(SavedPlace place)
    : this(place.point, pinned: true, placeId: place.id, name: place.name);

  final GeoPoint point;
  final bool pinned;
  final String? placeId;
  final String? name;

  Map<String, Object?> toJson() => {
    'latitude': point.latitude,
    'longitude': point.longitude,
    'pinned': pinned,
    'placeId': ?placeId,
    'name': ?name,
  };

  static BrowseLocation fromJson(Map<String, Object?> json) => BrowseLocation(
    _pointFrom(json),
    pinned: json['pinned'] as bool? ?? false,
    placeId: json['placeId'] as String?,
    name: json['name'] as String?,
  );
}

GeoPoint _pointFrom(Map<String, Object?> json) => GeoPoint(
  (json['latitude']! as num).toDouble(),
  (json['longitude']! as num).toDouble(),
);

/// Where the customer browses from, remembered on the phone. Null until
/// they choose, which the welcome pages ask first.
class BrowseLocationController extends ViewModel<BrowseLocation?> {
  /// [saved] is what [readSaved] found before the first frame, so the app
  /// doesn't flash the welcome pages at someone who's seen them.
  BrowseLocationController([this._saved]);

  static const _key = 'browse.location';

  final BrowseLocation? _saved;

  static Future<BrowseLocation?> readSaved(SettingsStore store) async {
    final raw = await store.getString(_key);
    if (raw == null) return null;
    try {
      return BrowseLocation.fromJson(jsonDecode(raw) as Map<String, Object?>);
    } on Object {
      return null;
    }
  }

  @override
  BrowseLocation? build() {
    if (_saved case final saved?) return saved;
    unawaited(_load());
    return null;
  }

  Future<void> set(BrowseLocation location) async {
    state = location;
    await ref
        .read(settingsStoreProvider)
        .setString(_key, jsonEncode(location.toJson()));
  }

  Future<void> _load() async {
    final saved = await readSaved(ref.read(settingsStoreProvider));
    if (saved != null && ref.mounted && state == null) state = saved;
  }
}

final browseLocationProvider =
    NotifierProvider<BrowseLocationController, BrowseLocation?>(
      BrowseLocationController.new,
    );
