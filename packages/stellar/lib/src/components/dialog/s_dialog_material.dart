import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_dialog_renderer.dart';

/// Dialogs and confirmations in the style of ERPNext.
class MaterialDialogRenderer implements DialogRenderer {
  const MaterialDialogRenderer();

  @override
  Future<T?> show<T>(
    BuildContext context,
    WidgetBuilder builder, {
    bool dismissible = true,
  }) => showDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    builder: builder,
  );

  @override
  Widget render(BuildContext context, DialogSpec spec) => _Dialog(spec: spec);

  @override
  Future<bool> confirm(BuildContext context, ConfirmSpec spec) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        final c = context.colors;
        return AlertDialog(
          title: Text(
            spec.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Text(spec.message),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(spec.cancelLabel),
            ),
            FilledButton(
              style: spec.destructive
                  ? FilledButton.styleFrom(
                      backgroundColor: c.danger,
                      foregroundColor: c.onDanger,
                    )
                  : null,
              onPressed: () => Navigator.pop(context, true),
              child: Text(spec.confirmLabel),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}

class _Dialog extends StatelessWidget {
  const _Dialog({required this.spec});

  final DialogSpec spec;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final busy = spec.busy;
    return PopScope(
      canPop: !busy,
      child: Dialog(
        clipBehavior: Clip.antiAlias,
        insetPadding: const EdgeInsets.all(Space.lg),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: spec.width),
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
                        spec.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: spec.closeLabel,
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
                  child: spec.body,
                ),
              ),
              if (spec.primaryLabel != null) ...[
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
                      if (spec.cancelLabel != null)
                        TextButton(
                          onPressed: busy ? null : () => Navigator.pop(context),
                          child: Text(spec.cancelLabel!),
                        ),
                      FilledButton(
                        onPressed: busy ? null : spec.onPrimary,
                        child: busy
                            ? SizedBox.square(
                                dimension: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: c.textSubtle,
                                ),
                              )
                            : Text(spec.primaryLabel!),
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
