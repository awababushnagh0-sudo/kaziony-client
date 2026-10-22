import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../l10n/generated/admin_localizations.dart';
import 'record_form.dart';

/// A saved record's page, ERPNext-style: "Parent / title" with its status
/// and actions, and its fields under them, edited in place. Once a field
/// changes, the header shows "Not saved" and Save instead, and leaving the
/// page asks first (its route needs `onExit: LeaveGuard.onExit`, which every
/// dashboard page has).
///
/// [record] and [form] are the record's providers (see [RecordForm]); the
/// screen only describes its header and its fields.
class RecordScreen<T> extends AppView {
  const RecordScreen({
    required this.record,
    required this.form,
    required this.parent,
    required this.title,
    required this.builder,
    this.status,
    this.actions,
    super.key,
  });

  final AsyncNotifierProvider<AsyncViewModel<T>, T> record;
  final NotifierProvider<RecordForm<T>, RecordFormState> form;

  /// The list the record belongs to, e.g. "Stores".
  final ScaffoldParent parent;
  final String Function(T record) title;

  /// Its fields, usually an SRecordPage; they're inside the form.
  final Widget Function(BuildContext context, T record) builder;

  /// Its badge, e.g. "Active".
  final Widget Function(T record)? status;

  /// Its header buttons, e.g. an "Actions" menu.
  final List<Widget> Function(T record)? actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final loaded = ref.watch(record);
    final saved = loaded.value;
    final edit = ref.watch(form);
    final editor = ref.read(form.notifier);

    Future<void> save() async {
      final result = await editor.save();
      if (!context.mounted) return;
      switch (result) {
        case null:
          return;
        case Ok():
          SSnack.success(context, s.savedDone);
        case Err(:final failure):
          SSnack.error(context, failureMessage(context, failure));
      }
    }

    return LeaveGuard(
      active: edit.changed,
      confirm: (context) => SDialog.confirm(
        context,
        title: s.discardChangesTitle,
        message: s.discardChangesMessage,
        confirmLabel: s.discardChanges,
        destructive: true,
      ),
      child: SScaffold(
        title: saved == null ? '' : title(saved),
        parent: parent,
        status: switch (saved) {
          null => null,
          _ when edit.changed => SBadge(s.notSaved, tone: BadgeTone.warning),
          final saved => status?.call(saved),
        },
        actions: [
          if (edit.changed)
            SButton(label: s.save, loading: edit.saving, onPressed: save)
          else if (saved != null)
            ...?actions?.call(saved),
        ],
        padded: false,
        body: SAsyncView(
          value: loaded,
          onRetry: () => ref.invalidate(record),
          builder: (context, saved) =>
              SForm(form: editor.form, child: builder(context, saved)),
        ),
      ),
    );
  }
}
