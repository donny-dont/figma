import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'webhook_event.dart';
import 'webhook_status.dart';

part 'webhook.g.dart';

/// A description of an HTTP webhook (from Figma back to your application)
@JsonSerializable(explicitToJson: true)
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

  /// The ID of the webhook
  final String id;

  /// The event this webhook triggers on
  @JsonKey(name: 'event_type')
  final WebhookEvent eventType;

  /// The type of context this webhook is attached to. The value will be "PROJECT", "TEAM", or "FILE"
  final String context;

  /// The ID of the context this webhook is attached to
  @JsonKey(name: 'context_id')
  final String contextId;

  /// The plan API ID of the team or organization where this webhook was created
  @JsonKey(name: 'plan_api_id')
  final String planApiId;

  /// The current status of the webhook
  final WebhookStatus status;

  /// The client ID of the OAuth application that registered this webhook, if any
  @JsonKey(name: 'client_id')
  final String? clientId;

  /// The passcode that will be passed back to the webhook endpoint. For security, when using the GET endpoints, the value is an empty string
  final String passcode;

  /// The endpoint that will be hit when the webhook is triggered
  final String endpoint;

  /// Optional user-provided description or name for the webhook. This is provided to help make maintaining a number of webhooks more convenient. Max length 140 characters.
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
