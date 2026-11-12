import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import 's_button_material.dart';

/// A button with a label ([SButton], [SButton.secondary], [SButton.soft],
/// [SButton.dangerSoft], [SButton.dangerSecondary], [SButton.text]), one
/// over a photo ([SButton.onPhoto]), one that opens a menu ([SButton.menu])
/// or just an icon ([SButton.icon], or round on a band: [SButton.onBand]).
///
/// Every button takes [onPressed] (null disables it). The ones with a label
/// can show a spinner and ignore taps while [loading], so a form can't be
/// sent twice, [expand] to the available width, and an [icon] after the
/// label, on the same side for every button (the left in Arabic).
abstract interface class SButton implements Widget {
  /// The page's main action.
  const factory SButton({
    required String label,
    required VoidCallback? onPressed,
    bool loading,
    bool expand,
    SIcons? icon,
    Key? key,
  }) = SButtonMaterial;

  /// Outlined: a second action beside the main one.
  const factory SButton.secondary({
    required String label,
    required VoidCallback? onPressed,
    bool loading,
    bool expand,
    SIcons? icon,
    Key? key,
  }) = SButtonMaterial.secondary;

  /// Gray, beside a primary one: the other choice, not the one to make.
  const factory SButton.soft({
    required String label,
    required VoidCallback? onPressed,
    bool loading,
    bool expand,
    SIcons? icon,
    Key? key,
  }) = SButtonMaterial.soft;

  /// Light red, for an action that can't be undone ("End the offer") that
  /// sits apart from the everyday ones.
  const factory SButton.dangerSoft({
    required String label,
    required VoidCallback? onPressed,
    bool loading,
    bool expand,
    SIcons? icon,
    Key? key,
  }) = SButtonMaterial.dangerSoft;

  /// On the surface with red words and icon from the start, like a row:
  /// for leaving (logging out).
  const factory SButton.dangerSecondary({
    required String label,
    required VoidCallback? onPressed,
    bool loading,
    bool expand,
    SIcons? icon,
    Key? key,
  }) = SButtonMaterial.dangerSecondary;

  /// Just words: the least of the actions.
  const factory SButton.text({
    required String label,
    required VoidCallback? onPressed,
    SIcons? icon,
    Key? key,
  }) = SButtonMaterial.text;

  /// Small and white, lifted on a soft shadow, over a corner of a photo:
  /// an action on what the photo shows (posting an offer from a product's
  /// photo). It reads on any picture.
  const factory SButton.onPhoto({
    required String label,
    required SIcons icon,
    required VoidCallback? onPressed,
    Key? key,
  }) = SPhotoButtonMaterial;

  /// Just an icon, in the brand's green on a white circle, on a band of
  /// its color (`SBand`): beside the place at the top of a home page
  /// (`SPlaceHeader`'s trailing), as tall as it is given room for.
  /// [tooltip] is required so the button always has a name for screen
  /// readers. [count] is how many there are to see behind it (unread
  /// notifications), on an orange dot over the icon; none at 0.
  const factory SButton.onBand({
    required SIcons icon,
    required String tooltip,
    required VoidCallback? onPressed,
    int count,
    Key? key,
  }) = SBandButtonMaterial;

  /// Opens a menu, as ERPNext's "Actions": a primary button with
  /// up-and-down chevrons after the label. Use it as an SMenuButton's
  /// builder.
  const factory SButton.menu({
    required String label,
    required VoidCallback? onPressed,
    Key? key,
  }) = SButtonMaterial.menu;

  /// Just an icon (toolbars). [tooltip] is required so the button always
  /// has a name for screen readers.
  const factory SButton.icon({
    required SIcons icon,
    required String tooltip,
    required VoidCallback? onPressed,
    Key? key,
  }) = SIconButtonMaterial;

  /// An icon on a circle of glass, for a button floating over a photo or
  /// the brand's shapes, where a bare icon would get lost. [tooltip] is
  /// required so the button always has a name for screen readers.
  factory SButton.glass({
    required SIcons icon,
    required String tooltip,
    required VoidCallback onPressed,
    Key? key,
  }) = SGlassButtonMaterial;
}
