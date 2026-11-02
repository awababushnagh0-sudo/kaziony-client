import 'package:kernel/kernel.dart';

import '../../features/auth/data/session_auth_repository.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/bookings/data/api_bookings_repository.dart';
import '../../features/bookings/domain/booking.dart';
import '../../features/location/data/api_service_area_repository.dart';
import '../../features/location/domain/browse_location.dart';
import '../../features/offers/data/api_offers_repository.dart';
import '../../features/offers/domain/offer.dart';

final List<Override> dependencies = [
  authRepositoryProvider.overrideWith(SessionAuthRepository.new),
  serviceAreaRepositoryProvider.overrideWith(
    (ref) => ApiServiceAreaRepository(ref.watch(apiProvider)),
  ),
  offersRepositoryProvider.overrideWith(
    (ref) => ApiOffersRepository(ref.watch(apiProvider)),
  ),
  bookingsRepositoryProvider.overrideWith(
    (ref) => ApiBookingsRepository(ref.watch(apiProvider)),
  ),
];
