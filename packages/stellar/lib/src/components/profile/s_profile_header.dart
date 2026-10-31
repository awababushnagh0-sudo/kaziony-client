import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../badge/s_badge_renderer.dart';
import 's_profile_renderer.dart';

/// The top of a profile page: a round picture ([imageUrl], a logo; else a
/// person's outline), and beside it the [title] in big type, a [badge]
/// beside the [subtitle] (a role and a name), and a [phone].
class SProfileHeader extends StatelessWidget {
  const SProfileHeader({
    required this.title,
    this.subtitle,
    this.badge,
    this.badgeTone = BadgeTone.success,
    this.phone,
    this.imageUrl,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? badge;
  final BadgeTone badgeTone;

  /// Already written for people (`formatLibyanPhone`); read left to right
  /// in Arabic too.
  final String? phone;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).profile.header(
    context,
    ProfileHeaderSpec(
      title: title,
      subtitle: subtitle,
      badge: badge,
      badgeTone: badgeTone,
      phone: phone,
      imageUrl: imageUrl,
    ),
  );
}

/// The pages people open most, as rows bigger than settings rows: gray,
/// each with its picture, its name, a line on what's inside and an arrow.
class SShortcuts extends StatelessWidget {
  const SShortcuts(this.shortcuts, {super.key});

  final List<Shortcut> shortcuts;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).profile.shortcuts(context, shortcuts);
}
