import 'package:dio/dio.dart';

import '../auth/token_store.dart';

/// Request options flag: don't attach the access token (login, refresh).
const skipAuthKey = 'skipAuth';
const _authRetriedKey = 'authRetried';
const _retryAttemptKey = 'retryAttempt';

/// Attaches the access token, and on a 401 refreshes the session once and
/// retries the request.
///
/// It's a [QueuedInterceptor], so when several requests fail with 401 at the
/// same time only the first one refreshes; the others see the new token and
/// just retry.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.dio,
    required this.tokens,
    required this.refresh,
  });

  final Dio dio;
  final TokenStore tokens;

  /// Gets new tokens. Returns false if the session can't be refreshed.
  final Future<bool> Function() refresh;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokens.current?.accessToken;
    if (options.extra[skipAuthKey] != true && token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final sentHeader = options.headers['Authorization'];
    if (err.response?.statusCode != 401 ||
        sentHeader == null ||
        options.extra[_authRetriedKey] == true) {
      return handler.next(err);
    }

    // Another request may already have refreshed while this one waited.
    final current = tokens.current?.accessToken;
    var refreshed = current != null && 'Bearer $current' != sentHeader;
    if (!refreshed) refreshed = await refresh();
    if (!refreshed) return handler.next(err);

    try {
      options.extra[_authRetriedKey] = true;
      options.headers.remove('Authorization');
      handler.resolve(await dio.fetch<dynamic>(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}

/// Retries GET requests that failed because of a bad connection, after a
/// short wait. Writes (POST, PATCH, ...) are never retried automatically,
/// so nothing is created twice.
class RetryInterceptor extends Interceptor {
  RetryInterceptor(
    this.dio, {
    this.delays = const [Duration(milliseconds: 700), Duration(seconds: 2)],
  });

  final Dio dio;
  final List<Duration> delays;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final attempt = (options.extra[_retryAttemptKey] as int?) ?? 0;
    final retryable =
        options.method == 'GET' &&
        (err.type == DioExceptionType.connectionError ||
            err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.receiveTimeout);
    if (!retryable || attempt >= delays.length) return handler.next(err);

    await Future<void>.delayed(delays[attempt]);
    try {
      options.extra[_retryAttemptKey] = attempt + 1;
      handler.resolve(await dio.fetch<dynamic>(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}
