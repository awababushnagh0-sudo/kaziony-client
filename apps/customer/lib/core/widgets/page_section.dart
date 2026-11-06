import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

/// A part of a page that opens on a photo (an offer's, a store's), under
/// its [title], set off from the part above by a gray band. [trailing]
/// sits at the title's end (how its offers are shown). [child] runs to the
/// screen's edges: rows (`SListTile`) keep their own room at the sides,
/// other content pads itself.
class PageSection extends StatelessWidget {
  const PageSection({
    required this.title,
    required this.child,
    this.trailing,
    super.key,
  });

  final String title;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final trailing = this.trailing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Gap(Space.lg),
        const SDivider.band(),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Space.lg,
            Space.lg,
            Space.lg,
            Space.md,
          ),
          child: trailing == null
              ? SSectionHeader(title)
              : Row(
                  spacing: Space.md,
                  children: [
                    Expanded(child: SSectionHeader(title)),
                    trailing,
                  ],
                ),
        ),
        child,
      ],
    );
  }
}
