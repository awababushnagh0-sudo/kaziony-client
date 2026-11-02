import 'package:kernel/kernel.dart';

import '../domain/platform_settings.dart';

/// The platform settings as saved on the server.
class PlatformSettingsViewModel extends AsyncViewModel<PlatformSettings> {
  @override
  Future<PlatformSettings> build() async =>
      (await ref.watch(platformSettingsRepositoryProvider).get()).valueOrThrow;

  Future<Result<PlatformSettings>> save(PlatformSettings settings) async {
    final result = await ref
        .read(platformSettingsRepositoryProvider)
        .update(settings);
    if (result case Ok(:final value) when ref.mounted) {
      state = AsyncData(value);
    }
    return result;
  }
}

final platformSettingsViewModel =
    AsyncNotifierProvider.autoDispose<
      PlatformSettingsViewModel,
      PlatformSettings
    >(PlatformSettingsViewModel.new);
