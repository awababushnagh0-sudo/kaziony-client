import 'package:flutter/widgets.dart';

import 's_scaffold_material.dart';

/// A page: app bar, body and an optional action pinned to the bottom.
/// Record pages put their list in [parent] and their status in [status].
abstract interface class SScaffold implements Widget {
  /// - [parent]: the page above this one, shown before [title] as a
  ///   breadcrumb ("Stores / Sweet Coast"). It replaces the back arrow.
  /// - [status]: a badge after [title], such as the record's status.
  /// - [padded]: standard page padding around [body].
  /// - [scrollable]: wraps [body] in a scroll view (forms, so the keyboard
  ///   never hides fields); [onRefresh] lets it be pulled down to reload
  ///   (a dashboard of numbers).
  /// - [bottom]: pinned to the bottom (e.g. a primary action).
  /// - [floating]: floats over the end of the page, above the content: the
  ///   page's main action on a long list ("Post an offer").
  /// - [maxWidth]: keeps the content narrow on wide screens (forms on the
  ///   web).
  /// - [centered]: centers the content vertically too (login pages).
  /// - [underStatusBar]: lets [body] start at the top of the screen, behind
  ///   the status bar, for pages that open on a colored band (the stores'
  ///   sign-in). The body keeps the status bar's height free itself. Needs
  ///   [showAppBar] off.
  const factory SScaffold({
    required Widget body,
    String? title,
    ScaffoldParent? parent,
    Widget? status,
    List<Widget> actions,
    bool padded,
    bool scrollable,
    Future<void> Function()? onRefresh,
    Widget? bottom,
    Widget? floating,
    bool showAppBar,
    double? maxWidth,
    bool centered,
    bool underStatusBar,
    Key? key,
  }) = SScaffoldMaterial;
}

/// The breadcrumb link before a page's title.
@immutable
class ScaffoldParent {
  const ScaffoldParent({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;
}
