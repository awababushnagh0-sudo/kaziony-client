import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/record/record_form.dart';
import '../domain/store.dart';
import 'store_details_view_model.dart';

/// A store's own fields, edited on its page.
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
    'description': FormControl<String>(
      validators: [Validators.maxLength(1000)],
    ),
    'phone': FormControl<String>(validators: [SValidators.libyanPhone]),
    'email': FormControl<String>(
      validators: [SValidators.email, Validators.maxLength(255)],
    ),
    'facebookUrl': FormControl<String>(validators: [SValidators.url]),
    'instagramUrl': FormControl<String>(validators: [SValidators.url]),
  };

  @override
  Map<String, Object?> valuesOf(StoreDetails store) {
    final phone = store.phone;
    return {
      'name': store.name,
      'categoryId': store.category.id,
      'description': store.description,
      'phone': phone == null ? null : formatLibyanPhone(phone),
      'email': store.email,
      'facebookUrl': store.facebookUrl,
      'instagramUrl': store.instagramUrl,
    };
  }

  @override
  Future<Result<StoreDetails>> submit() {
    final phone = text('phone');
    return ref
        .read(record.notifier)
        .save(
          EditedStore(
            name: text('name')!,
            categoryId: form.control('categoryId').value as String,
            description: text('description'),
            phone: phone == null ? null : normalizeLibyanPhone(phone),
            email: text('email'),
            facebookUrl: text('facebookUrl'),
            instagramUrl: text('instagramUrl'),
          ),
        );
  }
}

final storeFormViewModel = NotifierProvider.autoDispose
    .family<StoreFormViewModel, RecordFormState, String>(
      StoreFormViewModel.new,
    );
