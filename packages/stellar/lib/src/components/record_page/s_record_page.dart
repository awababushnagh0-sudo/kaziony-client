import 'package:flutter/widgets.dart';

import 's_record_page_material.dart';

/// One tab of a record page: its label and what it shows.
@immutable
class RecordTab {
  const RecordTab({required this.label, required this.child});

  final String label;

  /// Usually SFormSections of fields. The page scrolls it.
  final Widget child;
}

/// The body of a record's page (a store, an offer), ERPNext-style: [tabs] of
/// fields, and a side panel ([sidebar]) on the end side that moves above the
/// tabs on narrow screens. Put it in an SScaffold with `padded: false`.
abstract interface class SRecordPage implements Widget {
  /// The tab bar is hidden when there is only one tab. [sidebar] holds the
  /// side panel's sections (SRecordProfile, SRecordFacts), separated by
  /// lines.
  const factory SRecordPage({
    required List<RecordTab> tabs,
    List<Widget> sidebar,
    Key? key,
  }) = SRecordPageMaterial;
}

/// The top of a record's side panel: its picture (or first letter), name
/// and a detail line.
abstract interface class SRecordProfile implements Widget {
  /// Without an [imageUrl] (or when it fails to load), the title's first
  /// letter.
  const factory SRecordProfile({
    required String title,
    String? subtitle,
    String? imageUrl,
    Key? key,
  }) = SRecordProfileMaterial;
}
