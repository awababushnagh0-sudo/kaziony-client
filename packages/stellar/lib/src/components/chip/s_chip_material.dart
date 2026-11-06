import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_chip.dart';

/// As tall as an [SPill], so they line up in a row.
const _height = 36.0;

/// [SChip], drawn as an outlined [Material] with an [InkWell] for the
/// word and another for the ×.
class SChipMaterial extends StatelessWidget implements SChip {
  const SChipMaterial({
    required this.label,
    required this.onTap,
    this.onRemove,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final onRemove = this.onRemove;
    return Material(
      color: c.surface,
      shape: StadiumBorder(side: BorderSide(color: c.border)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: _height,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: onTap,
              child: Padding(
                // The × brings its own room at the end.
                padding: EdgeInsetsDirectional.only(
                  start: Space.md,
                  end: onRemove == null ? Space.md : Space.xs,
                ),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: c.text,
                      fontSize: context.style.text.small,
                      fontWeight: SFontWeight.medium.value,
                    ),
                  ),
                ),
              ),
            ),
            if (onRemove != null)
              Tooltip(
                message: StellarLocalizations.of(context).chipRemove,
                child: InkWell(
                  onTap: onRemove,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: Space.xs,
                      end: Space.md,
                    ),
                    child: Center(
                      widthFactor: 1,
                      child: Icon(
                        materialIcon(SIcons.close),
                        size: SIconSize.xs.pixels,
                        color: c.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
