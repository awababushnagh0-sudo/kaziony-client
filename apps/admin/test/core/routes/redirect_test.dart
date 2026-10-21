import 'package:admin/core/routes/redirect.dart';
import 'package:admin/core/routes/routes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../../fakes.dart';

void main() {
  String? go(
    SessionState session,
    String location, {
    UpdateStatus update = UpdateStatus.upToDate,
  }) => redirectFor(session: session, update: update, uri: Uri.parse(location));

  test('waits on the splash while the session is restored', () {
    expect(go(const SessionRestoring(), Routes.splash), isNull);
    expect(go(const SessionRestoring(), Routes.home), '/?from=%2Fhome');
  });

  test('sends signed-out users to login from any page', () {
    expect(go(const SignedOut(), Routes.login), isNull);
    expect(go(const SignedOut(), Routes.stores), '/login?from=%2Fstores');
  });

  test('a reload lands back on the same page', () {
    // Reloading /stores?q=x: splash while restoring, then back to it.
    final splash = go(const SessionRestoring(), '/stores?q=x')!;
    expect(splash, '/?from=%2Fstores%3Fq%3Dx');
    expect(go(SignedIn(user()), splash), '/stores?q=x');
  });

  test('signing in goes to the page the user was heading to', () {
    final login = go(const SignedOut(), '/?from=%2Fstores')!;
    expect(login, '/login?from=%2Fstores');
    expect(go(SignedIn(user()), login), Routes.stores);
  });

  test('ignores a "from" that is not one of our pages', () {
    for (final from in ['https://evil.example', '//evil.example', '/login']) {
      final login = '/login?from=${Uri.encodeComponent(from)}';
      expect(go(SignedIn(user()), login), Routes.home, reason: from);
    }
  });

  test('forces a temporary password to be changed first', () {
    final session = SignedIn(user(mustChangePassword: true));
    expect(go(session, Routes.home), '/change-password?from=%2Fhome');
    expect(go(session, Routes.changePassword), isNull);
  });

  test('takes signed-in admins from the entry pages to home', () {
    final session = SignedIn(user());
    expect(go(session, Routes.login), Routes.home);
    expect(go(session, Routes.changePassword), Routes.home);
    expect(go(session, Routes.splash), Routes.home);
  });

  test('lets signed-in admins open any dashboard page', () {
    final session = SignedIn(user());
    for (final page in [
      Routes.home,
      Routes.stores,
      Routes.users,
      Routes.offers,
      Routes.categories,
    ]) {
      expect(go(session, page), isNull, reason: page);
    }
  });

  test('blocks everything when an update is required', () {
    expect(
      go(SignedIn(user()), Routes.home, update: UpdateStatus.updateRequired),
      Routes.update,
    );
  });
}
