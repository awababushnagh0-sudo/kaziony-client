import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';

/// Reads the whole request, as a real connection does, then answers.
class _ReadingAdapter implements HttpClientAdapter {
  var received = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await for (final chunk in requestStream!) {
      received += chunk.length;
    }
    return ResponseBody.fromString(
      jsonEncode({'ok': true}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// Stands in for the auth interceptor, which queues requests.
class _Queued extends QueuedInterceptor {}

void main() {
  test('upload reports the share sent, up to all of it', () async {
    final adapter = _ReadingAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'http://test.invalid'))
      ..httpClientAdapter = adapter
      ..interceptors.add(_Queued());
    final api = Api(dio, RecordingErrorReporter());
    final progress = <double>[];

    final result = await api.upload(
      (dio) => dio,
      (dio) => dio.fetch<Object?>(
        RequestOptions(
          path: '/photo',
          method: 'PUT',
          data: FormData.fromMap({
            'image': MultipartFile.fromBytes(
              List.filled(200 * 1024, 1),
              filename: 'photo.jpg',
            ),
          }),
        ),
      ),
      onProgress: progress.add,
    );

    expect(result.isOk, isTrue);
    expect(adapter.received, greaterThan(200 * 1024));
    expect(progress, isNotEmpty);
    expect(progress.last, 1);
    // Only grows.
    for (var i = 1; i < progress.length; i++) {
      expect(progress[i], greaterThanOrEqualTo(progress[i - 1]));
    }
  });
}
