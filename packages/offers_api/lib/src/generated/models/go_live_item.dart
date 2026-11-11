// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

/// What the store still needs before it can be turned on, in this order.
/// (none when it's ready). A live store can't lose them either.
@JsonEnum()
enum GoLiveItem {
  @JsonValue('LOGO')
  logo('LOGO'),
  @JsonValue('PICKUP_INSTRUCTIONS')
  pickupInstructions('PICKUP_INSTRUCTIONS'),
  @JsonValue('OPENING_HOURS')
  openingHours('OPENING_HOURS'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const GoLiveItem(this.json);

  factory GoLiveItem.fromJson(String json) => values.firstWhere(
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
  static List<GoLiveItem> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
