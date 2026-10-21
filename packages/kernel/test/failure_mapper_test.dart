import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/src/network/failure_mapper.dart';

DioException response(int status, Object? body) {
  final options = RequestOptions(path: '/x');
  return DioException.badResponse(
    statusCode: status,
    requestOptions: options,
    response: Response<Object?>(
      requestOptions: options,
      statusCode: status,
      data: body,
    ),
  );
}

Map<String, Object?> backendError(int status, String error, Object message) => {
  'statusCode': status,
  'error': error,
  'message': message,
};

void main() {
  test('maps connection problems', () {
    final options = RequestOptions(path: '/x');
    expect(
      failureFromError(
        DioException.connectionError(requestOptions: options, reason: ''),
      ),
      isA<NoConnectionFailure>(),
    );
    expect(
      failureFromError(
        DioException.receiveTimeout(
          timeout: Duration.zero,
          requestOptions: options,
        ),
      ),
      isA<TimeoutFailure>(),
    );
  });

  test('maps validation errors with all their messages', () {
    final failure = failureFromError(
      response(
        400,
        backendError(400, 'Bad Request', ['phone is invalid', 'name is empty']),
      ),
    );
    expect(failure, isA<ValidationFailure>());
    expect((failure as ValidationFailure).messages, [
      'phone is invalid',
      'name is empty',
    ]);
    expect(failure.code, isNull);
  });

  test('keeps the code of a specific validation error', () {
    final failure = failureFromError(
      response(
        400,
        backendError(
          400,
          'LocationOutsideLibya',
          'This location is outside Libya',
        ),
      ),
    );
    expect((failure as ValidationFailure).code, 'LocationOutsideLibya');
  });

  test('recognizes the temporary password and other 403 codes', () {
    expect(
      failureFromError(
        response(
          403,
          backendError(
            403,
            'PasswordChangeRequired',
            'Change your temporary password first',
          ),
        ),
      ),
      isA<PasswordChangeRequiredFailure>(),
    );
    final banned = failureFromError(
      response(
        403,
        backendError(403, 'ClaimBanned', 'Too many missed pickups'),
      ),
    );
    expect(
      banned,
      isA<ForbiddenFailure>().having((f) => f.code, 'code', 'ClaimBanned'),
    );
    final plain = failureFromError(
      response(403, backendError(403, 'Forbidden', 'No')),
    );
    expect((plain as ForbiddenFailure).code, isNull);
  });

  test('keeps the server message for conflicts', () {
    final failure = failureFromError(
      response(409, backendError(409, 'Conflict', 'Sold out')),
    );
    expect(
      failure,
      isA<ConflictFailure>().having(
        (f) => f.serverMessage,
        'message',
        'Sold out',
      ),
    );
  });

  test('maps other statuses', () {
    expect(failureFromError(response(401, null)), isA<UnauthorizedFailure>());
    expect(failureFromError(response(404, null)), isA<NotFoundFailure>());
    expect(failureFromError(response(429, null)), isA<RateLimitedFailure>());
    expect(
      failureFromError(response(502, 'Bad gateway')),
      isA<ServerFailure>(),
    );
    expect(failureFromError(StateError('bug')), isA<UnknownFailure>());
  });
}
