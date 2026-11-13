import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'appearance/theme_choice.dart';
import 'config/app_config.dart';
import 'dev/dev_log.dart';
import 'dev/dev_settings.dart';
import 'errors/error_reporter.dart';
import 'errors/sentry_error_reporter.dart';
import 'locale/locale.dart';
import 'navigation/navigation.dart';
import 'state/state.dart';
import 'storage/storage.dart';

/// Starts an app: reads the app version, catches every uncaught error, and
/// wraps the app in [AppScope] with its configuration. Errors go to Sentry
/// when the build has a `SENTRY_DSN`, to the console otherwise.
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
  List<Override> overrides = const [],
}) async {
  if (!kIsWeb) return _start(config, app, overrides);
  // On the web, Flutter doesn't pass errors from futures to
  // PlatformDispatcher.onError, so a zone catches them for it.
  await runZonedGuarded(
    () => _start(config, app, overrides),
    (error, stack) => PlatformDispatcher.instance.onError?.call(error, stack),
  );
}

Future<void> _start(
  AppConfig config,
  Widget Function() app,
  List<Override> overrides,
) async {
  usePathUrls();
  WidgetsFlutterBinding.ensureInitialized();

  ErrorReporter reporter = config.sentryDsn.isEmpty
      ? const ConsoleErrorReporter()
      : await SentryErrorReporter.start(
          dsn: config.sentryDsn,
          app: config.kind,
          env: config.env,
        );
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

  // In place of Sentry's own handlers, so every error goes through the
  // reporter (and the dev menu's log).
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

  @override
  void routeChanged(String route) => _inner.routeChanged(route);
}
