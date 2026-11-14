import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/src/errors/sentry_error_reporter.dart';
import 'package:kernel/testing.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() {
  group('Sentry', () {
    late StreamController<SentryEvent> sent;
    const reporter = SentryErrorReporter();

    setUp(() async {
      sent = StreamController.broadcast();
      await Sentry.init((options) {
        options
          ..dsn = 'https://key@sentry.example/1'
          // Kept here instead of sent.
          ..beforeSend = (event, hint) {
            sent.add(event);
            return null;
          };
      });
    });
    tearDown(() async {
      await Sentry.close();
      await sent.close();
    });

    // Waits for the event itself: on Linux, Sentry reads files about the
    // machine before it sends, so a busy machine (CI) takes longer than a
    // few turns of the event loop.
    Future<SentryEvent> reported(Object error, {bool fatal = false}) {
      final event = sent.stream.first;
      reporter.report(error, StackTrace.current, fatal: fatal);
      return event;
    }

    test('an uncaught error is fatal and unhandled', () async {
      final event = await reported(StateError('boom'), fatal: true);

      expect(event.level, SentryLevel.fatal);
      final mechanism = event.exceptions!.single.mechanism!;
      expect(mechanism.handled, isFalse);
      expect(mechanism.type, 'uncaught');
    });

    test('a caught one is an error', () async {
      final event = await reported(StateError('boom'));

      expect(event.level, SentryLevel.error);
      expect(event.exceptions!.single.mechanism, isNull);
    });

    test('a failed request is one issue per endpoint and status, with the '
        "backend's request id and no query string", () async {
      final request = RequestOptions(
        method: 'POST',
        baseUrl: 'https://api.example.ly',
        path:
            '/api/v1/offers/0192f3a4-5b6c-7d8e-9f01-23456789abcd/claim'
            '?lat=32.88&lng=13.19',
      );
      final event = await reported(
        DioException.badResponse(
          statusCode: 500,
          requestOptions: request,
          response: Response(
            requestOptions: request,
            statusCode: 500,
            headers: Headers.fromMap({
              'x-request-id': ['req-1'],
            }),
          ),
        ),
      );

      expect(event.fingerprint, [
        'request',
        'POST',
        '/api/v1/offers/:id/claim',
        '500',
      ]);
      expect(
        event.tags,
        containsPair('http.endpoint', '/api/v1/offers/:id/claim'),
      );
      expect(event.tags, containsPair('http.status_code', '500'));
      expect(event.tags, containsPair('request_id', 'req-1'));
      expect(event.tags.toString(), isNot(contains('32.88')));
    });

    test('users by id only, until they sign out', () async {
      reporter.setUser('user-1');
      final signedIn = await reported(StateError('boom'));
      reporter.setUser(null);
      final signedOut = await reported(StateError('boom'));

      expect(signedIn.user?.id, 'user-1');
      expect(signedIn.user?.email, isNull);
      expect(signedIn.user?.ipAddress, isNull);
      expect(signedOut.user, isNull);
    });

    test('the pages opened come with a report', () async {
      reporter
        ..routeChanged('/home')
        ..routeChanged('/offers/:id');
      final event = await reported(StateError('boom'));

      expect(
        event.breadcrumbs!
            .where((b) => b.category == 'navigation')
            .map((b) => b.message),
        ['/home', '/offers/:id'],
      );
    });
  });

  test('nothing personal is collected', () {
    final options = SentryFlutterOptions();
    SentryErrorReporter.configure(
      options,
      dsn: 'https://key@sentry.example/1',
      env: AppEnv.prod,
    );

    expect(options.environment, 'prod');
    expect(options.sendDefaultPii, isFalse);
    expect(options.attachScreenshot, isFalse);
    expect(options.attachViewHierarchy, isFalse);
    expect(options.enablePrintBreadcrumbs, isFalse);
    expect(options.beforeBreadcrumb, same(breadcrumbWithoutQuery));
  });

  test('an endpoint has placeholders for ids and pickup codes', () {
    expect(
      endpointOf('/api/v1/partner/stores/0192f3a4-5b6c-7d8e-9f01-23456789abcd'),
      '/api/v1/partner/stores/:id',
    );
    expect(
      endpointOf('/api/v1/admin/jobs/42/run'),
      '/api/v1/admin/jobs/:id/run',
    );
    expect(
      endpointOf('/api/v1/partner/claims/code/K7Q2'),
      '/api/v1/partner/claims/code/:code',
    );
    expect(endpointOf('/api/v1/offers'), '/api/v1/offers');
  });

  test('a breadcrumb keeps no query string or fragment', () {
    final breadcrumb = breadcrumbWithoutQuery(
      Breadcrumb.http(
        url: Uri.parse('https://api.example.ly/api/v1/offers?lat=32.88#top'),
        method: 'GET',
        httpQuery: 'lat=32.88',
        httpFragment: 'top',
      ),
      Hint(),
    )!;

    expect(
      breadcrumb.data,
      containsPair('url', 'https://api.example.ly/api/v1/offers'),
    );
    expect(breadcrumb.data, isNot(contains('http.query')));
    expect(breadcrumb.data, isNot(contains('http.fragment')));
    expect(breadcrumb.data, containsPair('method', 'GET'));
  });

  testWidgets('each page opened is reported once, as its pattern', (
    tester,
  ) async {
    final reporter = RecordingErrorReporter();
    final routerProvider = Provider<GoRouter>((ref) {
      final router = GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, _) => GestureDetector(
              onTap: () => context.go('/offers/7?from=search'),
              child: const Text('home'),
            ),
          ),
          GoRoute(path: '/offers/:id', builder: (_, _) => const Text('offer')),
        ],
      );
      reportRoutes(ref, router);
      return router;
    });
    final container = ProviderContainer(
      overrides: [errorReporterProvider.overrideWithValue(reporter)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      WidgetsApp.router(
        routerConfig: container.read(routerProvider),
        color: const Color(0xFF000000),
      ),
    );
    await tester.tap(find.text('home'));
    await tester.pumpAndSettle();

    expect(reporter.routes, ['/home', '/offers/:id']);
  });
}
