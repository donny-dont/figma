import 'package:json_annotation/json_annotation.dart';

enum StyleType {
  @JsonValue('FILL')
  fill,
  @JsonValue('TEXT')
  text,
  @JsonValue('EFFECT')
  effect,
  @JsonValue('GRID')
  grid,
}
