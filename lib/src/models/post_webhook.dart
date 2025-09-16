import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'webhook_event.dart';
import 'webhook_status.dart';

part 'post_webhook.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class PostWebhook extends Equatable {
  const PostWebhook({
    required this.eventType,
    required this.context,
    required this.contextId,
    required this.endpoint,
    required this.passcode,
    this.status,
    this.description,
  });

  factory PostWebhook.fromJson(Map<String, Object?> json) =>
      _$PostWebhookFromJson(json);

  @JsonKey(name: 'event_type')
  final WebhookEvent eventType;

  final String context;

  @JsonKey(name: 'context_id')
  final String contextId;

  final String endpoint;

  final String passcode;

  final WebhookStatus? status;

  final String? description;

  @override
  List<Object?> get props => <Object?>[
    eventType,
    context,
    contextId,
    endpoint,
    passcode,
    status,
    description,
  ];

  Map<String, Object?> toJson() => _$PostWebhookToJson(this);
}
