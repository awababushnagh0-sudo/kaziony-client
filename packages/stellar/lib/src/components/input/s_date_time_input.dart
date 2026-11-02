import 'package:flutter/widgets.dart';

import 's_input_material.dart';

/// A ready-made answer for a date and time field ("Tonight").
@immutable
class DateTimePreset {
  const DateTimePreset(this.label, this.value);

  final String label;
  final DateTime value;
}

/// A day and time, bound to the control [controlName] (a `DateTime`) of
/// the enclosing SForm. [presets] are one-tap answers above the field.
abstract interface class SDateTimeInput implements Widget {
  /// [firstDate] to [lastDate] are the days the calendar offers.
  /// [validationMessages] are for the screen's own checks (e.g. "at most
  /// 30 days").
  const factory SDateTimeInput({
    required String controlName,
    required String label,
    required DateTime firstDate,
    required DateTime lastDate,
    List<DateTimePreset> presets,
    String? helper,
    Map<String, String Function(Object error)> validationMessages,
    Key? key,
  }) = SDateTimeInputMaterial;
}
