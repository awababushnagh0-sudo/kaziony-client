import 'dart:io';

import 'package:kernel/kernel.dart';
import 'package:offers_api/partner.dart';

import '../domain/product.dart';

class ApiProductRepository implements ProductRepository {
  ApiProductRepository(this._api);

  final Api _api;
  late final _products = _api.client(PartnerProductsClient.new);

  @override
  Future<Result<PageResult<Product>>> list(
    String storeId, {
    required int page,
    required int pageSize,
    String search = '',
    bool archived = false,
  }) async {
    final result = await _api.guard(
      () => _products.list(
        storeId: storeId,
        page: page,
        pageSize: pageSize,
        search: search.isEmpty ? null : search,
        archived: archived,
      ),
    );
    return result.map(
      (list) => PageResult(
        items: [for (final product in list.items) _toProduct(product)],
        total: list.meta.total.toInt(),
      ),
    );
  }

  @override
  Future<Result<Product>> get(String storeId, String productId) async {
    final result = await _api.guard(
      () => _products.getProduct(storeId: storeId, productId: productId),
    );
    return result.map(_toProduct);
  }

  @override
  Future<Result<Product>> create(String storeId, ProductDraft draft) async {
    final result = await _api.guard(
      () => _products.create(
        storeId: storeId,
        body: CreateProductDto(
          title: draft.title,
          description: draft.description,
          regularPrice: draft.regularPrice,
        ),
      ),
    );
    return result.map(_toProduct);
  }

  @override
  Future<Result<Product>> update(
    String storeId,
    String productId,
    ProductDraft draft,
  ) => _update(
    storeId,
    productId,
    UpdateProductDto(
      title: draft.title,
      // An empty value clears it on the server.
      description: draft.description ?? '',
      regularPrice: draft.regularPrice,
    ),
  );

  @override
  Future<Result<Product>> setArchived(
    String storeId,
    String productId, {
    required bool archived,
  }) => _update(storeId, productId, UpdateProductDto(isArchived: archived));

  @override
  Future<Result<Product>> setPhoto(
    String storeId,
    String productId,
    PreparedPhoto photo, {
    required void Function(double sent) onProgress,
  }) async {
    final result = await _api.upload(
      PartnerProductsClient.new,
      (products) => products.setImage(
        storeId: storeId,
        productId: productId,
        image: File(photo.fullPath),
        thumb: File(photo.thumbPath),
      ),
      onProgress: onProgress,
    );
    return result.map(_toProduct);
  }

  Future<Result<Product>> _update(
    String storeId,
    String productId,
    UpdateProductDto body,
  ) async {
    final result = await _api.guard(
      () =>
          _products.update(storeId: storeId, productId: productId, body: body),
    );
    return result.map(_toProduct);
  }
}

Product _toProduct(ProductDto dto) => Product(
  id: dto.id,
  title: dto.title,
  description: dto.description,
  regularPrice: dto.regularPrice,
  imageUrl: dto.imageUrl,
  thumbUrl: dto.thumbUrl,
  isArchived: dto.isArchived,
);
