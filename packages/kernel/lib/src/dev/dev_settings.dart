import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../storage/storage.dart';

/// Developer-only switches. Ignored in production builds.
class DevSettings {
  const DevSettings({
    this.serverUrl,
    this.slowNetwork = false,
    this.offline = false,
  });

  /// Overrides the build's API URL. Null uses the build's URL.
  final String? serverUrl;

  /// Adds 2 seconds to every request, to see loading states.
  final bool slowNetwork;

  /// Fails every request as if there were no connection.
  final bool offline;

  DevSettings copyWith({
    String? Function()? serverUrl,
    bool? slowNetwork,
    bool? offline,
  }) => DevSettings(
    serverUrl: serverUrl == null ? this.serverUrl : serverUrl(),
    slowNetwork: slowNetwork ?? this.slowNetwork,
    offline: offline ?? this.offline,
  );
}

class DevSettingsController extends Notifier<DevSettings> {
  static const serverKey = 'dev.serverUrl';

  @override
  DevSettings build() => ref.watch(initialDevSettingsProvider);

  /// Remembered across restarts. Null goes back to the build's URL.
  Future<void> setServer(String? url) async {
    final store = ref.read(settingsStoreProvider);
    if (url == null) {
      await store.remove(serverKey);
    } else {
      await store.setString(serverKey, url);
    }
    state = state.copyWith(serverUrl: () => url);
  }

  void setSlowNetwork(bool value) => state = state.copyWith(slowNetwork: value);

  void setOffline(bool value) => state = state.copyWith(offline: value);
}

/// The settings saved last time, loaded by `bootstrap` before the app starts.
final initialDevSettingsProvider = Provider<DevSettings>(
  (ref) => const DevSettings(),
);

final devSettingsProvider =
    NotifierProvider<DevSettingsController, DevSettings>(
      DevSettingsController.new,
    );

/// The server the app talks to right now.
final apiBaseUrlProvider = Provider<String>((ref) {
  final buildUrl = ref.watch(appConfigProvider).apiBaseUrl;
  if (!kDevTools) return buildUrl;
  return ref.watch(devSettingsProvider.select((s) => s.serverUrl)) ?? buildUrl;
});

/// Checks that a backend answers at [baseUrl]. Returns null if it does,
/// otherwise a short reason.
Future<String?> pingServer(String baseUrl) async {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );
  try {
    final response = await dio.get<Object?>('/api/v1/health');
    return response.statusCode == 200 ? null : 'HTTP ${response.statusCode}';
  } on DioException catch (e) {
    return e.response != null
        ? 'HTTP ${e.response!.statusCode}'
        : (e.message ?? e.type.name);
  } finally {
    dio.close();
  }
}
