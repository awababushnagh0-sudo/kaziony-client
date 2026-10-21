import 'package:kernel/kernel.dart';

import '../domain/dashboard_stats.dart';

class DashboardViewModel extends AsyncViewModel<DashboardStats> {
  @override
  Future<DashboardStats> build() async {
    final result = await ref.watch(dashboardRepositoryProvider).getStats();
    return switch (result) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    ref.invalidateSelf();
    await future;
  }
}

final dashboardViewModel =
    AsyncNotifierProvider.autoDispose<DashboardViewModel, DashboardStats>(
      DashboardViewModel.new,
    );
