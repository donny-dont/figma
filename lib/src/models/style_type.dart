import 'package:json_annotation/json_annotation.dart';

/// The type of style
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
