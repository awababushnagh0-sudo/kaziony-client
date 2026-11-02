import 'package:kernel/kernel.dart';

import '../../features/auth/data/session_auth_repository.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/location/data/api_service_area_repository.dart';
import '../../features/location/domain/browse_location.dart';

final List<Override> dependencies = [
  authRepositoryProvider.overrideWith(SessionAuthRepository.new),
  serviceAreaRepositoryProvider.overrideWith(
    (ref) => ApiServiceAreaRepository(ref.watch(apiProvider)),
  ),
];
