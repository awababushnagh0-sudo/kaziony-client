/// Fakes for tests. Import in test files only:
/// `import 'package:kernel/testing.dart';`
library;

import 'package:flutter/widgets.dart';

import 'src/config/app_config.dart';
import 'src/errors/error_reporter.dart';
import 'src/photos/photos.dart';
import 'src/scanner/qr_scanner.dart';
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

/// A blank camera in [state]; [read] acts as if a QR code came into view.
class FakeQrScanner implements QrScanner {
  FakeQrScanner([this.state = const ScannerState(ScannerStatus.scanning)]);

  final ScannerState state;
  ValueChanged<String>? _onCode;

  /// What the screen last asked of the light.
  bool torch = false;
  var settingsOpened = 0;

  /// Sends [code] to the view on screen.
  void read(String code) => _onCode?.call(code);

  @override
  Widget view({
    required ValueChanged<String> onCode,
    required ValueChanged<ScannerState> onState,
    bool torch = false,
  }) {
    _onCode = onCode;
    this.torch = torch;
    return _FakeCamera(state: state, onState: onState);
  }

  @override
  Future<void> openSettings() async => settingsOpened++;
}

class _FakeCamera extends StatefulWidget {
  const _FakeCamera({required this.state, required this.onState});

  final ScannerState state;
  final ValueChanged<ScannerState> onState;

  @override
  State<_FakeCamera> createState() => _FakeCameraState();
}

class _FakeCameraState extends State<_FakeCamera> {
  @override
  void initState() {
    super.initState();
    // Like the camera, which reports once it's open.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.onState(widget.state),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
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
