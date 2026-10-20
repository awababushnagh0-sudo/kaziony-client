import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Which app is running. Used for the minimum-version check.
enum AppKind { business, customer, admin }

enum AppEnv { dev, staging, prod }

const _envName = String.fromEnvironment(
  'APP_ENV',
  // A release build without an explicit APP_ENV is treated as production,
  // so a forgotten flag can never ship dev tools to users.
  defaultValue: kReleaseMode ? 'prod' : 'dev',
);

/// The environment this build was made for (`--dart-define=APP_ENV=...`,
/// usually via `--dart-define-from-file=config/<env>.json`).
final AppEnv appEnv = AppEnv.values.firstWhere(
  (env) => env.name == _envName,
  orElse: () => AppEnv.prod,
);

/// Dev tools (dev menu, request log, server switching) exist only in dev
/// and staging builds. This is a compile-time constant: in production
/// builds the code behind `if (kDevTools)` is removed entirely.
const bool kDevTools = _envName != 'prod';

class AppConfig {
  const AppConfig({
    required this.kind,
    required this.apiBaseUrl,
    this.env = AppEnv.dev,
  });

  /// Reads `API_BASE_URL` and `APP_ENV`. Without a URL, dev builds point at
  /// the local backend (the Android emulator reaches the host at 10.0.2.2).
  factory AppConfig.fromEnvironment(AppKind kind) {
    const url = String.fromEnvironment('API_BASE_URL');
    if (url.isEmpty && appEnv == AppEnv.prod) {
      throw StateError(
        'Production builds need API_BASE_URL '
        '(--dart-define-from-file=config/prod.json)',
      );
    }
    return AppConfig(
      kind: kind,
      env: appEnv,
      apiBaseUrl: url.isNotEmpty ? url : localBackendUrl(),
    );
  }

  final AppKind kind;
  final AppEnv env;

  /// The server this build was made for. In dev builds the dev menu can
  /// point the app elsewhere; use `apiBaseUrlProvider` for the active one.
  final String apiBaseUrl;
}

/// The backend on this machine, as seen from the simulator or emulator.
String localBackendUrl() {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:3000';
  }
  return 'http://localhost:3000';
}

/// The installed app's version, read once at startup.
class AppInfo {
  const AppInfo({required this.version, required this.buildNumber});

  /// e.g. "1.2.0"
  final String version;
  final String buildNumber;
}

/// Set by `bootstrap`.
final appConfigProvider = Provider<AppConfig>(
  (ref) => throw StateError('appConfigProvider is set by bootstrap()'),
);

/// Set by `bootstrap`.
final appInfoProvider = Provider<AppInfo>(
  (ref) => throw StateError('appInfoProvider is set by bootstrap()'),
);
