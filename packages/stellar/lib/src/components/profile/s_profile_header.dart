import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../illustration/s_illustration.dart';
import 's_profile_material.dart';

/// Who the person is here, as a small tag beside their name.
@immutable
class ProfileRole {
  const ProfileRole({
    required this.label,
    required this.icon,
    this.lead = false,
  });

  final String label;
  final SIcons icon;

  /// The one in charge (a store's owner): the tag is the brand's green,
  /// with a sparkle; the others' is a quiet gray.
  final bool lead;
}

/// One card in [SShortcuts].
@immutable
class Shortcut {
  const Shortcut({
    required this.illustration,
    required this.label,
    required this.onTap,
    this.hint,
  });

  final Illustration illustration;
  final String label;

  /// What's inside, under [label].
  final String? hint;
  final VoidCallback onTap;
}

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

/// The top of a profile page: a round picture ([imageUrl], a logo; else a
/// person's outline), and beside it the [title] in big type, the [role]
/// as a small tag beside the [subtitle] (a name), and a [phone].
abstract interface class SProfileHeader implements Widget {
  /// [phone] is already written for people (`formatLibyanPhone`).
  const factory SProfileHeader({
    required String title,
    String? subtitle,
    ProfileRole? role,
    String? phone,
    String? imageUrl,
    Key? key,
  }) = SProfileHeaderMaterial;

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

/// The pages people open most, as rows bigger than settings rows: gray,
/// each with its picture, its name, a line on what's inside and an arrow.
abstract interface class SShortcuts implements Widget {
  const factory SShortcuts(List<Shortcut> shortcuts, {Key? key}) =
      SShortcutsMaterial;

  /// The same pages as a row of outlined pills of one width, each with its
  /// icon in its color and its name, and a count on its corner when
  /// something waits there.
  const factory SShortcuts.pills(List<ShortcutPill> pills, {Key? key}) =
      SShortcutPillsMaterial;
}
