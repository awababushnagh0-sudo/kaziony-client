// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'clients/auth_client.dart';
import 'clients/health_client.dart';
import 'clients/app_config_client.dart';
import 'clients/categories_client.dart';
import 'clients/admin_categories_client.dart';
import 'clients/stores_client.dart';
import 'clients/business_store_client.dart';
import 'clients/admin_stores_client.dart';
import 'clients/offers_client.dart';
import 'clients/business_offers_client.dart';
import 'clients/admin_offers_client.dart';
import 'clients/admin_locations_client.dart';
import 'clients/admin_users_client.dart';
import 'clients/business_products_client.dart';
import 'clients/claims_client.dart';
import 'clients/business_claims_client.dart';
import 'clients/admin_stats_client.dart';

/// Offers API `v1.0`.
///
/// Backend for the customer app, business app and admin dashboard.
class OffersApi {
  OffersApi(
    Dio dio, {
    String? baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static String get version => '1.0';

  AuthClient? _auth;
  HealthClient? _health;
  AppConfigClient? _appConfig;
  CategoriesClient? _categories;
  AdminCategoriesClient? _adminCategories;
  StoresClient? _stores;
  BusinessStoreClient? _businessStore;
  AdminStoresClient? _adminStores;
  OffersClient? _offers;
  BusinessOffersClient? _businessOffers;
  AdminOffersClient? _adminOffers;
  AdminLocationsClient? _adminLocations;
  AdminUsersClient? _adminUsers;
  BusinessProductsClient? _businessProducts;
  ClaimsClient? _claims;
  BusinessClaimsClient? _businessClaims;
  AdminStatsClient? _adminStats;

  AuthClient get auth => _auth ??= AuthClient(_dio, baseUrl: _baseUrl);

  HealthClient get health => _health ??= HealthClient(_dio, baseUrl: _baseUrl);

  AppConfigClient get appConfig => _appConfig ??= AppConfigClient(_dio, baseUrl: _baseUrl);

  CategoriesClient get categories => _categories ??= CategoriesClient(_dio, baseUrl: _baseUrl);

  AdminCategoriesClient get adminCategories => _adminCategories ??= AdminCategoriesClient(_dio, baseUrl: _baseUrl);

  StoresClient get stores => _stores ??= StoresClient(_dio, baseUrl: _baseUrl);

  BusinessStoreClient get businessStore => _businessStore ??= BusinessStoreClient(_dio, baseUrl: _baseUrl);

  AdminStoresClient get adminStores => _adminStores ??= AdminStoresClient(_dio, baseUrl: _baseUrl);

  OffersClient get offers => _offers ??= OffersClient(_dio, baseUrl: _baseUrl);

  BusinessOffersClient get businessOffers => _businessOffers ??= BusinessOffersClient(_dio, baseUrl: _baseUrl);

  AdminOffersClient get adminOffers => _adminOffers ??= AdminOffersClient(_dio, baseUrl: _baseUrl);

  AdminLocationsClient get adminLocations => _adminLocations ??= AdminLocationsClient(_dio, baseUrl: _baseUrl);

  AdminUsersClient get adminUsers => _adminUsers ??= AdminUsersClient(_dio, baseUrl: _baseUrl);

  BusinessProductsClient get businessProducts => _businessProducts ??= BusinessProductsClient(_dio, baseUrl: _baseUrl);

  ClaimsClient get claims => _claims ??= ClaimsClient(_dio, baseUrl: _baseUrl);

  BusinessClaimsClient get businessClaims => _businessClaims ??= BusinessClaimsClient(_dio, baseUrl: _baseUrl);

  AdminStatsClient get adminStats => _adminStats ??= AdminStatsClient(_dio, baseUrl: _baseUrl);
}
