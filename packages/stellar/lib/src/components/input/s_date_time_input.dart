import 'package:flutter/widgets.dart';
import 'package:reactive_forms/reactive_forms.dart' show ValidationMessage;

import '../../foundation/s_kit.dart';
import '../../l10n/generated/stellar_localizations.dart';
import 's_input_renderer.dart';

/// A day and time, bound to the control [controlName] (a `DateTime`) of
/// the enclosing SForm. [presets] are one-tap answers above the field.
class SDateTimeInput extends StatelessWidget {
  const SDateTimeInput({
    required this.controlName,
    required this.label,
    required this.firstDate,
    required this.lastDate,
    this.presets = const [],
    this.helper,
    this.validationMessages = const {},
    super.key,
  });

  final String controlName;
  final String label;

  /// The days the calendar offers.
  final DateTime firstDate;
  final DateTime lastDate;
  final List<DateTimePreset> presets;
  final String? helper;

  /// Messages for the screen's own checks (e.g. "at most 30 days").
  final Map<String, String Function(Object error)> validationMessages;

  @override
  Widget build(BuildContext context) {
    final strings = StellarLocalizations.of(context);
    return StellarKit.of(context).input.dateTime(
      context,
      DateTimeInputSpec(
        controlName: controlName,
        label: label,
        firstDate: firstDate,
        lastDate: lastDate,
        presets: presets,
        helper: helper,
        validationMessages: {
          ValidationMessage.required: (_) => strings.validationRequired,
          ...validationMessages,
        },
      ),
    );
  }
}
