import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'webhook_event.dart';
import 'webhook_status.dart';

part 'put_webhook.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class PutWebhook extends Equatable {
  const PutWebhook({
    required this.eventType,
    required this.endpoint,
    required this.passcode,
    this.status,
    this.description,
  });

  factory PutWebhook.fromJson(Map<String, Object?> json) =>
      _$PutWebhookFromJson(json);

  @JsonKey(name: 'event_type')
  final WebhookEvent eventType;

  final String endpoint;

  final String passcode;

  final WebhookStatus? status;

  final String? description;

  @override
  List<Object?> get props => <Object?>[
    eventType,
    endpoint,
    passcode,
    status,
    description,
  ];

  Map<String, Object?> toJson() => _$PutWebhookToJson(this);
}
