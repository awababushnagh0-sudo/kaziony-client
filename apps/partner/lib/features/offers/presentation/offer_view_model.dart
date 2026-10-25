import 'package:kernel/kernel.dart';

import '../../store/domain/current_store.dart';
import '../domain/offer.dart';
import 'offers_view_model.dart';

/// One offer, for its page, and the owner's actions on it.
class OfferViewModel extends AsyncViewModel<Offer> {
  OfferViewModel(this.offerId);

  final String offerId;

  @override
  Future<Offer> build() async {
    final storeId = ref.watch(currentStoreProvider)?.storeId;
    if (storeId == null) throw const NotFoundFailure();
    return switch (await ref
        .watch(offerRepositoryProvider)
        .get(storeId, offerId)) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }

  /// Each returns what went wrong, or null when it worked.
  Future<AppFailure?> pause() =>
      _change((offers, id) => offers.pause(id.$1, id.$2));

  Future<AppFailure?> resume() =>
      _change((offers, id) => offers.resume(id.$1, id.$2));

  Future<AppFailure?> end() =>
      _change((offers, id) => offers.end(id.$1, id.$2));

  /// Shows the offer the server returned after a change.
  void replace(Offer offer) {
    state = AsyncData(offer);
    // The list shows the state too.
    ref.invalidate(offersViewModel);
  }

  Future<AppFailure?> _change(
    Future<Result<Offer>> Function(
      OfferRepository offers,
      (String storeId, String offerId) id,
    )
    change,
  ) async {
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (storeId == null) return const NotFoundFailure();
    final result = await change(ref.read(offerRepositoryProvider), (
      storeId,
      offerId,
    ));
    if (!ref.mounted) return null;
    switch (result) {
      case Ok(:final value):
        replace(value);
        return null;
      case Err(:final failure):
        return failure;
    }
  }
}

final offerViewModel = AsyncNotifierProvider.autoDispose
    .family<OfferViewModel, Offer, String>(OfferViewModel.new);
