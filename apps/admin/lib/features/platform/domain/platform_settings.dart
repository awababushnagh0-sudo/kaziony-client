import 'package:kernel/kernel.dart';

/// Settings our team changes for everyone, without a release.
class PlatformSettings {
  const PlatformSettings({
    required this.browseRadiusKm,
    required this.holdMinutes,
  });

  /// Customers see offers from stores this close to them.
  final int browseRadiusKm;

  /// How long a reservation waits for the customer to pick it up, unless
  /// the offer ends first. Reservations made before a change keep theirs.
  final int holdMinutes;
}

abstract interface class PlatformSettingsRepository {
  Future<Result<PlatformSettings>> get();

  /// Admins only; the server refuses editors.
  Future<Result<PlatformSettings>> update(PlatformSettings settings);
}

/// Wired to the real implementation in `core/providers/dependencies.dart`.
final platformSettingsRepositoryProvider = Provider<PlatformSettingsRepository>(
  (ref) => throw UnimplementedError('Provided by core/providers'),
);
