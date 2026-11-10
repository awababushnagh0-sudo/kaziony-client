import 'dart:async';

import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../domain/current_store.dart';
import '../domain/store.dart';
import 'store_view_model.dart';

class EditStoreInfoState {
  const EditStoreInfoState({
    this.changed = false,
    this.saving = false,
    this.failure,
  });

  /// A field differs from the saved store: there's something to save, and
  /// leaving asks first.
  final bool changed;
  final bool saving;
  final AppFailure? failure;
}

/// What customers see of the store, edited in place on the info page: the
/// fields fill from the saved store (and again when it reloads, unless
/// something is being edited), [EditStoreInfoState.changed] turns on once
/// one differs from it, and [save] sends them.
class EditStoreInfoViewModel extends ViewModel<EditStoreInfoState> {
  late final FormGroup form;

  /// What the saved values were, as the fields show them.
  Map<String, String?> _saved = const {};

  @override
  EditStoreInfoState build() {
    form = FormGroup({
      'pickupInstructions': FormControl<String>(
        validators: [Validators.maxLength(500)],
      ),
      'phone': FormControl<String>(validators: [SValidators.libyanPhone]),
      'email': FormControl<String>(
        validators: [SValidators.email, Validators.maxLength(255)],
      ),
      'facebookUrl': FormControl<String>(validators: [SValidators.url]),
      'instagramUrl': FormControl<String>(validators: [SValidators.url]),
    });
    final edits = form.valueChanges.listen((_) => _compare());
    ref.onDispose(() {
      unawaited(edits.cancel());
      form.dispose();
    });
    ref.listen(storeViewModel, (_, next) {
      if (next.value case final saved? when !state.changed) _fill(saved);
    });
    if (ref.read(storeViewModel).value case final saved?) _fill(saved);
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
    state = const EditStoreInfoState(changed: true, saving: true);

    final phone = _text('phone');
    final result = await ref
        .read(storeRepositoryProvider)
        .updateProfile(
          storeId,
          StoreProfile(
            pickupInstructions: _text('pickupInstructions'),
            phone: phone == null ? null : normalizeLibyanPhone(phone),
            email: _text('email'),
            facebookUrl: _text('facebookUrl'),
            instagramUrl: _text('instagramUrl'),
          ),
        );
    if (!ref.mounted) return false;

    switch (result) {
      case Ok(:final value):
        state = const EditStoreInfoState();
        _fill(value);
        ref.read(storeViewModel.notifier).replace(value);
      case Err(:final failure):
        state = EditStoreInfoState(changed: true, failure: failure);
    }
    return result.isOk;
  }

  void _fill(Store store) {
    final profile = store.profile;
    final phone = profile.phone;
    final values = {
      'pickupInstructions': profile.pickupInstructions,
      'phone': phone == null ? null : formatLibyanPhone(phone),
      'email': profile.email,
      'facebookUrl': profile.facebookUrl,
      'instagramUrl': profile.instagramUrl,
    };
    _saved = {
      for (final MapEntry(:key, :value) in values.entries) key: _normal(value),
    };
    for (final MapEntry(:key, :value) in values.entries) {
      form.control(key).reset(value: value);
    }
  }

  void _compare() {
    final changed = form.controls.keys.any(
      (name) => _text(name) != _saved[name],
    );
    if (changed != state.changed) {
      state = EditStoreInfoState(
        changed: changed,
        saving: state.saving,
        failure: state.failure,
      );
    }
  }

  /// The field's text without spaces around it, or null when it's empty.
  String? _text(String name) => _normal(form.control(name).value as String?);
}

/// Spaces around text don't count as a change, and empty text is no value.
String? _normal(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

final editStoreInfoViewModel =
    NotifierProvider.autoDispose<EditStoreInfoViewModel, EditStoreInfoState>(
      EditStoreInfoViewModel.new,
    );
