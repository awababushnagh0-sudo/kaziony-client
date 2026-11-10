/// One kind of server error: the same error on the same route, however
/// many times it happened.
class SystemError {
  const SystemError({
    required this.name,
    required this.message,
    required this.method,
    required this.route,
    required this.statusCode,
    required this.count,
    required this.firstSeenAt,
    required this.lastSeenAt,
    required this.lastRequestId,
    required this.stack,
    required this.instances,
  });

  /// "TypeError".
  final String name;

  /// In the server's words (English): for whoever fixes it.
  final String message;
  final String method;
  final String route;
  final int statusCode;
  final int count;
  final DateTime firstSeenAt;
  final DateTime lastSeenAt;

  /// Finds the last occurrence in the server's logs.
  final String? lastRequestId;
  final String? stack;

  /// Instances it happened on.
  final int instances;
}
