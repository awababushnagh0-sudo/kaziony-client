import 'package:kernel/kernel.dart';
import 'package:offers_api/admin.dart';

import '../domain/store.dart';

class ApiStoreRepository implements StoreRepository {
  ApiStoreRepository(this._api);

  final Api _api;
  late final _stores = _api.client(AdminStoresClient.new);
  late final _categories = _api.client(AdminCategoriesClient.new);

  @override
  Future<Result<StorePage>> list(StoreQuery query) async {
    final result = await _api.guard(
      () => _stores.list(
        page: query.page,
        pageSize: query.pageSize,
        search: query.search.isEmpty ? null : query.search,
        isActive: switch (query.filter) {
          null => null,
          StoreStatus.active => true,
          StoreStatus.disabled => false,
        },
      ),
    );
    return result.map(
      (dto) => StorePage(
        total: dto.meta.total.toInt(),
        items: [
          for (final store in dto.items)
            StoreSummary(
              id: store.id,
              name: store.name,
              category: _toCategory(store.category),
              branchCount: store.branchCount.toInt(),
              isActive: store.isActive,
              createdAt: store.createdAt,
            ),
        ],
      ),
    );
  }

  @override
  Future<Result<StoreDetails>> get(String id) async {
    final result = await _api.guard(() => _stores.getStore(id: id));
    return result.map(
      (dto) => StoreDetails(
        id: dto.id,
        name: dto.name,
        category: _toCategory(dto.category),
        isActive: dto.isActive,
        createdAt: dto.createdAt,
        branchCount: dto.branches.length,
        teamCount: dto.members.length,
        description: dto.description,
        logoUrl: dto.logoUrl,
        phone: dto.phone,
        facebookUrl: dto.facebookUrl,
        instagramUrl: dto.instagramUrl,
      ),
    );
  }

  @override
  Future<Result<List<Category>>> categories() async {
    final result = await _api.guard(_categories.list);
    return result.map(
      (list) => [
        for (final category in list)
          if (category.isActive) _toCategory(category),
      ],
    );
  }

  @override
  Future<Result<CreatedStore>> create(NewStore store) async {
    final branch = store.branch;
    final result = await _api.guard(
      () => _stores.create(
        body: CreateStoreDto(
          name: store.name,
          categoryId: store.categoryId,
          phone: store.phone,
          description: store.description,
          branches: [
            CreateBranchDto(
              name: branch.name,
              city: branch.city,
              area: branch.area,
              address: branch.address,
              latitude: branch.latitude,
              longitude: branch.longitude,
            ),
          ],
          owner: NewMerchantDto(name: store.ownerName, phone: store.ownerPhone),
        ),
      ),
    );
    return result.map(
      (dto) => CreatedStore(
        storeId: dto.store.id,
        storeName: dto.store.name,
        ownerPhone: dto.owner.phone,
        temporaryPassword: dto.owner.temporaryPassword,
      ),
    );
  }
}

Category _toCategory(CategoryDto dto) =>
    Category(id: dto.id, nameAr: dto.nameAr, nameEn: dto.nameEn);
