/// One minute of requests, every instance together.
class TrafficMinute {
  const TrafficMinute({
    required this.at,
    required this.requests,
    required this.serverErrors,
    required this.p95Ms,
  });

  /// Start of the minute.
  final DateTime at;
  final int requests;
  final int serverErrors;
  final int? p95Ms;
}

/// Requests to one route of the API.
class RouteTraffic {
  const RouteTraffic({
    required this.method,
    required this.route,
    required this.requests,
    required this.clientErrors,
    required this.serverErrors,
    required this.p50Ms,
    required this.p95Ms,
    required this.p99Ms,
  });

  /// "GET".
  final String method;

  /// As written in the code: "/api/v1/offers/:id".
  final String route;
  final int requests;

  /// 4xx: the app or the person asked for something wrong.
  final int clientErrors;

  /// 5xx: our fault.
  final int serverErrors;
  final int? p50Ms;
  final int? p95Ms;
  final int? p99Ms;
}

class SystemTraffic {
  const SystemTraffic({required this.minutes, required this.routes});

  /// Every minute of the window, oldest first.
  final List<TrafficMinute> minutes;

  /// Busiest first.
  final List<RouteTraffic> routes;

  int get requests => minutes.fold(0, (sum, minute) => sum + minute.requests);
  int get serverErrors =>
      minutes.fold(0, (sum, minute) => sum + minute.serverErrors);
}
