import 'package:kernel/kernel.dart';

/// Something the store sells, saved once so offers can be posted from it
/// in seconds.
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.regularPrice,
    required this.imageUrl,
    required this.thumbUrl,
    required this.isArchived,
  });

  final String id;
  final String title;
  final String? description;

  /// LD with 3 decimals ("8.000"), shown with `formatPrice`.
  final String regularPrice;
  final String? imageUrl;
  final String? thumbUrl;

  /// Hidden from the list; its past offers stay.
  final bool isArchived;
}

/// What the owner types to add or edit a product.
class ProductDraft {
  const ProductDraft({
    required this.title,
    required this.description,
    required this.regularPrice,
  });

  final String title;
  final String? description;

  /// As the backend takes it: `parsePrice` of what was typed.
  final String regularPrice;
}

/// Owners only: the API refuses staff.
abstract interface class ProductRepository {
  Future<Result<PageResult<Product>>> list(
    String storeId, {
    required int page,
    required int pageSize,
    String search = '',
    bool archived = false,
  });

  Future<Result<Product>> get(String storeId, String productId);

  Future<Result<Product>> create(String storeId, ProductDraft draft);

  Future<Result<Product>> update(
    String storeId,
    String productId,
    ProductDraft draft,
  );

  Future<Result<Product>> setArchived(
    String storeId,
    String productId, {
    required bool archived,
  });

  /// Uploads the product's photo; [onProgress] gets the share sent, from 0
  /// to 1.
  Future<Result<Product>> setPhoto(
    String storeId,
    String productId,
    PreparedPhoto photo, {
    required void Function(double sent) onProgress,
  });
}

/// Wired to the real implementation in `core/providers/dependencies.dart`.
final productRepositoryProvider = Provider<ProductRepository>(
  (ref) =>
      throw UnimplementedError('Provided by core/providers/dependencies.dart'),
);
