import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';

/// Icons the apps can use. Kits map them to their own icon set, so apps
/// never depend on an icon font. Add one here when a screen needs it.
enum SIcons {
  // Things.
  store,
  location,
  home,
  users,
  user,
  offers,
  category,
  phone,
  key,
  settings,
  language,
  lock,
  show,
  hide,
  // Actions.
  add,
  edit,
  copy,
  close,
  refresh,
  search,
  filter,
  more,
  menu,
  logout,
  disable,
  enable,
  // Lists and navigation.
  chevron,
  chevronBack,
  chevronDown,
  sortable,
  ascending,
  descending,
  // States.
  check,
  success,
  error,
  noConnection,
  empty,
  noResults,
  update,
  selected,
  unselected,
}

/// A standalone icon: `SIcon(SIcons.store, color: SColor.textMuted)`.
/// Size and color are stellar tokens, never raw numbers or colors.
class SIcon extends StatelessWidget {
  const SIcon(
    this.icon, {
    this.size = SIconSize.md,
    this.color = SColor.text,
    super.key,
  });

  final SIcons icon;
  final SIconSize size;
  final SColor color;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).icon.render(context, icon, size, color);
}
