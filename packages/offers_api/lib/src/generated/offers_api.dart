// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'clients/auth_client.dart';
import 'clients/health_client.dart';
import 'clients/app_config_client.dart';
import 'clients/admin_settings_client.dart';
import 'clients/admin_service_areas_client.dart';
import 'clients/categories_client.dart';
import 'clients/admin_categories_client.dart';
import 'clients/stores_client.dart';
import 'clients/partner_store_client.dart';
import 'clients/admin_stores_client.dart';
import 'clients/offers_client.dart';
import 'clients/partner_offers_client.dart';
import 'clients/admin_offers_client.dart';
import 'clients/admin_search_client.dart';
import 'clients/admin_system_client.dart';
import 'clients/admin_locations_client.dart';
import 'clients/places_client.dart';
import 'clients/admin_users_client.dart';
import 'clients/admin_audit_log_client.dart';
import 'clients/partner_products_client.dart';
import 'clients/claims_client.dart';
import 'clients/partner_claims_client.dart';
import 'clients/admin_reports_client.dart';
import 'clients/admin_customers_client.dart';
import 'clients/notifications_client.dart';
import 'clients/admin_stats_client.dart';

/// Offers API `v1.0`.
///
/// Backend for the customer app, partner app and admin dashboard.
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
  AdminSettingsClient? _adminSettings;
  AdminServiceAreasClient? _adminServiceAreas;
  CategoriesClient? _categories;
  AdminCategoriesClient? _adminCategories;
  StoresClient? _stores;
  PartnerStoreClient? _partnerStore;
  AdminStoresClient? _adminStores;
  OffersClient? _offers;
  PartnerOffersClient? _partnerOffers;
  AdminOffersClient? _adminOffers;
  AdminSearchClient? _adminSearch;
  AdminSystemClient? _adminSystem;
  AdminLocationsClient? _adminLocations;
  PlacesClient? _places;
  AdminUsersClient? _adminUsers;
  AdminAuditLogClient? _adminAuditLog;
  PartnerProductsClient? _partnerProducts;
  ClaimsClient? _claims;
  PartnerClaimsClient? _partnerClaims;
  AdminReportsClient? _adminReports;
  AdminCustomersClient? _adminCustomers;
  NotificationsClient? _notifications;
  AdminStatsClient? _adminStats;

  AuthClient get auth => _auth ??= AuthClient(_dio, baseUrl: _baseUrl);

  HealthClient get health => _health ??= HealthClient(_dio, baseUrl: _baseUrl);

  AppConfigClient get appConfig => _appConfig ??= AppConfigClient(_dio, baseUrl: _baseUrl);

  AdminSettingsClient get adminSettings => _adminSettings ??= AdminSettingsClient(_dio, baseUrl: _baseUrl);

  AdminServiceAreasClient get adminServiceAreas => _adminServiceAreas ??= AdminServiceAreasClient(_dio, baseUrl: _baseUrl);

  CategoriesClient get categories => _categories ??= CategoriesClient(_dio, baseUrl: _baseUrl);

  AdminCategoriesClient get adminCategories => _adminCategories ??= AdminCategoriesClient(_dio, baseUrl: _baseUrl);

  StoresClient get stores => _stores ??= StoresClient(_dio, baseUrl: _baseUrl);

  PartnerStoreClient get partnerStore => _partnerStore ??= PartnerStoreClient(_dio, baseUrl: _baseUrl);

  AdminStoresClient get adminStores => _adminStores ??= AdminStoresClient(_dio, baseUrl: _baseUrl);

  OffersClient get offers => _offers ??= OffersClient(_dio, baseUrl: _baseUrl);

  PartnerOffersClient get partnerOffers => _partnerOffers ??= PartnerOffersClient(_dio, baseUrl: _baseUrl);

  AdminOffersClient get adminOffers => _adminOffers ??= AdminOffersClient(_dio, baseUrl: _baseUrl);

  AdminSearchClient get adminSearch => _adminSearch ??= AdminSearchClient(_dio, baseUrl: _baseUrl);

  AdminSystemClient get adminSystem => _adminSystem ??= AdminSystemClient(_dio, baseUrl: _baseUrl);

  AdminLocationsClient get adminLocations => _adminLocations ??= AdminLocationsClient(_dio, baseUrl: _baseUrl);

  PlacesClient get places => _places ??= PlacesClient(_dio, baseUrl: _baseUrl);

  AdminUsersClient get adminUsers => _adminUsers ??= AdminUsersClient(_dio, baseUrl: _baseUrl);

  AdminAuditLogClient get adminAuditLog => _adminAuditLog ??= AdminAuditLogClient(_dio, baseUrl: _baseUrl);

  PartnerProductsClient get partnerProducts => _partnerProducts ??= PartnerProductsClient(_dio, baseUrl: _baseUrl);

  ClaimsClient get claims => _claims ??= ClaimsClient(_dio, baseUrl: _baseUrl);

  PartnerClaimsClient get partnerClaims => _partnerClaims ??= PartnerClaimsClient(_dio, baseUrl: _baseUrl);

  AdminReportsClient get adminReports => _adminReports ??= AdminReportsClient(_dio, baseUrl: _baseUrl);

  AdminCustomersClient get adminCustomers => _adminCustomers ??= AdminCustomersClient(_dio, baseUrl: _baseUrl);

  NotificationsClient get notifications => _notifications ??= NotificationsClient(_dio, baseUrl: _baseUrl);

  AdminStatsClient get adminStats => _adminStats ??= AdminStatsClient(_dio, baseUrl: _baseUrl);
}
