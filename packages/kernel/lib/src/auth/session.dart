import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_api/auth.dart' as api;

import '../errors/error_reporter.dart';
import '../network/api.dart';
import '../result/failure.dart';
import '../result/result.dart';
import '../storage/storage.dart';
import 'session_user.dart';
import 'token_store.dart';

sealed class SessionState {
  const SessionState();
}

/// Reading the saved session at startup.
final class SessionRestoring extends SessionState {
  const SessionRestoring();
}

final class SignedOut extends SessionState {
  const SignedOut({this.expired = false});

  /// True when the session ended on its own (e.g. disabled account,
  /// password reset), so the login screen can say why.
  final bool expired;
}

final class SignedIn extends SessionState {
  const SignedIn(this.user);

  final SessionUser user;
}

/// The logged-in user and their tokens, shared by all features.
class SessionController extends Notifier<SessionState> {
  static const _userKey = 'session.user';

  late TokenStore _tokens;
  late SecureStore _storage;

  @override
  SessionState build() {
    _tokens = ref.watch(tokenStoreProvider);
    _storage = ref.watch(secureStoreProvider);
    unawaited(Future.microtask(_restore));
    return const SessionRestoring();
  }

  SessionUser? get currentUser => switch (state) {
    SignedIn(:final user) => user,
    _ => null,
  };

  /// Merchant (phone) or admin (email) login.
  Future<Result<SessionUser>> loginWithPassword(
    String identifier,
    String password,
  ) async {
    final publicApi = ref.read(publicApiProvider);
    final auth = publicApi.client(api.AuthClient.new);
    final result = await publicApi.guard(
      () => auth.login(
        body: api.LoginDto(identifier: identifier, password: password),
      ),
    );
    return switch (result) {
      Ok(:final value) => _start(value),
      Err(:final failure) => Err(failure),
    };
  }

  /// Replaces a temporary (or old) password. Other devices are logged out.
  Future<Result<SessionUser>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final authApi = ref.read(apiProvider);
    final auth = authApi.client(api.AuthClient.new);
    final result = await authApi.guard(
      () => auth.changePassword(
        body: api.ChangePasswordDto(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      ),
    );
    return switch (result) {
      Ok(:final value) => _start(value),
      Err(:final failure) => Err(failure),
    };
  }

  /// Reloads the user (e.g. after store details change).
  Future<Result<SessionUser>> reloadUser() async {
    final result = await _fetchMe();
    if (result case Ok(:final value)) await _setUser(value);
    return result;
  }

  /// Called by the HTTP layer when the access token expired.
  /// Returns false when the session is over.
  Future<bool> refreshTokens() async {
    final refreshToken = _tokens.current?.refreshToken;
    if (refreshToken == null) return false;

    final publicApi = ref.read(publicApiProvider);
    final auth = publicApi.client(api.AuthClient.new);
    final result = await publicApi.guard(
      () => auth.refresh(body: api.RefreshTokenDto(refreshToken: refreshToken)),
    );
    switch (result) {
      case Ok(:final value):
        await _tokens.save(_tokensOf(value));
        return true;
      case Err(failure: UnauthorizedFailure() || ForbiddenFailure()):
        await _end(expired: true);
        return false;
      case Err():
        // Offline or server trouble: keep the session, try again later.
        return false;
    }
  }

  /// Dev menu: the current access token (to show when it expires).
  String? get debugAccessToken => _tokens.current?.accessToken;

  /// Dev menu: replaces the access token with an invalid one, so the next
  /// request gets a 401 and exercises the refresh flow.
  Future<void> debugExpireAccessToken() async {
    final tokens = _tokens.current;
    if (tokens == null) return;
    await _tokens.save(
      AuthTokens(
        accessToken: 'expired-by-dev-menu',
        refreshToken: tokens.refreshToken,
      ),
    );
  }

  Future<void> signOut() async {
    final refreshToken = _tokens.current?.refreshToken;
    if (refreshToken != null) {
      final publicApi = ref.read(publicApiProvider);
      final auth = publicApi.client(api.AuthClient.new);
      // Best effort: logging out locally must work offline too.
      await publicApi.guard(
        () =>
            auth.logout(body: api.RefreshTokenDto(refreshToken: refreshToken)),
      );
    }
    await _end();
  }

  Future<void> _restore() async {
    final tokens = await _tokens.load();
    if (tokens == null) {
      state = const SignedOut();
      return;
    }
    final cached = await _cachedUser();
    switch (await _fetchMe()) {
      case Ok(:final value):
        await _setUser(value);
      case Err(failure: UnauthorizedFailure() || ForbiddenFailure()):
        await _end(expired: true);
      case Err():
        // No connection: open with the cached user if we have one.
        if (cached != null) {
          state = SignedIn(cached);
        } else {
          await _end();
        }
    }
  }

  Future<Result<SessionUser>> _start(api.AuthResponseDto response) async {
    await _tokens.save(_tokensOf(response));
    final result = await _fetchMe();
    switch (result) {
      case Ok(:final value):
        await _setUser(value);
      case Err():
        await _end();
    }
    return result;
  }

  Future<Result<SessionUser>> _fetchMe() async {
    final authApi = ref.read(apiProvider);
    final auth = authApi.client(api.AuthClient.new);
    final result = await authApi.guard(auth.me);
    return result.map(SessionUser.fromMe);
  }

  Future<void> _setUser(SessionUser user) async {
    await _storage.write(_userKey, jsonEncode(user.toJson()));
    ref.read(errorReporterProvider).setUser(user.id);
    if (ref.mounted) state = SignedIn(user);
  }

  Future<SessionUser?> _cachedUser() async {
    final raw = await _storage.read(_userKey);
    if (raw == null) return null;
    try {
      return SessionUser.fromJson(jsonDecode(raw) as Map<String, Object?>);
    } on Object {
      return null;
    }
  }

  Future<void> _end({bool expired = false}) async {
    await _tokens.clear();
    await _storage.delete(_userKey);
    ref.read(errorReporterProvider).setUser(null);
    if (ref.mounted) state = SignedOut(expired: expired);
  }
}

AuthTokens _tokensOf(api.AuthResponseDto response) => AuthTokens(
  accessToken: response.accessToken,
  refreshToken: response.refreshToken,
);

final sessionProvider = NotifierProvider<SessionController, SessionState>(
  SessionController.new,
);
