import 'package:json_annotation/json_annotation.dart';

enum NoiseEffectNoiseType {
  @JsonValue('MONOTONE')
  monotone,
  @JsonValue('MULTITONE')
  multitone,
  @JsonValue('DUOTONE')
  duotone,
}
