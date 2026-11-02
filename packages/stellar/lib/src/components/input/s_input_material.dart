import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kernel/kernel.dart' show formatDateTime;
import 'package:reactive_forms/reactive_forms.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../form/s_validators.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../pill/s_pill.dart';
import 's_choice_input.dart';
import 's_date_time_input.dart';
import 's_quantity_input.dart';
import 's_search_field.dart';
import 's_select_input.dart';
import 's_text_input.dart';

/// [STextInput], drawn with reactive_forms' [ReactiveTextField].
class STextInputMaterial extends StatelessWidget implements STextInput {
  const STextInputMaterial({
    required this.controlName,
    required this.label,
    this.hint,
    this.kind = TextInputKind.text,
    this.isLast = false,
    this.onSubmitted,
    this.autofillHints,
    this.maxLength,
    this.validationMessages = const {},
    this.required = false,
    this.helper,
    this.autofocus = false,
    super.key,
  });

  /// Name of the control in the enclosing SForm.
  final String controlName;
  final String label;
  final String? hint;
  final TextInputKind kind;

  /// The keyboard shows "done" instead of "next".
  final bool isLast;
  final VoidCallback? onSubmitted;
  final Iterable<String>? autofillHints;
  final int? maxLength;

  /// Error text per validation error key ("required", "minLength", ...),
  /// over the translated ones for the common errors.
  final Map<String, String Function(Object error)> validationMessages;

  /// Marks the label with a red asterisk (the validators still decide).
  final bool required;

  /// A quiet line under the field explaining what to enter.
  final String? helper;
  final bool autofocus;

  @override
  Widget build(BuildContext context) => kind == TextInputKind.password
      ? _PasswordInput(input: this)
      : _buildField(context, this);

  Map<String, String Function(Object error)> _messages(BuildContext context) {
    final strings = StellarLocalizations.of(context);
    return {
      ValidationMessage.required: (_) => strings.validationRequired,
      ValidationMessage.minLength: (error) =>
          strings.validationMinLength(_requiredLength(error)),
      ValidationMessage.maxLength: (error) =>
          strings.validationMaxLength(_requiredLength(error)),
      ValidationMessage.email: (_) => strings.validationEmail,
      ValidationMessage.mustMatch: (_) => strings.validationMustMatch,
      SValidators.libyanPhoneKey: (_) => strings.validationPhone,
      SValidators.urlKey: (_) => strings.validationUrl,
      SValidators.priceKey: (_) => strings.validationPrice,
      SValidators.wholeNumberKey: (error) => strings.validationWholeNumber(
        _bound(error, 'min'),
        _bound(error, 'max'),
      ),
      ...validationMessages,
    };
  }
}

int _requiredLength(Object error) =>
    error is Map ? (error['requiredLength'] as int? ?? 0) : 0;

int _bound(Object error, String key) =>
    error is Map ? (error[key] as int? ?? 0) : 0;

/// [SSearchField], drawn with Material's [TextField].
class SSearchFieldMaterial extends StatefulWidget implements SSearchField {
  const SSearchFieldMaterial({
    required this.hint,
    required ValueChanged<String> this.onChanged,
    this.initialValue = '',
    this.autofocus = false,
    super.key,
  }) : onTap = null;

  const SSearchFieldMaterial.button({
    required this.hint,
    required VoidCallback this.onTap,
    super.key,
  }) : onChanged = null,
       initialValue = '',
       autofocus = false;

  final String hint;
  final ValueChanged<String>? onChanged;

  /// Set instead of [onChanged] when the field only opens the search
  /// elsewhere.
  final VoidCallback? onTap;
  final String initialValue;

  /// Opens the keyboard at once: on a page that is only for searching.
  final bool autofocus;

  @override
  State<SSearchFieldMaterial> createState() => _SearchFieldState();
}

/// [SQuantityInput], drawn with Material's outlined [IconButton]s.
class SQuantityInputMaterial extends StatelessWidget implements SQuantityInput {
  const SQuantityInputMaterial({
    required this.value,
    required this.onChanged,
    this.min = 1,
    required this.max,
    super.key,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  /// Room for two figures, so the buttons don't move as the number grows.
  static const _quantityWidth = 48.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = StellarLocalizations.of(context);
    Widget step(SIcons icon, String tooltip, int? to) => IconButton.outlined(
      tooltip: tooltip,
      onPressed: to == null ? null : () => onChanged(to),
      style: IconButton.styleFrom(
        side: BorderSide(color: c.border),
        foregroundColor: c.text,
      ),
      icon: Icon(materialIcon(icon), size: SIconSize.md.pixels),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: Space.xl,
      children: [
        step(SIcons.minus, s.quantityFewer, value > min ? value - 1 : null),
        SizedBox(
          width: _quantityWidth,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.style.text.display,
              fontWeight: SFontWeight.bold.value,
              color: c.text,
            ),
          ),
        ),
        step(SIcons.add, s.quantityMore, value < max ? value + 1 : null),
      ],
    );
  }
}

/// [SChoiceInput], drawn as a row of [SPill]s.
class SChoiceInputMaterial<T> extends StatelessWidget
    implements SChoiceInput<T> {
  const SChoiceInputMaterial({
    required this.controlName,
    required this.label,
    required this.options,
    this.onChanged,
    super.key,
  });

  final String controlName;
  final String label;
  final List<SelectOption<T>> options;
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) => labelledInput(
    context,
    label: label,
    child: ReactiveFormField<T, T>(
      formControlName: controlName,
      builder: (field) => Wrap(
        spacing: Space.sm,
        runSpacing: Space.sm,
        children: [
          for (final option in options)
            SPill(
              label: option.label,
              selected: field.value == option.value,
              onTap: () {
                field.didChange(option.value);
                onChanged?.call(option.value);
              },
            ),
        ],
      ),
    ),
  );
}

/// [SDateTimeInput]: a field that opens Material's date picker, then its
/// time picker.
class SDateTimeInputMaterial extends StatelessWidget implements SDateTimeInput {
  const SDateTimeInputMaterial({
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
  Widget build(BuildContext context) => labelledInput(
    context,
    label: label,
    helper: helper,
    child: _DateTimeField(input: this),
  );
}

class _DateTimeField extends StatelessWidget {
  const _DateTimeField({required this.input});

  final SDateTimeInputMaterial input;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = context.colors;
    final strings = StellarLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return ReactiveFormField<DateTime, DateTime>(
      formControlName: input.controlName,
      validationMessages: {
        ValidationMessage.required: (_) => strings.validationRequired,
        ...input.validationMessages,
      },
      builder: (field) {
        final value = field.value;
        void choose(DateTime chosen) {
          field.didChange(chosen);
          field.control.markAsTouched();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: Space.sm,
          children: [
            if (input.presets.isNotEmpty)
              Wrap(
                spacing: Space.sm,
                runSpacing: Space.sm,
                children: [
                  for (final preset in input.presets)
                    SPill(
                      label: preset.label,
                      selected: value == preset.value,
                      onTap: () => choose(preset.value),
                    ),
                ],
              ),
            InkWell(
              borderRadius: BorderRadius.circular(context.style.radius),
              onTap: () async {
                final picked = await _pick(context, value);
                if (picked != null) choose(picked);
              },
              child: InputDecorator(
                isEmpty: value == null,
                decoration: InputDecoration(
                  hintText: strings.chooseDateTime,
                  errorText: field.errorText,
                  suffixIcon: Icon(
                    materialIcon(SIcons.calendar),
                    size: SIconSize.sm.pixels,
                    color: c.textMuted,
                  ),
                ),
                child: value == null
                    ? null
                    : Text(
                        formatDateTime(value, languageCode: language),
                        style: theme.textTheme.bodyLarge,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// The phone's calendar, then its clock.
  Future<DateTime?> _pick(BuildContext context, DateTime? current) async {
    final initial = current ?? input.firstDate;
    final day = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(input.firstDate)
          ? input.firstDate
          : initial,
      firstDate: input.firstDate,
      lastDate: input.lastDate,
    );
    if (day == null || !context.mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return null;
    return DateTime(day.year, day.month, day.day, time.hour, time.minute);
  }
}

/// A label above a form control, with a red asterisk when [required], as
/// in ERPNext; [helper] is a quiet line under it. Also used by the select
/// input.
Widget labelledInput(
  BuildContext context, {
  required String label,
  required Widget child,
  bool required = false,
  String? helper,
}) {
  final c = context.colors;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      ExcludeSemantics(
        child: Text.rich(
          TextSpan(
            text: label,
            children: [
              if (required)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: c.danger),
                ),
            ],
          ),
          // Labels lead, values follow: full text color, semibold.
          style: Theme.of(context).textTheme.labelLarge
              ?.copyWith(color: c.text, fontWeight: SFontWeight.semibold.value),
        ),
      ),
      const Gap(Space.sm),
      Semantics(label: label, child: child),
      if (helper != null) ...[
        const Gap(Space.xs),
        Text(
          helper,
          style: TextStyle(
            fontSize: context.style.text.tiny,
            color: c.textSubtle,
          ),
        ),
      ],
    ],
  );
}

Widget _buildField(
  BuildContext context,
  STextInputMaterial input, {
  bool obscure = false,
  Widget? suffix,
}) {
  // Phone numbers, emails, links and passwords read left to right, even in
  // Arabic; they still start at the page's start edge (the right, in
  // Arabic), like every other field.
  final ltr = switch (input.kind) {
    TextInputKind.phone ||
    TextInputKind.price ||
    TextInputKind.email ||
    TextInputKind.url ||
    TextInputKind.code ||
    TextInputKind.password => true,
    _ => false,
  };
  final rtlPage = Directionality.of(context) == TextDirection.rtl;
  // A spinner at the end while the field is checked (async validators).
  final field = ReactiveStatusListenableBuilder(
    formControlName: input.controlName,
    builder: (context, control, _) => ReactiveTextField<String>(
      formControlName: input.controlName,
      validationMessages: input._messages(context),
      obscureText: obscure,
      maxLength: input.maxLength,
      maxLines: input.kind == TextInputKind.multiline ? 4 : 1,
      autofillHints: input.autofillHints,
      autofocus: input.autofocus,
      inputFormatters: switch (input.kind) {
        TextInputKind.price => [_priceCharacters],
        TextInputKind.code => [_codeCharacters, _capitals],
        _ => null,
      },
      textCapitalization: input.kind == TextInputKind.code
          ? TextCapitalization.characters
          : TextCapitalization.none,
      autocorrect: input.kind != TextInputKind.code,
      enableSuggestions: input.kind != TextInputKind.code,
      textDirection: ltr ? TextDirection.ltr : null,
      textAlign: ltr
          ? (rtlPage ? TextAlign.right : TextAlign.left)
          : TextAlign.start,
      keyboardType: switch (input.kind) {
        TextInputKind.phone => TextInputType.phone,
        TextInputKind.number || TextInputKind.price =>
          const TextInputType.numberWithOptions(decimal: true),
        TextInputKind.email => TextInputType.emailAddress,
        TextInputKind.url => TextInputType.url,
        TextInputKind.multiline => TextInputType.multiline,
        // Letters and digits on one keyboard, without suggestions.
        TextInputKind.code => TextInputType.visiblePassword,
        _ => TextInputType.text,
      },
      textInputAction: input.kind == TextInputKind.multiline
          ? TextInputAction.newline
          : input.isLast
          ? TextInputAction.done
          : TextInputAction.next,
      onSubmitted: input.onSubmitted == null
          ? null
          : (_) => input.onSubmitted!.call(),
      // Pressing Enter to submit keeps the cursor in the field, so the user
      // can fix a wrong password right away.
      onEditingComplete: input.onSubmitted == null ? null : (_) {},
      decoration: InputDecoration(
        hintText: input.hint,
        hintTextDirection: ltr ? TextDirection.ltr : null,
        suffixText: input.kind == TextInputKind.price
            ? StellarLocalizations.of(context).currency
            : null,
        suffixIcon: control.pending ? const _Checking() : suffix,
        // As tall as the other fields despite the button.
        suffixIconConstraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 20,
        ),
      ),
    ),
  );
  return labelledInput(
    context,
    label: input.label,
    required: input.required,
    helper: input.helper,
    child: field,
  );
}

/// Digits (Arabic ones too) and a decimal sign: what a price can hold.
final _priceCharacters = FilteringTextInputFormatter.allow(
  RegExp('[0-9٠-٩.٫]'),
);

/// Latin letters and digits: what a code can hold.
final _codeCharacters = FilteringTextInputFormatter.allow(
  RegExp('[A-Za-z0-9]'),
);

/// Codes are in capitals, whatever the keyboard sends.
final _capitals = TextInputFormatter.withFunction(
  (_, value) => value.copyWith(text: value.text.toUpperCase()),
);

class _Checking extends StatelessWidget {
  const _Checking();

  @override
  Widget build(BuildContext context) => Center(
    widthFactor: 1,
    child: Padding(
      padding: const EdgeInsetsDirectional.only(end: Space.md),
      child: SizedBox.square(
        dimension: SIconSize.xs.pixels,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: context.colors.textSubtle,
        ),
      ),
    ),
  );
}

class _PasswordInput extends StatefulWidget {
  const _PasswordInput({required this.input});

  final STextInputMaterial input;

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  var _obscure = true;

  @override
  Widget build(BuildContext context) {
    final strings = StellarLocalizations.of(context);
    return _buildField(
      context,
      widget.input,
      obscure: _obscure,
      suffix: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 28, height: 28),
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        tooltip: _obscure ? strings.showPassword : strings.hidePassword,
        icon: Icon(
          materialIcon(_obscure ? SIcons.show : SIcons.hide),
          size: SIconSize.sm.pixels,
          color: context.colors.textSubtle,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    );
  }
}

class _SearchFieldState extends State<SSearchFieldMaterial> {
  late final _controller = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // A gray pill, unlike the form's fields: it searches the page, it
    // doesn't ask for anything.
    const shape = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(Radii.pill)),
      borderSide: BorderSide.none,
    );
    final onTap = widget.onTap;
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      autofocus: widget.autofocus,
      // As a button: no cursor, no keyboard, only the tap.
      readOnly: onTap != null,
      canRequestFocus: onTap == null,
      onTap: onTap,
      style: TextStyle(fontSize: context.style.text.body),
      decoration: InputDecoration(
        hintText: widget.hint,
        fillColor: c.fieldFill,
        border: shape,
        enabledBorder: shape,
        focusedBorder: shape,
        prefixIcon: Icon(
          materialIcon(SIcons.search),
          size: SIconSize.xs.pixels,
          color: c.textSubtle,
        ),
        // Clear of the round end.
        prefixIconConstraints: const BoxConstraints(minWidth: 44),
      ),
    );
  }
}
