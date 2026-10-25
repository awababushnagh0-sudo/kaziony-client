import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../domain/current_store.dart';
import '../domain/store.dart';
import 'store_view_model.dart';

class EditStoreInfoState {
  const EditStoreInfoState({this.saving = false, this.failure});

  final bool saving;
  final AppFailure? failure;
}

/// Edits what customers see of the store. Opened from the info page,
/// which has already loaded the store.
class EditStoreInfoViewModel extends ViewModel<EditStoreInfoState> {
  late final FormGroup form;

  @override
  EditStoreInfoState build() {
    final profile = ref.read(storeViewModel).requireValue.profile;
    final phone = profile.phone;
    form = FormGroup({
      'description': FormControl<String>(
        value: profile.description,
        validators: [Validators.maxLength(1000)],
      ),
      'phone': FormControl<String>(
        value: phone == null ? null : formatLibyanPhone(phone),
        validators: [SValidators.libyanPhone],
      ),
      'email': FormControl<String>(
        value: profile.email,
        validators: [SValidators.email, Validators.maxLength(255)],
      ),
      'facebookUrl': FormControl<String>(
        value: profile.facebookUrl,
        validators: [SValidators.url],
      ),
      'instagramUrl': FormControl<String>(
        value: profile.instagramUrl,
        validators: [SValidators.url],
      ),
    });
    ref.onDispose(form.dispose);
    return const EditStoreInfoState();
  }

  /// Returns true when the store was saved.
  Future<bool> save() async {
    if (state.saving) return false;
    if (form.invalid) {
      form.markAllAsTouched();
      return false;
    }
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (storeId == null) return false;
    state = const EditStoreInfoState(saving: true);

    final phone = _text('phone');
    final result = await ref
        .read(storeRepositoryProvider)
        .updateProfile(
          storeId,
          StoreProfile(
            description: _text('description'),
            phone: phone == null ? null : normalizeLibyanPhone(phone),
            email: _text('email'),
            facebookUrl: _text('facebookUrl'),
            instagramUrl: _text('instagramUrl'),
          ),
        );
    if (!ref.mounted) return false;

    switch (result) {
      case Ok(:final value):
        ref.read(storeViewModel.notifier).replace(value);
        state = const EditStoreInfoState();
      case Err(:final failure):
        state = EditStoreInfoState(failure: failure);
    }
    return result.isOk;
  }

  /// The field's text, or null when it's empty.
  String? _text(String name) {
    final value = (form.control(name).value as String?)?.trim();
    return value == null || value.isEmpty ? null : value;
  }
}

final editStoreInfoViewModel =
    NotifierProvider.autoDispose<EditStoreInfoViewModel, EditStoreInfoState>(
      EditStoreInfoViewModel.new,
    );
