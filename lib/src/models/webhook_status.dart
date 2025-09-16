import 'package:json_annotation/json_annotation.dart';

enum WebhookStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('PAUSED')
  paused,
}
