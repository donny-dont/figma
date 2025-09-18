import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'webhook_event.dart';

part 'ping_payload.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
@immutable
class PingPayload extends Equatable {
  const PingPayload({required this.eventType});

  factory PingPayload.fromJson(Map<String, Object?> json) =>
      _$PingPayloadFromJson(json);

  @JsonKey(name: 'event_type')
  final WebhookEvent eventType;

  @override
  List<Object?> get props => <Object?>[eventType];

  Map<String, Object?> toJson() => _$PingPayloadToJson(this);
}
