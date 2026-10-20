import 'package:flutter/widgets.dart';

import '../kit/contracts.dart';
import '../kit/stellar_kit.dart';
import 'app_icon.dart';

// The widgets apps use. Each one only describes what it wants (a spec) and
// lets the active StellarKit draw it.

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.loading = false,
    this.expand = false,
    this.icon,
    super.key,
  });

  const AppButton.secondary({
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.expand = false,
    this.icon,
    super.key,
  }) : variant = ButtonVariant.secondary;

  const AppButton.text({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  }) : variant = ButtonVariant.text,
       loading = false,
       expand = false;

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool loading;
  final bool expand;
  final AppIcon? icon;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).button.render(
    context,
    ButtonSpec(
      label: label,
      onPressed: onPressed,
      variant: variant,
      loading: loading,
      expand: expand,
      icon: icon,
    ),
  );
}

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.title,
    this.actions = const [],
    this.padded = true,
    this.scrollable = false,
    this.bottom,
    this.showAppBar = true,
    super.key,
  });

  final Widget body;
  final String? title;
  final List<Widget> actions;
  final bool padded;
  final bool scrollable;
  final Widget? bottom;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).scaffold.render(
    context,
    ScaffoldSpec(
      body: body,
      title: title,
      actions: actions,
      padded: padded,
      scrollable: scrollable,
      bottom: bottom,
      showAppBar: showAppBar,
    ),
  );
}

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    this.variant = TextVariant.body,
    this.tone = TextTone.normal,
    this.align,
    this.maxLines,
    this.bold = false,
    super.key,
  });

  const AppText.display(
    this.text, {
    this.tone = TextTone.normal,
    this.align,
    super.key,
  }) : variant = TextVariant.display,
       maxLines = null,
       bold = true;

  const AppText.title(
    this.text, {
    this.tone = TextTone.normal,
    this.align,
    this.maxLines,
    super.key,
  }) : variant = TextVariant.title,
       bold = true;

  const AppText.caption(
    this.text, {
    this.tone = TextTone.muted,
    this.align,
    this.maxLines,
    super.key,
  }) : variant = TextVariant.caption,
       bold = false;

  final String text;
  final TextVariant variant;
  final TextTone tone;
  final TextAlign? align;
  final int? maxLines;
  final bool bold;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).text.render(
    context,
    TextSpec(
      text,
      variant: variant,
      tone: tone,
      align: align,
      maxLines: maxLines,
      bold: bold,
    ),
  );
}

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padded = true,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool padded;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).card
      .render(context, CardSpec(child: child, onTap: onTap, padded: padded));
}

class AppListTile extends StatelessWidget {
  const AppListTile({
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final String? subtitle;
  final AppIcon? icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).listTile.render(
    context,
    ListTileSpec(
      title: title,
      subtitle: subtitle,
      icon: icon,
      trailing: trailing,
      onTap: onTap,
    ),
  );
}

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).status.loading(context, message: message);
}

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    required this.title,
    this.message,
    this.icon = AppIcon.empty,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String? message;
  final AppIcon icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).status.empty(
    context,
    StatusSpec(
      title: title,
      message: message,
      icon: icon,
      actionLabel: actionLabel,
      onAction: onAction,
    ),
  );
}

/// Short message at the bottom of the screen.
abstract final class AppSnack {
  static void info(BuildContext context, String message) =>
      StellarKit.of(context).snack.show(context, message, SnackTone.info);

  static void success(BuildContext context, String message) =>
      StellarKit.of(context).snack.show(context, message, SnackTone.success);

  static void error(BuildContext context, String message) =>
      StellarKit.of(context).snack.show(context, message, SnackTone.error);
}
