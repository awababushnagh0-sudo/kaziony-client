import 'package:flutter/widgets.dart';

import 's_rating_material.dart';

/// A rating at a glance: a filled star, the [average] with one decimal and
/// how many rated in brackets, "★ 4.5 (37)". Show it only once something
/// has been rated: "0" says nothing.
abstract interface class SRating implements Widget {
  /// [average] from 1 to 5. [label] is the whole of it for screen readers
  /// ("Rated 4.5 out of 5 by 37 people"). [count] (how many rated it) is
  /// left out where room is short, as on an offer's card. [small] fits a
  /// caption, in a row of a list; else it reads like body text.
  const factory SRating({
    required double average,
    int? count,
    required String label,
    bool small,
    Key? key,
  }) = SRatingMaterial;
}
