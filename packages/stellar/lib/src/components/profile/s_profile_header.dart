import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../illustration/s_illustration.dart';
import 's_profile_material.dart';

/// One pill in [SShortcuts.pills].
@immutable
class ShortcutPill {
  const ShortcutPill({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = SColor.primary,
    this.count = 0,
  });

  final String label;
  final SIcons icon;

  /// The icon's color, so each pill reads apart (a heart's pink).
  final SColor color;

  /// What waits there, as a badge on the pill's corner; none at 0.
  final int count;
  final VoidCallback onTap;
}

/// The top of a profile page.
abstract interface class SProfileHeader implements Widget {
  /// A band in the brand's soft orange across the page's top, behind the
  /// status bar: a [greeting] over the [name] in big type and the
  /// [subtitle] (an email), with an [illustration] at the end. For a page
  /// that starts at the screen's top
  /// (`SScaffold(showAppBar: false, underStatusBar: true, padded: false)`).
  const factory SProfileHeader.greeting({
    required String greeting,
    required String name,
    String? subtitle,
    Illustration? illustration,
    Key? key,
  }) = SProfileGreetingMaterial;
}

/// The pages people open most.
abstract interface class SShortcuts implements Widget {
  /// A row of outlined pills of one width, each with its icon in its color
  /// and its name, and a count on its corner when something waits there.
  const factory SShortcuts.pills(List<ShortcutPill> pills, {Key? key}) =
      SShortcutPillsMaterial;
}
