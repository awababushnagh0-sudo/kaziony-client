import 'dart:async';

import 'package:customer/features/auth/domain/auth_repository.dart';
import 'package:customer/features/location/domain/browse_location.dart';
import 'package:kernel/kernel.dart';

SessionUser customer({String? name = 'Ahmed', String? email = 'a@gmail.com'}) =>
    SessionUser(
      id: 'c1',
      role: AccountRole.customer,
      name: name,
      phone: null,
      email: email,
      contactPhone: null,
      mustChangePassword: false,
      memberships: const [],
    );

class FakeAuthRepository implements AuthRepository {
  Result<SessionUser?> signInResult = Ok(customer());

  /// When set, sign-ins wait for it, to see the page while signing in.
  Completer<void>? hold;
  var signIns = 0;
  var signOuts = 0;

  @override
  Future<Result<SessionUser?>> signInWithGoogle() async {
    signIns++;
    await hold?.future;
    return signInResult;
  }

  @override
  Future<void> signOut() async => signOuts++;
}

/// A session that is already signed in as [user], without the backend.
class SignedInSession extends SessionController {
  SignedInSession(this.user);

  final SessionUser user;

  @override
  SessionState build() => SignedIn(user);
}

const tripoli = ServiceArea(
  nameAr: 'طرابلس',
  nameEn: 'Tripoli',
  center: GeoPoint(32.85, 13.18),
  radiusKm: 30,
);

/// Inside [tripoli], where [FakeLocationFinder] puts the phone too.
const souqAlJuma = GeoPoint(32.9, 13.22);

/// Outside [tripoli]: 45 km west.
const zawiya = GeoPoint(32.757, 12.727);

class FakeServiceAreaRepository implements ServiceAreaRepository {
  Result<List<ServiceArea>> result = const Ok([tripoli]);
  var loads = 0;

  @override
  Future<Result<List<ServiceArea>>> areas() async {
    loads++;
    return result;
  }
}
