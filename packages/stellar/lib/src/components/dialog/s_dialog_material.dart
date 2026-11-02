import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_dialog.dart';

/// [SDialog] in the style of ERPNext, drawn with Material's [Dialog].
class SDialogMaterial extends StatelessWidget implements SDialog {
  const SDialogMaterial({
    required this.title,
    required this.body,
    this.primaryLabel,
    this.onPrimary,
    this.busy = false,
    this.showCancel = true,
    this.width = 520,
    super.key,
  });

  final String title;
  final Widget body;

  /// The main button; no footer without it.
  final String? primaryLabel;
  final VoidCallback? onPrimary;

  /// Disables the buttons and closing while the action runs.
  final bool busy;
  final bool showCancel;
  final double width;

  /// [SDialog.show].
  static Future<T?> show<T>(
    BuildContext context,
    WidgetBuilder builder, {
    bool dismissible = true,
  }) => showDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    builder: builder,
  );

  /// [SDialog.confirm], as Material's [AlertDialog].
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    String? cancelLabel,
    bool destructive = false,
  }) async {
    final cancel = cancelLabel ?? StellarLocalizations.of(context).cancel;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        final c = context.colors;
        return AlertDialog(
          title: Text(title, style: Theme.of(context).textTheme.titleMedium),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Text(message),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancel),
            ),
            FilledButton(
              style: destructive
                  ? FilledButton.styleFrom(
                      backgroundColor: c.danger,
                      foregroundColor: c.onDanger,
                    )
                  : null,
              onPressed: () => Navigator.pop(context, true),
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final strings = StellarLocalizations.of(context);
    final primaryLabel = this.primaryLabel;
    return PopScope(
      canPop: !busy,
      child: Dialog(
        clipBehavior: Clip.antiAlias,
        insetPadding: const EdgeInsets.all(Space.lg),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 14, 12, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: strings.close,
                      icon: Icon(
                        materialIcon(SIcons.close),
                        size: SIconSize.md.pixels,
                      ),
                      onPressed: busy ? null : () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: c.border),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Space.xl),
                  child: body,
                ),
              ),
              if (primaryLabel != null) ...[
                Divider(height: 1, color: c.border),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Space.xl,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: Space.sm,
                    children: [
                      if (showCancel)
                        TextButton(
                          onPressed: busy ? null : () => Navigator.pop(context),
                          child: Text(strings.cancel),
                        ),
                      FilledButton(
                        onPressed: busy ? null : onPrimary,
                        child: busy
                            ? SizedBox.square(
                                dimension: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: c.textSubtle,
                                ),
                              )
                            : Text(primaryLabel),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
