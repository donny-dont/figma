import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'webhook_event.dart';

part 'webhook_payload.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
abstract class WebhookPayload extends Equatable {
  const WebhookPayload({
    required this.passcode,
    required this.timestamp,
    required this.webhookId,
  });

  factory WebhookPayload.fromJson(Map<String, Object?> json) =>
      _$WebhookPayloadFromJson(json);

  /// The passcode specified when the webhook was created, should match what was initially provided
  final String passcode;

  /// UTC ISO 8601 timestamp of when the event was triggered.
  final DateTime timestamp;

  /// The id of the webhook that caused the callback
  @JsonKey(name: 'webhook_id')
  final String webhookId;

  /// Discriminator for [WebhookPayload] types.
  WebhookEvent get eventType;
  @override
  List<Object?> get props => <Object?>[passcode, timestamp, webhookId];

  Map<String, Object?> toJson() => _$WebhookPayloadToJson(this);
}
