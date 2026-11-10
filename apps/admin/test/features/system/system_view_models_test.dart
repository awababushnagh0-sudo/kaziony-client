import 'package:admin/features/system/domain/system_repository.dart';
import 'package:admin/features/system/presentation/system_view_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../../fakes.dart';

/// Shows [providers] (keeps them alive) against [system].
ProviderContainer showing(
  FakeSystemRepository system,
  List<ProviderListenable<Object?>> providers,
) {
  final container = ProviderContainer(
    overrides: [systemRepositoryProvider.overrideWithValue(system)],
  );
  for (final provider in providers) {
    container.listen(provider, (_, _) {});
  }
  return container;
}

void main() {
  testWidgets('reloads while shown, and stops once closed', (tester) async {
    // Built here, so its timer runs on the test's clock.
    final system = FakeSystemRepository();
    final container = showing(system, [systemOverviewViewModel]);
    await tester.pump();
    expect(system.overviewCalls, 1);

    await tester.pump(systemRefreshEvery);
    expect(system.overviewCalls, 2);

    container.dispose();
    await tester.pump(systemRefreshEvery * 2);
    expect(system.overviewCalls, 2);
  });

  test('a failed reload keeps what is on screen', () async {
    final system = FakeSystemRepository();
    final container = showing(system, [systemOverviewViewModel]);
    addTearDown(container.dispose);
    await container.read(systemOverviewViewModel.future);
    system.overviewResult = const Err(NoConnectionFailure());

    final failure = await container
        .read(systemOverviewViewModel.notifier)
        .refreshNow();

    expect(failure, isA<NoConnectionFailure>());
    expect(container.read(systemOverviewViewModel).value?.p95Ms, 85);
  });

  test('running a job puts how it went in the list', () async {
    final system = FakeSystemRepository();
    final container = showing(system, [systemJobsViewModel]);
    addTearDown(container.dispose);
    await container.read(systemJobsViewModel.future);

    final failure = await container
        .read(systemJobsViewModel.notifier)
        .run('expire-claims');

    expect(failure, isNull);
    final jobs = container.read(systemJobsViewModel).value!;
    expect(
      [for (final job in jobs) (job.name, job.runs)],
      [('expire-claims', 13), ('clean-refresh-tokens', 0)],
    );
  });

  test('a job that could not run leaves the list as it was', () async {
    final system = FakeSystemRepository()
      ..runResult = const Err(ConflictFailure(null, 'JobRunning'));
    final container = showing(system, [systemJobsViewModel]);
    addTearDown(container.dispose);
    await container.read(systemJobsViewModel.future);

    final failure = await container
        .read(systemJobsViewModel.notifier)
        .run('expire-claims');

    expect(failure, isA<ConflictFailure>());
    expect(container.read(systemJobsViewModel).value!.first.runs, 12);
  });

  test('another traffic window loads again', () async {
    final system = FakeSystemRepository();
    final container = showing(system, [systemTrafficViewModel]);
    addTearDown(container.dispose);
    await container.read(systemTrafficViewModel.future);

    container.read(trafficWindowViewModel.notifier).choose(15);
    await container.read(systemTrafficViewModel.future);

    expect(system.trafficWindows, [60, 15]);
  });
}
