import 'dart:async';

import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

class RecordFormState {
  const RecordFormState({this.changed = false, this.saving = false});

  /// A field differs from the saved record.
  final bool changed;
  final bool saving;
}

/// The fields of a saved record (a store, a user, ...), edited in place as
/// in ERPNext: [RecordFormState.changed] turns on once a field differs from
/// the saved record, and [save] sends them. [RecordScreen] shows it.
///
/// A record's form only says which fields it has, how a saved record fills
/// them, and how to save them:
///
/// ```dart
/// class StoreFormViewModel extends RecordForm<StoreDetails> {
///   StoreFormViewModel(this.storeId);
///   ...
/// }
/// final storeFormViewModel = NotifierProvider.autoDispose
///     .family<StoreFormViewModel, RecordFormState, String>(
///       StoreFormViewModel.new,
///     );
/// ```
abstract class RecordForm<T> extends ViewModel<RecordFormState> {
  late final FormGroup form;

  /// What the saved values were, as [valuesOf] gave them.
  Map<String, Object?> _saved = const {};

  /// The saved record. The form fills from it, and again whenever it
  /// changes (reloaded, or changed by an action) while nothing is edited.
  ProviderListenable<AsyncValue<T>> get record;

  /// The fields, by name, with their validators.
  Map<String, AbstractControl<Object?>> fields();

  /// Each field's value for a saved [record], as the field shows it.
  Map<String, Object?> valuesOf(T record);

  /// Saves the fields; only called when they're valid. Read them with
  /// [text] and [form].
  Future<Result<T>> submit();

  @override
  RecordFormState build() {
    form = FormGroup(fields());
    final edits = form.valueChanges.listen((_) => _compare());
    ref.onDispose(() {
      unawaited(edits.cancel());
      form.dispose();
    });
    ref.listen(record, (_, next) {
      if (next.value case final saved? when !state.changed) _fill(saved);
    });
    if (ref.read(record).value case final saved?) _fill(saved);
    return const RecordFormState();
  }

  /// A text field's value without spaces around it, or null when empty.
  String? text(String name) => _normal(form.control(name).value) as String?;

  void _fill(T record) {
    final values = valuesOf(record);
    _saved = {
      for (final MapEntry(:key, :value) in values.entries) key: _normal(value),
    };
    form.reset(value: values);
  }

  void _compare() {
    final changed = form.controls.keys.any(
      (name) => _normal(form.control(name).value) != _saved[name],
    );
    if (changed != state.changed) {
      state = RecordFormState(changed: changed, saving: state.saving);
    }
  }

  /// The saved record, or null when a field is invalid (now marked) or it's
  /// already being saved. A failure to save comes back as [Err], and the
  /// changes stay.
  Future<Result<T>?> save() async {
    if (state.saving) return null;
    if (form.invalid) {
      form.markAllAsTouched();
      return null;
    }
    state = const RecordFormState(changed: true, saving: true);
    final result = await submit();
    if (!ref.mounted) return result;
    switch (result) {
      case Ok(:final value):
        state = const RecordFormState();
        _fill(value);
      case Err():
        state = const RecordFormState(changed: true);
    }
    return result;
  }
}

/// Spaces around text don't count as a change, and empty text is no value.
Object? _normal(Object? value) {
  if (value is! String) return value;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
