import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LogLevel { debug, info, warning, error }

class AppLogEntry {
  AppLogEntry(this.level, this.message, [this.stack]) : time = DateTime.now();

  final DateTime time;
  final LogLevel level;
  final String message;
  final String? stack;
}

class HttpLogEntry {
  HttpLogEntry({
    required this.id,
    required this.method,
    required this.url,
    required this.requestHeaders,
    required this.requestBody,
  }) : time = DateTime.now();

  final int id;
  final DateTime time;
  final String method;
  final String url;
  final Map<String, String> requestHeaders;
  final String? requestBody;

  int? status;
  String? responseBody;
  String? error;
  Duration? duration;

  bool get pending => status == null && error == null;
  bool get failed => error != null || (status ?? 0) >= 400;
}

/// Recent requests and log messages, shown in the dev menu.
/// Only filled in dev and staging builds.
class DevLog extends ChangeNotifier {
  static const maxEntries = 200;
  static const _maxBodyLength = 20000;

  final http = <HttpLogEntry>[];
  final logs = <AppLogEntry>[];
  var _nextId = 0;

  void log(LogLevel level, String message, [StackTrace? stack]) {
    _add(logs, AppLogEntry(level, message, stack?.toString()));
  }

  HttpLogEntry startRequest({
    required String method,
    required String url,
    required Map<String, Object?> headers,
    required Object? body,
  }) {
    final entry = HttpLogEntry(
      id: _nextId++,
      method: method,
      url: url,
      requestHeaders: {
        for (final MapEntry(:key, :value) in headers.entries)
          key: _isSecretHeader(key) ? '•••' : '$value',
      },
      requestBody: describeBody(body),
    );
    _add(http, entry);
    return entry;
  }

  void finishRequest(
    HttpLogEntry entry, {
    int? status,
    Object? responseBody,
    String? error,
  }) {
    entry
      ..status = status
      ..responseBody = describeBody(responseBody)
      ..error = error
      ..duration = DateTime.now().difference(entry.time);
    notifyListeners();
  }

  void clear() {
    http.clear();
    logs.clear();
    notifyListeners();
  }

  void _add<T>(List<T> list, T entry) {
    list.insert(0, entry);
    if (list.length > maxEntries) list.removeLast();
    notifyListeners();
  }

  /// Pretty JSON with secrets hidden, shortened if huge.
  static String? describeBody(Object? body) {
    if (body == null) return null;
    String text;
    if (body is Map || body is List) {
      text = const JsonEncoder.withIndent('  ').convert(redactSecrets(body));
    } else if (body is String) {
      try {
        text = describeBody(jsonDecode(body)) ?? body;
      } on FormatException {
        text = body;
      }
    } else {
      // Multipart uploads and other non-JSON bodies.
      text = '<${body.runtimeType}>';
    }
    return text.length > _maxBodyLength
        ? '${text.substring(0, _maxBodyLength)}\n… (${text.length} characters)'
        : text;
  }

  static bool _isSecretHeader(String name) {
    final lower = name.toLowerCase();
    return lower == 'authorization' || lower == 'cookie';
  }
}

const _secretKeys = {
  'password',
  'currentpassword',
  'newpassword',
  'accesstoken',
  'refreshtoken',
  'idtoken',
  'temporarypassword',
};

/// Replaces passwords and tokens in a JSON value with "•••", so they never
/// appear in the dev menu or in copied logs.
Object? redactSecrets(Object? value) => switch (value) {
  Map() => {
    for (final MapEntry(:key, :value) in value.entries)
      '$key': _secretKeys.contains('$key'.toLowerCase())
          ? '•••'
          : redactSecrets(value),
  },
  List() => [for (final item in value) redactSecrets(item)],
  _ => value,
};

/// Set by `bootstrap` (it also captures debugPrint before the app starts).
final devLogProvider = Provider<DevLog>((ref) => DevLog());
