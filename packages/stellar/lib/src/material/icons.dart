import 'package:flutter/widgets.dart';

import '../components/app_icon.dart';

/// Lucide (lucide.dev), the icon set ERPNext uses, at its thin 300 weight.
/// The codepoints are the `...300` constants of the lucide_icons_flutter
/// package; the font is bundled in stellar (see pubspec.yaml). Arrows that
/// point along the line mirror in right-to-left text. Every IconData is
/// const, so release builds can strip the unused glyphs from the font.
IconData materialIcon(AppIcon icon) => switch (icon) {
  AppIcon.store => const IconData(
    0xe3e4,
    fontFamily: _f,
    fontPackage: _p,
  ), // store
  AppIcon.location => const IconData(
    0xe111,
    fontFamily: _f,
    fontPackage: _p,
  ), // map-pin
  AppIcon.home => const IconData(
    0xe0f5,
    fontFamily: _f,
    fontPackage: _p,
  ), // house
  AppIcon.users => const IconData(
    0xe1a4,
    fontFamily: _f,
    fontPackage: _p,
  ), // users
  AppIcon.user => const IconData(
    0xe468,
    fontFamily: _f,
    fontPackage: _p,
  ), // user-round
  AppIcon.offers => const IconData(
    0xe17f,
    fontFamily: _f,
    fontPackage: _p,
  ), // tag
  AppIcon.category => const IconData(
    0xe4b3,
    fontFamily: _f,
    fontPackage: _p,
  ), // shapes
  AppIcon.phone => const IconData(
    0xe133,
    fontFamily: _f,
    fontPackage: _p,
  ), // phone
  AppIcon.key => const IconData(
    0xe4a3,
    fontFamily: _f,
    fontPackage: _p,
  ), // key-round
  AppIcon.settings => const IconData(
    0xe154,
    fontFamily: _f,
    fontPackage: _p,
  ), // settings
  AppIcon.language => const IconData(
    0xe0fe,
    fontFamily: _f,
    fontPackage: _p,
  ), // languages
  AppIcon.lock => const IconData(
    0xe10b,
    fontFamily: _f,
    fontPackage: _p,
  ), // lock
  AppIcon.show => const IconData(
    0xe0ba,
    fontFamily: _f,
    fontPackage: _p,
  ), // eye
  AppIcon.hide => const IconData(
    0xe0bb,
    fontFamily: _f,
    fontPackage: _p,
  ), // eye-off
  AppIcon.add => const IconData(
    0xe13d,
    fontFamily: _f,
    fontPackage: _p,
  ), // plus
  AppIcon.edit => const IconData(
    0xe1f9,
    fontFamily: _f,
    fontPackage: _p,
  ), // pencil
  AppIcon.copy => const IconData(
    0xe09e,
    fontFamily: _f,
    fontPackage: _p,
  ), // copy
  AppIcon.close => const IconData(0xe1b2, fontFamily: _f, fontPackage: _p), // x
  AppIcon.refresh => const IconData(
    0xe145,
    fontFamily: _f,
    fontPackage: _p,
  ), // refresh-cw
  AppIcon.search => const IconData(
    0xe151,
    fontFamily: _f,
    fontPackage: _p,
  ), // search
  AppIcon.filter => const IconData(
    0xe0dc,
    fontFamily: _f,
    fontPackage: _p,
  ), // funnel
  AppIcon.more => const IconData(
    0xe0b6,
    fontFamily: _f,
    fontPackage: _p,
  ), // ellipsis
  AppIcon.menu => const IconData(
    0xe115,
    fontFamily: _f,
    fontPackage: _p,
  ), // menu
  AppIcon.logout => const IconData(
    0xe10e,
    fontFamily: _f,
    fontPackage: _p,
    matchTextDirection: true,
  ), // log-out
  AppIcon.disable => const IconData(
    0xe051,
    fontFamily: _f,
    fontPackage: _p,
  ), // ban
  AppIcon.enable => const IconData(
    0xe080,
    fontFamily: _f,
    fontPackage: _p,
  ), // circle-play
  AppIcon.chevron => const IconData(
    0xe06f,
    fontFamily: _f,
    fontPackage: _p,
    matchTextDirection: true,
  ), // chevron-right
  AppIcon.chevronBack => const IconData(
    0xe06e,
    fontFamily: _f,
    fontPackage: _p,
    matchTextDirection: true,
  ), // chevron-left
  AppIcon.chevronDown => const IconData(
    0xe06d,
    fontFamily: _f,
    fontPackage: _p,
  ), // chevron-down
  AppIcon.sortable => const IconData(
    0xe211,
    fontFamily: _f,
    fontPackage: _p,
  ), // chevrons-up-down
  AppIcon.ascending => const IconData(
    0xe04a,
    fontFamily: _f,
    fontPackage: _p,
  ), // arrow-up
  AppIcon.descending => const IconData(
    0xe042,
    fontFamily: _f,
    fontPackage: _p,
  ), // arrow-down
  AppIcon.check => const IconData(
    0xe06c,
    fontFamily: _f,
    fontPackage: _p,
  ), // check
  AppIcon.success => const IconData(
    0xe226,
    fontFamily: _f,
    fontPackage: _p,
  ), // circle-check
  AppIcon.error => const IconData(
    0xe077,
    fontFamily: _f,
    fontPackage: _p,
  ), // circle-alert
  AppIcon.noConnection => const IconData(
    0xe08d,
    fontFamily: _f,
    fontPackage: _p,
  ), // cloud-off
  AppIcon.empty => const IconData(
    0xe0f7,
    fontFamily: _f,
    fontPackage: _p,
  ), // inbox
  AppIcon.noResults => const IconData(
    0xe4ad,
    fontFamily: _f,
    fontPackage: _p,
  ), // search-x
  AppIcon.update => const IconData(
    0xe07b,
    fontFamily: _f,
    fontPackage: _p,
  ), // circle-arrow-up
  AppIcon.selected => const IconData(
    0xe345,
    fontFamily: _f,
    fontPackage: _p,
  ), // circle-dot
  AppIcon.unselected => const IconData(
    0xe076,
    fontFamily: _f,
    fontPackage: _p,
  ), // circle
};

/// The Lucide font bundled in stellar.
const _f = 'Lucide';
const _p = 'stellar';
