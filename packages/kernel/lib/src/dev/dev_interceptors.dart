import 'package:dio/dio.dart';

import 'dev_log.dart';
import 'dev_settings.dart';

const _entryKey = 'devLogEntry';

/// Records every request and response in the [DevLog].
class HttpLogInterceptor extends Interceptor {
  HttpLogInterceptor(this.log);

  final DevLog log;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_entryKey] = log.startRequest(
      method: options.method,
      url: options.uri.toString(),
      headers: options.headers,
      body: options.data,
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final entry = response.requestOptions.extra[_entryKey];
    if (entry is HttpLogEntry) {
      log.finishRequest(
        entry,
        status: response.statusCode,
        responseBody: response.data,
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final entry = err.requestOptions.extra[_entryKey];
    if (entry is HttpLogEntry) {
      log.finishRequest(
        entry,
        status: err.response?.statusCode,
        responseBody: err.response?.data,
        error: err.response == null ? '${err.type.name}: ${err.message}' : null,
      );
    }
    handler.next(err);
  }
}

/// Applies the dev menu's "slow network" and "offline" switches.
class DevNetworkInterceptor extends Interceptor {
  DevNetworkInterceptor(this.settings);

  final DevSettings Function() settings;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final current = settings();
    if (current.offline) {
      return handler.reject(
        DioException.connectionError(
          requestOptions: options,
          reason: 'Offline mode (dev menu)',
        ),
      );
    }
    if (current.slowNetwork) {
      await Future<void>.delayed(const Duration(seconds: 2));
    }
    handler.next(options);
  }
}
