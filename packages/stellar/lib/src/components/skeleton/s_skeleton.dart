import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import '../text/s_text.dart';
import 's_skeleton_material.dart';

/// Gray shapes where content is on its way, laid out like it, with a soft
/// light sweeping across them: the page looks like itself while it loads,
/// instead of a spinner on a blank screen. Built of [SBone]s.
///
/// One sweep for everything under it, so a skeleton inside another (a
/// card's skeleton in a list's) just joins the outer one. Taller than the
/// room it's given, it is cut at the bottom rather than overflowing; it
/// never scrolls. Screen readers hear "Loading" once, not the shapes.
abstract interface class SSkeleton implements Widget {
  /// [child] is the shapes, [SBone]s laid out like what's coming.
  const factory SSkeleton({required Widget child, Key? key}) =
      SSkeletonMaterial;

  /// The rows of a list ([SListTile]s in an `SPagedList`), divided by
  /// thin lines: a square at the start of each unless [leading] is off,
  /// and two lines of words.
  const factory SSkeleton.list({int rows, bool leading, Key? key}) =
      SSkeletonListMaterial;

  /// Groups of rows ([SListGroup]s), [groups] of them with [rows] each:
  /// a page of a record's details or settings. Like the groups, it has no
  /// sides of its own.
  const factory SSkeleton.groups({int groups, int rows, Key? key}) =
      SSkeletonGroupsMaterial;

  /// A record's page (an offer's, a product's): its photo, title, a few
  /// lines about it and a button. It has no sides of its own: it goes in
  /// a padded scaffold, as the page does.
  const factory SSkeleton.page({Key? key}) = SSkeletonPageMaterial;
}

/// How much of the width it's given a line of words' bone takes.
enum BoneLength {
  /// A word or two (a price, a distance).
  short(0.3),

  /// Half a line (a store's name).
  medium(0.5),

  /// Most of a line (a title).
  long(0.75),

  /// The whole line (a line in a paragraph).
  full(1);

  const BoneLength(this.share);

  /// The share of the width, 0 to 1.
  final double share;
}

/// One gray shape in an [SSkeleton].
abstract interface class SBone implements Widget {
  /// A line of words in [variant]'s size, as tall as its text, [length]
  /// of the width it's given (which must be bounded, as in a column).
  const factory SBone.text({TextVariant variant, BoneLength length, Key? key}) =
      SBoneMaterial.text;

  /// A picture of [size] (an `SImage`'s or a logo's): its square and
  /// corners, round for logos.
  const factory SBone.image({SImageSize size, Key? key}) = SBoneMaterial.image;

  /// A picture the width it's given, [ratio] wide to tall (an
  /// `SImage.wide`'s).
  const factory SBone.wide({SImageRatio ratio, Key? key}) = SBoneMaterial.wide;

  /// A button the width it's given, as tall as the look's buttons.
  const factory SBone.button({Key? key}) = SBoneMaterial.button;

  /// A small pill like an `SBadge`'s.
  const factory SBone.badge({Key? key}) = SBoneMaterial.badge;
}
