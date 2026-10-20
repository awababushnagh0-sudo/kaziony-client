import 'package:business/app/router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../fakes.dart';

void main() {
  String? go(
    SessionState session,
    String location, {
    UpdateStatus update = UpdateStatus.upToDate,
  }) => redirectFor(session: session, update: update, location: location);

  test('waits on the splash while the session is restored', () {
    expect(go(const SessionRestoring(), Routes.home), Routes.splash);
    expect(go(const SessionRestoring(), Routes.splash), isNull);
  });

  test('sends signed-out users to login', () {
    expect(go(const SignedOut(), Routes.home), Routes.login);
    expect(go(const SignedOut(), Routes.login), isNull);
  });

  test('forces a temporary password to be changed first', () {
    final session = SignedIn(user(mustChangePassword: true));
    expect(go(session, Routes.home), Routes.changePassword);
    expect(go(session, Routes.changePassword), isNull);
  });

  test('takes signed-in users from the entry screens to home', () {
    final session = SignedIn(user());
    expect(go(session, Routes.login), Routes.home);
    expect(go(session, Routes.changePassword), Routes.home);
    expect(go(session, Routes.home), isNull);
  });

  test('blocks everything when an update is required', () {
    expect(
      go(SignedIn(user()), Routes.home, update: UpdateStatus.updateRequired),
      Routes.update,
    );
    // Still checking (or offline): don't block.
    expect(
      go(SignedIn(user()), Routes.home, update: UpdateStatus.checking),
      isNull,
    );
  });
}
