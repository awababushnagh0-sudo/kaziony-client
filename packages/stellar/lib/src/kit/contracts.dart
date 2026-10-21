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

@immutable
class IconButtonSpec {
  const IconButtonSpec({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final AppIcon icon;

  /// Also what screen readers say.
  final String tooltip;
  final VoidCallback? onPressed;
}

abstract interface class ButtonRenderer {
  Widget render(BuildContext context, ButtonSpec spec);
  Widget icon(BuildContext context, IconButtonSpec spec);
}

// ─── Text input ─────────────────────────────────────────────────────────

enum TextInputKind { text, phone, password, number, email, url, multiline }

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
    this.required = false,
    this.helper,
    this.autofocus = false,
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

  /// Marks the label with a red asterisk (the validators still decide).
  final bool required;

  /// A quiet line under the field explaining what to enter.
  final String? helper;
  final bool autofocus;
}

@immutable
class SelectOption<T> {
  const SelectOption(this.value, this.label);

  final T value;
  final String label;
}

/// A dropdown bound to a form control, labelled like a text input.
@immutable
class SelectInputSpec<T> {
  const SelectInputSpec({
    required this.controlName,
    required this.label,
    required this.options,
    required this.validationMessages,
    this.hint,
    this.required = false,
  });

  final String controlName;
  final String label;
  final List<SelectOption<T>> options;
  final Map<String, String Function(Object error)> validationMessages;
  final String? hint;
  final bool required;
}

abstract interface class TextInputRenderer {
  Widget render(BuildContext context, TextInputSpec spec);
  Widget select<T>(BuildContext context, SelectInputSpec<T> spec);
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
    this.maxWidth,
    this.centered = false,
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

  /// Keeps the content narrow on wide screens (forms on the web).
  final double? maxWidth;

  /// Centers the content vertically too (login pages).
  final bool centered;
}

abstract interface class ScaffoldRenderer {
  Widget render(BuildContext context, ScaffoldSpec spec);
}

// ─── Shell (side menu layout for the dashboard) ─────────────────────────

@immutable
class NavItemSpec {
  const NavItemSpec({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final AppIcon icon;
  final bool selected;
  final VoidCallback onTap;
}

@immutable
class ShellMenuAction {
  const ShellMenuAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.destructive = false,
  });

  final String label;
  final AppIcon icon;
  final VoidCallback onTap;

  /// Red, like logging out.
  final bool destructive;
}

@immutable
class ShellSpec {
  const ShellSpec({
    required this.title,
    required this.items,
    required this.body,
    this.subtitle,
    this.userName,
    this.userDetail,
    this.userActions = const [],
  });

  /// App name at the top of the side menu.
  final String title;

  /// A quiet line under [title].
  final String? subtitle;
  final List<NavItemSpec> items;

  /// The current page, usually an AppScaffold.
  final Widget body;

  /// Shown at the bottom of the side menu; tapping opens [userActions].
  final String? userName;
  final String? userDetail;
  final List<ShellMenuAction> userActions;
}

/// Wide screens get a fixed side menu; narrow ones get a drawer that pages
/// open from their app bar.
abstract interface class ShellRenderer {
  Widget render(BuildContext context, ShellSpec spec);
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

  /// A standalone icon in a text color.
  Widget icon(BuildContext context, AppIcon icon, TextTone tone, double size);
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

// ─── Data: tables, list pages, badges ───────────────────────────────────

/// One column of an [TableSpec] showing rows of [T].
@immutable
class TableColumn<T> {
  const TableColumn({
    required this.label,
    required this.cell,
    this.flex = 2,
    this.minWidth = 0,
  });

  final String label;
  final Widget Function(T row) cell;
  final int flex;

  /// The column is hidden when the table is narrower than this.
  final double minWidth;
}

@immutable
class TableSpec<T> {
  const TableSpec({
    required this.rows,
    required this.columns,
    required this.totalLabel,
    this.onOpen,
  });

  final List<T> rows;
  final List<TableColumn<T>> columns;

  /// Shown at the end of the header ("12 stores"), as in ERPNext.
  final String totalLabel;

  /// Rows are clickable when set.
  final ValueChanged<T>? onOpen;
}

/// A list page's body: [filters] above the table, a thin bar while
/// [loading], then [content] (the table's slivers, or an empty or error
/// view) and the [pager] at the bottom.
@immutable
class ListPageSpec {
  const ListPageSpec({
    required this.content,
    required this.contentIsSliver,
    this.filters,
    this.pager,
    this.loading = false,
  });

  final Widget content;

  /// The table is made of slivers; empty and error views are boxes.
  final bool contentIsSliver;
  final Widget? filters;
  final Widget? pager;
  final bool loading;
}

@immutable
class PagerSpec {
  const PagerSpec({
    required this.pageLabel,
    required this.pageSize,
    required this.pageSizes,
    required this.onPageSize,
    required this.onPrevious,
    required this.onNext,
    required this.previousLabel,
    required this.nextLabel,
  });

  /// "Page 1 of 3".
  final String pageLabel;
  final int pageSize;
  final List<int> pageSizes;
  final ValueChanged<int> onPageSize;

  /// Null on the first (or last) page.
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final String previousLabel;
  final String nextLabel;
}

enum BadgeTone { success, warning, danger, neutral }

/// A filter toggle or a small choice, dark when [selected].
@immutable
class PillSpec {
  const PillSpec({
    required this.label,
    required this.selected,
    this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final AppIcon? icon;
}

@immutable
class SearchFieldSpec {
  const SearchFieldSpec({
    required this.hint,
    required this.onChanged,
    this.initialValue = '',
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final String initialValue;
}

abstract interface class DataRenderer {
  /// Slivers, for a list page.
  Widget table<T>(BuildContext context, TableSpec<T> spec);
  Widget listPage(BuildContext context, ListPageSpec spec);
  Widget pager(BuildContext context, PagerSpec spec);
  Widget badge(BuildContext context, String label, BadgeTone tone);
  Widget pill(BuildContext context, PillSpec spec);
  Widget searchField(BuildContext context, SearchFieldSpec spec);

  /// One table cell's text: muted, one line. [strong] for the column that
  /// names the row, [ltr] for numbers, phones and emails.
  Widget cellText(BuildContext context, String text, {bool strong, bool ltr});
}

// ─── Overlays: dialogs, confirmations, menus ────────────────────────────

/// A dialog with a title bar and close button, a scrolling [body] and a
/// footer with Cancel and the main action, as in ERPNext.
@immutable
class DialogSpec {
  const DialogSpec({
    required this.title,
    required this.body,
    required this.closeLabel,
    this.primaryLabel,
    this.onPrimary,
    this.busy = false,
    this.cancelLabel,
    this.width = 520,
  });

  final String title;
  final Widget body;
  final String closeLabel;

  /// The main button; no footer without it.
  final String? primaryLabel;
  final VoidCallback? onPrimary;

  /// Disables the buttons and closing while the action runs.
  final bool busy;
  final String? cancelLabel;
  final double width;
}

@immutable
class ConfirmSpec {
  const ConfirmSpec({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.destructive = false,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  /// A red confirm button, for actions that remove or disable something.
  final bool destructive;
}

@immutable
class MenuEntry {
  const MenuEntry({
    required this.label,
    required this.icon,
    required this.onTap,
    this.destructive = false,
    this.description,
  });

  final String label;
  final AppIcon icon;
  final VoidCallback onTap;

  /// Red, for removing or disabling.
  final bool destructive;

  /// A smaller line under the label, for actions that need explaining.
  final String? description;
}

abstract interface class OverlayRenderer {
  /// Opens [builder] (usually an AppDialog) over the page.
  Future<T?> show<T>(
    BuildContext context,
    WidgetBuilder builder, {
    bool dismissible = true,
  });
  Widget dialog(BuildContext context, DialogSpec spec);
  Future<bool> confirm(BuildContext context, ConfirmSpec spec);

  /// A button ([builder] draws it and gets the function that opens the
  /// menu) with a menu of [entries]; null entries draw a divider.
  Widget menu(
    BuildContext context, {
    required List<MenuEntry?> entries,
    required Widget Function(BuildContext context, VoidCallback toggle) builder,
    bool alignEnd = true,
    double width = 184,
  });
}
