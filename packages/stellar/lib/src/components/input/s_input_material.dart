import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kernel/kernel.dart' show formatDateTime;
import 'package:reactive_forms/reactive_forms.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../pill/s_pill.dart';
import 's_input_renderer.dart';
import 's_select_material.dart';

class MaterialInputRenderer implements InputRenderer {
  const MaterialInputRenderer();

  @override
  Widget text(BuildContext context, TextInputSpec spec) =>
      spec.kind == TextInputKind.password
      ? _PasswordInput(spec: spec)
      : _buildField(context, spec);

  @override
  Widget select<T>(BuildContext context, SelectInputSpec<T> spec) => _labelled(
    context,
    label: spec.label,
    required: spec.required,
    child: SelectField<T>(spec: spec),
  );

  @override
  Widget search(BuildContext context, SearchFieldSpec spec) =>
      _SearchField(spec: spec);

  @override
  Widget choice<T>(BuildContext context, ChoiceInputSpec<T> spec) => _labelled(
    context,
    label: spec.label,
    child: ReactiveFormField<T, T>(
      formControlName: spec.controlName,
      builder: (field) => Wrap(
        spacing: Space.sm,
        runSpacing: Space.sm,
        children: [
          for (final option in spec.options)
            SPill(
              label: option.label,
              selected: field.value == option.value,
              onTap: () {
                field.didChange(option.value);
                spec.onChanged?.call(option.value);
              },
            ),
        ],
      ),
    ),
  );

  @override
  Widget dateTime(BuildContext context, DateTimeInputSpec spec) => _labelled(
    context,
    label: spec.label,
    helper: spec.helper,
    child: _DateTimeField(spec: spec),
  );
}

class _DateTimeField extends StatelessWidget {
  const _DateTimeField({required this.spec});

  final DateTimeInputSpec spec;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = context.colors;
    final language = Localizations.localeOf(context).languageCode;
    return ReactiveFormField<DateTime, DateTime>(
      formControlName: spec.controlName,
      validationMessages: spec.validationMessages,
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
            if (spec.presets.isNotEmpty)
              Wrap(
                spacing: Space.sm,
                runSpacing: Space.sm,
                children: [
                  for (final preset in spec.presets)
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
                  hintText: StellarLocalizations.of(context).chooseDateTime,
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
    final initial = current ?? spec.firstDate;
    final day = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(spec.firstDate) ? spec.firstDate : initial,
      firstDate: spec.firstDate,
      lastDate: spec.lastDate,
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
/// in ERPNext; [helper] is a quiet line under it.
Widget _labelled(
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
  TextInputSpec spec, {
  bool obscure = false,
  Widget? suffix,
}) {
  // Phone numbers, emails, links and passwords read left to right, even in
  // Arabic; they still start at the page's start edge (the right, in
  // Arabic), like every other field.
  final ltr = switch (spec.kind) {
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
    formControlName: spec.controlName,
    builder: (context, control, _) => ReactiveTextField<String>(
      formControlName: spec.controlName,
      validationMessages: spec.validationMessages,
      obscureText: obscure,
      maxLength: spec.maxLength,
      maxLines: spec.kind == TextInputKind.multiline ? 4 : 1,
      autofillHints: spec.autofillHints,
      autofocus: spec.autofocus,
      inputFormatters: switch (spec.kind) {
        TextInputKind.price => [_priceCharacters],
        TextInputKind.code => [_codeCharacters, _capitals],
        _ => null,
      },
      textCapitalization: spec.kind == TextInputKind.code
          ? TextCapitalization.characters
          : TextCapitalization.none,
      autocorrect: spec.kind != TextInputKind.code,
      enableSuggestions: spec.kind != TextInputKind.code,
      textDirection: ltr ? TextDirection.ltr : null,
      textAlign: ltr
          ? (rtlPage ? TextAlign.right : TextAlign.left)
          : TextAlign.start,
      keyboardType: switch (spec.kind) {
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
      textInputAction: spec.kind == TextInputKind.multiline
          ? TextInputAction.newline
          : spec.isLast
          ? TextInputAction.done
          : TextInputAction.next,
      onSubmitted: spec.onSubmitted == null
          ? null
          : (_) => spec.onSubmitted!.call(),
      // Pressing Enter to submit keeps the cursor in the field, so the user
      // can fix a wrong password right away.
      onEditingComplete: spec.onSubmitted == null ? null : (_) {},
      decoration: InputDecoration(
        hintText: spec.hint,
        hintTextDirection: ltr ? TextDirection.ltr : null,
        suffixText: spec.kind == TextInputKind.price
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
  return _labelled(
    context,
    label: spec.label,
    required: spec.required,
    helper: spec.helper,
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
  const _PasswordInput({required this.spec});

  final TextInputSpec spec;

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
      widget.spec,
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

class _SearchField extends StatefulWidget {
  const _SearchField({required this.spec});

  final SearchFieldSpec spec;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final _controller = TextEditingController(
    text: widget.spec.initialValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TextField(
      controller: _controller,
      onChanged: widget.spec.onChanged,
      style: TextStyle(fontSize: context.style.text.body),
      decoration: InputDecoration(
        hintText: widget.spec.hint,
        prefixIcon: Icon(
          materialIcon(SIcons.search),
          size: SIconSize.xs.pixels,
          color: c.textSubtle,
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 36),
      ),
    );
  }
}
