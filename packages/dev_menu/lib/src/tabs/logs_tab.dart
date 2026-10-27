import 'package:flutter/material.dart';
import 'package:kernel/kernel.dart';

import '../dev_panel.dart';

/// Everything printed with debugPrint, plus reported errors.
class LogsTab extends AppView {
  const LogsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(devLogProvider);
    return ListenableBuilder(
      listenable: log,
      builder: (context, _) => Column(
        children: [
          ListTile(
            dense: true,
            title: Text('${log.logs.length} messages'),
            trailing: TextButton(
              onPressed: log.clear,
              child: const Text('Clear'),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: log.logs.isEmpty
                ? const Center(child: Text('Nothing logged yet'))
                : ListView.separated(
                    itemCount: log.logs.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) => _LogTile(log.logs[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile(this.entry);

  final AppLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final color = switch (entry.level) {
      LogLevel.error => Colors.red,
      LogLevel.warning => Colors.orange,
      LogLevel.info => Colors.blue,
      LogLevel.debug => Colors.grey,
    };
    final title = Text(
      entry.message,
      style: monospace.copyWith(
        color: entry.level == LogLevel.error ? color : null,
      ),
    );
    final subtitle = Text('${clockTime(entry.time)} · ${entry.level.name}');
    final marker = Container(width: 4, height: 32, color: color);

    if (entry.stack == null) {
      return ListTile(
        dense: true,
        leading: marker,
        title: title,
        subtitle: subtitle,
      );
    }
    return ExpansionTile(
      dense: true,
      leading: marker,
      title: title,
      subtitle: subtitle,
      childrenPadding: const EdgeInsets.all(12),
      children: [SelectableText(entry.stack!, style: monospace)],
    );
  }
}
