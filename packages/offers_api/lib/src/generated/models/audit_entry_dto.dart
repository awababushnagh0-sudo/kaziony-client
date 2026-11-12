// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'audit_actor_dto.dart';
import 'audit_change_dto.dart';

part 'audit_entry_dto.g.dart';

@JsonSerializable()
class AuditEntryDto {
  const AuditEntryDto({
    required this.id,
    required this.action,
    required this.actor,
    required this.targetId,
    required this.targetLabel,
    required this.changes,
    required this.requestId,
    required this.createdAt,
  });
  
  factory AuditEntryDto.fromJson(Map<String, Object?> json) => _$AuditEntryDtoFromJson(json);
  
  final String id;

  /// What was done, as `area.verb`: store.create, store.update, store.delete,.
  /// store.addLocation, store.setImage, store.removeImage,.
  /// store.cancelBookings, store.addMember,.
  /// store.removeMember, user.create, user.update, user.setStatus,.
  /// user.resetPassword, category.create, category.update,.
  /// serviceArea.create, serviceArea.update, serviceArea.delete,.
  /// settings.update, offer.remove, job.run. More may be added later.
  final String action;

  /// Null only if the account was removed from the database since.
  final AuditActorDto? actor;

  /// The store, user, offer, category or service area it was done to.
  final String? targetId;

  /// Its name at the time (a job's name for job.run).
  final String? targetLabel;

  /// What was sent, without passwords.
  final List<AuditChangeDto> changes;

  /// To find the request in the logs.
  final String? requestId;
  final DateTime createdAt;

  Map<String, Object?> toJson() => _$AuditEntryDtoToJson(this);
}
