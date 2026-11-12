// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/notification_list_dto.dart';
import '../models/unread_notifications_dto.dart';

part 'notifications_client.g.dart';

@RestApi()
abstract class NotificationsClient {
  factory NotificationsClient(Dio dio, {String? baseUrl}) = _NotificationsClient;

  /// My notifications, newest first.
  ///
  /// Things the app tells me, such as a booking cancelled by the store or our team. Each has a `kind` for the app to word it.
  @GET('/api/v1/me/notifications')
  Future<NotificationListDto> list({
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
  });

  /// How many I haven't seen
  @GET('/api/v1/me/notifications/unread')
  Future<UnreadNotificationsDto> unread();

  /// Mark them all seen, once the inbox is open
  @POST('/api/v1/me/notifications/read')
  Future<void> markAllRead();
}
