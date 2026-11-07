import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import 's_icon_material.dart';

/// Icons the apps can use. The drawing code maps them to its own icon set,
/// so apps never depend on an icon font. Add one here when a screen needs it.
enum SIcons {
  // Things.
  store,
  location,

  /// Finding where the phone is ("use my location").
  navigate,
  home,
  users,
  user,

  /// The store's owner.
  crown,

  /// A touch of shine on something special.
  sparkles,
  offers,

  /// What a store sells.
  products,

  /// A picture's place while it loads, or when there's none.
  image,
  camera,

  /// Reads a customer's code at the counter.
  scan,

  /// Shows the customer's own code, to be read.
  qrCode,
  torch,
  torchOff,
  keyboard,

  /// Customers on their way to pick up.
  pickups,

  /// A customer's reservations.
  bookings,

  /// Offers and stores a customer saved.
  favorites,

  /// The stars a customer gave stores.
  ratings,

  /// Food not thrown away.
  leaf,

  /// Money saved.
  wallet,

  /// Paying cash at the counter.
  cash,

  /// How long a reservation is held.
  hourglass,

  /// Numbers over time: a store's month.
  chart,
  category,
  phone,

  /// A chat with our team (WhatsApp).
  chat,
  mail,
  key,
  settings,

  /// Light or dark: the theme settings.
  appearance,
  language,
  lock,

  /// About the app, more details.
  info,

  /// A page of text: the terms and conditions.
  document,

  /// The phone the app runs on (its version).
  device,
  show,
  hide,
  // Actions.
  add,

  /// One fewer (a quantity).
  minus,
  edit,
  copy,
  close,
  refresh,
  search,
  filter,
  more,
  menu,

  /// Show a list as big cards.
  viewCards,

  /// Show a list as compact rows.
  viewList,
  logout,
  disable,
  enable,
  delete,
  archive,
  calendar,

  /// Until when an offer runs.
  clock,
  pause,

  /// Starts again (a paused offer).
  resume,

  /// Stops for good (an offer).
  stop,

  /// Posts again (an ended offer).
  repost,

  /// Brings back something archived.
  restore,
  // Lists and navigation.
  chevron,
  chevronBack,
  chevronDown,

  /// A menu or select button: ERPNext's up-and-down chevrons.
  chevronUpDown,
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
abstract interface class SIcon implements Widget {
  /// Medium, in the text's color, unless [size] or [color] say otherwise.
  const factory SIcon(SIcons icon, {SIconSize size, SColor color, Key? key}) =
      SIconMaterial;
}
