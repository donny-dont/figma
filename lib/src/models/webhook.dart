import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'webhook_event.dart';
import 'webhook_status.dart';

part 'webhook.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class Webhook extends Equatable {
  const Webhook({
    required this.id,
    required this.eventType,
    required this.context,
    required this.contextId,
    required this.planApiId,
    required this.status,
    this.clientId,
    required this.passcode,
    required this.endpoint,
    this.description,
  });

  factory Webhook.fromJson(Map<String, Object?> json) =>
      _$WebhookFromJson(json);

  final String id;

  @JsonKey(name: 'event_type')
  final WebhookEvent eventType;

  final String context;

  @JsonKey(name: 'context_id')
  final String contextId;

  @JsonKey(name: 'plan_api_id')
  final String planApiId;

  final WebhookStatus status;

  @JsonKey(name: 'client_id')
  final String? clientId;

  final String passcode;

  final String endpoint;

  final String? description;

  @override
  List<Object?> get props => <Object?>[
    id,
    eventType,
    context,
    contextId,
    planApiId,
    status,
    clientId,
    passcode,
    endpoint,
    description,
  ];

  Map<String, Object?> toJson() => _$WebhookToJson(this);
}
