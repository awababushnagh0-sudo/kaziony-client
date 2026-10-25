import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_sheet_renderer.dart';

const _sheetRadius = 20.0;
const _optionHeight = 56.0;

/// A white sheet with rounded top corners and a handle, its title, then one
/// row per choice with a check on the current one, as in the big apps.
class MaterialSheetRenderer implements SheetRenderer {
  const MaterialSheetRenderer();

  @override
  Future<T?> choose<T>(BuildContext context, ChoiceSheetSpec<T> spec) =>
      showModalBottomSheet<T>(
        context: context,
        useSafeArea: true,
        showDragHandle: true,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            spec.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Gap(Space.md),
          for (final option in spec.options)
            Semantics(
              selected: option.value == spec.selected,
              button: true,
              child: InkWell(
                borderRadius: BorderRadius.circular(Radii.lg),
                onTap: () => Navigator.of(context).pop(option.value),
                child: SizedBox(
                  height: _optionHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.sm),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option.label,
                            style: TextStyle(
                              fontSize: context.style.text.body,
                              fontWeight: SFontWeight.medium.value,
                              color: c.text,
                            ),
                          ),
                        ),
                        if (option.value == spec.selected)
                          Icon(
                            materialIcon(SIcons.check),
                            size: SIconSize.md.pixels,
                            color: c.text,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
