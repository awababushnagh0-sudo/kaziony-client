import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import '../text/s_text.dart';

/// One fact in a record's side panel: a label over its value, with an
/// optional badge at the end ("Added / 15/10/2026").
@immutable
class RecordFact {
  const RecordFact(this.label, this.value, {this.badge});

  final String label;
  final String value;
  final Widget? badge;
}

/// A section of facts in a record's side panel.
class SRecordFacts extends StatelessWidget {
  const SRecordFacts(this.facts, {super.key});

  final List<RecordFact> facts;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final (i, fact) in facts.indexed) ...[
        if (i > 0) const Gap(Space.md),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SText(fact.label, weight: SFontWeight.medium),
                  SText.caption(fact.value),
                ],
              ),
            ),
            ?fact.badge,
          ],
        ),
      ],
    ],
  );
}
