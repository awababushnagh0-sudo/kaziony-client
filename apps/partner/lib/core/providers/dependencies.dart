import 'package:kernel/kernel.dart';

import '../../features/auth/data/session_auth_repository.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/products/data/api_product_repository.dart';
import '../../features/products/domain/product.dart';
import '../../features/store/data/api_store_repository.dart';
import '../../features/store/domain/store.dart';

final List<Override> dependencies = [
  authRepositoryProvider.overrideWith(SessionAuthRepository.new),
  storeRepositoryProvider.overrideWith(
    (ref) => ApiStoreRepository(ref.watch(apiProvider)),
  ),
  productRepositoryProvider.overrideWith(
    (ref) => ApiProductRepository(ref.watch(apiProvider)),
  ),
];
