import 'package:flutter/widgets.dart';

/// A picture an [SIllustration] shows: one of stellar's ([SIllustrations]),
/// or one of an app's, from the app's own `assets/illustrations` (an enum
/// that implements this). Each is a PNG at 1x, 2x and 3x, on a transparent
/// background, and knows the widest it's shown; it shrinks to fit narrower
/// places, keeping its shape.
abstract interface class Illustration {
  /// The picture's file name, without `.png`.
  String get file;
  Size get size;

  /// The Arabic picture's size, for pictures with words in them, drawn in
  /// each language (`<file>_ar.png`, `<file>_en.png`). Null when one
  /// picture serves every language.
  Size? get arabicSize;

  /// The package whose assets hold the picture; null for the app's own.
  String? get package;
}

/// The pictures stellar's own components show, bundled with it. Pictures
/// only one app shows are in that app.
enum SIllustrations implements Illustration {
  /// Two speech bubbles, "ع" and "A": choosing the app's language.
  languages('languages', Size(140, 104)),

  /// A light page with the sun and a dark one with the moon: choosing the
  /// app's theme.
  theme('theme', Size(140, 104)),

  /// A person's outline in a circle: someone, or a store, without a
  /// picture yet ([SProfileHeader]).
  avatar('avatar', Size(72, 72));

  const SIllustrations(this.file, this.size);

  @override
  final String file;
  @override
  final Size size;

  @override
  Size? get arabicSize => null;

  @override
  String get package => 'stellar';
}

@immutable
class IllustrationSpec {
  const IllustrationSpec({required this.illustration});

  final Illustration illustration;
}

abstract interface class IllustrationRenderer {
  Widget render(BuildContext context, IllustrationSpec spec);
}
