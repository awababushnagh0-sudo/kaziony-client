import 'dart:async';

import 'package:customer/features/auth/domain/auth_repository.dart';
import 'package:customer/features/auth/presentation/sign_in_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';

import '../../fakes.dart';

void main() {
  late FakeAuthRepository auth;
  late ProviderContainer container;
  late SignInViewModel viewModel;

  setUp(() {
    auth = FakeAuthRepository();
    container = ProviderContainer(
      overrides: [
        ...testOverrides(kind: AppKind.customer),
        authRepositoryProvider.overrideWithValue(auth),
      ],
    );
    addTearDown(container.dispose);
    // Keep the auto-dispose view model alive during the test.
    container.listen(signInViewModel, (_, _) {});
    viewModel = container.read(signInViewModel.notifier);
  });

  test('says yes once signed in', () async {
    expect(await viewModel.signInWithGoogle(), isTrue);
    expect(container.read(signInViewModel).failure, isNull);
  });

  test('closing Google\'s sheet is not an error', () async {
    auth.signInResult = const Ok(null);
    expect(await viewModel.signInWithGoogle(), isFalse);
    expect(container.read(signInViewModel).failure, isNull);
    expect(container.read(signInViewModel).signingIn, isFalse);
  });

  test('keeps the failure for the page to explain', () async {
    auth.signInResult = const Err(NoConnectionFailure());
    expect(await viewModel.signInWithGoogle(), isFalse);
    expect(container.read(signInViewModel).failure, isA<NoConnectionFailure>());
  });

  test('a second tap while signing in does nothing', () async {
    auth.hold = Completer();
    final first = viewModel.signInWithGoogle();
    expect(container.read(signInViewModel).signingIn, isTrue);
    expect(await viewModel.signInWithGoogle(), isFalse);
    auth.hold!.complete();
    expect(await first, isTrue);
    expect(auth.signIns, 1);
  });
}
