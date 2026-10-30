import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../illustration/s_illustration.dart';
import '../list_tile/s_radio_group.dart';
import 's_sheet_renderer.dart';

const _sheetRadius = 20.0;

/// A white sheet with rounded top corners and a handle: an optional
/// picture, the title and a line on what the choice changes, then the
/// choices as an [SRadioGroup]. Tapping one closes the sheet with it.
class MaterialSheetRenderer implements SheetRenderer {
  const MaterialSheetRenderer();

  @override
  Future<T?> choose<T>(BuildContext context, ChoiceSheetSpec<T> spec) =>
      showModalBottomSheet<T>(
        context: context,
        // Over the whole app: a tab's own navigator would put it under
        // the nav bar.
        useRootNavigator: true,
        useSafeArea: true,
        showDragHandle: true,
        // Long lists (a store's branches) scroll inside the sheet.
        isScrollControlled: true,
        backgroundColor: context.colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_sheetRadius),
          ),
        ),
        builder: (context) => _ChoiceSheet(spec: spec),
      );
}

class _ChoiceSheet<T> extends StatelessWidget {
  const _ChoiceSheet({required this.spec});

  final ChoiceSheetSpec<T> spec;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    return Padding(
      // The safe area keeps the top and sides; the bottom (the home
      // indicator) is left to the sheet.
      padding: EdgeInsets.fromLTRB(
        Space.lg,
        0,
        Space.lg,
        Space.lg + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (spec.illustration case final illustration?) ...[
            SIllustration(illustration),
            const Gap(Space.md),
          ],
          Text(
            spec.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: text.title,
              fontWeight: SFontWeight.bold.value,
              color: c.text,
            ),
          ),
          if (spec.subtitle case final subtitle?) ...[
            const Gap(Space.xs),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: text.body, color: c.textMuted),
            ),
          ],
          const Gap(Space.xl),
          Flexible(
            child: SingleChildScrollView(
              child: SRadioGroup<T>(
                options: spec.options,
                value: spec.selected,
                onChanged: (value) => Navigator.of(context).pop(value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
