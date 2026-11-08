// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_saved_place_dto.dart';
import '../models/saved_place_dto.dart';
import '../models/update_saved_place_dto.dart';

part 'places_client.g.dart';

@RestApi()
abstract class PlacesClient {
  factory PlacesClient(Dio dio, {String? baseUrl}) = _PlacesClient;

  /// My saved places, oldest first
  @GET('/api/v1/me/places')
  Future<List<SavedPlaceDto>> list();

  /// Save a place to browse from.
  ///
  /// Up to 10 places: 409 with error "TooManyPlaces". Inside a service area: 400 with error "OutsideServiceArea".
  @POST('/api/v1/me/places')
  Future<SavedPlaceDto> create({
    @Body() required CreateSavedPlaceDto body,
  });

  /// Change a saved place's name, note or point
  @PATCH('/api/v1/me/places/{placeId}')
  Future<SavedPlaceDto> update({
    @Path('placeId') required String placeId,
    @Body() required UpdateSavedPlaceDto body,
  });

  /// Delete a saved place
  @DELETE('/api/v1/me/places/{placeId}')
  Future<void> remove({
    @Path('placeId') required String placeId,
  });
}
