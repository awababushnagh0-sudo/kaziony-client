import 'package:kernel/kernel.dart';

import '../../features/auth/data/session_auth_repository.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/counter/data/api_claim_repository.dart';
import '../../features/counter/domain/claim.dart';
import '../../features/home/data/api_stats_repository.dart';
import '../../features/home/domain/store_stats.dart';
import '../../features/offers/data/api_offer_repository.dart';
import '../../features/offers/domain/offer.dart';
import '../../features/products/data/api_product_repository.dart';
import '../../features/products/domain/product.dart';
import '../../features/store/data/api_store_repository.dart';
import '../../features/store/domain/store.dart';

final List<Override> dependencies = [
  authRepositoryProvider.overrideWith(SessionAuthRepository.new),
  storeRepositoryProvider.overrideWith(
    (ref) => ApiStoreRepository(ref.watch(apiProvider)),
  ),
  claimRepositoryProvider.overrideWith(
    (ref) => ApiClaimRepository(ref.watch(apiProvider)),
  ),
  offerRepositoryProvider.overrideWith(
    (ref) => ApiOfferRepository(ref.watch(apiProvider)),
  ),
  productRepositoryProvider.overrideWith(
    (ref) => ApiProductRepository(ref.watch(apiProvider)),
  ),
  statsRepositoryProvider.overrideWith(
    (ref) => ApiStatsRepository(ref.watch(apiProvider)),
  ),
];
