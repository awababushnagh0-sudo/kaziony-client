import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/src/dev/dev_interceptors.dart';

class _JsonAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    jsonEncode({
      'accessToken': 'secret-access',
      'user': {'name': 'Ahmed'},
    }),
    200,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

void main() {
  test('hides passwords and tokens anywhere in a body', () {
    final redacted = redactSecrets({
      'identifier': '0910000001',
      'password': 'Merchant123!',
      'nested': {
        'refreshToken': 'abc',
        'items': [
          {'newPassword': 'x', 'title': 'Cake'},
        ],
      },
    });
    expect(jsonEncode(redacted), isNot(contains('Merchant123!')));
    expect(jsonEncode(redacted), isNot(contains('abc')));
    expect(redacted, {
      'identifier': '0910000001',
      'password': '•••',
      'nested': {
        'refreshToken': '•••',
        'items': [
          {'newPassword': '•••', 'title': 'Cake'},
        ],
      },
    });
  });

  test('keeps only the latest entries', () {
    final log = DevLog();
    for (var i = 0; i < DevLog.maxEntries + 10; i++) {
      log.log(LogLevel.info, 'message $i');
    }
    expect(log.logs, hasLength(DevLog.maxEntries));
    expect(log.logs.first.message, 'message ${DevLog.maxEntries + 9}');
  });

  test('logs requests without secrets', () async {
    final log = DevLog();
    final dio = Dio(BaseOptions(baseUrl: 'http://test.invalid'))
      ..httpClientAdapter = _JsonAdapter()
      ..interceptors.add(HttpLogInterceptor(log));

    await dio.post<Object?>(
      '/api/v1/auth/login',
      data: {'identifier': '0910000001', 'password': 'Merchant123!'},
      options: Options(headers: {'Authorization': 'Bearer real-token'}),
    );

    final entry = log.http.single;
    expect(entry.method, 'POST');
    expect(entry.status, 200);
    expect(entry.duration, isNotNull);
    expect(entry.requestHeaders['Authorization'], '•••');
    expect(entry.requestBody, contains('0910000001'));
    expect(entry.requestBody, isNot(contains('Merchant123!')));
    expect(entry.responseBody, contains('Ahmed'));
    expect(entry.responseBody, isNot(contains('secret-access')));
  });

  test('offline mode fails requests like a lost connection', () async {
    var settings = const DevSettings(offline: true);
    final dio = Dio(BaseOptions(baseUrl: 'http://test.invalid'))
      ..httpClientAdapter = _JsonAdapter()
      ..interceptors.add(DevNetworkInterceptor(() => settings));

    await expectLater(
      dio.get<Object?>('/offers'),
      throwsA(
        isA<DioException>().having(
          (e) => e.type,
          'type',
          DioExceptionType.connectionError,
        ),
      ),
    );

    settings = const DevSettings();
    expect((await dio.get<Object?>('/offers')).statusCode, 200);
  });
}
