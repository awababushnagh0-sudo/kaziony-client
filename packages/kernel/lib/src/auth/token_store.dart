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

  AuthTokens? get current => _current;

  Future<AuthTokens?> load() async {
    final raw = await _storage.read(_key);
    if (raw == null) return _current = null;
    try {
      return _current = AuthTokens.fromJson(
        jsonDecode(raw) as Map<String, Object?>,
      );
    } on Object {
      await clear();
      return null;
    }
  }

  Future<void> save(AuthTokens tokens) async {
    _current = tokens;
    await _storage.write(_key, jsonEncode(tokens.toJson()));
  }

  Future<void> clear() async {
    _current = null;
    await _storage.delete(_key);
  }
}

final tokenStoreProvider = Provider<TokenStore>(
  (ref) => TokenStore(ref.watch(secureStoreProvider)),
);
