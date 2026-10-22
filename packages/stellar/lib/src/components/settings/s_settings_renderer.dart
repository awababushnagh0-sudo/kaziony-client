import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';

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

@immutable
class SettingsDialogSpec {
  const SettingsDialogSpec({required this.title, required this.pages});

  /// Above the page list ("Settings").
  final String title;
  final List<SettingsPage> pages;
}

/// A titled group of settings within a page.
@immutable
class SettingsGroupSpec {
  const SettingsGroupSpec({
    required this.title,
    required this.hint,
    required this.child,
  });

  final String title;
  final String hint;
  final Widget child;
}

/// What an option card shows above its label: a small picture of the app
/// window in light or dark colors, or both side by side (follow the
/// device).
enum WindowPreview { light, dark, lightAndDark }

@immutable
class OptionCardSpec {
  const OptionCardSpec({
    required this.label,
    required this.preview,
    required this.selected,
    required this.onTap,
    this.direction,
  });

  final String label;
  final WindowPreview preview;
  final bool selected;
  final VoidCallback onTap;

  /// Lays the preview out in this direction, not the page's: a language's
  /// card shows its side menu on its own side.
  final TextDirection? direction;
}

/// Draws the settings dialog and what goes on its pages.
abstract interface class SettingsRenderer {
  Widget dialog(BuildContext context, SettingsDialogSpec spec);
  Widget group(BuildContext context, SettingsGroupSpec spec);

  /// Cards three to a row (one on narrow screens), the same width in every
  /// group.
  Widget optionGrid(BuildContext context, List<Widget> cards);
  Widget optionCard(BuildContext context, OptionCardSpec spec);
}
