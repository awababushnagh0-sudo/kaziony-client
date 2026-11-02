import 'package:flutter/widgets.dart';

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
}

/// The pages people open most, as rows bigger than settings rows: gray,
/// each with its picture, its name, a line on what's inside and an arrow.
abstract interface class SShortcuts implements Widget {
  const factory SShortcuts(List<Shortcut> shortcuts, {Key? key}) =
      SShortcutsMaterial;
}
