import 'package:kernel/kernel.dart';

/// Where Kaziony works: customers browse from inside one of these circles.
class ServiceArea {
  const ServiceArea({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
    required this.isActive,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final double latitude;
  final double longitude;
  final int radiusKm;

  /// Off: customers there can't browse until it's back on.
  final bool isActive;

  String name(String languageCode) => languageCode == 'ar' ? nameAr : nameEn;
}

/// What the dialog sends, for a new area or an edited one.
class ServiceAreaDraft {
  const ServiceAreaDraft({
    required this.nameAr,
    required this.nameEn,
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
    required this.isActive,
  });

  final String nameAr;
  final String nameEn;
  final double latitude;
  final double longitude;
  final int radiusKm;
  final bool isActive;
}

/// A radius can be set between these, in km (as the backend checks).
const minServiceAreaRadiusKm = 1;
const maxServiceAreaRadiusKm = 100;

/// Everyone on the team reads them; the server lets only admins change them.
abstract interface class ServiceAreaRepository {
  Future<Result<List<ServiceArea>>> list();
  Future<Result<ServiceArea>> create(ServiceAreaDraft draft);
  Future<Result<ServiceArea>> update(String id, ServiceAreaDraft draft);
  Future<Result<void>> delete(String id);
}

/// Wired to the real implementation in `core/providers/dependencies.dart`.
final serviceAreaRepositoryProvider = Provider<ServiceAreaRepository>(
  (ref) => throw UnimplementedError('Provided by core/providers'),
);
