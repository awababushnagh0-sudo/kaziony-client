import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart'
    show ReactiveTextField, ReactiveValueListenableBuilder;

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_code_card.dart';
import 's_code_input.dart';
import 's_qr_code.dart';

// Air between the letters, so look-alikes stay apart when read out.
const _letterSpacing = 3.0;

const _qrSize = 200.0;

/// [SQrCode], drawn with qr_flutter.
class SQrCodeMaterial extends StatelessWidget implements SQrCode {
  const SQrCodeMaterial(this.data, {required this.label, super.key});

  final String data;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // Dark on white in both themes: some scanners can't read light on
    // dark.
    return Semantics(
      label: label,
      image: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.codePaper,
          borderRadius: BorderRadius.circular(Radii.xl),
          border: Border.all(color: c.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: QrImageView(
            data: data,
            size: _qrSize,
            padding: EdgeInsets.zero,
            backgroundColor: c.codePaper,
            eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: c.codeInk),
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: c.codeInk,
            ),
          ),
        ),
      ),
    );
  }
}

/// [SCodeCard], on the brand color.
class SCodeCardMaterial extends StatelessWidget implements SCodeCard {
  const SCodeCardMaterial({required this.label, required this.code, super.key});

  final String label;
  final String code;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.primary,
          borderRadius: BorderRadius.circular(Radii.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Column(
            spacing: Space.xxs,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: text.small, color: c.onPrimaryMuted),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  code,
                  textDirection: TextDirection.ltr,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: text.code,
                    fontWeight: SFontWeight.bold.value,
                    letterSpacing: _letterSpacing,
                    height: 1.2,
                    color: c.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// [SCodeInput]: a hidden Material [TextField] under boxes it draws.
class SCodeInputMaterial extends StatefulWidget implements SCodeInput {
  const SCodeInputMaterial({
    required this.controlName,
    required this.label,
    required this.length,
    required this.characters,
    this.groupOf = 4,
    this.autofocus = false,
    this.onSubmitted,
    super.key,
  });

  final String controlName;
  final String label;
  final int length;
  final RegExp characters;
  final int groupOf;
  final bool autofocus;
  final VoidCallback? onSubmitted;

  @override
  State<SCodeInputMaterial> createState() => _SCodeInputMaterialState();
}

class _SCodeInputMaterialState extends State<SCodeInputMaterial> {
  // Watched, so the box being typed in shows only while typing.
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_refresh);
  }

  @override
  void dispose() {
    _focus
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) => ReactiveValueListenableBuilder<String>(
    formControlName: widget.controlName,
    builder: (context, control, _) => Stack(
      children: [
        // The field that takes the typing, unseen under the boxes:
        // tapping them lands on it.
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            alwaysIncludeSemantics: true,
            child: Semantics(
              label: widget.label,
              child: ReactiveTextField<String>(
                formControlName: widget.controlName,
                focusNode: _focus,
                autofocus: widget.autofocus,
                maxLength: widget.length,
                showErrors: (_) => false,
                showCursor: false,
                inputFormatters: [
                  _capitals,
                  FilteringTextInputFormatter.allow(widget.characters),
                ],
                textCapitalization: TextCapitalization.characters,
                autocorrect: false,
                enableSuggestions: false,
                // Letters and digits on one keyboard.
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.go,
                onSubmitted: (_) => widget.onSubmitted?.call(),
                decoration: const InputDecoration.collapsed(hintText: null)
                    .copyWith(counterText: ''),
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: _Boxes(
            length: widget.length,
            groupOf: widget.groupOf,
            value: control.value ?? '',
            typing: _focus.hasFocus,
          ),
        ),
      ],
    ),
  );
}

/// Codes are in capitals, whatever the keyboard sends.
final _capitals = TextInputFormatter.withFunction(
  (_, value) => value.copyWith(text: value.text.toUpperCase()),
);

/// One box per character, the next one to type marked.
class _Boxes extends StatelessWidget {
  const _Boxes({
    required this.length,
    required this.groupOf,
    required this.value,
    required this.typing,
  });

  final int length;

  /// A wider gap after every this many boxes, as the code is read out.
  final int groupOf;
  final String value;
  final bool typing;

  static const _gap = Space.xs + Space.xxs;
  static const _groupGap = Space.md;

  /// Boxes stop growing at this width on wide screens.
  static const _widest = 48.0;

  /// Height to width: taller than wide, like a letter.
  static const _tall = 1.36;

  @override
  Widget build(BuildContext context) {
    final groupGaps = (length - 1) ~/ groupOf;
    return LayoutBuilder(
      builder: (context, constraints) {
        final room =
            constraints.maxWidth -
            (length - 1) * _gap -
            groupGaps * (_groupGap - _gap);
        final width = math.min(_widest, room / length);
        return Directionality(
          // A code reads left to right in Arabic too.
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < length; i++) ...[
                if (i > 0) SizedBox(width: i % groupOf == 0 ? _groupGap : _gap),
                _Box(
                  width: width,
                  height: width * _tall,
                  character: i < value.length ? value[i] : null,
                  next: typing && i == value.length,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({
    required this.width,
    required this.height,
    required this.character,
    required this.next,
  });

  final double width;
  final double height;
  final String? character;

  /// The one being typed in: in the brand color, with a soft glow.
  final bool next;

  static const _ringWidth = 3.0;
  static const _borderWidth = 1.5;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(
          color: next ? c.primary : c.border,
          width: _borderWidth,
        ),
        boxShadow: [
          if (next) BoxShadow(color: c.primaryTint, spreadRadius: _ringWidth),
        ],
      ),
      child: Text(
        character ?? '',
        style: TextStyle(
          fontSize: context.style.text.title,
          fontWeight: SFontWeight.bold.value,
          color: c.text,
          height: 1,
        ),
      ),
    );
  }
}
