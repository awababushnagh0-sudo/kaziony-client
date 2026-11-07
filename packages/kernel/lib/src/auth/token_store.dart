import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage.dart';

class AuthTokens {
  const AuthTokens({required this.accessToken, required this.refreshToken});

  factory AuthTokens.fromJson(Map<String, Object?> json) => AuthTokens(
    accessToken: json['accessToken']! as String,
    refreshToken: json['refreshToken']! as String,
  );

  final String accessToken;
  final String refreshToken;

  Map<String, Object?> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };
}

/// Keeps the tokens in memory for every request and in secure storage
/// across app restarts.
class TokenStore {
  TokenStore(this._storage);

  static const _key = 'session.tokens';

  final SecureStore _storage;
  AuthTokens? _current;

  /// The read of the saved tokens, made once.
  Future<void>? _loading;

  /// Signed in or out since the app started: newer than what's saved.
  var _changed = false;

  AuthTokens? get current => _current;

  /// The tokens saved by the last run, read the first time it's called;
  /// every request waits on it, so none made at startup goes out without
  /// its token. Later calls answer at once with [current].
  Future<AuthTokens?> load() async {
    await (_loading ??= _read());
    return _current;
  }

  Future<void> _read() async {
    final raw = await _storage.read(_key);
    if (_changed || raw == null) return;
    try {
      _current = AuthTokens.fromJson(jsonDecode(raw) as Map<String, Object?>);
    } on Object {
      await clear();
    }
  }

  Future<void> save(AuthTokens tokens) async {
    _changed = true;
    _current = tokens;
    await _storage.write(_key, jsonEncode(tokens.toJson()));
  }

  Future<void> clear() async {
    _changed = true;
    _current = null;
    await _storage.delete(_key);
  }
}

final tokenStoreProvider = Provider<TokenStore>(
  (ref) => TokenStore(ref.watch(secureStoreProvider)),
);
