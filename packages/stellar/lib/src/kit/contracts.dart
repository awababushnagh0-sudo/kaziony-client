import 'package:flutter/widgets.dart';

import '../components/app_icon.dart';

// Every visual component has a contract here: a spec (what the app asks
// for) and a renderer interface (how a kit draws it). Apps use the public
// widgets (AppButton, AppText, ...), which ask the active StellarKit to
// render them. A different kit restyles every app without touching it.

// ─── Button ─────────────────────────────────────────────────────────────

enum ButtonVariant { primary, secondary, text, danger }

@immutable
class ButtonSpec {
  const ButtonSpec({
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.loading = false,
    this.expand = false,
    this.icon,
  });

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;
  final ButtonVariant variant;

  /// Shows a spinner and ignores taps, so a form can't be sent twice.
  final bool loading;

  /// Fill the available width.
  final bool expand;
  final AppIcon? icon;
}

abstract interface class ButtonRenderer {
  Widget render(BuildContext context, ButtonSpec spec);
}

// ─── Text input ─────────────────────────────────────────────────────────

enum TextInputKind { text, phone, password, number, email, multiline }

@immutable
class TextInputSpec {
  const TextInputSpec({
    required this.controlName,
    required this.label,
    required this.validationMessages,
    this.hint,
    this.kind = TextInputKind.text,
    this.isLast = false,
    this.onSubmitted,
    this.autofillHints,
    this.maxLength,
  });

  /// Name of the control in the enclosing AppForm.
  final String controlName;
  final String label;
  final String? hint;
  final TextInputKind kind;

  /// Error text per validation error key ("required", "minLength", ...).
  final Map<String, String Function(Object error)> validationMessages;

  /// The keyboard shows "done" instead of "next".
  final bool isLast;
  final VoidCallback? onSubmitted;
  final Iterable<String>? autofillHints;
  final int? maxLength;
}

abstract interface class TextInputRenderer {
  Widget render(BuildContext context, TextInputSpec spec);
}

// ─── Scaffold ───────────────────────────────────────────────────────────

@immutable
class ScaffoldSpec {
  const ScaffoldSpec({
    required this.body,
    this.title,
    this.actions = const [],
    this.padded = true,
    this.scrollable = false,
    this.bottom,
    this.showAppBar = true,
  });

  final Widget body;
  final String? title;
  final List<Widget> actions;

  /// Standard page padding around [body].
  final bool padded;

  /// Wrap [body] in a scroll view (forms, so the keyboard never hides fields).
  final bool scrollable;

  /// Pinned to the bottom (e.g. a primary action).
  final Widget? bottom;
  final bool showAppBar;
}

abstract interface class ScaffoldRenderer {
  Widget render(BuildContext context, ScaffoldSpec spec);
}

// ─── Text ───────────────────────────────────────────────────────────────

enum TextVariant { display, title, subtitle, body, caption, label }

enum TextTone { normal, muted, primary, danger, success, onPrimary }

@immutable
class TextSpec {
  const TextSpec(
    this.text, {
    this.variant = TextVariant.body,
    this.tone = TextTone.normal,
    this.align,
    this.maxLines,
    this.bold = false,
  });

  final String text;
  final TextVariant variant;
  final TextTone tone;
  final TextAlign? align;
  final int? maxLines;
  final bool bold;
}

abstract interface class TextRenderer {
  Widget render(BuildContext context, TextSpec spec);
}

// ─── Card and list tile ─────────────────────────────────────────────────

@immutable
class CardSpec {
  const CardSpec({required this.child, this.onTap, this.padded = true});

  final Widget child;
  final VoidCallback? onTap;
  final bool padded;
}

abstract interface class CardRenderer {
  Widget render(BuildContext context, CardSpec spec);
}

@immutable
class ListTileSpec {
  const ListTileSpec({
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final AppIcon? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
}

abstract interface class ListTileRenderer {
  Widget render(BuildContext context, ListTileSpec spec);
}

// ─── Status views (loading, error, empty) ───────────────────────────────

@immutable
class StatusSpec {
  const StatusSpec({
    required this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? message;
  final AppIcon? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
}

abstract interface class StatusRenderer {
  Widget loading(BuildContext context, {String? message});
  Widget error(BuildContext context, StatusSpec spec);
  Widget empty(BuildContext context, StatusSpec spec);
}

// ─── Snack (short message at the bottom) ────────────────────────────────

enum SnackTone { info, success, error }

abstract interface class SnackRenderer {
  void show(BuildContext context, String message, SnackTone tone);
}
