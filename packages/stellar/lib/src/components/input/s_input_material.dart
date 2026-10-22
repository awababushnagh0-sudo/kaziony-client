import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
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
              ?.copyWith(color: c.text, fontWeight: FontWeight.w600),
        ),
      ),
      const Gap(Space.sm),
      Semantics(label: label, child: child),
      if (helper != null) ...[
        const Gap(Space.xs),
        Text(helper, style: TextStyle(fontSize: 12, color: c.textSubtle)),
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
    TextInputKind.email ||
    TextInputKind.url ||
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
      textDirection: ltr ? TextDirection.ltr : null,
      textAlign: ltr
          ? (rtlPage ? TextAlign.right : TextAlign.left)
          : TextAlign.start,
      keyboardType: switch (spec.kind) {
        TextInputKind.phone => TextInputType.phone,
        TextInputKind.number => const TextInputType.numberWithOptions(
          decimal: true,
        ),
        TextInputKind.email => TextInputType.emailAddress,
        TextInputKind.url => TextInputType.url,
        TextInputKind.multiline => TextInputType.multiline,
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
      style: const TextStyle(fontSize: 14),
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
