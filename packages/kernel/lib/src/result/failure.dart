/// Why an operation failed, in terms the UI can act on.
///
/// [serverMessage] is the backend's message (English) when there is one.
/// The UI shows its own translated text per failure type and only falls
/// back to the server message where noted.
sealed class AppFailure {
  const AppFailure([this.serverMessage]);

  final String? serverMessage;

  @override
  String toString() => '$runtimeType(${serverMessage ?? ''})';
}

/// No internet, DNS failure, server unreachable.
final class NoConnectionFailure extends AppFailure {
  const NoConnectionFailure();
}

/// The server didn't answer in time.
final class TimeoutFailure extends AppFailure {
  const TimeoutFailure();
}

/// Not logged in, or the session ended (also wrong login details).
final class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure([super.serverMessage]);
}

/// The user must change their temporary password first.
final class PasswordChangeRequiredFailure extends AppFailure {
  const PasswordChangeRequiredFailure([super.serverMessage]);
}

/// Logged in but not allowed. [code] is the backend's `error` field
/// (e.g. `ClaimBanned`) when it's more specific than "Forbidden".
final class ForbiddenFailure extends AppFailure {
  const ForbiddenFailure({this.code, String? serverMessage})
    : super(serverMessage);

  final String? code;
}

/// The request was rejected as invalid. [messages] are the backend's
/// validation messages; [code] is its `error` field when it's more specific
/// than "Bad Request" (e.g. `LocationOutsideLibya`).
final class ValidationFailure extends AppFailure {
  const ValidationFailure(this.messages, {this.code}) : super(null);

  final List<String> messages;
  final String? code;

  @override
  String? get serverMessage => messages.isEmpty ? null : messages.join('\n');
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure([super.serverMessage]);
}

/// The action conflicts with the current state (already redeemed, sold
/// out, duplicate phone, ...). The server message explains which.
final class ConflictFailure extends AppFailure {
  const ConflictFailure([super.serverMessage]);
}

/// Too many attempts; try again in a minute.
final class RateLimitedFailure extends AppFailure {
  const RateLimitedFailure();
}

/// Something broke on the server (5xx).
final class ServerFailure extends AppFailure {
  const ServerFailure(this.statusCode);

  final int statusCode;
}

/// Anything else (a bug, an unexpected response).
final class UnknownFailure extends AppFailure {
  const UnknownFailure(this.error);

  final Object error;
}
