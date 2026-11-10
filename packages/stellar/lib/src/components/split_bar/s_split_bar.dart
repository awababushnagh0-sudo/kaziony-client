import 'package:flutter/widgets.dart';

import 's_split_bar_material.dart';

/// What a part of an [SSplitBar] stands for, by its color.
enum SplitTone {
  /// Finished: the brand's green.
  done,

  /// On its way to finished: a lighter green.
  underway,

  /// Nothing has happened to it yet: a quiet gray.
  waiting,

  /// Running out: the brand's orange, on its words too.
  hot,
}

/// One part of an [SSplitBar]: how many, and what they are.
@immutable
class SplitPart {
  const SplitPart({
    required this.count,
    required this.label,
    this.tone = SplitTone.waiting,
    this.keyed = true,
  });

  final int count;
  final String label;
  final SplitTone tone;

  /// False leaves it out of the key, where its count shows bigger beside
  /// the bar (the pieces left, at the end of an offer's card).
  final bool keyed;
}

/// A whole split into parts, as one bar with a key under it: where the 10
/// pieces of an offer are now. The parts take the bar's width by their
/// counts, and the key's words shrink together rather than being cut.
abstract interface class SSplitBar implements Widget {
  /// [parts] run from the start of the bar; one counting 0 stays in the key
  /// only. [note] ends the key with words that aren't a part ("No limit").
  /// [faded] grays the greens: it's over.
  const factory SSplitBar({
    required List<SplitPart> parts,
    String? note,
    bool faded,
    Key? key,
  }) = SSplitBarMaterial;
}
