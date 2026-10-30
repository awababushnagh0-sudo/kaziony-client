import 'package:flutter/widgets.dart';

import '../badge/s_badge_renderer.dart';
import '../illustration/s_illustration_renderer.dart';

@immutable
class ProfileHeaderSpec {
  const ProfileHeaderSpec({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeTone,
    required this.phone,
    required this.imageUrl,
  });

  final String title;
  final String? subtitle;
  final String? badge;
  final BadgeTone badgeTone;
  final String? phone;
  final String? imageUrl;
}

/// One card in [ProfileRenderer.shortcuts].
@immutable
class Shortcut {
  const Shortcut({
    required this.illustration,
    required this.label,
    required this.onTap,
  });

  final SIllustrations illustration;
  final String label;
  final VoidCallback onTap;
}

abstract interface class ProfileRenderer {
  Widget header(BuildContext context, ProfileHeaderSpec spec);

  Widget shortcuts(BuildContext context, List<Shortcut> shortcuts);
}
