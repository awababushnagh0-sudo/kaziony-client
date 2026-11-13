import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../config/app_config.dart';
import 'error_reporter.dart';

/// Sends errors to Sentry, or a self-hosted GlitchTip (same protocol), as
/// the backend does. On the phones, native crashes and crash-free sessions
/// per app version come with it.
///
/// Nothing personal leaves: users by id only, no screenshots, view trees or
/// printed lines, and no query strings (they carry locations and searches).
/// A failed request is told apart by its endpoint, with the backend's
/// request id to find its log lines.
class SentryErrorReporter implements ErrorReporter {
  @visibleForTesting
  const SentryErrorReporter();

  /// Starts Sentry. `bootstrap` then installs its own handlers for uncaught
  /// errors in place of Sentry's, and they report here.
  static Future<SentryErrorReporter> start({
    required String dsn,
    required AppKind app,
    required AppEnv env,
  }) async {
    await SentryFlutter.init(
      (options) => configure(options, dsn: dsn, env: env),
    );
    await Sentry.configureScope((scope) => scope.setTag('app', app.name));
    return const SentryErrorReporter();
  }

  @visibleForTesting
  static void configure(
    SentryFlutterOptions options, {
    required String dsn,
    required AppEnv env,
  }) {
    options
      ..dsn = dsn
      ..environment = env.name
      // The defaults, set here so that a new default can't send them.
      ..sendDefaultPii = false
      ..attachScreenshot = false
      ..attachViewHierarchy = false
      // A printed line can hold anything.
      ..enablePrintBreadcrumbs = false
      ..beforeBreadcrumb = breadcrumbWithoutQuery;
  }

  @override
  void report(Object error, StackTrace? stack, {bool fatal = false}) {
    unawaited(
      Sentry.captureException(
        // Shown as unhandled, as Sentry's own handlers would.
        fatal
            ? ThrowableMechanism(
                Mechanism(type: 'uncaught', handled: false),
                error,
              )
            : error,
        stackTrace: stack,
        withScope: (scope) async {
          scope.level = fatal ? SentryLevel.fatal : SentryLevel.error;
          if (error is DioException) await _describeRequest(scope, error);
        },
      ),
    );
  }

  @override
  void setUser(String? userId) {
    Sentry.configureScope(
      (scope) => scope.setUser(userId == null ? null : SentryUser(id: userId)),
    );
  }

  @override
  void routeChanged(String route) => unawaited(
    Sentry.addBreadcrumb(
      Breadcrumb(type: 'navigation', category: 'navigation', message: route),
    ),
  );

  /// Every failed request has much the same stack (inside Dio), so one
  /// issue per endpoint and status instead.
  static Future<void> _describeRequest(Scope scope, DioException error) async {
    final request = error.requestOptions;
    final endpoint = endpointOf(request.uri.path);
    final status = error.response?.statusCode;
    scope.fingerprint = [
      'request',
      request.method,
      endpoint,
      '${status ?? error.type.name}',
    ];
    await scope.setTag('http.method', request.method);
    await scope.setTag('http.endpoint', endpoint);
    if (status != null) await scope.setTag('http.status_code', '$status');
    final requestId = error.response?.headers.value('x-request-id');
    if (requestId != null) await scope.setTag('request_id', requestId);
  }
}

final _id = RegExp(
  r'^([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}|\d+)$',
  caseSensitive: false,
);

/// [path] with its ids and pickup codes as placeholders, so an endpoint is
/// one name whatever record it was for: `/api/v1/offers/:id`.
@visibleForTesting
String endpointOf(String path) {
  final segments = path.split('/');
  return [
    for (final (i, segment) in segments.indexed)
      if (i > 0 && segments[i - 1] == 'code')
        ':code'
      else if (_id.hasMatch(segment))
        ':id'
      else
        segment,
  ].join('/');
}

/// Drops the query string and fragment from a breadcrumb's address.
@visibleForTesting
Breadcrumb? breadcrumbWithoutQuery(Breadcrumb? breadcrumb, Hint hint) {
  final data = breadcrumb?.data;
  if (breadcrumb == null || data == null) return breadcrumb;
  breadcrumb.data = {
    for (final MapEntry(:key, :value) in data.entries)
      if (key != 'http.query' && key != 'http.fragment')
        key: key == 'url' && value is String
            ? value.split('#').first.split('?').first
            : value,
  };
  return breadcrumb;
}
