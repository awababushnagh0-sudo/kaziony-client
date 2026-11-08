import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import 's_text_material.dart';

/// The size (and default weight) of a text, from the theme's type scale.
enum TextVariant { figure, display, title, subtitle, body, caption, label }

/// All text in the apps. Size, weight and color are stellar tokens
/// ([TextVariant], [SFontWeight], [SColor]), never raw numbers or colors.
abstract interface class SText implements Widget {
  /// Body text in the text's color unless told otherwise. A null [weight]
  /// keeps the variant's own; [maxLines] cuts it with an ellipsis; [struck]
  /// crosses it out (a regular price beside its offer price).
  const factory SText(
    String text, {
    TextVariant variant,
    SColor color,
    SFontWeight? weight,
    TextAlign? align,
    int? maxLines,
    bool struck,
    Key? key,
  }) = STextMaterial;

  /// The biggest, bold.
  const factory SText.display(
    String text, {
    SColor color,
    TextAlign? align,
    Key? key,
  }) = STextMaterial.display;

  /// A title, bold.
  const factory SText.title(
    String text, {
    SColor color,
    TextAlign? align,
    int? maxLines,
    Key? key,
  }) = STextMaterial.title;

  /// Small and muted.
  const factory SText.caption(
    String text, {
    SColor color,
    TextAlign? align,
    int? maxLines,
    Key? key,
  }) = STextMaterial.caption;
}
