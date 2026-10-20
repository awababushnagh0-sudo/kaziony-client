import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/src/auth/token_store.dart';
import 'package:kernel/src/network/interceptors.dart';
import 'package:kernel/testing.dart';

/// Answers requests from a handler instead of the network.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.handle);

  final ResponseBody Function(RequestOptions options) handle;
  final requests = <RequestOptions>[];

  /// Authorization header of each request, captured when it was sent
  /// (the options object is reused and changed by retries).
  final authHeaders = <Object?>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    authHeaders.add(options.headers['Authorization']);
    await Future<void>.delayed(const Duration(milliseconds: 5));
    return handle(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody json(int status, Object body) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

void main() {
  late TokenStore tokens;
  late Dio dio;
  late FakeAdapter adapter;
  late int refreshCalls;
  late bool refreshSucceeds;

  setUp(() async {
    tokens = TokenStore(MemorySecureStore());
    await tokens.save(const AuthTokens(accessToken: 'old', refreshToken: 'r1'));
    refreshCalls = 0;
    refreshSucceeds = true;

    dio = Dio(BaseOptions(baseUrl: 'http://test.invalid'));
    adapter = FakeAdapter(
      (options) => options.headers['Authorization'] == 'Bearer new'
          ? json(200, {'ok': true})
          : json(401, {'statusCode': 401, 'message': 'expired'}),
    );
    dio.httpClientAdapter = adapter;
    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        tokens: tokens,
        refresh: () async {
          refreshCalls++;
          await Future<void>.delayed(const Duration(milliseconds: 20));
          if (!refreshSucceeds) return false;
          await tokens.save(
            const AuthTokens(accessToken: 'new', refreshToken: 'r2'),
          );
          return true;
        },
      ),
    );
  });

  test('refreshes an expired token and retries the request', () async {
    final response = await dio.get<Object?>('/me');
    expect(response.statusCode, 200);
    expect(refreshCalls, 1);
    expect(adapter.authHeaders, ['Bearer old', 'Bearer new']);
  });

  test('refreshes only once when many requests expire together', () async {
    final responses = await Future.wait([
      for (var i = 0; i < 5; i++) dio.get<Object?>('/me'),
    ]);
    expect(responses.every((r) => r.statusCode == 200), isTrue);
    expect(refreshCalls, 1);
  });

  test('gives up with the 401 when the refresh fails', () async {
    refreshSucceeds = false;
    await expectLater(
      dio.get<Object?>('/me'),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          401,
        ),
      ),
    );
    expect(refreshCalls, 1);
  });

  test('does not attach tokens to requests marked skipAuth', () async {
    await expectLater(
      dio.get<Object?>('/public', options: Options(extra: {skipAuthKey: true})),
      throwsA(isA<DioException>()),
    );
    expect(adapter.authHeaders, [null]);
    expect(refreshCalls, 0);
  });

  group('RetryInterceptor', () {
    test('retries GET on connection errors, never POST', () async {
      final retryDio = Dio(BaseOptions(baseUrl: 'http://test.invalid'));
      var calls = 0;
      retryDio.httpClientAdapter = FakeAdapter((options) {
        calls++;
        if (calls < 3) {
          throw DioException.connectionError(
            requestOptions: options,
            reason: 'offline',
          );
        }
        return json(200, {'ok': true});
      });
      retryDio.interceptors.add(
        RetryInterceptor(
          retryDio,
          delays: const [Duration.zero, Duration.zero],
        ),
      );

      expect((await retryDio.get<Object?>('/offers')).statusCode, 200);
      expect(calls, 3);

      calls = 0;
      await expectLater(
        retryDio.post<Object?>('/claim'),
        throwsA(isA<DioException>()),
      );
      expect(calls, 1);
    });
  });
}
