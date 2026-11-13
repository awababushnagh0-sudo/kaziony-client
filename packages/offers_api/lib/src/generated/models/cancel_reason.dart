// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

/// Who cancelled it, when CANCELLED: anything but CUSTOMER wasn't the.
/// customer's doing, and doesn't count against them.
@JsonEnum()
enum CancelReason {
  @JsonValue('CUSTOMER')
  customer('CUSTOMER'),
  @JsonValue('OFFER_REMOVED')
  offerRemoved('OFFER_REMOVED'),
  @JsonValue('STORE_OFF')
  storeOff('STORE_OFF'),
  @JsonValue('NOT_DELIVERED')
  notDelivered('NOT_DELIVERED'),
  @JsonValue('STORE_CLOSED')
  storeClosed('STORE_CLOSED'),
  @JsonValue('HOURS_CHANGED')
  hoursChanged('HOURS_CHANGED'),
  @JsonValue('ACCOUNT_DISABLED')
  accountDisabled('ACCOUNT_DISABLED'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const CancelReason(this.json);

  factory CancelReason.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
  String toJson() {
    final value = json;
    if (value == null) {
      throw StateError('Cannot convert enum value with null JSON representation to String. '
          'This usually happens for \$unknown or @JsonValue(null) entries.');
    }
    return value as String;
  }

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<CancelReason> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
