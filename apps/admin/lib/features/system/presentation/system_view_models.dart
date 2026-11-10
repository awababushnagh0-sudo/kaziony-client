import 'dart:async';

import 'package:kernel/kernel.dart';

import '../domain/database_stats.dart';
import '../domain/system_error.dart';
import '../domain/system_job.dart';
import '../domain/system_overview.dart';
import '../domain/system_repository.dart';
import '../domain/system_traffic.dart';

/// How often a System tab reloads while it's open: instances report every
/// 10 seconds.
const systemRefreshEvery = Duration(seconds: 15);

/// Loaded data that reloads itself every [systemRefreshEvery] while shown.
/// A reload that fails keeps what's on screen (the sidebar's "checked"
/// time shows how old it is); [reload] shows the failure.
abstract class LiveViewModel<T> extends AsyncViewModel<T> {
  Future<Result<T>> load();

  @override
  Future<T> build() async {
    final timer = Timer.periodic(systemRefreshEvery, (_) => _refresh());
    ref.onDispose(timer.cancel);
    return switch (await load()) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }

  Future<void> _refresh() => refreshNow();

  /// Loads again without leaving what's on screen (the open tab stays
  /// open). The failure, if it fails.
  Future<AppFailure?> refreshNow() async {
    final result = await load();
    if (!ref.mounted) return null;
    switch (result) {
      case Ok(:final value):
        state = AsyncData(value);
        return null;
      case Err(:final failure):
        return failure;
    }
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    ref.invalidateSelf();
    await future;
  }
}

class SystemOverviewViewModel extends LiveViewModel<SystemOverview> {
  @override
  Future<Result<SystemOverview>> load() =>
      ref.read(systemRepositoryProvider).overview();
}

final systemOverviewViewModel =
    AsyncNotifierProvider.autoDispose<SystemOverviewViewModel, SystemOverview>(
      SystemOverviewViewModel.new,
    );

/// How far back the traffic tab looks, in minutes.
class TrafficWindowViewModel extends ViewModel<int> {
  static const choices = [15, 60];

  @override
  int build() => choices.last;

  void choose(int minutes) => state = minutes;
}

final trafficWindowViewModel =
    NotifierProvider.autoDispose<TrafficWindowViewModel, int>(
      TrafficWindowViewModel.new,
    );

class SystemTrafficViewModel extends LiveViewModel<SystemTraffic> {
  @override
  Future<SystemTraffic> build() {
    // Another window loads again.
    ref.watch(trafficWindowViewModel);
    return super.build();
  }

  @override
  Future<Result<SystemTraffic>> load() => ref
      .read(systemRepositoryProvider)
      .traffic(minutes: ref.read(trafficWindowViewModel));
}

final systemTrafficViewModel =
    AsyncNotifierProvider.autoDispose<SystemTrafficViewModel, SystemTraffic>(
      SystemTrafficViewModel.new,
    );

class SystemErrorsViewModel extends LiveViewModel<List<SystemError>> {
  @override
  Future<Result<List<SystemError>>> load() =>
      ref.read(systemRepositoryProvider).errors();
}

final systemErrorsViewModel =
    AsyncNotifierProvider.autoDispose<SystemErrorsViewModel, List<SystemError>>(
      SystemErrorsViewModel.new,
    );

class SystemJobsViewModel extends LiveViewModel<List<SystemJob>> {
  @override
  Future<Result<List<SystemJob>>> load() =>
      ref.read(systemRepositoryProvider).jobs();

  /// Runs [name] now; the list shows how it went. Null when it ran, even
  /// if the job itself failed (its card says so).
  Future<AppFailure?> run(String name) async {
    final result = await ref.read(systemRepositoryProvider).runJob(name);
    switch (result) {
      case Ok(:final value):
        final jobs = state.value;
        if (ref.mounted && jobs != null) {
          state = AsyncData([
            for (final job in jobs) job.name == name ? value : job,
          ]);
        }
        return null;
      case Err(:final failure):
        return failure;
    }
  }
}

final systemJobsViewModel =
    AsyncNotifierProvider.autoDispose<SystemJobsViewModel, List<SystemJob>>(
      SystemJobsViewModel.new,
    );

class DatabaseStatsViewModel extends LiveViewModel<DatabaseStats> {
  @override
  Future<Result<DatabaseStats>> load() =>
      ref.read(systemRepositoryProvider).database();
}

final databaseStatsViewModel =
    AsyncNotifierProvider.autoDispose<DatabaseStatsViewModel, DatabaseStats>(
      DatabaseStatsViewModel.new,
    );
