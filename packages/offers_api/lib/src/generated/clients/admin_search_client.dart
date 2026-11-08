// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/search_term_list_dto.dart';

part 'admin_search_client.g.dart';

@RestApi()
abstract class AdminSearchClient {
  factory AdminSearchClient(Dio dio, {String? baseUrl}) = _AdminSearchClient;

  /// What customers search for, the most searched first.
  ///
  /// Counted by the words, never by who. `nothingFound` lists the words that found no offer: the ones the search should learn.
  ///
  /// [search] - Only searches with these words, spelled any way.
  ///
  /// [nothingFound] - Only what found no offer the last time it was searched (`true`), or.
  /// only what found some (`false`).
  @GET('/api/v1/admin/search-terms')
  Future<SearchTermListDto> list({
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
    @Query('search') String? search,
    @Query('nothingFound') bool? nothingFound,
  });
}
