import 'package:kernel/kernel.dart';

/// Settings our team changes for everyone, without a release.
class PlatformSettings {
  const PlatformSettings({required this.browseRadiusKm});

  /// Customers see offers from branches this close to them.
  final int browseRadiusKm;
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
