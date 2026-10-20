import 'package:business/features/auth/domain/auth_repository.dart';
import 'package:business/features/auth/presentation/login/login_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';

import '../../fakes.dart';

void main() {
  late FakeAuthRepository auth;
  late ProviderContainer container;
  late LoginViewModel viewModel;

  setUp(() {
    auth = FakeAuthRepository();
    container = ProviderContainer(
      overrides: [
        ...testOverrides(),
        authRepositoryProvider.overrideWithValue(auth),
      ],
    );
    addTearDown(container.dispose);
    // Keep the auto-dispose view model alive during the test.
    container.listen(loginViewModel, (_, _) {});
    viewModel = container.read(loginViewModel.notifier);
  });

  void fill(String phone, String password) {
    viewModel.form.control('phone').value = phone;
    viewModel.form.control('password').value = password;
  }

  test('does not call the backend while the form is invalid', () async {
    fill('123', '');
    await viewModel.submit();
    expect(auth.logins, isEmpty);
    expect(viewModel.form.control('phone').touched, isTrue);
  });

  test('sends the normalized phone number', () async {
    fill('091 000 0001', 'secret');
    await viewModel.submit();
    expect(auth.logins, [('+218910000001', 'secret')]);
    expect(container.read(loginViewModel).problem, isNull);
  });

  test('explains wrong details and disabled accounts', () async {
    fill('0910000001', 'wrong');
    auth.loginResult = const Err(UnauthorizedFailure());
    await viewModel.submit();
    expect(
      container.read(loginViewModel).problem,
      LoginProblem.wrongCredentials,
    );

    auth.loginResult = const Err(ForbiddenFailure());
    await viewModel.submit();
    expect(
      container.read(loginViewModel).problem,
      LoginProblem.accountDisabled,
    );
  });

  test('logs customers and admins straight out again', () async {
    fill('0910000001', 'secret');
    auth.loginResult = Ok(user(role: AccountRole.admin));
    await viewModel.submit();
    expect(auth.logouts, 1);
    expect(
      container.read(loginViewModel).problem,
      LoginProblem.notStoreAccount,
    );
  });

  test('keeps other failures for the screen to show', () async {
    fill('0910000001', 'secret');
    auth.loginResult = const Err(NoConnectionFailure());
    await viewModel.submit();
    expect(container.read(loginViewModel).failure, isA<NoConnectionFailure>());
    expect(container.read(loginViewModel).submitting, isFalse);
  });
}
