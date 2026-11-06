import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

/// A part of a page that opens on a photo (an offer's, a store's), under
/// its [title], set off from the part above by a line. [child] runs to the
/// screen's edges: rows (`SListTile`) keep their own room at the sides,
/// other content pads itself.
class PageSection extends StatelessWidget {
  const PageSection({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Gap(Space.lg),
      const SDivider(),
      Padding(
        padding: const EdgeInsets.fromLTRB(
          Space.lg,
          Space.lg,
          Space.lg,
          Space.sm,
        ),
        child: SSectionHeader(title),
      ),
      child,
    ],
  );
}
