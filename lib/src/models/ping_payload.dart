import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'webhook_event.dart';
import 'webhook_payload.dart';

part 'ping_payload.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
@immutable
class PingPayload extends WebhookPayload {
  const PingPayload({
    required super.passcode,
    required super.timestamp,
    required super.webhookId,
  });

  factory PingPayload.fromJson(Map<String, Object?> json) =>
      _$PingPayloadFromJson(json);

  @override
  WebhookEvent get eventType => WebhookEvent.ping;

  @override
  List<Object?> get props => <Object?>[...super.props, eventType];

  @override
  Map<String, Object?> toJson() => _$PingPayloadToJson(this);
}
