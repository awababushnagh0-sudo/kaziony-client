import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_settings_renderer.dart';

/// Settings in a dialog, as in ERPNext: the [pages] listed on the start
/// side, the open one beside them. Show it with `SDialog.show`.
class SSettingsDialog extends StatelessWidget {
  const SSettingsDialog({required this.title, required this.pages, super.key});

  final String title;
  final List<SettingsPage> pages;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).settings
          .dialog(context, SettingsDialogSpec(title: title, pages: pages));
}

/// A titled group of settings on a settings page, with a [hint] under the
/// title.
class SSettingsGroup extends StatelessWidget {
  const SSettingsGroup({
    required this.title,
    required this.hint,
    required this.child,
    super.key,
  });

  final String title;
  final String hint;
  final Widget child;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).settings.group(
    context,
    SettingsGroupSpec(title: title, hint: hint, child: child),
  );
}
