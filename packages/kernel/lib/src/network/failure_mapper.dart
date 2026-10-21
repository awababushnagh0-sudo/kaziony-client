import 'package:dio/dio.dart';

import '../result/failure.dart';

/// Turns any error from a request into an [AppFailure].
///
/// The backend answers errors with
/// `{ statusCode, error, message, path, timestamp }`, where `message` is a
/// string or a list of validation messages.
AppFailure failureFromError(Object error) {
  if (error is DioException) return _fromDio(error);
  return UnknownFailure(error);
}

AppFailure _fromDio(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const TimeoutFailure();
    case DioExceptionType.connectionError:
      return const NoConnectionFailure();
    case DioExceptionType.badResponse:
      final response = e.response;
      return response == null ? UnknownFailure(e) : _fromResponse(response);
    case DioExceptionType.unknown:
      // Socket errors arrive here on some platforms.
      final inner = e.error?.runtimeType.toString() ?? '';
      if (inner.contains('SocketException') ||
          inner.contains('ClientException')) {
        return const NoConnectionFailure();
      }
      return UnknownFailure(e.error ?? e);
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
      return UnknownFailure(e);
  }
}

AppFailure _fromResponse(Response<dynamic> response) {
  final status = response.statusCode ?? 0;
  final body = response.data;
  final messages = <String>[];
  String? code;
  if (body is Map) {
    final message = body['message'];
    if (message is String) messages.add(message);
    if (message is List) messages.addAll(message.whereType<String>());
    final error = body['error'];
    if (error is String) code = error;
  }
  final message = messages.isEmpty ? null : messages.join('\n');

  return switch (status) {
    400 || 413 || 422 => ValidationFailure(
      messages,
      code: switch (code) {
        'Bad Request' || 'Payload Too Large' || 'Unprocessable Entity' => null,
        _ => code,
      },
    ),
    401 => UnauthorizedFailure(message),
    403 when code == 'PasswordChangeRequired' => PasswordChangeRequiredFailure(
      message,
    ),
    403 => ForbiddenFailure(
      code: code == 'Forbidden' ? null : code,
      serverMessage: message,
    ),
    404 => NotFoundFailure(message),
    409 => ConflictFailure(message),
    429 => const RateLimitedFailure(),
    >= 500 => ServerFailure(status),
    _ => UnknownFailure('HTTP $status: ${message ?? body}'),
  };
}
