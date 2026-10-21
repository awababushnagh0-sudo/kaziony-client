import 'package:flutter/widgets.dart';

/// One tab of a record page: its label and what it shows.
@immutable
class RecordTab {
  const RecordTab({required this.label, required this.child});

  final String label;

  /// Usually SFormSections of fields. The page scrolls it.
  final Widget child;
}

@immutable
class RecordPageSpec {
  const RecordPageSpec({required this.tabs, this.sidebar = const []});

  /// The bar is hidden when there is only one.
  final List<RecordTab> tabs;

  /// Sections of the side panel (SRecordProfile, SRecordFacts), separated
  /// by lines.
  final List<Widget> sidebar;
}

@immutable
class RecordProfileSpec {
  const RecordProfileSpec({required this.title, this.subtitle, this.imageUrl});

  final String title;
  final String? subtitle;

  /// Without one (or when it fails to load), the title's first letter.
  final String? imageUrl;
}

/// Draws a single record (a store, an offer), as ERPNext's form view: tabs
/// of fields, and a side panel with its picture and key facts.
abstract interface class RecordPageRenderer {
  Widget render(BuildContext context, RecordPageSpec spec);

  /// The top of the side panel: picture, name and a detail line.
  Widget profile(BuildContext context, RecordProfileSpec spec);
}
