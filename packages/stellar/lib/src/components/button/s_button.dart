import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../icon/s_icon.dart';
import 's_button_renderer.dart';

/// A button with a label ([SButton], [SButton.secondary],
/// [SButton.text]), one that opens a menu ([SButton.menu]) or just an icon
/// ([SButton.icon]).
class SButton extends StatelessWidget {
  const SButton({
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.loading = false,
    this.expand = false,
    this.icon,
    super.key,
  }) : _iconOnly = false,
       _iconAtEnd = false;

  const SButton.secondary({
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.expand = false,
    this.icon,
    super.key,
  }) : variant = ButtonVariant.secondary,
       _iconOnly = false,
       _iconAtEnd = false;

  const SButton.text({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  }) : variant = ButtonVariant.text,
       loading = false,
       expand = false,
       _iconOnly = false,
       _iconAtEnd = false;

  /// Opens a menu, as ERPNext's "Actions": a primary button with
  /// up-and-down chevrons after the label. Use it as an SMenuButton's builder.
  const SButton.menu({required this.label, required this.onPressed, super.key})
    : variant = ButtonVariant.primary,
      icon = SIcons.chevronUpDown,
      loading = false,
      expand = false,
      _iconOnly = false,
      _iconAtEnd = true;

  /// Just an icon (toolbars). [tooltip] is required so the button always
  /// has a name for screen readers.
  const SButton.icon({
    required SIcons this.icon,
    required String tooltip,
    required this.onPressed,
    super.key,
  }) : label = tooltip,
       variant = ButtonVariant.text,
       loading = false,
       expand = false,
       _iconOnly = true,
       _iconAtEnd = false;

  /// The text on the button; the tooltip of an icon button.
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool loading;
  final bool expand;
  final SIcons? icon;
  final bool _iconOnly;
  final bool _iconAtEnd;

  @override
  Widget build(BuildContext context) {
    final renderer = StellarKit.of(context).button;
    if (_iconOnly) {
      return renderer.icon(
        context,
        IconButtonSpec(icon: icon!, tooltip: label, onPressed: onPressed),
      );
    }
    return renderer.render(
      context,
      ButtonSpec(
        label: label,
        onPressed: onPressed,
        variant: variant,
        loading: loading,
        expand: expand,
        icon: icon,
        iconAtEnd: _iconAtEnd,
      ),
    );
  }
}
