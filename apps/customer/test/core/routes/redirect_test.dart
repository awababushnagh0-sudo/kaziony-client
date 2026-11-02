import 'package:customer/core/routes/redirect.dart';
import 'package:customer/core/routes/routes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

void main() {
  String? redirect(
    String location, {
    UpdateStatus update = UpdateStatus.upToDate,
    bool hasLocation = true,
  }) =>
      redirectFor(update: update, hasLocation: hasLocation, location: location);

  test('stays on the tabs while the version is fine or being checked', () {
    for (final update in [UpdateStatus.checking, UpdateStatus.upToDate]) {
      expect(redirect(Routes.home, update: update), isNull);
      expect(redirect(Routes.account, update: update), isNull);
    }
  });

  test('stops on the update page when the app is too old', () {
    const tooOld = UpdateStatus.updateRequired;
    expect(redirect(Routes.home, update: tooOld), Routes.update);
    expect(redirect(Routes.welcome, update: tooOld), Routes.update);
    expect(redirect(Routes.update, update: tooOld), isNull);
  });

  test('leaves the update page once the version is fine', () {
    expect(redirect(Routes.update), Routes.home);
  });

  test('without a place, everything leads to the welcome pages', () {
    expect(redirect(Routes.home, hasLocation: false), Routes.welcome);
    expect(redirect(Routes.account, hasLocation: false), Routes.welcome);
    expect(redirect(Routes.signIn, hasLocation: false), Routes.welcome);
    expect(redirect(Routes.locationMap, hasLocation: false), Routes.welcome);
  });

  test('the welcome pages and the terms open without a place', () {
    for (final page in [
      Routes.welcome,
      Routes.welcomeLocation,
      Routes.welcomeMap,
      Routes.welcomeSignIn,
      Routes.terms,
    ]) {
      expect(redirect(page, hasLocation: false), isNull, reason: page);
    }
  });

  test('the welcome pages stay reachable once there is a place', () {
    // The sign-in page at their end comes after the place is chosen.
    expect(redirect(Routes.welcomeSignIn), isNull);
  });
}
