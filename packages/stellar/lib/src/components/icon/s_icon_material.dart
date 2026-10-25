import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import 's_icon.dart';
import 's_icon_renderer.dart';

class MaterialIconRenderer implements IconRenderer {
  const MaterialIconRenderer();

  @override
  Widget render(
    BuildContext context,
    SIcons icon,
    SIconSize size,
    SColor color,
  ) => Icon(
    materialIcon(icon),
    size: size.pixels,
    color: context.colors.resolve(color),
  );
}

/// Lucide (lucide.dev), the icon set ERPNext uses, at its thin 300 weight.
/// The codepoints are the `...300` constants of the lucide_icons_flutter
/// package; the font is bundled in stellar (see pubspec.yaml). Arrows that
/// point along the line mirror in right-to-left text. Every IconData is
/// const, so release builds can strip the unused glyphs from the font.
IconData materialIcon(SIcons icon) => switch (icon) {
  SIcons.store => const IconData(
    0xe3e4,
    fontFamily: _f,
    fontPackage: _p,
  ), // store
  SIcons.location => const IconData(
    0xe111,
    fontFamily: _f,
    fontPackage: _p,
  ), // map-pin
  SIcons.home => const IconData(
    0xe0f5,
    fontFamily: _f,
    fontPackage: _p,
  ), // house
  SIcons.users => const IconData(
    0xe1a4,
    fontFamily: _f,
    fontPackage: _p,
  ), // users
  SIcons.user => const IconData(
    0xe468,
    fontFamily: _f,
    fontPackage: _p,
  ), // user-round
  SIcons.offers => const IconData(
    0xe17f,
    fontFamily: _f,
    fontPackage: _p,
  ), // tag
  SIcons.category => const IconData(
    0xe4b3,
    fontFamily: _f,
    fontPackage: _p,
  ), // shapes
  SIcons.phone => const IconData(
    0xe133,
    fontFamily: _f,
    fontPackage: _p,
  ), // phone
  SIcons.key => const IconData(
    0xe4a3,
    fontFamily: _f,
    fontPackage: _p,
  ), // key-round
  SIcons.settings => const IconData(
    0xe154,
    fontFamily: _f,
    fontPackage: _p,
  ), // settings
  SIcons.appearance => const IconData(
    0xe178,
    fontFamily: _f,
    fontPackage: _p,
  ), // sun
  SIcons.language => const IconData(
    0xe0e8,
    fontFamily: _f,
    fontPackage: _p,
  ), // globe
  SIcons.info => const IconData(
    0xe0f9,
    fontFamily: _f,
    fontPackage: _p,
  ), // info
  SIcons.device => const IconData(
    0xe163,
    fontFamily: _f,
    fontPackage: _p,
  ), // smartphone
  SIcons.products => const IconData(
    0xe129,
    fontFamily: _f,
    fontPackage: _p,
  ), // package
  SIcons.image => const IconData(
    0xe0f6,
    fontFamily: _f,
    fontPackage: _p,
  ), // image
  SIcons.archive => const IconData(
    0xe041,
    fontFamily: _f,
    fontPackage: _p,
  ), // archive
  SIcons.restore => const IconData(
    0xe2cd,
    fontFamily: _f,
    fontPackage: _p,
  ), // archive-restore
  SIcons.lock => const IconData(
    0xe10b,
    fontFamily: _f,
    fontPackage: _p,
  ), // lock
  SIcons.show => const IconData(0xe0ba, fontFamily: _f, fontPackage: _p), // eye
  SIcons.hide => const IconData(
    0xe0bb,
    fontFamily: _f,
    fontPackage: _p,
  ), // eye-off
  SIcons.add => const IconData(0xe13d, fontFamily: _f, fontPackage: _p), // plus
  SIcons.edit => const IconData(
    0xe1f9,
    fontFamily: _f,
    fontPackage: _p,
  ), // pencil
  SIcons.copy => const IconData(
    0xe09e,
    fontFamily: _f,
    fontPackage: _p,
  ), // copy
  SIcons.close => const IconData(0xe1b2, fontFamily: _f, fontPackage: _p), // x
  SIcons.refresh => const IconData(
    0xe145,
    fontFamily: _f,
    fontPackage: _p,
  ), // refresh-cw
  SIcons.search => const IconData(
    0xe151,
    fontFamily: _f,
    fontPackage: _p,
  ), // search
  SIcons.filter => const IconData(
    0xe0dc,
    fontFamily: _f,
    fontPackage: _p,
  ), // funnel
  SIcons.more => const IconData(
    0xe0b6,
    fontFamily: _f,
    fontPackage: _p,
  ), // ellipsis
  SIcons.menu => const IconData(
    0xe115,
    fontFamily: _f,
    fontPackage: _p,
  ), // menu
  SIcons.logout => const IconData(
    0xe10e,
    fontFamily: _f,
    fontPackage: _p,
    matchTextDirection: true,
  ), // log-out
  SIcons.disable => const IconData(
    0xe051,
    fontFamily: _f,
    fontPackage: _p,
  ), // ban
  SIcons.enable => const IconData(
    0xe080,
    fontFamily: _f,
    fontPackage: _p,
  ), // circle-play
  SIcons.delete => const IconData(
    0xe18e,
    fontFamily: _f,
    fontPackage: _p,
  ), // trash-2
  SIcons.chevron => const IconData(
    0xe06f,
    fontFamily: _f,
    fontPackage: _p,
    matchTextDirection: true,
  ), // chevron-right
  SIcons.chevronBack => const IconData(
    0xe06e,
    fontFamily: _f,
    fontPackage: _p,
    matchTextDirection: true,
  ), // chevron-left
  SIcons.chevronDown => const IconData(
    0xe06d,
    fontFamily: _f,
    fontPackage: _p,
  ), // chevron-down
  SIcons.chevronUpDown => const IconData(
    0xe211,
    fontFamily: _f,
    fontPackage: _p,
  ), // chevrons-up-down
  SIcons.sortable => const IconData(
    0xe211,
    fontFamily: _f,
    fontPackage: _p,
  ), // chevrons-up-down
  SIcons.ascending => const IconData(
    0xe04a,
    fontFamily: _f,
    fontPackage: _p,
  ), // arrow-up
  SIcons.descending => const IconData(
    0xe042,
    fontFamily: _f,
    fontPackage: _p,
  ), // arrow-down
  SIcons.check => const IconData(
    0xe06c,
    fontFamily: _f,
    fontPackage: _p,
  ), // check
  SIcons.success => const IconData(
    0xe226,
    fontFamily: _f,
    fontPackage: _p,
  ), // circle-check
  SIcons.error => const IconData(
    0xe077,
    fontFamily: _f,
    fontPackage: _p,
  ), // circle-alert
  SIcons.noConnection => const IconData(
    0xe08d,
    fontFamily: _f,
    fontPackage: _p,
  ), // cloud-off
  SIcons.empty => const IconData(
    0xe0f7,
    fontFamily: _f,
    fontPackage: _p,
  ), // inbox
  SIcons.noResults => const IconData(
    0xe4ad,
    fontFamily: _f,
    fontPackage: _p,
  ), // search-x
  SIcons.update => const IconData(
    0xe07b,
    fontFamily: _f,
    fontPackage: _p,
  ), // circle-arrow-up
  SIcons.selected => const IconData(
    0xe345,
    fontFamily: _f,
    fontPackage: _p,
  ), // circle-dot
  SIcons.unselected => const IconData(
    0xe076,
    fontFamily: _f,
    fontPackage: _p,
  ), // circle
};

/// The Lucide font bundled in stellar.
const _f = 'Lucide';
const _p = 'stellar';
