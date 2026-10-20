import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kernel/kernel.dart';

import '../dev_panel.dart';

/// Every request the app made, newest first.
class NetworkTab extends AppView {
  const NetworkTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(devLogProvider);
    return ListenableBuilder(
      listenable: log,
      builder: (context, _) => Column(
        children: [
          ListTile(
            dense: true,
            title: Text('${log.http.length} requests'),
            trailing: TextButton(
              onPressed: log.clear,
              child: const Text('Clear'),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: log.http.isEmpty
                ? const Center(child: Text('No requests yet'))
                : ListView.separated(
                    itemCount: log.http.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final entry = log.http[index];
                      final uri = Uri.parse(entry.url);
                      return ListTile(
                        dense: true,
                        leading: _StatusChip(entry),
                        title: Text(
                          '${entry.method} ${uri.path}',
                          style: monospace,
                        ),
                        subtitle: Text(
                          [
                            formatTime(entry.time),
                            if (entry.duration != null)
                              '${entry.duration!.inMilliseconds} ms',
                            if (uri.query.isNotEmpty) '?${uri.query}',
                          ].join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => _RequestDetails(entry),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip(this.entry);

  final HttpLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (entry) {
      HttpLogEntry(pending: true) => ('…', Colors.grey),
      HttpLogEntry(status: null) => ('ERR', Colors.red),
      HttpLogEntry(:final status?) when status >= 500 => (
        '$status',
        Colors.red,
      ),
      HttpLogEntry(:final status?) when status >= 400 => (
        '$status',
        Colors.orange,
      ),
      HttpLogEntry(:final status) => ('$status', Colors.green),
    };
    return Container(
      width: 44,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _RequestDetails extends StatelessWidget {
  const _RequestDetails(this.entry);

  final HttpLogEntry entry;

  @override
  Widget build(BuildContext context) {
    void copy(String text, String what) {
      Clipboard.setData(ClipboardData(text: text));
      showDevSnack(context, '$what copied');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${entry.method} ${entry.status ?? entry.error ?? '…'}'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          DevSection(
            title: 'Request',
            children: [
              DevInfoRow('URL', entry.url),
              DevInfoRow(
                'Headers',
                entry.requestHeaders.entries
                    .map((e) => '${e.key}: ${e.value}')
                    .join('\n'),
              ),
              if (entry.requestBody != null) _Body(entry.requestBody!),
            ],
          ),
          DevSection(
            title: 'Response',
            children: [
              DevInfoRow(
                'Status',
                entry.status?.toString() ?? entry.error ?? 'pending',
              ),
              if (entry.duration != null)
                DevInfoRow('Time', '${entry.duration!.inMilliseconds} ms'),
              if (entry.responseBody != null) _Body(entry.responseBody!),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () => copy(entry.url, 'URL'),
                  child: const Text('Copy URL'),
                ),
                if (entry.responseBody != null)
                  OutlinedButton(
                    onPressed: () => copy(entry.responseBody!, 'Response'),
                    child: const Text('Copy response'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
    ),
    child: SelectableText(text, style: monospace),
  );
}
