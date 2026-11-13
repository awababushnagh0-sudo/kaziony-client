// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/admin_customer_booking_list_dto.dart';
import '../models/admin_customer_details_dto.dart';
import '../models/admin_customer_list_dto.dart';
import '../models/claim_status.dart';
import '../models/customer_standing.dart';

part 'admin_customers_client.g.dart';

@RestApi()
abstract class AdminCustomersClient {
  factory AdminCustomersClient(Dio dio, {String? baseUrl}) = _AdminCustomersClient;

  /// List and search customers, the newest first.
  ///
  /// Search by name, email, or phone in any format; filter by where they stand (booking, paused, disabled, deleted).
  ///
  /// [search] - Name, email, or phone in any format.
  @GET('/api/v1/admin/customers')
  Future<AdminCustomerListDto> list({
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
    @Query('standing') CustomerStanding? standing,
    @Query('search') String? search,
  });

  /// One customer: where they stand, their strikes and bookings
  @GET('/api/v1/admin/customers/{id}')
  Future<AdminCustomerDetailsDto> getCustomer({
    @Path('id') required String id,
  });

  /// A customer's bookings, the latest first.
  ///
  /// [status] - RESERVED is only those still in time; EXPIRED includes the rest.
  @GET('/api/v1/admin/customers/{id}/bookings')
  Future<AdminCustomerBookingListDto> bookings({
    @Path('id') required String id,
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
    @Query('status') ClaimStatus? status,
  });

  /// End a customer's pause now.
  ///
  /// 409 NotPaused when they aren't paused. Ended, not cleared: strikes from before stop counting, and a pause soon after is longer.
  @POST('/api/v1/admin/customers/{id}/end-pause')
  Future<AdminCustomerDetailsDto> endPause({
    @Path('id') required String id,
  });

  /// Take back one of a customer's strikes.
  ///
  /// It stops counting and their missed pickups go down by one. A pause it led to stays until ended on its own.
  @DELETE('/api/v1/admin/customers/{id}/strikes/{strikeId}')
  Future<AdminCustomerDetailsDto> takeBackStrike({
    @Path('id') required String id,
    @Path('strikeId') required String strikeId,
  });
}
