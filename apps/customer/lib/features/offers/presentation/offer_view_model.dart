import 'package:kernel/kernel.dart';

import '../../location/domain/browse_location.dart';
import '../domain/offer.dart';

/// One offer, for its page. Signing in or out loads it again: the
/// customer's reservation of it comes with it.
class OfferViewModel extends AsyncViewModel<OfferDetail> {
  OfferViewModel(this.offerId);

  final String offerId;

  @override
  Future<OfferDetail> build() async {
    ref.watch(sessionProvider);
    final around = ref.watch(browseLocationProvider)?.point;
    return switch (await ref
        .watch(offersRepositoryProvider)
        .get(offerId, around: around)) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }
}

final offerViewModel = AsyncNotifierProvider.autoDispose
    .family<OfferViewModel, OfferDetail, String>(OfferViewModel.new);
