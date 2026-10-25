import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../store/domain/current_store.dart';
import '../domain/offer.dart';
import 'offer_form_checks.dart';
import 'offer_view_model.dart';

class EditOfferState {
  const EditOfferState({this.saving = false, this.failure});

  final bool saving;
  final AppFailure? failure;
}

/// Changes an offer's title, description or end time. Its page has
/// already loaded the offer.
class EditOfferViewModel extends ViewModel<EditOfferState> {
  EditOfferViewModel(this.offerId);

  final String offerId;

  late final FormGroup form;

  @override
  EditOfferState build() {
    final offer = ref.read(offerViewModel(offerId)).requireValue;
    form = FormGroup({
      'title': FormControl<String>(
        value: offer.title,
        validators: [Validators.required, Validators.maxLength(100)],
      ),
      'description': FormControl<String>(
        value: offer.description,
        validators: [Validators.maxLength(1000)],
      ),
      'endsAt': FormControl<DateTime>(
        value: offer.endsAt.toLocal(),
        validators: [Validators.required, OfferChecks.endsAt],
      ),
    });
    ref.onDispose(form.dispose);
    return const EditOfferState();
  }

  /// Returns true when it was saved.
  Future<bool> save() async {
    if (state.saving) return false;
    if (form.invalid) {
      form.markAllAsTouched();
      return false;
    }
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (storeId == null) return false;
    state = const EditOfferState(saving: true);

    final description = (form.control('description').value as String?)?.trim();
    final result = await ref
        .read(offerRepositoryProvider)
        .update(
          storeId,
          offerId,
          OfferChanges(
            title: (form.control('title').value as String).trim(),
            description: description == null || description.isEmpty
                ? null
                : description,
            endsAt: form.control('endsAt').value as DateTime,
          ),
        );
    if (!ref.mounted) return false;
    switch (result) {
      case Ok(:final value):
        ref.read(offerViewModel(offerId).notifier).replace(value);
        state = const EditOfferState();
      case Err(:final failure):
        state = EditOfferState(failure: failure);
    }
    return result.isOk;
  }
}

final editOfferViewModel = NotifierProvider.autoDispose
    .family<EditOfferViewModel, EditOfferState, String>(EditOfferViewModel.new);
