import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/routes/redirect.dart';
import 'package:partner/core/routes/routes.dart';

import '../../fakes.dart';

void main() {
  final inStore = SignedIn(user(memberships: [store('a')]));

  String? go(
    SessionState session,
    String location, {
    AsyncValue<String?> chosenStore = const AsyncData(null),
    UpdateStatus update = UpdateStatus.upToDate,
  }) => redirectFor(
    session: session,
    chosenStore: chosenStore,
    update: update,
    location: location,
  );

  test('waits on the splash while the session is restored', () {
    expect(go(const SessionRestoring(), Routes.home), Routes.splash);
    expect(go(const SessionRestoring(), Routes.splash), isNull);
  });

  test('sends signed-out users to login', () {
    expect(go(const SignedOut(), Routes.home), Routes.login);
    expect(go(const SignedOut(), Routes.login), isNull);
  });

  test('forces a temporary password to be changed first', () {
    final session = SignedIn(
      user(mustChangePassword: true, memberships: [store('a')]),
    );
    expect(go(session, Routes.home), Routes.changePassword);
    expect(go(session, Routes.changePassword), isNull);
  });

  test('takes members of one store from the entry screens to home', () {
    expect(go(inStore, Routes.login), Routes.home);
    expect(go(inStore, Routes.changePassword), Routes.home);
    expect(go(inStore, Routes.chooseStore), Routes.home);
    expect(go(inStore, Routes.home), isNull);
    expect(go(inStore, Routes.profile), isNull);
  });

  test('keeps staff out of the owner-only pages', () {
    final staff = SignedIn(user(memberships: [store('a', isOwner: false)]));
    expect(go(staff, Routes.products), Routes.home);
    expect(go(staff, Routes.product('p1')), Routes.home);
    expect(go(staff, Routes.newProduct), Routes.home);
    expect(go(inStore, Routes.products), isNull);
    expect(go(inStore, Routes.product('p1')), isNull);
  });

  test('sends accounts without a store to the no-store page', () {
    final session = SignedIn(user());
    expect(go(session, Routes.home), Routes.noStore);
    expect(go(session, Routes.noStore), isNull);
  });

  group('members of several stores', () {
    final session = SignedIn(user(memberships: [store('a'), store('b')]));

    test('wait while the store picked on this device is read', () {
      expect(
        go(session, Routes.login, chosenStore: const AsyncLoading()),
        Routes.splash,
      );
    });

    test('choose a store first', () {
      expect(go(session, Routes.home), Routes.chooseStore);
      expect(go(session, Routes.chooseStore), isNull);
    });

    test('choose again when the picked store is no longer theirs', () {
      expect(
        go(session, Routes.home, chosenStore: const AsyncData('gone')),
        Routes.chooseStore,
      );
    });

    test('go home once a store is picked', () {
      const chosen = AsyncData<String?>('b');
      expect(go(session, Routes.chooseStore, chosenStore: chosen), Routes.home);
      expect(go(session, Routes.home, chosenStore: chosen), isNull);
    });
  });

  test('blocks everything when an update is required', () {
    expect(
      go(inStore, Routes.home, update: UpdateStatus.updateRequired),
      Routes.update,
    );
    // Still checking (or offline): don't block.
    expect(go(inStore, Routes.home, update: UpdateStatus.checking), isNull);
  });
}
