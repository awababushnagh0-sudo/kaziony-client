import 'package:kernel/kernel.dart';
import 'package:offers_api/admin.dart';

import '../domain/platform_settings.dart';

class ApiPlatformSettingsRepository implements PlatformSettingsRepository {
  ApiPlatformSettingsRepository(this._api);

  final Api _api;
  late final _settings = _api.client(AdminSettingsClient.new);

  @override
  Future<Result<PlatformSettings>> get() async {
    final result = await _api.guard(_settings.getSettings);
    return result.map(_toSettings);
  }

  @override
  Future<Result<PlatformSettings>> update(PlatformSettings settings) async {
    final result = await _api.guard(
      () => _settings.updateSettings(
        body: UpdateAppSettingsDto(
          browseRadiusKm: settings.browseRadiusKm,
          holdMinutes: settings.holdMinutes,
        ),
      ),
    );
    return result.map(_toSettings);
  }
}

PlatformSettings _toSettings(AppSettingsDto dto) => PlatformSettings(
  browseRadiusKm: dto.browseRadiusKm.toInt(),
  holdMinutes: dto.holdMinutes.toInt(),
);
