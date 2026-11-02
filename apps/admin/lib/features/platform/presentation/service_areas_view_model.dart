import 'package:kernel/kernel.dart';

import '../domain/service_area.dart';

/// Where Kaziony works, as saved on the server.
class ServiceAreasViewModel extends AsyncViewModel<List<ServiceArea>> {
  @override
  Future<List<ServiceArea>> build() async =>
      (await ref.watch(serviceAreaRepositoryProvider).list()).valueOrThrow;
}

final serviceAreasViewModel =
    AsyncNotifierProvider.autoDispose<ServiceAreasViewModel, List<ServiceArea>>(
      ServiceAreasViewModel.new,
    );
