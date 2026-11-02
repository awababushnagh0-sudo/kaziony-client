import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// What came of asking Google who the user is.
sealed class GooglePick {
  const GooglePick();
}

/// The user chose an account. [idToken] is what the backend checks.
final class GoogleSignedIn extends GooglePick {
  const GoogleSignedIn(this.idToken);

  final String idToken;
}

/// The user closed Google's sheet without choosing an account.
final class GoogleCancelled extends GooglePick {
  const GoogleCancelled();
}

/// Anything else: no Google services on the phone, a build that isn't
/// registered with Google, no connection.
final class GoogleFailed extends GooglePick {
  const GoogleFailed(this.error);

  final Object error;
}

/// This build's OAuth client IDs, from `--dart-define-from-file`: the web
/// one (`GOOGLE_SERVER_CLIENT_ID`), which the ID token is made for on
/// Android, and the iOS one (`GOOGLE_IOS_CLIENT_ID`). The Android client
/// needs no ID in the app: Google knows it by the package name and the
/// signing key.
@immutable
class GoogleClientIds {
  const GoogleClientIds({required this.server, required this.ios});

  const GoogleClientIds.fromEnvironment()
    : server = const String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID'),
      ios = const String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');

  final String server;
  final String ios;
}

/// Signs in with the Google account on the phone. Tests use a fake.
abstract interface class GoogleAuth {
  /// False on builds without Google client IDs (the partner app, the
  /// dashboard), where the button isn't shown.
  bool get available;

  /// Shows Google's account sheet.
  Future<GooglePick> signIn();

  /// Forgets the account, so the next [signIn] asks which one again.
  Future<void> signOut();
}

class DeviceGoogleAuth implements GoogleAuth {
  DeviceGoogleAuth(this._ids);

  final GoogleClientIds _ids;
  Future<void>? _initialized;

  bool get _onIos => defaultTargetPlatform == TargetPlatform.iOS;

  @override
  bool get available =>
      !kIsWeb &&
      switch (defaultTargetPlatform) {
        TargetPlatform.android => _ids.server.isNotEmpty,
        TargetPlatform.iOS => _ids.ios.isNotEmpty,
        _ => false,
      };

  // The plugin must be set up once, before anything else is asked of it.
  Future<void> _initialize() =>
      _initialized ??= GoogleSignIn.instance.initialize(
        clientId: _onIos ? _ids.ios : null,
        serverClientId: _ids.server,
      );

  @override
  Future<GooglePick> signIn() async {
    if (!available) return GoogleFailed(StateError('No Google client IDs'));
    try {
      await _initialize();
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) return GoogleFailed(StateError('No ID token'));
      return GoogleSignedIn(idToken);
    } on GoogleSignInException catch (error) {
      return switch (error.code) {
        GoogleSignInExceptionCode.canceled ||
        GoogleSignInExceptionCode.interrupted => const GoogleCancelled(),
        _ => GoogleFailed(error),
      };
    } on Object catch (error) {
      return GoogleFailed(error);
    }
  }

  @override
  Future<void> signOut() async {
    if (!available) return;
    try {
      await _initialize();
      await GoogleSignIn.instance.signOut();
    } on Object {
      // Leaving our app must work even if Google can't be reached.
    }
  }
}

final googleAuthProvider = Provider<GoogleAuth>(
  (ref) => DeviceGoogleAuth(const GoogleClientIds.fromEnvironment()),
);
