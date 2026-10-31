import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../domain/product.dart';
import 'product_view_model.dart';

/// One product, like an offer's page: its photo, name, regular price and
/// description, with posting an offer from it first. Editing is a page of
/// its own.
class ProductScreen extends AppView {
  const ProductScreen({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productViewModel(productId));
    final shown = product.value;
    return SScaffold(
      // Loaded, the page opens on the product's photo, with its own back
      // button; loading or failing, it keeps the app bar's.
      showAppBar: shown == null,
      underStatusBar: shown != null,
      padded: shown == null,
      bottom: shown == null ? null : _Action(product: shown),
      body: SAsyncView(
        value: product,
        onRetry: () => ref.invalidate(productViewModel(productId)),
        builder: (context, product) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(product: product),
              Padding(
                padding: const EdgeInsets.all(Space.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: Space.xl,
                  children: [
                    if (product.thumbUrl == null && !product.isArchived)
                      _PhotoTip(product: product),
                    _About(product: product),
                    _Details(product: product),
                    if (!product.isArchived) _Archive(product: product),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    return SDealHeader(
      imageUrl: product.imageUrl ?? product.thumbUrl,
      title: product.title,
      price: formatPrice(
        product.regularPrice,
        languageCode: Localizations.localeOf(context).languageCode,
      ),
      status: product.isArchived
          ? DealStatus(label: s.archivedStatus, tone: BadgeTone.neutral)
          : null,
      onBack: context.pop,
      action: DealAction(
        icon: SIcons.edit,
        tooltip: s.edit,
        onPressed: () => context.push(Routes.editProduct(product.id)),
      ),
    );
  }
}

/// Archives or restores the product, and says how it went.
Future<void> _setArchived(
  BuildContext context,
  WidgetRef ref,
  Product product,
) async {
  final s = PartnerLocalizations.of(context);
  final archived = !product.isArchived;
  final failure = await ref
      .read(productViewModel(product.id).notifier)
      .setArchived(archived: archived);
  if (!context.mounted) return;
  if (failure == null) {
    SSnack.success(context, archived ? s.productArchived : s.productRestored);
  } else {
    SSnack.error(context, failureMessage(context, failure));
  }
}

/// No photo yet: a nudge to add one, as it's the first thing customers
/// see on its offers.
class _PhotoTip extends StatelessWidget {
  const _PhotoTip({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    return SListGroup(
      children: [
        SListTile(
          icon: SIcons.camera,
          title: s.productPhotoTipTitle,
          subtitle: s.productPhotoTipMessage,
          onTap: () => context.push(Routes.editProduct(product.id)),
        ),
      ],
    );
  }
}

/// What the product is, as customers read it on its offers.
class _About extends StatelessWidget {
  const _About({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final description = product.description;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.sm,
      children: [
        SSectionHeader(
          s.descriptionLabel,
          actionLabel: description == null ? s.add : s.edit,
          onAction: () => context.push(Routes.editProduct(product.id)),
        ),
        if (description == null)
          SText(s.noDescription, color: SColor.textSubtle)
        else
          SText(description),
      ],
    );
  }
}

/// Its regular price, and when it was added and last changed.
class _Details extends StatelessWidget {
  const _Details({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.sm,
      children: [
        SSectionHeader(s.productDetailsTitle),
        SListGroup(
          children: [
            SFactTile(
              label: s.regularPriceLabel,
              value: formatPrice(product.regularPrice, languageCode: language),
            ),
            SFactTile(
              label: s.productAddedOn,
              value: formatDate(product.createdAt, languageCode: language),
            ),
            SFactTile(
              label: s.productEditedOn,
              value: formatDate(product.updatedAt, languageCode: language),
            ),
          ],
        ),
      ],
    );
  }
}

/// Archiving only hides it from the list, so it's a quiet row at the end,
/// saying what it does.
class _Archive extends AppView {
  const _Archive({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    return SListGroup(
      children: [
        SListTile(
          icon: SIcons.archive,
          title: s.archiveProduct,
          subtitle: s.archiveProductHint,
          onTap: () => _setArchived(context, ref, product),
        ),
      ],
    );
  }
}

/// What the product is for: posting an offer from it; or, archived,
/// bringing it back first.
class _Action extends AppView {
  const _Action({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    if (product.isArchived) {
      return SButton(
        label: s.restoreProduct,
        icon: SIcons.restore,
        expand: true,
        onPressed: () => _setArchived(context, ref, product),
      );
    }
    return SButton(
      label: s.postOffer,
      icon: SIcons.offers,
      expand: true,
      onPressed: () => context.push(Routes.newOffer(product.id)),
    );
  }
}
