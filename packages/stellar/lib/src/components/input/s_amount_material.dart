import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../badge/s_badge.dart';
import '../form/s_validators.dart';
import 's_amount_input.dart';
import 's_input_material.dart' show bareDecoration, fieldScrollPadding;
import 's_number_formatters.dart';

/// [SAmountInput], drawn as a bare [ReactiveTextField] as wide as what's in
/// it, centered with the currency after it; under them, what's wrong or
/// the price it replaces.
class SAmountInputMaterial extends StatefulWidget implements SAmountInput {
  const SAmountInputMaterial({
    required this.controlName,
    required this.label,
    this.was,
    this.badge,
    this.limit,
    this.limitMessage,
    this.validationMessages = const {},
    super.key,
  });

  final String controlName;
  final String label;
  final String? was;
  final String? badge;
  final String? limit;
  final String? limitMessage;
  final Map<String, String Function(Object error)> validationMessages;

  @override
  State<SAmountInputMaterial> createState() => _AmountState();
}

class _AmountState extends State<SAmountInputMaterial> {
  /// What an empty amount shows: the shape of a price.
  static const _empty = '0.000';

  /// Something that would reach the limit was just typed and turned away.
  var _refused = false;

  /// Reads the limit as it is when typing, as it can change (a regular
  /// price typed on the same form).
  late final _formatter = moneyUnder(
    () => widget.limit,
    onRefused: () {
      unawaited(HapticFeedback.lightImpact());
      if (!_refused) setState(() => _refused = true);
    },
  );

  @override
  Widget build(BuildContext context) {
    final controlName = widget.controlName;
    final label = widget.label;
    final c = context.colors;
    final text = context.style.text;
    final strings = StellarLocalizations.of(context);
    final amount = TextStyle(
      fontSize: text.hero,
      fontWeight: SFontWeight.bold.value,
      color: c.text,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    // One binding for what's around the field: the hint only while it's
    // empty (it would keep the field as wide as "0.000"), and the line
    // under it.
    return ReactiveFormField<String, String>(
      formControlName: controlName,
      validationMessages: {
        ValidationMessage.required: (_) => strings.validationRequired,
        SValidators.priceKey: (_) => strings.validationPrice,
        ...widget.validationMessages,
      },
      builder: (field) => Column(
        mainAxisSize: MainAxisSize.min,
        spacing: Space.xs,
        children: [
          ExcludeSemantics(
            child: Text(
              label,
              style: TextStyle(
                fontSize: text.small,
                fontWeight: SFontWeight.semibold.value,
                color: c.textMuted,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: Space.sm,
            children: [
              Flexible(
                child: IntrinsicWidth(
                  child: Semantics(
                    label: label,
                    child: ReactiveTextField<String>(
                      formControlName: controlName,
                      // Shown under the amount, not inside its width.
                      showErrors: (_) => false,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [_formatter],
                      // The next thing taken clears why the last wasn't.
                      onChanged: (_) {
                        if (_refused) setState(() => _refused = false);
                      },
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      scrollPadding: fieldScrollPadding,
                      style: amount,
                      cursorColor: c.primary,
                      decoration: bareDecoration(
                        hint: (field.value ?? '').isEmpty ? _empty : null,
                        hintStyle: amount.copyWith(color: c.border),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                strings.currency,
                style: TextStyle(
                  fontSize: text.title,
                  fontWeight: SFontWeight.semibold.value,
                  color: c.textSubtle,
                ),
              ),
            ],
          ),
          _Under(
            error: _refused ? widget.limitMessage : field.errorText,
            was: widget.was,
            badge: widget.badge,
          ),
        ],
      ),
    );
  }
}

/// What's wrong with the amount, or else the price it replaces and how
/// much less it is.
class _Under extends StatelessWidget {
  const _Under({required this.error, required this.was, required this.badge});

  final String? error;
  final String? was;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final small = context.style.text.small;
    final error = this.error;
    final was = this.was;
    final badge = this.badge;
    if (error != null) {
      return Semantics(
        liveRegion: true,
        child: Text(
          error,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: small, color: c.danger),
        ),
      );
    }
    if (was == null && badge == null) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: Space.sm,
      children: [
        if (was != null)
          Text(
            was,
            style: TextStyle(
              fontSize: small,
              color: c.textSubtle,
              decoration: TextDecoration.lineThrough,
              decorationColor: c.textSubtle,
            ),
          ),
        if (badge != null) SBadge(badge, tone: BadgeTone.discount),
      ],
    );
  }
}
