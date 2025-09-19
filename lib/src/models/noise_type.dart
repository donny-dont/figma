import 'package:json_annotation/json_annotation.dart';

enum NoiseType {
  @JsonValue('MONOTONE')
  monotone,
  @JsonValue('MULTITONE')
  multitone,
  @JsonValue('DUOTONE')
  duotone,
}
