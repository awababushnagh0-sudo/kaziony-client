// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/resolve_location_dto.dart';
import '../models/resolved_location_dto.dart';

part 'admin_locations_client.g.dart';

@RestApi()
abstract class AdminLocationsClient {
  factory AdminLocationsClient(Dio dio, {String? baseUrl}) = _AdminLocationsClient;

  /// Read the point in a Google Maps link or coordinates.
  ///
  /// Short links (maps.app.goo.gl) are followed to the map. 400 with error "UnreadableLocation" or "LocationOutsideLibya" otherwise.
  @POST('/api/v1/admin/locations/resolve')
  Future<ResolvedLocationDto> resolve({
    @Body() required ResolveLocationDto body,
  });
}
