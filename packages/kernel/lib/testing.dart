/// Fakes for tests. Import in test files only:
/// `import 'package:kernel/testing.dart';`
library;

import 'src/config/app_config.dart';
import 'src/errors/error_reporter.dart';
import 'src/photos/photos.dart';
import 'src/state/state.dart';
import 'src/storage/storage.dart';

class MemorySecureStore implements SecureStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}

class MemorySettingsStore implements SettingsStore {
  final values = <String, String>{};

  @override
  Future<String?> getString(String key) async => values[key];

  @override
  Future<void> setString(String key, String value) async => values[key] = value;

  @override
  Future<void> remove(String key) async => values.remove(key);
}

/// Answers every [pick] with [next], and counts the trips to settings.
class FakePhotoPicker implements PhotoPicker {
  FakePhotoPicker([this.next = const PhotoCancelled()]);

  PhotoPick next;
  final picks = <PhotoSource>[];
  var settingsOpened = 0;

  @override
  Future<PhotoPick> pick(
    PhotoSource source, {
    required String cropTitle,
  }) async {
    picks.add(source);
    return next;
  }

  @override
  Future<void> openSettings() async => settingsOpened++;
}

class RecordingErrorReporter implements ErrorReporter {
  final errors = <Object>[];
  String? userId;

  @override
  void report(Object error, StackTrace? stack, {bool fatal = false}) =>
      errors.add(error);

  @override
  void setUser(String? userId) => this.userId = userId;
}

/// Overrides that make kernel work in tests without plugins. Pass
/// [settings] to check what was saved.
List<Override> testOverrides({
  AppKind kind = AppKind.partner,
  String apiBaseUrl = 'http://test.invalid',
  String version = '1.0.0',
  SettingsStore? settings,
}) => [
  appConfigProvider.overrideWithValue(
    AppConfig(kind: kind, apiBaseUrl: apiBaseUrl),
  ),
  appInfoProvider.overrideWithValue(
    AppInfo(version: version, buildNumber: '1'),
  ),
  secureStoreProvider.overrideWithValue(MemorySecureStore()),
  settingsStoreProvider.overrideWithValue(settings ?? MemorySettingsStore()),
  errorReporterProvider.overrideWithValue(RecordingErrorReporter()),
];
