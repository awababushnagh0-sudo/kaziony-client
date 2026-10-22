import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/session.dart';
import '../auth/token_store.dart';
import '../config/app_config.dart';
import '../dev/dev_interceptors.dart';
import '../dev/dev_log.dart';
import '../dev/dev_settings.dart';
import '../errors/error_reporter.dart';
import '../result/failure.dart';
import '../result/result.dart';
import 'failure_mapper.dart';
import 'interceptors.dart';

/// Gateway to the backend for the data layers of the apps.
///
/// ```dart
/// final stores = api.client(PartnerStoreClient.new);
/// final result = await api.guard(() => stores.getStore(storeId: id));
/// ```
class Api {
  const Api(this._dio, this._reporter);

  final Dio _dio;
  final ErrorReporter _reporter;

  /// Creates a generated client (from `offers_api`) that uses this
  /// connection: tokens, refresh, retries and timeouts included.
  T client<T>(T Function(Dio dio) create) => create(_dio);

  /// Runs a request and returns [Ok] or [Err] instead of throwing.
  /// Unexpected failures are sent to the [ErrorReporter].
  Future<Result<T>> guard<T>(Future<T> Function() request) async {
    try {
      return Ok(await request());
    } catch (error, stack) {
      final failure = failureFromError(error);
      if (failure is UnknownFailure || failure is ServerFailure) {
        _reporter.report(error, stack);
      }
      return Err(failure);
    }
  }
}

/// Builds the HTTP client. Interceptors run in this order:
/// dev network switches → auth (token + refresh) → retry → dev request log.
Dio _createDio(Ref ref, {required bool withAuth}) {
  final config = ref.watch(appConfigProvider);
  final info = ref.watch(appInfoProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: ref.watch(apiBaseUrlProvider),
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        // Browsers don't allow setting User-Agent; native apps do.
        if (!kIsWeb) 'User-Agent': 'Offers-${config.kind.name}/${info.version}',
      },
    ),
  );
  dio.interceptors.addAll([
    if (kDevTools) DevNetworkInterceptor(() => ref.read(devSettingsProvider)),
    if (withAuth)
      AuthInterceptor(
        dio: dio,
        tokens: ref.watch(tokenStoreProvider),
        refresh: () => ref.read(sessionProvider.notifier).refreshTokens(),
      ),
    RetryInterceptor(dio),
    if (kDevTools) HttpLogInterceptor(ref.watch(devLogProvider)),
  ]);
  return dio;
}

/// For requests that need no login (login itself, refresh, app config).
final publicApiProvider = Provider<Api>(
  (ref) =>
      Api(_createDio(ref, withAuth: false), ref.watch(errorReporterProvider)),
);

/// For everything else: attaches the token and refreshes it when it expires.
final apiProvider = Provider<Api>(
  (ref) =>
      Api(_createDio(ref, withAuth: true), ref.watch(errorReporterProvider)),
);
