import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_record_page_renderer.dart';

/// The body of a record's page, ERPNext-style: [tabs] of fields, and a
/// side panel ([sidebar]) on the end side that moves above the tabs on
/// narrow screens. Put it in an SScaffold with `padded: false`.
class SRecordPage extends StatelessWidget {
  const SRecordPage({required this.tabs, this.sidebar = const [], super.key});

  final List<RecordTab> tabs;
  final List<Widget> sidebar;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).recordPage
          .render(context, RecordPageSpec(tabs: tabs, sidebar: sidebar));
}

/// The top of a record's side panel: its picture (or first letter), name
/// and a detail line.
class SRecordProfile extends StatelessWidget {
  const SRecordProfile({
    required this.title,
    this.subtitle,
    this.imageUrl,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).recordPage
      .profile(
        context,
        RecordProfileSpec(title: title, subtitle: subtitle, imageUrl: imageUrl),
      );
}
