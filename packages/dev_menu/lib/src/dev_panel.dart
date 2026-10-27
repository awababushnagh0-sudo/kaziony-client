import 'package:flutter/material.dart';
import 'package:kernel/kernel.dart';

import 'tabs/logs_tab.dart';
import 'tabs/network_tab.dart';
import 'tabs/overview_tab.dart';
import 'tabs/server_tab.dart';

/// The full-screen dev menu. Always English and left to right.
/// Has its own Navigator so detail pages and text fields work inside it.
class DevPanel extends StatelessWidget {
  const DevPanel({required this.onClose, super.key});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.ltr,
    // The app's navigator owns the hero controller; this one gets none.
    child: HeroControllerScope.none(
      child: Navigator(
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (_) => DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Dev menu · ${appEnv.name.toUpperCase()}'),
                centerTitle: false,
                actions: [
                  IconButton(
                    tooltip: 'Close',
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                  ),
                ],
                bottom: const TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: [
                    Tab(text: 'Overview'),
                    Tab(text: 'Network'),
                    Tab(text: 'Logs'),
                    Tab(text: 'Server'),
                  ],
                ),
              ),
              body: const TabBarView(
                children: [OverviewTab(), NetworkTab(), LogsTab(), ServerTab()],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Small helpers shared by the tabs.
void showDevSnack(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));

class DevSection extends StatelessWidget {
  const DevSection({required this.title, required this.children, super.key});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...children,
      ],
    ),
  );
}

class DevInfoRow extends StatelessWidget {
  const DevInfoRow(this.label, this.value, {super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    title: Text(label),
    subtitle: SelectableText(
      value,
      style: const TextStyle(fontFamily: 'monospace'),
    ),
  );
}

const monospace = TextStyle(fontFamily: 'monospace', fontSize: 12);

String clockTime(DateTime time) =>
    '${time.hour.toString().padLeft(2, '0')}:'
    '${time.minute.toString().padLeft(2, '0')}:'
    '${time.second.toString().padLeft(2, '0')}';
