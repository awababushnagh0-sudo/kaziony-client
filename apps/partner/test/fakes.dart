import 'package:kernel/kernel.dart';
import 'package:partner/features/auth/domain/auth_repository.dart';

SessionUser user({
  AccountRole role = AccountRole.merchant,
  bool mustChangePassword = false,
}) => SessionUser(
  id: 'u1',
  role: role,
  name: 'Test',
  phone: '+218910000001',
  email: null,
  contactPhone: null,
  mustChangePassword: mustChangePassword,
  memberships: const [],
);

class FakeAuthRepository implements AuthRepository {
  Result<SessionUser> loginResult = Ok(user());
  final logins = <(String, String)>[];
  var logouts = 0;

  @override
  Future<Result<SessionUser>> login(String phone, String password) async {
    logins.add((phone, password));
    return loginResult;
  }

  @override
  Future<Result<SessionUser>> changePassword(
    String current,
    String next,
  ) async => Ok(user());

  @override
  Future<void> logout() async => logouts++;
}
