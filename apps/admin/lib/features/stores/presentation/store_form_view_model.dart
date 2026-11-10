import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/record/record_form.dart';
import '../domain/location.dart';
import '../domain/store.dart';
import 'hours_text.dart';
import 'location_lookup.dart';
import 'place_form.dart';
import 'store_details_view_model.dart';

/// A store's own fields and its place, edited on its page.
class StoreFormViewModel extends RecordForm<StoreDetails> {
  StoreFormViewModel(this.storeId);

  final String storeId;

  @override
  AsyncNotifierProvider<StoreDetailsViewModel, StoreDetails> get record =>
      storeDetailsViewModel(storeId);

  @override
  Map<String, AbstractControl<Object?>> fields() => {
    'name': FormControl<String>(
      validators: [Validators.required, Validators.maxLength(100)],
    ),
    'categoryId': FormControl<String>(validators: [Validators.required]),
    'pickupInstructions': FormControl<String>(
      validators: [Validators.maxLength(500)],
    ),
    'phone': FormControl<String>(validators: [SValidators.libyanPhone]),
    'email': FormControl<String>(
      validators: [SValidators.email, Validators.maxLength(255)],
    ),
    'facebookUrl': FormControl<String>(validators: [SValidators.url]),
    'instagramUrl': FormControl<String>(validators: [SValidators.url]),
    ...placeControls(ref),
  };

  @override
  Map<String, Object?> valuesOf(StoreDetails store) {
    final phone = store.phone;
    final LatLng point = (latitude: store.latitude, longitude: store.longitude);
    return {
      'name': store.name,
      'categoryId': store.category.id,
      'pickupInstructions': store.pickupInstructions,
      'phone': phone == null ? null : formatLibyanPhone(phone),
      'email': store.email,
      'facebookUrl': store.facebookUrl,
      'instagramUrl': store.instagramUrl,
      'city': store.city,
      'area': store.area,
      'address': store.address,
      'point': point,
      'location': coordinatesText(point),
      for (final day in Weekday.values)
        hoursField(day): hoursText(store.openingHours.days[day]),
    };
  }

  /// Waits for a new location to be read first.
  @override
  Future<Result<StoreDetails>?> save() async {
    await settleLocation(form.control('location'));
    if (!ref.mounted) return null;
    return super.save();
  }

  @override
  Future<Result<StoreDetails>> submit() async {
    final phone = text('phone');
    final result = await ref
        .read(record.notifier)
        .save(
          EditedStore(
            name: text('name')!,
            categoryId: form.control('categoryId').value as String,
            pickupInstructions: text('pickupInstructions'),
            phone: phone == null ? null : normalizeLibyanPhone(phone),
            email: text('email'),
            facebookUrl: text('facebookUrl'),
            instagramUrl: text('instagramUrl'),
            place: differs(placeFields) ? readPlace(form) : null,
          ),
        );
    if (result
        case Err(failure: ValidationFailure(code: LocationCodes.outsideLibya))
        when ref.mounted) {
      showOutsideLibya(form.control('location'));
    }
    return result;
  }
}

final storeFormViewModel = NotifierProvider.autoDispose
    .family<StoreFormViewModel, RecordFormState, String>(
      StoreFormViewModel.new,
    );
