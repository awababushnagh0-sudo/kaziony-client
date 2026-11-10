import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../domain/location.dart';
import '../domain/store.dart';
import 'location_lookup.dart';
import 'place_form.dart';
import 'stores_view_model.dart';

class AddLocationState {
  const AddLocationState({this.submitting = false, this.failure});

  final bool submitting;
  final AppFailure? failure;
}

/// Another place of [storeId]'s brand: a store of its own, with the
/// brand's name, photos and owners.
class AddLocationViewModel extends ViewModel<AddLocationState> {
  AddLocationViewModel(this.storeId);

  final String storeId;
  late final FormGroup form;

  @override
  AddLocationState build() {
    form = FormGroup({
      ...placeControls(ref),
      'phone': FormControl<String>(validators: [SValidators.libyanPhone]),
    });
    ref.onDispose(form.dispose);
    return const AddLocationState();
  }

  /// The new store, or null when the form is invalid or saving failed (the
  /// state or the form then says why).
  Future<StoreDetails?> submit() async {
    if (state.submitting) return null;
    state = const AddLocationState(submitting: true);
    final location = form.control('location');
    await settleLocation(location);
    if (!ref.mounted) return null;
    final place = readPlace(form);
    if (form.invalid || place == null) {
      form.markAllAsTouched();
      state = const AddLocationState();
      return null;
    }

    final phone = (form.control('phone').value as String?)?.trim() ?? '';
    final result = await ref
        .read(storeRepositoryProvider)
        .addLocation(
          storeId,
          NewLocation(
            place: place,
            phone: phone.isEmpty ? null : normalizeLibyanPhone(phone),
          ),
        );
    if (!ref.mounted) return null;

    switch (result) {
      case Ok(:final value):
        ref.invalidate(storePageProvider);
        state = const AddLocationState();
        return value;
      case Err(failure: ValidationFailure(code: LocationCodes.outsideLibya)):
        showOutsideLibya(location);
        state = const AddLocationState();
      case Err(:final failure):
        state = AddLocationState(failure: failure);
    }
    return null;
  }
}

final addLocationViewModel = NotifierProvider.autoDispose
    .family<AddLocationViewModel, AddLocationState, String>(
      AddLocationViewModel.new,
    );
