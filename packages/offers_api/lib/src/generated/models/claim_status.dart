// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

/// EXPIRED as soon as expiresAt passes, even before the cleanup job runs.
@JsonEnum()
enum ClaimStatus {
  @JsonValue('RESERVED')
  reserved('RESERVED'),
  @JsonValue('REDEEMED')
  redeemed('REDEEMED'),
  @JsonValue('EXPIRED')
  expired('EXPIRED'),
  @JsonValue('CANCELLED')
  cancelled('CANCELLED'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const ClaimStatus(this.json);

  factory ClaimStatus.fromJson(String json) => values.firstWhere(
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
  static List<ClaimStatus> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
