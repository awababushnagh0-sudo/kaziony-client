import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../menu/s_menu_material.dart';
import 's_input_material.dart';
import 's_select_input.dart';

/// Taller lists scroll inside the menu.
const _maxMenuHeight = 280.0;

/// [SSelectInput] in ERPNext's style: a gray field like the text fields,
/// with the up-and-down chevrons, that opens the same menu as an "Actions"
/// button, as wide as the field, with a check by the chosen option. Arrow
/// keys, Enter and Escape work in the menu.
class SSelectInputMaterial<T> extends StatelessWidget
    implements SSelectInput<T> {
  const SSelectInputMaterial({
    required this.controlName,
    required this.label,
    required this.options,
    this.hint,
    this.required = false,
    super.key,
  });

  final String controlName;
  final String label;
  final List<SelectOption<T>> options;
  final String? hint;
  final bool required;

  @override
  Widget build(BuildContext context) => labelledInput(
    context,
    label: label,
    required: required,
    child: _SelectField<T>(input: this),
  );
}

class _SelectField<T> extends StatefulWidget {
  const _SelectField({required this.input});

  final SSelectInputMaterial<T> input;

  @override
  State<_SelectField<T>> createState() => _SelectFieldState<T>();
}

class _SelectFieldState<T> extends State<_SelectField<T>> {
  final _menu = MenuController();
  final _focus = FocusNode();
  var _open = false;

  @override
  void initState() {
    super.initState();
    // The field's border shows while it has the keyboard focus.
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final input = widget.input;
    final c = context.colors;
    final text = Theme.of(context).textTheme.bodyLarge;
    final strings = StellarLocalizations.of(context);
    return ReactiveFormField<T, T>(
      formControlName: input.controlName,
      validationMessages: {
        ValidationMessage.required: (_) => strings.validationRequired,
      },
      builder: (field) {
        final value = field.value;
        final chosen = input.options
            .where((option) => option.value == value)
            .firstOrNull;
        final enabled = field.control.enabled;
        return LayoutBuilder(
          builder: (context, constraints) => MenuAnchor(
            controller: _menu,
            style: menuStyle,
            alignmentOffset: const Offset(0, 4),
            onOpen: () => setState(() => _open = true),
            onClose: () {
              setState(() => _open = false);
              // Opened and closed without a choice: say it's required.
              field.control.markAsTouched();
            },
            menuChildren: [
              MenuPanel(
                opensUp: false,
                width: constraints.maxWidth,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: _maxMenuHeight,
                    ),
                    child: SingleChildScrollView(
                      // The page's own scroll view keeps the primary one.
                      primary: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final (i, option) in input.options.indexed)
                            MenuItemButton(
                              // The keys start from the chosen option, or
                              // the first one.
                              autofocus: chosen == null
                                  ? i == 0
                                  : option.value == value,
                              style: menuItemStyle(context),
                              trailingIcon: option.value == value
                                  ? Icon(
                                      materialIcon(SIcons.check),
                                      size: SIconSize.xs.pixels,
                                    )
                                  : null,
                              onPressed: () => field.didChange(option.value),
                              child: Text(
                                option.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
            child: InkWell(
              focusNode: _focus,
              onTap: enabled
                  ? () => _menu.isOpen ? _menu.close() : _menu.open()
                  : null,
              borderRadius: BorderRadius.circular(Radii.md),
              // The field's own border shows focus; no tint on top.
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              child: InputDecorator(
                isFocused: _open || _focus.hasFocus,
                isEmpty: chosen == null,
                decoration: InputDecoration(
                  hintText: input.hint,
                  errorText: field.errorText,
                  enabled: enabled,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        chosen?.label ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text,
                      ),
                    ),
                    const Gap(Space.sm),
                    Icon(
                      materialIcon(SIcons.chevronUpDown),
                      size: SIconSize.xs.pixels,
                      color: c.textSubtle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
