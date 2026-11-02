import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import 's_settings_material.dart';

/// One page of the settings dialog: its entry in the page list, and what
/// it shows. [label] is also the page's title.
@immutable
class SettingsPage {
  const SettingsPage({
    required this.label,
    required this.icon,
    required this.hint,
    required this.children,
  });

  final String label;
  final SIcons icon;

  /// A line under the title saying what the page is for.
  final String hint;
  final List<Widget> children;
}

/// Settings in a dialog, as in ERPNext: the [pages] listed on the start
/// side, the open one beside them. Show it with `SDialog.show`.
abstract interface class SSettingsDialog implements Widget {
  /// [title] goes above the page list ("Settings").
  const factory SSettingsDialog({
    required String title,
    required List<SettingsPage> pages,
    Key? key,
  }) = SSettingsDialogMaterial;
}

/// A titled group of settings on a settings page, with a [hint] under the
/// title.
abstract interface class SSettingsGroup implements Widget {
  const factory SSettingsGroup({
    required String title,
    required String hint,
    required Widget child,
    Key? key,
  }) = SSettingsGroupMaterial;
}
