import 'package:kernel/kernel.dart';

import '../features/auth/data/session_auth_repository.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/home/data/api_store_repository.dart';
import '../features/home/domain/store.dart';

/// Composition root: connects each feature's domain interfaces to their
/// data implementations. Screens and view models only know the interfaces;
/// tests replace these with fakes.
final List<Override> dependencies = [
  authRepositoryProvider.overrideWith(SessionAuthRepository.new),
  storeRepositoryProvider.overrideWith(
    (ref) => ApiStoreRepository(ref.watch(apiProvider)),
  ),
];
