import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'appearance/theme_choice.dart';
import 'config/app_config.dart';
import 'dev/dev_log.dart';
import 'dev/dev_settings.dart';
import 'errors/error_reporter.dart';
import 'locale/locale.dart';
import 'navigation/navigation.dart';
import 'state/state.dart';
import 'storage/storage.dart';

/// Starts an app: reads the app version, catches every uncaught error, and
/// wraps the app in [AppScope] with its configuration.
///
/// ```dart
/// void main() => bootstrap(
///   config: AppConfig.fromEnvironment(AppKind.partner),
///   app: () => const PartnerApp(),
/// );
/// ```
Future<void> bootstrap({
  required AppConfig config,
  required Widget Function() app,
  ErrorReporter reporter = const ConsoleErrorReporter(),
  List<Override> overrides = const [],
}) async {
  usePathUrls();
  WidgetsFlutterBinding.ensureInitialized();

  final devLog = DevLog();
  var devSettings = const DevSettings();
  if (kDevTools) {
    // Everything printed shows up in the dev menu's log too.
    final print = debugPrint;
    debugPrint = (message, {wrapWidth}) {
      devLog.log(LogLevel.debug, message ?? '');
      print(message, wrapWidth: wrapWidth);
    };
    reporter = _DevLogReporter(reporter, devLog);
    final savedServer = await DeviceSettingsStore().getString(
      DevSettingsController.serverKey,
    );
    devSettings = DevSettings(serverUrl: savedServer);
  }

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    reporter.report(details.exception, details.stack, fatal: true);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    reporter.report(error, stack, fatal: true);
    return true;
  };

  // Read before the first frame, so the app opens in its own theme and
  // language instead of switching to them a moment later.
  final settings = DeviceSettingsStore();
  final theme = await ThemeChoiceController.readSaved(settings);
  final locale = await LocaleController.readSaved(settings);

  final info = await PackageInfo.fromPlatform();
  runApp(
    AppScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        appInfoProvider.overrideWithValue(
          AppInfo(version: info.version, buildNumber: info.buildNumber),
        ),
        errorReporterProvider.overrideWithValue(reporter),
        devLogProvider.overrideWithValue(devLog),
        initialDevSettingsProvider.overrideWithValue(devSettings),
        themeChoiceProvider.overrideWith(() => ThemeChoiceController(theme)),
        localeProvider.overrideWith(() => LocaleController(locale)),
        ...overrides,
      ],
      child: app(),
    ),
  );
}

/// Copies reported errors into the dev menu's log.
class _DevLogReporter implements ErrorReporter {
  const _DevLogReporter(this._inner, this._log);

  final ErrorReporter _inner;
  final DevLog _log;

  @override
  void report(Object error, StackTrace? stack, {bool fatal = false}) {
    _log.log(LogLevel.error, '${fatal ? 'FATAL ' : ''}$error', stack);
    _inner.report(error, stack, fatal: fatal);
  }

  @override
  void setUser(String? userId) => _inner.setUser(userId);
}
