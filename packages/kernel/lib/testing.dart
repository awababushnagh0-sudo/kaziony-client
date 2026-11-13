/// Fakes for tests. Import in test files only:
/// `import 'package:kernel/testing.dart';`
library;

import 'package:flutter/widgets.dart';

import 'src/auth/google_auth.dart';
import 'src/config/app_config.dart';
import 'src/errors/error_reporter.dart';
import 'src/links/links.dart';
import 'src/location/location.dart';
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
  final shapes = <PhotoShape>[];
  var settingsOpened = 0;

  @override
  Future<PhotoPick> pick(
    PhotoSource source, {
    required String cropTitle,
    PhotoShape shape = PhotoShape.square,
  }) async {
    picks.add(source);
    shapes.add(shape);
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

/// Answers every [signIn] with [next], and counts them and the sign-outs.
class FakeGoogleAuth implements GoogleAuth {
  FakeGoogleAuth([this.next = const GoogleCancelled()]);

  GooglePick next;
  var signIns = 0;
  var signOuts = 0;

  @override
  bool available = true;

  @override
  Future<GooglePick> signIn() async {
    signIns++;
    return next;
  }

  @override
  Future<void> signOut() async => signOuts++;
}

/// Answers every [current] with [next], and counts the trips to settings.
class FakeLocationFinder implements LocationFinder {
  FakeLocationFinder([this.next = const LocationFound(GeoPoint(32.88, 13.19))]);

  LocationFix next;
  var asked = 0;
  var appSettingsOpened = 0;
  var locationSettingsOpened = 0;

  @override
  Future<LocationFix> current() async {
    asked++;
    return next;
  }

  @override
  Future<void> openAppSettings() async => appSettingsOpened++;

  @override
  Future<void> openLocationSettings() async => locationSettingsOpened++;
}

/// Keeps every link it's asked to open; [opens] says whether the phone
/// could.
class FakeLinkOpener implements LinkOpener {
  FakeLinkOpener({this.opens = true});

  final bool opens;
  final opened = <Uri>[];

  @override
  Future<bool> open(Uri link) async {
    opened.add(link);
    return opens;
  }
}

class RecordingErrorReporter implements ErrorReporter {
  final errors = <Object>[];
  final routes = <String>[];
  String? userId;

  @override
  void report(Object error, StackTrace? stack, {bool fatal = false}) =>
      errors.add(error);

  @override
  void setUser(String? userId) => this.userId = userId;

  @override
  void routeChanged(String route) => routes.add(route);
}

/// Overrides that make kernel work in tests without plugins. Pass
/// [settings] to check what was saved, [googleAuth] to choose what Google
/// answers, [locationFinder] to choose where the phone is.
List<Override> testOverrides({
  AppKind kind = AppKind.partner,
  String apiBaseUrl = 'http://test.invalid',
  String version = '1.0.0',
  SettingsStore? settings,
  GoogleAuth? googleAuth,
  LocationFinder? locationFinder,
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
  googleAuthProvider.overrideWithValue(googleAuth ?? FakeGoogleAuth()),
  locationFinderProvider.overrideWithValue(
    locationFinder ?? FakeLocationFinder(),
  ),
];
